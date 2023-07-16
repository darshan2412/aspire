class Repayment < ApplicationRecord
  include AASM
  include ApplicationHelper

  enum :status, %i[pending paid], _default: 'pending'

  belongs_to :loan
  delegate :customer, :to => :loan, :allow_nil => false

  aasm column: :status do
    state :pending, initial: true
    state :paid

    event :pay do
      transitions from: :pending, to: :paid, guard: [:by_customer?, :repaid_amount_valid?], after: :set_loan_balance_amount
    end
  end

  def repaid_amount_valid?
    self.repaid_amount.round(2) >= self.amount.round(2)
  end

  def set_loan_balance_amount
    current_balance_amount = self.loan.balance_amount
    new_balance_amount = current_balance_amount - self.repaid_amount
    self.loan.update_attribute(:balance_amount, new_balance_amount)
  end
end
