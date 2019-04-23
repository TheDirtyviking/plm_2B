#!/usr/bin/coffee
  
#Takes an array and separates the values with the sep variable
dump = (a, sep = ",") ->
  cat = ""
  for s of a
    cat = cat + s + sep
  console.log cat
  
#Takes 3 numbers and binds the x variable to the range 
#defined by lo and hi
cap = (x, lo, hi) ->
  min(hi, max(lo, x))
  
#Returns the lesser of x and y
min = (x, y) ->
  x < y and x or y
  
#Returns the greater of x and y
max = (x, y) ->
  x > y and x or y
  
#Gets a random index from t that is not x
another = (x, t) ->
  y = cap(Math.floor(.5+Math.random()*t.length),0,t.length-1)
  if x == y
    another(x, t)
  if t[y]?
    t[y]
  else
    another(x, t)
    
#Replace pattern a with pattern b in string s
gsub = (s, a, b) -> 
  s.replace a, b

#Return a list of the 
split = (s, sep = ",") ->
  t = []
  notsep = "([^" + sep + "]+)"
  for y in s.match(notsep)
    t[t.length] = y
  t