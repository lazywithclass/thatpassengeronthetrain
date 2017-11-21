## thatpassengeronthetrain

`thatpassengeronthetrain`, or `tpott` (pronounced teapot), it's a tool that finds patterns in .pcap files.

### Usage

```bash
$ make -s all && ./dist/tpott
```

### Features

#### Incremental id

It recognises incremental ids network protocols, for example in

```
cc 01 29 00 00 e0 ...
cc 01 00 0f 40 e1 ...
```

you notice how the id is incrementing between exchanges at the sixth byte. `tpott`
would tell you how likely to expect an incremental id at that position.

### Request / response

TODO

It recognises a packet and its response. At first it might be a good idea to bind this
to a recognised feature that we know it's plausible to be true, for example an incremental
id with a good percentage in respect to the total number of packets.

### Acknowledgements

[This](https://github.com/seladb/PcapPlusPlus/blob/master/Examples/Tutorials/Tutorial-HelloWorld) helped
a lot while looking around for examples on how to do stuff, actually this project
started with exactly those files.
