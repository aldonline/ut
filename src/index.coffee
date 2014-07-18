
interval = -> setInterval arguments[1], arguments[0]
delay    = -> setTimeout  arguments[1], arguments[0]

email_re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

LIPSUM = 'Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas faucibus mollis interdum. Cras mattis consectetur purus sit amet fermentum. Nullam id dolor id nibh ultricies vehicula ut id elit.'

module.exports =
  
  say_hello: ( name ) -> "Hello #{name}!"
  
  delay:    delay
  
  interval: interval

  unbox_arr: ( v ) -> if v instanceof Array then v[0] else v
  unbox_func: ( v ) -> if typeof v is 'function' then v() else v

  arr:    ( arrayish ) -> Array::slice.apply arrayish, null

  arrdiff: ( arr1, arr2 ) ->
    onlyin1 = ( e for e in arr1 when e not in arr2 )
    onlyin2 = ( e for e in arr2 when e not in arr1 )
    [onlyin1, onlyin2]

  arr_builder: ( f )   -> arr = [] ; (f ( x ) -> arr.push x) ; arr

  lipsum: ( len = 0 ) -> if len is 0 then LIPSUM else LIPSUM.substring 0, len

  obj_empty: ( obj ) ->
    if obj?
      return no for own k, v of obj
    yes

  getter: ( prop ) -> 'get' + prop[0].toUpperCase() + prop[1..]
  setter: ( prop ) -> 'set' + prop[0].toUpperCase() + prop[1..]


  kv: kv = ( obj, func ) ->
    if obj?
      for own k, v of obj
        func k, v

  kkv: ( obj, func ) -> kv obj, (k, v) -> kv v, (k2, v2) -> func k, k2, v2

  err: ( e ) ->
    if e?
      console.log e
      console.log e.stack
      throw e

  # removes null or undefined values
  collapse_arr: ( arr ) ->
    ( x for x in arr when not null_or_undefined x )

  null_or_undefined: null_or_undefined = ( v ) ->
    switch typeof v
      when 'undefined'
        yes
      when 'object'
        not v?
      else
        no

  when_not_falsy: ( f1, f2 ) ->
    iv = interval 100, ->
      if f1()?
        clearInterval iv
        f2()

  tap: ( v ) ->
    console.log v
    v

  first_key: ( obj ) -> return k for k, v of obj
  
  first_own_key: ( obj ) -> return k for own k, v of obj
  
  lazy: ( f ) ->
    res_ready = false
    res = null
    ->
      if res_ready
        res
      else
        res_ready = yes
        res = f()
        res

  clone: (obj) ->
    o = {}
    o[k] = v for own k, v of obj
    o

  insist: ( times, interval_, f ) ->
    count = 0
    do x = ->
      try
        f()
      catch e
        count += 1
        if count < times
          delay interval_, x

  valid_email: ( v ) -> typeof v is 'string' and email_re.test v 
  
  email_re: email_re

  ###
  to get rid of 'return cb e if e?'

  func1 = ( a, cb ) ->
    func2 ( e, r ) ->
      return cb e if e?
      console.log r

  func1 = ( a, cb ) ->
    func2 ( cbe cb ) ( e, r ) ->
      console.log r
  ###
  cbe: (done) -> (cb) -> ->
    if arguments[0]?
      done arguments[0]
    else
      cb.apply null, arguments

  assert_type: (type, v, message) ->
    message ?= "Expected #{v} to be a " + type
    throw new Error message unless typeof v is type

