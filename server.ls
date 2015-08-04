require \xonom
 .object \$config, require(\./../config.json)
 .run ($xonom)->
    tty = require \tty.js
    app = tty.create-server do
      port: 8080
      users: []
      cwd: require('path').resolve(process.cwd!, \../demo)
      static: require(\path).resolve(__dirname, \../client)
      shell: \bash
    $xonom.object \$router, app
    #router.use require(\body-parser).json!
 .run "#__dirname/app/**/*.service.server.js"
 .run "#__dirname/app/**/*.route.server.js"
 .run "#__dirname/xonom.route.js"
 .run ($router, $config)->
    $router.listen!