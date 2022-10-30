module Jekyll
    class ListFiles < Liquid::Tag
      safe true
      priority :high  
  
      def initialize(tag_name, text, tokens)
        super
  
        args = text.strip.split(' ', 2)
        @variable_name = args[0]
        @path_glob = args[1]
      end
  
      def render(context)
        # This is a bug if you have multiple Jekyll sites
        site = Jekyll.sites.first
        source = site.source
  
        files = Dir.glob(@path_glob).map do |path|
          dirname = File.dirname(path)
          filename = File.basename(path)
          Page.new(site, source, dirname, filename)
        end
        context[@variable_name] = files
        ""
      end
    end
  end
  
  Liquid::Template.register_tag('list_files', Jekyll::ListFiles)
