class CreateJoinTableTemplateQuestion < ActiveRecord::Migration[6.0]
  def change
    create_join_table :templates, :questions do |t|
      t.index [:template_id, :question_id]
      t.index [:question_id, :template_id]
    end
  end
end
