#!/bin/bash

PATCH_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "PATCH_DIR=$PATCH_DIR"
few_diffs=( "--" "--cached" )
for d in "${few_diffs[@]}"; do
  echo "git diff --name-only $d $1"
  git diff --name-only $d $1 | while read f
  do
    CUR_DIFF="$PATCH_DIR/$f.diff"
    mkdir -p "$(dirname $CUR_DIFF)"
    case "$(uname -s)" in
      Linux*) git diff $d "$f" | sed '2,3{/^index/d;}' | sed $'s/\r$//' > $CUR_DIFF ;;
           *) git diff $d "$f" | sed '2,3{/^index/d;}' | sed $'s/$/\r/' > $CUR_DIFF ;;
    esac
  done
done
echo "DONE"