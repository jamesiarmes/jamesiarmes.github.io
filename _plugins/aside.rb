
module Jekyll
  class Aside < Liquid::Block
    include Liquid::StandardFilters

    def render(context)
      contents = super

      params = @markup ? JSON.parse(@markup, symbolize_names: true) : {}

      <<-HTML
<aside class="aside" data-type="#{params[:type]}">
  <div class="aside-title">#{params[:icon]}#{params[:title] || params[:type].capitalize}</div>
  <div class="aside-content" markdown="1">#{contents}</div>
</aside>
      HTML
    end
  end
end

Liquid::Template.register_tag('aside', Jekyll::Aside)
