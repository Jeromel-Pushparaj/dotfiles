-- ~/.config/nvim/lua/lsp/jdtls.lua
local M = {}

function M.setup(on_attach, capabilities)
  local jdtls = require('jdtls')

  -- determine project root (you can add more root markers)
  local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
  local root_dir = require('jdtls.setup').find_root(root_markers) or vim.fn.getcwd()

  -- workspace directory (for jdtls) – you can customise the path
  local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
  local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls-workspace/' .. project_name

  -- command to launch jdtls
  local cmd = {
    'jdtls',  -- assume jdtls is in your PATH; else use full path
    '--directory', workspace_dir,
    -- you might need additional flags as per jdtls installation
    -- e.g., '-data', workspace_dir
  }

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.Assume.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        configuration = {
          runtimes = {
            {
              name = "JavaSE-17",
              path = "/usr/lib/jvm/java-17",  -- adjust path on your system
            },
            {
              name = "JavaSE-11",
              path = "/usr/lib/jvm/java-11",
            },
          },
        },
      },
    },
    init_options = {
      bundles = {},  -- for debug/test bundles if you install them
    },
  }

  -- Start or attach the jdtls server
  jdtls.start_or_attach(config)
end

return M


