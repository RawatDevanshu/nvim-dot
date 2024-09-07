return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "windwp/nvim-ts-autotag", -- Add this dependency
  },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- Add support for JSX/TSX
    autopairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
    autopairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))

    -- Add specific rules for JSX/TSX
    local jsx_filetypes = { "javascriptreact", "typescriptreact" }
    for _, filetype in ipairs(jsx_filetypes) do
      autopairs.add_rules({
        Rule("<", ">", filetype):with_pair(function(opts)
          return opts.line:match("^%s*<") ~= nil
        end),
        Rule("<", ">", filetype)
          :with_pair(function(opts)
            return opts.line:match("^%s*<") ~= nil
          end)
          :with_move(function(opts)
            return opts.char == ">"
          end)
          :with_cr(function(opts)
            return opts.line:match("^%s*<") ~= nil
          end),
      })
    end

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    -- import nvim-cmp plugin (completions plugin)
    local cmp = require("cmp")
    -- make autopairs and completion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Setup nvim-ts-autotag
    require("nvim-ts-autotag").setup()
  end,
}
