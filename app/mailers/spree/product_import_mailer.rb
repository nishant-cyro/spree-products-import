class Spree::ProductImportMailer < Spree::BaseMailer
  def import_data_success_email(import_product_id, file_field, total_rows)
    load_data_and_set_original_file_as_attachment(import_product_id, file_field)
    @total_rows = total_rows
    subject = "Product bulk upload status #{ Time.current.strftime('%b %d %Y %H:%M:%S') }"
    mail(to: @import_product.user.email, from: from_address, subject: subject)
  end

  def import_data_failure_email(import_product_id, file_field, failed_csv, total_rows, failed_rows)
    load_data_and_set_original_file_as_attachment(import_product_id, file_field)
    @total_rows = total_rows; @failed_rows = failed_rows
    attachments['failed.csv'] = failed_csv
    subject = "Product bulk upload status #{ Time.current.strftime('%b %d %Y %H:%M:%S') } "
    mail(to: @import_product.user.email, from: from_address, subject: subject)
  end

  private
    def load_data_and_set_original_file_as_attachment(import_product_id, file_field)
      @import_product = Spree::ProductImport.find(import_product_id)
      original_file_name = @import_product.send("#{ file_field }_file_name")
      original_file_path = @import_product.send("#{ file_field }_path")
      attachments[original_file_name] = File.read(original_file_path)
    end
end
