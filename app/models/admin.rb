class Admin < User
  has_many :approved_loans, class_name: 'Loan', :foreign_key => 'approved_by'
end