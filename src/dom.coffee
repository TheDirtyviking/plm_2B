#!/usr/bin/coffee

###
Get Standard input, then call dom(rows)
###

# Make global variable id
objectId = this
objectId = 0

# lines of input fron stdin
lines = []

# read lines from input
readline = require 'readline'

# create line reading interface
rl = readline.createInterface
  input: process.stdin
  terminal: true
    
# read each line, adding it to lines
rl.on 'line', (input) =>
  #Constructivity: if the type of input is not a string, set it to be an empty string
  if typeof input != 'string'
    input = ""
  lines.push(input)

# once stdin is read, call main, end process
rl.on 'close', () =>
  mainDom()
  process.exit 0

###
End of stdinput reading
Input is now in lines[]
###
#-------------------------------------------------------------------
###
Start of the sym file
###

symInc = (t, x) ->
  #Constructivity: if t is not an object, set it to a new sym object, if x is not a number, parse it to a number, failing that set it to zero
  if typeof t != 'object'
    nsf = new NSFactory
    t = nsf.sym
  if typeof x != 'number'
    if typeof x == 'string'
      x = parseFloat x
    else
      x = 0
  if not x?
    x
  else
    t.n = t.n + 1
    old = t.counts[x]
    newVal = if old then old + 1 else 1
    t.counts[x] = newVal
    if newVal > t.most
      t.most = newVal
      t.mode = x
    x

###
End of the sym file
###

###
Start of the num file
###

numInc = (t, x) ->
  #Constructivity: If t is not an object, set it to an empty num object, if x is not a number, return x
  if typeof t != 'object'
    nsf = new NSFactory
    t = nsf.sym
  if typeof x != "number"
    x
  else
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
  #Constructivity: if t is not an object, set it to an object containing lo and hi set to zero, if x is not a number set it to 0.5
  if typeof t != 'object'
    t = [lo: 0, hi: 0]
  if typeof x != 'number'
    x = 0.5
  if x?
    (x - t.lo) / (t.hi - t.lo + Math.pow 10,-32 )
  else
    0.5

###
End of the num file
###
#-------------------------------------------------------------------
###
Start of the lib file
###

#Takes an array and separates the values with the sep variable
dump = (a) ->
  #Constructivity: Checks that a is an object, if not sets it to an empty object
  if typeof a != 'object'
    a = []
  for row in a
    console.log row + ""
  
#Takes 3 numbers and binds the x variable to the range 
#defined by lo and hi
cap = (x, lo, hi) ->
  #Constructivity: Checks that x, lo, and hi are numbers, sets them to zero if they are not
  if typeof x != 'number'
    x = 0
  if typeof lo != 'number'
    lo = 0
  if typeof hi != 'number'
    hi = 0
  min(hi, max(lo, x))
  
#Returns the lesser of x and y
min = (x, y) ->
  #Constructivity: Checks that x and y are numbers, sets them to zero if they are not
  if typeof x != 'number'
    x = 0
  if typeof y != 'number'
    y = 0
  x < y and x or y
  
#Returns the greater of x and y
max = (x, y) -> 
  #Constructivity: Checks that x and y are numbers, sets them to zero if they are not
  if typeof x != 'number'
    x = 0
  if typeof y != 'number'
    y = 0
  x > y and x or y
  
#Gets a random index from t that is not x
another = (x, t) ->
  #Constructivity: Checks if x is a float, if x is a string it parses it as a float, else sets it to zero
  if typeof x != 'float'
    if typeof x == 'string'
      x = parseFloat x
    else
      x = 0
  #Constructivity: Checks if t is an object, if not it sets it to be an empty object
  if typeof t != 'object'
    t = []
  y = cap(Math.floor(.5+Math.random()*t.length),0,t.length-1)
  if x == y
    another(x, t)
  if t[y]?
    t[y]
  else
    another(x, t)
    
#Replace pattern a with pattern b in string s
gsub = (s, a, b) -> 
  #Constructivity: checks the types of s, a, and b and assigns them to be empty strings if they aren't strings
  if typeof s != 'string'
    s = ""
  if typeof a != 'string'
    a = ""
  if typeof b != 'string'
    b = ""
  s.replace a, b
  
###
End of the lib file
###
#-------------------------------------------------------------------
###
Start of the Dom File
###

#Get the dom score of those two rows
dom = (t, row1, row2) ->
  #Constructivity: Checks that t, row1, and row2 are all objects and exist, if they arent create empty ones
  if typeof t != 'object' or not t?
    t = [w:[],nums:[]]
  if typeof row1 != 'object' or not row1?
    row1 = []
  if typeof row1 != 'object' or not row2?
    row2 = []
  s1 = 0
  s2 = 0
  n = 0
  n++ for key in t.w
  for c,w of t.w
    a0 = row1[c]
    b0 = row2[c]
    a = numNorm( t.nums[c], a0)
    b = numNorm( t.nums[c], b0)
    s1 = s1 - Math.pow 10,(w * (a - b)/n)
    s2 = s2 - Math.pow 10,(w * (b - a)/n)
  s1/n < s2/n
  
doms = (t) ->
  #Constructivity: Checks that t is an object and creates an empty one if it is not
  if typeof t != 'object'
    t = []
  n = 100
  if t.name?
    c = t.name.length
  else
    c = 0
  console.log(t.name + "," + ">dom")
  for r1, row1 of t.rows
    row1[c] = 0
    for i in [0...n-1] by 1
      row2 = another(r1, t.rows)
      if dom(t,row1,row2)
        row1[c] = row1[c] + ( 1 / n )
    row1[c] = row1[c].toFixed 2
  dump(t.rows)

mainDom = () ->
  doms(rows())
  
###
End of the Dom file
###
#-------------------------------------------------------------------
###
Start of the rows File
###

rows = () =>
  
  # Construct an empty table
  t = data()

  first = true
  for line in lines 
    do (line) ->
      #console.log(line)
      line = gsub line, "[\t\r ]*", ""
      line = gsub line, "#.*", ""
      cells = line.split ","
      if cells.length > 0
        if first is true
          header t, cells
          first = false
        else
          row t, cells
  t
  
#A class that holds the logic for creating a num or sym object, depending on the contents of a given string
class NSFactory
  
  sym = () ->
    counts : []
    mode : null
    most : 0
    n : 0
    
  num = () ->
    n : 0
    mu : 0
    m2 : 0
    sd : 0
    id : objectId++
    lo : Math.pow 10,32
    hi : -1 * Math.pow 10,32
    w : 1
  
  create : (x) ->
    #Constructivity: if x is not a string, make it an empty string
    if typeof x != 'string'
      x = ""
    o  = []
    if x.match "[<>%$]"
      o = num()
    else
      o = sym()
    o
  

header = (t, cells) ->
  #Constructivity: if the parameters are not objects, assign them to empty objects, assign t to have required fields
  if typeof t != 'object' or not t.indeps? or not t.use or not t.name or not t.col or not t.syms or not t.nums
    t = [ w : [],syms : [],nums : [],class : null,rows : [],name : [],col : [],use : [],indeps : [] ]
  if typeof cells != 'object'
    cells = []
  t.indeps = []
  for c0, x of cells
    if not x.search "%?"
      c = t.use.length
      t.use[c] = c0
      t.name[c] = x
      t.col[x] = c
      nsf = new NSFactory
      o = nsf.create x,t
      if o.counts?
        t.syms[c] = o
      else
        t.nums[c] = o
      if x.match "<"
        t.w[c] = -1
      else if x.match ">"
        t.w[c] = 1
      else if x.match "!"
        t.class = c
      else
        t.indeps.push c 
  t
  
row = (t, cells ) ->
  #Constructivity: if the parameters are not objects, assign them to empty objects
  if typeof t != 'object'
    t = [rows:[],nums:[],syms:[]]
  if typeof cells != 'object'
    cells = []
  r = t.rows.length # Don't need to add 1 like in rows.lua
  t.rows[r] = []
  for c, c0 in t.use
    # any chance that the different index systems will cause issues in areas like this?
    x = cells[c0]
    if x != "?"
      if t.nums? and t.nums[c]?
        x = parseFloat x # String to float in JS
        numInc t.nums[c], x
      else
        symInc t.syms[c], x
    t.rows[r][c] = x # happens whether or not x was a float
  t
    
data = () ->
  data =
    w : []
    syms : []
    nums : []
    class : null
    rows : []
    name : []
    col : []
    use : []
    indeps : []

###
End of the rows file
###