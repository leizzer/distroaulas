class CarrerasController < ApplicationController
  # GET /carreras
  # GET /carreras.xml
  def index
    @carreras = Carrera.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carreras }
    end
  end

  # GET /carreras/1
  # GET /carreras/1.xml
  def show
    @carrera = Carrera.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @carrera }
    end
  end

  # GET /carreras/new
  # GET /carreras/new.xml
  def new
    @carrera = Carrera.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @carrera }
    end
  end

  # GET /carreras/1/edit
  def edit
    @carrera = Carrera.find(params[:id])
  end

  # POST /carreras
  # POST /carreras.xml
  def create
    @carrera = Carrera.new(params[:carrera])
    respond_to do |format|
      if @carrera.save
        flash[:notice] = 'Se creo la carrera satisfactoriamente.'
        format.html { redirect_to(@carrera) }
        format.xml  { render :xml => @carrera, :status => :created, :location => @carrera }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @carrera.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carreras/1
  # PUT /carreras/1.xml
  def update
    @carrera = Carrera.find(params[:id])

    respond_to do |format|
      if @carrera.update_attributes(params[:carrera])
        flash[:notice] = 'Carrera actualizada correctamente.'
        format.html { redirect_to(@carrera) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @carrera.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /carreras/1
  # DELETE /carreras/1.xml
  def destroy
    @carrera = Carrera.find(params[:id])
    @carrera.destroy

    respond_to do |format|
      format.html { redirect_to(carreras_url) }
      format.xml  { head :ok }
    end
  end
end
