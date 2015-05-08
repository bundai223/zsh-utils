py_help() {
    target=$1
    python -c "import ${target}; help(${target})"
}

py3_help() {
    target=$1
    python3 -c "import ${target}; help(${target})"
}


