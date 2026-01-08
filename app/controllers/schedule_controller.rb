class ScheduleController < ApplicationController
    
    def index
        @schedules = Schedule.includes(:schedule, :screen).order(screened_at: :asc)
    end

end
