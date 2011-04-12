#!/bin/bash

# chef-client_status_via_logs.sh
# Cloudkick plugin to check the status of Chef via its logs.
#
# By Greg Albrecht <gba@gregalbrecht.com>
# Adapted from David Chen <dchen@alumni.cmu.edu>'s process_count.sh

# Copyright (C) 2011 Splunk, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

CHEF_LOG="/var/log/chef-client.log"
LOG_ERR=$(grep ERROR $CHEF_LOG|wc -l)
LOG_WARN=$(grep WARN $CHEF_LOG|wc -l)

if [ "$LOG_ERR" -gt "0" ]; then
  echo "status err chef-client has $LOG_ERR errors"
elif [ "$LOG_WARN" -gt "0" ]; then
  echo "status warn chef-client has $LOG_WARN warnings"
else
  echo "status ok chef-client has no errors and no warnings"
fi
echo "metric errors int $LOG_ERR"
echo "metric warnings int $LOG_WARN"
