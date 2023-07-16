require "test_helper"

class LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan = loans(:one)
    @customer = users(:customer)
    @admin = users(:admin)
    @auth_token = JsonWebToken.encode(user_id: @customer.id)
    @admin_auth_token = JsonWebToken.encode(user_id: @admin.id)
  end

  test "should get index" do
    get loans_url, headers: { 'Authorization' => @auth_token }, xhr: true
    assert_response :success
    response = @response.parsed_body
    loan = response['loans'].first
    assert_equal loan['id'], @loan.id
  end

  test "should create loan along with repayments" do
    assert_difference("Loan.count") do
      post loans_url, params: { amount: 30000.00, term: 3 }, headers: { 'Authorization' => @auth_token }, xhr: true
    end

    assert_response :success
    response = @response.parsed_body
    assert_equal response['loan']['amount'].to_f, 30000.00
    assert_equal response['loan']['term'], 3
    assert_equal response['loan']['balance_amount'].to_f, 30000.00
    assert_equal response['loan']['status'], 'pending'
    loan = Loan.find(response['loan']['id'])
    assert_not_empty loan.repayments
  end

  test "should show loan" do
    get loan_url(@loan), headers: { 'Authorization' => @auth_token }, xhr: true
    assert_response :success
    response = @response.parsed_body
    loan = response['loan']
    assert_equal loan['id'], @loan.id
  end

  test "should approve loan by admin" do
    put approve_loan_url(@loan), headers: { 'Authorization' => @admin_auth_token }, xhr: true
    assert_response :success
    response = @response.parsed_body
    loan = response['loan']
    assert_equal loan['status'], 'approved'
  end

  test "should fetch repayments for a loan" do
    get repayments_loan_url(@loan), headers: { 'Authorization' => @auth_token }, xhr: true
    assert_response :success
    response = @response.parsed_body
    repayments = response['repayments']
    assert_equal repayments.count, @loan.repayments.count
  end
end
