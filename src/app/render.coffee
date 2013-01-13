pages = [
  {name: 'home', text: 'Home', url: '/'}
  {name: 'submit', text: 'Submit', url: '/submit'}
]

render = (page, name, ctx = {}) ->
  ctx.currentPage = name
  ctx.pages = []
  for item, i in pages
    item = Object.create item
    ctx.pages[i] = item
    if item.name is name
      item.current = true
      ctx.title = item.text
  item.isLast = true
  page.render name, ctx

module.exports = {
    render
  }