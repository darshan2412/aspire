json.message 'success'
json.loan @loan, :id, :amount, :term, :balance_amount, :status
json.customer @loan.customer, partial: 'customer', as: customer if @current_user.admin?