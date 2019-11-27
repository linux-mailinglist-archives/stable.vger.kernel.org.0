Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432DA10B1DB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfK0PG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 10:06:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbfK0PG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 10:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574867183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EaVr4UgXcbNLw/9QRG1YMaaL3NI+nncrdl2+uZERZMg=;
        b=hKaRxGAYR2zNSXs11QZ0npyBa+N/bk0gjTwmBLkp7MYEQ4I57lfE8fzMCOkswFNUp9UwBS
        PUcX2jB6In8EVIdFLZgJjVIJN841I8bFfpmFJSlaB+FxLDpGs/BF3EabEgjx3gHER7XsYV
        WhWZvosQRC9bp+uuU3rY2QBZM6v8l94=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-57cgVaPlMdW4rZboJ6HKSA-1; Wed, 27 Nov 2019 10:06:20 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7A618B5FA7;
        Wed, 27 Nov 2019 15:06:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-110.rdu2.redhat.com [10.10.120.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97FA019C6A;
        Wed, 27 Nov 2019 15:06:13 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e3=2e13?=
 =?UTF-8?Q?-cc9917b=2ecki_=28stable-queue=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Xiong Zhou <xzhou@redhat.com>
References: <cki.B4696121A3.SRVKVUGWT3@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <546bd6ac-8ab1-9a9b-5856-e6410fb8ee89@redhat.com>
Date:   Wed, 27 Nov 2019 10:06:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.B4696121A3.SRVKVUGWT3@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 57cgVaPlMdW4rZboJ6HKSA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/27/19 9:30 AM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable=
/stable-queue.git
>              Commit: cc9917b40848 - mdio_bus: Fix init if CONFIG_RESET_CO=
NTROLLER=3Dn
>=20
> The results of these automated tests are provided below.
>=20
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>    https://artifacts.cki-project.org/pipelines/309848
>=20
> One or more kernel tests failed:
>=20
>      ppc64le:
>       =E2=9D=8C LTP

I see a slew of syscalls failures here for LTP:
https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_=
resultoutputfile.log
https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_=
syscalls.run.log


>       =E2=9D=8C xfstests: xfs

Also generic/212 test failed for xfstests:
https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_2_xfst=
ests__xfs_taskout.log

Running test generic/212
#! /bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
#
# FS QA Test No. 212
#
# Run aio-io-setup-with-nonwritable-context-pointer -
# Test what happens when a non-writable context pointer is passed to=20
io_setup
#
seq=3D`basename $0`
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/ppc64le ibm-p9b-03 5.3.13-cc9917b.cki #1 SMP Tue=20
Nov 26 18:18:25 UTC 2019
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D1,reflink=3D1 -i sparse=
=3D1=20
/dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sda3=20
/mnt/xfstests/mnt2

generic/212 0s ... [failed, exit status 135]- output mismatch (see=20
/var/lib/xfstests/results//generic/212.out.bad)
     --- tests/generic/212.out=092019-11-26 18:36:35.624357754 -0500
     +++ /var/lib/xfstests/results//generic/212.out.bad=092019-11-26=20
18:44:30.926323027 -0500
     @@ -1,2 +1,2 @@
      QA output created by 212
     -aio-io-setup-with-nonwritable-context-pointer: Success!
     +./common/rc: line 1949: 521294 Bus error               (core=20
dumped) $AIO_TEST $testtemp 2>&1
     ...
     (Run 'diff -u /var/lib/xfstests/tests/generic/212.out=20
/var/lib/xfstests/results//generic/212.out.bad'  to see the entire diff)
Ran: generic/212
Failures: generic/212
Failed 1 of 1 tests

>=20
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>=20
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>=20
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _________________________________________________________________________=
_____
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 3 architectures:
>=20
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      ppc64le:
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
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns transport
>         =E2=9C=85 Networking ipsec: basic netns tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9D=8C LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9D=8C xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
>         =E2=8F=B1  Boot test
>         =E2=8F=B1  Storage SAN device stress - mpt3sas driver
>=20
>      Host 3:
>         =E2=8F=B1  Boot test
>         =E2=8F=B1  Storage SAN device stress - megaraid_sas
>=20
>      Host 4:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more te=
sts (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectu=
re.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as ro=
ot)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as us=
er)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns transpo=
rt
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Elemen=
t test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/=
basic
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvements=
 to existing tests!
>=20
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or are
> being fixed.
>=20
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven'=
t
> finished running are marked with =E2=8F=B1. Reports for non-upstream kern=
els have
> a Beaker recipe linked to next to each host.
>=20

