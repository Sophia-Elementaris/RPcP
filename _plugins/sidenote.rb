module Jekyll
  class SideNote < Liquid::Tag

    require "shellwords"

    def initialize(tag_name, text, tokens)
      super
      @text = text.shellsplit
    end
    
    def render(context)
      output = "<label for='#{@text[0]}' class='margin-toggle sidenote-number'></label>"
      output += "<input type='checkbox' id='#{@text[1]}' class='margin-toggle' />"
      output += "<span class='sidenote'>#{@text[2]}</span>"

      return output
    end
  end
end

Liquid::Template.register_tag('sidenote', Jekyll::SideNote)
