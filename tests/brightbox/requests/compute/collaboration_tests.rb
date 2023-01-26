Shindo.tests("Fog::Compute[:brightbox] | collaboration requests", ["brightbox"]) do
  tests("success") do
    @test_collaborator_email = ENV["FOG_TEST_COLLABORATOR_EMAIL"]
    pending unless @test_collaborator_email

    tests("#create_collaboration") do
      pending if Fog.mocking?
      collaboration = Fog::Compute[:brightbox].create_collaboration(email: @test_collaborator_email, role: "admin")
      @collaboration_id = collaboration["id"]
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { collaboration }
    end

    tests("#list_collaborations") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_collaborations

      formats(Brightbox::Compute::Formats::Collection::COLLABORATIONS, false) { result }
    end

    tests("#get_collaboration") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_collaboration(@collaboration_id)
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { result }
    end

    tests("#delete_collaboration") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].delete_collaboration(@collaboration_id)
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { result }
    end
  end

  tests("failure") do
    tests("get_collaboration('col-abcde')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_collaboration("col-abcde")
    end
  end
end
