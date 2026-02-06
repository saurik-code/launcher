--
-- AutoCAD 2026 Launcher
-- Source file for compilation
-- 
-- Compile with: osacompile -o "AutoCAD 2026 Launcher.app" launcher.applescript
--

on run
	set configFile to "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
	
	-- Load password from config
	try
		set configContent to do shell script "cat " & quoted form of configFile & " 2>/dev/null | grep PASSWORD | cut -d'=' -f2"
		set savedPassword to configContent
	on error
		set savedPassword to ""
	end try
	
	-- Check server processes
	try
		set lmgrdCount to (do shell script "ps aux | grep [l]mgrd | wc -l | tr -d ' '") as integer
	on error
		set lmgrdCount to 0
	end try
	
	try
		set adskflexCount to (do shell script "ps aux | grep [a]dskflex | wc -l | tr -d ' '") as integer
	on error
		set adskflexCount to 0
	end try
	
	-- Check if duplicate processes exist
	if lmgrdCount > 1 then
		display notification "Cleaning duplicate server processes..." with title "AutoCAD Launcher"
		try
			if savedPassword is not "" then
				do shell script "echo " & quoted form of savedPassword & " | sudo -S pkill -9 -x lmgrd; echo " & quoted form of savedPassword & " | sudo -S pkill -9 -x adskflex" with administrator privileges
			else
				do shell script "sudo pkill -9 -x lmgrd; sudo pkill -9 -x adskflex" with administrator privileges
			end if
		end try
		delay 2
		set lmgrdCount to 0
	end if
	
	-- Check server health
	if lmgrdCount is 0 or adskflexCount is 0 then
		display notification "Starting license server..." with title "AutoCAD Launcher"
		
		-- Kill any stuck processes
		try
			if savedPassword is not "" then
				do shell script "echo " & quoted form of savedPassword & " | sudo -S pkill -9 -x lmgrd; echo " & quoted form of savedPassword & " | sudo -S pkill -9 -x adskflex" with administrator privileges
			else
				display dialog "Enter your Mac password to start license server:" default answer "" with hidden answer buttons {"Cancel", "OK"} default button "OK"
				set userPass to text returned of result
				if userPass is not "" then
					do shell script "echo " & quoted form of userPass & " | sudo -S pkill -9 -x lmgrd; echo " & quoted form of userPass & " | sudo -S pkill -9 -x adskflex" with administrator privileges
					try
						do shell script "echo 'PASSWORD='" & quoted form of userPass & " > " & quoted form of configFile & "; chmod 600 " & quoted form of configFile
					end try
				end if
			end if
		end try
		
		delay 1
		
		-- Start server
		try
			if savedPassword is not "" then
				do shell script "cd /usr/local/flexnetserver && echo " & quoted form of savedPassword & " | sudo -S ./lmgrd -c ./license.dat > /dev/null 2>&1 &"
			else
				display dialog "Enter your Mac password:" default answer "" with hidden answer buttons {"Cancel", "OK"} default button "OK"
				set userPass to text returned of result
				if userPass is not "" then
					do shell script "cd /usr/local/flexnetserver && echo " & quoted form of userPass & " | sudo -S ./lmgrd -c ./license.dat > /dev/null 2>&1 &"
					try
						do shell script "echo 'PASSWORD='" & quoted form of userPass & " > " & quoted form of configFile & "; chmod 600 " & quoted form of configFile
					end try
				end if
			end if
		end try
		
		delay 4
		
		try
			set checkLMGRD to (do shell script "ps aux | grep [l]mgrd | wc -l | tr -d ' '") as integer
			if checkLMGRD is 0 then
				display alert "Error" message "License server failed to start. Please try again." buttons {"OK"}
				return
			end if
		on error
			display alert "Error" message "License server failed to start. Please try again." buttons {"OK"}
			return
		end try
		
		display notification "License server running" with title "AutoCAD Launcher"
	else
		display notification "License server already running" with title "AutoCAD Launcher"
	end if
	
	do shell script "launchctl setenv LM_LICENSE_FILE '27080@127.0.0.1'; launchctl setenv ADSKFLEX_LICENSE_FILE '27080@127.0.0.1'"
	
	display notification "Launching AutoCAD 2026..." with title "AutoCAD Launcher"
	
	try
		tell application "AutoCAD 2026"
			activate
		end tell
	on error
		open "/Applications/Autodesk/AutoCAD 2026/AutoCAD 2026.app"
	end try
end run
