class Seat < ApplicationRecord
    belongs_to :screen

    validates :verse, presence: true
    validates :queue, presence: true,
        uniqueness: { scope: [:screen_id, :verse] }
    
    SEAT_TEMPLATES = {
        #座席を150個用意する
        "large" => { queue: ("A".."O"), verse: (1..10) },
        #座席を100個用意する
        "standard" => { queue: ("A".."J"), verse: (1..10) },
        #座席を50個用意する
        "small"    => { queue: ("A".."E"), verse: (1..10) }
    }

    def self.generate_for(screen)
        template = SEAT_TEMPLATES[screen.info]
        return if template.nil?

        create_seats(screen, template)
    end
    

      def self.create_seats(screen, template)
        template[:queue].each do |queue|
          template[:verse].each do |verse|
            create!(
            screen: screen,
            queue: queue,
            verse: verse,
            #name: "#{queue}-#{verse}"
            )
          end
        end
      end
    end
