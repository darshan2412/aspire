json.message 'success'
json.loans @loans do |loan|
  json.extract! loan, :id, :amount, :term, :balance_amount, :status, :created_at, :updated_at
  json.customer loan.customer, :email, :first_name, :last_name if loan.customer.present? && @current_user.admin?
  json.approver loan.approver, :email if loan.approved_by.present? && @current_user.customer?
end