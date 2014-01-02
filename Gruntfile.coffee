module.exports = (grunt) ->
  highlight = (code, lang) ->
    if not lang
      return hljs.highlightAuto(code).value

    try
      return hljs.highlight(lang, code).value
    catch e
      grunt.log.error 'Failed to compile code as language "' + lang + '"; attempting to guess language instead.'
      return hljs.highlightAuto(code).value

  snippets = {}
  grunt.file.setBase 'src/snippets'
  for file in grunt.file.expand '*'
    snippets[file] = grunt.file.read file, encoding:'utf-8'
  console.log snippets
  grunt.file.setBase '../..'

  config =
    HOSTNAME: process.env.HOSTNAME || '0.0.0.0'
    PORT: process.env.PORT || 3000

    watch:
      options:
        livereload: true
      stylus:
        files: 'src/**/*.styl'
        tasks: 'stylus'
      jade:
        files: 'src/**/*.jade'
        tasks: 'jade'
      copy:
        files: ['src/img/*', 'src/**/*.json']
        tasks: 'copy'
      statics:
        files: [
          'dist/**/*.html'
          'dist/**/*.css'
          'dist/**/*.js'
          'dist/**/*.json'
        ]

    jade:
      options:
        data:
          snippets: snippets
      build:
        expand: true
        cwd: 'src'
        src: '**/*.jade'
        dest: 'dist'
        ext: '.html'

    stylus:
      build:
        expand: true
        cwd: 'src'
        src: '**/*.styl'
        dest: 'dist'
        ext: '.css'

    copy:
      main:
        expand: true
        cwd: 'src'
        src: ['img/**', '**/*.json']
        dest: 'dist'

    connect:
      server:
        options:
          port: '<%= PORT %>'
          hostname: '<%= HOSTNAME %>'
          base: 'dist'
          directory: 'dist'
          livereload: true

    open:
      hack:
        path: 'http://<%= HOSTNAME %>:<%= PORT %>'

  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-open'

  grunt.registerTask 'default', ['jade', 'stylus', 'copy']
  grunt.registerTask 'hack', ['default', 'connect:server', 'open:hack', 'watch']
