'use strict'

angular.module('storeModule', []).provider 'Store', ->

  @prefix = 'myApp'

  @setPrefix = (prefix) -> @prefix = prefix

  @$get = [() ->
    prefix = @prefix
    prefix = (if !!prefix then prefix + '.' else '')  if prefix.substr(-1) isnt '.'

    _serialize = (value) ->
      value = null unless value?
      value = angular.toJson(value) if angular.isObject(value) or angular.isArray(value)
      value

    _parsable = (value) ->
      true if value.charAt(0) is '{' or value.charAt(0) is '['

    _deserialize = (value) ->
      value = null if not value or value is 'null'
      if value? then angular.fromJson(value) if _parsable value
      value

    supported = ->
      try
        _supported = ('localStorage' of window and window['localStorage'] isnt null)
        key = prefix + '__' + Math.round(Math.random() * 1e7)
        if _supported
          localStorage.setItem key, ''
          localStorage.removeItem key
        return true
      catch e
        console.log 'Local storage is not supported.', e
        return false

    set = (key, value) ->
      if supported
        try
          localStorage.setItem prefix + key, _serialize value
          return true
        catch e
          console.log 'Setting a value in local storage is failed.', e
          return false

    get = (key) ->
      if supported
        try
          return _deserialize localStorage.getItem(prefix + key)
        catch e
          console.log 'Getting a value from local storage is failed.', e
          return false

    search = (query) ->
      if supported
        try
          query = query or ''
          testRegex = RegExp(query)
          _locals = {}
          for key, value of list()
            _locals[key] = value if testRegex.test(_serialize value)
          _locals
        catch e
          console.log 'Searching in local storage is failed.', e
          return false

    list = () ->
      if supported
        try
          prefixLength = prefix.length
          _locals = {}
          for key, value of localStorage
            if key.substr(0, prefixLength) is prefix
              _locals[key.substr(prefixLength)] = if _parsable value then angular.fromJson(value) else value
          _locals
        catch e
          console.log 'Getting the list of local storage values is failed.', e
          return false

    treat = ->
      ###
      store.transact = function(key, defaultVal, transactionFn) {
        var val = store.get(key)
        if (transactionFn == null) {
          transactionFn = defaultVal
          defaultVal = null
        }
        if (typeof val == 'undefined') { val = defaultVal || {} }
        transactionFn(val)
        store.set(key, val)
      }
      ###
      true

    query = ->
      ###
        store.forEach = function(callback) {
        for (var i=0; i<storage.length; i++) {
          var key = storage.key(i)
          callback(key, store.get(key))
        }
      }
      ###
      true

    remove = (key) ->
      if supported
        try
          return localStorage.removeItem prefix + key
        catch e
          console.log 'Removing a local storage value is failed.', e
          return false

    flush = () ->
      if supported
        try
          remove key for key of list()
        catch e
          console.log 'Flushing local storage values is failed.', e
          return false

    supported: supported
    set: set
    get: get
    search: search
    list: list
    treat: treat
    remove: remove
    flush: flush
  ]

  true