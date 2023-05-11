class ChangeBodyLimitInComments < ActiveRecord::Migration[7.0]
  def change
    change_column :comments, :body, :text, limit: 100
  end
end
