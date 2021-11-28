Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580974602FD
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 03:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhK1C2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 21:28:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhK1C0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 21:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638066194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9BXFrxivckDnfB0gtg06MW+RoZT0HVymUGCrdCJGArQ=;
        b=jL+XxDsisi48DOqkCjkpFirq1PupcRSVTSIW5qzjfbaTc5Da+1/TUycQPWjXN9tf4Ye8S4
        TWZSuj/VtFRz8Twpiuvt1zPuGc7d9cBLbPw0ocTlYisnwk0kvKGsuGGb9ZwcIV3+Bm0Xmh
        RQmWZBpuomLfm1ILbUHd7wwjk2wybnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-8glRr3ZCMDa0XDTjnqaL3g-1; Sat, 27 Nov 2021 21:23:13 -0500
X-MC-Unique: 8glRr3ZCMDa0XDTjnqaL3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FEBD801B10
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 02:23:12 +0000 (UTC)
Received: from [172.64.11.35] (unknown [10.30.34.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55F7419C79;
        Sun, 28 Nov 2021 02:23:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     skt-results-master@redhat.com,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.15.5 (stable-queue,
 02ffbb81)
Date:   Sun, 28 Nov 2021 02:23:02 -0000
CC:     Yi Zhang <yizhan@redhat.com>
Message-ID: <cki.SQH2UVZXKRJM97D5FT70@redhat.com>
X-Gitlab-Pipeline-ID: 417560653
X-Gitlab-Url: https://gitlab.com
X-Gitlab-Path: =?utf-8?q?/redhat/red-hat-ci-tools/kernel/cki-internal-pipeli?=
 =?utf-8?q?nes/cki-trusted-contributors/pipelines/417560653?=
X-DataWarehouse-Checkout-IID: 25520
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Check out this report and any autotriaged failures in our web dashboard:
    https://datawarehouse.cki-project.org/kcidb/checkouts/25520

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: 02ffbb81ddeb - scsi: sd: Fix sd_do_mode_sense() buffer le=
ngth handling

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK
    Targeted tests: NO

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2021/11/27/417560653

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: make -j24 INSTALL_MOD_STRIP=3D1 targz-pkg



Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 ACPI table test
       =E2=9C=85 ACPI enabled test
       =E2=9C=85 LTP - cve
       =E2=9C=85 LTP - sched
       =E2=9C=85 LTP - syscalls
       =E2=9C=85 LTP - can
       =E2=9C=85 LTP - commands
       =E2=9C=85 LTP - containers
       =E2=9C=85 LTP - dio
       =E2=9C=85 LTP - fs
       =E2=9C=85 LTP - fsx
       =E2=9C=85 LTP - math
       =E2=9C=85 LTP - hugetlb
       =E2=9C=85 LTP - mm
       =E2=9C=85 LTP - nptl
       =E2=9C=85 LTP - pty
       =E2=9C=85 LTP - ipc
       =E2=9C=85 LTP - tracing
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 CIFS Connectathon
       =E2=9C=85 POSIX pjd-fstest suites
       =E2=9C=85 NFS Connectathon
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm - jcstress tests
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking cki netfilter test
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - transport
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =E2=9C=85 pciutils: update pci ids test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 storage: dm/common
       =E2=9C=85 lvm snapper test
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 xarray-idr-radixtree-test
       =F0=9F=9A=A7 =E2=9C=85 i2c: i2cdetect sanity
       =F0=9F=9A=A7 =E2=9C=85 Firmware test suite
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 Networking: igmp conformance test
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 Networking bridge: sanity - mlx5
       =E2=9C=85 Ethernet drivers sanity - mlx5

    Host 3:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvmeof-mp

    Host 4:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Reboot test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - srp

    Host 5:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - blk
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - interrupt
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu-cache
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as root
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as user
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm cache test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - os

    Host 6:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9D=8C Storage blktests - srp

    Host 7:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 xfstests - ext4
       =E2=9C=85 xfstests - xfs
       =E2=9C=85 IPMI driver test
       =E2=9C=85 IPMItool loop stress test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 Storage blktests - blk
       =E2=9C=85 Storage block - filesystem fio test
       =E2=9C=85 Storage block - queue scheduler test
       =E2=9C=85 storage: software RAID testing
       =E2=9C=85 Storage: swraid mdadm raid_module test
       =E2=9C=85 stress: stress-ng - interrupt
       =E2=9C=85 stress: stress-ng - cpu
       =E2=9C=85 stress: stress-ng - cpu-cache
       =E2=9C=85 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as root
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as user
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9C=85 lvm cache test
       =F0=9F=9A=A7 =E2=9C=85 stress: stress-ng - os

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 xfstests - ext4
       =E2=9C=85 xfstests - xfs
       =E2=9C=85 IPMI driver test
       =E2=9C=85 IPMItool loop stress test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 Storage blktests - blk
       =E2=9C=85 Storage block - filesystem fio test
       =E2=9C=85 Storage block - queue scheduler test
       =E2=9C=85 storage: software RAID testing
       =E2=9C=85 Storage: swraid mdadm raid_module test
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as root
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as user
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9C=85 Storage: lvm device-mapper test - upstream
       =F0=9F=9A=A7 =E2=9C=85 lvm cache test

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - srp

    Host 3:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9D=8C Storage blktests - nvmeof-mp

    Host 4:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 LTP - cve
       =E2=9C=85 LTP - sched
       =E2=9C=85 LTP - syscalls
       =E2=9C=85 LTP - can
       =E2=9C=85 LTP - commands
       =E2=9C=85 LTP - containers
       =E2=9C=85 LTP - dio
       =E2=9C=85 LTP - fs
       =E2=9C=85 LTP - fsx
       =E2=9C=85 LTP - math
       =E2=9C=85 LTP - hugetlb
       =E2=9C=85 LTP - mm
       =E2=9C=85 LTP - nptl
       =E2=9C=85 LTP - pty
       =E2=9C=85 LTP - ipc
       =E2=9C=85 LTP - tracing
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 CIFS Connectathon
       =E2=9C=85 POSIX pjd-fstest suites
       =E2=9C=85 NFS Connectathon
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm - jcstress tests
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking cki netfilter test
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =E2=9C=85 pciutils: update pci ids test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 storage: dm/common
       =E2=9C=85 lvm snapper test
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 xarray-idr-radixtree-test
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test

  s390x:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 Storage blktests - blk
       =E2=9C=85 Storage: swraid mdadm raid_module test
       =E2=9C=85 stress: stress-ng - interrupt
       =E2=9C=85 stress: stress-ng - cpu
       =E2=9C=85 stress: stress-ng - cpu-cache
       =E2=9C=85 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as root
       =F0=9F=9A=A7 =E2=9C=85 Podman system test - as user
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9C=85 lvm cache test
       =F0=9F=9A=A7 =E2=9C=85 stress: stress-ng - os

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvmeof-mp

    Host 3:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - srp

    Host 4:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 LTP - cve
       =E2=9C=85 LTP - sched
       =E2=9C=85 LTP - syscalls
       =E2=9C=85 LTP - can
       =E2=9C=85 LTP - commands
       =E2=9C=85 LTP - containers
       =E2=9C=85 LTP - dio
       =E2=9C=85 LTP - fs
       =E2=9C=85 LTP - fsx
       =E2=9C=85 LTP - math
       =E2=9C=85 LTP - hugetlb
       =E2=9C=85 LTP - mm
       =E2=9C=85 LTP - nptl
       =E2=9C=85 LTP - pty
       =E2=9C=85 LTP - ipc
       =E2=9C=85 LTP - tracing
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 CIFS Connectathon
       =E2=9C=85 POSIX pjd-fstest suites
       =E2=9C=85 NFS Connectathon
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm - jcstress tests
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking cki netfilter test
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - transport
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =E2=9C=85 storage: dm/common
       =E2=9C=85 lvm snapper test
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 xarray-idr-radixtree-test
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - srp

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests - nvmeof-mp

    Host 3:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Reboot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - nfsv4.2
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - cifsv3.11
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanity test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - blk
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - interrupt
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu-cache
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as root
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as user
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Idle Test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: lvm device-mapper te=
st - upstream
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm cache test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - os

    Host 4:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 Reboot test
       =E2=9C=85 ACPI table test
       =E2=9C=85 LTP - cve
       =E2=9C=85 LTP - sched
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - syscalls
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - can
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - commands
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - containers
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - dio
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - fs
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - fsx
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - math
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - hugetlb
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - mm
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - nptl
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - pty
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - ipc
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP - tracing
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 NFS Connectathon
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory: fork_mem
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking cki netfilter test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - transport
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: sanity smoke test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: update pci ids test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: dm/common
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm snapper test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xarray-idr-radixtree-test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 i2c: i2cdetect sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Firmware test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking: igmp conformance =
test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test

    Host 5:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Reboot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - nfsv4.2
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - cifsv3.11
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanity test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - blk
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - interrupt
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu-cache
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as root
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as user
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Idle Test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: lvm device-mapper te=
st - upstream
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm cache test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - os

    Host 6:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Reboot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - nfsv4.2
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - cifsv3.11
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanity test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - blk
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - interrupt
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - cpu-cache
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - memory
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as root
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system test - as user
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CPU: Idle Test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests - nvme-tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: lvm device-mapper te=
st - upstream
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 lvm cache test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng - os

  Test sources: https://gitlab.com/cki-project/kernel-tests
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to e=
xisting tests!

Aborted tests
-------------
Tests that didn't complete running successfully are marked with =E2=9A=A1=E2=
=9A=A1=E2=9A=A1.
If this was caused by an infrastructure issue, we try to mark that
explicitly in the report.

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. Suc=
h tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or a=
re
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running yet are marked with =E2=8F=B1.
Targeted tests
--------------
Test runs for patches always include a set of base tests, plus some
tests chosen based on the file paths modified by the patch. The latter
are called "targeted tests". If no targeted tests are run, that means
no patch-specific tests are available. Please, consider contributing a
targeted test for related patches to increase test coverage. See
https://docs.engineering.redhat.com/x/_wEZB for more details.

