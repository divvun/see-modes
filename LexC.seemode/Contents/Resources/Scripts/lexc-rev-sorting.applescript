-- see settings
on seescriptsettings()
	
	return {displayName:"LexC Reversed Stem Sorting", keyboardShortcut:"^~@b", inContextMenu:"yes"}
	
	-- Here is a overview of currently supported settings
	-- displayName: Name displayed in menus
	-- keyboardShortcut: A keyboard shortcut. alt=~, ctrl=^, shift=$, cmd=@
	-- inContextMenu: Should it appear in the ctrl-click menu?
	
end seescriptsettings


-- the actual script

tell application "SubEthaEdit"
	set savedClipboard to the clipboard
	if (length of selection = 0) then
		set the clipboard to contents of front document as text
	else
		set the clipboard to contents of selection as text
	end if
end tell

set UnixPath to POSIX path of ((path to me as text) & "::")
set ScriptName to "lexc-giella-style.py"
set ScriptPathName to UnixPath & ScriptName

-- the following is a command to call an external script, in this case python
-- notice the export preamble which is essential to make pbpaste work with
-- utf8 content.
set shellscriptString to "export DEVPATH=$(xcode-select -p); export LANG=en_US.UTF-8; pbpaste | $DEVPATH/usr/bin/python3 \"" & ScriptPathName & "\" --sort=revstem -"

set shellresult to do shell script shellscriptString without altering line endings

tell application "SubEthaEdit"
	set the clipboard to savedClipboard
	
	if (length of selection = 0) then
		set contents of front document to shellresult
	else
		set contents of selection of front document to shellresult as text
	end if
end tell
