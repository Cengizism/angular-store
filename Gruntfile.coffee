"use strict"

markdown = require("marked")
semver = require("semver")

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
    changelog:
      options:
        dest: "CHANGELOG.md"
        versionFile: "package.json"
    release:
      options:
        commitMessage: "<%= version %>"
        tagName: "v<%= version %>"
        tagMessage: "tagging version <%= version %>"
        bump: false
        file: "package.json"
        add: true
        commit: true
        tag: true
        push: true
        pushTags: true
        npm: false
    stage:
      options:
        files: ["CHANGELOG.md"]

  grunt.registerTask "bump", "bump manifest version", (type) ->
    setup = (file, type) ->
      pkg = grunt.file.readJSON(file)
      newVersion = pkg.version = semver.inc(pkg.version, type or "patch")
      file: file
      meta: pkg
      newVersion: newVersion
    options = @options(file: grunt.config("pkgFile") or "package.json")
    config = setup(options.file, type)
    grunt.file.write config.file, JSON.stringify(config.meta, null, "  ") + "\n"
    grunt.log.ok "Version bumped to " + config.newVersion

  grunt.registerTask "stage", "git add files before running the release task", ->
    files = @options().files
    grunt.util.spawn
      cmd: (if process.platform is "win32" then "git.cmd" else "git")
      args: ["add"].concat(files)
    , grunt.task.current.async()

  grunt.registerTask "default", ["watch"]

  grunt.registerTask "patch", [
    "bump:patch"
    "changelog"
    "stage"
    "release:patch"
  ]

  grunt.registerTask "minor", [
    "bump:minor"
    "changelog"
    "stage"
    "release:minor"
  ]

  grunt.registerTask "major", [
    "bump:major"
    "changelog"
    "stage"
    "release:major"
  ]