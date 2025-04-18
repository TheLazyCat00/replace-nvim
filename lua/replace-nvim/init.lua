local M = {}

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

function M.replace()
	local originalValue = vim.fn.getreg('+', true)
	afterOPending(function ()
		local newValue = vim.fn.getreg('+', true)
		vim.fn.setreg("+", originalValue)

		vim.cmd("stopinsert")
		vim.cmd("normal! hp")
		vim.fn.setreg("+", newValue)
	end, 10)
	return 'c'
end

function M.setup(opts)
end

return M
