require "./lib/fabricas"

Gem::Specification.new do |s|
  s.name              = "fabricas"
  s.version           = Fabricas::VERSION
  s.summary           = "Minimalist library for build factories."
  s.description       = "Fabricas is simple, just a few lines of code. Is framework agnostic, there are no monkey-patch to any class or object and is very useful when you need to build objects fast."
  s.authors           = ["Julio Lopez"]
  s.email             = ["ljuliom@gmail.com"]
  s.homepage          = "http://github.com/TheBlasfem/fabricas"
  s.files = Dir[
    "LICENSE",
    "README.md",
    "lib/**/*.rb",
    "*.gemspec",
    "test/**/*.rb"
  ]
  s.license           = "MIT"
  s.add_development_dependency "cutest", "1.1.3"
end