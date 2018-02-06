## thatpassengeronthetrain

`thatpassengeronthetrain`, or `tpott` (pronounced teapot), it's a tool that finds patterns in .pcap files.

### Usage

```bash
tshark -r $pcap-path -V -T fields -e data.data | sed 's/\([0-9a-fA-F][0-9a-fA-F]\)/#x\1/g' | racket tpott.rkt
```

### Tests

```bash
racket -l errortrace -t test/sequence-id-test.rkt
```
