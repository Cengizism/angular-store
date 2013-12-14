'use strict'

angular.module('storeModule', []).provider 'Store', ->

  # default prefix value
  @prefix = 'myApp'

  @$get = [() ->

    # work on prefix values
    prefix = @prefix
    prefix = (if !!prefix then prefix + '.' else '')  if prefix.substr(-1) isnt '.'

    # serialize values
    _serialize = (value) ->
      value = null unless value?
      value = angular.toJson value if angular.isObject value or angular.isArray value
      value

    # check whether the strings are parsable
    _parsable = (value) ->
      true if value.charAt(0) is '{' or value.charAt(0) is '['

    # parse the strings
    _deserialize = (value) ->
      value = null if not value or value is 'null'
      if value? then angular.fromJson value if _parsable value
      value

    # set prefixes
    prefixer = (name) ->
      if supported
        try
          prefix = name
        catch e
          console.log 'Prefix name could not be set.', e
          return false

    # check if the localStorage is supported
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

    # set a localStorage value
    set = (key, value) ->
      if supported
        try
          localStorage.setItem prefix + key, _serialize value
          return true
        catch e
          console.log 'Setting a value in local storage is failed.', e
          return false

    # get a localStorage value
    get = (key) ->
      if supported
        try
          return _deserialize localStorage.getItem(prefix + key)
        catch e
          console.log 'Getting a value from local storage is failed.', e
          return false

    # check whether a give key exists in localStorage
    exists = (key) ->
      if supported
        try
          if get(key)? then return true else return false
        catch e
          console.log 'Something bad happened with checking on an existing key', e
          return false

    # all all prefixed localStorage values
    list = () ->
      if supported
        try
          prefixLength = prefix.length
          _locals = {}
          for key, value of localStorage
            if key.substr(0, prefixLength) is prefix
              _locals[key.substr(prefixLength)] = if _parsable value then angular.fromJson value else value
          _locals
        catch e
          console.log 'Getting the list of local storage values is failed.', e
          return false

    # search in localStorage for a given query (only in values)
    search = (query) ->
      if supported
        try
          query = query or ''
          testRegex = RegExp query
          _locals = {}
          for key, value of list()
            _locals[key] = value if testRegex.test _serialize value
          _locals
        catch e
          console.log 'Searching in local storage is failed.', e
          return false

    # grab prefixed keys based on a given query
    name = (query) ->
      if supported
        try
          query = query or ''
          testRegex = RegExp query
          _locals = []
          for key of list()
            _locals.push key if testRegex.test key
          _locals
        catch e
          console.log 'Grabbing keys in local storage is failed.', e
          return false

    # transact with localStorage value with given modifier function
    treat = (key, fn) ->
      if supported
        try
          if fn
            val = this.get(key)
            this.set key, fn(val)
        catch e
          console.log 'Treating the given key is failed.', e
          return false
      true

    # remove any localStorage value
    remove = (key) ->
      if supported
        try
          return localStorage.removeItem prefix + key
        catch e
          console.log 'Removing a local storage value is failed.', e
          return false

    # flush all prefixed localStoage values
    flush = () ->
      if supported
        try
          remove key for key of list()
        catch e
          console.log 'Flushing (prefixed) local storage values is failed.', e
          return false

    # clear everything in localStorage
    nuke = () ->
      if supported
        try
          localStorage.removeItem key for key of localStorage
        catch e
          console.log 'Flushing all local storage values is failed.', e
          return false

    prefixer: prefixer
    supported: supported
    set: set
    get: get
    exists: exists
    list: list
    search: search
    name: name
    treat: treat
    remove: remove
    flush: flush
    nuke: nuke
  ]

  true