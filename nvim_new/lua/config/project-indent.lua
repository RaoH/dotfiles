local M = {}

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
			return parsed.prettier
		end
		return parsed
	end

	for _, filename in ipairs(prettier_files) do
		local config_path = vim.fs.find(filename, {
			upward = true,
			stop = vim.env.HOME,
			path = vim.fs.dirname(bufpath),
		})[1]

		if config_path then
			local config = parse_json_config(config_path)
			if config then
				local settings = {}
				if config.tabWidth then
					settings.tabstop = config.tabWidth
					settings.shiftwidth = config.tabWidth
				end
				if config.useTabs ~= nil then
					settings.expandtab = not config.useTabs
				end
				return settings
			end
		end
	end
	return nil
end

-- Expand brace patterns like {*.ts,*.tsx} into individual patterns
local function expand_braces(pattern)
	local patterns = {}

	-- Check if pattern contains braces
	local brace_content = pattern:match("{([^}]+)}")
	if not brace_content then
		return { pattern }
	end

	-- Split comma-separated items inside braces
	local prefix = pattern:match("^([^{]*)")
	local suffix = pattern:match("}(.*)$")

	for item in brace_content:gmatch("[^,]+") do
		item = item:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
		table.insert(patterns, prefix .. item .. suffix)
	end

	return patterns
end

-- Check if filename matches a glob pattern
local function matches_glob(filename, pattern)
	-- Escape special lua pattern characters except * and ?
	local escaped = pattern:gsub("[%(%)%.%+%-%^%$%%]", "%%%1")
	-- Convert glob wildcards to lua patterns
	escaped = escaped:gsub("%*", ".*"):gsub("%?", ".")
	-- Anchor the pattern
	escaped = "^" .. escaped .. "$"

	return filename:match(escaped) ~= nil
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
		line = line:gsub("^%s+", ""):gsub("%s+$", "")

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

