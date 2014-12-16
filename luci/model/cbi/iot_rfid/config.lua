m = Map("rfid", "RFID") -- We want to edit the uci config file /etc/config/rfid

g = m:section(TypedSection, "global","Default Config/Status")
g.addremove=false
g.anonymous=true

channel = g:option(Value, "inchannel", "Channel for RFID reads")
channel.default="/it/bestmazzo/yun/rfid"

mode = g:option(ListValue, "sysmode", "System Mode")
mode:value("GLOBAL","Global")
mode:value("SINGLE", "Single")

gs=g:option(DummyValue, "status", "Global status")
gs:depends("sysmode","GLOBAL")

l=g:option(Flag, "learn", "Automatically add unknown TAGS")
l.rmempty=false

g:option(DynamicList, "onerror", "Actions to be executed when a error occurs")
g:option(DynamicList, "onadd", "Actions to be executed when a new TAG is added")
g:option(DynamicList, "in", "Actions to be executed when a TAG checks in")
g:option(DynamicList, "out", "Actions to be executed when a TAG checks out")


s = m:section(TypedSection, "rfid", "TAGS") -- Especially the "rfid"-sections
s.addremove = true -- Allow the user to create and remove tags
 
s:option(Value, "description", "Descriptive name", "the person name associated to given RFID")
s:option(DynamicList, "in", "Actions to be executed when a TAG checks in")
s:option(DynamicList, "out", "Actions to be executed when a TAG checks out")

return m
