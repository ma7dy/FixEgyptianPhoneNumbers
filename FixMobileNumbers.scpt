(*script done with content from

http://www.mactech.com/articles/mactech/Vol.21/21.10/ScriptingAddressBook/index.html
http://vocaro.com/trevor/software/applescript/Remove%20Duplicate%20Phone%20Numbers.zip
http://www.apple.com/applescript/sbrt/sbrt-06.html

Script Based on these specs:

http://www.grupoice.com/esp/temas/camp/2_8_dig/index.htm

Christian Sabor’o
christian@saborio.org
http://www.grumpytico.com

*)

display dialog "Warning: Be sure to back up your Address Book database first!" & return & return & "Do you still want to continue?"

tell application "Address Book"
	set contactlist to selection
	display dialog ("Converting " & (count of contactlist) & " contacts.")
	
	repeat with i from 1 to the count of contactlist
		set currentPerson to item i of contactlist
		set phonePropertes to properties of phones of currentPerson
		repeat with i from 1 to the count of phonePropertes
			set currentItem to item i of phonePropertes
			set oldLabel to label of currentItem
			set oldPhone to value of currentItem
			
			set newPhone to my checkNumber(oldPhone, oldLabel)
			if not (newPhone = oldPhone) then
				--display dialog "changing: " & oldPhone & " -> " & newPhone
				log "changing: " & oldPhone & " -> " & newPhone
				--delete (phones of currentPerson whose id is id of currentItem)
				make new phone at end of phones of currentPerson with properties {label:oldLabel & "+2", value:newPhone}
			end if
		end repeat
	end repeat
	
	save
	
	display dialog "All done, enjoy!"
end tell

--subroutines
(*Cases for Changing Phone Numbers:

*)

on checkNumber(phoneNumber, phoneLabel)
	
	set trimmedPhone to replace_chars(phoneNumber, " ", "")
	set trimmedPhone to replace_chars(trimmedPhone, "(", "")
	set trimmedPhone to replace_chars(trimmedPhone, ")", "")
	set trimmedPhone to replace_chars(trimmedPhone, "-", "")
	
	if trimmedPhone begins with "+2" then
		set trimmedPhone to rightString(trimmedPhone, "+2")
	end if
	
	-- display dialog trimmedPhone
	
	if (length of trimmedPhone = 10) then
		if trimmedPhone begins with "01" then --big assumption here, if it starts with 01, it's a mobile.
			if trimmedPhone begins with "012" then
				set trimmedPhone to "+20122" & rightString(trimmedPhone, "012")
			else if trimmedPhone begins with "017" then
				set trimmedPhone to "+20127" & rightString(trimmedPhone, "017")
			else if trimmedPhone begins with "018" then
				set trimmedPhone to "+20128" & rightString(trimmedPhone, "018")
			else if trimmedPhone begins with "0150" then
				set trimmedPhone to "+20120" & rightString(trimmedPhone, "0150")
			else if trimmedPhone begins with "011" then
				set trimmedPhone to "+20111" & rightString(trimmedPhone, "011")
			else if trimmedPhone begins with "014" then
				set trimmedPhone to "+20114" & rightString(trimmedPhone, "014")
			else if trimmedPhone begins with "0152" then
				set trimmedPhone to "+20112" & rightString(trimmedPhone, "0152")
			else if trimmedPhone begins with "010" then
				set trimmedPhone to "+20100" & rightString(trimmedPhone, "010")
			else if trimmedPhone begins with "016" then
				set trimmedPhone to "+20106" & rightString(trimmedPhone, "016")
			else if trimmedPhone begins with "019" then
				set trimmedPhone to "+20109" & rightString(trimmedPhone, "019")
			else if trimmedPhone begins with "0151" then
				set trimmedPhone to "+20101" & rightString(trimmedPhone, "0151")
			end if
		else
			set trimmedPhone to phoneNumber --ignore any modifications made 
		end if
		
	else
		if (length of trimmedPhone = 11) and trimmedPhone does not start with "+" then
			log "--"
		else
			set trimmedPhone to phoneNumber --ignore any modifications made
		end if
	end if
	return trimmedPhone
end checkNumber

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars


--c--   rightString(str, del)
--d--   Return the text to the right of a delimiter (full string if not found).
--a--   str : string -- the string to search
--a--   del : string -- the delimiter to use
--r--   string
--x--   rightString("ab:ca:bc", ":") --> "ca:bc"
--u--   ljr (http://applescript.bratis-lover.net/library/string/)
on rightString(str, del)
	local str, del, oldTIDs
	set oldTIDs to AppleScript's text item delimiters
	try
		set str to str as string
		if str does not contain del then return str
		set AppleScript's text item delimiters to del
		set str to str's text items 2 thru -1 as string
		set AppleScript's text item delimiters to oldTIDs
		return str
	on error eMsg number eNum
		set AppleScript's text item delimiters to oldTIDs
		error "Can't rightString: " & eMsg number eNum
	end try
end rightString
