#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

struct Headers {
    ethernet_t eth_hdr;
}

struct Meta {
}

parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        pkt.extract<ethernet_t>(hdr.eth_hdr);
        transition accept;
    }
}

control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @noWarn("unused") @name(".NoAction") action NoAction_0() {
    }
    @noWarn("unused") @name(".NoAction") action NoAction_3() {
    }
    @name("ingress.set_valid_action") action set_valid_action(@name("tmp") out Headers tmp) {
        tmp.eth_hdr.setValid();
        tmp.eth_hdr.dst_addr = 48w1;
        tmp.eth_hdr.src_addr = 48w1;
    }
    @name("ingress.simple_table_1") table simple_table {
        key = {
            128w1: exact @name("JGOUaj") ;
        }
        actions = {
            set_valid_action(h);
            @defaultonly NoAction_0();
        }
        default_action = NoAction_0();
    }
    @name("ingress.simple_table_2") table simple_table_0 {
        key = {
            48w1: exact @name("qkgOtm") ;
        }
        actions = {
            NoAction_3();
        }
        default_action = NoAction_3();
    }
    apply {
        switch (simple_table_0.apply().action_run) {
            NoAction_3: {
                simple_table.apply();
            }
        }
    }
}

control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}

control update(inout Headers h, inout Meta m) {
    apply {
    }
}

control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control deparser(packet_out pkt, in Headers h) {
    apply {
        pkt.emit<Headers>(h);
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

