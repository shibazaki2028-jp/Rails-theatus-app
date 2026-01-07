class ScheduleController < ApplicationController
    def index
        @schedules = Schedule.includes(:movie, :screen).order(screened_at: :asc)
    end
end
