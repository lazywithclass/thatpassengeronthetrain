#include <IPv4Layer.h>
#include <TcpLayer.h>
#include <Packet.h>
#include <PcapFileDevice.h>
#include <iostream>
#include <sstream>

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

int main(int argc, char* argv[])
{
  pcpp::PcapFileReaderDevice reader("pcaps/ProConOS-cold.pcapng");
  if (!reader.open())
    {
      printf("Error opening the pcap file\n");
      return 1;
    }

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
          printf("\n");

          uint8_t* firstByteAfterHeader = curLayer->getLayerPayload();
          size_t size = curLayer->getLayerPayloadSize();

          for (int i = 0; i < size; i++)
            {
              std::cout << (uint32_t) firstByteAfterHeader[i] << " ";
            }
        }
    }
  reader.close();

  printf("No more packets\n");
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

/*

  function that finds out if there's a sequence id
  to do so it takes each column and sees if the next one
  is the previous plus 1

*/
