#!/bin/bash
#
# update_builddir_checker: Prints directory names where local
# directory is behind the remote git repository.
#
# This bash script has been adapted from question & answer posted on
# stackoverflow in regards to "Check if pull needed in git" and "check
# if an array contains a value", see links below.
#
# (http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git)
# (http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value)
#
# Copyright (c) 2015 Joshua D. Foster <joshua.david.foster@gmail.com>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

BUILDDIR=~/build
IGNOREDIR=(linux-apparmor-custom)
UPTODATE=()
NEEDTOPULL=()
NEEDTOPUSH=()
DIVERGED=()

for dirname in $(ls $BUILDDIR); do
    diff_array=${IGNOREDIR[@]#$dirname}
    if [ "${IGNOREDIR[*]}" == "${diff_array[*]}" ]; then
        cd $BUILDDIR/$dirname
        git remote update > /dev/null
        LOCAL=$(git rev-parse @)
        REMOTE=$(git rev-parse @{u})
        BASE=$(git merge-base @ @{u})
        if [ $LOCAL = $REMOTE ]; then
            UPTODATE+=($dirname)
        elif [ $LOCAL = $BASE ]; then
            NEEDTOPULL+=($dirname)
        elif [ $REMOTE = $BASE ]; then
            NEEDTOPUSH+=($dirname)
        else
            DIVERGED+=($dirname)
        fi
    fi
done

for topull in  ${NEEDTOPULL[*]}; do
    echo $topull
done
