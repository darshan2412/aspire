class RepaymentsController < ApplicationController

  def repay
    @repayment = Repayment.find(params[:id])
    return render json: { message: 'failure', error: "Scheduled repayment not found for given id" }, status: :not_found if @repayment.blank?

    return render json: { message: 'failure', error: "Loan not approved yet for repayment" }, status: :forbidden unless @repayment.loan.approved?

    @repayment.repaid_amount = params[:repaid_amount]
    @repayment.pay!
  rescue ActiveModel::ValidationError => e
    render json: { message: 'failure', error: @repayment.errors }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { message: 'failure', error: e.message }, status: :bad_request
  end
end