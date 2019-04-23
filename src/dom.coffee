#!/usr/bin/coffee

import './lib.coffee';
import './rows.coffee';

#Get the dom score of those two rows
dom = (t, row1, row2) ->
  s1 = 0
  s2 = 0
  n = 0
  n++ for key in t.w
  for c,w in t.w
    a0 = row1[c]
    b0 = row2[c]
    a = numNorm( t.nums[c], a0)
    b = numNorm( t.nums[c], b0)
    s1 = s1 - 10^(w * (a - b)/n)
    s2 = s2 - 10^(w * (b - a)/n)
  s1/n < s2/n
  
doms = (t) ->
  n = 100
  c = t.name.length + 1
  console.log(t.name + "," + ",>dom")
  for row1, r1 in t.rows
    row1[c] = 0
    for i in [0...n-1] by 1
      row2 = another(r1, t.rows)
      s = dom(t,row1,row2)
      row1[c] = row1[c] + s
  dump(t.rows)

mainDom = () ->
  doms(rows())