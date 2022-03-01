# frozen_string_literal: true

require 'adjusted_carbon_total'

# Unit tests for the AdjustedCarbonTotal module
describe AdjustedCarbonTotal do
  test_input_data_path = './spec/test_input_data.json'
  test_output_data_path = './spec/test_output_data.json'
  bad_test_input_data_path ='./spec/xyz.json'

  let(:valid_input_hash) do
    {
      'ISIN' => 'US0000000000',
      'Total Energy Use' => 7000000,
      'Total CO2 Equivalents Emissions' => 94972.49198,
      'Renewable Energy Purchased' => 10576.00479,
      'Renewable Energy Produced' => 96652.16115,
      'Carbon Credit Value' => 8171.323352
    }
  end

  let(:invalid_input_hash) do
    {
      'ISIN' => 'US0000000000',
      'Total CO2 Equivalents Emissions' => 94972.49198,
      'Renewable Energy Purchased' => 10576.00479,
      'Renewable Energy Produced' => 96652.16115,
      'Carbon Credit Value' => 8171.323352
    }
  end

  let(:valid_input_hash_array) { [valid_input_hash] }

  let(:invalid_input_hash_array) { [invalid_input_hash] }

  after do
    File.delete(test_output_data_path) if File.exist?(test_output_data_path)
  end

  describe 'calculate adjusted carbon total' do
    context 'with valid input hash' do
      it 'returns the expected total' do
        expect(AdjustedCarbonTotal.calculate_adjusted_co2(valid_input_hash)).to eq(81902.98845798663)
      end
    end
  end

  describe 'process from file' do
    context 'with valid input file' do
      it 'returns the expected output' do
        AdjustedCarbonTotal.process_from_file(test_input_data_path, test_output_data_path)
        results = File.read('./spec/test_output_data.json')
        expect(results).to eq("US0000000000, 81902.98845798663\nUS0000000001, 247545.0664717915\n")
      end
    end

    context 'with invalid input file' do
      context 'when file does not exist' do
        it 'returns an error message' do
          expect { AdjustedCarbonTotal.process_from_file(bad_test_input_data_path) }.to output("Provided input file does not exist\n").to_stderr
        end
      end
    end
  end

  describe 'validate input file' do
    context 'with valid input' do
      it 'returns true' do
        expect(AdjustedCarbonTotal.valid_input?(valid_input_hash_array)).to eq(true)
      end

      it 'returns no error messages' do
        expect { AdjustedCarbonTotal.valid_input?(valid_input_hash_array) }.to_not output.to_stderr
      end
    end

    context 'with invalid input' do
      context 'that is missing a key entry' do
        it 'returns true' do
          expect(AdjustedCarbonTotal.valid_input?(invalid_input_hash_array)).to eq(false)
        end

        it 'returns an error message' do
          expect { AdjustedCarbonTotal.valid_input?(invalid_input_hash_array) }.to output("Input data element 1 is missing the following required keys: [\"Total Energy Use\"]\n").to_stderr
        end
      end
    end
  end
end
