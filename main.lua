local GuiFramework = {}

local TYPES = tableHelper.enum({
    "MessageBox",
    "CustomMessageBox",
    "InputDialog",
    "PasswordDialog",
    "ListBox"
})

GuiFramework.nameCache = {}
GuiFramework.typeCache = {}
GuiFramework.callbackCache = {}
GuiFramework.returnCache = {}
GuiFramework.parametersCache = {}

function GuiFramework.getGuiId(name)
    local id = guiHelper.ID[name]
    if id ~= nil then
        return id
    end

    table.insert(guiHelper.names, name)
    guiHelper.ID = tableHelper.enum(guiHelper.names)
    return guiHelper.ID[name]
end

--pid, name, label
function GuiFramework.MessageBox(opt)
    local id = GuiFramework.getGuiId(opt.name)
    GuiFramework.nameCache[id] = opt.name
    GuiFramework.typeCache[id] = TYPES.MessageBox

    local label = opt.label or ''

    tes3mp.MessageBox( opt.pid, id, label )
end

--pid, name, buttons, [label, callback, returnValues, parameters]
function GuiFramework.CustomMessageBox(opt)
    local id = GuiFramework.getGuiId(opt.name)
    GuiFramework.nameCache[id] = opt.name
    GuiFramework.typeCache[id] = TYPES.CustomMessageBox
    GuiFramework.callbackCache[id] = opt.callback

    GuiFramework.returnCache[opt.pid] = opt.returnValues or opt.buttons
    GuiFramework.parametersCache[opt.pid] = opt.parameters

    local label = opt.label or ''

    tes3mp.CustomMessageBox( opt.pid, id, label, table.concat(opt.buttons, ";") )
end

--pid, name, [label, note, callback, parameters]
function GuiFramework.InputDialog(opt)
    local id = GuiFramework.getGuiId(opt.name)
    GuiFramework.nameCache[id] = opt.name
    GuiFramework.typeCache[id] = TYPES.InputDialog
    GuiFramework.callbackCache[id] = opt.callback

    GuiFramework.parametersCache[opt.pid] = opt.parameters

    local note = opt.note or ''
    local label = opt.label or ''

    tes3mp.InputDialog( opt.pid, id, label, note )
end

--pid, name, [label, note, callback, parameters]
function GuiFramework.PasswordDialog(opt)
    local id = GuiFramework.getGuiId(opt.name)
    GuiFramework.nameCache[id] = opt.name
    GuiFramework.typeCache[id] = TYPES.PasswordDialog
    GuiFramework.callbackCache[id] = opt.callback

    GuiFramework.parametersCache[opt.pid] = opt.parameters

    local note = opt.note or ''
    local label = opt.label or ''

    tes3mp.PasswordDialog( opt.pid, id, label, note )
end

--pid, name, rows, [label, callback, returnValues, parameters]
function GuiFramework.ListBox(opt)
    local id = GuiFramework.getGuiId(opt.name)
    GuiFramework.nameCache[id] = opt.name
    GuiFramework.typeCache[id] = TYPES.ListBox
    GuiFramework.callbackCache[id] = opt.callback

    GuiFramework.returnCache[opt.pid] = opt.returnValues or opt.rows
    GuiFramework.parametersCache[opt.pid] = opt.parameters

    local label = opt.label or ''
    local items = table.concat(opt.rows,"\n")

    tes3mp.ListBox( opt.pid, id, label, items )
end

function GuiFramework.OnGUIAction(evenStatus, pid, id, data)
    local callback = GuiFramework.callbackCache[id]

    if callback ~= nil then
        local name = GuiFramework.nameCache[id]
        local type = GuiFramework.typeCache[id]

        if type == TYPES.CustomMessageBox then
            local input = tonumber(data) + 1
            local value = GuiFramework.returnCache[pid][input]

            callback(pid, name, input, value, GuiFramework.parametersCache[pid])

        elseif type == TYPES.InputDialog then
            callback(pid, name, data, GuiFramework.parametersCache[pid])

        elseif type == TYPES.PasswordDialog then
            callback(pid, name, data, GuiFramework.parametersCache[pid])

        elseif type == TYPES.ListBox then
            local input = tonumber(data) + 1
            local value = GuiFramework.returnCache[pid][input]

            callback(pid, name, input, value, GuiFramework.parametersCache[pid])
        end
    end
end

customEventHooks.registerHandler("OnGUIAction", GuiFramework.OnGUIAction)

return GuiFramework