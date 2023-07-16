require "test_helper"

class RepaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan = loans(:one)
    @customer = users(:customer)
    @admin = users(:admin)
    @auth_token = JsonWebToken.encode(user_id: @customer.id)
    @admin_auth_token = JsonWebToken.encode(user_id: @admin.id)
    @repayment = repayments(:one)
    put approve_loan_url(@loan), headers: { 'Authorization' => @admin_auth_token }, xhr: true
  end

  test "should pay repayment for a customer" do
    put repay_repayment_url(@repayment), params: { repaid_amount: @repayment.amount }, headers: { 'Authorization' => @auth_token }, xhr: true
    assert_response :success
    response = @response.parsed_body
    repayment = response['repayment']
    assert_equal repayment['status'], 'paid'
  end
end
