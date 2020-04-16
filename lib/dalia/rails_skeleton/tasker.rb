module Dalia::RailsSkeleton::Tasker
  def self.invoke(task_name)
    Dalia::MiniGraphite.benchmark_wrapper("app.railsskeleton.#{Rails.env}.task.#{task_name}") do
      Dalia::RailsSkeleton::Tasker.send(task_name)
    end
  end

  def self.task_test
    Rails.logger.info("DEBUG: Dalia::RailsSkeleton::Tasker.task_test")
  end
end
