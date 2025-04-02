#A simple and fast convert to url & html in terminal via pipe.
#Author: https://github.com/ninD2lml

#!/bin/bash

#Colors
red='\e[31m'
gre='\e[32m'
blu='\e[34m'
yel='\e[33m'
nor='\e[0m'

#Information functions
function fn_help(){
	echo -e "${red}Usage:${nor} ${gre}$0${nor} ${yel}[-s] [-u/-l]${nor}"
	echo -e "\t${yel}-u:${nor} convert to ${blu}URL-Encode${nor}"
	echo -e "\t${yel}-l:${nor} convert to ${blu}HTML-Encode${nor}"
	echo -e "\t${yel}-s:${nor} convert ${blu}only symbols${nor} (whitout this parameter convert ${red}all${nor})"
	echo -e "\t${yel}-c:${nor} ${blu}copy to clipboard${nor}"
	echo -e "\t${yel}-o:${nor} ${blu}output file${nor}"
	echo -e "\t${yel}-h/--help:${nor} shows this panel."
	echo -e "\t${yel}--version:${nor} prints ${blu}version${nor} ${yel}&${nor} ${blu}credits${nor}"
	echo -e "${red}Example:${nor} ${blu}cat file.txt |${nor} ${gre}$0${nor} ${yel}-su${nor}, ${blu}echo \'a#1[z]0L\' |${nor} ${gre}$0${nor} ${yel}-lsc -o file.txt${nor}"
	exit 0
}

function fn_version(){
	echo -e "${yel}Version${nor} ${gre}1.0${nor} ${yel}| Author:${nor} ${gre}ninD2lml${nor}${yel} ${yel}| Secret Face:${nor} ${gre}:u${nor}"
	exit 0
}


#Global variables
declare -a ac_utf8=(" " "!" "\"" "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" ":" ";" "<" "=" ">" "?" "@" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "[" "\\" "]" "^" "_" "\`" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "{" "|" "}" "~")
declare -a ac_url=("%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29" "%2A" "%2B" "%2C" "%2D" "%2E" "%2F" "%30" "%31" "%32" "%33" "%34" "%35" "%36" "%37" "%38" "%39" "%3A" "%3B" "%3C" "%3D" "%3E" "%3F" "%40" "%41" "%42" "%43" "%44" "%45" "%46" "%47" "%48" "%49" "%4A" "%4B" "%4C" "%4D" "%4E" "%4F" "%50" "%51" "%52" "%53" "%54" "%55" "%56" "%57" "%58" "%59" "%5A" "%5B" "%5C" "%5D" "%5E" "%5F" "%60" "%61" "%62" "%63" "%64" "%65" "%66" "%67" "%68" "%69" "%6A" "%6B" "%6C" "%6D" "%6E" "%6F" "%70" "%71" "%72" "%73" "%74" "%75" "%76" "%77" "%78" "%79" "%7A" "%7B" "%7C" "%7D" "%7E")
declare -a ac_html=("&#32;" "&#33;" "&#34;" "&#35;" "&#36;" "&#37;" "&#38;" "&#39;" "&#40;" "&#41;" "&#42;" "&#43;" "&#44;" "&#45;" "&#46;" "&#47;" "&#48;" "&#49;" "&#50;" "&#51;" "&#52;" "&#53;" "&#54;" "&#55;" "&#56;" "&#57;" "&#58;" "&#59;" "&#60;" "&#61;" "&#62;" "&#63;" "&#64;" "&#65;" "&#66;" "&#67;" "&#68;" "&#69;" "&#70;" "&#71;" "&#72;" "&#73;" "&#74;" "&#75;" "&#76;" "&#77;" "&#78;" "&#79;" "&#80;" "&#81;" "&#82;" "&#83;" "&#84;" "&#85;" "&#86;" "&#87;" "&#88;" "&#89;" "&#90;" "&#91;" "&#92;" "&#93;" "&#94;" "&#95;" "&#96;" "&#97;" "&#98;" "&#99;" "&#100;" "&#101;" "&#102;" "&#103;" "&#104;" "&#105;" "&#106;" "&#107;" "&#108;" "&#109;" "&#110;" "&#111;" "&#112;" "&#113;" "&#114;" "&#115;" "&#116;" "&#117;" "&#118;" "&#119;" "&#120;" "&#121;" "&#122;" "&#123;" "&#124;" "&#125;" "&#126;")

declare -a sc_utf8=(" " "!" "\"" "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "/" ":" ";" "<" "=" ">" "?" "@" "[" "\\" "]" "^" "_" "\`" "{" "|" "}" "~")
declare -a sc_url=("%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29" "%2A" "%2B" "%2C" "%2D" "%2E" "%2F" "%3A" "%3B" "%3C" "%3D" "%3E" "%3F" "%40" "%5B" "%5C" "%5D" "%5E" "%5F" "%60" "%7B" "%7C" "%7D" "%7E")
declare -a sc_html=("&#32;" "&#33;" "&#34;" "&#35;" "&#36;" "&#37;" "&#38;" "&#39;" "&#40;" "&#41;" "&#42;" "&#43;" "&#44;" "&#45;" "&#46;" "&#47;" "&#58;" "&#59;" "&#60;" "&#61;" "&#62;" "&#63;" "&#64;" "&#91;" "&#92;" "&#93;" "&#94;" "&#95;" "&#96;" "&#123;" "&#124;" "&#125;" "&#126;")

#Functions
function url_encode(){
	aux2=""
	result="$result"
	if [ "$symbols" == "true" ]; then
		while read line; do
			aux="$line$aux2"
			aux2=""
			for ((pos=0;pos<=${#line};pos++)); do
			check=0
				for ((k=0;k<=${#sc_utf8[@]};k++)); do
					if [ "${line:$pos:1}" == "${sc_utf8[$k]}" ]; then
						aux2="$aux2${sc_url[$k]}"
						check=1
						break
					fi
				done
				if [ $check -eq 0 ]; then
					aux2="$aux2${line:$pos:1}"
				fi
			done
			result="$result$aux2\n"
		done
	else
		while read line; do
			aux="$line$aux2"
			aux2=""
			for ((pos=0;pos<=${#line};pos++)); do
				for ((k=0;k<=${#ac_utf8[@]};k++)); do
					if [ "${line:$pos:1}" == "${ac_utf8[$k]}" ]; then
						aux2="$aux2${ac_url[$k]}"
						break
					fi
				done
			done
			result="$result$aux2\n"
		done
	fi
}

function html_encode(){
	aux2=""
	result="$result"
	if [ "$symbols" == "true" ]; then
		while read line; do
			aux="$line$aux2"
			aux2=""
			for ((pos=0;pos<=${#line};pos++)); do
			check=0
				for ((k=0;k<=${#sc_utf8[@]};k++)); do
					if [ "${line:$pos:1}" == "${sc_utf8[$k]}" ]; then
						aux2="$aux2${sc_html[$k]}"
						check=1
						break
					fi
				done
				if [ $check -eq 0 ]; then
					aux2="$aux2${line:$pos:1}"
				fi
			done
			result="$result$aux2\n"
		done
	else
		while read line; do
			aux="$line$aux2"
			aux2=""
			for ((pos=0;pos<=${#line};pos++)); do
				for ((k=0;k<=${#ac_utf8[@]};k++)); do
					if [ "${line:$pos:1}" == "${ac_utf8[$k]}" ]; then
						aux2="$aux2${ac_html[$k]}"
						break
					fi
				done
			done
			result="$result$aux2\n"
		done
	fi
}

declare -i check=0; declare -i check2=0; declare -i copy=0;

while getopts ":o::sulch-:" opt; do
	case $opt in
		u) url=true; check=1;;
		l) url=false; check=1;;
		s) symbols=true; check=1;;
		o) output=$OPTARG; check2=1;;
		c) copy=1;;
		h) fn_help;;
		-)
			case "${OPTARG}" in
				help) fn_help;;
				version) fn_version;;
			esac;;
		?) echo -e "[-${OPTARG}] isn't a option!">&2; exit 1;;
	esac
done

if [ $check -ne 0 ]; then
	if [ "$url" == true ]; then
		url_encode
	elif [ "$url" == false ]; then
		html_encode
	else
		echo "${red}Select a encode: ${nor} ${yel}[-u/-l]${nor}"
		exit 0
	fi
	if [ $copy -eq 1 ]; then
		echo -ne "$result" | sed 's/\n//g' | tr -d '\n' | xclip -sel clipboard &>/dev/null
	fi
	if [ $check2 -eq 1 ]; then
		echo -n "$result" | sed 's/\\n/\ /g' | sed 's/\ /\n/g' >> $output
		exit 0
	else
		echo -ne "${red}~~~~~~~~~~~OUTPUT~~~~~~~~~~~${nor}\n${yel}$result${nor}"
		unset ac_utf8; unset ac_url; unset sc_utf8; unset sc_url
		exit 0
	fi
fi
