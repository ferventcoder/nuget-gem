require_relative "../lib/nuget"
require "fileutils"
describe "NuGet" do
    $tmp = './.tmp'
    $nuget_exe = File.join( $tmp, 'nuget.exe') 
    before(:each) do
        FileUtils.mkdir_p $tmp
    end
    after(:each) do 
        FileUtils.rm_rf $nuget_exe
    end
    it "can list versions" do
        versions = NuGet.list_versions
        expect(versions).to include '2.8.6'
    end
    it "can download version" do
        NuGet.download_version('2.8.6', $tmp)
        expect(File.exists?($nuget_exe)).to be true
    end
end