version = File.read(File.expand_path("../VERSION",__FILE__)).strip

Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'nuget'
  spec.version     = version
  spec.files = Dir['bin/**/*']
  spec.bindir = 'bin'
  spec.executables << 'nuget'

  spec.summary     = 'NuGet - Get your package here'
  spec.description = <<-EOF 
NuGet is a free, open source developer focused package management system for the .NET platform intent on simplifying the process of incorporating third party libraries into a .NET application during development. This is the package creation piece of the toolset.
EOF
  
  spec.authors            = ['David Fowler','Phil Haack','David Ebbo']
  spec.email             = 'nuget@discussions.codeplex.com'
  spec.homepage          = 'http://nuget.codeplex.com'
  spec.rubyforge_project = 'nuget'
end