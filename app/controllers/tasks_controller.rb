# frozen_string_literal: true

class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: %i[show update destroy add_subcontactor delete_subcontactor]
  before_action :set_subcontactor, only: [:delete_subcontactor]

  # GET /tasks
  def index
    @tasks = Task.all

    render json: TaskSerializer.new(@tasks).serialized_json
  end

  # GET /tasks/1
  def show
    render json: TaskSerializer.new(@task).serialized_json
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      @task.tasks_users << TasksUser.new(user: current_user, role: 'creator')
      @task.tasks_users << TasksUser.new(user_id: params[:performer], role: 'performer') if params[:performer].present?
      render json: TaskSerializer.new(@task).serialized_json, status: :created, location: @task
    else
      render json: @task.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: TaskSerializer.new(@task).serialized_json
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  def add_subcontactor
     if @task.tasks_users << TasksUser.new(user_id: params[:subcontactor], role: 'subcontactor')
       render json: TaskSerializer.new(@task).serialized_json
     else
       render status: :unprocessable_entity, json: @task.errors
     end
  end

  def delete_subcontactor
    if @subcontactor.present?
      @subcontactor.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_subcontactor
    @subcontactor = @task.tasks_users.find_by(user_id: params[:subcontactor])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:title, :description, :start_time, :started, :end_time, :ended, :color, :notify)
  end
end
