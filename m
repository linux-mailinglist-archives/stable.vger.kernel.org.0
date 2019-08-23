Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8429A44A
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 02:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbfHWAaf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 22 Aug 2019 20:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfHWAaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 20:30:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2822A3091754
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 00:30:35 +0000 (UTC)
Received: from [172.54.99.226] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E55BF6DA86;
        Fri, 23 Aug 2019 00:30:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.2.10-rc1-f5284fb.cki
 (stable)
CC:     Jeff Bastian <jbastian@redhat.com>
Message-ID: <cki.66AF037CBA.ROCU3L6TFM@redhat.com>
X-Gitlab-Pipeline-ID: 117364
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/117364
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 23 Aug 2019 00:30:35 +0000 (UTC)
Date:   Thu, 22 Aug 2019 20:30:35 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: f5284fbdcd34 - Linux 5.2.10-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/117364



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

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    s390x:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]
         🚧 ⚡⚡⚡ IOMMU boot test [6]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ LTP lite [8]
         ✅ Loopdev Sanity [9]
         ✅ jvm test suite [10]
         ✅ Memory function: memfd_create [11]
         ✅ AMTU (Abstract Machine Test Utility) [12]
         ✅ LTP: openposix test suite [13]
         ✅ Ethernet drivers sanity [14]
         ✅ Networking socket: fuzz [15]
         ✅ Networking sctp-auth: sockopts test [16]
         ✅ Networking: igmp conformance test [17]
         ✅ Networking TCP: keepalive test [18]
         ✅ Networking UDP: socket [19]
         ✅ Networking tunnel: gre basic [20]
         ✅ Networking tunnel: vxlan basic [21]
         ✅ audit: audit testsuite test [22]
         ✅ httpd: mod_ssl smoke sanity [23]
         ✅ iotop: sanity [24]
         ✅ tuned: tune-processes-through-perf [25]
         ✅ Usex - version 1.9-29 [26]
         ✅ storage: SCSI VPD [27]
         ✅ stress: stress-ng [28]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking route_func: local [30]
         🚧 ✅ Networking route_func: forward [30]
         🚧 ✅ Networking tunnel: geneve basic test [31]
         🚧 ✅ Networking ipsec: basic netns transport [32]
         🚧 ✅ Networking ipsec: basic netns tunnel [32]
         🚧 ✅ trace: ftrace/tracer [33]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ LTP lite [8]
         ✅ Loopdev Sanity [9]
         ✅ jvm test suite [10]
         ✅ Memory function: memfd_create [11]
         ✅ AMTU (Abstract Machine Test Utility) [12]
         ✅ LTP: openposix test suite [13]
         ✅ Ethernet drivers sanity [14]
         ✅ Networking socket: fuzz [15]
         ✅ Networking sctp-auth: sockopts test [16]
         ✅ Networking TCP: keepalive test [18]
         ✅ Networking UDP: socket [19]
         ✅ Networking tunnel: gre basic [20]
         ✅ Networking tunnel: vxlan basic [21]
         ✅ audit: audit testsuite test [22]
         ✅ httpd: mod_ssl smoke sanity [23]
         ✅ iotop: sanity [24]
         ✅ tuned: tune-processes-through-perf [25]
         ✅ Usex - version 1.9-29 [26]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking route_func: local [30]
         🚧 ✅ Networking route_func: forward [30]
         🚧 ✅ Networking tunnel: geneve basic test [31]
         🚧 ✅ Networking ipsec: basic netns tunnel [32]
         🚧 ✅ trace: ftrace/tracer [33]


  s390x:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]
         🚧 ✅ IOMMU boot test [6]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [7]
         ✅ Podman system integration test (as user) [7]
         ✅ LTP lite [8]
         ✅ Loopdev Sanity [9]
         ✅ jvm test suite [10]
         ✅ Memory function: memfd_create [11]
         ✅ AMTU (Abstract Machine Test Utility) [12]
         ✅ LTP: openposix test suite [13]
         ✅ Ethernet drivers sanity [14]
         ✅ Networking socket: fuzz [15]
         ✅ Networking sctp-auth: sockopts test [16]
         ✅ Networking: igmp conformance test [17]
         ✅ Networking TCP: keepalive test [18]
         ✅ Networking UDP: socket [19]
         ✅ Networking tunnel: gre basic [20]
         ✅ Networking tunnel: vxlan basic [21]
         ✅ audit: audit testsuite test [22]
         ✅ httpd: mod_ssl smoke sanity [23]
         ✅ iotop: sanity [24]
         ✅ tuned: tune-processes-through-perf [25]
         ✅ pciutils: sanity smoke test [34]
         ✅ Usex - version 1.9-29 [26]
         ✅ storage: SCSI VPD [27]
         ❌ stress: stress-ng [28]
         🚧 ✅ Networking route: pmtu [29]
         🚧 ✅ Networking route_func: local [30]
         🚧 ✅ Networking route_func: forward [30]
         🚧 ✅ Networking tunnel: geneve basic test [31]
         🚧 ✅ Networking ipsec: basic netns transport [32]
         🚧 ✅ Networking ipsec: basic netns tunnel [32]
         🚧 ✅ trace: ftrace/tracer [33]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
