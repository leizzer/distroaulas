class TipoespaciosController < ApplicationController
  # GET /tipoespacios
  # GET /tipoespacios.xml
  def index
    @tipoespacios = Tipoespacio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tipoespacios }
    end
  end

  # GET /tipoespacios/1
  # GET /tipoespacios/1.xml
  def show
    @tipoespacio = Tipoespacio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tipoespacio }
    end
  end

  # GET /tipoespacios/new
  # GET /tipoespacios/new.xml
  def new
    @tipoespacio = Tipoespacio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tipoespacio }
    end
  end

  # GET /tipoespacios/1/edit
  def edit
    @tipoespacio = Tipoespacio.find(params[:id])
  end

  # POST /tipoespacios
  # POST /tipoespacios.xml
  def create
    @tipoespacio = Tipoespacio.new(params[:tipoespacio])

    respond_to do |format|
      if @tipoespacio.save
        flash[:notice] = 'Tipo creado satisfactoriamente.'
        format.html { redirect_to(@tipoespacio) }
        format.xml  { render :xml => @tipoespacio, :status => :created, :location => @tipoespacio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tipoespacio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipoespacios/1
  # PUT /tipoespacios/1.xml
  def update
    @tipoespacio = Tipoespacio.find(params[:id])

    respond_to do |format|
      if @tipoespacio.update_attributes(params[:tipoespacio])
        flash[:notice] = 'Tipo actualizado correctamente.'
        format.html { redirect_to(@tipoespacio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tipoespacio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipoespacios/1
  # DELETE /tipoespacios/1.xml
  def destroy
    @tipoespacio = Tipoespacio.find(params[:id])
    @tipoespacio.destroy

    respond_to do |format|
      format.html { redirect_to(tipoespacios_url) }
      format.xml  { head :ok }
    end
  end
end
