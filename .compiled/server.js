// Generated by LiveScript 1.3.1
var path;
path = require('path');
require('xonom').run(function($xonom){
  var tty, app;
  tty = require('tty.js');
  app = tty.createServer({
    port: process.env.PORT || 80,
    users: [],
    cwd: require('path').resolve(process.cwd(), '../demo'),
    'static': require('path').resolve(__dirname, '../client'),
    shell: 'bash'
  });
  app.use(require('body-parser').json());
  app.get('doc', function(req, resp){
    return resp.redirect('/#doc');
  });
  return $xonom.object('$router', app);
}).run(__dirname + "/app/**/*.service.server.js").run(__dirname + "/app/**/*.route.server.js").object('p', require('prelude-ls')).object('repo', {
  commands: [],
  docs: []
}).run(path.resolve(__dirname, "../node_modules/nixar/compiled-commands") + '/*').run(path.resolve(__dirname, "../node_modules/nixar/docs") + '/*').run(__dirname + "/xonom.route.js").run(function($router){
  return $router.listen();
});