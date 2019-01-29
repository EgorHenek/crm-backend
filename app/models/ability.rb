# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :read, Client
      can :manage, :all if user.has_role? :admin

      can :create, :totp unless user.otp_required_for_login
      can :delete, :totp if user.otp_required_for_login

      can :create, Task
      can :read, Task, users: { id: user.id }
      can %i[destroy update add_subcontactor delete_subcontactor], Task, creator: user

      can :manage, Client if user.has_role? :manager
      can :manage, News if user.has_role? :advertising
      can :manage, Promote if user.has_any_role? :advertising, :manager
    else
      can :read, News, ['published_at < ?', Time.now] do |news|
        news.published_at && news.published_at < Time.now
      end
      can :create, Client
    end
  end
end
