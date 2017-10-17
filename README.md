## thatpassengeronthetrain

`thatpassengeronthetrain`, or `tpott` (pronounced teapot), it's a tool that finds patterns in libpcap files.

### Usage

```bash
$ make all && ./tpott
```

### Features

#### Incremental id

It could recognise incremental ids network protocols, for example in 

```
cc 01 29 00 00 e0 ...
cc 01 00 0f 40 e1 ...
```

you notice how the id is incrementing between exchanges at the sixth byte.

#### Packet identifier

#### Function code

### Acknowledgements

[This](https://github.com/seladb/PcapPlusPlus/blob/master/Examples/Tutorials/Tutorial-HelloWorld) helped
a lot while looking around for examples on how to do stuff, actually this project started with exactly
those files.
