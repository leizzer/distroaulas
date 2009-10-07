class EventosController < ApplicationController
  # GET /eventos
  # GET /eventos.xml
  def index
    @eventos = Evento.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @eventos }
    end
  end

  # GET /eventos/1
  # GET /eventos/1.xml
  def show
    @evento = Evento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @evento }
    end
  end

  # GET /eventos/new
  # GET /eventos/new.xml
  def new
    @evento = Evento.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @evento }
    end
  end

  # GET /eventos/1/edit
  def edit
    @evento = Evento.find(params[:id])
  end

  # POST /eventos
  # POST /eventos.xml
  def create
    @evento = Evento.new(params[:evento])

    respond_to do |format|
      if @evento.save
        flash[:notice] = 'Evento was successfully created.'
        format.html { redirect_to(@evento) }
        format.xml  { render :xml => @evento, :status => :created, :location => @evento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /eventos/1
  # PUT /eventos/1.xml
  def update
    @evento = Evento.find(params[:id])

    respond_to do |format|
      if @evento.update_attributes(params[:evento])
        flash[:notice] = 'Evento was successfully updated.'
        format.html { redirect_to(@evento) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @evento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /eventos/1
  # DELETE /eventos/1.xml
  def destroy
    @evento = Evento.find(params[:id])
    @evento.destroy

    respond_to do |format|
      format.html { redirect_to(eventos_url) }
      format.xml  { head :ok }
    end
  end
end
