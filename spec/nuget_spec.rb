require_relative "../lib/nuget"
describe "NuGet" do
    before(:each) do
        NuGet.clear_exe
    end
    it "can list versions" do
        versions = NuGet.list_versions
        expect(versions).to include '2.8.6'
    end
    it "can download and execute current version" do
        result = NuGet.exec([])
        expect(result).to eq true
    end
end