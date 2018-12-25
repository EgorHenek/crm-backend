class NewsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :published_at
  attributes :created_at, :updated_at, if: Proc.new {|record, params| params[:current_user]}
end
