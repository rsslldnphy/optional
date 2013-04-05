# id
### simple models based on hashes

JSON is a great way to transfer data between systems, and it's easy to parse into a Ruby hash. But sometimes it's nice to have actual methods to call when you want to get attributes from your data, rather than coupling your entire codebase to the hash representation by littering it with calls to `fetch` or `[]`. The same goes for BSON documents stored in Mongo.

That's where `id` (as in Freud) comes in. You define your model classes using syntax that should look pretty familiar if you've used any popular Ruby ORMs - but `id` is not an ORM. Model objects defined with `id` have a constructor that accepts a hash, and you define the values of this hash that are made readable as fields - but that hash can come from any source.

#### Defining a model

Defining a model looks like this:

    class MyModel
      include Id::Model

      field :foo
      field :bar, default: 42
      field :baz, key: 'barry'

    end

    my_model = MyModel.new(foo: 7, barry: 'hello')
    my_model.foo # => 7
    my_model.bar # => 42
    my_model.baz # => 'hello'

As you can see, you can specify default values as well as key aliases.

#### Associations

You can also specify has_one or has_many "associations" - what would be nested subdocuments in MongoDB for example - like this:

    class Zoo
      include Id::Model

      has_many :lions
      has_many :zebras
      has_one :zookeeper, type: Person
    end

    zoo = Zoo.new(lions: [{name: 'Hetty'}],
                  zebras: [{name: 'Lisa'}],
                  zookeeper: {name: 'Russell' d})

    zoo.lions.first.class # => Lion
    zoo.lions.first.name  # => "Hetty"
    zoo.zookeeper.class   # => Person
    zoo.zookeeper.name    # => "Russell"

Types are inferred from the association name unless one is specified.

#### Designed for immutability

`id` models provide accessor methods, but no mutator methods, because they are designed for immutability. How do immutable models work? When you need to change some field of a model object, a new copy of the object is created with the field changed as required. This is handled for you by `id`'s `set` method:

    person = Person.new(name: 'Russell', job: 'programmer')
    person.set(name: 'Radek') # => returns a new Person whose name is Radek and whose job is 'programmer'

You can even set fields on nested models in this way:

    person.hat.set(color: 'red') # => returns a new person object with a new hat object with its color set to red
