require File.expand_path("../lib/fabricas", File.dirname(__FILE__))

class User
  attr_accessor :name, :email, :pet
end

class Pet
  attr_accessor :name, :age, :adopted
end

Fabricas.define do
  factory :user do
    name "Julio"
    email "email@gmail.com"
    pet { Fabricas.build :pet }
  end

  factory :pet do
    name "Calvin"
    age 1
    adopted true
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

  test "multiple factories" do
    pet = Fabricas.build :pet
    assert_equal pet.name, "Calvin"
    assert_equal pet.age, 1
    assert_equal pet.adopted, true
  end

  test "factory objects by procs" do
    user = Fabricas.build :user
    assert_equal user.pet.name, "Calvin"
    assert_equal user.pet.age, 1
  end
end