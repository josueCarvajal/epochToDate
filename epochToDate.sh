#!/bin/bash

function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines(){

    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){

    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){

    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString(){

    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function printHeader(){
echo -e "  | fileid |         startet               |           endet               |         receipttime           |        mineventendtime        |       maxeventendtime         |" >>parsed_file.out
}

function main(){
   header="fileid_startet_endet_receipttime_mineventendtime_maxeventendtime"
   parsed_file=$(cat epochTable.txt | grep -Ev "rows|fileid|\-\-" | tr '|' ',' | tr -d ' ')
   rm -r parsed_file.out 2>/dev/null
   #printTable '_' "$(echo $header)" >> parsed_file.out
   printHeader

   for value in $(echo "$parsed_file"); do
       for x in $(echo $value | sed "s/,/ /g"); do
           counter=$(($counter+1))
           if [ "$(echo $counter)" -eq "1" ]; then
                tuple="${tuple}${x}_"

           elif [ "$(echo $counter)" -eq "6" ]; then
              parsed=${x::-3}
              retrievedDate=$(date -d @$parsed)
              tuple="${tuple}${retrievedDate}"
           else
              parsed=${x::-3}
              retrievedDate=$(date -d @$parsed)
              tuple="${tuple}${retrievedDate}_"
              #echo -e "$x ---> $parsed"
           fi
      done
      printTable '_' "$(echo $tuple)" >> parsed_file.out
      tuple=""
      counter=0
   done
   echo -e "\n\n [OK] Parsed done. File parsed_file.out created"
}
#calling our main method
main