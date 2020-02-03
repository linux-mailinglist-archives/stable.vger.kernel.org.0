Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7406B150A3E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgBCPuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:50:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726561AbgBCPuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 10:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580745001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBEOMl1KNZiMzpqY8rQzstn4asSn7q1VtYxXTJiNTd0=;
        b=S5Cim0qH720c8uTACao0jodyekSainFWyTK5RezEr13kBXfoTIr228rcAjAr4Nnrs5lsPq
        iyUZGmetIQfNhopf+el5CEscbC17a78lPr1nxcdiSvU8HKICwYRCkN5Qjn3Y7LobY2RnAA
        FNTt7hyUrw5dQz09zfrH9XgzZrtkRMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-Sw0d5s0JPteOkxnTuJUxHQ-1; Mon, 03 Feb 2020 10:49:57 -0500
X-MC-Unique: Sw0d5s0JPteOkxnTuJUxHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ADD910CE78C;
        Mon,  3 Feb 2020 15:49:55 +0000 (UTC)
Received: from redhat.com (unknown [10.19.186.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E4490F62;
        Mon,  3 Feb 2020 15:49:51 +0000 (UTC)
Date:   Mon, 3 Feb 2020 10:49:49 -0500
From:   Don Zickus <dzickus@redhat.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.5.0-b3e3082.cki (stable-next)
Message-ID: <20200203154949.hpvsvnxip4oemppp@redhat.com>
References: <cki.23F8456381.YW5PMKDN0H@redhat.com>
 <1764516057.4804858.1580730812581.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1764516057.4804858.1580730812581.JavaMail.zimbra@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

adding some bnx2x folks who might be able to help?

On Mon, Feb 03, 2020 at 06:53:32AM -0500, Veronika Kabatova wrote:
>=20
>=20
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Sent: Monday, February 3, 2020 9:06:21 AM
> > Subject: =E2=9D=8C FAIL: Test report for kernel 5.5.0-b3e3082.cki (st=
able-next)
> >=20
> >=20
> > Hello,
> >=20
> > We ran automated tests on a recent commit from this kernel tree:
> >=20
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-sta=
ble.git
> >             Commit: b3e3082be48b - ARM: dma-api: fix max_pfn off-by-o=
ne error
> >             in __dma_supported()
> >=20
> > The results of these automated tests are provided below.
> >=20
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >=20
> > All kernel binaries, config files, and logs are available for downloa=
d here:
> >=20
> >   https://artifacts.cki-project.org/pipelines/417813
> >=20
> > One or more kernel tests failed:
> >=20
> >     ppc64le:
> >      =E2=9D=8C Boot test
> >=20
>=20
> [   40.416312] bnx2x 0045:01:00.0: Direct firmware load for bnx2x/bnx2x=
-e2-7.13.15.0.fw failed with error -2=20
> [   40.416339] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f0)]Can't loa=
d firmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
> [   40.416349] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f0)]Error loadi=
ng firmware=20
> [   40.416362] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f0)]HW init failed,=
 aborting=20
> [   40.556594] bnx2x 0045:01:00.1: Direct firmware load for bnx2x/bnx2x=
-e2-7.13.15.0.fw failed with error -2=20
> [   40.556621] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f1)]Can't loa=
d firmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
> [   40.556631] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f1)]Error loadi=
ng firmware=20
> [   40.556646] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f1)]HW init failed,=
 aborting=20
> [   40.706538] bnx2x 0045:01:00.2: Direct firmware load for bnx2x/bnx2x=
-e2-7.13.15.0.fw failed with error -2=20
> [   40.706563] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f2)]Can't loa=
d firmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
> [   40.706572] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f2)]Error loadi=
ng firmware=20
> [   40.706587] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f2)]HW init failed,=
 aborting=20
> [   40.836616] bnx2x 0045:01:00.3: Direct firmware load for bnx2x/bnx2x=
-e2-7.13.15.0.fw failed with error -2=20
> [   40.836638] bnx2x: [bnx2x_init_firmware:13556(enP69p1s0f3)]Can't loa=
d firmware file bnx2x/bnx2x-e2-7.13.15.0.fw=20
> [   40.836645] bnx2x: [bnx2x_func_hw_init:6002(enP69p1s0f3)]Error loadi=
ng firmware=20
> [   40.836657] bnx2x: [bnx2x_nic_load:2731(enP69p1s0f3)]HW init failed,=
 aborting=20
>=20
> The recipe aborted later due to networking issues, which might be cause=
d by
> the messages above.
>=20
> The messages are not present with kernel-5.4.8-200.fc31.ppc64le which m=
akes
> me wonder if something related changed in the kernel, whether it's a pl=
anned
> change we need to account for or actual breakage? The other ppc64le mac=
hine
> we ran on didn't use bnx2x.
>=20
>=20
> Veronika
>=20
> > We hope that these logs can help you find the problem quickly. For th=
e full
> > detail on our testing procedures, please scroll to the bottom of this
> > message.
> >=20
> > Please reply to this email if you have any questions about the tests =
that we
> > ran or if you have any suggestions on how to make future tests more
> > effective.
> >=20
> >         ,-.   ,-.
> >        ( C ) ( K )  Continuous
> >         `-',-.`-'   Kernel
> >           ( I )     Integration
> >            `-'
> > _____________________________________________________________________=
_________
> >=20
> > Compile testing
> > ---------------
> >=20
> > We compiled the kernel for 3 architectures:
> >=20
> >     aarch64:
> >       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >     ppc64le:
> >       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >     x86_64:
> >       make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >=20
> > Hardware testing
> > ----------------
> > We booted each kernel and ran the following tests:
> >=20
> >   aarch64:
> >     Host 1:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 xfstests: ext4
> >        =E2=9C=85 xfstests: xfs
> >        =E2=9C=85 selinux-policy: serge-testsuite
> >        =E2=9C=85 lvm thinp sanity
> >        =E2=9C=85 storage: software RAID testing
> >        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
> >=20
> >     Host 2:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 Podman system integration test (as root)
> >        =E2=9C=85 Podman system integration test (as user)
> >        =E2=9C=85 LTP
> >        =E2=9C=85 Loopdev Sanity
> >        =E2=9C=85 Memory function: memfd_create
> >        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >        =E2=9C=85 Networking bridge: sanity
> >        =E2=9C=85 Ethernet drivers sanity
> >        =E2=9C=85 Networking MACsec: sanity
> >        =E2=9C=85 Networking socket: fuzz
> >        =E2=9C=85 Networking sctp-auth: sockopts test
> >        =E2=9C=85 Networking: igmp conformance test
> >        =E2=9C=85 Networking route: pmtu
> >        =E2=9C=85 Networking route_func: local
> >        =E2=9C=85 Networking route_func: forward
> >        =E2=9C=85 Networking TCP: keepalive test
> >        =E2=9C=85 Networking UDP: socket
> >        =E2=9C=85 Networking tunnel: geneve basic test
> >        =E2=9C=85 Networking tunnel: gre basic
> >        =E2=9C=85 L2TP basic test
> >        =E2=9C=85 Networking tunnel: vxlan basic
> >        =E2=9C=85 Networking ipsec: basic netns transport
> >        =E2=9C=85 Networking ipsec: basic netns tunnel
> >        =E2=9C=85 audit: audit testsuite test
> >        =E2=9C=85 httpd: mod_ssl smoke sanity
> >        =E2=9C=85 tuned: tune-processes-through-perf
> >        =E2=9C=85 ALSA PCM loopback test
> >        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >        =E2=9C=85 storage: SCSI VPD
> >        =E2=9C=85 trace: ftrace/tracer
> >        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
> >        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
> >        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
> >        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >=20
> >   ppc64le:
> >     Host 1:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 Podman system integration test (as root)
> >        =E2=9C=85 Podman system integration test (as user)
> >        =E2=9C=85 LTP
> >        =E2=9C=85 Loopdev Sanity
> >        =E2=9C=85 Memory function: memfd_create
> >        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >        =E2=9C=85 Networking bridge: sanity
> >        =E2=9C=85 Ethernet drivers sanity
> >        =E2=9C=85 Networking MACsec: sanity
> >        =E2=9C=85 Networking socket: fuzz
> >        =E2=9C=85 Networking sctp-auth: sockopts test
> >        =E2=9C=85 Networking route: pmtu
> >        =E2=9C=85 Networking route_func: local
> >        =E2=9C=85 Networking route_func: forward
> >        =E2=9C=85 Networking TCP: keepalive test
> >        =E2=9C=85 Networking UDP: socket
> >        =E2=9C=85 Networking tunnel: geneve basic test
> >        =E2=9C=85 Networking tunnel: gre basic
> >        =E2=9C=85 L2TP basic test
> >        =E2=9C=85 Networking tunnel: vxlan basic
> >        =E2=9C=85 Networking ipsec: basic netns tunnel
> >        =E2=9C=85 audit: audit testsuite test
> >        =E2=9C=85 httpd: mod_ssl smoke sanity
> >        =E2=9C=85 tuned: tune-processes-through-perf
> >        =E2=9C=85 ALSA PCM loopback test
> >        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >        =E2=9C=85 trace: ftrace/tracer
> >        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
> >        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
> >        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
> >        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >=20
> >     Host 2:
> >        =E2=9D=8C Boot test
> >        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
> >        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
> >        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
> >        =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
> >        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
> >        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> >        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress =
test
> >        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> >=20
> >   x86_64:
> >     Host 1:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 Storage SAN device stress - mpt3sas driver
> >=20
> >     Host 2:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 Podman system integration test (as root)
> >        =E2=9C=85 Podman system integration test (as user)
> >        =E2=9C=85 LTP
> >        =E2=9C=85 Loopdev Sanity
> >        =E2=9C=85 Memory function: memfd_create
> >        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >        =E2=9C=85 Networking bridge: sanity
> >        =E2=9C=85 Ethernet drivers sanity
> >        =E2=9C=85 Networking MACsec: sanity
> >        =E2=9C=85 Networking socket: fuzz
> >        =E2=9C=85 Networking sctp-auth: sockopts test
> >        =E2=9C=85 Networking: igmp conformance test
> >        =E2=9C=85 Networking route: pmtu
> >        =E2=9C=85 Networking route_func: local
> >        =E2=9C=85 Networking route_func: forward
> >        =E2=9C=85 Networking TCP: keepalive test
> >        =E2=9C=85 Networking UDP: socket
> >        =E2=9C=85 Networking tunnel: geneve basic test
> >        =E2=9C=85 Networking tunnel: gre basic
> >        =E2=9C=85 L2TP basic test
> >        =E2=9C=85 Networking tunnel: vxlan basic
> >        =E2=9C=85 Networking ipsec: basic netns transport
> >        =E2=9C=85 Networking ipsec: basic netns tunnel
> >        =E2=9C=85 audit: audit testsuite test
> >        =E2=9C=85 httpd: mod_ssl smoke sanity
> >        =E2=9C=85 tuned: tune-processes-through-perf
> >        =E2=9C=85 pciutils: sanity smoke test
> >        =E2=9C=85 ALSA PCM loopback test
> >        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >        =E2=9C=85 storage: SCSI VPD
> >        =E2=9C=85 trace: ftrace/tracer
> >        =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >        =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >        =F0=9F=9A=A7 =E2=9C=85 jvm test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
> >        =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
> >        =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >        =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
> >        =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
> >        =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >=20
> >     Host 3:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 Storage SAN device stress - megaraid_sas
> >=20
> >     Host 4:
> >        =E2=9C=85 Boot test
> >        =E2=9C=85 xfstests: ext4
> >        =E2=9C=85 xfstests: xfs
> >        =E2=9C=85 selinux-policy: serge-testsuite
> >        =E2=9C=85 lvm thinp sanity
> >        =E2=9C=85 storage: software RAID testing
> >        =E2=9C=85 stress: stress-ng
> >        =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
> >        =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
> >        =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
> >        =F0=9F=9A=A7 =E2=9C=85 Storage blktests
> >=20
> >   Test sources: https://github.com/CKI-project/tests-beaker
> >     =F0=9F=92=9A Pull requests are welcome for new tests or improveme=
nts to existing
> >     tests!
> >=20
> > Waived tests
> > ------------
> > If the test run included waived tests, they are marked with =F0=9F=9A=
=A7. Such tests
> > are
> > executed but their results are not taken into account. Tests are waiv=
ed when
> > their results are not reliable enough, e.g. when they're just introdu=
ced or
> > are
> > being fixed.
> >=20
> > Testing timeout
> > ---------------
> > We aim to provide a report within reasonable timeframe. Tests that ha=
ven't
> > finished running are marked with =E2=8F=B1. Reports for non-upstream =
kernels have
> > a Beaker recipe linked to next to each host.
> >=20
> >=20
>=20

