describe 'Store service ', ->

  # still needed?
  beforeEach module('storeModule', (StoreProvider) ->
    window.p = StoreProvider
    return
  )

  _s = undefined
  store = {}

  beforeEach inject((_Store_) ->

    _s = _Store_

    # fake a set call
    spyOn(_s, 'set').andCallFake (key, val) ->
      val = angular.toJson(val) if angular.isObject(val) or angular.isArray(val)
      val = val.toString() if angular.isNumber(val)
      store[key] = val

    # fake a get call
    spyOn(_s, 'get').andCallFake (key) ->
      if store[key].charAt(0) is '{' or store[key].charAt(0) is '['
        angular.fromJson store[key]
      else
        store[key]

    # fake a flush
    spyOn(_s, 'flush').andCallFake ->
      store = {}
      store
  )

  ###
  Specs
  ###

  # should set a prefix
  it 'should set a new prefix', ->
    expect(_s.prefixer('newPrefix')).toBe('newPrefix')

  #
  # it ''

  it 'Should add a value to my local storage', ->
    n = 234
    _s.set 'test', n
    #Since localStorage makes the value a string, we look for the '234' and not 234
    expect(_s.get('test')).toBe '234'
    obj = key: 'val'
    _s.set 'object', obj
    res = _s.get('object')
    expect(res.key).toBe 'val'


  true

