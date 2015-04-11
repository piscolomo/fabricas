Fabricas
====

Another minimalist library for build factories

Usage
-----

```ruby
class User
  attr_accessor :name, :email
end

Fabricas.define do
  factory :user do
    name "Julio"
    email "email@gmail.com"
  end
end

user = Fabricas.build :user
puts user.inspect
#=> <User @name= "Julio", @email= "email@gmail.com">

other_user = Fabricas.build :user, name: "Pedro"
puts other_user.inspect
#=> <User @name= "Pedro", @email= "email@gmail.com">
```

You can provide your own class name to your factories using the `class_name` key:

```ruby
Fabricas.define do
  factory :admin, class_name: "User" do
    name "Big Boss"
    admin true
  end
end

admin = Fabricas.build :admin
puts admin.inspect
#=> <User @name= "Big Boss", @admin= true>
```


Also you can use blocks in your `factory`, useful for send other instances

```ruby
class Pet
  attr_accessor :name, :age
end

Fabricas.define do
  factory :user do
    name "Julio"
    email "email@gmail.com"
    pet { Fabricas.build :pet }
  end

  factory :pet do
    name "Firulais"
    age 12
  end
end

user = Fabricas.build :user
puts user.pet.inspect
#=> <Pet @name= "Firulais", @age= 12>
```