Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59A10C8AD
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 13:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfK1M1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 07:27:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbfK1M1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 07:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574944057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvHrnvXOTK4SEjPj6Cq2Eul9reyW8fxK91ZFta7X8yk=;
        b=fmvUfoS8rpZT9bX6tp/F8J/869FR3hyaKKcig5EQdoDkCb4zcZuk5eMayG5cqLVjXkEPIV
        eVVKrOYXJ6XdzihNy85CzS8kO4UgVNIJ6N98TFGcibGQP93HWMBHjSKNQ8p+1rtKZFWNy3
        BvEMOUdyJ6ByIIDVHvHwRDa1txtgbA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-bhUHRIY1PD6cPF09O41Chg-1; Thu, 28 Nov 2019 07:27:36 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5151E8024E5
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 12:27:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 499AC60BE1
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 12:27:35 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3BA0A4BB5C;
        Thu, 28 Nov 2019 12:27:35 +0000 (UTC)
Date:   Thu, 28 Nov 2019 07:27:34 -0500 (EST)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     Major Hayden <major@redhat.com>,
        CKI Project <cki-project@redhat.com>
Message-ID: <2099848054.11571023.1574944054916.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.D4E107EACA.L0SITTRBRL@redhat.com>
References: <cki.D4E107EACA.L0SITTRBRL@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.3.13-015654b.cki_(stable-queue)?=
MIME-Version: 1.0
X-Originating-IP: [10.40.205.176, 10.4.195.16]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.13-015654b.cki (stable-queue)
Thread-Index: Dw4VqRfGK8ffjM1e18vsgETZECMmqA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: bhUHRIY1PD6cPF09O41Chg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Cc: "Major Hayden" <major@redhat.com>
> Sent: Thursday, November 28, 2019 11:11:26 AM
> Subject: =E2=9D=8C FAIL: Test report for kernel 5.3.13-015654b.cki (stabl=
e-queue)
>=20
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.=
git
>             Commit: 015654bdddc1 - media: mceusb: fix out of bounds read =
in
>             MCE receiver buffer
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
>   https://artifacts.cki-project.org/pipelines/311282
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C Boot test
>      =E2=9D=8C Boot test
>=20
>     aarch64:
>      =E2=9D=8C Podman system integration test (as root)
>      =E2=9D=8C Boot test
>=20
>     x86_64:
>      =E2=9D=8C Podman system integration test (as root)
>      =E2=9D=8C Boot test
>=20

Hi,

there have been multiple call traces during boots such as the one
below. You can find more information and full console logs in the
link in the summary above.


[   38.534343] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000070=20
[   38.536528] Mem abort info:=20
[   38.537188]   ESR =3D 0x96000004=20
[   38.537909]   Exception class =3D DABT (current EL), IL =3D 32 bits=20
[   38.539323]   SET =3D 0, FnV =3D 0=20
[   38.540077]   EA =3D 0, S1PTW =3D 0=20
[   38.540838] Data abort info:=20
[   38.541545]   ISV =3D 0, ISS =3D 0x00000004=20
[   38.542455]   CM =3D 0, WnR =3D 0=20
[   38.543152] user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000001b525b000=
=20
[   38.544753] [0000000000000070] pgd=3D0000000000000000=20
[   38.545957] Internal error: Oops: 96000004 [#1] SMP=20
[   38.547238] Modules linked in: sunrpc vfat fat crct10dif_ce virtio_net g=
hash_ce net_failover failover ip_tables xfs libcrc32c virtio_console virtio=
_blk qemu_fw_cfg virtio_mmio=20
[   38.552298] CPU: 2 PID: 635 Comm: kworker/u8:3 Not tainted 5.3.13-015654=
b.cki #1=20
[   38.554055] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20
[   38.555801] Workqueue: netns cleanup_net=20
[   38.556788] pstate: 60400005 (nZCv daif +PAN -UAO)=20
[   38.557985] pc : kernfs_find_ns+0x24/0x128=20
[   38.558987] lr : kernfs_find_and_get_ns+0x44/0x68=20
[   38.560168] sp : ffff0000102dba90=20
[   38.561003] x29: ffff0000102dba90 x28: 0000000000000000 =20
[   38.562531] x27: 00000000ffffffff x26: ffff5f51c319c000 =20
[   38.564281] x25: ffff5f51c27ee0c8 x24: ffff5f51c31b6473 =20
[   38.564283] x23: 0000000000000140 x22: 0000000000000000 =20
[   38.564285] x21: ffff5f51c290edc8 x20: 0000000000000000 =20
[[      3388..556548298164]]  x1r9e:s t0r0a0i0n0t0d00[0804040]0:0 00* *x 1I=
8n:s t0a0l0l0i0n0g0 0d0e0p0e0n0d0e0n6c i e
s[  =20
 38.564287] x17: 0000000000000000 x16: ffff5f51c245eef8 =20
[   38.564289] x15: 0000000000000000 x14: 0000000000000000 =20
[   38.573279] x13: ffffde0cbd92e310 x12: ffffde0cbc5784e8 =20
[   38.574606] x11: ffffde0cbc578490 x10: 0000000000000040 =20
[   38.575931] x9 : ffffde0cbd92e318 x8 : 0000000000210d00 =20
[   38.577237] x7 : 0000000000000008 x6 : ffffde0ca8874380 =20
[   38.578562] x5 : 54df216eecf59a86 x4 : ffff7f7832a21d20 =20
[   38.579877] x3 : 000000008020001c x2 : 0000000000000000 =20
[   38.581324] x1 : ffff5f51c290edc8 x0 : ffff5f51c1ca47cc =20
[   38.582655] Call trace:=20
[   38.583284]  kernfs_find_ns+0x24/0x128=20
[   38.584215]  kernfs_find_and_get_ns+0x44/0x68=20
[   38.585311]  sysfs_remove_group+0x38/0xa0=20
[   38.586315]  netdev_queue_update_kobjects+0xfc/0x1a0=20
[   38.587574]  netdev_unregister_kobject+0x64/0x90=20
[   38.588747]  rollback_registered_many+0x25c/0x540=20
[   38.589948]  unregister_netdevice_many.part.0+0x20/0x88=20
[   38.591296]  default_device_exit_batch+0x154/0x170=20
[   38.592541]  ops_exit_list.isra.0+0x6c/0x80=20
[   38.593632]  cleanup_net+0x290/0x3c0=20
[   38.594573]  process_one_work+0x1bc/0x3e8=20
[   38.595578]  worker_thread+0x54/0x440=20
[   38.596558]  kthread+0x104/0x130=20
[   38.597396]  ret_from_fork+0x10/0x18=20
[   38.598362] Code: aa0103f5 aa1e03e0 aa0203f6 d503201f (7940e260) =20



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
>        =E2=9D=8C Podman system integration test (as root)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns transpor=
t
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>     Host 2:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-tes=
tsuite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>   ppc64le:
>     Host 1:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-tes=
tsuite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>     Host 2:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as roo=
t)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>   x86_64:
>     Host 1:
>        =E2=8F=B1  Boot test
>        =E2=8F=B1  Storage SAN device stress - megaraid_sas
>=20
>     Host 2:
>        =E2=9C=85 Boot test
>        =E2=9D=8C Podman system integration test (as root)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as use=
r)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking MACsec: sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking sctp-auth: sockopts test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns transpor=
t
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns tunnel
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element=
 test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking vnic: ipvlan/b=
asic
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Usex - version 1.9-29
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
>=20
>     Host 3:
>        =E2=9D=8C Boot test
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: ext4
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests: xfs
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm thinp sanity
>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IOMMU boot test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-tes=
tsuite
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupowe=
r/sanity test
>        =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>     Host 4:
>        =E2=8F=B1  Boot test
>        =E2=8F=B1  Storage SAN device stress - mpt3sas driver
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

