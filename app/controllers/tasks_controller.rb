class TasksController < ApplicationController
  before_action :set_task, only: [:destroy]

  def index
    @tasks = Task.all.order(:deadline)
  end

  def new
    @task = Task.new
  end

  def create
    @task = filter_multiparameters

    if time_params_complete? && @task.save
      redirect_to tasks_url, notice: 'Task successfully created.'
    else
      render :new
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task successfully destroyed.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :title, :deadline)
  end

  # filter fake parameters
  def filter_multiparameters
    Task.new(task_params)
  rescue ActiveRecord::MultiparameterAssignmentErrors
    Task.new(task_params.reject { |k, _v| k.match(/^deadline.*/) })
  end

  # check
  def time_params_complete?
    time_values = (1..5).map { |e| task_params["deadline(#{e}i)"] }
    return true if empty_or_integers time_values
    @task.errors.add(
      :deadline, 'Error - please fill all date time inputs or leave blank'
    )
    false
  end

  def empty_or_integers(time_values)
    time_values.all?(&:empty?) || time_values.all? { |x| integer_string?(x) }
  end

  def integer_string?(value)
    Integer(value)
  rescue ArgumentError
    false
  end
end
