local status, lspstatus = pcall(require, 'lsp-status')
if not status then
    return
end

lspstatus.register_progress()
