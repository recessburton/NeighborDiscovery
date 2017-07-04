#!/usr/bin/python
'''
 Copyright (C),2014-2015, YTC, www.bjfulinux.cn
 Copyright (C),2014-2015, ENS Lab, ens.bjfu.edu.cn
 Created on  2015-12-10 16:15

 @author: ytc recessburton@gmail.com
 @version: 0.9

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>
'''
from TOSSIM import *
from tinyos.tossim.TossimApp import *
from random import *
import sys

emulatehours = 1.0 #emulate time
emulatetimeseconds = int(emulatehours*3687)
nodeNo = 3
t = Tossim([])
r = t.radio()
tickspersencond = t.ticksPerSecond()

f = open("grid_5_by_20_footballfield_2.txt", "r")
lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    if s[0] == "gain" and 0<int(s[1])<=nodeNo  and 0<int(s[2])<=nodeNo:
      r.add(int(s[1]), int(s[2]), float(s[3]))


noise = open("meyer-short.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)-10
    for i in range(1, nodeNo+1):
      m = t.getNode(i);
      m.addNoiseTraceReading(val)

for i in range(1, nodeNo+1):
  m = t.getNode(i);
  m.createNoiseModel();
  time = randint(t.ticksPerSecond(), 1200 * t.ticksPerSecond())
  m.bootAtTime(time)
  print "Booting ", i, " at time ", time

print "Starting simulation."

f1 = open("logs_ack","w")
t.addChannel("ACK", f1)
#t.addChannel("CpmModelC", f1)
#t.addChannel("Acks", f1)
#t.addChannel("AM", f1)
t.addChannel("YTCT", f1)
#t.addChannel("Tossim", f1)
t.addChannel("Probe", f1)


percent = 0
while (t.time() < emulatetimeseconds * tickspersencond):
	if t.time() > (emulatetimeseconds * tickspersencond*(percent/100.0)):
		sys.stdout.write('\r%d'%percent+'%')
		sys.stdout.flush()
		percent+=1
	t.runNextEvent()

print "\rSimulation completed."
