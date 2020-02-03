Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D192A1505AD
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 12:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgBCLxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 06:53:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727256AbgBCLxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 06:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580730817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFA0sUwFQiVI/v8qtF4RtDICWiIO9VSKBpDkFRWbZHU=;
        b=gCHtmC7pHUmij5qYq9y28JJNH0b398VIBhWiAZNaVhOrc1KwBqI8kktpCqQSnMe0Be1Sic
        gFNZ/x2F0h6ivMrithyqlou9p7gx94AzXgnek96V9+3SHKs/ZZAfInlKdBk2wsPif4N6PG
        KRVhycyNjZ6hPMm0oAr66oEGTn0n98U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-aUMDxmvXP5S9W3045PtEIA-1; Mon, 03 Feb 2020 06:53:33 -0500
X-MC-Unique: aUMDxmvXP5S9W3045PtEIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBA4E1851FD8
        for <stable@vger.kernel.org>; Mon,  3 Feb 2020 11:53:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C34231BC6D
        for <stable@vger.kernel.org>; Mon,  3 Feb 2020 11:53:32 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id BA8E281720;
        Mon,  3 Feb 2020 11:53:32 +0000 (UTC)
Date:   Mon, 3 Feb 2020 06:53:32 -0500 (EST)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <1764516057.4804858.1580730812581.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.23F8456381.YW5PMKDN0H@redhat.com>
References: <cki.23F8456381.YW5PMKDN0H@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kerne?=
 =?utf-8?Q?l_5.5.0-b3e3082.cki_(stable-next)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.205.219, 10.4.195.3]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.5.0-b3e3082.cki (stable-next)
Thread-Index: EtqCIF1aYt42nzXZMDYXcdJ4nKfJIA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Monday, February 3, 2020 9:06:21 AM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.5.0-b3e3082.cki (stable=
-next)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.=
git
>             Commit: b3e3082be48b - ARM: dma-api: fix max_pfn off-by-one e=
rror
>             in __dma_supported()
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://artifacts.cki-project.org/pipelines/417813
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C Boot test
>=20

[   40.416312] bnx2x 0045:01:00.0: Direct firmware load for bnx2x/bnx2x-e2-=
7.13.15.0.fw failed with error -2=20
[   40.416339] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f0)]Can't load fi=
rmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
[   40.416349] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f0)]Error loading f=
irmware=20
[   40.416362] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f0)]HW init failed, abo=
rting=20
[   40.556594] bnx2x 0045:01:00.1: Direct firmware load for bnx2x/bnx2x-e2-=
7.13.15.0.fw failed with error -2=20
[   40.556621] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f1)]Can't load fi=
rmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
[   40.556631] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f1)]Error loading f=
irmware=20
[   40.556646] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f1)]HW init failed, abo=
rting=20
[   40.706538] bnx2x 0045:01:00.2: Direct firmware load for bnx2x/bnx2x-e2-=
7.13.15.0.fw failed with error -2=20
[   40.706563] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f2)]Can't load fi=
rmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
[   40.706572] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f2)]Error loading f=
irmware=20
[   40.706587] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f2)]HW init failed, abo=
rting=20
[   40.836616] bnx2x 0045:01:00.3: Direct firmware load for bnx2x/bnx2x-e2-=
7.13.15.0.fw failed with error -2=20
[   40.836638] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f3)]Can't load fi=
rmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
[   40.836645] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f3)]Error loading f=
irmware=20
[   40.836657] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f3)]HW init failed, abo=
rting=20

The recipe aborted later due to networking issues, which might be caused by
the messages above.

The messages are not present with kernel-5.4.8-200.fc31.ppc64le which makes
me wonder if something related changed in the kernel, whether it's a planne=
d
change we need to account for or actual breakage? The other ppc64le machine
we ran on didn't use bnx2x.


Veronika

> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this
> message.
>=20
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more
> effective.
>=20
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> _________________________________________________________________________=
_____
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 3 architectures:
>=20
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>=20
>   aarch64:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 xfstests: ext4
>        =E2=9C=85 xfstests: xfs
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 lvm thinp sanity
>        =E2=9C=85 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Podman system integration test (as root)
>        =E2=9C=85 Podman system integration test (as user)
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking MACsec: sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking sctp-auth: sockopts test
>        =E2=9C=85 Networking: igmp conformance test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func: local
>        =E2=9C=85 Networking route_func: forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns transport
>        =E2=9C=85 Networking ipsec: basic netns tunnel
>        =E2=9C=85 audit: audit testsuite test
>        =E2=9C=85 httpd: mod_ssl smoke sanity
>        =E2=9C=85 tuned: tune-processes-through-perf
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 storage: SCSI VPD
>        =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>   ppc64le:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Podman system integration test (as root)
>        =E2=9C=85 Podman system integration test (as user)
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking MACsec: sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking sctp-auth: sockopts test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func: local
>        =E2=9C=85 Networking route_func: forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns tunnel
>        =E2=9C=85 audit: audit testsuite test
>        =E2=9C=85 httpd: mod_ssl smoke sanity
>        =E2=9C=85 tuned: tune-processes-through-perf
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>     Host 2:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>   x86_64:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Storage SAN device stress - mpt3sas driver
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Podman system integration test (as root)
>        =E2=9C=85 Podman system integration test (as user)
>        =E2=9C=85 LTP
>        =E2=9C=85 Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking MACsec: sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking sctp-auth: sockopts test
>        =E2=9C=85 Networking: igmp conformance test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func: local
>        =E2=9C=85 Networking route_func: forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns transport
>        =E2=9C=85 Networking ipsec: basic netns tunnel
>        =E2=9C=85 audit: audit testsuite test
>        =E2=9C=85 httpd: mod_ssl smoke sanity
>        =E2=9C=85 tuned: tune-processes-through-perf
>        =E2=9C=85 pciutils: sanity smoke test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 storage: SCSI VPD
>        =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>     Host 3:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Storage SAN device stress - megaraid_sas
>=20
>     Host 4:
>        =E2=9C=85 Boot test
>        =E2=9C=85 xfstests: ext4
>        =E2=9C=85 xfstests: xfs
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 lvm thinp sanity
>        =E2=9C=85 storage: software RAID testing
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>   Test sources: https://github.com/CKI-project/tests-beaker
>     =F0=9F=92=9A Pull requests are welcome for new tests or improvements =
to existing
>     tests!
>=20
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests
> are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or
> are
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
>=20

