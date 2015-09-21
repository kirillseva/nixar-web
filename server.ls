path = require \path
require \xonom
 .run ($xonom)->
    tty = require \tty.js
    console.log \1
    app = tty.create-server do
      port: process.env.PORT || 80
      users: []
      cwd: require('path').resolve(process.cwd!, \../demo)
      static: require(\path).resolve(__dirname, \../client)
      shell: \bash
    app.use require(\body-parser).json!
    $xonom.object \$router, app
    console.log \2
 .run "#{__dirname}/app/**/*.service.server.js"
 .run ->
    console.log \3
 .run "#{__dirname}/app/**/*.route.server.js"
 .object \p, require \prelude-ls
 .object \repo, { commands: [], docs: [] }
  .run ->
    console.log \4
 .run path.resolve(__dirname, "../node_modules/nixar/compiled-commands") + \/*
  .run ->
    console.log \5
 .run path.resolve(__dirname, "../node_modules/nixar/docs") + \/*
  .run ->
    console.log \6
 .run "#{__dirname}/xonom.route.js"
 .run ($router)->
    #console.log \current_directory, __dirname, 'listen', $router
    $router.listen!