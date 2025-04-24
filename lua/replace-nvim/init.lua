local M = {}
local blocked = true

--- Runs after entering insert mode.
--- @param callback fun(): nil
--- @param delay number Delay in milliseconds
local function afterOPending(callback, delay)
	local keyListener
	keyListener = vim.on_key(function(key)
		vim.schedule(function ()
			if not blocked then
				if vim.api.nvim_get_mode().mode == "n" then
					vim.on_key(nil, keyListener)
					return
				end

				if vim.api.nvim_get_mode().mode == 'i' then
					blocked = true
					vim.on_key(nil, keyListener)
					vim.schedule(callback)
				end
			end
		end)
	end)
end

--- Replaces put to register operation while preserving registers.
--- @param delay number Delay in milliseconds
--- @return string Command mode for replacement.
local function replaceWriteToReg(delay)
	local originalValue = vim.fn.getreg('+', true)

	afterOPending(function ()
		local newValue = vim.fn.getreg('+', true)
		vim.fn.setreg("+", originalValue)

		vim.cmd("stopinsert")
		vim.cmd("normal! P")
		vim.fn.setreg("+", newValue)
	end, delay)

	return 'c'
end

--- Performs a replace operation.
--- @param delay number Delay in milliseconds
--- @return string Command mode for replacement.
local function replace(delay)
	afterOPending(function ()
		vim.cmd("stopinsert")
		vim.cmd("normal! P")
	end, delay)

	return '"_c'
end

--- Replaces text based on writeToReg flag.
--- @param delay number Delay in milliseconds
--- @param writeToReg? boolean Optional flag to write to register.
--- @return string Command mode for replacement.
function M.replace(delay, writeToReg)
	writeToReg = writeToReg or false
	blocked = false

	if writeToReg then
		return replaceWriteToReg(delay)
	else
		return replace(delay)
	end
end

--- Setup function for module configuration.
--- @param opts table Module options.
function M.setup(opts)
end

return M
