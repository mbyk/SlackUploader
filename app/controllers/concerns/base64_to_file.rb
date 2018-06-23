module Base64ToFile

  extend ActiveSupport::Concern

  private

    def base64_to_file(base64_data)
      return nil unless base64_data.is_a? String

      start_regex = /data:(?<content_type>image\/[a-z]{3,4});base64,/
      filename = SecureRandom.hex[0..10]

      regex_result = start_regex.match(base64_data)
      if base64_data && regex_result
        content_type = regex_result[:content_type]

        if !(content_type == "image/jpeg" ||  content_type == "image/png")
          return nil
        end

        start = regex_result.to_s
        tempfile = Tempfile.new(filename)
        tempfile.binmode
        tempfile.write(Base64.decode64(base64_data[start.length..-1]))
        tempfile.rewind

        uploaded_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: filename,
          original_filename: filename
        )

        uploaded_file.content_type = content_type
        uploaded_file
      else
        nil
      end

    end

end