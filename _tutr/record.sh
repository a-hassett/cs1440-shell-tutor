# Record the completion token in a hidden file named with $1
_tutr_record_completion() {
    if [[ -z $1 ]]; then
        echo "_tutr_record_completion(): No argument given"
        return 1
    else
        printf "$1\t$(date +%s)\t$SECONDS\n" >> .$1
        git hash-object .$1 >> .$1
    fi
}

# Check for the existence of the record token
_tutr_record_exists() {
    if [[ -z $1 ]]; then
        echo "_tutr_record_check(): No argument given"
        return 1
    else
        [[ -f .$1 ]]
    fi
}
