describe('Store service ', function() {
  var store, _s;
  beforeEach(module('storeModule', function(StoreProvider) {
    window.p = StoreProvider;
  }));
  _s = void 0;
  store = {};
  beforeEach(inject(function(_Store_) {
    _s = _Store_;
    spyOn(_s, 'set').andCallFake(function(key, val) {
      if (angular.isObject(val) || angular.isArray(val)) {
        val = angular.toJson(val);
      }
      if (angular.isNumber(val)) {
        val = val.toString();
      }
      return store[key] = val;
    });
    spyOn(_s, 'get').andCallFake(function(key) {
      if (store[key].charAt(0) === '{' || store[key].charAt(0) === '[') {
        return angular.fromJson(store[key]);
      } else {
        return store[key];
      }
    });
    return spyOn(_s, 'flush').andCallFake(function() {
      store = {};
      return store;
    });
  }));
  /*
  Specs
  */

  it('should set a new prefix', function() {
    return expect(_s.prefixer('newPrefix')).toBe('newPrefix');
  });
  it('Should add a value to my local storage', function() {
    var n, obj, res;
    n = 234;
    _s.set('test', n);
    expect(_s.get('test')).toBe('234');
    obj = {
      key: 'val'
    };
    _s.set('object', obj);
    res = _s.get('object');
    return expect(res.key).toBe('val');
  });
  return true;
});
