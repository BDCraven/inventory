# Inventory

Given a table of data, create a process which solves parts A and B below. Document your work using either a flowchart, pseudo-code, a written sequence of steps, or a programming language you are familiar with.

A Identify which pairs of rows have identical Products, Customers and Measures, and overlapping date ranges;

B. Of the rows identified in part A, update the rows to make the date ranges not overlap.

### Tech

Written in Ruby with Datamapper and tested with RSpec.


### How to use

1. `git clone https://github.com/BDCraven/inventory.git`
2. Run the command `gem install bundle` (if you don't have bundle already)
3. When the installation completes, run `bundle`
4. Run the tests by typing rspec in the command line.
5. If you want to run the feature test you may need to install Psql. In terminal run `brew install postgresql`
6. Follow the installation instructions
7. Run these commands after installing:

  `ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents`
  `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist`

### Approach to the challenge

I chose Ruby, Datamapper and Psql for this challenge as I wanted to be able to see the results of my logic.

I started the challenge by spiking the code to get a feel for the approach. I added the data to a table using Datamapper. The first issue I encountered was that the Date field did not recognise 00000000 and 99999999 so I changed it to an integer.

I created a method which looped through the inventory, identified pairs with overlapping dates and then amended them so that they did not overlap.

I then rewrote my code using TDD. On this approach I decided to separate the responsibility for finding the pairs, identifying overlapping dates and then updating the dates into separate methods. This resulted in the code being a little longer than my first attempt but it gives the user more control over the data and felt like a cleaner approach.

I did not do regular small commits to Github as I was not initially sure whether I would be submitting my solution online.

### Assumptions and decisions

* 00000000 and 99999999 are not recognised as date fields so I used an integer field. I assumed that these dates meant that there was no particular start or end date intended so that they would automatically overlap with any other date.

* I decided to amend 00000000 and 99999999 in order to simplify the date comparison. The identify_date_overlaps method changes 000000000 to 10000101 and 99999999 to 99991231.These are valid date formats but still convey the lack of start or end which I assume was originally intended. I did not alter the original data.

* As explained above I decided to separate the responsibilities of the methods rather than have one method which did everything in one loop.

* Updating the dates - I identified a couple of issues:
  * (1) there appeared to be a possible pattern that there were only three intended date periods: 20130101 to 20130301, 20130401 to 20131231 and 20140401 to 20150101. However, I could not be sure that this was a genuine pattern and concluded that implementing it would substantially interfere with the integrity of the data;
  * (2) whether the dates for a product's Gross Sales Price and Distribution Cost should be identical. However, it seemed that there were commercial reasons why the dates for a product's sales price and distribution costs did not have to be the same.

* I decided that the solution which made most commercial sense and limited the interference with the integrity of the original data was to change the overlaps to a continuous period. The method therefore, reduces the Valid To Day of the first item in the pair to one day prior to the Valid From Day of the second item in the pair. I assumed that the Valid From Date was most likely the correct date and that it was supposed to supersede the Valid To Day in the event of conflict.

### To run the feature test

1. In the project root directory enter the following command in the terminal:
  `ruby ./spec/feature_test.rb`

2. Open `psql`
3. Connect to the inventory database with `\c inventory`    

4. view the table with `select * from inventories order by id;` and you should see the following table of updated data:

| id | product | customer |      measure      | value | valid_from | valid_to |
| -- | ------- | -------- | ----------------- | ----- | ---------- | -------- |
|  1 | Widget  | Tesco    | Gross Sales Price |     1 |   20130101 | 20130228 |
|  2 | Widget  | Tesco    | Gross Sales Price |   1.5 |   20130301 | 20130331 |
|  3 | Widget  | Tesco    | Gross Sales Price |     2 |   20130401 | 20150101 |
|  4 | Widget  | Tesco    | Distribution Cost |     5 |   20130101 | 20130228 |
|  5 | Widget  | Tesco    | Distribution Cost |     6 |   20130301 | 20131230 |
|  6 | Widget  | Tesco    | Distribution Cost |     7 |   20131231 | 20150101 |
|  7 | Widget  | Asda     | Gross Sales Price |   100 |          0 | 20131230 |
|  8 | Widget  | Asda     | Gross Sales Price |   200 |   20131231 | 20150101 |
|  9 | Widget  | Asda     | Distribution Cost |     2 |   20130301 | 20131231 |
| 10 | Widget  | Asda     | Distribution Cost |     3 |   20140401 | 20150101 |
