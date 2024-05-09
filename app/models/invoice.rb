# app/models/invoice.rb

class Invoice < ApplicationRecord
  STATUSES = %w[NEW CONFIRMED CANCELLED].freeze
  PAYMENT_STATUSES = %w[PAID UNPAID UNDERPAID].freeze
  XERO_STATUSES = { 'NEW' => 'DRAFT', 'CONFIRMED' => 'AUTHORISED', 'CANCELLED' => 'VOID' }.freeze

  belongs_to :client
  has_many :transactions, dependent: :destroy

  validates :status, presence: true, inclusion: STATUSES
  validates :payment_status, presence: true, inclusion: PAYMENT_STATUSES

  scope :by_client_id, ->(client_id) { where(client_id: client_id) }
  scope :due_in_five_days, -> { where(due_date: Date.today + 5.days, synced_to_xero: false) }

  after_save :update_xero, if: :saved_change_to_amount?

  def cancel
    update(status: 'CANCELLED')
    xero_service.void_invoice
  end

  def confirm
    update(status: 'CONFIRMED')
    xero_service.update_invoice
  end

  def update_amount
    update(amount: compute_amount)
    xero_service.update_invoice
  end

  def compute_amount
    transactions.empty? ? 0 : transactions.sum(&:amount)
  end

  private

  def update_xero
    xero_service.update_invoice
  end

  def xero_service
    @xero_service ||= XeroService.new(self)
  end
end