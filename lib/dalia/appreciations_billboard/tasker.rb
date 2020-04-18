module Dalia::AppreciationsBillboard::Tasker
  def self.invoke(task_name)
    Dalia::MiniGraphite.benchmark_wrapper("app.appreciationsbillboard.#{Rails.env}.task.#{task_name}") do
      Dalia::AppreciationsBillboard::Tasker.send(task_name)
    end
  end

  def self.task_test
    Rails.logger.info("DEBUG: Dalia::AppreciationsBillboard::Tasker.task_test")
  end
end
