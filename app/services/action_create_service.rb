class ActionCreateService
  attr_accessor :stage

  def initialize(stage_id)
    self.stage = Stage.find(stage_id)
  end

  def create(options)
    validate_operation(options[:operation])
    Action.create!(options.merge(:stage => stage)).tap do |action|
      case action.operation
      when Action::NOTIFY_OPERATION
        StageUpdateService.new(stage.id).update(:state => Stage::NOTIFIED_STATE)
      when Action::SKIP_OPERATION
        StageUpdateService.new(stage.id).update(:state => Stage::SKIPPED_STATE)
      when Action::APPROVE_OPERATION
        StageUpdateService.new(stage.id).update(
          :state    => Stage::FINISHED_STATE,
          :decision => Stage::APPROVED_STATUS,
          :reason   => action.comments
        )
      when Action::DENY_OPERATION
        StageUpdateService.new(stage.id).update(
          :state    => Stage::FINISHED_STATE,
          :decision => Stage::DENIED_STATUS,
          :reason   => action.comments
        )
      end
    end
  end

  private

  def validate_operation(operation)
    return if operation == Action::MEMO_OPERATION
    return unless [Stage::FINISHED_STATE, Stage::SKIPPED_STATE].include?(stage.state)

    action = stage.actions.find do |act|
      [Action::SKIP_OPERATION, Action::APPROVE_OPERATION, Action::DENY_OPERATION].include?(act.operation)
    end
    decision = stage.state == Stage::SKIPPED_STATE ? stage.state : stage.decision
    raise "Action #{operation} is rejected because request has been #{decision} by #{action.processed_by}."
  end
end
