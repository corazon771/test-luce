class SyncInvoicesToXeroJob < ApplicationJob
  BATCH_SIZE = 1500

  def perform
    Invoice.due_in_five_days.find_in_batches(batch_size: BATCH_SIZE) do |group|
      group.each do |invoice|
        XeroService.new(invoice).create_invoice
      end
    end
  end
end