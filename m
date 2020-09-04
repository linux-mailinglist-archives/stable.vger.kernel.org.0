Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4730225DD0A
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 17:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgIDPSp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Sep 2020 11:18:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47963 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729942AbgIDPSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 11:18:44 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-pNgKl4cxOk-sxmLnFQg0xQ-1; Fri, 04 Sep 2020 11:18:40 -0400
X-MC-Unique: pNgKl4cxOk-sxmLnFQg0xQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CA4018BFED4
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 15:18:39 +0000 (UTC)
Received: from [10.130.11.175] (unknown [10.0.117.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 836106FDB6;
        Fri,  4 Sep 2020 15:18:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.8.6-96b51cc.cki
 (stable-queue)
Date:   Fri, 04 Sep 2020 15:18:32 -0000
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.80B0510D48.EN6S50MUQG@redhat.com>
X-Gitlab-Pipeline-ID: 613308
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com/
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/613308
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 96b51cca34dd - KVM: arm64: Survive synchronous exceptions caused by AT instructions

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/09/04/613308

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
      make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg

    s390x:
      make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: make -j30 INSTALL_MOD_STRIP=1 targz-pkg



Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test
       ✅ ACPI table test
       ✅ ACPI enabled test
       ✅ Podman system integration test - as root
       ✅ Podman system integration test - as user
       ✅ LTP
       ✅ Loopdev Sanity
       ✅ Memory function: memfd_create
       ✅ AMTU (Abstract Machine Test Utility)
       ✅ Networking bridge: sanity
       ✅ Ethernet drivers sanity
       ✅ Networking socket: fuzz
       ✅ Networking: igmp conformance test
       ✅ Networking route: pmtu
       ✅ Networking route_func - local
       ✅ Networking route_func - forward
       ✅ Networking TCP: keepalive test
       ✅ Networking UDP: socket
       ✅ Networking tunnel: geneve basic test
       ✅ Networking tunnel: gre basic
       ✅ L2TP basic test
       ✅ Networking tunnel: vxlan basic
       ✅ Networking ipsec: basic netns - transport
       ✅ Networking ipsec: basic netns - tunnel
       ✅ Libkcapi AF_ALG test
       ✅ pciutils: update pci ids test
       ✅ ALSA PCM loopback test
       ✅ ALSA Control (mixer) Userspace Element test
       ✅ storage: SCSI VPD
       🚧 ✅ CIFS Connectathon
       🚧 ✅ POSIX pjd-fstest suites
       🚧 ✅ jvm - jcstress tests
       🚧 ✅ Memory function: kaslr
       🚧 ✅ Networking firewall: basic netfilter test
       🚧 ✅ audit: audit testsuite test
       🚧 ✅ trace: ftrace/tracer
       🚧 ✅ kdump - kexec_boot

    Host 2:
       ✅ Boot test
       ✅ xfstests - ext4
       ✅ xfstests - xfs
       ✅ selinux-policy: serge-testsuite
       ✅ storage: software RAID testing
       ✅ stress: stress-ng
       🚧 ✅ xfstests - btrfs
       🚧 ✅ IPMI driver test
       🚧 ✅ IPMItool loop stress test
       🚧 ✅ Storage blktests
       🚧 ✅ Storage nvme - tcp

  ppc64le:
    Host 1:
       ✅ Boot test
       ✅ xfstests - ext4
       ✅ xfstests - xfs
       ✅ selinux-policy: serge-testsuite
       ✅ storage: software RAID testing
       🚧 ✅ xfstests - btrfs
       🚧 ✅ IPMI driver test
       🚧 ✅ IPMItool loop stress test
       🚧 ✅ Storage blktests
       🚧 ✅ Storage nvme - tcp

    Host 2:
       ✅ Boot test
       ✅ Podman system integration test - as root
       ✅ Podman system integration test - as user
       ✅ LTP
       ✅ Loopdev Sanity
       ✅ Memory function: memfd_create
       ✅ AMTU (Abstract Machine Test Utility)
       ✅ Networking bridge: sanity
       ✅ Ethernet drivers sanity
       ✅ Networking socket: fuzz
       ✅ Networking route: pmtu
       ✅ Networking route_func - local
       ✅ Networking route_func - forward
       ✅ Networking TCP: keepalive test
       ✅ Networking UDP: socket
       ✅ Networking tunnel: geneve basic test
       ✅ Networking tunnel: gre basic
       ✅ L2TP basic test
       ✅ Networking tunnel: vxlan basic
       ✅ Networking ipsec: basic netns - tunnel
       ✅ Libkcapi AF_ALG test
       ✅ pciutils: update pci ids test
       ✅ ALSA PCM loopback test
       ✅ ALSA Control (mixer) Userspace Element test
       🚧 ✅ CIFS Connectathon
       🚧 ✅ POSIX pjd-fstest suites
       🚧 ✅ jvm - jcstress tests
       🚧 ✅ Memory function: kaslr
       🚧 ✅ Networking firewall: basic netfilter test
       🚧 ✅ audit: audit testsuite test
       🚧 ✅ trace: ftrace/tracer

    Host 3:

       ⚡ Internal infrastructure issues prevented one or more tests (marked
       with ⚡⚡⚡) from running on this architecture.
       This is not the fault of the kernel that was tested.

       ⚡⚡⚡ Boot test
       🚧 ⚡⚡⚡ kdump - sysrq-c

    Host 4:

       ⚡ Internal infrastructure issues prevented one or more tests (marked
       with ⚡⚡⚡) from running on this architecture.
       This is not the fault of the kernel that was tested.

       ⚡⚡⚡ Boot test
       🚧 ⚡⚡⚡ kdump - sysrq-c

    Host 5:
       ✅ Boot test
       🚧 ✅ kdump - sysrq-c

  s390x:
    Host 1:
       ✅ Boot test
       ✅ selinux-policy: serge-testsuite
       ✅ stress: stress-ng
       🚧 ✅ Storage blktests
       🚧 ❌ Storage nvme - tcp

    Host 2:
       ✅ Boot test
       ✅ Podman system integration test - as root
       ✅ Podman system integration test - as user
       ✅ LTP
       ✅ Loopdev Sanity
       ✅ Memory function: memfd_create
       ✅ AMTU (Abstract Machine Test Utility)
       ✅ Networking bridge: sanity
       ✅ Ethernet drivers sanity
       ✅ Networking route: pmtu
       ✅ Networking route_func - local
       ✅ Networking route_func - forward
       ✅ Networking TCP: keepalive test
       ✅ Networking UDP: socket
       ✅ Networking tunnel: geneve basic test
       ✅ Networking tunnel: gre basic
       ✅ L2TP basic test
       ✅ Networking tunnel: vxlan basic
       ✅ Networking ipsec: basic netns - transport
       ✅ Networking ipsec: basic netns - tunnel
       ✅ Libkcapi AF_ALG test
       🚧 ✅ CIFS Connectathon
       🚧 ✅ POSIX pjd-fstest suites
       🚧 ✅ jvm - jcstress tests
       🚧 ✅ Memory function: kaslr
       🚧 ✅ Networking firewall: basic netfilter test
       🚧 ✅ audit: audit testsuite test
       🚧 ✅ trace: ftrace/tracer

  x86_64:
    Host 1:

       ⚡ Internal infrastructure issues prevented one or more tests (marked
       with ⚡⚡⚡) from running on this architecture.
       This is not the fault of the kernel that was tested.

       ✅ Boot test
       ✅ xfstests - ext4
       ✅ xfstests - xfs
       ✅ selinux-policy: serge-testsuite
       ✅ storage: software RAID testing
       ✅ stress: stress-ng
       🚧 ✅ CPU: Frequency Driver Test
       🚧 ✅ CPU: Idle Test
       🚧 ✅ xfstests - btrfs
       🚧 ⚡⚡⚡ IOMMU boot test
       🚧 ⚡⚡⚡ IPMI driver test
       🚧 ⚡⚡⚡ IPMItool loop stress test
       🚧 ⚡⚡⚡ power-management: cpupower/sanity test
       🚧 ⚡⚡⚡ Storage blktests
       🚧 ⚡⚡⚡ Storage nvme - tcp

    Host 2:
       ✅ Boot test
       🚧 ✅ kdump - sysrq-c
       🚧 ✅ kdump - file-load

    Host 3:
       ✅ Boot test
       ✅ ACPI table test
       ✅ Podman system integration test - as root
       ✅ Podman system integration test - as user
       ✅ LTP
       ✅ Loopdev Sanity
       ✅ Memory function: memfd_create
       ✅ AMTU (Abstract Machine Test Utility)
       ✅ Networking bridge: sanity
       ✅ Ethernet drivers sanity
       ✅ Networking socket: fuzz
       ✅ Networking: igmp conformance test
       ✅ Networking route: pmtu
       ✅ Networking route_func - local
       ✅ Networking route_func - forward
       ✅ Networking TCP: keepalive test
       ✅ Networking UDP: socket
       ✅ Networking tunnel: geneve basic test
       ✅ Networking tunnel: gre basic
       ✅ L2TP basic test
       ✅ Networking tunnel: vxlan basic
       ✅ Networking ipsec: basic netns - transport
       ✅ Networking ipsec: basic netns - tunnel
       ✅ Libkcapi AF_ALG test
       ✅ pciutils: sanity smoke test
       ✅ pciutils: update pci ids test
       ✅ kernel-rt: rt_migrate_test
       ✅ kernel-rt: rteval
       ✅ kernel-rt: sched_deadline
       ✅ kernel-rt: smidetect
       ✅ ALSA PCM loopback test
       ✅ ALSA Control (mixer) Userspace Element test
       ✅ storage: SCSI VPD
       🚧 ✅ CIFS Connectathon
       🚧 ✅ POSIX pjd-fstest suites
       🚧 ✅ jvm - jcstress tests
       🚧 ✅ Memory function: kaslr
       🚧 ✅ Networking firewall: basic netfilter test
       🚧 ✅ audit: audit testsuite test
       🚧 ✅ trace: ftrace/tracer
       🚧 ✅ kdump - kexec_boot

  Test sources: https://gitlab.com/cki-project/kernel-tests
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Aborted tests
-------------
Tests that didn't complete running successfully are marked with ⚡⚡⚡.
If this was caused by an infrastructure issue, we try to mark that
explicitly in the report.

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running yet are marked with ⏱.

