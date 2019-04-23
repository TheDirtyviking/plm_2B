#!/usr/bin/coffee
####################################################################
###
Start of the sym file
###

sym = () ->
  sym =
    counts : []
    mode : null
    most : 0
    n : 0
    ent : null

symInc = (t, x) ->
  if x=="?"
    x
  t.ent = null
  t.n = t.n + 1
  old = t.counts[x]
  new = old + 1 if old else 1
  t.counts[x] = new
  if new > t.most
    t.most = new
    t.mode = x
  x

###
End of the sym file
###
####################################################################
###
Start of the num file
###

# Make global variable id
objectId = this
objectId = 0

num = (txt) ->
  num =
    n : 0
    mu : 0
    m2 : 0
    sd : 0
    id : objectId++
    lo : Math.pow 10,32
    hi : -1 * Math.pow 10,32
    txt1 : txt
    w : 1

defaultFunction = ( x ) ->
  x 

numInc = (t, x) ->
  if x == "?"
    x
  t.n = t.n + 1
  d = x - t.mu
  t.mu = t.mu + d / t.n
  t.m2 = t.m2 + d * (x - t.mu )
  if x > t.hi
    t.hi = x
  if x < t.lo
    t.lo = x
  if t.n >= 2
    t.sd = Math.pow (t.m2 / ( t.n - 1 + Math.pow 10,-32 ) ),0.5
  x

numNorm = (t, x) ->
  if x?
    (x - t.lo) / (t.hi - t.lo + Math.pow 10,-32 )
  else
    0.5

nums = (t, f = defaultFunction) ->
  n = num
  numInc n,f value for key, value of t

###
End of the num file
###
####################################################################
###
Start of the lib file
###

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
  
###
End of the lib file
###
####################################################################
###
Start of the Dom File
###

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
  
###
End of the Dom file
###