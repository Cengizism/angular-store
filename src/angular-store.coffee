"use strict"

angular.module("storageModule", []).provider "storageService", ->

  @prefix = "myApp"

  @setPrefix = (prefix) ->
    @prefix = prefix

  @$get = [() ->
    prefix = @prefix
    prefix = (if !!prefix then prefix + "." else "")  if prefix.substr(-1) isnt "."

    supported = ->
      try
        _supported = ("localStorage" of window and window["localStorage"] isnt null)
        key = prefix + "__" + Math.round(Math.random() * 1e7)
        if _supported
          localStorage.setItem key, ""
          localStorage.removeItem key
        return true
      catch e
        return false

    _serialize = (value) ->
      value = null unless value?
      value = angular.toJson(value) if angular.isObject(value) or angular.isArray(value)
      value

    _deserialize = (value) ->
      value = null if not value or value is "null"
      if value? then angular.fromJson(value) if value.charAt(0) is "{" or value.charAt(0) is "["
      value

    set = (key, value) ->
      if supported
        try
          return localStorage.setItem prefix + key, _serialize value
        catch e
          return false

    get = (key) ->
      if supported
        _deserialize localStorage.getItem(prefix + key)

    search = (query) ->
      if supported
        query = query or ""
        testRegex = RegExp(query)
        _locals = {}
        for key, value of list()
          _locals[key] = value if testRegex.test(_serialize value)
        _locals

    list = () ->
      if supported
        prefixLength = prefix.length
        _locals = {}
        for key, value of localStorage
          if key.substr(0, prefixLength) is prefix
            try
              _locals[key.substr(prefixLength)] =
                if value.charAt(0) is "{" or value.charAt(0) is "["
                then angular.fromJson(value) else value
            catch e
              return []
        _locals

    treat = ->
      true

    remove = (key) ->
      if supported
        try
          return localStorage.removeItem prefix + key
        catch e
          return false

    flush = (regularExpression) ->
      if supported
        regularExpression = regularExpression or ""
        tempPrefix = prefix.slice(0, -1) + "."
        testRegex = RegExp(tempPrefix + regularExpression)
        prefixLength = prefix.length
        for key of localStorage
          if testRegex.test(key)
            try
              remove key.substr(prefixLength)
            catch e
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