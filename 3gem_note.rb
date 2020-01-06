authorize! :read, @document in controller#action


Post.accessible_by(current_ability)

can? :read, @post

ApplicationController

  check_authorization

AbcsController
  prepend_before_filter
  load_and_authorize_resource only: [:index, :show], param_method: :my_sanitizer
  load_resource
    The resource will only be loaded into an instance variable if it hasn't been already. This allows you to easily override how the loading happens in a separate before_filter.

  authorize_resource          # = before_action ->{authorize!(params[:action].to_sym, @product || Product)}

  load_and_authorize_resource
    1 create_params
    2 <model_name>_params (ex: post_params)
    3 resource_params

  skip_load_and_authorize_resource only: :new
  skip_load_resource
  skip_authorize_resource
  skip_authorization_check

rescue from -> check login -> check owner -> check admin

_________________"raise ActiveModel::ForbiddenAttributesError if !attributes.permitted?" when run authorize_resource

load_and_authorize :post
load_and_authorize :comment, through: :post, shallow: true
