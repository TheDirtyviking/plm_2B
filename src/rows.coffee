#!/usr/bin/coffee

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
  lines.push(input)

# once stdin is read, call main, end process
rl.on 'close', () =>
  main()
  process.exit 0
    
main = () =>
  console.log(lines[lines.length - 1])
  
  # Construct an empty tables
  t = data
  
  t = header (t)
  
header = (t) ->
  t.indeps = []
    
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
    
 sym = () ->
  sym =
    counts : []
    mode : null
    most : 0
    n : 0
    ent : null
    
indep = (t, c) ->
  if t.w?
    not t.w[c]? and t.class != c
  else
    t.class != c

dep = (t, c) ->
  not indep t,c

row = (t, cells ) ->
  r = t.rows.length # Don't need to add 1 like in rows.lua
  t.rows[r] = []
  for c, c0 in t.use
    # any chance that the different index systems will cause issues in areas like this?
    x = cells[c0]
    if x?
      x = parseFloat x # String to float in JS
      if t.nums? and t.nums[c]?
        numInc t.nums[c],x
      else
        symInc t.syms[c],x
    t.rows[r][c] = x # happens whether or not x was a float
  t

clone = (data0, rows) ->
  data1 = header data0.name
  for key, cells in rows or dat0.rows
    row data1,cells
  data1
 
