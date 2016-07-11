require 'net/http'
require 'net/https'
require 'json'

module NuGet
    @@serverName = "dist.nuget.org"
    
    def self.request_without_verify uri
        http = Net::HTTP.new(@@serverName,443)
        http.use_ssl = true
        # Might need to do this on windows:
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri)

        http.request request do |response|
            yield response
        end
    end


    def self.download(srcPath, destPath)
        self.request_without_verify srcPath do |response|
            open(destPath, "wb") do |f|
                response.read_body do |segment|
                    f.write(segment)
                end
            end
        end
    end


    def self.get_index()
        self.request_without_verify "/index.json" do |response|
            return JSON.parse response.body
        end
    end

    def self.command_line()
        self.get_index()["artifacts"].find do |artifact|
            artifact["name"].match(/commandline/)
        end
    end

    def self.download_version(version, path)
        found_version = self.command_line()["versions"].find do |v|
            v["version"] == version
        end

        self.download(found_version["url"], File.join(path, "nuget.exe"))
    end

    def self.list_versions()
        self.command_line()["versions"].map do |v|
            v["version"]
        end
    end
end

