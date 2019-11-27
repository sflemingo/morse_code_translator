#!/bin/bash
morse2englishJSON=morse_to_english.json
english2morseJSON=english_to_morse.json

# prompts for a string in morse code
# then prints it in english
morse2english() {
	# prompt for the input
	echo 'use . for a dot, - for a dash, / for a space, and space to seperate characters'
	read -p 'Enter morse code: ' inputStr
	local outputStr=""
	# split the input by spaces and loop through
	read -ra strParts <<< "$inputStr"
	for i in "${strParts[@]}"; do
		# to use jq with the json, we need to replace the characters used
		local char=$(echo $i | tr "." o | tr "-" a | tr "/" s)
		# append the english translation to the output string
		local outputStr=${outputStr}$(cat "$morse2englishJSON" | jq ."${char}" -r)
	done
	# print the output
	echo $outputStr
}

# prompts for a string in english
# then prints it in morse code
english2morse() {
	# prompt for the input
	echo 'allowed characters a-z and spaces'
	read -p 'Enter english phrase: ' inputStr
	local outputStr=""
	# loop through each character in the input
	for (( i=0; i<${#inputStr}; i++ )); do
		local char="${inputStr:$i:1}"
		# append / if the character is a space
		if [ "${inputStr:$i:1}" == " " ]; then
			local outputStr="${outputStr} /"
		else
			# append the morse translation to the output string
			local outputStr="${outputStr} "$(cat "$english2morseJSON" | jq ."${char,,}" -r)
		fi
	done
	# print the output
	echo $outputStr
}

# prompt user for conversion type
read -p "Enter 1 for morse to english; Enter 2 for english to morse: " cType
echo

if [ "$cType" == "1" ]; then
	morse2english
elif [ "$cType" == "2" ]; then
	english2morse
else
	echo "Invalid Input!"
fi

