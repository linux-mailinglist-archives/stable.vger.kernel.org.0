Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8CE220E47
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 15:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731782AbgGONgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 09:36:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731847AbgGONgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 09:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594820207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CEa4O+2huLPeKf0ehz78WiI1JqlOR+vqG6W6TBPiPWk=;
        b=WOusZU+vN5ebiGbYYTkI6Zncwibo2RWm8G+alqpZLxJHHHmbx+0TqcSP/CgBbeBRpSoVLR
        hNzZRYModcbXWl8oSuZqnCBqe0sMvOv02uRgewH37JF01fDSsndzLXiHz9ABFanQHIbiRq
        fXM5Nc99jXM2/cJF9J7K4tC2uopVuEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-UM9nWWh_PbyhRSuTvNReEg-1; Wed, 15 Jul 2020 09:36:45 -0400
X-MC-Unique: UM9nWWh_PbyhRSuTvNReEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0AED100AA22
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 13:36:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9369757DF
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 13:36:44 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1E541809543;
        Wed, 15 Jul 2020 13:36:44 +0000 (UTC)
Date:   Wed, 15 Jul 2020 09:36:44 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     Xiong Zhou <xzhou@redhat.com>
Message-ID: <2125467353.2778784.1594820204666.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.9BE0703C38.BLD1GT3V8U@redhat.com>
References: <cki.9BE0703C38.BLD1GT3V8U@redhat.com>
Subject: =?utf-8?Q?Re:_=F0=9F=92=A5_PANICKED:_Test_report_for_ke?=
 =?utf-8?Q?rnel_5.7.9-rc1-c2fb28a.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.40.195.154, 10.4.195.26]
Thread-Topic: ? PANICKED: Test report for kernel 5.7.9-rc1-c2fb28a.cki (stable)
Thread-Index: HexhQ0Y+vugadNdTo3qbdrvYBGzfdA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Cc: "Xiong Zhou" <xzhou@redhat.com>
> Sent: Wednesday, July 15, 2020 3:33:45 PM
> Subject: =F0=9F=92=A5 PANICKED: Test report for kernel 5.7.9-rc1-c2fb28a.=
cki (stable)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
>             Commit: c2fb28a4b6e4 - Linux 5.7.9-rc1
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: PANICKED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/07/14/610210
>=20
> One or more kernel tests failed:
>=20
>     s390x:
>      =E2=9D=8C Boot test
>      =E2=9D=8C Boot test
>      =F0=9F=92=A5 Boot test
>=20

Hi,

we started observing boot panics with 5.7 on s390x yesterday:

[    0.388965] Kernel panic - not syncing: Corrupted kernel text
[    0.388970] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.7.8-0930ce5.ck=
i #1
[    0.388971] Hardware name: IBM 2964 N96 400 (z/VM 6.4.0)
[    0.388975] Workqueue: events timer_update_keys
[    0.388977] Call Trace:
[    0.388980]  [<00000001378c868a>] show_stack+0x8a/0xd0
[    0.388983]  [<0000000137e0c9c2>] dump_stack+0x8a/0xb8
[    0.388985]  [<00000001378fa372>] panic+0x112/0x308
[    0.388989]  [<00000001378d20b6>] jump_label_bug+0x7e/0x80
[    0.388990]  [<00000001378d1fb8>] __jump_label_transform+0xa8/0xd8
[    0.388992]  [<00000001378d200e>] arch_jump_label_transform+0x26/0x40
[    0.388995]  [<0000000137a8d448>] __jump_label_update+0xb8/0x128
[    0.388996]  [<0000000137a8dca6>] static_key_enable_cpuslocked+0x8e/0xd0
[    0.388998]  [<0000000137a8dd18>] static_key_enable+0x30/0x40
[    0.389000]  [<000000013798a0d2>] timer_update_keys+0x3a/0x50
[    0.389003]  [<000000013791cdde>] process_one_work+0x206/0x458
[    0.389005]  [<000000013791d078>] worker_thread+0x48/0x460
[    0.389007]  [<0000000137924912>] kthread+0x12a/0x160
[    0.389013]  [<00000001381b9a70>] ret_from_fork+0x2c/0x30

I only released one of the reports to not spam too much but the panics are
still happening with the most recent code.

These panics are NOT present on the current mainline. All other arches are =
OK.

Given the call trace, I'm guessing it is something related to

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/?h=3Dlinux-5.7.y&id=3D477d4930b0c7e70c1ac3e3c35e5ad15c5ebde8be



Veronika

>     ppc64le:
>      =E2=9D=8C Loopdev Sanity
>=20
>     aarch64:
>      =E2=9D=8C Loopdev Sanity
>=20
>     x86_64:
>      =E2=9D=8C Loopdev Sanity
>=20

[We're still investigating these, feel free to ignore for now.]

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
> We compiled the kernel for 4 architectures:
>=20
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     s390x:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
>=20
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>=20
>   aarch64:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 ACPI table test
>        =E2=9C=85 ACPI enabled test
>        =E2=9C=85 Podman system integration test - as root
>        =E2=9C=85 Podman system integration test - as user
>        =E2=9C=85 LTP
>        =E2=9D=8C Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking: igmp conformance test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - transport
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =E2=9C=85 pciutils: update pci ids test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 storage: SCSI VPD
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 kdump - kexec_boot
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =E2=9C=85 xfstests - ext4
>        =E2=9C=85 xfstests - xfs
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>   ppc64le:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 xfstests - ext4
>        =E2=9C=85 xfstests - xfs
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =F0=9F=9A=A7 =E2=9C=85 kdump - sysrq-c
>=20
>     Host 3:
>        =E2=9C=85 Boot test
>        =E2=9C=85 Podman system integration test - as root
>        =E2=9C=85 Podman system integration test - as user
>        =E2=9C=85 LTP
>        =E2=9D=8C Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =E2=9C=85 pciutils: update pci ids test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>=20
>   s390x:
>     Host 1:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>     Host 2:
>        =E2=9D=8C Boot test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 kdump - sysrq-c
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 kdump - file-load
>=20
>     Host 3:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as ro=
ot
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as us=
er
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - transp=
ort
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - DaCapo Benchmark Su=
ite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basi=
c netfilter test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite te=
st
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 kdump - kexec_boot
>=20
>   x86_64:
>     Host 1:
>        =E2=9C=85 Boot test
>        =E2=9C=85 xfstests - ext4
>        =E2=9C=85 xfstests - xfs
>        =E2=9C=85 selinux-policy: serge-testsuite
>        =E2=9C=85 storage: software RAID testing
>        =E2=9C=85 stress: stress-ng
>        =F0=9F=9A=A7 =E2=9C=85 CPU: Frequency Driver Test
>        =F0=9F=9A=A7 =E2=9C=85 CPU: Idle Test
>        =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9C=85 power-management: cpupower/sanity test
>        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =E2=9C=85 ACPI table test
>        =E2=9C=85 Podman system integration test - as root
>        =E2=9C=85 Podman system integration test - as user
>        =E2=9C=85 LTP
>        =E2=9D=8C Loopdev Sanity
>        =E2=9C=85 Memory function: memfd_create
>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
>        =E2=9C=85 Networking bridge: sanity
>        =E2=9C=85 Ethernet drivers sanity
>        =E2=9C=85 Networking socket: fuzz
>        =E2=9C=85 Networking: igmp conformance test
>        =E2=9C=85 Networking route: pmtu
>        =E2=9C=85 Networking route_func - local
>        =E2=9C=85 Networking route_func - forward
>        =E2=9C=85 Networking TCP: keepalive test
>        =E2=9C=85 Networking UDP: socket
>        =E2=9C=85 Networking tunnel: geneve basic test
>        =E2=9C=85 Networking tunnel: gre basic
>        =E2=9C=85 L2TP basic test
>        =E2=9C=85 Networking tunnel: vxlan basic
>        =E2=9C=85 Networking ipsec: basic netns - transport
>        =E2=9C=85 Networking ipsec: basic netns - tunnel
>        =E2=9C=85 Libkcapi AF_ALG test
>        =E2=9C=85 pciutils: sanity smoke test
>        =E2=9C=85 pciutils: update pci ids test
>        =E2=9C=85 ALSA PCM loopback test
>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
>        =E2=9C=85 storage: SCSI VPD
>        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9C=85 jvm - DaCapo Benchmark Suite
>        =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
>        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>        =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
>        =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
>        =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9C=85 kdump - kexec_boot
>=20
>     Host 3:
>        =E2=9C=85 Boot test
>        =F0=9F=9A=A7 =E2=9C=85 kdump - sysrq-c
>        =F0=9F=9A=A7 =E2=9C=85 kdump - file-load
>=20
>   Test sources: https://gitlab.com/cki-project/kernel-tests
>     =F0=9F=92=9A Pull requests are welcome for new tests or improvements =
to existing
>     tests!
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
> finished running yet are marked with =E2=8F=B1.
>=20
>=20

