class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :started, :ended, :start_time, :end_time, :notify, :color
  attribute :creator do |object|
    {
        id: object.creator.id,
        name: object.creator.full_name,
        roles: object.creator.roles.map(&:name)
    }
  end
  attribute :performer do |object|
    {
        id: object.performer.id,
        name: object.performer.full_name,
        roles: object.performer.roles.map(&:name)
    }
  end
  attribute :performer do |object|
    {
        id: object.performer.id,
        name: object.performer.full_name,
        roles: object.performer.roles.map(&:name)
    }
  end
  attribute :subcontactors do |object|
    object.subcontactors.map do |subcontactor|
      {
          id: subcontactor.id,
          name: subcontactor.full_name,
          roles: subcontactor.roles.map(&:name)
      }
    end
  end

  attribute :history do |object|
    object.audits.map do |audit|
      {
          action: audit.action,
          changes: audit.audited_changes,
          comment: audit.comment,
          created_at: audit.created_at
      }
    end
  end
end
