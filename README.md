# optional
### option types to make nils a thing of the past

Tony Hoare, inventor of the null reference, calls it his "billion-dollar mistake". You will be no stranger to the ubiquitous `NoMethodError: undefined method 'foo' for nil:NilClass`. But it doesn't have to be this way.

There are, crucially, two distinct types of values (or rather lack of values) that are usually, in Ruby, represented as `nil`. There are values that should always be present - and here the fact that they are `nil` actually indicates that an error has occurred somewhere else in your program - and those values that *may or may not be set* - where each case is valid. For example, a person may or may not be wearing a hat.
    
    class Hat
      def doff
        …
      end
    end
    
    gwen    = Person.create(name: "Gwen", hat: Some[:fedora])
    charlie = Person.create(name: "Charlie", hat: None)
    
    class Person
    
      def greet
        puts "hello!"
        hat.do { |h| doff h }
      end
      
    end

    gwen.hat.match do |m|
      m.some (:flat_cap) { puts "Hey up!" }
      m.some (:fedora)   { |h| puts "*touches brim of #{h} respectfully*" }
      m.none             { puts "Hello!" }
    end  