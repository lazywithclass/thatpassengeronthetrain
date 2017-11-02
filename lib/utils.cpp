std::string toPercentage(double occurrencies, int total)
{
  return std::to_string((int) round(100 * occurrencies / total)) + "%";
}

std::string getProtocolTypeAsString(pcpp::ProtocolType protocolType)
{
  switch (protocolType)
    {
    case pcpp::Ethernet:
      return "Ethernet";
    case pcpp::IPv4:
      return "IPv4";
    case pcpp::TCP:
      return "TCP";
    case pcpp::HTTPRequest:
    case pcpp::HTTPResponse:
      return "HTTP";
    default:
      return "Unknown";
    }
}
