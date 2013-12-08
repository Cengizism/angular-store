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
          "uglify:storage"
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
      storage:
        options:
          sourceMap: "dist/angular-storage.js.map"
          sourceMapRoot: "dist/"
          sourceMapIn: "dist/angular-storage.js.map"
        files:
          "dist/angular-storage.min.js": ["dist/angular-storage.js"]
      store:
        options:
          sourceMap: "dist/store.js.map"
          sourceMapRoot: "dist/"
          sourceMapIn: "dist/store.js.map"
        files:
          "dist/store.min.js": ["dist/store.js"]

  grunt.registerTask "default", ["watch"]