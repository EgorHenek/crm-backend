FactoryBot.define do
  factory :tasks_user do
  end
  factory :task do
    title { Faker::String.random }
    description { Faker::Movies::VForVendetta.speech }
    start_time { Time.now }
    started { false }
    end_time { Time.now + 5.days }
    ended { false }
    color { Faker::Color.color_name }
    notify { nil }

    transient do
      creator { FactoryBot.create(:user) }
      performer { FactoryBot.create(:user) }
      subcontactors { FactoryBot.create_list(:user, 3) }
    end

    after :create do |task, options|
      task.tasks_users << FactoryBot.create(:tasks_user, task: task, user: options.creator, role: 'creator')
      task.tasks_users << FactoryBot.create(:tasks_user, task: task, user: options.performer, role: 'performer')
      options.subcontactors.each do |subcontactor|
        task.tasks_users << FactoryBot.create(:tasks_user, task: task, user: subcontactor, role: 'subcontactor')
      end
    end
  end
end
