class PromoteSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :text, :complete_at, :started_at, :created_at
  attribute :status do |object|
    if object.started_at && object.complete_at
      'finish'
    elsif object.started_at && object.complete_at.nil?
      'process'
    else
      'not started'
    end
  end
end
