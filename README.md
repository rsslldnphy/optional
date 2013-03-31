# id
### simple models based on hashes

JSON is a great way to transfer data between systems, and it's easy to parse into a Ruby hash. But sometimes it's nice to have actual methods to call when you want to get attributes from your data, rather than coupling your entire codebase to the hash representation by littering it with calls to `fetch` or `[]`. The same goes for BSON documents stored in Mongo.

That's where `id` (as in Freud) comes in. You define your model classes using syntax that should look pretty familiar if you've used any popular Ruby ORMs - but `id` is not an ORM. Model objects defined with `id` have a constructor that accepts a hash, and you define the values of this hash that are made readable as fields - but that hash can come from any source.