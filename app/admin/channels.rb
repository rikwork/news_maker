ActiveAdmin.register Channel do
  permit_params :name, :token

  index do
    selectable_column
    id_column
    column :name
    column :token
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :token
    end
    f.actions
  end
end
