_fzf_complete_batrak() {
    cmd="${BUFFER}"
    eval set -- $cmd
    zparseopts -E -D -- \
               -l=o_list
    echo "o_list=$o_list" >> /tmp/x
}
