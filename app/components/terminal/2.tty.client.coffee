###*
# tty.js
# Copyright (c) 2012-2013, Christopher Jeffrey (MIT License)
###

(->

  ###*
  # Elements
  ###

  document = @document
  window = this
  root = undefined
  body = undefined
  h1 = undefined
  open = undefined
  lights = undefined

  ###*
  # Initial Document Title
  ###

  initialTitle = document.title

  ###*
  # Helpers
  ###

  EventEmitter = Terminal.EventEmitter
  inherits = Terminal.inherits
  cancel = Terminal.cancel

  ###*
  # tty
  ###

  tty = new EventEmitter

  ###*
  # Shared
  ###

  ###*
  # Window
  ###

  Window = ($element, socket) ->
    self = this
    EventEmitter.call this
    el = document.createElement('div')
    el.className = 'window'
    grip = document.createElement('div')
    grip.className = 'grip'
    bar = document.createElement('div')
    bar.className = 'bar'
    button = document.createElement('div')
    button.innerHTML = '~'
    button.title = 'new/close'
    button.className = 'tab'
    title = document.createElement('div')
    title.className = 'title'
    title.innerHTML = ''
    @socket = socket or tty.socket
    @element = el
    @grip = grip
    @bar = bar
    @button = button
    @title = title
    @tabs = []
    @focused = null
    @cols = Terminal.geometry[0]
    @rows = Terminal.geometry[1]
    el.appendChild grip
    el.appendChild bar
    bar.appendChild button
    bar.appendChild title
    $element.append($(el))
    tty.windows.push this
    @createTab()
    @focus()
    @bind()
    @tabs[0].once 'open', ->
      tty.emit 'open window', self
      self.emit 'open'

  ###*
  # Tab
  ###

  Tab = (win, socket) ->
    self = this
    cols = win.cols
    rows = win.rows
    Terminal.call this,
      cols: cols
      rows: rows
    button = document.createElement('div')
    button.className = 'tab'
    button.innerHTML = '•'
    win.bar.appendChild button
    Terminal.on button, 'click', (ev) ->
      if ev.ctrlKey or ev.altKey or ev.metaKey or ev.shiftKey
        self.destroy()
      else
        self.focus()
      cancel ev
    @id = ''
    @socket = socket or tty.socket
    @window = win
    @button = button
    @element = null
    @process = ''
    @open()
    @hookKeys()
    win.tabs.push this
    @socket.emit 'create', cols, rows, (err, data) ->
      if err
        return self._destroy()
      self.pty = data.pty
      self.id = data.id
      tty.terms[self.id] = self
      self.setProcessName data.process
      tty.emit 'open tab', self
      self.emit 'open'
      return
    return

  ###*
  # Helpers
  ###

  indexOf = (obj, el) ->
    i = obj.length
    while i--
      if obj[i] == el
        return i
    -1

  splice = (obj, el) ->
    i = indexOf(obj, el)
    if ~i
      obj.splice i, 1
    return

  sanitize = (text) ->
    if !text
      return ''
    (text + '').replace /[&<>]/g, ''

  ###*
  # Load
  ###

  load = ->
    if load.done
      return
    load.done = true
    Terminal.off document, 'load', load
    Terminal.off document, 'DOMContentLoaded', load
    tty.open()
    return

  tty.socket
  tty.windows
  tty.terms
  tty.elements

  ###*
  # Open
  ###

  

  tty.open = ->
    if document.location.pathname
      parts = document.location.pathname.split('/')
      base = parts.slice(0, parts.length - 1).join('/') + '/'
      resource = base.substring(1) + 'socket.io'
      tty.socket = io.connect(null, resource: resource)
      
    else
      tty.socket = io.connect()
    tty.windows = []
    tty.terms = {}
    tty.elements =
      root: document.documentElement
      body: document.body
      h1: document.getElementsByTagName('h1')[0]
      open: document.getElementById('open')
      lights: document.getElementById('lights')
    root = tty.elements.root
    body = tty.elements.body
    h1 = tty.elements.h1
    open = tty.elements.open
    lights = tty.elements.lights
    
    angular.module('app').directive 'terminal', ($timeout)->
      {
        restrict: 'C'
        link: ($scope, $element, $attrs)->
          add = ->
            new Window($element)
          $timeout add, 1000
      }
        
    if lights
      Terminal.on lights, 'click', ->
        tty.toggleLights()
        return
    tty.socket.on 'reload', ->
     location.reload()
    tty.socket.on 'connect', ->
      tty.reset()
      tty.emit 'connect'
      return
    tty.socket.on 'data', (id, data) ->
      if !tty.terms[id]
        return
      tty.terms[id].write data
      return
    tty.socket.on 'kill', (id) ->
      if !tty.terms[id]
        return
      tty.terms[id]._destroy()
      return
    # XXX Clean this up.
    tty.socket.on 'sync', (terms) ->
      console.log 'Attempting to sync...'
      console.log terms
      tty.reset()
      emit = tty.socket.emit

      tty.socket.emit = ->

      Object.keys(terms).forEach (key) ->
        data = terms[key]
        win = new Window
        tab = win.tabs[0]
        delete tty.terms[tab.id]
        tab.pty = data.pty
        tab.id = data.id
        tty.terms[data.id] = tab
        win.resize data.cols, data.rows
        tab.setProcessName data.process
        tty.emit 'open tab', tab
        tab.emit 'open'
        return
      tty.socket.emit = emit
      return
    # We would need to poll the os on the serverside
    # anyway. there's really no clean way to do this.
    # This is just easier to do on the
    # clientside, rather than poll on the
    # server, and *then* send it to the client.
    setInterval (->
      i = tty.windows.length
      while i--
        if !tty.windows[i].focused
          continue
        tty.windows[i].focused.pollProcessName()
      return
    ), 2 * 1000
    # Keep windows maximized.
    Terminal.on window, 'resize', ->
      i = tty.windows.length
      win = undefined
      while i--
        win = tty.windows[i]
        if win.minimize
          win.minimize()
          win.maximize()
      return
    tty.emit 'load'
    tty.emit 'open'
    return

  ###*
  # Reset
  ###

  tty.reset = ->
    i = tty.windows.length
    while i--
      tty.windows[i].destroy()
    tty.windows = []
    tty.terms = {}
    tty.emit 'reset'
    return

  ###*
  # Lights
  ###

  tty.toggleLights = ->
    root.className = if !root.className then 'dark' else ''
    return

  inherits Window, EventEmitter

  Window::bind = ->
    self = this
    el = @element
    bar = @bar
    grip = @grip
    button = @button
    last = 0
    Terminal.on button, 'click', (ev) ->
      if ev.ctrlKey or ev.altKey or ev.metaKey or ev.shiftKey
        self.destroy()
      else
        self.createTab()
      cancel ev

  Window::focus = ->
    # Restack
    parent = @element.parentNode
    if parent
      parent.removeChild @element
      parent.appendChild @element
    # Focus Foreground Tab
    @focused.focus()
    tty.emit 'focus window', this
    @emit 'focus'
    return

  Window::destroy = ->
    if @destroyed
      return
    @destroyed = true
    if @minimize
      @minimize()
    splice tty.windows, this
    if tty.windows.length
      tty.windows[0].focus()
    @element.parentNode.removeChild @element
    @each (term) ->
      term.destroy()
      return
    tty.emit 'close window', this
    @emit 'close'
    return

 

  Window::resizing = (ev) ->
    self = this
    el = @element
    term = @focused

    move = (ev) ->
      x = undefined
      y = undefined
      y = el.offsetHeight - (term.element.clientHeight)
      x = ev.pageX - (el.offsetLeft)
      y = ev.pageY - (el.offsetTop) - y
      el.style.width = x + 'px'
      el.style.height = y + 'px'
      return

    up = ->
      x = undefined
      y = undefined
      x = el.clientWidth / resize.w
      y = el.clientHeight / resize.h
      x = x * term.cols | 0
      y = y * term.rows | 0
      self.resize x, y
      el.style.width = ''
      el.style.height = ''
      el.style.overflow = ''
      el.style.opacity = ''
      el.style.cursor = ''
      root.style.cursor = ''
      term.element.style.height = ''
      Terminal.off document, 'mousemove', move
      Terminal.off document, 'mouseup', up
      return

    if @minimize
      delete @minimize
    resize = 
      w: el.clientWidth
      h: el.clientHeight
    el.style.overflow = 'hidden'
    el.style.opacity = '0.70'
    el.style.cursor = 'se-resize'
    root.style.cursor = 'se-resize'
    term.element.style.height = '100%'
    Terminal.on document, 'mousemove', move
    Terminal.on document, 'mouseup', up
    return

  Window::maximize = ->
    if @minimize
      return @minimize()
    self = this
    el = @element
    term = @focused
    x = undefined
    y = undefined
    m = 
      cols: term.cols
      rows: term.rows
      left: el.offsetLeft
      top: el.offsetTop
      root: root.className

    @minimize = ->
      delete @minimize
      el.style.left = m.left + 'px'
      el.style.top = m.top + 'px'
      el.style.width = ''
      el.style.height = ''
      term.element.style.width = ''
      term.element.style.height = ''
      el.style.boxSizing = ''
      self.grip.style.display = ''
      root.className = m.root
      self.resize m.cols, m.rows
      tty.emit 'minimize window', self
      self.emit 'minimize'
      return

    window.scrollTo 0, 0
    x = root.clientWidth / term.element.offsetWidth
    y = root.clientHeight / term.element.offsetHeight
    x = x * term.cols | 0
    y = y * term.rows | 0
    el.style.left = '0px'
    el.style.top = '0px'
    el.style.width = '100%'
    el.style.height = '100%'
    term.element.style.width = '100%'
    term.element.style.height = '100%'
    el.style.boxSizing = 'border-box'
    @grip.style.display = 'none'
    root.className = 'maximized'
    @resize x, y
    tty.emit 'maximize window', this
    @emit 'maximize'
    return

  Window::resize = (cols, rows) ->
    @cols = cols
    @rows = rows
    @each (term) ->
      term.resize cols, rows
      return
    tty.emit 'resize window', this, cols, rows
    @emit 'resize', cols, rows
    return

  Window::each = (func) ->
    i = @tabs.length
    while i--
      func @tabs[i], i
    return

  Window::createTab = ->
    new Tab(this, @socket)

  Window::highlight = ->
    self = this
    @element.style.borderColor = 'orange'
    setTimeout (->
      self.element.style.borderColor = ''
      return
    ), 200
    @focus()
    return

  Window::focusTab = (next) ->
    tabs = @tabs
    i = indexOf(tabs, @focused)
    l = tabs.length
    if !next
      if tabs[--i]
        return tabs[i].focus()
      if tabs[--l]
        return tabs[l].focus()
    else
      if tabs[++i]
        return tabs[i].focus()
      if tabs[0]
        return tabs[0].focus()
    @focused and @focused.focus()

  Window::nextTab = ->
    @focusTab true

  Window::previousTab = ->
    @focusTab false

  inherits Tab, Terminal
  # We could just hook in `tab.on('data', ...)`
  # in the constructor, but this is faster.

  Tab::handler = (data) ->
    @socket.emit 'data', @id, data
    return

  # We could just hook in `tab.on('title', ...)`
  # in the constructor, but this is faster.

  Tab::handleTitle = (title) ->
    if !title
      return
    title = sanitize(title)
    @title = title
    if Terminal.focus == this
      document.title = title
      # if (h1) h1.innerHTML = title;
    if @window.focused == this
      @window.bar.title = title
      # this.setProcessName(this.process);
    return

  Tab::_write = Tab::write

  Tab::write = (data) ->
    if @window.focused != this
      @button.style.color = 'red'
    @_write data

  Tab::_focus = Tab::focus

  Tab::focus = ->
    if Terminal.focus == this
      return
    win = @window
    # maybe move to Tab.prototype.switch
    if win.focused != this
      if win.focused
        if win.focused.element.parentNode
          win.focused.element.parentNode.removeChild win.focused.element
        win.focused.button.style.fontWeight = ''
      win.element.appendChild @element
      win.focused = this
      win.title.innerHTML = @process
      document.title = @title or initialTitle
      @button.style.fontWeight = 'bold'
      @button.style.color = ''
    @handleTitle @title
    @_focus()
    win.focus()
    tty.emit 'focus tab', this
    @emit 'focus'
    return

  Tab::_resize = Tab::resize

  Tab::resize = (cols, rows) ->
    @socket.emit 'resize', @id, cols, rows
    @_resize cols, rows
    tty.emit 'resize tab', this, cols, rows
    @emit 'resize', cols, rows
    return

  Tab::__destroy = Tab::destroy

  Tab::_destroy = ->
    if @destroyed
      return
    @destroyed = true
    win = @window
    @button.parentNode.removeChild @button
    if @element.parentNode
      @element.parentNode.removeChild @element
    if tty.terms[@id]
      delete tty.terms[@id]
    splice win.tabs, this
    if win.focused == this
      win.previousTab()
    if !win.tabs.length
      win.destroy()
    # if (!tty.windows.length) {
    #   document.title = initialTitle;
    #   if (h1) h1.innerHTML = initialTitle;
    # }
    @__destroy()
    return

  Tab::destroy = ->
    if @destroyed
      return
    @socket.emit 'kill', @id
    @_destroy()
    tty.emit 'close tab', this
    @emit 'close'
    return

  Tab::hookKeys = ->
    self = this
    # Alt-[jk] to quickly swap between windows.
    @on 'key', (key, ev) ->
      if Terminal.focusKeys == false
        return
      offset = undefined
      i = undefined
      if key == 'j'
        offset = -1
      else if key == 'k'
        offset = +1
      else
        return
      i = indexOf(tty.windows, @window) + offset
      @_ignoreNext()
      if tty.windows[i]
        return tty.windows[i].highlight()
      if offset > 0
        if tty.windows[0]
          return tty.windows[0].highlight()
      else
        i = tty.windows.length - 1
        if tty.windows[i]
          return tty.windows[i].highlight()
      @window.highlight()
    @on 'request paste', (key) ->
      @socket.emit 'request paste', (err, text) ->
        if err
          return
        self.send text
        return
      return
    @on 'request create', ->
      @window.createTab()
      return
    @on 'request term', (key) ->
      if @window.tabs[key]
        @window.tabs[key].focus()
      return
    @on 'request term next', (key) ->
      @window.nextTab()
      return
    @on 'request term previous', (key) ->
      @window.previousTab()
      return
    return

  Tab::_ignoreNext = ->
    # Don't send the next key.
    handler = @handler

    @handler = ->
      @handler = handler
      return

    showCursor = @showCursor

    @showCursor = ->
      @showCursor = showCursor
      return

    return

  ###*
  # Program-specific Features
  ###

  Tab.scrollable =
    irssi: true
    man: true
    less: true
    htop: true
    top: true
    w3m: true
    lynx: true
    mocp: true
  Tab::_bindMouse = Tab::bindMouse

  Tab::bindMouse = ->
    if !Terminal.programFeatures
      return @_bindMouse()
    self = this
    wheelEvent = if 'onmousewheel' of window then 'mousewheel' else 'DOMMouseScroll'
    Terminal.on self.element, wheelEvent, (ev) ->
      if self.mouseEvents
        return
      if !Tab.scrollable[self.process]
        return
      if ev.type == 'mousewheel' and ev.wheelDeltaY > 0 or ev.type == 'DOMMouseScroll' and ev.detail < 0
        # page up
        self.keyDown keyCode: 33
      else
        # page down
        self.keyDown keyCode: 34
      cancel ev
    @_bindMouse()

  Tab::pollProcessName = (func) ->
    self = this
    @socket.emit 'process', @id, (err, name) ->
      if err
        return func and func(err)
      self.setProcessName name
      func and func(null, name)
    return

  Tab::setProcessName = (name) ->
    name = sanitize(name)
    if @process != name
      @emit 'process', name
    @process = name
    @button.title = name
    if @window.focused == this
      # if (this.title) {
      #   name += ' (' + this.title + ')';
      # }
      @window.title.innerHTML = name
    return

  Terminal.on document, 'load', load
  Terminal.on document, 'DOMContentLoaded', load
  load()

  ###*
  # Expose
  ###

  tty.Window = Window
  tty.Tab = Tab
  tty.Terminal = Terminal
  @tty = tty
  return
).call do ->
  this or (if typeof window != 'undefined' then window else global)