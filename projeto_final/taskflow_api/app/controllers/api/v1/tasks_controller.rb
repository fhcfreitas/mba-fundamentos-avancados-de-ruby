class Api::V1::TasksController < ApplicationController
  before_action :set_pipeline

  def index
    @tasks = @pipeline.tasks
    render json: @tasks, status: :ok
  end

  def show
    @task = @pipeline.tasks.find(params[:id])
    render json: @task, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  def create
    @task = @pipeline.tasks.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task = @pipeline.tasks.find(params[:id])
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  def destroy
    @task = @pipeline.tasks.find(params[:id])
    @task.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  private

  def set_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Pipeline not found' }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:name, :task_type, :position, params: {}, depends_on: [])
  end
end
