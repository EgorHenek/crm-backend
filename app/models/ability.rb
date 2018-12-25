# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    if user.present?
      can :manage, :all if user.has_role? :admin
      can :create, :totp unless user.otp_required_for_login
      can %i[delete], :totp if user.otp_required_for_login

      can :read, Task, users: { id: user.id }
      can :create, Task unless user.has_role? :client
      can %i[destroy update add_subcontactor delete_subcontactor], Task, creator: user
      can :manage, News
    end
    can :read, News, ['published_at < ?', Time.now] do |news|
      news.published_at && news.published_at < Time.now
    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
