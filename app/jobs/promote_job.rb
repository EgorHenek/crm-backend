class PromoteJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default

  around_perform do |job, block|
    job.arguments.first.started_at = Time.now
    job.arguments.first.save
    block.call
    job.arguments.first.complete_at = Time.now
    job.arguments.first.save
  end

  def perform(promote, *args)
    clients = Client.all
    clients.each do |client|
      PromoteMailer.with(text: promote.text, title: promote.title, client: client).promote_email.deliver_later
    end
  end
end
