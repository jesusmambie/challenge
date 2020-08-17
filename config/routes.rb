Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get '/templates/assign_questions/:id', to: 'templates#assign_questions'
  post '/templates/assign_questions/:id', to: 'templates#assign_questions_post'

  get '/templates/:id/answer_questions', to: 'templates#answer_questions'
  post '/templates/:id/answer_questions', to: 'templates#answer_questions_post'

  get '/templates/:id/generate_pdf_document', to: 'templates#generate_pdf_document'

  resources :questions, :templates
end
