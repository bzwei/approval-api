module ApprovalDecisions
  UNDECIDED_STATUS = 'undecided'.freeze
  APPROVED_STATUS  = 'approved'.freeze
  DENIED_STATUS    = 'denied'.freeze
  CANCELED_STATUS  = 'canceled'.freeze
  ERROR_STATUS     = 'error'.freeze
  DECISIONS = [UNDECIDED_STATUS, APPROVED_STATUS, DENIED_STATUS, CANCELED_STATUS, ERROR_STATUS].freeze
end
