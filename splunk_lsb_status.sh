#!/bin/bash
# By Greg Albrecht (gba@gregalbrecht.com)
# This looks ghetto because it is ghetto, we'll fix the product at some point, I promise*.

if [ $# -ne 2 ]
then
  echo "This should be called from cloudkick agent:"
  echo "  $0 <SPLUNK_HOME> <COMPONENT>"
  echo "Where SPLUNK_HOME is your SPLUNK_HOME, e.g.: /opt/splunk,"
  echo "and Where COMPONENT is either 'splunkd' or 'splunkweb'."
  exit 1
fi
SPLUNK_HOME=$1
COMPONENT=$2

if [ ! -d "$SPLUNK_HOME" ]; then
  echo "status err SPLUNK_HOME=$SPLUNK_HOME is not a directory."
  exit 1
fi

if [ ! -x "$SPLUNK_HOME/bin/splunk" ]; then
  echo "status err $SPLUNK_HOME/bin/splunk is not executable."
  exit 1
fi

STATUS_OUT="$($SPLUNK_HOME/bin/splunk status|grep $COMPONENT)"

if [ "$(echo $STATUS_OUT|grep 'is not running')" ]; then
  echo "status err $STATUS_OUT"
  exit 3
elif [ "$(echo $STATUS_OUT|grep 'is running')" ]; then
  echo "status ok $STATUS_OUT"
  exit 0
else 
  echo "status err $STATUS_OUT"
  exit 3
fi

