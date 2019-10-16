Gem::Specification.new do |spec|
	spec.name          = "stuffonmymind"
	spec.version       = "1.0.0"
	spec.authors       = ["Sangarshanan"]
	spec.email         = ["sangarshanan@gmail.com"]

	spec.summary       = "A shameless fork of thinkspace"
	spec.homepage      = "https://github.com/Sangarshanan/stuffonmymind"
	spec.license       = "MIT"

	spec.metadata["plugin_type"] = "theme"

	spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|(LICENSE|README)((\.(txt|md|markdown)|$)))!i) }

	spec.add_runtime_dependency "jekyll", "~> 3.5"

	#spec.add_development_dependency "bundler", "~> 2.0.1"
	spec.add_development_dependency "rake", "~> 12.0"
end
