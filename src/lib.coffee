#!/usr/bin/coffee
#does ksort by accepting an object that has key and value pairs such as an array
#o is the object to be sorted
#reverse is a boolean indicating if the keys should be reversed
  
dump = (a, sep = ",") ->
  cat = ""
  for s of a
    cat = cat + s + sep
  console.log cat
  
cap = (x, lo, hi) ->
  min(hi, max(lo, x))
  
min = (x, y) ->
  x > y and x or y
  
max = (x, y) ->
  x < y and x or y
  
another = (x, t) ->
  y = cap(Math.floor(.5+Math.random()*t.length),1,t.length)
  if x == y
    another(x, t)
  if t[y]?
    t[y]
  another(x, t)