# -*- coding: utf-8 -*-
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

  # Busqueda de eventos por dia y carrera
  def browse_by_day
    # Checkeo de parametros. El parametro date contiene la fecha seleccionada, pero puede venir tambien star_date,
    # con el mismo uso. Hay dos, porque el weekly_viewer usa start_date, pero habria que unificarlo.
    # Si hay algo en esos parametros se usa eso, y si no se usa la fecha de hoy.
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
    if params.include? :business_hours
      @business_hours = params[:business_hours]
    end
    if not params[:carrera].nil?
      @carrera_selected = params[:carrera][:carrera_id]
    end

    # busqueda de los eventos por año, los del año "0" son los eventos no recurrentes en este momento, pero eso esta mal, deberian ser los que no estan
    # asignados a una materia. Lo de que sean recurrentes o no recurrentes, ya no es tan asi en esta busqueda y debemos cambiarlo, pero me termino de avivar recien
    # y ya es tarde
    @free_spaces = Espacio.all
    6.times do |an|
      @calendar = nil
      @calendar = get_calendar :date => @search_by_date, :career => (params.include? :carrera) ? params[:carrera][:carrera_id] : nil, :year => an
      @calendar.events.each do |event|

        temp = SimpEvent.new
        temp.starts_at = event.dtstart
        temp.ends_at = event.dtend
        temp.name = event.description + ' - ' +  Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo
        temp.original_id = event.comment[0].to_i
        temp.anio = an
        @events.push temp

        @free_spaces.delete(Espacio.find_by_id event.location.to_i) if DateTime.now.strftime('%H%M').to_i.between? event.dtstart.strftime('%H%M').to_i, event.dtend.strftime('%H%M').to_i
      end
    end
    @ver_horas = params[:ver_horas] == "1" ? false : true
    redirect_to "/eventos/browse_by_day?business_hours=#{@ver_horas}&start_date=#{@search_by_date}" unless params[:ver_horas].nil?
 end


  # Busca las materias de una carrera para ofrecerla en un combo en el new de eventos
  def get_materias
    @lista_materias = Materia.find :all, :conditions => {:codigo_carrera => params[:carrera_id]}
    render :update do |page|
      page.replace_html 'materias', :partial => 'materias', :object => @lista_materias
    end
  end

  # Busqueda de de eventos por espacio asignado
  def browse_by_space
    if params[:date].nil?
      @search_by_date = DateTime.now
    else
      if @search_by_date.nil?
        begin
          @search_by_date = DateTime.parse(params[:date][:year] + '-' + params[:date][:month] + '-' + params[:date][:day] + ' ' + params[:date][:hour] + ':' + params[:date][:minute])
        rescue => e
          @search_by_date = DateTime.now
        end
      end
    end

    @events = []
    @free_spaces = Espacio.all
    # get_calendar obtiene un calendario para un dia dado. El parametro all hace que no discrimine por materias
    @calendar = get_calendar :date => @search_by_date.to_date, :all => true
    if not params[:espacio].nil?
      @espacio_selected = params[:espacio][:espacio_id]
    end
    @calendar.events.each do |event|
      temp = SimpEvent.new
      temp.starts_at = event.dtstart
      temp.ends_at = event.dtend
      temp.name = event.description # + ' - ' +  Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo
      temp.original_id = event.comment[0].to_i
      temp.location = event.location.to_i
      if not params[:espacio].nil? and params[:espacio][:espacio_id] != 'all'
        @events.push temp if temp.location == params[:espacio][:espacio_id].to_i
      else
        @events.push temp
      end
      @free_spaces.delete(Espacio.find_by_id event.location.to_i) if @search_by_date.strftime('%H%M').to_i.between? event.dtstart.strftime('%H%M').to_i, event.dtend.strftime('%H%M').to_i
    end
  end

  # Obtiene un calendario segun los parametros que recibe
  # parametros: all = buscar todos, date = fecha a filtrar, space = espacio a filtrar
  def get_calendar opt = {}
    calendar = RiCal.Calendar
    subjects = []
    events_list = []
    if opt[:space].nil?
      #Crea la lista de id's de materias que corresponden a la carrera en un año dado
      Materia.find(:all, :conditions => {:codigo_carrera => opt[:career], :anio => opt[:year]}).each do |m|
        subjects << m.codigo.to_i
      end
      #Lo de buscar no reccurrentes diferenciando de los recurrentes es algo que quedo de la vieja busqueda y deberia ser adaptado todo
      #  al nuevo objetivo de esta busqueda. Deberia verse que no pertenece a ninguna materia.
      if opt[:all]
        events_list = Evento.find :all, :conditions => "dtstart > '#{opt[:date]}' AND '#{opt[:date] + 1.day}' > dtstart AND reccurrent = 'f'"
        events_list += Evento.find :all, :conditions => { :reccurrent => true, :byday => opt[:date].strftime("%a").upcase[0..1]}
        events_list += Evento.find :all, :conditions => "reccurrent = 't' AND rdate <> ''"
        events_list += Evento.find :all, :conditions => "reccurrent = 't' AND exdate <> ''"
      else
        events_list = Evento.find :all, :conditions => "dtstart > '#{opt[:date]}' AND '#{opt[:date] + 1.day}' > dtstart AND reccurrent = 'f'" if opt[:year] == 0
        events_list += Evento.find :all, :conditions => { :reccurrent => true, :byday => opt[:date].strftime("%a").upcase[0..1]}
        events_list += Evento.find :all, :conditions => "reccurrent = 't' AND rdate <> ''"
        events_list += Evento.find :all, :conditions => "reccurrent = 't' AND exdate <> ''"
      end
    else
      # Buscar eventos segun un espacio
      events_list = Evento.find(:all, :conditions => "dtstart > '#{opt[:date]}' AND '#{opt[:date] + 1.day}' > dtstart AND reccurrent = 'f' AND espacio_id = #{opt[:space]}")
      events_list += Evento.find(:all, :conditions => { :reccurrent => true, :byday => opt[:date].strftime("%a").upcase[0..1], :espacio_id => opt[:space]})
      events_list += Evento.find :all, :conditions => "reccurrent = 't' AND rdate <> ''"
      events_list += Evento.find :all, :conditions => "reccurrent = 't' AND exdate <> ''"

    end

    # Elimina duplicados
    events_list.uniq!

    # Carga al calendario
    events_list.each do |event|
      new_event = RiCal.Event
      new_event.description = event.description || ''
      new_event.dtstart = event.dtstart.strftime '%Y%m%dT%H%M00'
      new_event.dtend = event.dtend.strftime '%Y%m%dT%H%M00'
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s + ";UNTIL=" + event.renddate.strftime('%Y%m%dT%H%M00') if event.reccurrent
      new_event.exdates = event.exdate.to_a
      new_event.rdates =  event.rdate.split(',').collect{|e| DateTime.parse e} || ''
      new_event.comment = event.id.to_s

      # Analisis de ocurrencia
      if event.reccurrent
        occurrence = new_event.occurrences :count => 1, :starting => opt[:date], :before => opt[:date] + 1
        if occurrence.count > 0
          if event.materia_id.nil? or opt[:all]
            # Agregar el evento sin materia
            calendar.add_subcomponent occurrence[0]
          else
            # Agregar el evento si coincide con alguna materia en subjects
            calendar.add_subcomponent occurrence[0] if subjects.include? event.materia_id #new_event
          end
        end
      else
        if event.materia_id.nil? or opt[:all]
          # Agregar el evento sin discriminarlo
          calendar.add_subcomponent new_event if Date.parse(event.dtstart.year.to_s + '/' + event.dtstart.month.to_s + '/' + event.dtstart.day.to_s) == opt[:date]
        else
          # Agregar el evento si coincide con alguna materia en subjets
          calendar.add_subcomponent new_event if Date.parse(event.dtstart.year.to_s + '/' +  event.dtstart.month.to_s + '/' + event.dtstart.day.to_s) == opt[:date] and subjects.include? event.materia_id
        end
      end
    end
    return calendar
  end
end


