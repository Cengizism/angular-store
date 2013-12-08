"use strict"

module.exports = (grunt) ->

  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  grunt.initConfig
    watch:
      coffee:
        files: ["src/*.coffee"]
        tasks: [
          "coffee:dist"
          "uglify:store"
        ]
    coffee:
      dist:
        files: [
          expand: true
          cwd: "src"
          src: "*.coffee"
          dest: "dist"
          ext: ".js"
        ]
        options:
          sourceMap: true
          sourceRoot: "dist"
    uglify:
      store:
        options:
          sourceMap: "dist/angular-store.js.map"
          sourceMapRoot: "dist/"
          sourceMapIn: "dist/angular-store.js.map"
        files:
          "dist/angular-store.min.js": ["dist/angular-store.js"]

  grunt.registerTask "default", ["watch"]