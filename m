Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4517C9B4
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 01:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCGA1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 19:27:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgCGA13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 19:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583540847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Txx2uhtwU0v05dmBJV0fau9ofsPy366hYbtv2qoWPMA=;
        b=HpmYRJ2StQGCWP/V+VmbXRNTT+4mYv/UiJ+q5UstBj9GYPu8pZAkmbIGTgkFxtC4SrYGad
        ARfPGBM9fmy5+qpRxDnLS/HGYZbVZN0u0WEx7w5Dxq8zSau7/Frc9m6VoOGXYKjwAepIDS
        aGh4Z5A4FSuhA+DL0l0Jqo/mA8vFXYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-D00_ALwvM4er7XoapJy7rA-1; Fri, 06 Mar 2020 19:27:12 -0500
X-MC-Unique: D00_ALwvM4er7XoapJy7rA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0237B800D4E;
        Sat,  7 Mar 2020 00:27:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-123-211.rdu2.redhat.com [10.10.123.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7918D8D55B;
        Sat,  7 Mar 2020 00:27:05 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e5=2e8-?=
 =?UTF-8?Q?c302816=2ecki_=28stable-queue=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Jeff Bastian <jbastian@redhat.com>
References: <cki.6EF11BFC52.3M6NGDAMJ1@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <f7067e16-8b24-e7b2-0102-6654a6a5e047@redhat.com>
Date:   Fri, 6 Mar 2020 19:27:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.6EF11BFC52.3M6NGDAMJ1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/6/20 4:43 PM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git
>              Commit: c302816fcfff - block, bfq: do not insert oom queue=
 into position tree
>=20
> The results of these automated tests are provided below.
>=20
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download =
here:
>=20
>    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3D=
datawarehouse/2020/03/06/474961
>=20
> One or more kernel tests failed:
>=20
>      s390x:
>       =E2=9D=8C LTP
>       =E2=9D=8C stress: stress-ng

Hello, both stress-ng and LTP triggered a panic on s390x, the LTP panic h=
as already been mentioned in
a previous report:
https://lists.linaro.org/pipermail/linux-stable-mirror/2020-March/174549.=
html

stress-ng: https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse=
/2020/03/06/474961/s390x_2_console.log
[  960.031326] mmap: stress-ng-remap (204507) uses deprecated remap_file_=
pages()
  syscall. See Documentation/vm/remap_file_pages.rst.
[ 1100.699451] NET: Registered protocol family 5
[ 1100.899587] NET: Unregistered protocol family 5
[ 1101.021223] NET: Registered protocol family 5
[ 1101.239562] NET: Unregistered protocol family 5
[ 1101.320743] NET: Registered protocol family 5
[ 1101.519533] NET: Unregistered protocol family 5
[ 1101.610575] NET: Registered protocol family 5
[ 1101.849514] NET: Unregistered protocol family 5
[ 1112.850668] sched: DL replenish lagged too much
[-- MARK -- Fri Mar  6 15:25:00 2020]
[ 1314.900059] stress-ng-iomix (353739): drop_caches: 1
[ 1314.900613] stress-ng-iomix (353733): drop_caches: 1
[ 1314.906668] stress-ng-iomix (353709): drop_caches: 1
[ 1315.156617] stress-ng-iomix (353694): drop_caches: 1
[-- MARK -- Fri Mar  6 15:30:01 2020]
[ 1482.676673] ICMPv6: process `stress-ng-procf' is using deprecated sysc=
tl (sys
call) net.ipv6.neigh.enc600.base_reachable_time - use net.ipv6.neigh.enc6=
00.base
_reachable_time_ms instead
[ 1645.499403] list_add corruption. prev->next should be next (0000000031=
0fa210)
, but was 0000000000000000. (prev=3D0000000000000000).
[ 1645.499435] ------------[ cut here ]------------
[ 1645.499437] kernel BUG at lib/list_debug.c:26!
[ 1645.499499] monitor event: 0040 ilc:2 [#1] SMP
[ 1645.499503] Modules linked in: unix_diag binfmt_misc psnap llc salsa20=
_generi
c camellia_generic cast6_generic cast_common serpent_generic twofish_gene=
ric two
fish_common ofb lrw tgr192 wp512 rmd320 rmd256 rmd160 rmd128 md4 loop tun=
 af_key
  crypto_user nfnetlink scsi_transport_iscsi xt_multiport overlay ip6tabl=
e_securi
ty ip6_tables xt_CONNSECMARK xt_SECMARK xt_state xt_conntrack nf_conntrac=
k nf_de
frag_ipv6 nf_defrag_ipv4 iptable_security ah6 ah4 sctp ghash_s390 prng ae=
s_s390
sunrpc des_s390 libdes qeth_l2 qeth qdio ccwgroup vfio_ccw vfio_mdev mdev=
 vfio_i
ommu_type1 sha512_s390 vfio sha1_s390 ip_tables xfs libcrc32c crc32_vx_s3=
90 sha2
56_s390 sha_common dasd_eckd_mod dasd_mod pkey zcrypt
[ 1645.499548] CPU: 2 PID: 570251 Comm: stress-ng-sysfs Not tainted 5.5.8=
-c30281
6.cki #1
[ 1645.499557] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
[ 1645.499559] Krnl PSW : 0704e00180000000 000000003097bfda (__list_add_v=
alid+0x
a2/0xa8)
[ 1645.499568]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 P=
M:0 RI:
0 EA:3
[ 1645.499570] Krnl GPRS: 0000000000000085 00000000312dbbf0 0000000000000=
075 000
00001ff042a10
[ 1645.499572]            00000001ff051408 0000000000000000 00000001c206a=
b28 000
0000000000000
[ 1645.499573]            0000000000000000 00000000310fa200 00000000310fa=
210 000
003e004fbfd00
[ 1645.499575]            00000001fa680000 00000001c206ab40 000000003097b=
fd6 000
003e004fbfbe8
[ 1645.499581] Krnl Code: 000000003097bfca: c020002f7c46        larl    %=
r2,0000
000030f6b856
[ 1645.499581]            000000003097bfd0: c0e5ffde72e8        brasl   %=
r14,000
000003054a5a0
[ 1645.499581]           #000000003097bfd6: af000000            mc      0=
,0
[ 1645.499581]           >000000003097bfda: 0707                bcr     0=
,%r7
[ 1645.499581]            000000003097bfdc: 0707                bcr     0=
,%r7
[ 1645.499581]            000000003097bfde: 0707                bcr     0=
,%r7
[ 1645.499581]            000000003097bfe0: ebeff0880024        stmg    %=
r14,%r1
5,136(%r15)
[ 1645.499581]            000000003097bfe6: b90400ef            lgr     %=
r14,%r1
5
[ 1645.499596] Call Trace:
[ 1645.499599]  [<000000003097bfda>] __list_add_valid+0xa2/0xa8
[ 1645.499601] ([<000000003097bfd6>] __list_add_valid+0x9e/0xa8)
[ 1645.499606]  [<0000000030d41a84>] __mutex_add_waiter+0x3c/0x88
[ 1645.499608]  [<0000000030d41e60>] __mutex_lock.isra.0+0xd8/0x508
[ 1645.499611]  [<0000000030537364>] psi_show+0x4c/0x1c0
[ 1645.499615]  [<000000003075c94c>] seq_read+0xe4/0x4d8
[ 1645.499619]  [<000000003072adc4>] vfs_read+0x94/0x160
[ 1645.499620]  [<000000003072b1a0>] ksys_read+0x68/0xf8
[ 1645.499623]  [<0000000030d45698>] system_call+0xdc/0x2c8
[ 1645.499624] Last Breaking-Event-Address:
[ 1645.499626]  [<0000000030d46bd8>] __s390_indirect_jump_r14+0x0/0xc
[ 1645.499628] ---[ end trace 0628f5a603be8e67 ]---
[ 1705.505787] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 1705.505800] rcu:     3-....: (4277 ticks this GP) idle=3D49a/1/0x40000=
000000000
00 softirq=3D173963/173963 fqs=3D2258
[ 1705.505829]  (detected by 0, t=3D6002 jiffies, g=3D104505, q=3D612741)
[ 1705.505832] Task dump for CPU 3:
[ 1705.505835] stress-ng-sysfs R  running task        0 570254 570245 0x0=
0000006

ltp: https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/=
03/06/474961/s390x_1_console.log
[ 6428.638258] LTP: starting proc01 (proc01 -m 128)
[ 6429.364183] ICMPv6: process `proc01' is using deprecated sysctl (sysca=
ll) net
.ipv6.neigh.cni-podman0.base_reachable_time - use net.ipv6.neigh.cni-podm=
an0.bas
e_reachable_time_ms instead
[ 6430.215989] LTP: starting read_all_dev (read_all -d /dev -p -q -r 10)
[ 6431.504709] LTP: starting read_all_proc (read_all -d /proc -q -r 10)
[ 6431.547885] ICMPv6: process `read_all' is using deprecated sysctl (sys=
call) n
et.ipv6.neigh.cni-podman0.base_reachable_time - use net.ipv6.neigh.cni-po=
dman0.b
ase_reachable_time_ms instead
[ 6435.327086] LTP: starting read_all_sys (read_all -d /sys -q -r 10)
[ 6436.214256] list_add corruption. prev->next should be next (00000000d4=
7c6210)
, but was 0000000000000000. (prev=3D0000000000000000).
[ 6436.214292] ------------[ cut here ]------------
[ 6436.214295] kernel BUG at lib/list_debug.c:26!
[ 6436.214392] monitor event: 0040 ilc:2 [#1] SMP
[ 6436.214397] Modules linked in: kvm dummy minix binfmt_misc nfsv3 nfs_a=
cl nfs
lockd grace fscache sctp rds btrfs blake2b_generic xor zstd_compress raid=
6_pq zs
td_decompress brd vfat fat loop tun ip6table_nat ip6_tables xt_conntrack =
iptable
_filter xt_MASQUERADE xt_comment iptable_nat nf_nat nf_conntrack nf_defra=
g_ipv6
nf_defrag_ipv4 veth bridge stp llc overlay fuse ghash_s390 prng sunrpc ae=
s_s390
des_s390 libdes qeth_l2 qeth qdio ccwgroup vfio_ccw vfio_mdev mdev sha512=
_s390 v
fio_iommu_type1 sha1_s390 vfio ip_tables xfs libcrc32c crc32_vx_s390 sha2=
56_s390
  sha_common dasd_eckd_mod dasd_mod pkey zcrypt
[ 6436.214456] CPU: 0 PID: 729531 Comm: read_all Not tainted 5.5.8-c30281=
6.cki #
1
[ 6436.214460] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
[ 6436.217487] Krnl PSW : 0704e00180000000 00000000d4047fda (__list_add_v=
alid+0x
a2/0xa8)
[ 6436.217497]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 P=
M:0 RI:
0 EA:3
[ 6436.217500] Krnl GPRS: 0000000000000085 00000000d49a7bf0 0000000000000=
075 000
00001ff002a10
[ 6436.217501]            00000001ff011408 0000000000000000 00000001b7992=
a28 000
0000000000000
[ 6436.217503]            0000000000000000 00000000d47c6200 00000000d47c6=
210 000
003e001bebd00
[ 6436.217504]            00000000fa7e2000 00000001b7992a40 00000000d4047=
fd6 000
003e001bebbe8
[ 6436.217512] Krnl Code: 00000000d4047fca: c020002f7c46        larl    %=
r2,0000
0000d4637856
[ 6436.217512]            00000000d4047fd0: c0e5ffde72e8        brasl   %=
r14,000
00000d3c165a0
[ 6436.217512]           #00000000d4047fd6: af000000            mc      0=
,0
[ 6436.217512]           >00000000d4047fda: 0707                bcr     0=
,%r7
[ 6436.217512]            00000000d4047fdc: 0707                bcr     0=
,%r7
[ 6436.217512]            00000000d4047fde: 0707                bcr     0=
,%r7
[ 6436.217512]            00000000d4047fe0: ebeff0880024        stmg    %=
r14,%r
5,136(%r15)
[ 6436.217512]            00000000d4047fe6: b90400ef            lgr     %=
r14,%r1
5
[ 6436.217527] Call Trace:
[ 6436.217530]  [<00000000d4047fda>] __list_add_valid+0xa2/0xa8
[ 6436.217532] ([<00000000d4047fd6>] __list_add_valid+0x9e/0xa8)
[ 6436.217538]  [<00000000d440da84>] __mutex_add_waiter+0x3c/0x88
[ 6436.217540]  [<00000000d440de60>] __mutex_lock.isra.0+0xd8/0x508
[ 6436.217544]  [<00000000d3c03364>] psi_show+0x4c/0x1c0
[ 6436.217547]  [<00000000d3e2894c>] seq_read+0xe4/0x4d8
[ 6436.217551]  [<00000000d3df6dc4>] vfs_read+0x94/0x160
[ 6436.217553]  [<00000000d3df71a0>] ksys_read+0x68/0xf8
[ 6436.217556]  [<00000000d4411698>] system_call+0xdc/0x2c8
[ 6436.217556] Last Breaking-Event-Address:
[ 6436.217559]  [<00000000d4412bd8>] __s390_indirect_jump_r14+0x0/0xc
[ 6436.217561] ---[ end trace 59c684509f54b20b ]---
[ 6496.161797] rcu: INFO: rcu_sched self-detected stall on CPU
[ 6496.161810] rcu:     3-....: (5247 ticks this GP) idle=3D4aa/1/0x40000=
000000000
02 softirq=3D693782/693782 fqs=3D2851
[ 6496.161838]  (t=3D6001 jiffies g=3D640657 q=3D782)
[ 6496.161841] Task dump for CPU 3:
[ 6496.161844] read_all        R  running task        0 729533 729530 0x0=
0000004

>=20
> We hope that these logs can help you find the problem quickly. For the =
full
> detail on our testing procedures, please scroll to the bottom of this m=
essage.
>=20
> Please reply to this email if you have any questions about the tests th=
at we
> ran or if you have any suggestions on how to make future tests more eff=
ective.
>=20
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _______________________________________________________________________=
_______
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 4 architectures:
>=20
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      s390x:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>=20
>    aarch64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func - local
>         =E2=9C=85 Networking route_func - forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns - transport
>         =E2=9C=85 Networking ipsec: basic netns - tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>         =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>         =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func - local
>         =E2=9C=85 Networking route_func - forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns - tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>         =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>         =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    s390x:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9D=8C LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic tes=
t
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tra=
nsport
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tun=
nel
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suite=
s
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - DaCapo Benchmark=
 Suite
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test su=
ite
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvla=
n/basic
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9D=8C stress: stress-ng
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - megaraid_sas
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =E2=9C=85 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 3:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - mpt3sas driver
>=20
>      Host 4:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func - local
>         =E2=9C=85 Networking route_func - forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns - transport
>         =E2=9C=85 Networking ipsec: basic netns - tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>         =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>         =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvemen=
ts to existing tests!
>=20
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7=
. Such tests are
> executed but their results are not taken into account. Tests are waived=
 when
> their results are not reliable enough, e.g. when they're just introduce=
d or are
> being fixed.
>=20
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that have=
n't
> finished running yet are marked with =E2=8F=B1.
>=20
>=20

