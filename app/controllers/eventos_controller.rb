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
    @lista_materias = Materia.all
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
          @search_by_date = Date.parse(params[:date][:year] + '-' + params[:date][:month] + '-' + params[:date][:day])
        rescue => e
          @search_by_date = Date.today
        end
      end
    end
    @events = []
    @calendar = get_calendar(@search_by_date, nil)

    @free_spaces = Espacio.all
    @calendar.events.each do |event|

      temp = SimpEvent.new
      temp.starts_at = event.dtstart
      temp.ends_at = event.dtend
      temp.name = event.description + ' - ' +  Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo
      temp.original_id = event.comment[0].to_i
      @events.push temp

      @free_spaces.delete(Espacio.find_by_id event.location.to_i) if DateTime.now.strftime('%H%M').to_i.between? event.dtstart.strftime('%H%M').to_i, event.dtend.strftime('%H%M').to_i
    end
  end

  def get_materias
    @lista_materias = Materia.find :all, :conditions => {:codigo_carrera => params[:carrera_id]}
    render :update do |page|
      page.replace_html 'materias', :partial => 'materias', :object => @lista_materias
    end
  end

  def browse_by_space
    @events = []
    @calendar = get_calendar(Date.today, nil)
    @calendar.events.each do |event|
      temp = SimpEvent.new
      temp.starts_at = event.dtstart
      temp.ends_at = event.dtend
      temp.name = event.description + ' - ' +  Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo
      temp.original_id = event.comment[0].to_i
      temp.location = event.location.to_i
      @events.push temp
    end
  end

  def get_calendar(date, space)
    calendar = RiCal.Calendar
    if space.nil?
      events_list = Evento.find(:all, :conditions => "dtstart > '#{date}' AND '#{date + 1.day}' > dtstart AND reccurrent = 'f'") + Evento.find(:all, :conditions => { :reccurrent => true, :byday => date.strftime("%a").upcase[0..1]})
    else
      events_list = Evento.find(:all, :conditions => "dtstart > '#{date}' AND '#{date + 1.day}' > dtstart AND reccurrent = 'f' AND espacio_id = #{space}") + Evento.find(:all, :conditions => { :reccurrent => true, :byday => date.strftime("%a").upcase[0..1], :espacio_id => space})
    end

    events_list.each do |event|
      new_event = RiCal.Event
      new_event.description = event.description || ''
      new_event.dtstart = event.dtstart.strftime '%Y%m%dT%H%M00'
      new_event.dtend = event.dtend.strftime '%Y%m%dT%H%M00'
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s if event.reccurrent
      new_event.exdates = event.exdate.to_a
      new_event.rdates = event.rdate.to_a
      new_event.comment = event.id.to_s
      #Occurrences te va a manejar automaticamente las exdates y rdates, no tenes que hacer ningun otro calculo mas que cargarlos al evento.
      #Creo que son las primeras lineas de comentario en TODA la aplicacion XD Mal
      if event.reccurrent
        occurrence = new_event.occurrences :count => 1, :starting => date, :before => date + 1
        if occurrence.count > 0
          calendar.add_subcomponent occurrence[0] #new_event
        end
      else
        calendar.add_subcomponent new_event if (Date.parse(event.dtstart.year.to_s + '/' +  event.dtstart.month.to_s + '/' + event.dtstart.day.to_s)) == date
      end
    end
    return calendar
  end
end


