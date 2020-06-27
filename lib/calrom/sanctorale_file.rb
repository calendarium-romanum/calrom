module Calrom
  # Wraps arbitrary sanctorale files and allows handling and loading them exactly
  # the same way as bundled sanctorale files.
  #
  # Erm, yes, according to calendarium-romanum documentation the parent class is actually
  # not intended for use like this. But we take the risk of breakage by future
  # calendarium-romanum releases ;)
  class SanctoraleFile < CR::Data::SanctoraleFile
    def initialize(path)
      @siglum = nil
      @path = path
    end
  end
end
