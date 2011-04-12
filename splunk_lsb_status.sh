#!/bin/sh
# By Greg Albrecht (gba@gregalbrecht.com)
# This looks ghetto because it is ghetto, we'll fix the product at some point, I promise*.

if [ "$($SPLUNK_HOME/splunk status|grep 'splunkd is not running')" ]; then
    echo "err splunkd is not running"
    exit 3
else
    echo "ok splunkd is running"
    exit 0
fi

# * By promise I mean I'll file a JIRA so my grandchildren can resolve it.
