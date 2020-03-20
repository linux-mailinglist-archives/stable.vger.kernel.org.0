Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A934A18D8B0
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 20:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCTTsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 15:48:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26018 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgCTTsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 15:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584733694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4YxYaSvTK0H9iUMlzp8Ebii//uuz9TOoH4dEwBTI+pc=;
        b=Pf5GRGVChX23lJO1Qk1BVKVebBAR8xwnt9cbQg8PTP6U9sS2+6uXD5gEXUalBIfg9ACMGO
        JHMjvAgG4C1w1YGvy66uL3rpHSdFaWv9xpqpUHIMb4CDa9iNWwOeeJ7ZFvUw7k0NoIONSb
        01EVRQlSq8GhA/Of5aIWCwodbNSqKzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-EJMvf-PkOgCy4XJm_HXjoQ-1; Fri, 20 Mar 2020 15:48:10 -0400
X-MC-Unique: EJMvf-PkOgCy4XJm_HXjoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6316518FE860;
        Fri, 20 Mar 2020 19:48:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-136.rdu2.redhat.com [10.10.112.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AACE71001B07;
        Fri, 20 Mar 2020 19:48:02 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e5=2e11?=
 =?UTF-8?Q?-rc3-bea9431=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Ondrej Moris <omoris@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>
References: <cki.0B4BE5D73F.9NAD0VB3SU@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <f893b5c9-46b3-1f22-ad13-d193095bb54b@redhat.com>
Date:   Fri, 20 Mar 2020 15:48:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.0B4BE5D73F.9NAD0VB3SU@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/20/20 2:02 PM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git
>              Commit: bea94317c526 - Linux 5.5.11-rc3
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
datawarehouse/2020/03/20/497256
>=20
> One or more kernel tests failed:
>=20
>      ppc64le:
>       =E2=9D=8C LTP

The dmesg check failed, likely due to a slow kvm guest:
[ 7536.055236] watchdog: BUG: soft lockup - CPU#2 stuck for 33s! [diotest=
6:819306]

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
>         =F0=9F=9A=A7 =E2=9D=8C audit: audit testsuite test
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
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    ppc64le:
>      Host 1:
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
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9D=8C LTP
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
>         =F0=9F=9A=A7 =E2=9D=8C audit: audit testsuite test
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    s390x:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
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
>         =E2=9C=85 Networking ipsec: basic netns - transport
>         =E2=9C=85 Networking ipsec: basic netns - tunnel
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>         =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>         =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9D=8C audit: audit testsuite test
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - megaraid_sas
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - mpt3sas driver
>=20
>      Host 3:
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
>         =F0=9F=9A=A7 =E2=9D=8C audit: audit testsuite test
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>      Host 4:
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
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvemen=
ts to existing tests!
>=20
> Aborted tests
> -------------
> Tests that didn't complete running successfully are marked with =E2=9A=A1=
=E2=9A=A1=E2=9A=A1.
> If this was caused by an infrastructure issue, we try to mark that
> explicitly in the report.
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

