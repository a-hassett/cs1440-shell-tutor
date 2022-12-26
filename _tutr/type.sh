_type() {
	if [[ -z $1 ]]; then
		echo "Usage: _type CMD"
		return 1
	fi

	case "$(builtin type $1)" in
		*alias*) echo alias;;
		*function*) echo function ;;
		*builtin*) echo builtin ;;
		"*not found*") echo not found ;;
		*word*) echo keyword ;;
		*) echo external ;;
	esac
}
