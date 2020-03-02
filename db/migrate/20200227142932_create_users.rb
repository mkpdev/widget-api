class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :remote_id
      t.string :access_token
      t.string :refresh_token
      t.string :email
      t.timestamps
    end
  end
end
