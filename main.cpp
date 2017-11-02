#include <Packet.h>
#include <PcapFileDevice.h>
#include <map>
#include <math.h>

// what this code is trying to do is called
// protocol tagging
// look it up on the internet

std::string toPercentage(double occurrencies, int total)
{
  return std::to_string((int) round(100 * occurrencies / total)) + "%";
}

/*std::vector<uint32_t>*/ void sequenceIdChances(std::vector< std::vector<uint32_t> > packets)
{
  bool firstRun = true;
  std::map<int, int> occurrencies;
  std::vector<uint32_t> previousPacket;
  for (std::vector<uint32_t> currentPacket : packets) {
    if (currentPacket.empty()) continue;

    // oh god the horror
    if (firstRun)
      {
        for (uint32_t byte : currentPacket) {
          previousPacket.push_back(byte);
        }
        firstRun = false;
        continue;
      }

    std::vector<uint32_t> shorterPacket = previousPacket.size() > currentPacket.size() ? currentPacket : previousPacket;

    for(uint32_t i = 0; i < shorterPacket.size(); i++)
      {
        if (previousPacket[i] + 1 == currentPacket[i])
          {
            // TODO use proper type
            auto position = occurrencies.find(i);
            if(position != occurrencies.end())
              {
                occurrencies[i] = occurrencies[i] + 1;
              }
            else
              {
                occurrencies[i] = 1;
              }
          }
      }

    // again, the horror
    // TODO move this in a utility lib?
    previousPacket.clear();
    for (uint32_t byte : currentPacket)
      {
        previousPacket.push_back(byte);
      }
  }

  for(uint32_t i = 0; i < occurrencies.size(); i++)
    {
      if (occurrencies[i] != 0)
        {
          auto chance = (double) occurrencies[i] / packets.size();
          printf("I found a sequence id with %s chance at position %i\n", toPercentage(occurrencies[i], packets.size()).c_str(), i + 1);
        }
    }
};

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

std::vector< std::vector<uint32_t> > matrix;

int main(int argc, char* argv[])
{
  pcpp::PcapFileReaderDevice reader("pcaps/ProConOS-cold.pcapng");
  if (!reader.open())
    {
      printf("Error opening the pcap file\n");
      return 1;
    }

  uint32_t lineNumber = 0;
  pcpp::RawPacket rawPacket;
  while (reader.getNextPacket(rawPacket))
    {
      pcpp::Packet parsedPacket(&rawPacket);

      for (pcpp::Layer* curLayer = parsedPacket.getFirstLayer(); curLayer != NULL; curLayer = curLayer->getNextLayer())
        {
          std::string layer = getProtocolTypeAsString(curLayer->getProtocol()).c_str();
          if (layer != "TCP")
            {
              continue;
            }

          std::vector<uint32_t> packetBytes;
          // TODO create the vector here
          // TODO dont add empty packets
          uint8_t* firstByteAfterHeader = curLayer->getLayerPayload();
          for (uint32_t i = 0; i < curLayer->getLayerPayloadSize(); i++)
            {
              packetBytes.push_back((uint32_t) firstByteAfterHeader[i]);
            }
          matrix.push_back(packetBytes);
        }

      lineNumber++;
    }
  reader.close();
  printf("Finished scanning packets\n");


  sequenceIdChances(matrix);

  return 0;
}

/*
  Assuming we have a couple packets like these

  cc 01 00 50 00 10
  cc 01 00 00 00 10

  We could argue the following:

  * the header might be formed by cc 01 00
  * 50 might be something (?)
  * 10 might be a transaction id of sorts

  cc 01 29 00 00 e0 100004006019ffffffffbd3937e000000000a485
  cc 01 00 0f 40 e1 00009225
*/


// first define a function that knows how to get the next
// given the current value
uint32_t successor(uint32_t current)
{
  return current + 1;
}
