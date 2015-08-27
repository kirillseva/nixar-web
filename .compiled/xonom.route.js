module.exports = function($router, $xonom) {
var make = function (func){
          return function(req, resp){
            var body, ref$;
            body = (ref$ = req.body) != null
              ? ref$
              : [];
            body.push(function(result){
              return resp.send({
                result: result
              });
            });
            func.apply(this, body);
          };
        };
 var app = $xonom.require('/home/ubuntu/workspace/.compiled/app/components/app/app.api.server.js');
 $router.post('/app/test', make(app.test));
 var doc = $xonom.require('/home/ubuntu/workspace/.compiled/app/components/doc/doc.api.server.js');
 $router.post('/doc/commands', make(doc.commands)); 
}