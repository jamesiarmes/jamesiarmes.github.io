
module Jekyll
  class Aside < Liquid::Block
    def render(context)
      contents = super

      params = @markup ? JSON.parse(@markup, symbolize_names: true) : {}

      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)

      <<-HTML
<aside class="aside" data-type="#{params[:type]}">
  <div class="aside-title">#{params[:icon]}#{params[:title] || params[:type].capitalize}</div>
  <div class="aside-content">#{converter.convert(contents)}</div>
</aside>
      HTML
    end
  end
end

Liquid::Template.register_tag('aside', Jekyll::Aside)
