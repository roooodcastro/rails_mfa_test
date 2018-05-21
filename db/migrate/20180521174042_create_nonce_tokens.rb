class CreateNonceTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :nonce_tokens do |t|
      t.references :user, foreign_key: true
      t.string :token, null: false
      t.boolean :used, default: false, null: false

      t.timestamps
    end
  end
end
