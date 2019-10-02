Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD6C494B
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfJBITB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Oct 2019 04:19:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfJBITA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 04:19:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1A1818C427B
        for <stable@vger.kernel.org>; Wed,  2 Oct 2019 08:18:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D966E5D6A3
        for <stable@vger.kernel.org>; Wed,  2 Oct 2019 08:18:59 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDFB34E589;
        Wed,  2 Oct 2019 08:18:59 +0000 (UTC)
Date:   Wed, 2 Oct 2019 04:18:59 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <872170480.3076676.1570004339611.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.ECF89BD220.LKQR1ETI6V@redhat.com>
References: <cki.ECF89BD220.LKQR1ETI6V@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9C=85_PASS:_Test_report_for_ke?=
 =?utf-8?Q?rnel_5.3.3-9c30694.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.43.17.163, 10.4.195.18]
Thread-Topic: =?utf-8?B?4pyFIFBBU1M6?= Test report for kernel 5.3.3-9c30694.cki (stable)
Thread-Index: z0LDkoiVSgcA3xF6R6cYs05Zlxz9KA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 02 Oct 2019 08:18:59 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 9c30694424ee - Linux 5.3.2
> 
> The results of these automated tests are provided below.
> 
>     Overall result: PASSED
>              Merge: OK
>            Compile: OK
>              Tests: OK
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/199450
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more
> effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 3 architectures:
> 
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
> 
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>       Host 1:
>          ✅ Boot test
>          ✅ Podman system integration test (as root)
>          ✅ Podman system integration test (as user)
>          ✅ Loopdev Sanity
>          ✅ jvm test suite
>          ✅ Memory function: memfd_create
>          ✅ AMTU (Abstract Machine Test Utility)
>          ✅ Ethernet drivers sanity
>          ✅ Networking socket: fuzz
>          ✅ Networking sctp-auth: sockopts test
>          ✅ Networking: igmp conformance test
>          ✅ Networking TCP: keepalive test
>          ✅ Networking UDP: socket
>          ✅ Networking tunnel: gre basic
>          ✅ Networking tunnel: vxlan basic
>          ✅ audit: audit testsuite test
>          ✅ httpd: mod_ssl smoke sanity
>          ✅ iotop: sanity
>          ✅ tuned: tune-processes-through-perf
>          ✅ Usex - version 1.9-29
>          ✅ storage: SCSI VPD
>          ✅ stress: stress-ng
>          🚧 ✅ LTP lite
>          🚧 ✅ CIFS Connectathon
>          🚧 ✅ POSIX pjd-fstest suites
>          🚧 ✅ Memory function: kaslr
>          🚧 ✅ Networking bridge: sanity
>          🚧 ✅ Networking MACsec: sanity
>          🚧 ✅ Networking route: pmtu
>          🚧 ✅ Networking tunnel: geneve basic test
>          🚧 ✅ L2TP basic test
>          🚧 ✅ Networking vnic: ipvlan/basic
>          🚧 ✅ ALSA PCM loopback test
>          🚧 ✅ ALSA Control (mixer) Userspace Element test
>          🚧 ✅ trace: ftrace/tracer
>          🚧 ✅ Networking route_func: local
>          🚧 ✅ Networking route_func: forward
>          🚧 ✅ Networking ipsec: basic netns transport
>          🚧 ✅ Networking ipsec: basic netns tunnel
> 
>       Host 2:
>          ✅ Boot test
>          ✅ xfstests: ext4
>          ✅ xfstests: xfs
>          ✅ selinux-policy: serge-testsuite
>          ✅ lvm thinp sanity
>          ✅ storage: software RAID testing
>          🚧 ✅ Storage blktests
> 
>   ppc64le:
>       Host 1:
>          ✅ Boot test
>          ✅ Podman system integration test (as root)
>          ✅ Podman system integration test (as user)
>          ✅ Loopdev Sanity
>          ✅ jvm test suite
>          ✅ Memory function: memfd_create
>          ✅ AMTU (Abstract Machine Test Utility)
>          ✅ Ethernet drivers sanity
>          ✅ Networking socket: fuzz
>          ✅ Networking sctp-auth: sockopts test
>          ✅ Networking TCP: keepalive test
>          ✅ Networking UDP: socket
>          ✅ Networking tunnel: gre basic
>          ✅ Networking tunnel: vxlan basic
>          ✅ audit: audit testsuite test
>          ✅ httpd: mod_ssl smoke sanity
>          ✅ iotop: sanity
>          ✅ tuned: tune-processes-through-perf
>          ✅ Usex - version 1.9-29
>          🚧 ❌ LTP lite

ppc64le hit panic that appears to be fixed by:
  41ba17f20ea8 ("powerpc/imc: Dont create debugfs files for cpu-less nodes")

Architecture:        ppc64le
Byte Order:          Little Endian
CPU(s):              144
On-line CPU(s) list: 0-143
Thread(s) per core:  4
Core(s) per socket:  18
Socket(s):           2
NUMA node(s):        6
Model:               2.2 (pvr 004e 1202)
Model name:          POWER9, altivec supported
CPU max MHz:         3800.0000
CPU min MHz:         2300.0000
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            10240K
NUMA node0 CPU(s):   0-71
NUMA node8 CPU(s):   72-143
NUMA node252 CPU(s): 
NUMA node253 CPU(s): 
NUMA node254 CPU(s): 
NUMA node255 CPU(s):

[12715.258043] BUG: Unable to handle kernel data access at 0x0003fc08 
[12715.258060] Faulting instruction address: 0xc0000000000cb500 
[12715.258061] BUG: Unable to handle kernel data access at 0x0003fc08 
[12715.258063] Faulting instruction address: 0xc0000000000cb500 
[12715.258073] Oops: Kernel access of bad area, sig: 11 [#1] 
[12715.258099] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=1024 NUMA PowerNV 
[12715.258111] Modules linked in: kvm_hv kvm dummy veth minix binfmt_misc nfsv3 nfs_acl nfs lockd grace fscache brd vfat fat btrfs xor zstd_compress raid6_pq zstd_decompress ip6table_mangle ip6table_filter iptable_mangle xt_mark xt_AUDIT vxlan l2tp_ip6 pptp gre can_bcm l2tp_ip l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel scsi_transport_iscsi psnap ieee802154_socket ieee802154 mpls_router ip_tunnel rose bluetooth ecdh_generic ecc af_key pppoe pppox ppp_generic slhc fcrypt pcbc rxrpc kcm nfc rfkill atm smc ib_core rds netrom ax25 can sctp mlx4_en mlx4_core loop tun ip6table_nat ip6_tables xt_conntrack iptable_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 llc overlay fuse sunrpc vmx_crypto at24 regmap_i2c ipmi_powernv ipmi_devintf bnx2x ipmi_msghandler tg3 mdio opal_prd i2c_opal rtc_opal crct10dif_vpmsum ofpart powernv_flash mtd ip_tables xfs libcrc32c ast i2c_algo_bit drm_vram_helper ttm drm_kms_helper crc32c_vpmsum syscopyarea 
[12715.258161]  sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirks i2c_core [last unloaded: can_raw] 
[12715.258391] CPU: 12 PID: 84130 Comm: read_all Not tainted 5.3.3-9c30694.cki #1 
[12715.258411] NIP:  c0000000000cb500 LR: c000000000477154 CTR: c0000000000cb4f0 
[12715.258431] REGS: c000001ce5c939e0 TRAP: 0300   Not tainted  (5.3.3-9c30694.cki) 
[12715.258459] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 22002822  XER: 00000000 
[12715.258482] CFAR: c000000000477150 DAR: 000000000003fc08 DSISR: 40000000 IRQMASK: 0  
[12715.258482] GPR00: c000000000477154 c000001ce5c93c70 c00000000171e000 0000000000000000  
[12715.258482] GPR04: c000001ce5c93cd8 00000000000003ff c000001ce5c93df8 0000000000000000  
[12715.258482] GPR08: c000001b1f168800 000000000003fc08 0000000000000000 c000000000cf13e8  
[12715.258482] GPR12: c0000000000cb4f0 c000001fffff1800 0000000000000000 0000000000000000  
[12715.258482] GPR16: 0000000000000000 00000000100406e0 0000000000000002 000000001001aaa0  
[12715.258482] GPR20: 000000001001aa60 000000001001aa90 000000001001aa48 000000001001aa70  
[12715.258482] GPR24: 000000001001ad90 000000001001aa58 00007fffc7740570 00000000000003ff  
[12715.258482] GPR28: c000001fe1e71750 c000001ce5c93df8 c000001fe1e71700 0000000000000000  
[12715.258644] NIP [c0000000000cb500] imc_mem_get+0x10/0x20 
[12715.258664] LR [c000000000477154] simple_attr_read+0xf4/0x130 
[12715.258691] Call Trace: 
[12715.258698] [c000001ce5c93c70] [c0000000004770bc] simple_attr_read+0x5c/0x130 (unreliable) 
[12715.258720] [c000001ce5c93d10] [c0000000005c85ec] debugfs_attr_read+0x6c/0xb0 
[12715.258750] [c000001ce5c93d60] [c000000000433008] __vfs_read+0x38/0x70 
[12715.258769] [c000001ce5c93d80] [c000000000433150] vfs_read+0x110/0x200 
[12715.258788] [c000001ce5c93dd0] [c000000000433628] ksys_read+0x78/0x130 
[12715.258809] [c000001ce5c93e20] [c00000000000bae4] system_call+0x5c/0x70 
[12715.258828] Instruction dump: 
[12715.258834] 7c0802a6 60000000 7c691b78 38600000 7c804d28 4e800020 60000000 60000000  
[12715.258857] 7c0802a6 60000000 7c691b78 38600000 <7d204c28> f9240000 4e800020 60000000  
[12715.258890] ---[ end trace 83d49744939304b0 ]--- 
