(module config.init
  {autoload {core aniseed.core
             nvim aniseed.nvim
             util config.util
             str aniseed.string}})

;generic mapping leaders configuration

;(nvim.set_keymap :n :<space> :<nop> {:noremap true})

(set nvim.g.mapleader ".")
(set nvim.g.maplocalleader ",")

;don't wrap lines
;(nvim.ex.set :nowrap)

;sets a nvim global options
(let [options
      {;settings needed for compe autocompletion
       :completeopt "menuone,noselect"
       ;case insensitive search
       :ignorecase true
       ;smart search case
       :smartcase true
       ;shared clipboard with linux
       :clipboard "unnamedplus"}]
  (each [option value (pairs options)]
    (core.assoc nvim.o option value)))

;import plugin.fnl
(require :config.plugin)

(set nvim.g.auto_save 1)
(set nvim.g.auto_save_silent 1)

(nvim.ex.set :undofile)
(set nvim.undodir "~/.local/share/nvim/undo/")
(set nvim.undolevels 100000)
(set nvim.undoreload 100000)

(set nvim.tabstop 2)
(set nvim.softtabstop 2)
(nvim.ex.set :expandtab)

(nvim.set_keymap :n :<leader>fh ":lua require('telescope.builtin').help_tags()<cr>" {:noremap true})

(nvim.set_keymap :n "<M-,>" ":bprev<cr>" {})

(nvim.set_keymap :n "<M-.>" ":bnext<cr>" {})
(nvim.set_keymap :n "<M-x>" ":bdelete<cr>" {})

(nvim.set_keymap :n "<M-r>" ":Telescope command_history<cr>" {})
(nvim.set_keymap :n "<M-z>" ":Telescope buffers<cr>" {})
(nvim.set_keymap :n "<M-n>" ":Telescope find_files<cr>" {})
(nvim.set_keymap :n "<M-f>" ":Telescope live_grep<cr>" {})
(nvim.set_keymap :n "<M-a>" ":Telescope commands<cr>" {})
(nvim.set_keymap :n "<M-;>" ":Telescope registers<cr>" {})

(nvim.set_keymap :n "<M-u>" ":lua require('telescope.builtin').lsp_references()<cr>" {})

(nvim.set_keymap :n "<M-q>" ":qa<cr>" {})

(nvim.set_keymap :n "<M-v>" ":UndotreeShow<cr>:UndotreeFocus<cr>" {})

(nvim.set_keymap :n "<M-s>" "<Plug>(sexp_flow_to_prev_open)" {})
(nvim.set_keymap :n "<M-d>" "<Plug>(sexp_flow_to_next_open)" {})
(nvim.set_keymap :n "<M-i>" "<Plug>(sexp_capture_next_element)" {})
(nvim.set_keymap :n "<M-m>" "<Plug>(sexp_emit_tail_element)" {})

