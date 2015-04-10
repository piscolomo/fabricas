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