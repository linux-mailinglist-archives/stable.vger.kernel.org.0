Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A082D286845
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 21:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgJGT0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 15:26:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbgJGT0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 15:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602098799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xn3bIXtgi4Lsxx98Qfs4Mh9tdzmJ0JeMsxLYiIT6DhA=;
        b=cxhjnZNKQkjK7/H2vM27A4NQfy+8ySdM9o4e9y7JK2FnH7/pftT/CclGgVx8U6ApGvzprA
        m7PGRNDoWO8GTt4B82bRX/vWhpuA++PJen1uT+BcepRz2wi/zgJV0hcS2C/1tS5c+QW1wW
        E7Ne2yTArA3qFr03OxH+NbMVGsFVmO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-1teho4nrOEqP0_eoBcUC5Q-1; Wed, 07 Oct 2020 15:26:37 -0400
X-MC-Unique: 1teho4nrOEqP0_eoBcUC5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACDBC10866A8
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 19:26:36 +0000 (UTC)
Received: from [172.20.6.42] (unknown [10.0.115.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26F5F19D7C;
        Wed,  7 Oct 2020 19:26:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.8.14 (stable-queue)
Date:   Wed, 07 Oct 2020 19:26:30 -0000
CC:     Yi Zhang <yi.zhang@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Message-ID: <cki.906B1313E7.5MNLRQA784@redhat.com>
X-Gitlab-Pipeline-ID: 614861
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com/
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/614861
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/li=
nux-stable-rc.git
            Commit: b7035e2fc589 - Revert "ravb: Fixed to be able to unload m=
odules"

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefi=
x=3Ddatawarehouse-public/2020/10/07/614861

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
       =E2=9C=85 Boot test
       =E2=9C=85 ACPI table test
       =E2=9C=85 ACPI enabled test
       =E2=9C=85 Podman system integration test - as root
       =E2=9C=85 Podman system integration test - as user
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking: igmp conformance test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
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
       =E2=9C=85 storage: SCSI VPD
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 Firmware test suite
       =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
       =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 kdump - kexec_boot

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests - ext4
       =E2=9C=85 xfstests - xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9D=8C IPMI driver test
       =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests
       =F0=9F=9A=A7 =E2=9C=85 Storage nvme - tcp

  ppc64le:
    Host 1:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 kdump - sysrq-c

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test - as root
       =E2=9C=85 Podman system integration test - as user
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =E2=9C=85 pciutils: update pci ids test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
       =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer

    Host 3:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests - ext4
       =E2=9C=85 xfstests - xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
       =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests
       =F0=9F=9A=A7 =E2=9C=85 Storage nvme - tcp

  s390x:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests
       =F0=9F=9A=A7 =E2=9D=8C Storage nvme - tcp

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test - as root
       =E2=9C=85 Podman system integration test - as user
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - transport
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
       =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 ACPI table test
       =E2=9C=85 Podman system integration test - as root
       =E2=9C=85 Podman system integration test - as user
       =E2=9C=85 LTP
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 Memory: fork_mem
       =E2=9C=85 Memory function: memfd_create
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking: igmp conformance test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func - local
       =E2=9C=85 Networking route_func - forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: geneve basic test
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 L2TP basic test
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 Networking ipsec: basic netns - transport
       =E2=9C=85 Networking ipsec: basic netns - tunnel
       =E2=9C=85 Libkcapi AF_ALG test
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 pciutils: update pci ids test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 storage: SCSI VPD
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 Firmware test suite
       =F0=9F=9A=A7 =E2=9C=85 jvm - jcstress tests
       =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
       =F0=9F=9A=A7 =E2=9C=85 Ethernet drivers sanity
       =F0=9F=9A=A7 =E2=9C=85 Networking firewall: basic netfilter test
       =F0=9F=9A=A7 =E2=9C=85 audit: audit testsuite test
       =F0=9F=9A=A7 =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 kdump - kexec_boot

    Host 2:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests (=
marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =E2=9C=85 xfstests - ext4
       =E2=9C=85 xfstests - xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 storage: software RAID testing
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9D=8C CPU: Frequency Driver Test
       =F0=9F=9A=A7 =E2=9C=85 CPU: Idle Test
       =F0=9F=9A=A7 =E2=9C=85 xfstests - btrfs
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IOMMU boot test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sa=
nity test
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp

    Host 3:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 kdump - sysrq-c
       =F0=9F=9A=A7 =E2=9C=85 kdump - file-load

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

