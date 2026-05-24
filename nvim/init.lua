-- ####################################
-- Basic config
-- ####################################
-- Mostrar nº de linea relativos
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.swapfile = false

-- permitir deshacer aunque se haya cerrado y reabierto el archivo
vim.opt.undofile = true

-- Para el split entre ventanas
vim.opt.splitbelow = true
vim.opt.splitright = true

-- tab equivale a 4 espacios
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- set to 0 to default to tabstop value

-- confirmar guardado al salir
vim.o.confirm = true

-- Dejar una columna a la izquierda del nº de linea para mostrar info (errores, warnings) 
vim.o.signcolumn = 'yes:1'




-- ####################################
-- plugins (nvim >=0.12)
-- ####################################
vim.pack.add {
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/catppuccin/nvim',			-- colorscheme
	'https://github.com/mason-org/mason.nvim',
}

-- set colorscheme
vim.cmd.colorscheme('catppuccin')

-- nvim trae por defecto un LSP client, pero para que funcione necesitas un LSP server para cada lenguaje que quieras
-- Hay que instalar el LSP server que quieras usar y se puede hacer con:
-- brew install 'lsp_server_name'
-- o también se puede usar el plugin de nvim "mason" que es para gestionar los LSP servers (:Mason en nvim)
-- Cualquiera de las 2 formas es válida

-- (https://www.youtube.com/watch?v=yI9R13h9IEE)
-- Voy a usar mason para gestionar los LSP servers que instalo para nvim
require("mason").setup()
-- Habilitar los LSP servers que queremos usar (primero instalarlos)
vim.lsp.enable({"gopls"})





-- ####################################
-- key maps
-- ####################################
-- leader key
vim.g.mapleader = ","
-- leader + w --> save (write) file
vim.keymap.set('n', '<leader>w', ':write<CR>')
-- leader + w --> quit file
vim.keymap.set('n', '<leader>q', ':quit<CR>')
-- leader + y --> copy to clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')


-- LSP keymaps
-- g + l --> diagnostic of errors & warnings of LSP (the ones that supports it)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
-- leader + l + f --> format code
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)


-- LSP customs
-- autocompletion
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]
-- bordes redondeados y que no se muestren tantos elementos en el recuadro de autocompletar
vim.o.pumheight = 5
vim.o.pumborder = 'rounded'
