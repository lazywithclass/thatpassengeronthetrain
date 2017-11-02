#include <Packet.h>
#include <PcapFileDevice.h>
#include <math.h>

#include "lib/utils.cpp"
#include "lib/analyzers/sequence-id.cpp"

// what this code is trying to do is called
// protocol tagging
// look it up on the internet

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
