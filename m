Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC951E7382
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbfJ1OTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:19:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728330AbfJ1OTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 10:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572272358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIqIy4G6voT8Bt5N8/Z0qn2TTJxaJuwApMPCeO2OT2U=;
        b=dN1Y5EB1AzHuOAst9dy/4KpPramCvh2ELE4dz1oS6TF4LE7HWCi7g++UUA+zP3QDcMb7jD
        xQIrsA926El5yDEYz/WnU7R1wxNXo1OCTNEUMFHuXSJKuX7aPLsmmjw7rWm0m/yaL5xhcR
        CZnNUhUZ6Uq1leHJRmMMwSE9uKOIaJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-9nRxNoW3PwuExjw05Yk0TQ-1; Mon, 28 Oct 2019 10:19:16 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 504EB1005509
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 14:19:15 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-15.rdu2.redhat.com [10.10.121.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D889A600C9;
        Mon, 28 Oct 2019 14:19:06 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e3=2e8-?=
 =?UTF-8?Q?rc1-740177d=2ecki_=28stable=29?=
To:     Memory Management <mm-qe@redhat.com>, Xiong Zhou <xzhou@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>
References: <cki.944DA2AA5D.T2W6XE1PPV@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <d0684d9e-5a89-1d7f-2e00-40143f07c06b@redhat.com>
Date:   Mon, 28 Oct 2019 10:19:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cki.944DA2AA5D.T2W6XE1PPV@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 9nRxNoW3PwuExjw05Yk0TQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Xiong, the generic/402 test is failing for both ext4/xfs tests with upstrea=
m kernels, including
previous reports. Is this a test issue related to moving to F31 distro or s=
omething else ?
Also, the kaslr memory test is failing, but I have seen it fail in previous=
 upstream reports,
hoping someone from the MM-QE@ team can follow up here ?

Thanks,
Rachel
 =20
Running test generic/402
#! /bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
#
# FS QA Test 402
#
# Test to verify filesystem timestamps for supported ranges.
#
# Exit status 1: test failed.
# Exit status 0: test passed.
FSTYP         -- ext4
PLATFORM      -- Linux/aarch64 apm-mustang-ev3-31 5.3.8-rc1-740177d.cki #1 =
SMP Sun Oct 27 20:49:25 UTC 2019
MKFS_OPTIONS  -- /dev/sda4
MOUNT_OPTIONS -- -o acl,user_xattr -o context=3Dsystem_u:object_r:nfs_t:s0 =
/dev/sda4 /mnt/xfstests/mnt2

generic/402=09- output mismatch (see /var/lib/xfstests/results//generic/402=
.out.bad)
     --- tests/generic/402.out=092019-10-27 17:58:14.916322247 -0400
     +++ /var/lib/xfstests/results//generic/402.out.bad=092019-10-27 18:14:=
39.392150403 -0400
     @@ -1,2 +1,4 @@
      QA output created by 402
     +15032385535;15032385535 !=3D 15032385536;15032385536
     +15032385535;15032385535 !=3D -2147483648;-2147483648
      Silence is golden
     ...
     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out /var/lib/xfstest=
s/results//generic/402.out.bad'  to see the entire diff)
Ran: generic/402
Failures: generic/402
Failed 1 of 1 tests

Uploading generic-402.full .done
Uploading generic-402.out.bad .done
Uploading generic-402.out.bad.diff .done
** ext4:generic/402 FAIL Score:0
Uploading resultoutputfile.log .done


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::
::   kaslr-compare
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::

:: [ 19:02:29 ] :: [   PASS   ] :: to next state after_r_nokaslr_snapshot (=
Expected 0, got 0)
:: [ 19:02:29 ] :: [   FAIL   ] :: _text should be non-default (Assert: "ff=
ffffff81000000" should not equal "ffffffff81000000")
:: [ 19:02:30 ] :: [   PASS   ] :: Kernel_code should be non-default (Asser=
t: "01000000" should not equal "8d000000")


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::
::   kaslr-compare
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::

:: [ 19:02:29 ] :: [   PASS   ] :: to next state after_r_nokaslr_snapshot (=
Expected 0, got 0)
:: [ 19:02:29 ] :: [   FAIL   ] :: _text should be non-default (Assert: "ff=
ffffff81000000" should not equal "ffffffff81000000")

On 10/27/19 11:26 PM, CKI Project wrote:
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable=
/linux-stable-rc.git
>              Commit: 740177dc0d52 - Linux 5.3.8-rc1
>
> The results of these automated tests are provided below.
>
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>    https://artifacts.cki-project.org/pipelines/251766
>
> One or more kernel tests failed:
>
>      ppc64le:
>       =E2=9D=8C xfstests: ext4
>       =E2=9D=8C xfstests: xfs
>
>      aarch64:
>       =E2=9D=8C xfstests: ext4
>       =E2=9D=8C xfstests: xfs
>
>      x86_64:
>       =E2=9D=8C Memory function: kaslr
>       =E2=9D=8C xfstests: ext4
>       =E2=9D=8C xfstests: xfs
>
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _________________________________________________________________________=
_____
>
> Compile testing
> ---------------
>
> We compiled the kernel for 3 architectures:
>
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>
>    aarch64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9D=8C xfstests: ext4
>         =E2=9D=8C xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9D=8C xfstests: ext4
>         =E2=9D=8C xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>
>      Host 2:
>
>         =E2=9A=A1 Internal infrastructure issues prevented one or more te=
sts (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectu=
re.
>         This is not the fault of the kernel that was tested.
>
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9D=8C Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>
>      Host 3:
>         =E2=9C=85 Boot test
>         =E2=9D=8C xfstests: ext4
>         =E2=9D=8C xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9D=8C Storage blktests
>
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvements=
 to existing tests!
>
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or are
> being fixed.
>
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven'=
t
> finished running are marked with =E2=8F=B1. Reports for non-upstream kern=
els have
> a Beaker recipe linked to next to each host.
>

