module.exports = (karma) ->
  "use strict"
  karma.set
    frameworks: ["jasmine"]
    basePath: "test/"
    autoWatch: true
    exclude: []
    reporters: ["progress"]
    port: 8080
    runnerPort: 9100
    colors: true
    logLevel: karma.LOG_INFO
    browsers: ["PhantomJS"]
    files: [
      "vendors/angular/angular.js",
      "vendors/angular-mocks/angular-mocks.js",
      "../dist/angular-store.js",
      "specs/*.js"
    ]
    singleRun: false
    captureTimeout: 5000
    plugins: [
      "karma-jasmine"
      "karma-chrome-launcher"
      "karma-firefox-launcher"
      "karma-phantomjs-launcher"
    ]