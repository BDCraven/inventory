require_relative '../lib/app.rb'

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

controller = Controller.new
controller.identify_pairs_of_rows
controller.identify_date_overlaps
controller.update_dates
