(function() {
  var doc, e, isLocalStorageNameSupported, localStorageName, scriptTag, storage, store, testKey;

  isLocalStorageNameSupported = function() {
    var err;
    try {
      return localStorageName in window && window[localStorageName];
    } catch (_error) {
      err = _error;
      return false;
    }
  };

  store = {};

  doc = window.document;

  localStorageName = "localStorage";

  scriptTag = "script";

  storage = void 0;

  store.disabled = false;

  store.set = function(key, value) {};

  store.get = function(key) {};

  store.remove = function(key) {};

  store.clear = function() {};

  store.transact = function(key, defaultVal, transactionFn) {
    var val;
    val = store.get(key);
    if (transactionFn == null) {
      transactionFn = defaultVal;
      defaultVal = null;
    }
    if (typeof val === "undefined") {
      val = defaultVal || {};
    }
    transactionFn(val);
    return store.set(key, val);
  };

  store.getAll = function() {};

  store.forEach = function() {};

  store.serialize = function(value) {
    return JSON.stringify(value);
  };

  store.deserialize = function(value) {
    var e;
    if (typeof value !== "string") {
      return undefined;
    }
    try {
      return JSON.parse(value);
    } catch (_error) {
      e = _error;
      return value || undefined;
    }
  };

  storage = window[localStorageName];

  store.set = function(key, val) {
    if (val === undefined) {
      return store.remove(key);
    }
    storage.setItem(key, store.serialize(val));
    return val;
  };

  store.get = function(key) {
    return store.deserialize(storage.getItem(key));
  };

  store.remove = function(key) {
    return storage.removeItem(key);
  };

  store.clear = function() {
    return storage.clear();
  };

  store.getAll = function() {
    var ret;
    ret = {};
    store.forEach(function(key, val) {
      return ret[key] = val;
    });
    return ret;
  };

  store.forEach = function(callback) {
    var i, key, _results;
    i = 0;
    _results = [];
    while (i < storage.length) {
      key = storage.key(i);
      callback(key, store.get(key));
      _results.push(i++);
    }
    return _results;
  };

  try {
    testKey = "__storejs__";
    store.set(testKey, testKey);
    if (store.get(testKey) !== testKey) {
      store.disabled = true;
    }
    store.remove(testKey);
  } catch (_error) {
    e = _error;
    store.disabled = true;
  }

  store.enabled = !store.disabled;

  if (typeof module !== "undefined" && module.exports) {
    module.exports = store;
  } else if (typeof define === "function" && define.amd) {
    define(store);
  } else {
    window.store = store;
  }

}).call(this);

/*
//@ sourceMappingURL=store.js.map
*/