path = require \path
require \xonom
 .run ($xonom)->
    tty = require \tty.js
    app = tty.create-server do
      port: process.env.PORT || 80
      users: []
      cwd: require('path').resolve(process.cwd!, \../demo)
      static: require(\path).resolve(__dirname, \../client)
      shell: \bash
    app.use require(\body-parser).json!
    console.log "#{__dirname}/node_modules/nixar/compiled-commands/*"
    $xonom.object \$router, app
 .run "#{__dirname}/app/**/*.service.server.js"
 .run "#{__dirname}/app/**/*.route.server.js"
 .object \p, require \prelude-ls
 .object \repo, { commands: [], docs: [] }
 .run path.resolve(__dirname, "../node_modules/nixar/compiled-commands") + \/*
 .run path.resolve(__dirname, "../node_modules/nixar/docs") + \/*
 .run "#{__dirname}/xonom.route.js"
 .run ($router)->
    $router.listen!