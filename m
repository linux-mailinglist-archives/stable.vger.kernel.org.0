Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DBF31AFFE
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhBNKGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 05:06:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhBNKGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 05:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613297087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cktMT3FvM8cVk9B2mXVNSTFC8wwWd9oeh+w+2V/obV8=;
        b=GoIklA3b9tjSWbaVwt87kK9qVFcFkEyBDkwA2aZpMuCTxYNMrkLBG32egF+19NEiUFxliG
        GoJOgYAsJpo1aJbcAXMD1/xukYijf/yC0lxbK/L2CmNuhoQj02FvQA0ZyJbMdhWsgXbhmR
        Y8lMRydgYs02HliRzXNISbawddll19w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-3sVr22fwPxub-6xwfillvA-1; Sun, 14 Feb 2021 05:04:45 -0500
X-MC-Unique: 3sVr22fwPxub-6xwfillvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B86D804023
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 10:04:44 +0000 (UTC)
Received: from [172.23.0.135] (unknown [10.0.115.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49B955D9DB;
        Sun, 14 Feb 2021 10:04:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.10.16 (stable-queue)
Date:   Sun, 14 Feb 2021 10:04:41 -0000
Message-ID: <cki.CAB17CF7F2.UXBQSYR3SO@redhat.com>
X-Gitlab-Pipeline-ID: 623986
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com/
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/623986
X-DataWarehouse-Revision-IID: 10093
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: ac3c05f5f0a2 - objtool: Fix seg fault with Clang non-sect=
ion symbols

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2021/02/13/623986

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
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg



Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=8F=B1  Boot test
       =E2=8F=B1  ACPI table test
       =E2=8F=B1  ACPI enabled test
       =E2=8F=B1  LTP
       =E2=8F=B1  Loopdev Sanity
       =E2=8F=B1  Memory: fork_mem
       =E2=8F=B1  Memory function: memfd_create
       =E2=8F=B1  AMTU (Abstract Machine Test Utility)
       =E2=8F=B1  Networking bridge: sanity
       =E2=8F=B1  Networking socket: fuzz
       =E2=8F=B1  Networking: igmp conformance test
       =E2=8F=B1  Networking route: pmtu
       =E2=8F=B1  Networking route_func - local
       =E2=8F=B1  Networking route_func - forward
       =E2=8F=B1  Networking TCP: keepalive test
       =E2=8F=B1  Networking UDP: socket
       =E2=8F=B1  Networking tunnel: geneve basic test
       =E2=8F=B1  Networking tunnel: gre basic
       =E2=8F=B1  L2TP basic test
       =E2=8F=B1  Networking tunnel: vxlan basic
       =E2=8F=B1  Networking ipsec: basic netns - transport
       =E2=8F=B1  Networking ipsec: basic netns - tunnel
       =E2=8F=B1  Libkcapi AF_ALG test
       =E2=8F=B1  pciutils: update pci ids test
       =E2=8F=B1  ALSA PCM loopback test
       =E2=8F=B1  ALSA Control (mixer) Userspace Element test
       =E2=8F=B1  storage: SCSI VPD
       =E2=8F=B1  CIFS Connectathon
       =E2=8F=B1  POSIX pjd-fstest suites
       =E2=8F=B1  Firmware test suite
       =E2=8F=B1  jvm - jcstress tests
       =E2=8F=B1  Memory function: kaslr
       =E2=8F=B1  Ethernet drivers sanity
       =E2=8F=B1  Networking firewall: basic netfilter test
       =E2=8F=B1  audit: audit testsuite test
       =E2=8F=B1  trace: ftrace/tracer

    Host 2:
       =E2=8F=B1  Boot test
       =E2=8F=B1  selinux-policy: serge-testsuite
       =E2=8F=B1  storage: software RAID testing
       =E2=8F=B1  xfstests - ext4
       =E2=8F=B1  xfstests - xfs
       =E2=8F=B1  xfstests - btrfs
       =E2=8F=B1  IPMI driver test
       =E2=8F=B1  IPMItool loop stress test
       =E2=8F=B1  Storage blktests
       =E2=8F=B1  Storage block - filesystem fio test
       =E2=8F=B1  Storage block - queue scheduler test
       =E2=8F=B1  Storage nvme - tcp
       =E2=8F=B1  Storage: swraid mdadm raid_module test
       =E2=8F=B1  stress: stress-ng

  ppc64le:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Loopdev Sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory: fork_mem
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: memfd_create
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking bridge: sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func - forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking TCP: keepalive test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking UDP: socket
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: geneve basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: gre basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 L2TP basic test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking tunnel: vxlan basic
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking ipsec: basic netns - tunnel
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Libkcapi AF_ALG test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 pciutils: update pci ids test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA PCM loopback test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 ALSA Control (mixer) Userspace Element test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking firewall: basic ne=
tfilter test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 trace: ftrace/tracer

    Host 2:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fi=
o test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedul=
er test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mo=
dule test

    Host 3:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fi=
o test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedul=
er test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mo=
dule test

    Host 4:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fi=
o test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue schedul=
er test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_mo=
dule test

  s390x:
    Host 1:
       =E2=8F=B1  Boot test
       =E2=8F=B1  LTP
       =E2=8F=B1  Loopdev Sanity
       =E2=8F=B1  Memory: fork_mem
       =E2=8F=B1  Memory function: memfd_create
       =E2=8F=B1  AMTU (Abstract Machine Test Utility)
       =E2=8F=B1  Networking bridge: sanity
       =E2=8F=B1  Networking route: pmtu
       =E2=8F=B1  Networking route_func - local
       =E2=8F=B1  Networking route_func - forward
       =E2=8F=B1  Networking TCP: keepalive test
       =E2=8F=B1  Networking UDP: socket
       =E2=8F=B1  Networking tunnel: geneve basic test
       =E2=8F=B1  Networking tunnel: gre basic
       =E2=8F=B1  L2TP basic test
       =E2=8F=B1  Networking tunnel: vxlan basic
       =E2=8F=B1  Networking ipsec: basic netns - transport
       =E2=8F=B1  Networking ipsec: basic netns - tunnel
       =E2=8F=B1  Libkcapi AF_ALG test
       =E2=8F=B1  CIFS Connectathon
       =E2=8F=B1  POSIX pjd-fstest suites
       =E2=8F=B1  jvm - jcstress tests
       =E2=8F=B1  Memory function: kaslr
       =E2=8F=B1  Ethernet drivers sanity
       =E2=8F=B1  Networking firewall: basic netfilter test
       =E2=8F=B1  audit: audit testsuite test
       =E2=8F=B1  trace: ftrace/tracer

    Host 2:
       =E2=8F=B1  Boot test
       =E2=8F=B1  selinux-policy: serge-testsuite
       =E2=8F=B1  Storage blktests
       =E2=8F=B1  Storage nvme - tcp
       =E2=8F=B1  Storage: swraid mdadm raid_module test
       =E2=8F=B1  stress: stress-ng

  x86_64:
    Host 1:
       =E2=8F=B1  Boot test
       =E2=8F=B1  selinux-policy: serge-testsuite
       =E2=8F=B1  storage: software RAID testing
       =E2=8F=B1  CPU: Frequency Driver Test
       =E2=8F=B1  CPU: Idle Test
       =E2=8F=B1  xfstests - ext4
       =E2=8F=B1  xfstests - xfs
       =E2=8F=B1  xfstests - btrfs
       =E2=8F=B1  xfstests - nfsv4.2
       =E2=8F=B1  xfstests - cifsv3.11
       =E2=8F=B1  IPMI driver test
       =E2=8F=B1  IPMItool loop stress test
       =E2=8F=B1  power-management: cpupower/sanity test
       =E2=8F=B1  Storage blktests
       =E2=8F=B1  Storage block - filesystem fio test
       =E2=8F=B1  Storage block - queue scheduler test
       =E2=8F=B1  Storage nvme - tcp
       =E2=8F=B1  Storage: swraid mdadm raid_module test
       =E2=8F=B1  stress: stress-ng

    Host 2:
       =E2=8F=B1  Boot test
       =E2=8F=B1  ACPI table test
       =E2=8F=B1  LTP
       =E2=8F=B1  Loopdev Sanity
       =E2=8F=B1  Memory: fork_mem
       =E2=8F=B1  Memory function: memfd_create
       =E2=8F=B1  AMTU (Abstract Machine Test Utility)
       =E2=8F=B1  Networking bridge: sanity
       =E2=8F=B1  Networking socket: fuzz
       =E2=8F=B1  Networking: igmp conformance test
       =E2=8F=B1  Networking route: pmtu
       =E2=8F=B1  Networking route_func - local
       =E2=8F=B1  Networking route_func - forward
       =E2=8F=B1  Networking TCP: keepalive test
       =E2=8F=B1  Networking UDP: socket
       =E2=8F=B1  Networking tunnel: geneve basic test
       =E2=8F=B1  Networking tunnel: gre basic
       =E2=8F=B1  L2TP basic test
       =E2=8F=B1  Networking tunnel: vxlan basic
       =E2=8F=B1  Networking ipsec: basic netns - transport
       =E2=8F=B1  Networking ipsec: basic netns - tunnel
       =E2=8F=B1  Libkcapi AF_ALG test
       =E2=8F=B1  pciutils: sanity smoke test
       =E2=8F=B1  pciutils: update pci ids test
       =E2=8F=B1  ALSA PCM loopback test
       =E2=8F=B1  ALSA Control (mixer) Userspace Element test
       =E2=8F=B1  storage: SCSI VPD
       =E2=8F=B1  CIFS Connectathon
       =E2=8F=B1  POSIX pjd-fstest suites
       =E2=8F=B1  Firmware test suite
       =E2=8F=B1  jvm - jcstress tests
       =E2=8F=B1  Memory function: kaslr
       =E2=8F=B1  Ethernet drivers sanity
       =E2=8F=B1  Networking firewall: basic netfilter test
       =E2=8F=B1  audit: audit testsuite test
       =E2=8F=B1  trace: ftrace/tracer

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

