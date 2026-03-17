local M = {}

M.opts = {}

function M.setup(user_opts)
    M.opts = vim.tbl_deep_extend("force", require("autolang.config").defaults, user_opts or {})

    if M.opts.auto_detect then
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("AutolangGroup", { clear = true }),
            callback = function()
                vim.defer_fn(require("autolang.core").detect_and_set, 100)
            end,
        })
    end

    -- Detection
    vim.api.nvim_create_user_command("AutolangDetect", function()
        -- Force execution even if auto_detect false, but only on valid buffer
        local old_val = M.opts.auto_detect
        M.opts.auto_detect = true
        require("autolang.core").detect_and_set()
        M.opts.auto_detect = old_val
    end, {})

    -- Toggle Commands
    vim.api.nvim_create_user_command("AutolangEnable", function()
        M.opts.auto_detect = true
        vim.notify("Autolang enabled", vim.log.levels.INFO)
    end, {})

    vim.api.nvim_create_user_command("AutolangDisable", function()
        M.opts.auto_detect = false
        vim.notify("Autolang disabled", vim.log.levels.INFO)
    end, {})
end

return M
