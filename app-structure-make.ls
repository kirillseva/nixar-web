const recursive = 
  require \recursive-readdir
const fs = 
  require \fs

const only-important-types = (path)->
  | path.match("c9") => no
  | path.match("node_modules") => no
  | path.match("bower_components") => no
  | path.match("lib") => no
  | path.match(\sass$) => yes
  | path.match(\jade$) => yes
  | path.match(\ls$) => yes
  | path.match(\coffee$) => yes
  | path.match(\ts) => yes
  | _ => no
  
  

recursive \., (err, files)->
  fs.write-file do 
    * \./.compiled/app-structure.json
    * files.filter(only-important-types) |> JSON.stringify
    