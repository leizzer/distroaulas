class EventosController < ApplicationController
  require 'ri_cal'
  require 'simplified_event'

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
    @evento.espacio_id = params[:espacio_id].to_i if not params[:espacio_id].nil?
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

  def browse_by_day
    if params[:date].nil?
      if params[:start_date].nil?
        @search_by_date = Date.today
      else
        @search_by_date = params[:start_date].to_date
      end
    else
      if @search_by_date.nil?
        begin
          @search_by_date = Date.parse(params[:date][:year] + params[:date][:month] + params[:date][:day])
        rescue => e
          @search_by_date = Date.today
        end
      end
    end
    @events = []
    @calendar = RiCal.Calendar
    @events_list = Evento.find(:all, :conditions => "dtstart > '#{@search_by_date}' AND '#{@search_by_date + 1.day}' > dtstart AND reccurrent = 'f'") + Evento.find(:all, :conditions => { :reccurrent => true, :byday => @search_by_date.strftime("%a").upcase[0..1]})

    @events_list.each do |event|
      temp = SimpEvent.new
      new_event = RiCal.Event
      new_event.description = event.description
      new_event.dtstart = event.dtstart.strftime '%Y%m%dT%H%M00'
      new_event.dtend = event.dtend.strftime '%Y%m%dT%H%M00'
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s if event.reccurrent
      new_event.exdates = event.exdate.to_a
      new_event.rdates = event.rdate.to_a
      codigo_espacio = Espacio.find :first, :conditions => {:id => event.espacio_id}
      #Occurrences te va a manejar automaticamente las exdates y rdates, no tenes que hacer ningun otro calculo mas que cargarlos al evento.
      #Creo que son las primeras lineas de comentario en TODA la aplicacion XD Mal
      if event.reccurrent
        occurrence = new_event.occurrences :count => 1, :starting => @search_by_date, :before => @search_by_date + 1
        if occurrence.count > 0
          @calendar.add_subcomponent new_event
          temp.starts_at = occurrence[0].dtstart
          temp.ends_at = occurrence[0].dtend
          temp.name = event.description + ' - ' + codigo_espacio.codigo
          temp.original_id = event.id
          @events.push temp
        end
      else
        @calendar.add_subcomponent new_event if (Date.parse(event.dtstart.year.to_s + '/' +  event.dtstart.month.to_s + '/' + event.dtstart.day.to_s)) == @search_by_date
        temp.starts_at = new_event.dtstart
        temp.ends_at = new_event.dtend
        temp.name = new_event.description + ' - ' + codigo_espacio.codigo
        temp.original_id = event.id
        @events.push temp 
      end
    end
    @free_spaces = Espacio.all
    @calendar.events.each do |event|
      @free_spaces.delete(Espacio.find_by_id event.location.to_i) if DateTime.now.strftime('%H%M').to_i.between? event.dtstart.strftime('%H%M').to_i, event.dtend.strftime('%H%M').to_i
    end
  end

  def load_exceptions

  end
end


