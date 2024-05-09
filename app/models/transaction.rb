# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  unit_amount :float
#  quantity    :integer
#  date        :date
#  description :string
#  invoice_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :invoice

  scope :by_invoice_id, ->(invoice_id) { where(invoice_id: invoice_id) }

  after_save :update_invoice_amount

  def amount
    unit_amount * quantity
  end

  private

  def update_invoice_amount
    invoice.update_amount
  end
end