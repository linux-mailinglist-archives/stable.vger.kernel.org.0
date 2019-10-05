Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C0CCCD3F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfJEXLK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 5 Oct 2019 19:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJEXLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 19:11:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7AC10308FC20
        for <stable@vger.kernel.org>; Sat,  5 Oct 2019 23:11:09 +0000 (UTC)
Received: from [172.54.19.159] (cpt-1010.paas.prod.upshift.rdu2.redhat.com [10.0.19.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 679A95D772;
        Sat,  5 Oct 2019 23:11:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.3.4-ed56826.cki
 (stable)
CC:     Jeff Bastian <jbastian@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <cki.F7D7AF8291.B2RERZ8XG4@redhat.com>
X-Gitlab-Pipeline-ID: 207647
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/207647
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 05 Oct 2019 23:11:09 +0000 (UTC)
Date:   Sat, 5 Oct 2019 19:11:10 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: ed56826f1779 - Linux 5.3.4

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/207647

One or more kernel tests failed:

    x86_64:
      ❌ stress: stress-ng

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

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

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test
         ✅ xfstests: ext4
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ Memory function: memfd_create
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ Networking sctp-auth: sockopts test
         ✅ Networking: igmp conformance test
         ✅ Networking TCP: keepalive test
         ✅ Networking UDP: socket
         ✅ Networking tunnel: gre basic
         ✅ Networking tunnel: vxlan basic
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         🚧 ⚡⚡⚡ LTP lite
         🚧 ⚡⚡⚡ CIFS Connectathon
         🚧 ⚡⚡⚡ POSIX pjd-fstest suites
         🚧 ⚡⚡⚡ Memory function: kaslr
         🚧 ⚡⚡⚡ Networking bridge: sanity
         🚧 ⚡⚡⚡ Networking MACsec: sanity
         🚧 ⚡⚡⚡ Networking route: pmtu
         🚧 ⚡⚡⚡ Networking tunnel: geneve basic test
         🚧 ⚡⚡⚡ L2TP basic test
         🚧 ⚡⚡⚡ Networking vnic: ipvlan/basic
         🚧 ⚡⚡⚡ ALSA PCM loopback test
         🚧 ⚡⚡⚡ ALSA Control (mixer) Userspace Element test
         🚧 ⚡⚡⚡ storage: dm/common
         🚧 ⚡⚡⚡ trace: ftrace/tracer
         🚧 ⚡⚡⚡ Networking route_func: local
         🚧 ⚡⚡⚡ Networking route_func: forward
         🚧 ⚡⚡⚡ Networking ipsec: basic netns transport
         🚧 ⚡⚡⚡ Networking ipsec: basic netns tunnel

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ Memory function: memfd_create
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ Networking sctp-auth: sockopts test
         ✅ Networking TCP: keepalive test
         ✅ Networking UDP: socket
         ✅ Networking tunnel: gre basic
         ✅ Networking tunnel: vxlan basic
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ CIFS Connectathon
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ Memory function: kaslr
         🚧 ✅ Networking bridge: sanity
         🚧 ✅ Networking MACsec: sanity
         🚧 ✅ Networking route: pmtu
         🚧 ✅ Networking tunnel: geneve basic test
         🚧 ✅ L2TP basic test
         🚧 ✅ Networking ipsec: basic netns tunnel
         🚧 ✅ Networking vnic: ipvlan/basic
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ storage: dm/common
         🚧 ✅ trace: ftrace/tracer
         🚧 ✅ Networking route_func: local
         🚧 ✅ Networking route_func: forward

      Host 2:
         ✅ Boot test
         ✅ xfstests: ext4
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ Memory function: memfd_create
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ Networking sctp-auth: sockopts test
         ✅ Networking: igmp conformance test
         ✅ Networking TCP: keepalive test
         ✅ Networking UDP: socket
         ✅ Networking tunnel: gre basic
         ✅ Networking tunnel: vxlan basic
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ❌ stress: stress-ng
         🚧 ❌ LTP lite
         🚧 ✅ CIFS Connectathon
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ Memory function: kaslr
         🚧 ✅ Networking bridge: sanity
         🚧 ✅ Networking MACsec: sanity
         🚧 ✅ Networking route: pmtu
         🚧 ✅ Networking tunnel: geneve basic test
         🚧 ✅ L2TP basic test
         🚧 ✅ Networking vnic: ipvlan/basic
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ storage: dm/common
         🚧 ✅ trace: ftrace/tracer
         🚧 ✅ Networking route_func: local
         🚧 ✅ Networking route_func: forward
         🚧 ✅ Networking ipsec: basic netns transport
         🚧 ✅ Networking ipsec: basic netns tunnel

      Host 2:
         ✅ Boot test
         ✅ Storage SAN device stress - mpt3sas driver

      Host 3:
         ✅ Boot test
         🚧 ✅ IPMI driver test
         🚧 ✅ IPMItool loop stress test

      Host 4:
         ✅ Boot test
         ✅ Storage SAN device stress - megaraid_sas

      Host 5:
         ✅ Boot test
         ✅ xfstests: ext4
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ IOMMU boot test
         🚧 ✅ Storage blktests

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

