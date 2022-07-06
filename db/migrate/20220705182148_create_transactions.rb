class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :sender
      t.integer :receiver
      t.decimal :amount
      t.text :currency

      t.timestamps
    end
  end
end
