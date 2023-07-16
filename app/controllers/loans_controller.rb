class LoansController < ApplicationController

  def index
    @loans = @current_user.admin? ? Loan.all : @current_user.loans
  end

  def show
    @loan = @current_user.admin? ? Loan.find(params[:id]) : @current_user.loans.find(params[:id])
    render json: { message: 'failure', error: 'Loan not found for given id' }, status: :not_found unless @loan.present?
  end

  def create
    return render json: { message: 'failure', error: "Only a customer can apply for loan" }, status: :forbidden unless @current_user.customer?

    @loan = Loan.new(params.permit(:amount, :term))
    @loan.customer = @current_user
    result = @loan.save
    render json: { message: 'failure', error: @loan.errors }, status: :unprocessable_entity unless result
  end

  def approve
    return render json: { message: 'failure', error: "Only an admin can approve a loan" }, status: :forbidden unless @current_user.admin?

    @loan = Loan.find(params[:id])
    return render json: { message: 'failure', error: "Loan not found for given id" }, status: :not_found unless @loan.present?

    @loan.approve!
  rescue StandardError => e
    render json: { message: 'failure', error: e.message }, status: :bad_request
  end

  def repayments
    @loan = @current_user.loans.find(params[:id])
    return render json: { message: 'failure', error: "Loan not found for given id" }, status: :not_found unless @loan.present?

    @repayments = @loan.repayments
  end
end