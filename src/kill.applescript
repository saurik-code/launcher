--
-- Kill AutoCAD
-- Source file for compilation
--
-- Compile with: osacompile -o "Kill AutoCAD.app" kill.applescript
--

on run
	set configFile to "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
	
	try
		do shell script "mkdir -p $(dirname " & quoted form of configFile & ")"
	end try
	
	try
		set configContent to do shell script "cat " & quoted form of configFile & " 2>/dev/null | grep PASSWORD | cut -d'=' -f2"
		set savedPassword to configContent
	on error
		set savedPassword to ""
	end try
	
	try
		set autoCADCount to (do shell script "ps aux | grep [M]acOS/AutoCAD | grep -v Thumbnailer | wc -l | tr -d ' '") as integer
	on error
		set autoCADCount to 0
	end try
	
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
	
	set totalCount to autoCADCount + lmgrdCount + adskflexCount
	
	if totalCount is 0 then
		display alert "Info" message "No processes running." buttons {"OK"}
		return
	end if
	
	set theMessage to "Force quit AutoCAD and License Server." & return & return & "Running processes:" & return & return & "• AutoCAD: " & autoCADCount & return & "• License Server: " & lmgrdCount & return & "• Vendor Daemon: " & adskflexCount & return & return & "Total: " & totalCount
	
	display dialog theMessage buttons {"Cancel", "Continue"} default button "Continue" with icon caution
	
	if button returned of result is "Cancel" then
		return
	end if
	
	display notification "Killing processes..." with title "Kill AutoCAD"
	
	set killSuccess to false
	
	if savedPassword is not "" then
		try
			do shell script "echo " & quoted form of savedPassword & " | sudo -S bash -c 'pkill -9 -f MacOS/AutoCAD; pkill -9 -i autocad; sleep 0.3; for i in 1 2 3; do pkill -9 -x adskflex; pkill -9 -x lmgrd; sleep 0.3; done; pkill -9 -f launch_autocad_server.sh; launchctl unload /Library/LaunchDaemons/com.flexnet.lmgrd.plist 2>/dev/null'" with administrator privileges
			
			delay 2
			
			set checkAutoCAD to (do shell script "ps aux | grep [M]acOS/AutoCAD | grep -v Thumbnailer | wc -l | tr -d ' '") as integer
			set checkLMGRD to (do shell script "ps aux | grep [l]mgrd | wc -l | tr -d ' '") as integer
			set checkADSK to (do shell script "ps aux | grep [a]dskflex | wc -l | tr -d ' '") as integer
			
			if checkAutoCAD is 0 and checkLMGRD is 0 and checkADSK is 0 then
				set killSuccess to true
			end if
		end try
	end if
	
	if not killSuccess then
		try
			set dialogResult to display dialog "Invalid password." & return & return & "Enter Mac password:" default answer "" with hidden answer buttons {"Cancel", "OK"} default button "OK"
			
			set newPassword to text returned of dialogResult
			
			if newPassword is "" then
				return
			end if
			
			try
				do shell script "echo " & quoted form of newPassword & " | sudo -S echo test" with administrator privileges
				
				do shell script "echo " & quoted form of newPassword & " | sudo -S bash -c 'pkill -9 -f MacOS/AutoCAD; pkill -9 -i autocad; sleep 0.3; for i in 1 2 3; do pkill -9 -x adskflex; pkill -9 -x lmgrd; sleep 0.3; done; pkill -9 -f launch_autocad_server.sh; launchctl unload /Library/LaunchDaemons/com.flexnet.lmgrd.plist 2>/dev/null'" with administrator privileges
				
				delay 2
				
				set checkAutoCAD to (do shell script "ps aux | grep [M]acOS/AutoCAD | grep -v Thumbnailer | wc -l | tr -d ' '") as integer
				set checkLMGRD to (do shell script "ps aux | grep [l]mgrd | wc -l | tr -d ' '") as integer
				set checkADSK to (do shell script "ps aux | grep [a]dskflex | wc -l | tr -d ' '") as integer
				
				if checkAutoCAD is 0 and checkLMGRD is 0 and checkADSK is 0 then
					try
						do shell script "echo 'PASSWORD='" & quoted form of newPassword & " > " & quoted form of configFile & "; chmod 600 " & quoted form of configFile
						set killSuccess to true
						display notification "New password saved" with title "Kill AutoCAD"
					on error
						set killSuccess to true
					end try
				else
					display alert "Failed" message "Could not kill all processes." buttons {"OK"}
					return
				end if
				
			on error
				display alert "Wrong Password" message "Invalid password." buttons {"OK"}
				return
			end try
			
		on error
			return
		end try
	end if
	
	if killSuccess then
		display notification "All processes killed" with title "Kill AutoCAD - SUCCESS"
		display alert "SUCCESS" message "Processes terminated." & return & return & "Wait 3 seconds then launch with Launcher." buttons {"OK"}
	else
		display alert "Failed" message "Could not kill processes. Restart Mac." buttons {"OK"}
	end if
end run
