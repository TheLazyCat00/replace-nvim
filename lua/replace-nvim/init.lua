local M = {}
local blocked = true

--- Runs after entering insert mode.
--- @param callback fun(): nil
local function afterOPending(callback)
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
--- @return string Command mode for replacement.
local function replaceWriteToReg()
	local originalValue = vim.fn.getreg('+', true)

	afterOPending(function ()
		local newValue = vim.fn.getreg('+', true)
		vim.fn.setreg("+", originalValue)

		vim.cmd("stopinsert")
		vim.cmd("normal! P")
		vim.fn.setreg("+", newValue)
	end)

	return 'c'
end

--- Performs a replace operation.
--- @return string Command mode for replacement.
local function replace()
	afterOPending(function ()
		vim.cmd("stopinsert")
		vim.cmd("normal! P")
	end)

	return '"_c'
end

--- Replaces text based on writeToReg flag.
--- @param writeToReg? boolean Optional flag to write to register.
--- @return string Command mode for replacement.
function M.replace(writeToReg)
	writeToReg = writeToReg or false
	blocked = false

	if writeToReg then
		return replaceWriteToReg()
	else
		return replace()
	end
end

--- Setup function for module configuration.
--- @param opts table Module options.
function M.setup(opts)
end

return M
