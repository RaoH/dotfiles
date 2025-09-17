local M = {}

-- Helpers: defined early so all functions can use them

-- Expand brace patterns like {*.ts,*.tsx} into individual patterns
local function expand_braces(pattern)
	local patterns = {}
	local brace_content = pattern:match("{([^}]+)}")
	if not brace_content then
		return { pattern }
	end
	local prefix = pattern:match("^([^{]*)") or ""
	local suffix = pattern:match("}(.*)$") or ""
	for item in brace_content:gmatch("[^,]+") do
		item = item:gsub("^%s+", ""):gsub("%s+$", "")
		table.insert(patterns, prefix .. item .. suffix)
	end
	return patterns
end

-- Check if filename matches a glob pattern (matches against basename)
local function matches_glob(filename, pattern)
	-- Escape lua pattern characters EXCEPT * and ? (we translate those next)
	local escaped = pattern:gsub("([%^%$%(%)%%%.%[%]%+%-])", "%%%1")
	-- Convert glob wildcards to lua patterns
	escaped = escaped:gsub("%*", ".*"):gsub("%?", ".")
	-- Anchor
	escaped = "^" .. escaped .. "$"
	return filename:match(escaped) ~= nil
end

-- Find and parse prettier configuration
local function find_prettier_config(bufpath)
	local prettier_files = {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
		"package.json",
	}

	local function parse_json_config(filepath)
		local file = io.open(filepath, "r")
		if not file then
			return nil
		end
		local content = file:read("*all")
		file:close()

		local ok, parsed = pcall(vim.json.decode, content)
		if not ok then
			return nil
		end

		-- Handle package.json prettier field
		if filepath:match("package%.json$") then
			return parsed and parsed.prettier or nil
		end
		return parsed
	end

	-- Apply prettier config with override support
	local function apply_prettier_config(config, filename)
		if not config or type(config) ~= "table" then
			return nil
		end

		local settings = {}

		-- Global settings
		if config.tabWidth then
			settings.tabstop = config.tabWidth
			settings.shiftwidth = config.tabWidth
		end
		if config.useTabs ~= nil then
			settings.expandtab = not config.useTabs
		end

		-- Overrides (apply in order; later overrides win if multiple match)
		if type(config.overrides) == "table" then
			for _, override in ipairs(config.overrides) do
				if override and override.files and override.options then
					local files = override.files
					if type(files) == "string" then
						files = { files }
					end

					local matched = false
					for _, pattern in ipairs(files) do
						local patterns = expand_braces(pattern)
						for _, expanded in ipairs(patterns) do
							if matches_glob(filename, expanded) then
								if override.options.tabWidth then
									settings.tabstop = override.options.tabWidth
									settings.shiftwidth = override.options.tabWidth
								end
								if override.options.useTabs ~= nil then
									settings.expandtab = not override.options
									.useTabs
								end
								matched = true
								break -- no need to check more patterns for this override
							end
						end
						if matched then break end
					end
					-- continue to next override; later ones may override these settings
				end
			end
		end

		return next(settings) and settings or nil
	end

	local filename = vim.fs.basename(bufpath)

	for _, config_filename in ipairs(prettier_files) do
		local config_path = vim.fs.find(config_filename, {
			upward = true,
			stop = vim.env.HOME,
			path = vim.fs.dirname(bufpath),
		})[1]

		if config_path then
			local config = parse_json_config(config_path)
			if config then
				return apply_prettier_config(config, filename)
			end
		end
	end
	return nil
end

-- Find and parse editorconfig
local function find_editorconfig(bufpath)
	local editorconfig_path = vim.fs.find(".editorconfig", {
		upward = true,
		stop = vim.env.HOME,
		path = vim.fs.dirname(bufpath),
	})[1]

	if not editorconfig_path then
		return nil
	end

	local file = io.open(editorconfig_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	-- Enhanced editorconfig parser for indent settings
	local settings = {}
	local in_matching_section = false
	local filename = vim.fs.basename(bufpath)

	for line in content:gmatch("[^\r\n]+") do
		-- trim
		line = line:gsub("^%s+", ""):gsub("%s+$", "")
		-- skip comments and empty lines
		if line ~= "" and not line:match("^[#;]") then
			if line:match("^%[.-%]$") then
				local section = line:sub(2, -2)
				in_matching_section = false
				-- Expand brace patterns and check each one
				local patterns = expand_braces(section)
				for _, pattern in ipairs(patterns) do
					if pattern == "*" or matches_glob(filename, pattern) then
						in_matching_section = true
						break
					end
				end
			elseif in_matching_section and line:match("=") then
				local key, value = line:match("([^=]+)=([^=]+)")
				if key and value then
					key = key:gsub("%s+", "")
					value = value:gsub("%s+", "")

					if key == "indent_size" and tonumber(value) then
						settings.tabstop = tonumber(value)
						settings.shiftwidth = tonumber(value)
					elseif key == "tab_width" and tonumber(value) then
						settings.tabstop = tonumber(value)
					elseif key == "indent_style" then
						if value == "space" then
							settings.expandtab = true
						elseif value == "tab" then
							settings.expandtab = false
						end
					end
				end
			end
		end
	end

	return next(settings) and settings or nil
end

-- Apply indent settings to current buffer
local function apply_indent_settings(settings)
	if not settings then
		return
	end

	local bo = vim.bo
	if settings.tabstop then
		bo.tabstop = settings.tabstop
	end
	if settings.shiftwidth then
		bo.shiftwidth = settings.shiftwidth
	end
	if settings.expandtab ~= nil then
		bo.expandtab = settings.expandtab
	end
end

-- Main function to detect and apply project indent settings
function M.setup_project_indent()
	local bufpath = vim.api.nvim_buf_get_name(0)
	if bufpath == "" then
		return
	end

	-- Priority: EditorConfig > Prettier > defaults
	local editorconfig_settings = find_editorconfig(bufpath)
	local prettier_settings = find_prettier_config(bufpath)

	local final_settings = {}

	-- Start with prettier settings
	if prettier_settings then
		for key, value in pairs(prettier_settings) do
			final_settings[key] = value
		end
	end

	-- Override with editorconfig (higher priority)
	if editorconfig_settings then
		for key, value in pairs(editorconfig_settings) do
			final_settings[key] = value
		end
	end

	apply_indent_settings(final_settings)
end

-- Setup autocmd
local function setup_autocmd()
	local group = vim.api.nvim_create_augroup("ProjectIndent", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
		group = group,
		callback = M.setup_project_indent,
	})
end

-- Initialize
setup_autocmd()

return M
