m = Map("rfid", "RFID") -- We want to edit the uci config file /etc/config/rfid

g = m:section(TypedSection, "global","Default Config/Status")
g.addremove=false
g.anonymous=true

channel = g:option(Value, "inchannel", "Channel for RFID reads")
channel.default="/it/bestmazzo/yun/rfid"

mode = g:option(ListValue, "sysmode", "System Mode")
mode:value("GLOBAL","Global")
mode:value("SINGLE", "Single")
mode:value("HYBRID", "Both Global and Single (Hybrid)")

gs=g:option(DummyValue, "status", "Global status")
gs:depends("sysmode","GLOBAL")
gs:depends("sysmode","HYBRID")

l=g:option(Flag, "learn", "Automatically add unknown TAGS")
l.rmempty=false

g:option(DynamicList, "onerror", "Actions to be executed when a error occurs")
g:option(DynamicList, "onadd", "Actions to be executed when a new TAG is added")
g:option(DynamicList, "in", "Actions to be executed when a TAG checks in")
g:option(DynamicList, "out", "Actions to be executed when a TAG checks out")

s = m:section(TypedSection, "rfid", "TAGS") -- Especially the "rfid"-sections
s.addremove = true -- Allow the user to create and remove tags
 
s:option(Value, "description", "Descriptive name", "the person name associated to given RFID")
ss=s:option(DummyValue, "status", "Global status")
ss:depends("sysmode","SINGLE")
ss:depends("sysmode","HYBRID")
s:option(Flag, "enableactions", "Enable actions on state change")

inorder = s:option(ListValue, "inorder", "When should I execute IN actions?")
inorder:value("BEFORE","Before global actions")
inorder:value("AFTER", "After global actions")
inorder:depends("enableactions", "1")

outorder = s:option(ListValue, "outorder", "When should I execute OUT actions?")
outorder:value("BEFORE","Before global actions")
outorder:value("AFTER", "After global actions")
outorder:depends("enableactions", "1")

ina = s:option(DynamicList, "in", "Actions to be executed when a TAG checks in")
ina:depends("enableactions", "1")

outa = s:option(DynamicList, "out", "Actions to be executed when a TAG checks out")
outa:depends("enableactions", "1")

a = m:section(TypedSection, "action", "ACTIONS") 
a.addremove = true
a:option(DynamicList, "actions", "Actions to be executed")


return m
