Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3724109F3E
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfKZN0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:26:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbfKZN0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:26:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574774793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DcvEHIJZWBqVlJvq+SJv5wOTYdiwD8vTpptzhnRSYQ=;
        b=eowouI+JrGvL6JGY9jemWPvnKGP8u0vFBStB16LrxqvihpdqiYEx7wYK4aYZhL1aG7m8cl
        Ue4SA9P3TzFw1wZJ7ZfNkVq1XvFci6aofJbT+bj1rc0WRWhUxDwPrytx0D0HWX1DZW9g0v
        G75Zrc6MDvquGqQtHRznsCRgN37XiSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-MNZDdtlkNiqTGZ3Mq4n01Q-1; Tue, 26 Nov 2019 08:26:32 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 548378FDD5A
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 13:26:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-110.rdu2.redhat.com [10.10.120.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 044DA5D9CA;
        Tue, 26 Nov 2019 13:26:27 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e3=2e13?=
 =?UTF-8?Q?-72236ff=2ecki_=28stable-queue=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
References: <cki.AFEB28A873.U9RSQI6CA0@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <99708f0a-7431-d9aa-44f6-ab6780635800@redhat.com>
Date:   Tue, 26 Nov 2019 08:26:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.AFEB28A873.U9RSQI6CA0@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: MNZDdtlkNiqTGZ3Mq4n01Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/26/19 12:25 AM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable=
/stable-queue.git
>              Commit: 72236fffb872 - net/mlx5: Update the list of the PCI =
supported devices
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
>    https://artifacts.cki-project.org/pipelines/307736
>=20
> One or more kernel tests failed:
>=20
>      x86_64:
>       =E2=9D=8C Boot test
>       =E2=9D=8C Boot test

In both cases, there was a watchdog timeout when installing the
dependencies for the kpkginstall task which installs the modified
kernel. So the tests were never run, we have an issue filed against
the restraint test harness to be investigated further.

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
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
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
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more te=
sts (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architectu=
re.
>         This is not the fault of the kernel that was tested.
>=20
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
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>    x86_64:
>      Host 1:
>         =E2=9D=8C Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - mpt3sas d=
river
>=20
>      Host 2:
>         =E2=9D=8C Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage SAN device stress - megaraid_=
sas
>=20
>      Host 3:
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
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>      Host 4:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
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

