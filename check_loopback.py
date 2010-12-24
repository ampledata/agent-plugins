#!/usr/bin/env python
#
# License: MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Cloudkick plugin that checks if the loopback interface is available, has at least one ip address
# assigned and is up
#

import re
import sys
import random
import socket
import subprocess

DEFAULT_INTERFACE = 'lo0'
DEFAULT_TIMEOUT = 2

def main():
  arg_len = len(sys.argv)

  if arg_len >= 2:
    loopback_interface = sys.argv[1]
  else:
    loopback_interface = DEFAULT_INTERFACE

  if arg_len == 3:
    connect_timeout = int(sys.argv[2])
  else:
    connect_timeout = DEFAULT_TIMEOUT

  (stdout, stderr) = subprocess.Popen(['ifconfig', '-v', loopback_interface], stdout = subprocess.PIPE, stderr = subprocess.PIPE, close_fds = True).communicate()

  if stderr.find('Device not found') != -1 or stderr.find('does not exist') != -1:
    print 'status err %s interface not found' % (loopback_interface)
    sys.exit(1)

  lines = stdout.split('\n')
  has_ip_address = False
  for line in lines:
    line = line.strip()

    match = re.search(r'inet (addr)?:?(.*?) ', line)
    if match:
      has_ip_address = True
      inet_addr = match.groups()[1]
      break

  if not has_ip_address:
     print 'status err %s interface has no ip address' % (loopback_interface)
     sys.exit(1)

  port = random.randint(20000, 40000)
  try:
    if int(sys.version[0]) == 2 and int(sys.version[2]) <= 5:
        connection_socket = socket.socket(socket.AF_INET)
        connection_socket.settimeout(connect_timeout)
        connection = connection_socket.connect((inet_addr, port))
    else:
        connection = socket.create_connection((inet_addr, port), connect_timeout)
  except socket.timeout, e:
    print 'status err can\'t establish connection to %s:%s' % (inet_addr, port)
    sys.exit(1)
  except socket.error:
    pass

  print 'status ok %s interface is up and working' % (loopback_interface)
  sys.exit(0)

main()
