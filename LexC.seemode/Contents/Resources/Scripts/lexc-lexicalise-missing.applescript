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
	set the gtlangsdir to basedir & "/.."
	set the fstlang to do shell script "echo " & (basedir as text) & "| rev | cut -d'-' -f1 | rev"
end if

set the environment to do shell script "env"

-- debug dialog:
-- display dialog "The document name is: " & Docname & "
-- The basedir is: " & (basedir as text) & ".
-- The GTLANGS dir is: " & gtlangsdir & ".
-- The language is: " & fstlang & "
-- The environment is:
-- " & environment

-- the following is a command to call an external script, in this case python
-- notice the export preamble which is essential to make pbpaste work with
-- utf8 content.
-- DO THE ACTUAL LEXICALISATION:

-- Get path to python3 that works in sandbox
set DEVPATH to do shell script "xcode-select -p"
set PYTHON3 to DEVPATH & "/usr/bin/python3"

-- Get real home directory (not sandboxed container) using dscl
set realHome to do shell script "dscl . -read /Users/$(whoami) NFSHomeDirectory | awk '{print $2}'"

-- Use base64 command to encode clipboard, then construct JSON manually
set base64Input to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; pbpaste | base64"

-- Construct JSON manually (base64 is pure ASCII, safe for JSON)
set jsonData to "{\"operation\": \"analyze_missing\", \"lang\": \"" & fstlang & "\", \"gtlangs\": \"" & gtlangsdir & "\", \"docname\": \"" & Docname & "\", \"input_words_b64\": \"" & base64Input & "\"}"

-- Write JSON to clipboard
do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; echo " & quoted form of jsonData & " | pbcopy"

-- Launch helper app
set appPath to realHome & "/Applications/Divvun-SEE-helper.app"
set appDir to realHome & "/Applications/"
-- Check if helper app exists
try
	do shell script "test -d " & quoted form of appPath
on error
	display dialog "Divvun-SEE-helper.app er ikkje installert!

Appen må installerast i:
" & appDir & "

Meir info: https://github.com/divvun/divvun-see-helper." with title "Manglande helper-app" with icon caution buttons {"OK"} default button "OK"
	return
end try
-- Save the JSON we just wrote
set sentJSON to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; pbpaste"

-- Launch helper app
try
	do shell script "open " & quoted form of appPath
on error errMsg
	display dialog "Feil ved køyring av helper: " & errMsg with title "Feil" with icon caution
	return
end try

-- Poll for result (max 60 seconds)
delay 1
set maxAttempts to 118
set attempt to 0
set resultJSON to ""

repeat while attempt < maxAttempts
	delay 0.5
	set attempt to attempt + 1
	set clipboardNow to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; pbpaste"
	
	-- Check if clipboard changed and contains JSON response
	if clipboardNow is not equal to sentJSON and clipboardNow starts with "{\"status\"" then
		set resultJSON to clipboardNow
		exit repeat
	end if
end repeat

if resultJSON is "" then
	display dialog "Tidsavbrot: Fekk ikkje svar frå Divvun-SEE-helper. Sjekk ~/divvun-see-helper-debug.log for detaljar." with title "Feil" with icon caution
	return
end if

-- Parse response and combine with original words
-- Get original words from clipboard (before helper overwrote it)
set originalWords to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; printf '%s' " & quoted form of sentJSON & " | " & PYTHON3 & " -c 'import sys, json, base64; data=json.load(sys.stdin); print(base64.b64decode(data[\"input_words_b64\"]).decode(\"utf-8\"))'"

-- Parse response from helper
set shellresult to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; printf '%s' " & quoted form of resultJSON & " | " & PYTHON3 & " -c 'import sys, json; data=json.load(sys.stdin); status=data.get(\"status\"); output=data.get(\"output\", \"\"); print(output if status==\"success\" else \"ERROR: \" + data.get(\"message\", \"Unknown error\"))'"

-- If we got suggestions, combine them with untouched words
if shellresult does not start with "ERROR:" and shellresult is not "" then
	-- Use Python to extract lemmas from suggestions and filter original words
	set combinedResult to do shell script "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; " & PYTHON3 & " -c '
import sys, re

# Read suggestions and original words from arguments
suggestions = \"\"\"" & shellresult & "\"\"\"
original_words = \"\"\"" & originalWords & "\"\"\"

# Extract lemmas that got suggestions
suggested_lemmas = set()
for line in suggestions.strip().split(\"\\n\"):
    if line.strip() and not line.startswith(\"!\"):
        # Match pattern like \"lemma+Tag:form\" or \"lemma:lemma\"
        match = re.match(r\"^([^+:]+)\", line)
        if match:
            suggested_lemmas.add(match.group(1))

# Filter original words - keep only those without suggestions
untouched = []
for word in original_words.strip().split(\"\\n\"):
    word = word.strip()
    if word and word not in suggested_lemmas:
        untouched.append(word)

# Combine: suggestions first, then untouched words
result = suggestions.strip()
if untouched:
    if result:
        result += \"\\n\"
    result += \"\\n\".join(untouched)

# Clean up extra newlines - max 2 consecutive newlines
result = re.sub(r\"\\n{3,}\", \"\\n\\n\", result)

# Ensure exactly one trailing newline
if result and not result.endswith(\"\\n\"):
    result += \"\\n\"

print(result, end=\"\")
'"
	set shellresult to combinedResult
end if

-- Ensure exactly one trailing newline
if shellresult does not end with linefeed then
	set shellresult to shellresult & linefeed
else if shellresult ends with (linefeed & linefeed) then
	-- Remove extra trailing newlines
	repeat while shellresult ends with (linefeed & linefeed)
		set shellresult to text 1 thru -2 of shellresult
	end repeat
end if

-- restore clipboard, and update the document with the output of the shellscript:
tell application "SubEthaEdit"
	set the clipboard to savedClipboard
	
	if (length of selection = 0) then
		set contents of front document to shellresult
	else
		set contents of selection of front document to shellresult as text
	end if
end tell
