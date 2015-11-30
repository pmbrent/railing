To boot up the server, just run 'ruby bin/server.rb'

Remember that if you change any files, you'll need to restart the server; you can interrupt with Ctrl+C.

You can define routes using router.draw and regular expressions, e.g.

```ruby
router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end
```
