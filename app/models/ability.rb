class Ability
  include CanCan::Ability

  def initialize user
    alias_action :read, :update, :destroy, to: :rud

    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.owner?
      for_owner user
    elsif user.user? && user.persisted?
      for_user user
    else
      for_customer
    end
  end

  def for_customer
    can :read, [Pitch, SubpitchType, Subpitch, Like, Rating, Comment]
    can :new, Booking
  end

  def for_user user
    for_customer
    can [:show, :update, :destroy], User, id: user.id
    can :rud, Like, user_id: user.id
    can :create, Like
    can :rud, Rating, booking: {user: {id: user.id}}
    can :create, Rating
    can :rud, Comment, rating: {booking: {user: {id: user.id}}}
    can :create, Comment
    can :create, Booking
    can :update, Booking, user_id: user.id
  end

  def for_owner user
    for_user user
    can :rud, Comment,
        rating: {booking: {subpitch: {pitch: {user: {id: user.id}}}}}
    can :rud, Pitch, user_id: user.id
    can :create, Pitch
    can :rud, Subpitch, pitch: {user: {id: user.id}}
    can :create, Subpitch
  end
end
