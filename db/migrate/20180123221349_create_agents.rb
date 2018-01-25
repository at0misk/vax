class CreateAgents < ActiveRecord::Migration[5.1]
  def change
    create_table :agents do |t|
      t.string :agent_id

      t.timestamps
    end
  end
end
