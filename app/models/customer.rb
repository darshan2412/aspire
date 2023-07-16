class Customer < User

  has_many :loans, :foreign_key => 'user_id'
  has_many :repayments, through: :loans
end
