describe Inventory do
  subject(:inventory) { described_class.new }

  it 'exists' do
    expect(inventory).to be_a(Inventory)
  end

  it 'should add a new record' do
    inventory.product = 'Widget'
    save_result = inventory.save
    expect(save_result).to be true
    expect(Inventory.count).to equal(1)
  end

  it 'should store the product attribute' do
    inventory.product = 'Widget'
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.product).to eq('Widget')
  end

  it 'should store the customer attribute' do
    inventory.customer = 'Tesco'
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.customer).to eq('Tesco')
  end

  it 'should store the measure attribute' do
    inventory.measure = 'Gross Sales Price'
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.measure).to eq('Gross Sales Price')
  end

  it 'should store the value attribute' do
    inventory.value = 1
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.value).to eq(1)
  end

  it 'should store the valid_from attribute' do
    inventory.valid_from = 20130101
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.valid_from).to eq(20130101)
  end

  it 'should store the valid_to attribute' do
    inventory.valid_to = 20130401
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.valid_to).to eq(20130401)
  end

  it 'can store 00000000 and 99999999 in the date fields' do
    inventory.valid_from = 00000000
    inventory.valid_to = 99999999
    inventory.save
    test_inventory = Inventory.get(inventory.id)
    expect(test_inventory.valid_from).to eq(00000000)
    expect(test_inventory.valid_to).to eq(99999999)
  end
end
