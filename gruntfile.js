// Generated by LiveScript 1.3.1
(function(){
  module.exports = function(grunt){
    var convertMapping, makePair, mapping, key, getCompiled, loadModuleFirst, separate, live, liveModules, liveOther, coffee, ts, coffeeModules, coffeeOther, tsModules, tsOther, files, path, js, staf, bower, app, npmTasks, i$, len$, task, load;
    convertMapping = function(file){
      var ref$;
      return ref$ = {}, ref$[".compiled/" + file.dest] = file.src[0], ref$;
    };
    makePair = function(from, to){
      return grunt.file.expandMapping(["app/components/**/*" + from, "./*" + from, "app/*" + from], "", {
        ext: to,
        extDot: 'last'
      }).map(convertMapping);
    };
    mapping = [
      {
        to: '.js',
        from: ['.ls', '.coffee', '.ts', '.js']
      }, {
        to: '.css',
        from: ['.css', 'sass']
      }, {
        to: '.html',
        from: ['.html', '.jade']
      }
    ];
    key = function(o){
      return Object.keys(o)[0];
    };
    getCompiled = function(to){
      return mapping.filter(function(it){
        return it.to === to;
      })[0].from.map(function(from){
        return makePair(from, to).map(key);
      }).reduce(function(a, b){
        return a.concat(b);
      }).map(function(it){
        return __dirname + '/' + it;
      });
    };
    require('time-grunt')(grunt);
    loadModuleFirst = function(x){
      switch (false) {
      case !(Object.keys(x)[0].indexOf('module') > -1):
        return -1;
      default:
        return 0;
      }
    };
    separate = function(arr, returnMods){
      return arr.filter(function(it){
        return Object.keys(it)[0].indexOf('module') > -1 === returnMods;
      });
    };
    live = makePair('.ls', '.js');
    liveModules = separate(live, true);
    liveOther = separate(live, false);
    coffee = makePair('.coffee', '.js');
    ts = makePair('.ts', '.js');
    coffeeModules = separate(coffee, true);
    coffeeOther = separate(coffee, false);
    tsModules = separate(ts, true);
    tsOther = separate(ts, false);
    files = {
      live: liveModules.concat(liveOther),
      coffee: coffeeModules.concat(coffeeOther),
      ts: tsModules.concat(tsOther),
      jade: makePair('.jade', '.html'),
      sass: makePair('.sass', '.css')
    };
    console.log("html", getCompiled('.html').filter(function(it){
      return it.indexOf('app/index') === -1;
    }));
    path = (js = function(it){
      return "client/js/" + it;
    }, {
      app: js('app.js'),
      appStyle: '.compiled/app/index.css',
      appModule: '.compiled/app/index.js',
      templates: js('app_templates.js')
    });
    grunt.initConfig({
      sass: {
        no_options: {
          files: files.sass
        }
      },
      jade: {
        html: {
          files: files.jade,
          options: {
            client: false,
            wrap: false,
            node: false,
            runtime: false
          }
        }
      },
      ngAnnotate: {
        options: {
          singleQuotes: true
        },
        app1: {
          files: getCompiled('.js').filter(function(it){
            return it.indexOf('client.js') > -1;
          }).map(function(it){
            var ref$;
            return ref$ = {}, ref$[it + ""] = [it], ref$;
          })
        }
      },
      ngtemplates: {
        app: {
          src: ".compiled/app/components/**/*.html",
          dest: path.templates,
          options: {
            url: function(url){
              return url.replace('.html', '').replace(/.+\//i, '');
            },
            bootstrap: function(module, script){
              return "angular.module('app').run(['$templateCache',function($templateCache) { " + script + " }])";
            }
          }
        }
      },
      ts: {
        options: {
          bare: true
        },
        src: files.ts
      },
      livescript: {
        options: {
          bare: true
        },
        src: {
          files: files.live
        }
      },
      coffee: {
        options: {
          bare: true
        },
        src: {
          files: files.coffee
        }
      },
      bower: {
        install: {}
      },
      bower_concat: {
        all: {
          dest: 'lib/_bower.js',
          cssDest: 'lib/_bower.css',
          dependencies: {},
          bowerOptions: {
            relative: false
          }
        }
      },
      concat: {
        basic: {
          src: [
            staf = ['lib/_bower.js', path.appModule, '.compiled/xonom.service.js', path.templates], js = getCompiled(".js").filter(function(it){
              return it.indexOf('client.js') > -1;
            }), staf.concat(js)
          ],
          dest: path.app,
          options: {
            banner: "(function( window ){ \n 'use strict';",
            footer: "}( window ));"
          }
        },
        extra: {
          src: (bower = ['lib/_bower.css'], app = getCompiled(".css"), bower.concat(app)),
          dest: 'client/css/app.css'
        }
      },
      min: {
        dist: {
          src: ['client/js/app.js'],
          dest: 'client/js/app.js'
        }
      },
      copy: {
        main: {
          files: [
            {
              expand: false,
              src: ['.compiled/app/index.html'],
              dest: 'client/index.html'
            }, {
              expand: true,
              cwd: '',
              src: 'app/components/**/*.js',
              dest: '.compiled',
              flatten: false,
              filter: 'isFile'
            }, {
              expand: true,
              cwd: '',
              src: 'app/components/**/*.css',
              dest: '.compiled',
              flatten: false,
              filter: 'isFile'
            }, {
              expand: true,
              cwd: '',
              src: 'app/components/**/*.html',
              dest: '.compiled',
              flatten: false,
              filter: 'isFile'
            }
          ]
        }
      },
      removelogging: {
        dist: {
          src: "js/application.js",
          dest: "js/application-clean.js"
        }
      },
      watch: {
        scripts: {
          files: ['app/**/*.*'],
          tasks: ['newer:sass', 'newer:jade', 'newer:livescript', 'newer:coffee', 'xonom', 'copy', 'ngtemplates', 'concat:basic', 'concat:extra', 'shell:start', 'clean'],
          options: {
            spawn: false,
            livereload: false
          }
        }
      },
      clean: {
        build: {
          src: ['client/js/app_templates.js']
        }
      },
      open: {
        dev: {
          path: 'http://127.0.0.1:80',
          app: 'google-chrome'
        }
      },
      xonom: {
        options: {
          input: {
            controllers: getCompiled(".js").filter(function(it){
              return it.indexOf('api.server.js') > -1;
            })
          },
          output: {
            angularService: '.compiled/xonom.service.js',
            expressRoute: '.compiled/xonom.route.js'
          }
        }
      },
      shell: {
        start: {
          command: 'killall -9 node; cd .compiled; forever stop server.js; forever start server.js'
        },
        node: {
          command: 'killall -9 node; node .compiled/server.js'
        }
      },
      newer: {
        options: {
          cache: '.cache'
        }
      }
    });
    npmTasks = [
      {
        load: 'bower-task',
        register: 'bower',
        configs: ['default']
      }, {
        load: 'bower-concat',
        register: 'bower_concat',
        configs: ['default']
      }, {
        load: 'ts',
        register: 'ts',
        configs: []
      }, {
        load: 'livescript',
        register: 'livescript',
        configs: ['default', 'dist', 'debug']
      }, {
        load: 'contrib-coffee',
        register: 'coffee',
        configs: ['default']
      }, {
        load: 'contrib-jade',
        register: 'jade',
        configs: ['default', 'dist', 'debug']
      }, {
        load: 'ng-constant',
        register: 'ngconstant',
        configs: ['dist']
      }, {
        load: 'angular-templates',
        register: 'ngtemplates',
        configs: ['default', 'dist', 'debug']
      }, {
        load: 'contrib-sass',
        register: 'sass:no_options',
        configs: ['default', 'dist', 'debug']
      }, {
        load: 'contrib-copy',
        register: 'copy',
        configs: ['default', 'debug']
      }, {
        load: 'xonom',
        register: 'xonom',
        configs: ['default', 'debug']
      }, {
        load: 'ng-annotate',
        register: 'ngAnnotate',
        configs: ['default', 'debug']
      }, {
        load: 'contrib-concat',
        register: 'concat',
        configs: ['default', 'debug']
      }, {
        load: 'contrib-uglify',
        register: 'uglify',
        configs: []
      }, {
        load: 'yui-compressor',
        register: 'min',
        configs: []
      }, {
        load: 'shell',
        register: 'shell:start',
        configs: ['default']
      }, {
        load: 'shell',
        register: 'shell:node',
        configs: ['debug']
      }, {
        load: 'aws-s3',
        register: 'aws_s3',
        configs: ['dist']
      }, {
        load: 'contrib-clean',
        register: 'clean',
        configs: ['default', 'debug', []]
      }, {
        load: 'open',
        register: 'open',
        configs: [[]]
      }, {
        load: 'contrib-watch',
        register: 'watch',
        configs: ['default']
      }
    ];
    for (i$ = 0, len$ = npmTasks.length; i$ < len$; ++i$) {
      task = npmTasks[i$];
      grunt.loadNpmTasks("grunt-" + task.load);
    }
    load = function(name){
      return grunt.registerTask(name, npmTasks.filter(function(it){
        return it.configs.indexOf(name) > -1;
      }).map(function(it){
        return it.register;
      }));
    };
    grunt.loadNpmTasks('grunt-newer');
    load('default');
    return load('debug');
  };
}).call(this);
