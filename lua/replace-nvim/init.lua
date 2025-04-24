local M = {}

--- Runs a callback after entering insert mode.
--- @param callback fun(): nil
--- @param delay number Delay in milliseconds
local function afterOPending(callback, delay)
	local function checkMode()
		if vim.fn.mode(1) == 'i' then
			vim.schedule(callback)
		else
			vim.defer_fn(checkMode, delay)
		end
	end

	checkMode()
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
