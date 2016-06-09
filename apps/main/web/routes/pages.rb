module Main
  class Application < Dry::Web::Application
    route "about" do |r|
      r.view "pages.about"
    end

    route "contact" do |r|
      r.view "pages.contact"
    end

    route "work" do |r|
      r.on ":slug" do |slug|
        r.resolve("main.operations.projects.check_publication_state") do |check_publication_state|
          check_publication_state.(slug) do |m|
            m.failure do
              response.status = 404
              r.view "errors.error_404"
            end

            m.success do
              r.view "projects.show", slug: slug
            end
          end
        end
      end
      r.view "pages.work"
    end

    route "feed" do |r|
      response['Content-Type'] = 'application/xml'
      r.view "pages.feed", format: :xml, engine: :builder
    end
  end
end
