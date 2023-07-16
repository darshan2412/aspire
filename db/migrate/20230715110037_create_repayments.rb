class CreateRepayments < ActiveRecord::Migration[7.0]
  def change
    create_table :repayments do |t|
      t.integer :loan_id, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false, default: 0.0
      t.date :scheduled_on, null: false
      t.integer :status, default: 0
      t.decimal :repaid_amount, precision: 15, scale: 2
      t.timestamps
    end
  end
end
