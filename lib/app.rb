require 'date'
require_relative './models/inventory'

# Controller reads the inventory database scans for identical pairs, checks for
# date overlaps and then updates the dates to remove overlaps.
class Controller
  attr_reader :inventory, :identical_pairs, :overlaps

  def initialize(inventory: Inventory.all)
    @inventory = inventory
    @identical_pairs = []
    @overlaps = []
    @pair_one_date_range = nil
    @pair_two_valid_from = nil
  end

  def identify_pairs_of_rows
    inventory.each_with_index do |row1, index1|
      inventory.each_with_index do |row2, index2|
        next if index1 >= index2
        add_to_identical_pairs(row1, row2)
      end
    end
  end

  def identify_date_overlaps
    identical_pairs.each do |pair_one, pair_two|
      if date_format_invalid?(pair_one, pair_two)
        set_default_date(pair_one, pair_two)
        add_to_overlaps(pair_one, pair_two)
      else
        parse_dates(pair_one, pair_two)
        add_to_overlaps(pair_one, pair_two) if date_overlaps?
      end
    end
  end

  def update_dates
    overlaps.each do |pair_one, pair_two|
      parse_dates(pair_one, pair_two)
      check_and_update(pair_one)
    end
  end

  private

  def check_and_update(pair_one)
    row = Inventory.get(pair_one[:id])
    if pair_one[:valid_to] == row[:valid_to] || row[:valid_to] == 99999999
      row.update(valid_to: (@pair_two_valid_from - 1).strftime('%Y%m%d'))
    end
  end

  def date_overlaps?
    @pair_one_date_range.include?(@pair_two_valid_from)
  end

  def add_to_identical_pairs(row1, row2)
    if identical_product_customer_measure?(row1, row2)
      @identical_pairs << [row1, row2]
    end
  end

  def identical_product_customer_measure?(row1, row2)
    (row1[:product] == row2[:product]) &&
      (row1[:customer] == row2[:customer]) &&
      (row1[:measure] == row2[:measure])
  end

  def parse_dates(pair_one, pair_two)
    pair_one_valid_from = Date.parse(pair_one[:valid_from].to_s)
    pair_one_valid_to = Date.parse(pair_one[:valid_to].to_s)
    @pair_one_date_range = (pair_one_valid_from..pair_one_valid_to).to_a
    @pair_two_valid_from = Date.parse(pair_two[:valid_from].to_s)
  end

  def date_format_invalid?(pair_one, pair_two)
    (pair_one[:valid_from].zero? || pair_one[:valid_to] == 99999999) ||
      (pair_two[:valid_from].zero? || pair_two[:valid_to] == 99999999)
  end

  def set_default_date(pair_one, _pair_two)
    pair_one[:valid_from] = 10000101 if pair_one[:valid_from].zero?
    pair_one[:valid_to] = 99991231 if pair_one[:valid_to] == 99999999
  end

  def add_to_overlaps(pair_one, pair_two)
    overlaps << [pair_one, pair_two]
  end
end
