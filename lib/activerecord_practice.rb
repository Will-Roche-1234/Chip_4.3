require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    return Customer.where("first = 'Candice'")
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    return Customer.where("email LIKE ?", "%@%")
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    return Customer.where("email LIKE ?", "%@%.org")
  end

  def self.with_invalid_email
    return Customer.where("email NOT LIKE ? AND email != '' AND email is NOT NULL", "%@%")
  end

  def self.with_blank_email
    return Customer.where("email is NULL OR email =''")
  end

  def self.born_before_1980
    return Customer.where("birthdate < ?", "1980-01-01")
  end

  def self.with_valid_email_and_born_before_1980
    return Customer.where("birthdate < ? AND email LIKE ?", "1980-01-01", "%@%")
  end

  def self.last_names_starting_with_b
    return Customer.where("last LIKE ?", "B%").order("birthdate")
  end

  def self.twenty_youngest
    return Customer.order("birthdate DESC").limit(20)
  end

  def self.update_gussie_murray_birthdate
    return Customer.where("first = 'Gussie' AND last ='Murray'").update_all("birthdate = '2004-02-08'")
  end

  def self.change_all_invalid_emails_to_blank
    return Customer.where("email NOT LIKE '%@%' AND email != '' AND email IS NOT NULL").update_all("email=''")
  end

  def self.delete_meggie_herman
    return Customer.where("first = 'Meggie' AND last = 'Herman'").destroy_all
  end

  def self.delete_everyone_born_before_1978
    return Customer.where("birthdate < ?", '1978-01-01').destroy_all
  end
end
