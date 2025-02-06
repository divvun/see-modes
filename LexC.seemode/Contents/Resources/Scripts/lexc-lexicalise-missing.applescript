-- see settings
on seescriptsettings()
	
	return {displayName:"Lexicalise missing", keyboardShortcut:"^~@m", inContextMenu:"yes"}
	
	-- Here is an overview of currently supported settings
	-- displayName: Name displayed in menus
	-- keyboardShortcut: A keyboard shortcut. alt=~, ctrl=^, shift=$, cmd=@
	-- inContextMenu: Should it appear in the ctrl-click menu?
	
end seescriptsettings


-- the actual script

-- save clipboard, so we can restore it:
tell application "SubEthaEdit"
	set savedClipboard to the clipboard
	if (length of selection = 0) then
		set the clipboard to contents of front document as text
	else
		set the clipboard to contents of selection as text
	end if
end tell

-- define the pathname to the python script:
set UnixPath to POSIX path of ((path to me as text) & "::")
set ScriptName to "missing.py"
set ScriptPathName to UnixPath & ScriptName

-- define the path to the language folder
tell application "SubEthaEdit"
	set Docpath to file of front document
	set Docname to name of front document
end tell

-- If the document has never been saved, then ask for the language:
if Docpath is missing value then
	display dialog "Du må lagra dokumentet ein stad i 'src/' i språket du arbeider med!" with title "Dokumentet må lagrast" with icon caution
	return
else
	-- but if it has been saved, identify the repo root dir and the language code based on the full path of the document:
	set UnixPath to POSIX path of (Docpath as text)
	set the basedir to do shell script "sti=" & (UnixPath as text) & "; echo \"${sti%/src*}\""
	set the fstlang to do shell script "echo " & (basedir as text) & "| rev | cut -d'-' -f1 | rev"
end if

-- debug dialog:
display dialog "The document name is: " & Docname & "
The basedir is: " & (basedir as text) & ".
The language is: " & fstlang

-- the following is a command to call an external script, in this case python
-- notice the export preamble which is essential to make pbpaste work with
-- utf8 content.
-- DO THE ACTUAL LEXICALISATION:
set shellscriptString to "export DEVPATH=$(xcode-select -p); export LANG=en_US.UTF-8; pbpaste | $DEVPATH/usr/bin/python3 \"" & ScriptPathName & "\" -l " & fstlang & " -c " & Docname

set shellresult to do shell script shellscriptString without altering line endings

-- restore clipboard, and update the document with the output of the shellscript:
tell application "SubEthaEdit"
	set the clipboard to savedClipboard
	
	if (length of selection = 0) then
		set contents of front document to shellresult
	else
		set contents of selection of front document to shellresult as text
	end if
end tell
