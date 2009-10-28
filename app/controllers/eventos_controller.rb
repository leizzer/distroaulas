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
      @search_by_date = Date.today
    else
      begin
        @search_by_date = Date.parse(params[:date][:year] + params[:date][:month] + params[:date][:day])
      rescue => e
        @search_by_date = Date.today
      end
    end
    @events = []
    @calendar = RiCal.Calendar
    @events_list = Evento.find(:all, :conditions => {:reccurrent => false}) + Evento.find(:all, :conditions => { :reccurrent => true, :byday => @search_by_date.strftime("%a").upcase[0..1]})

    @events_list.each do |event|
      temp = Event.new
      new_event = RiCal.Event
      new_event.description = event.description
      new_event.dtstart = event.dtstart
      new_event.dtend = event.dtend
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s if event.reccurrent
      #new_event.exdate
      #new_event.rdate
      #Occurrences te va a manejar automaticamente las exdates y rdates, no tenes que hacer ningun otro calculo mas que cargarlos al evento.
      #Creo que son las primeras lineas de comentario en TODA la aplicacion XD Mal
      if event.reccurrent
        occurrence = new_event.occurrences :count => 1, :starting => @search_by_date, :before => @search_by_date + 1
        if occurrence.count > 0
          @calendar.add_subcomponent new_event
          temp.starts_at = occurrence[0].dtstart
          temp.ends_at = occurrence[0].dtend
          temp.name = event.description
          temp.original_id = event.id
          @events.push temp
        end
      else
        @calendar.add_subcomponent new_event if (Date.parse(event.dtstart.year.to_s + '/' +  event.dtstart.month.to_s + '/' + event.dtstart.day.to_s)) == @search_by_date
        temp.starts_at = new_event.dtstart
        temp.ends_at = new_event.dtend
        temp.name = new_event.description
        temp.original_id = event.id
        @events.push temp 
      end
    end
  end

  def load_exceptions

  end
end


