#!/usr/bin/coffee

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

