describe("Tests functionality of the localStorage module", function() {
  var ls, store;
  beforeEach(module("storeModule", function(StoreProvider) {
    window.p = StoreProvider;
  }));
  ls = void 0;
  store = [];
  beforeEach(inject(function(_Store_) {
    ls = _Store_;
    spyOn(ls, "get").andCallFake(function(key) {
      if (store[key].charAt(0) === "{" || store[key].charAt(0) === "[") {
        return angular.fromJson(store[key]);
      } else {
        return store[key];
      }
    });
    spyOn(ls, "set").andCallFake(function(key, val) {
      if (angular.isObject(val) || angular.isArray(val)) {
        val = angular.toJson(val);
      }
      if (angular.isNumber(val)) {
        val = val.toString();
      }
      return store[key] = val;
    });
    return spyOn(ls, "flush").andCallFake(function() {
      store = {};
      return store;
    });
  }));
  it("Should add a value to my local storage", function() {
    var n, obj, res;
    n = 234;
    ls.set("test", n);
    expect(ls.get("test")).toBe("234");
    obj = {
      key: "val"
    };
    ls.set("object", obj);
    res = ls.get("object");
    return expect(res.key).toBe("val");
  });
  it("Should allow me to set a prefix", function() {
    ls.prefixer("myPref");
    return expect(p.prefix).toBe("myPref");
  });
  it("Should be both true", function() {
    return expect(true).toBe(true);
  });
  return true;
});
