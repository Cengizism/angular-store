(function() {
  "use strict";
  angular.module("storageModule", []).provider("storageService", function() {
    this.prefix = "myApp";
    this.setPrefix = function(prefix) {
      return this.prefix = prefix;
    };
    this.$get = [
      function() {
        var all, flush, get, prefix, remove, search, set, supported, treat, _deserialize, _serialize;
        prefix = this.prefix;
        if (prefix.substr(-1) !== ".") {
          prefix = (!!prefix ? prefix + "." : "");
        }
        supported = function() {
          var e, key, _supported;
          try {
            _supported = "localStorage" in window && window["localStorage"] !== null;
            key = prefix + "__" + Math.round(Math.random() * 1e7);
            if (_supported) {
              localStorage.setItem(key, "");
              localStorage.removeItem(key);
            }
            return true;
          } catch (_error) {
            e = _error;
            return false;
          }
        };
        _serialize = function(value) {
          if (value == null) {
            value = null;
          }
          if (angular.isObject(value) || angular.isArray(value)) {
            value = angular.toJson(value);
          }
          return value;
        };
        _deserialize = function(value) {
          if (!value || value === "null") {
            value = null;
          }
          if (value != null) {
            if (value.charAt(0) === "{" || value.charAt(0) === "[") {
              angular.fromJson(value);
            }
          }
          return value;
        };
        set = function(key, value) {
          var e;
          if (supported) {
            try {
              return localStorage.setItem(prefix + key, _serialize(value));
            } catch (_error) {
              e = _error;
              return false;
            }
          }
        };
        get = function(key) {
          if (supported) {
            return _deserialize(localStorage.getItem(prefix + key));
          }
        };
        search = function() {
          return true;
        };
        all = function() {
          var e, key, prefixLength, _locals;
          if (supported) {
            prefixLength = prefix.length;
            _locals = [];
            for (key in localStorage) {
              if (key.substr(0, prefixLength) === prefix) {
                try {
                  _locals.push(key.substr(prefixLength));
                } catch (_error) {
                  e = _error;
                  return [];
                }
              }
            }
            return _locals;
          }
        };
        treat = function() {
          return true;
        };
        remove = function(key) {
          var e;
          if (supported) {
            try {
              return localStorage.removeItem(prefix + key);
            } catch (_error) {
              e = _error;
              return false;
            }
          }
        };
        flush = function(regularExpression) {
          var e, key, prefixLength, tempPrefix, testRegex;
          if (supported) {
            regularExpression = regularExpression || "";
            tempPrefix = prefix.slice(0, -1) + ".";
            testRegex = RegExp(tempPrefix + regularExpression);
            prefixLength = prefix.length;
            for (key in localStorage) {
              if (testRegex.test(key)) {
                try {
                  remove(key.substr(prefixLength));
                } catch (_error) {
                  e = _error;
                  return false;
                }
              }
            }
          }
        };
        return {
          supported: supported,
          set: set,
          get: get,
          search: search,
          all: all,
          treat: treat,
          remove: remove,
          flush: flush
        };
      }
    ];
    return true;
  });

}).call(this);

/*
//@ sourceMappingURL=angular-storage.js.map
*/