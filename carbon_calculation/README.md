### Instructions for running CO2 adjustment calculation:

- Navigate to yb-backend-challenge/carbon_calculation on my fork
- Run 'bundle install' and then 'irb'
- From inside irb, run the following:
  - load './lib/adjusted_carbon_total.rb'
  - Default successful run: AdjustedCarbonTotal.process_from_file

  - Run with data that will print validation error messages:
    AdjustedCarbonTotal.process_from_file('./bad_data.json')

  - Provide an input file by relative directory:
    AdjustedCarbonTotal.process_from_file('./data.json')

  - You can change the output file with a relative directory as well:|
    AdjustedCarbonTotal.process_from_file('./data.json', './abc_output_file.txt')

By default, input will be read from './input_data.json' and output will be printed to './adjusted_co2_emissions.txt' and to the terminal.

You can also run 'bundle exec rspec' from the carbon_calculation directory to run unit tests.
