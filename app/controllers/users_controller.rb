class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  def index
    render json: UserSerializer.new(@users).serialized_json
  end

  # GET /users/1
  def show
    render json: UserSerializer.new(@user).serialized_json
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      @user.add_role(params[:role])
      render json: UserSerializer.new(@user).serialized_json, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      if params[:role].present?
        @user.roles.each { |role| @user.remove_role(role) }
        @user.add_role(params[:role])
      end
      render json: UserSerializer.new(@user).serialized_json
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @user.has_role? :admin
      render status: :unprocessable_entity
    else
      @user.update_attribute(:blocked, !@user.blocked)
    end
  end

  private
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:first_name, :second_name, :last_name, :email, :password)
  end
end
