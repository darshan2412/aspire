class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.integer :user_id, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false, default: 0.0
      t.decimal :balance_amount, precision: 15, scale: 2, null: false, default: 0.0
      t.integer :term, null: false, default: 1
      t.string :repayment_frequency, default: 'weekly'
      t.integer :status
      t.integer :approved_by
      t.timestamp :approved_at
      t.timestamps
    end

    add_index :loans, :user_id
    add_index :loans, :status
  end
end
