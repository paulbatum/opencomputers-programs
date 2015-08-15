local shell = require("shell")

local updateCommand = "wget -f https://raw.githubusercontent.com/paulbatum/opencomputers-programs/master/oppm.cfg /etc/oppm.cfg"
shell.execute(updateCommand)