Shindo.tests("Fog::Compute[:brightbox] | Account model", ["brightbox"]) do
  pending if Fog.mocking?

  @account = Fog::Compute[:brightbox].account
end
