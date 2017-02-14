class RepoImage < ApplicationRecord
  belongs_to :user

  def self.find_or_create(user_name, filename)
    user = User.find_by_user_name(user_name)
    pdf = self.where(user_id: user.id, file: filename).first
    return pdf if pdf
    self.create_pdf(user.id, filename)
  end

  def self.create_pdf(user_id, filename, url='http://rubykin.com')
    wicked_pdf = WickedPdf.new.pdf_from_url(url)
    file_path = Rails.root.join('tmp', filename)
    File.open(file_path, 'wb') { |f| f.write(wicked_pdf) }

    obj = S3_BUCKET.object(filename)
    if obj.upload_file(file_path)
      self.create(user_id: user_id, url: obj.public_url)
    end
  end
end
