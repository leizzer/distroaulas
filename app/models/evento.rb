# -*- coding: utf-8 -*-
class Evento < ActiveRecord::Base
  require 'ri_cal'

  validates_numericality_of :interval
  before_save :set_dates, :set_materia_id

  belongs_to :espacio

  # set_dates toma el self.dtstart y copia la fecha (solo dia-mes-año) a self.dtend,
  # de este modo, el evento empieza y termina el mismo dia.
  def set_dates
    temp = self.dtstart.year.to_s
    if self.dtstart.month.to_s.length == 1
      temp += "0" + self.dtstart.month.to_s
    else
      temp += self.dtstart.month.to_s
    end
    if self.dtstart.day.to_s.length == 1
      temp += "0" + self.dtstart.day.to_s + "T"
    else
      temp += self.dtstart.day.to_s
    end
    if self.dtend.hour.to_s.length == 1
      temp += "0" + self.dtend.hour.to_s
    else
      temp += self.dtend.hour.to_s
    end
    if self.dtend.min.to_s.length == 1
      temp += "0" + self.dtend.min.to_s
    else
      temp += self.dtend.min.to_s
    end
    # temp += '-0300'
    self.dtend = DateTime.parse(temp)
    self.dtstart = DateTime.parse(self.dtstart.strftime '%Y-%m-%d %H:%M:%S')
   end

  # Validaciones varias
  def validate
    # Preparo las fechas de self
    set_dates

    # Validacion del rango, el evento no puede tener un dtend menor a dtstart, el rango seria negativo
    if self.dtend < self.dtstart
      errors.add('Inicio y fin',  "El inicio es mas temprano que el fin. El rango no es valido.")
    end

    # Valida que si es recurrente, el byday que se especifica corresponda a la fecha de comienzo.
    if self.reccurrent
      if self.dtstart.strftime("%a").upcase[0..1] != self.byday
        errors.add 'Día de Reccurrencia:', 'La fecha de comienzo no es del día de recurrencia especificado.'
      end
    end

    # Creacion del calendario para calcular ocurrencias
    calendar = RiCal.Calendar

    # Busqueda de los eventos que tengan ocurrencias el dia de self.dtstart, en el espacio que puede generarse conflicto
    events = Evento.find(:all, :conditions => "dtstart > '#{self.dtstart.to_date}' AND '#{self.dtstart.to_date + 1.day}' > dtstart AND reccurrent = 'f' AND espacio_id = #{self.espacio_id}") + Evento.find(:all, :conditions => { :reccurrent => true, :espacio_id => self.espacio_id})

    # Exclusion del evento self
    events.delete self

    # Genero evento tipo icalendar con el actual
    self_event = RiCal.Event
    self_event.description = self.description || ''
    self_event.dtstart = self.dtstart #.strftime '%Y%m%dT%H%M00'
    self_event.dtend = self.dtend #.strftime '%Y%m%dT%H%M00'
    self_event.location = self.espacio_id.to_s
    self_event.rrule = "FREQ=" + self.freq + ";BYDAY=" + self.byday + ";INTERVAL=" + self.interval.to_s if self.reccurrent
    self_event.exdate = self.exdate || ''
    self_event.rdate = self.rdate || ''


    # Saco la lista de ocurrencias del evento actual en los proximos 60
    list_occu = []
    self_event.occurrences(:starting => Date.today, :before => Date.today+60.day).each do |o|
      list_occu << o.dtstart
      list_occu << o.dtend
    end
    puts list_occu
    # Carga al calendario
    events.each do |event|
      new_event = RiCal.Event
      new_event.description = event.description || ''
      new_event.dtstart = event.dtstart #.strftime '%Y%m%dT%H%M00'
      new_event.dtend = event.dtend #.strftime '%Y%m%dT%H%M00'
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s if event.reccurrent
      new_event.exdate = event.exdate || ''
      new_event.rdate = event.rdate || ''


      puts new_event.occurrences :starting => Date.today, :before => Date.today + 60.day
      # Veo si ocurren coliciones
      colition = new_event.occurrences(:overlapping => list_occu, :starting => Date.today, :before => Date.today + 60.day)
      puts "/////////////////////////"
      puts colition
      # Si el array colitions no esta vacio, entonces hay colicion
      if not colition.empty?
          errors.add 'Colicion:', " el evento ocuparia el mismo espacio que #{new_event.description} en el mismo horario"
      end
    end
  end

  # set_materia_id obtiene el codigo al inicio de la descripcion, si esta contiene una materia cargada en el sistema
  def set_materia_id
    if materia = Materia.find(:first, :conditions =>  {:codigo => self.description.split(' ')[0]})
      self.materia_id = materia.codigo
    end
  end
end

