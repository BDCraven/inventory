require 'app'

describe Controller do
  subject(:controller) { described_class.new }

  describe '#initialize' do
    it 'has an empty inventory' do
      empty_inventory = Inventory.all
      expect(controller.inventory).to eq(empty_inventory)
    end
  end

  let!(:inventory) do
    Inventory.create(id: 1, product: 'Widget', customer: 'Tesco',
                     measure: 'Gross Sales Price', value: 1,
                     valid_from: 20130101, valid_to: 20130401)
    Inventory.create(id: 2, product: 'Widget', customer: 'Tesco',
                     measure: 'Gross Sales Price', value: 1.5,
                     valid_from: 20130301, valid_to: 20131231)
    Inventory.create(id: 3, product: 'Widget', customer: 'Tesco',
                     measure: 'Gross Sales Price', value: 2,
                     valid_from: 20130401, valid_to: 20150101)
    Inventory.create(id: 4, product: 'Widget', customer: 'Tesco',
                     measure: 'Distribution Cost', value: 5,
                     valid_from: 20130101, valid_to: 20130401)
    Inventory.create(id: 5, product: 'Widget', customer: 'Tesco',
                     measure: 'Distribution Cost', value: 6,
                     valid_from: 20130301, valid_to: 20140401)
    Inventory.create(id: 6, product: 'Widget', customer: 'Tesco',
                     measure: 'Distribution Cost', value: 7,
                     valid_from: 20131231, valid_to: 20150101)
    Inventory.create(id: 7, product: 'Widget', customer: 'Asda',
                     measure: 'Gross Sales Price', value: 100,
                     valid_from: 00000000, valid_to: 99999999)
    Inventory.create(id: 8, product: 'Widget', customer: 'Asda',
                     measure: 'Gross Sales Price', value: 200,
                     valid_from: 20131231, valid_to: 20150101)
    Inventory.create(id: 9, product: 'Widget', customer: 'Asda',
                     measure: 'Distribution Cost', value: 2,
                     valid_from: 20130301, valid_to: 20131231)
    Inventory.create(id: 10, product: 'Widget', customer: 'Asda',
                     measure: 'Distribution Cost', value: 3,
                     valid_from: 20140401, valid_to: 20150101)
  end

  let!(:row1) { Inventory.get(1) }
  let!(:row2) { Inventory.get(2) }
  let!(:row3) { Inventory.get(3) }
  let!(:row4) { Inventory.get(4) }
  let!(:row5) { Inventory.get(5) }
  let!(:row6) { Inventory.get(6) }
  let!(:row7) { Inventory.get(7) }
  let!(:row8) { Inventory.get(8) }
  let!(:row9) { Inventory.get(9) }
  let!(:row10) { Inventory.get(10) }

  describe '#identify_pairs_of_rows' do
    it 'identifies pairs with the same products, customers and measures' do
      controller.identify_pairs_of_rows
      expect(controller.identical_pairs).to eq([[row1, row2], [row1, row3],
                                                [row2, row3], [row4, row5],
                                                [row4, row6], [row5, row6],
                                                [row7, row8], [row9, row10]])
    end
  end

  describe '#identify_date_overlaps' do
    it 'assumes overlap if date is 00000000/99999999 and sets a default date' do
      row7.update(valid_from: 10000101, valid_to: 99991231)
      controller.identify_pairs_of_rows
      controller.identify_date_overlaps
      expect(controller.overlaps).to include([row7, row8])
    end

    it 'identifies pairs with overlapping dates' do
      row7.update(valid_from: 10000101, valid_to: 99991231)
      controller.identify_pairs_of_rows
      controller.identify_date_overlaps
      expect(controller.overlaps).to eq([[row1, row2], [row1, row3],
                                         [row2, row3], [row4, row5],
                                         [row5, row6], [row7, row8]])
    end
  end

  describe '#update_dates' do
    it 'updates the date to remove overlap' do
      controller.identify_pairs_of_rows
      controller.identify_date_overlaps
      controller.update_dates
      row1_updated = Inventory.get(1)
      row2_updated = Inventory.get(2)
      row4_updated = Inventory.get(4)
      row5_updated = Inventory.get(5)
      row7_updated = Inventory.get(7)
      expect(row1_updated[:valid_from]).to eq(20130101)
      expect(row1_updated[:valid_to]).to eq(20130228)
      expect(row2_updated[:valid_from]).to eq(20130301)
      expect(row2_updated[:valid_to]).to eq(20130331)
      expect(row4_updated[:valid_to]).to eq(20130228)
      expect(row5_updated[:valid_to]).to eq(20131230)
      expect(row7_updated[:valid_to]).to eq(20131230)
    end
  end
end
