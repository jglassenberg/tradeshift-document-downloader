class Jobs::ProcessDownloadForUser
    class << self
        def run(user, filters)
            documents = user.company.documents

            data = documents.map do |doc|
               Rabl::Renderer.new('documents/show', doc, :view_path => 'app/views', :format => 'hash').render
            end

            DownloadMailer.files_done(user, data)
        end

        handle_asynchronously :run
    end
end
