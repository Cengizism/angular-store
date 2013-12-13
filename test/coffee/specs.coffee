describe "Tests functionality of the localStorage module", ->

  beforeEach module("storeModule", (StoreProvider) ->
    window.p = StoreProvider
    return
  )

  ls = undefined
  store = []

  beforeEach inject((_Store_) ->

    ls = _Store_

    spyOn(ls, "get").andCallFake (key) ->
      if store[key].charAt(0) is "{" or store[key].charAt(0) is "["
        angular.fromJson store[key]
      else
        store[key]

    spyOn(ls, "set").andCallFake (key, val) ->
      val = angular.toJson(val)  if angular.isObject(val) or angular.isArray(val)
      val = val.toString()  if angular.isNumber(val)
      store[key] = val

    spyOn(ls, "flush").andCallFake ->
      store = {}
      store
  )


  it "Should add a value to my local storage", ->
    n = 234
    ls.set "test", n
    #Since localStorage makes the value a string, we look for the '234' and not 234
    expect(ls.get("test")).toBe "234"
    obj = key: "val"
    ls.set "object", obj
    res = ls.get("object")
    expect(res.key).toBe "val"


  it "Should allow me to set a prefix", ->
    ls.prefixer "myPref"
    expect(p.prefix).toBe "myPref"


  it "Should be both true", ->
    expect(true).toBe true

  true

