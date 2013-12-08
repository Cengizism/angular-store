




# Functions to encapsulate questionable FireFox 3.6.13 behavior
# when about.config::dom.storage.enabled === false
# See https://github.com/marcuswestin/store.js/issues#issue/13
isLocalStorageNameSupported = ->
  try
    return (localStorageName of window and window[localStorageName])
  catch err
    return false





store = {}

doc = window.document

localStorageName = "localStorage"

scriptTag = "script"

storage = undefined


store.disabled = false


store.set = (key, value) ->


store.get = (key) ->


store.remove = (key) ->


store.clear = ->



store.transact = (key, defaultVal, transactionFn) ->
  val = store.get(key)
  unless transactionFn?
    transactionFn = defaultVal
    defaultVal = null
  val = defaultVal or {}  if typeof val is "undefined"
  transactionFn val
  store.set key, val


store.getAll = ->


store.forEach = ->


store.serialize = (value) ->
  JSON.stringify value


store.deserialize = (value) ->
  return `undefined`  unless typeof value is "string"
  try
    return JSON.parse(value)
  catch e
    return value or `undefined`



storage = window[localStorageName]
store.set = (key, val) ->
  return store.remove(key)  if val is `undefined`
  storage.setItem key, store.serialize(val)
  val



store.get = (key) ->
  store.deserialize storage.getItem(key)



store.remove = (key) ->
  storage.removeItem key



store.clear = ->
  storage.clear()



store.getAll = ->
  ret = {}
  store.forEach (key, val) ->
    ret[key] = val
  ret



store.forEach = (callback) ->
  i = 0
  while i < storage.length
    key = storage.key(i)
    callback key, store.get(key)
    i++



try
  testKey = "__storejs__"
  store.set testKey, testKey
  store.disabled = true  unless store.get(testKey) is testKey
  store.remove testKey
catch e
  store.disabled = true
store.enabled = not store.disabled
if typeof module isnt "undefined" and module.exports
  module.exports = store
else if typeof define is "function" and define.amd
  define store
else
  window.store = store