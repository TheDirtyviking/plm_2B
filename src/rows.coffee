#!/usr/bin/coffee

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

indep = (t, c) ->
  if t.w?
    not t.w[c]? and t.class != c
  else
    t.class != c

dep = (t, c) ->
  not indep t,c

###
Test commands for data, indep and dep

d = data()
console.log d
d.w[0] = 1
d.class = 1
console.log d
console.log indep d,1
console.log dep d,1
###

