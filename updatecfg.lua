local shell = require("shell")

local updateCommand = "wget https://raw.githubusercontent.com/paulbatum/opencomputers-programs/master/oppm.cfg /etc/oppm.cfg -f"
shell.execute(updateCommand)