class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_questions
    @questions = Question.all
    @template = set_template
    @tags = @template.tags(@template.content)
  end

  def assign_questions_post
    questions = []
    params[:hash].each do |k, v|
      question = Question.find(v)
      question.update(tag: '['+k+']')
      questions.push(question)
    end
    template = Template.find(params[:id])
    template.questions = questions
    redirect_to templates_path
  end

  def answer_questions
    @questions = Template.find(params[:id]).questions
    if @questions.count == 0
      redirect_to templates_path, notice: "Please assign questions to the template"
    end
  end

  def answer_questions_post
    Template.find(params[:id]).questions.each do |question|
      question.answer = params[question.id.to_s]
      question.save
    end
    redirect_to "/templates/" + params[:id] + "/generate_pdf_document"
  end

  def generate_pdf_document

    @id = params[:id]
    @template = set_template
    @content = @template.content
    tags = @template.tags(@content)
    tags.each do |tag|
      replacement = @template.questions.where(tag: tag).first.answer
      @content.gsub! tag, replacement
    end
    respond_to do |format|
          format.html
          format.pdf {render template: "/templates/generate_pdf_document", pdf: 'Document'}
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(:content)
    end
end
