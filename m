Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F88188BB8
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 18:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgCQRL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 13:11:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20660 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgCQRL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 13:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584465116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=247/teCd/vfmc+cZBfW10f89ThAB0tLidOPGNHN8l6M=;
        b=FL3EVPK0xjFvj+ZXXeMeeIWLqWDA52FhW0y686CAxSUfL/AdKY8uYhN7LzwoiGTqkI+acM
        7PnzA+BWxLonI+KBs4Y1kY3Sw/ZT6+LM4+MX89xFx9YFzqQsa/njiaLQj6Iyq9aU4rIjrz
        7wJGdbj1PhQ/F8gOYme3gUJ6xT4zVAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-xfvRDxQxMC-k6RfVluiNGA-1; Tue, 17 Mar 2020 13:11:49 -0400
X-MC-Unique: xfvRDxQxMC-k6RfVluiNGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB7D19667AB;
        Tue, 17 Mar 2020 17:10:43 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-136.rdu2.redhat.com [10.10.112.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCFEA7E33B;
        Tue, 17 Mar 2020 17:10:28 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=5bLTP=5d_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_?=
 =?UTF-8?Q?5=2e5=2e10-rc1-97969bd=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Ondrej Moris <omoris@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.45BE8D2AEE.EDVG8CXFLJ@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <4f7fbcf7-6168-8b07-9f2f-e1a17a502000@redhat.com>
Date:   Tue, 17 Mar 2020 13:10:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.45BE8D2AEE.EDVG8CXFLJ@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/17/20 12:38 PM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/st=
able/linux-stable-rc.git
>              Commit: 97969bd17009 - Linux 5.5.10-rc1
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
datawarehouse/2020/03/17/492657
>=20
> One or more kernel tests failed:
>=20
>      ppc64le:
>       =E2=9D=8C LTP
>=20

The dmesg check failed during LTP, most likely due to running on a slow k=
vm guest:

[ 7006.259467] watchdog: BUG: soft lockup - CPU#2 stuck for 21s! [diotest=
6:818841]
[ 7138.007023] watchdog: BUG: soft lockup - CPU#8 stuck for 38s! [systemd=
-journal:561]


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
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
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
>    ppc64le:
>      Host 1:
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
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    s390x:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
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
>      Host 2:
>         =E2=9C=85 Boot test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - mpt3sas driver
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =E2=9C=85 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 3:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - megaraid_sas
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

