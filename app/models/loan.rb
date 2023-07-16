class Loan < ApplicationRecord
  include AASM
  include ApplicationHelper

  enum :status, %i[pending approved paid], _default: 'pending'

  TERM_DURATION = { 'weekly' => 7.days }

  belongs_to :customer, foreign_key: 'user_id'
  has_one :approver, class_name: 'Admin', foreign_key: 'approved_by'
  has_many :repayments

  before_create :before_create_tasks

  aasm column: :status do
    state :pending, initial: true
    state :approved
    state :paid

    event :approve do
      transitions from: :pending, to: :approved, guard: :by_admin?, after: :set_approval_columns
    end

    event :pay do
      transitions from: :approved, to: :paid, guard: :by_customer?, after: :update_repayments
    end
  end

  def before_create_tasks
    initialize_balance_amount
    assign_repayments
  end

  def initialize_balance_amount
    self.balance_amount = amount
  end

  def assign_repayments
    repayment_amount = (amount/term)
    next_repayment_date = (DateTime.now + TERM_DURATION[repayment_frequency]).to_date
    term.times do |i|
      repayment = Repayment.new(amount: repayment_amount, scheduled_on: next_repayment_date, status: Repayment.statuses['pending'])
      self.repayments << repayment
      next_repayment_date += TERM_DURATION[repayment_frequency]
    end
  end

  def before_update_tasks
    pay_if_balance_cleared
  end

  def pay_if_balance_cleared
    self.pay! if balance_amount_changed? && balance_amount <= 0
  end

  def set_approval_columns
    self.approved_by = Thread.current[:user].try(:id)
    self.approved_at = Time.now
  end

  def update_repayments
    # This can be done inside a delayed job while running at scale
    remaining_repayments = self.repayments.where(status: Repayment.statuses[:pending])
    return unless self.paid? || remaining_repayments.blank?

    remaining_repayments.each do |repayment|
      repayment.update_attribute(:status, Repayment.statuses[:paid])
    end
  end
end
