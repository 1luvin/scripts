#!/bin/bash

B="•••••••••"

print_board () {
    i=0
    while [ $i -lt 9 ]; do
        printf "${B:$i:1} "
        if [ $(($i % 3)) == 2 ]
        then
            printf "\n"
        fi
        i=$(($i + 1))
    done
}

# sign, x, y
mark_on_board () {
    p=$(($2 * 3 + $3))
    l=${B:0:p}
    r=${B:(p+1):(8-p)}
    B="$l$1$r"
}

# return
# 0 - game in progress
# 1 - somebody wins or draw
check_status () {
    # checking rows and cols
    i=0
    xs="XXX"
    os="OOO"
    while [ $i -lt 3 ]; do
        row=${B:(i * 3):3}
        col="${B:i:1}${B:(i + 3):1}${B:(i + 6):1}"
        if [ $row == $xs ] || [ $row == $os ]; then
            echo "Player ${row:0:1} wins!"
            return 1
        elif [ $col == $xs ] || [ $col == $os ]; then
            echo "Player ${col:0:1} wins!"
            return 1
        fi
        i=$(($i + 1))

    done

    # checking diagonals
    d="${B:0:1}${B:4:1}${B:8:1}"
    if [ $d == $xs ] || [ $d == $os ]; then
        echo "Player ${d:0:1} wins!"
        return 1
    fi

    d="${B:2:1}${B:4:1}${B:6:1}"
    if [ $d == $xs ] || [ $d == $os ]; then
        echo "Player ${d:0:1} wins!"
        return 1
    fi

    # checking draw
    if ! [[ $B == *"•"* ]]; then
        echo "Draw!"
        return 1
    fi

    return 0
}

default_game () {
    signs="XO"
    j=$1
    printf "\n$(print_board)\n"
    while true; do
        # logic
        read -p "Player ${signs:j:1}: " input
        if [ $input == "save" ]; then
            printf "$B\n" > saved_game.txt
            printf "$j" >> saved_game.txt
            printf "\nSuccessfully saved!"
            break
        fi

        mark_on_board ${signs:j:1} ${input:0:1} ${input:1:1}
        printf "\n$(print_board)\n"

        check_status
        if [ "$?" == "1" ]; then
            printf "\n"
            read -p "Press any key to continue..." x
            break
        fi

        # counters
        j=$(($j + 1))
        if [ $j == 2 ]; then
            j=0
        fi
    done
}

open_saved_game () {
    if [ -f "saved_game.txt" ]; then
        board=$(head -n 1 saved_game.txt)
        player=$(head -n 2 saved_game.txt | tail -n 1)
        rm saved_game.txt
        B=$board
        default_game $player
    fi
}

printf "\nMenu (choose the option):\n"
printf "1. Start default game\n"
printf "2. Open saved game\n\n"

read -p "--> " option
if [ $option == "1" ]; then
    default_game 0
elif [ $option == "2" ]; then
    open_saved_game
fi