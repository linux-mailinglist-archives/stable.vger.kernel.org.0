Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD38017478C
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 16:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgB2PCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 10:02:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbgB2PCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 10:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582988558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vpj8Y4lMF24AYhZ9kWAi9ql3QCJGdZ3LSHIUpseXPI=;
        b=XFpiM1RYe6FCnATVWVR7dhBjmHrUcpPiSbEWWq82QiJMgVpvBs2NGhoXsEk9DfXSrWt2R2
        SumvMBhasaNJj4ULk5IBXUTIzoMHUOySa/PrWjIRau7wlAiYj2t1MID790a2Qt1e5ri13Q
        jfqTfVjR7ZvCV5yFEmQq1JjJXDBASxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-U36CqK6VOcCHOcT06HHoKQ-1; Sat, 29 Feb 2020 10:02:29 -0500
X-MC-Unique: U36CqK6VOcCHOcT06HHoKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ADCB192296F
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 15:02:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-123-179.rdu2.redhat.com [10.10.123.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD889394;
        Sat, 29 Feb 2020 15:02:24 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e23?=
 =?UTF-8?Q?-bfe3046=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Milos Malik <mmalik@redhat.com>, Hangbin Liu <haliu@redhat.com>
References: <cki.D557417105.IEDVNU8MSC@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <e5e321d0-9775-aa94-4b9b-c9b9f2d63430@redhat.com>
Date:   Sat, 29 Feb 2020 10:02:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.D557417105.IEDVNU8MSC@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/29/20 8:26 AM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
>              Commit: bfe3046ecafd - Linux 5.4.23
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
datawarehouse/2020/02/28/462608
>=20
> One or more kernel tests failed:
>=20
>      ppc64le:
>       =E2=9D=8C selinux-policy: serge-testsuite
>=20
>      aarch64:
>       =E2=9D=8C selinux-policy: serge-testsuite
>=20
>      x86_64:
>       =E2=9D=8C selinux-policy: serge-testsuite

The selinux failures may be caused by this but I'll let Ondrej confirm:
https://www.spinics.net/lists/stable/msg369030.html

>       =E2=9D=8C Networking route_func - local

Test timeout due to our machine provisioner being over loaded, feel free =
to ignore.

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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 user
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility=
)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Elem=
ent test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
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
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>      Host 3:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=9C=85 Podman system integration test - as user
>         =E2=9C=85 LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Elem=
ent test
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
>      Host 4:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test - as root
>         =E2=8F=B1  Podman system integration test - as user
>         =E2=8F=B1  LTP
>         =E2=8F=B1  Loopdev Sanity
>         =E2=8F=B1  Memory function: memfd_create
>         =E2=8F=B1  AMTU (Abstract Machine Test Utility)
>         =E2=8F=B1  Networking bridge: sanity
>         =E2=8F=B1  Ethernet drivers sanity
>         =E2=8F=B1  Networking MACsec: sanity
>         =E2=8F=B1  Networking socket: fuzz
>         =E2=8F=B1  Networking sctp-auth: sockopts test
>         =E2=8F=B1  Networking: igmp conformance test
>         =E2=8F=B1  Networking route: pmtu
>         =E2=8F=B1  Networking route_func - local
>         =E2=8F=B1  Networking route_func - forward
>         =E2=8F=B1  Networking TCP: keepalive test
>         =E2=8F=B1  Networking UDP: socket
>         =E2=8F=B1  Networking tunnel: geneve basic test
>         =E2=8F=B1  Networking tunnel: gre basic
>         =E2=8F=B1  L2TP basic test
>         =E2=8F=B1  Networking tunnel: vxlan basic
>         =E2=8F=B1  Networking ipsec: basic netns - transport
>         =E2=8F=B1  Networking ipsec: basic netns - tunnel
>         =E2=8F=B1  audit: audit testsuite test
>         =E2=8F=B1  httpd: mod_ssl smoke sanity
>         =E2=8F=B1  tuned: tune-processes-through-perf
>         =E2=8F=B1  ALSA PCM loopback test
>         =E2=8F=B1  ALSA Control (mixer) Userspace Element test
>         =E2=8F=B1  storage: SCSI VPD
>         =E2=8F=B1  trace: ftrace/tracer
>         =E2=8F=B1  CIFS Connectathon
>         =E2=8F=B1  POSIX pjd-fstest suites
>         =E2=8F=B1  jvm - DaCapo Benchmark Suite
>         =E2=8F=B1  jvm - jcstress tests
>         =E2=8F=B1  Memory function: kaslr
>         =E2=8F=B1  LTP: openposix test suite
>         =E2=8F=B1  Networking vnic: ipvlan/basic
>         =E2=8F=B1  iotop: sanity
>         =E2=8F=B1  Usex - version 1.9-29
>         =E2=8F=B1  storage: dm/common
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
>         =E2=8F=B1  POSIX pjd-fstest suites
>         =E2=8F=B1  jvm - DaCapo Benchmark Suite
>         =E2=8F=B1  jvm - jcstress tests
>         =E2=8F=B1  Memory function: kaslr
>         =E2=8F=B1  LTP: openposix test suite
>         =E2=8F=B1  Networking vnic: ipvlan/basic
>         =E2=8F=B1  iotop: sanity
>         =E2=8F=B1  Usex - version 1.9-29
>         =E2=8F=B1  storage: dm/common
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>    x86_64:
>      Host 1:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests - ext4
>         =E2=9C=85 xfstests - xfs
>         =E2=9D=8C selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 root
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 user
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility=
)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Elem=
ent test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
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
>      Host 3:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - mpt3sas driver
>=20
>      Host 4:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Storage SAN device stress - megaraid_sas
>=20
>      Host 5:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 root
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test - as=
 user
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility=
)
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
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
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Elem=
ent test
>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
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
>      Host 6:
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
>         =E2=9D=8C Networking route_func - local
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

