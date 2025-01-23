# frozen_string_literal: true

module Jekyll
  # Creates a tag cloud tag for liquid.
  class TagCloud < Liquid::Tag
    CLASSIFICATION_SIZE = 5

    def render(context)
      site = context.registers[:site]
      return unless site.tags

      # TODO: Render tag cloud
      tags = calculate(site)
      html = '<ul class="tagcloud">'
      tags.each do |tag, weight|
        html += "<li><a href=\"/tags/#{tag}\" data-weight=\"#{weight}\">#{tag_icon(site, tag)}#{tag}</a></li>"
      end
      html += '</ul>'
    end

    private

    def calculate(site)
      tags = site.tags.sort.map { |tag, posts| [tag, posts.count] }.to_h
      min = tags.values.min
      max = tags.values.max
      r = tags.map { |tag, count| [tag, classify(count, min, max)] }.to_h
      pp(r)
    end

    def classify(current, min, max)
      (1..max).quantile(current, CLASSIFICATION_SIZE)
      # @@classifiers = {
      #   'log' => proc{|classes, value, min, max|
      #     scaled = (classes * (Math.log(value) - Math.log(min)) / (Math.log(max) - Math.log(min))).to_i
      #     scaled == classes ? classes : scaled + 1},
      #   'linear' => proc{|classes, value, min, max| (1..max).quantile(value, classes)}
      # }
    end

    def tag_icon(site, tag)
      "<i class=\"#{site.data['tags'][tag]}\"></i> " if site.data['tags'].has_key?(tag)
    end
  end
end

Liquid::Template.register_tag('tagcloud', Jekyll::TagCloud)
