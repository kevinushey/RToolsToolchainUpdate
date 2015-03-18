#! /usr/bin/env bash

pkgs=( build-essential m4 git make python wget gnat 
	flex texinfo patch python automake g++ bison
)

for P in "${pkgs[@]}"; do
    dpkg -s "$P" >/dev/null 2>&1 && {
        echo "$P is installed."
    } || {
        echo "$P is not installed."
    }
done
