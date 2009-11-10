class EspaciosController < ApplicationController
  # GET /espacios
  # GET /espacios.xml
  def index
    @espacios = Espacio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @espacios }
    end
  end

  # GET /espacios/1
  # GET /espacios/1.xml
  def show
    @espacio = Espacio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @espacio }
    end
  end

  # GET /espacios/new
  # GET /espacios/new.xml
  def new
    @espacio = Espacio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @espacio }
    end
  end

  # GET /espacios/1/edit
  def edit
    @espacio = Espacio.find(params[:id])
  end

  # POST /espacios
  # POST /espacios.xml
  def create
    @espacio = Espacio.new(params[:espacio])

    respond_to do |format|
      if @espacio.save
        flash[:notice] = 'Se creo el espacio satisfactoriamente.'
        format.html { redirect_to(@espacio) }
        format.xml  { render :xml => @espacio, :status => :created, :location => @espacio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @espacio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /espacios/1
  # PUT /espacios/1.xml
  def update
    @espacio = Espacio.find(params[:id])

    respond_to do |format|
      if @espacio.update_attributes(params[:espacio])
        flash[:notice] = 'Espacio actualizado correctamente.'
        format.html { redirect_to(@espacio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @espacio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /espacios/1
  # DELETE /espacios/1.xml
  def destroy
    @espacio = Espacio.find(params[:id])
    @espacio.destroy

    respond_to do |format|
      format.html { redirect_to(espacios_url) }
      format.xml  { head :ok }
    end
  end
end
