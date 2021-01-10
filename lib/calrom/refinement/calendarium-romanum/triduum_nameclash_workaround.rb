module Calrom
  module Refinement
    module CalendariumRomanum
      # Refinement used when evaluating the Day/Celebration filter expressions.
      # Allows the user (at least in simple cases) to write just `TRIDUUM` both
      # as a season and as a rank.
      module TriduumNameClashWorkaround
        refine CR::Season do
          alias_method :old_equal, :==

          def ==(other)
            if other.is_a?(CR::Rank) && self == CR::Seasons::TRIDUUM
              return CR::Ranks::TRIDUUM == other
            end

            return old_equal(other)
          end
        end

        refine CR::Rank do
          alias_method :old_equal, :==

          def ==(other)
            if other.is_a?(CR::Season) && self == CR::Ranks::TRIDUUM
              return CR::Seasons::TRIDUUM == other
            end

            return old_equal other
          end
        end
      end
    end
  end
end
