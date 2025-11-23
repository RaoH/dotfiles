-- GitHub Actions helpers for inserting secrets and variables

local M = {}

-- Cache for performance
local cache = {
	secrets = nil,
	variables = nil,
	repo = nil,
	timestamp = 0,
}

local CACHE_TTL = 300 -- 5 minutes in seconds

-- Get repository name
local function get_repo()
	local now = os.time()
	if cache.repo and (now - cache.timestamp) < CACHE_TTL then
		return cache.repo
	end

	local result = vim.fn.system('gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null')
	if vim.v.shell_error == 0 then
		cache.repo = vim.trim(result)
		cache.timestamp = now
		return cache.repo
	end
	return nil
end

-- Fetch secrets
local function fetch_secrets()
	local now = os.time()
	if cache.secrets and (now - cache.timestamp) < CACHE_TTL then
		return cache.secrets
	end

	local repo = get_repo()
	if not repo then
		return {}
	end

	local result = vim.fn.system('gh api repos/' .. repo .. '/actions/secrets --jq ".secrets[].name" 2>/dev/null')
	if vim.v.shell_error == 0 then
		local secrets = {}
		for line in result:gmatch('[^\r\n]+') do
			if line ~= "" then
				table.insert(secrets, line)
			end
		end
		cache.secrets = secrets
		return secrets
	end
	return {}
end

-- Fetch variables
local function fetch_variables()
	local now = os.time()
	if cache.variables and (now - cache.timestamp) < CACHE_TTL then
		return cache.variables
	end

	local repo = get_repo()
	if not repo then
		return {}
	end

	local result = vim.fn.system('gh api repos/' .. repo .. '/actions/variables --jq ".variables[].name" 2>/dev/null')
	if vim.v.shell_error == 0 then
		local variables = {}
		for line in result:gmatch('[^\r\n]+') do
			if line ~= "" then
				table.insert(variables, line)
			end
		end
		cache.variables = variables
		return variables
	end
	return {}
end

-- Insert secret at cursor
function M.insert_secret()
	local secrets = fetch_secrets()
	if #secrets == 0 then
		vim.notify("No secrets found or failed to fetch secrets", vim.log.levels.WARN)
		return
	end

	vim.ui.select(secrets, {
		prompt = "Select secret:",
	}, function(choice)
		if choice then
			vim.api.nvim_put({ "secrets." .. choice }, "", false, true)
		end
	end)
end

-- Insert variable at cursor
function M.insert_variable()
	local variables = fetch_variables()
	if #variables == 0 then
		vim.notify("No variables found or failed to fetch variables", vim.log.levels.WARN)
		return
	end

	vim.ui.select(variables, {
		prompt = "Select variable:",
	}, function(choice)
		if choice then
			vim.api.nvim_put({ "vars." .. choice }, "", false, true)
		end
	end)
end

-- Clear cache
function M.clear_cache()
	cache = {
		secrets = nil,
		variables = nil,
		repo = nil,
		timestamp = 0,
	}
	vim.notify("GitHub Actions cache cleared", vim.log.levels.INFO)
end

return M
