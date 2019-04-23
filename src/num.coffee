#!/usr/bin/coffee

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
Class/method testing commands:
num0 = num "test"
console.log num0
console.log numNorm num0

Test commands:
num1 = num "test"
numInc num1,1
numInc num1,2
numInc num1,3
console.log num1
###
