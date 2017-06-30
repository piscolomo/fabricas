require File.expand_path("../lib/fabricas", File.dirname(__FILE__))

class User
  attr_accessor :name, :email, :pet, :admin, :password, :url, :access

  def self.generate_password
    "5555"
  end
end

class Pet
  attr_accessor :name, :age, :adopted
end

class Comment
  attr_accessor :content, :sent
end


module Nested
  class User
    attr_accessor :name, :email, :pet, :admin, :password, :url, :access
  end
end
Fabricas.define do
  factory :user do
    name "Julio"
    url "workingawesome.com"
    email { "#{name.downcase}@#{url}" }
    password { User.generate_password }
    pet { Fabricas.build :pet }

    factory :super_admin do
      access true
    end
  end

  factory :admin, class_name: "User" do
    name "Big Boss"
    email "boss@gmail.com"
    admin true
  end

  factory :nested_admin, class_name: "Nested::User" do
    name "Big Boss"
    email "boss@gmail.com"
    admin true
  end

  factory :pet do
    name "Calvin"
    age 1
    adopted true
  end

  factory :message, class_name: "Comment" do
    content "Hei dude"

    factory :message_sent do
      sent true
    end
  end
end

scope do
  test "build user returns name and email" do
    user = Fabricas.build :user
    assert_equal user.name, "Julio"
    assert_equal user.url, "workingawesome.com"
    assert_equal user.access, nil
  end

  test "build user with name returns the sent name" do
    user = Fabricas.build :user, name: "Pedro"
    assert_equal user.name, "Pedro"
    assert_equal user.url, "workingawesome.com"
  end

  test "multiple factories" do
    pet = Fabricas.build :pet
    assert_equal pet.name, "Calvin"
    assert_equal pet.age, 1
    assert_equal pet.adopted, true
  end

  test "factory object instances by proc" do
    user = Fabricas.build :user
    assert_equal user.pet.name, "Calvin"
    assert_equal user.pet.age, 1
  end

  test "factory run method in proc" do
    user = Fabricas.build :user
    assert_equal user.password, "5555"
  end

  test "using another class name" do
    admin = Fabricas.build :admin
    assert_equal admin.name, "Big Boss"
    assert_equal admin.admin, true
  end

  test "using another nested class name" do
    admin = Fabricas.build :nested_admin
    assert_equal admin.name, "Big Boss"
    assert_equal admin.admin, true
  end

  test "dependent attribute" do
    user = Fabricas.build :user
    assert_equal user.email, "julio@workingawesome.com"
  end

  test "inheritance" do
    super_admin = Fabricas.build :super_admin
    assert_equal super_admin.name, "Julio"
    assert_equal super_admin.access, true
  end

  test "inheritance with class_name in parent" do
    message = Fabricas.build :message
    message_sent = Fabricas.build :message_sent
    assert_equal message.content, "Hei dude"
    assert_equal message_sent.content, "Hei dude"
    assert_equal message_sent.sent, true
  end
end