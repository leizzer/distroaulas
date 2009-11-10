class MateriasController < ApplicationController
  # GET /materias
  # GET /materias.xml
  def index
    @materias = Materia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @materias }
    end
  end

  # GET /materias/1
  # GET /materias/1.xml
  def show
    @materia = Materia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @materia }
    end
  end

  # GET /materias/new
  # GET /materias/new.xml
  def new
    @materia = Materia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @materia }
    end
  end

  # GET /materias/1/edit
  def edit
    @materia = Materia.find(params[:id])
  end

  # POST /materias
  # POST /materias.xml
  def create
    @materia = Materia.new(params[:materia])

    respond_to do |format|
      if @materia.save
        flash[:notice] = 'Materia creada satisfactoriamente.'
        format.html { redirect_to(@materia) }
        format.xml  { render :xml => @materia, :status => :created, :location => @materia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @materia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /materias/1
  # PUT /materias/1.xml
  def update
    @materia = Materia.find(params[:id])

    respond_to do |format|
      if @materia.update_attributes(params[:materia])
        flash[:notice] = 'Materia actualizada correctamente.'
        format.html { redirect_to(@materia) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @materia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /materias/1
  # DELETE /materias/1.xml
  def destroy
    @materia = Materia.find(params[:id])
    @materia.destroy

    respond_to do |format|
      format.html { redirect_to(materias_url) }
      format.xml  { head :ok }
    end
  end
end
