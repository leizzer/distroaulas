class AdministrationController < ApplicationController

  def index
  end

  def clean_events
    counter = Evento.delete(Evento.find(:all, :conditions => "dtend < '#{Date.today}' AND reccurrent = 'f'").collect {|event| event.id})
    if counter > 0
      flash[:notice] = "Se han borrado #{counter} eventos de la base de datos"
    end
    redirect_back_or_default '/administration'
  end

  def clean_reccur
    counter = Evento.delete Evento.find(:all, :conditions => {:reccurrent => 't'})
    flash[:notice] = "Se han borrado #{counter} eventos recurrentes."
    redirect_back_or_default '/administration'
  end

  def destroy_subjects
    counter = Materia.delete_all
    if counter > 0
      flash[:notice] = "Se han borrado #{counter} materias de la base de datos"
    end
    redirect_back_or_default '/administration'
  end

  def destroy_plans
    counter = Plan.delete_all
    if counter > 0
      flash[:notice] = "Se han borrado #{counter} planes de la base de datos"
    end
    redirect_back_or_default '/administration'
  end

  def destroy_careers
    counter = Carrera.delete_all
    if counter > 0
      flash[:notice] = "Se han borrado #{counter} carreras de la base de datos"
    end
    redirect_back_or_default '/administration'
  end

  def destroy_extdb
    counter_m = Materia.delete_all
    counter_p = Plan.delete_all
    counter_c = Carrera.delete_all
    flash[:notice] = "Se han borrado #{counter_m} materias, #{counter_p} planes y #{counter_c} carreras de la base de datos" if counter_m + counter_p + counter_c > 0
    redirect_back_or_default '/administration'
  end
end
