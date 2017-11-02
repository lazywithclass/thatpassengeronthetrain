#include <map>

void sequenceIdChances(std::vector< std::vector<uint32_t> > packets)
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
