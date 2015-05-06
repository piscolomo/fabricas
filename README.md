Fabricas
====

Minimalist library for build factories.

## Introduction

Fabricas is simple; just a few lines of code. It's a framework agnostic library with zero requires and zero monkey-patching of any class or object. Very useful when you need to build objects fast.

## Installation

Installing Fabricas is as simple as running:

```
$ gem install fabricas
```

Include Fabricas in your Gemfile with ```gem 'fabricas'``` or require it with ```require 'fabricas'```.

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

### Defining a class name

You can provide your own class name to your factories using the `class_name` key:

```ruby
Fabricas.define do
  factory :employee, class_name: "User" do
    name "Dilbert"
    area "Engineer"
  end
end

employee = Fabricas.build :employee
puts employee.inspect
#=> <User @name= "Dilbert", @area= "Engineer">
```

### Sending blocks as attributes

Also you can use blocks in your `factory` to send whatever you want.

```ruby
Fabricas.define do
  factory :user do
    # ...
    password { User.generate_password }
    city { Faker::Address.city }
  end
end
```

You can take advantage of them for sending other instances.

```ruby
class Pet
  attr_accessor :name, :age
end

Fabricas.define do
  factory :user do
    # ...
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

### Dependent Attributes
Attributes can be built using other attributes

```ruby
Fabricas.define do
  factory :user do
    name "Julio"
    url "workingawesome.com"
    email { "#{name.downcase}@#{url}" }
  end
end

user = Fabricas.build :user
puts user.inspect
#=> <User @name= "Julio", @url="workingawesome.com", @email= "julio@workingawesome.com">
```

### Inheritance
By using inheritance, your factory child can receive the same attributes and class name of its parent.

```ruby
Fabricas.define do
  factory :user do
    first_name "Julio"
    email "email@gmail.com"

    factory :admin do
      access true
    end
  end
end

user = Fabricas.build :user
admin = Fabricas.build :admin

puts user.inspect
#=> <User @name= "Julio", @email= "email@gmail.com">

puts admin.inspect
#=> <User @name= "Julio", @email= "email@gmail.com", @access= true>
```
