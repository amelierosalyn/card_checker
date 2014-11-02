#!/usr/bin/ruby

class CardChecker
  def initialize(number)
    # Remove any spaces etc
    @card_number = number.to_s.gsub(/\s+/, '')
  end

  # Regexes for card types
  AMEX = /^3(4|7)\d{13}$/
  DISC = /^6011\d{12}$/
  MAST = /^5[1-5]\d{14}$/
  VISA = /^4(\d{12}|\d{15})$/

  # Check the card type
  def card_type
    if @card_number.to_s.match(AMEX)
      card_type = 'AMEX'
    elsif @card_number.to_s.match(DISC)
      card_type = 'Discover'
    elsif @card_number.to_s.match(MAST)
      card_type = 'MasterCard'
    elsif @card_number.to_s.match(VISA)
      card_type = 'Visa'
    else
      card_type = 'Unknown'
    end
    return card_type
  end

  # Check the number is valid
  def valid_number?
    sum_total = 0

    # Go through the card number, last but one first - reverse numbers to make this easier
    @card_number.scan(/\d/).reverse.each_with_index do |num,i|

      # Every second number needs to be doubled
      if i.odd?
        doubled = num.to_i*2

        # Double digits and higher (10+) need to be added together
        if doubled > 9
          sum_total += eval(doubled.to_s.scan(/\d/).join('+')).to_i
        else
          sum_total += doubled
        end
      else
        sum_total += num.to_i
      end
    end

    # Valid card number if multiple of 10
    if sum_total % 10 == 0
      return true
    else
      return false
    end
  end
end

# No card number supplied
raise ArgumentError, 'No card number supplied' if ARGV.empty?

# Run the validations
ARGV.each do |card_num|
  raise ArgumentError, 'Card number not found' if card_num.empty?

  c = CardChecker.new(card_num.chomp)
  puts "#{c.card_type}: #{card_num} (#{c.valid_number? ? 'Valid' : 'Invalid'})"
end