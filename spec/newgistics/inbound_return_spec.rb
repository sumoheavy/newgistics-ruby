require 'spec_helper'

RSpec.describe Newgistics::InboundReturn do
  include IntegrationHelpers

  describe '#save' do
    before { use_valid_api_key }

    vcr_options = { cassette_name: 'inbound_return/save/success' }
    context "when the inbound return is placed successfully", vcr: vcr_options do
      it "returns true" do
        inbound_return = Newgistics::InboundReturn.new(return_attributes)

        expect(inbound_return.save).to be(true)
      end

      it 'sets the id and any errors or warnings' do
        inbound_return = Newgistics::InboundReturn.new(return_attributes)

        inbound_return.save

        expect(inbound_return.id).to eq('1754253')
      end
    end

    vcr_options = { cassette_name: 'inbound_return/save/failure' }
    context "when the inbound return fails to save", vcr: vcr_options do
      it 'updates the inbound_return object with the errors' do
        inbound_return = Newgistics::InboundReturn.new(
          return_attributes(shipment_id: 'INVALID')
        )

        success = inbound_return.save

        expect(success).to eq false
        expect(inbound_return.errors.size).to eq 1
        expect(inbound_return.errors.first).to eq(
          "Unable to create inbound return; invalid shipment ID."
        )
      end
    end
  end

  def return_attributes(overrides = {})
    {
      shipment_id: '91955506',
      rma: 'RA343167887',
      comments: 'Sample Comment',
      items: [
        {
          sku: '1007-201-G',
          qty: 1,
          reason: 'Too Big'
        }
      ]
    }.merge(overrides)
  end
end