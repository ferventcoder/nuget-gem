require 'net/http'
require 'net/https'
require 'json'

module NuGet
    @@serverName = "dist.nuget.org"
    @@nuget_exe = File.join( File.dirname(__FILE__) , "..", "bin", "/nuget.exe")
    @@version = File.read(File.join(File.dirname(__FILE__) , "..", "VERSION")).strip

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

    def self.download_version(version)
        found_version = self.command_line()["versions"].find do |v|
            v["version"] == version
        end
        self.download(found_version["url"], @@nuget_exe)
    end

    def self.list_versions()
        self.command_line()["versions"].map do |v|
            v["version"]
        end
    end

    def self.clear_exe()
        if File.exists?(@@nuget_exe) then
            File.delete(@@nuget_exe)
        end
    end

    def self.exec(argv)
        if not File.exists?(@@nuget_exe) then
            puts "Could not find local nuget.exe, downloading"
            self.download_version(@@version)
        end
        windows = Gem.win_platform? 
        to_exec = [@@nuget_exe, argv.join(' ')]
        to_exec.insert(0, "mono --runtime=v4.0") if ! windows
        return system(to_exec.join(' '))
    end
end

