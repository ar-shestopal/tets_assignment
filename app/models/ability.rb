class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.regular_user?
      can :read, Comment
      can :read, Article
      can :read, User, id: user.id
      can :update, User, id: user.id
      can :manage, Comment, user_id: user.id
      can :manage, Article, user_id: user.id
    else
      # guest
      can :read, Article
      can :read, Comment
    end
  end
end
