require File.expand_path("../lib/fabricas", File.dirname(__FILE__))

class User
  attr_accessor :name, :email
end

Fabricas.define do
  factory :user do
    name "Julio"
    email "email@gmail.com"
  end

  factory :pet do
    name "Calvin"
    age 1
    color "white"
  end
end

scope do
  test "build user returns name and email" do
    user = Fabricas.build :user
    assert_equal user.name, "Julio"
    assert_equal user.email, "email@gmail.com"
  end

  test "build user with name returns the sent name" do
    user = Fabricas.build :user, name: "Pedro"
    assert_equal user.name, "Pedro"
    assert_equal user.email, "email@gmail.com"
  end
end