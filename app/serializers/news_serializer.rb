# frozen_string_literal: true

class NewsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :published_at, :slug
  attributes :created_at, :updated_at, if: proc {|record, params| params[:current_user]}
  attribute :description_html do |news|
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(Sanitize.fragment(news.description, Sanitize::Config::RELAXED))
  end
end
