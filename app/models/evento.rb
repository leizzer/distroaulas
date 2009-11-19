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
    # Prerao las fechas de self
    set_dates

    # Validacion del rango, el evento no puede tener un dtend menor a dtstart, el rango seria negativo
    if self.dtend < self.dtstart
      errors.add('Inicio y fin',  "El inicio es mas temprano que el fin. El rango no es valido.")
    end

    # Creacion del calendario para calcular ocurrencias
    calendar = RiCal.Calendar

    # Busqueda de los eventos que tengan ocurrencias el dia de self.dtstart
    events = Evento.find(:all, :conditions => "dtstart > '#{self.dtstart.to_date}' AND '#{self.dtstart.to_date + 1.day}' > dtstart AND reccurrent = 'f' AND espacio_id = #{self.espacio_id}") + Evento.find(:all, :conditions => { :reccurrent => true, :byday => self.dtstart.strftime("%a").upcase[0..1], :espacio_id => self.espacio_id})

    # Exclusion del evento self
    events.delete self

    # Carga al calendario
    events.each do |event|
      new_event = RiCal.Event
      new_event.description = event.description || ''
      new_event.dtstart = event.dtstart #.strftime '%Y%m%dT%H%M00'
      new_event.dtend = event.dtend #.strftime '%Y%m%dT%H%M00'
      new_event.location = event.espacio_id.to_s
      new_event.rrule = "FREQ=" + event.freq + ";BYDAY=" + event.byday + ";INTERVAL=" + event.interval.to_s if event.reccurrent
      new_event.exdates = event.exdate || ''
      new_event.rdates = event.rdate || ''

      #Occurrences te va a manejar automaticamente las exdates y rdates, no tenes que hacer ningun otro calculo mas que cargarlos al evento.
      #Creo que son las primeras lineas de comentario en TODA la aplicacion XD Mal
      if event.reccurrent
        occurrence = new_event.occurrences :count => 1, :starting => self.dtstart.to_date, :before => self.dtstart.to_date + 1.day
        if occurrence.count > 0
          # La ocurrencia es un evento tambien, asi que puede agregarse al calendario como cualquier evento
          # Si hay una ocurrencia en el dia de self.dtstart, la agrego
          calendar.add_subcomponent occurrence[0]
        end
      else
        # Si el evento no era recurrente, lo agrego al calendario si es de la fecha de self.dtstart
        calendar.add_subcomponent new_event if (Date.parse(event.dtstart.year.to_s + '/' +  event.dtstart.month.to_s + '/' + event.dtstart.day.to_s)) == self.dtstart.to_date
      end
    end

    # Analisis de fechas, aqui se checkea si self colisiona con otro evento
    calendar.events.each do |event|
      if self.dtstart.between? event.dtstart, event.dtend
        errors.add('Inicio: ',  "Conflicto con #{event.description} en #{Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo} de #{event.dtstart.strftime('%H:%M')} a #{event.dtend.strftime('%H:%M')}")
      end
      if self.dtend.between? event.dtstart, event.dtend
        errors.add('Finalizacion: ', "Conflicto con #{event.description} en #{Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo} de #{event.dtstart.strftime('%H:%M')} a #{event.dtend.strftime('%H:%M')}")
      end
      if event.dtstart.between? self.dtstart, self.dtend or event.dtend.between? self.dtstart, self.dtend
        errors.add('Inicio y finalizacion: ', "Conflicto con #{event.description} en #{Espacio.find(:first, :conditions => {:id => event.location.to_i}).codigo} de #{event.dtstart.strftime('%H:%M')} a #{event.dtend.strftime('%H:%M')}")
      end
    end
  end

  # set_materia_id obtiene el codigo al inicio de la descripcion, si esta contiene una materia cargada en el sistema
  def set_materia_id
    if materia == Materia.find(:first, :conditions =>  {:codigo => self.description.split(' ')[0]})
      self.materia_id = materia.codigo
    end
  end
end

