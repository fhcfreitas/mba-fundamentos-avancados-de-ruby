class TasksController < ApplicationController
  def index
    q = Task.not_deleted.ransack(params[:q])
    @tasks = q.result(distinct: true)
    render json: @tasks
  end

  # POST /tasks/
  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /tasks/:id
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # GET /tasks/:id
  def show
    @task = Task.find(params[:id])
    render json: @task
  end

  # DELETE /tasks/:id
  def destroy
    @task = Task.find(params[:id])
    debugger
    if @task.soft_delete
      head :no_content
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status)
  end
end
