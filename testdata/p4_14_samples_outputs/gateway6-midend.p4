#include <core.p4>
#include <v1model.p4>

header data_t {
    bit<32> f1;
    bit<32> f2;
    bit<8>  b1;
    bit<8>  b2;
    bit<8>  b3;
    bit<8>  b4;
}

struct metadata {
}

struct headers {
    @name("data") 
    data_t data;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract<data_t>(hdr.data);
        transition accept;
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_1") action NoAction() {
    }
    @name("NoAction_2") action NoAction_0() {
    }
    @name("output") action output_0(bit<9> port) {
        standard_metadata.egress_spec = port;
    }
    @name("output") action output_2(bit<9> port) {
        standard_metadata.egress_spec = port;
    }
    @name("noop") action noop_0() {
    }
    @name("noop") action noop_2() {
    }
    @name("test1") table test1() {
        actions = {
            output_0();
            noop_0();
            NoAction();
        }
        key = {
            hdr.data.f1: exact;
        }
        default_action = NoAction();
    }
    @name("test2") table test2() {
        actions = {
            output_2();
            noop_2();
            NoAction_0();
        }
        key = {
            hdr.data.f2: exact;
        }
        default_action = NoAction_0();
    }
    apply {
        if (8w1 == (8w15 & hdr.data.b2)) 
            test1.apply();
        else 
            test2.apply();
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<data_t>(hdr.data);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;