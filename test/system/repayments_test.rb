require "application_system_test_case"

class RepaymentsTest < ApplicationSystemTestCase
  setup do
    @repayment = repayments(:one)
  end

  test "visiting the index" do
    visit repayments_url
    assert_selector "h1", text: "Repayments"
  end

  test "should create repayment" do
    visit repayments_url
    click_on "New repayment"

    click_on "Create Repayment"

    assert_text "Repayment was successfully created"
    click_on "Back"
  end

  test "should update Repayment" do
    visit repayment_url(@repayment)
    click_on "Edit this repayment", match: :first

    click_on "Update Repayment"

    assert_text "Repayment was successfully updated"
    click_on "Back"
  end

  test "should destroy Repayment" do
    visit repayment_url(@repayment)
    click_on "Destroy this repayment", match: :first

    assert_text "Repayment was successfully destroyed"
  end
end
