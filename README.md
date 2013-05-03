# optional
## option types to make nils a thing of the past

Tony Hoare, inventor of the null reference, calls it his "billion-dollar mistake".
You will be no stranger to the ubiquitous `NoMethodError: undefined method 'foo' for nil:NilClass`.
But it doesn't have to be this way.

There are, crucially, two distinct types of values (or rather lack of values) that are usually, in Ruby, represented as `nil`.
There are values that should always be present - and here the fact that they are `nil` actually indicates that an error has occurred somewhere else in your program - and those values that *may or may not be set* - where each case is valid.
For example, a person may or may not be wearing a hat.

Using `nil` to represent these optional values leads to lots of ugly defensive coding - or worse, if you forget the ugly defensive coding in even a single place, to `nil`s leaking out into the rest of your program, causing it to blow up at some later point, from where it might be hard to track back to the original cause of the problem.

`Option`s, a construct found in functional languages such as ML, Haskell (as the Maybe monad), F# and Scala, provide an alternative.
They consist of, at the most basic level, a container that either contains a value (`Some` value) or does not (`None`).
Because its a container, you can't access the value directly, so client code is forced to deal with both the case that it's there and that it isn't.
It's a simple concept but leads to some surprisingly powerful uses.

## Creating Options

Here's how you create an option that has a value (a `Some`), using some syntactic sugar provided by the [] method:

    Some[4]
    Some[Cat.new("Tabitha")]
    Some["Jelly"]

Like `nil`, there's only one instance of `None`, so you don't need to create it. Here's how you use it:

    None

## Getting the value

The simplest way to get the value of an `Option` is using the `value` method:

    Some[5].value # => 5
    None.value    # => raises ValueOfNoneError

Why is it a good thing that calling `value` on `None` raises an error? Because you should only use `value` if you're sure that you should have a value at this point - if not having a value *is* an error.
This means the code will blow up at the earliest possible opportunity, making it easier to track down the root cause of the problem.

## How do I know if I have a value?

There are methods named as you'd expect to test for this:

    Some[5].some? # => true
    Some[5].none? # => false

    None.some? # => false
    None.none? # => true

You can also pass a class or module constant to `some?`:

    Some["Perpugilliam Brown"].some? String # => true
    Some["Perpugilliam Brown"].some? Fixnum # => false

This can come in handy when writing rspec tests:

    it { should be_none }
    it { should be_some Fixnum }

But you shouldn't usually need to use these `some?` or `none?` methods.
They basically add up to exactly the same ugly defensive code we're trying to avoid with `nil`s.
Luckily `Option`s provide plenty of other, more elegant ways to access their values.

## Providing a default

If not having a value is a valid case, you might want to provide a default in its place. You can do this using the `value_or` method:

    Some[5].value_or 0 # => 5
    None.value_or 0    # => 0

You can also pass a block to `value_or` in case you don't want the default to be evaluated unless it is used:

    Some[5].value_or { puts "This won't be printed." ; 0 } # => 5
    None.value_or { puts "This will be printed!" ; 0 }     # => 0

## Option is enumerable!

`Option` supports all the same methods that enumerable supports - although it will return `Option`s rather than `Array`s in most cases.
This leads to some pretty cool stuff.

Here's `each`:

    Some[5].each do |value|
      puts "The value is #{value}!"
    end
    # => prints "The value is 5!"

    None.each do |value|
      puts "The value is #{value}!"
    end
    # => doesn't print anything (because there is no value)

Or you can also use `for`:

    for value in Some[5]
      puts "The value is #{value}!"
    end
    # => prints "The value is 5!"

    for value in None
      puts "The value is #{value}!"
    end
    # => doesn't print anything

And here's `map` (or `collect`):

    Some["caterpillar!"].map(&:upcase) # => Some["CATERPILLAR!"]
    None.map(&:upcase) # => None

`Options being enumerable comes in handy if you're using rails, too.
Let's say you have a person model that has an `Option[Hat]`, and you want to render a `Hat` partial only if the person has one.
You can simply use the `collection` key when rendering the partial - you don't even need an `if`:

    <%= render partial: 'hat', collection: @person.hat %>

## Pattern-matching

You'll find `Option`s in many functional languages such as ML, Haskell (as the Maybe monad), Scala and F#.
And in most cases, they will provide a way to access the values (not specific to `Option`s, but a more general part of the language), called pattern-matching.
We don't have pattern-matching in Ruby, but `Optional` provides a basic version for use with `Option`s. Here's how to use it:

    option.match do |m|
      m.some { |value| puts "The value is #{value}" }
      m.none { puts "No value here" }
    end

As you'd expect, the `some` branch is executed if there is a value, the `none` branch if there isn't.

You can also add cases that assert based on the content of the option:

    option.match do |m|
      m.some(:fedora) { puts "This will be printed only if I'm passed a Some[:fedora]" }
      m.some(:trilby) { puts "This will be printed only if I'm passed a Some[:trilby]" }
      m.none { puts "This is printed if I'm passed a None" }
    end

The first case that matches is the one the match clause evaluates to.

You can also use lambdas as part of the match clauses like this:

    option.match do |m|
      m.some ->(x){ x.length > 2 } { puts "This will be printed if the value's length is greater than 2" }
      m.some ->(x){ x.is_a? Array } { puts "This will be printed if the value is an array (whose length is less than or equal to 2)" }
      m.none { puts "This is printed if I'm passed a None" }
    end

## Extra fun and goodness

What's been described so far is what you'd usually expect from `Option`s in other languages.
`Optional`, however, provides a few extra bits and pieces you may want to have a play with.

## Logical operators (sort of logical, anyway)

Got two optional values and want to do something only if they *both* have values? Use `&`:

    Some[5] & Some[6] # => Some[5,6]
    Some[5] & None    # => None
    None & Some[5]    # => None
    None & None       # => None

Got two optional values, either of which might be `None`, and want to do something with one of them, doesn't matter which? Use `|`:

    Some[5] | Some[6] # => Some[5]
    Some[5] & None    # => Some[5]
    None & Some[6]    # => Some[6]
    None & None       # => None

NB. Technically, an `Option` should only have up to one value, but to allow the `&` operator and similar things `Optional` sort of cheats by treating 'multiple values' as a single value of type `Array`.

## Mapping through multiple functions

You might find yourself needing to map an optional value through a number of functions. There's a handy way to do this with `Option`s:

    p = Person.create(name: "Russell!")

    Some[p].map_through(:name, :upcase) # => Some["RUSSELL!"]
    None.map_through(:name, :upcase) # => None

## Juxtaposing the result of multiple functions

This one is nicked from Clojure (there might be other languages that have it, I don't know). Call a list of functions on an option value, returning a `Some` of their results:

    p = Person.create(name: "Russell!", age: 29, hat: :fedora)

    Some[p].juxt(:name, :age, :class) # => Some["Russell", 29, Person]
    None.juxt(:name, :age, :class) # => None

If you're feeling adventurous you could always monkey patch this onto `Object` so it's available for everything. Might come in useful.

## That's about it

I hope you find `Option`s useful. Let me know if you do: I'm @rsslldnphy on that Twitter. I'm very enthusiastic about optional types and functional programming techniques in general, so if you have a question or want advice on using options in your project I'll be happy to answer!

If you'd like to contribute, create a pull request for the feature or fix you have in mind. That way we can discuss whether it's a good fit and how best to approach it before you start on the code. Contributions very welcome!
