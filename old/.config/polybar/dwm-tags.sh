#! /bin/bash

# Get the colors from xressources (optional)
back=$(xgetres "*.background")
fore=$(xgetres "*.foreground")
prim=$(xgetres "*.color2")
pr_a=$(xgetres "*.color10")
seco=$(xgetres "*.color4")
se_a=$(xgetres "*.color12")

# Listen for updates of the tagstate
xprop -spy -root "DWM_TAG_STATE_$MONITOR" 2>/dev/null | {
    # Read the tag state
    while true; do
        IFS=$'\t' read -ra tags_string <<< "$(xprop -notype -root "DWM_TAG_STATE_$MONITOR")"
        {
            [[ $tags_string =~ \"(.*)\" ]]
            tags=${BASH_REMATCH[0]}
            # Print the state for each tag to polybar
            # Formatting Tags are used here according to polybar's wiki
            for i in {1..9}
            do
                case ${tags:$i:1} in
                    a)
                        # the tag is viewed on the focused monitor
                        echo "%{F$prim}%{B$back}  %{F-}%{B-}"
                        ;;
                    o)
                        # : the tag is not empty
                        echo "%{F$prim}%{B$back}  %{F-}%{B-}"
                        ;;
                    u)
                        # ! the tag contains an urgent window
                        echo "%{F$seco}%{B$back}  %{F-}%{B-}"
                        ;;
                    *)
                        # . the tag is empty
                        echo "%{F$fore}%{B$back}  %{F-}%{B-}"
                        ;;
                esac
            done
        } | tr -d "\n"

        echo
    read -r || break
done
}
