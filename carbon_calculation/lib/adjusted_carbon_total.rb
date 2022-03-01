# frozen_string_literal: true

require 'json'

# Module containing the methods for calculating the adjusted total CO2 emissions for a company
module AdjustedCarbonTotal
  # Method to perform the actual calculation
  # Parameter for the input hash for a single entry/company
  # Returns the adjusted carbon total for a company
  def self.calculate_adjusted_co2(input)
    # MUpurch
    purchase_discount_factor = 0.5
    # MUmax_purch
    max_purchase_discount_factor = 0.8
    # PHIprod
    renewable_to_co2_factor = 0.05

    # CO2tot - CC
    total_co2_with_credit = input['Total CO2 Equivalents Emissions'] - input['Carbon Credit Value']

    # MUpurch * (REpurch / Etot)
    energy_ratio_discount_factor = purchase_discount_factor * (input['Renewable Energy Purchased'] / input['Total Energy Use'])

    # 1 - min(above, MUmax_purch)
    highest_discount_factor = 1 - [energy_ratio_discount_factor, max_purchase_discount_factor].min

    # PHIprod * REprod
    converted_renewable_produced = renewable_to_co2_factor * input['Renewable Energy Produced']

    # (CO2tot - CC) * (1 - min(above, MUmax_purch)) - (PHIprod * REprod)
    return total_co2_with_credit * highest_discount_factor - converted_renewable_produced
  end

  # Method to read the input 'data.json' file, call the calculation method, and return the output in a txt file
  # Optional parameters to provide input and output file paths
  # Prints out 'ISIN, Adjusted Carbon Total' pairs to the output file
  def self.process_from_file(input_path = './data.json', output_path = "./adjusted_co2_emissions.txt")
    unless File.exist?(input_path)
      warn('Provided input file does not exist')
      return
    end

    input_hash_array = JSON.parse(File.read(input_path))

    unless valid_input?(input_hash_array)
      return
    end

    output_array = []

    input_hash_array.each do |input|
      adjusted_co2_emissions = calculate_adjusted_co2(input)

      output_array << [input['ISIN'], adjusted_co2_emissions]
    end

    File.open(output_path, 'w') do |file|
      output_array.each { |output_pair| file.puts("#{output_pair[0]}, #{output_pair[1]}") }
    end
  end

  # Method to validate the input hash for required keys
  # Parameter for the input hash array
  # Raises errors in the case of a missing expected key
  def self.valid_input?(input_hash_array)
    expected_keys = ['ISIN', 'Total Energy Use', 'Total CO2 Equivalents Emissions', 'Renewable Energy Purchased', 'Renewable Energy Produced', 'Carbon Credit Value']
    valid_input_flag = true

    input_hash_array.each_with_index do |input_hash, index|
      required_elements_difference = expected_keys - input_hash.keys

      if required_elements_difference.any?
        warn("Input data element #{index + 1} is missing the following required keys: #{required_elements_difference}")
        valid_input_flag = false
      end
    end

    valid_input_flag
  end
end
