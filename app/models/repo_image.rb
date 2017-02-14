class RepoImage < ApplicationRecord
  belongs_to :user

  def self.find_or_create(user_name, url)
    user = User.find_by_user_name(user_name)
    pdf = self.where(user_id: user.id, url: url).first
    return pdf if pdf
    wicked_pdf = WickedPdf.new.pdf_from_url(url)
    wicked_pdf.gsub!("\u0000", '')
    self.create(user_id: user.id, url: url, file: wicked_pdf.force_encoding('iso8859-1'))
  end
end
