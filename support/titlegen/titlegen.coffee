config =
  min_word_count: 2
  max_word_count: 16
  max_attempts: 20
  splitter: /(\s|'s|[:!?]\s)/
  transform: (title) ->
    title.replace /\s('s|[:!?])/g, '$1'

titles = []
states = {}

feed = (_titles) ->
  states =
    __BEGIN__:
      t:1
      p: '__END__': 1
    __END__:
      t:0
      p: {}

  titles = _titles

  for title,i in titles
    title = titles[i] = title.trim()
    continue  if title.length is 0

    words = (word.trim() for word in title.split(config.splitter) when word.trim().length > 0)

    first = true
    for word,i in words
      if first
        ++states.__BEGIN__.t
        states.__BEGIN__.p[word] ?= 0
        ++states.__BEGIN__.p[word]
        first = false

      next = words[i+1] ? '__END__'
      state = states[word] ?= {p:{}}
      state.t ?= 0
      ++state.t
      state.p[next] ?= 0
      ++state.p[next]

  titlegen.titles = titles
  titlegen.states = states
  return

titlegen = (depth=0) ->
  title = ''
  state = states.__BEGIN__
  n = 0
  while n < config.max_word_count
    rnd = Math.round(Math.random() * state.t)
    tot = 0
    for own next,count of state.p
      tot += count
      break  if tot >= rnd

    break  if next is '__END__'

    state = states[next]
    next = ' '+next  unless n is 0
    title += next
    ++n

  title = config.transform title

  if depth < config.max_attempts and (n < config.min_word_count or title in titles)
    return titlegen(depth+1)

  return title

titlegen.feed = feed
titlegen.config = config
titlegen.feed []

module.exports = titlegen  if module?
window.titlegen = titlegen  if window?
global.titlegen = titlegen  if global?
