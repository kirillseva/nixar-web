module.exports = (repo, p)->
  commands: (callback)->
    repo.docs.for-each (item)->
      apply = (command)->
        command.examples = item.files
      repo.commands |> p.filter (-> it.name is item.name)
                    |> p.each apply
    callback repo.commands