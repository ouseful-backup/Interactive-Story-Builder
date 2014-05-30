# encoding: utf-8
module HasPermalink

  module InstanceMethods
    @found_duplicate = false
    
    # the gem returns permalink here and we do not want this for all links
    # so overriding and reseting back to self.id
    def to_param
      "#{self.id}"
    end

    # indicate if the permalink was found to be a duplicate
    # and had to have a number added to the end
    def is_duplicate_permalink?
      @found_duplicate == true
    end 

    private 
    
    def resolve_duplication(permalink, number)
      @found_duplicate = true
      "#{permalink}-#{number}"
    end
  end
end


module FriendlyUrl
  $KCODE = "U" unless RUBY_VERSION > "1.9.0"

  # add to_ascii method to catch all utf8 characters   
  def normalize(str)
    unless str.blank?
      n = str.mb_chars.downcase.to_s.strip.to_ascii
=begin
      n.gsub!(/[àáâãäåāă]/,     'a')
      n.gsub!(/æ/,              'ae')
      n.gsub!(/[ďđ]/,           'd')
      n.gsub!(/[çćčĉċ]/,        'c')
      n.gsub!(/[èéêëēęěĕė]/,    'e')
      n.gsub!(/ƒ/,              'f')
      n.gsub!(/[ĝğġģ]/,         'g')
      n.gsub!(/[ĥħ]/,           'h')
      n.gsub!(/[ììíîïīĩĭ]/,     'i')
      n.gsub!(/[įıĳĵ]/,         'j')
      n.gsub!(/[ķĸ]/,           'k')
      n.gsub!(/[łľĺļŀ]/,        'l')
      n.gsub!(/[ñńňņŉŋ]/,       'n')
      n.gsub!(/[òóôõöøōőŏŏ]/,   'o')
      n.gsub!(/œ/,              'oe')
      n.gsub!(/ą/,              'q')
      n.gsub!(/[ŕřŗ]/,          'r')
      n.gsub!(/[śšşŝș]/,        's')
      n.gsub!(/[ťţŧț]/,         't')
      n.gsub!(/[ùúûüūůűŭũų]/,   'u')
      n.gsub!(/ŵ/,              'w')
      n.gsub!(/[ýÿŷ]/,          'y')
      n.gsub!(/[žżź]/,          'z')
=end
      n.gsub!(/\s+/,            '-')
      n.gsub!(/[^[:alnum:]_\-]/, '')
#      n.gsub!(/[^\sa-z0-9_-]/,  '')
      n.gsub!(/-{2,}/,          '-')
      n.gsub!(/^-/,             '')
      n.gsub!(/-$/,             '')
      n
    end
  end
end
