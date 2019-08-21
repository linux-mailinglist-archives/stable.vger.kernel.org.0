Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6396F56
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfHUCRt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 20 Aug 2019 22:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfHUCRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 22:17:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C75E13082E0F
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 02:17:48 +0000 (UTC)
Received: from [172.54.45.2] (cpt-1019.paas.prod.upshift.rdu2.redhat.com [10.0.19.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC8752C8D2;
        Wed, 21 Aug 2019 02:17:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.10-rc1-d3ad3ee.cki
 (stable)
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.EE3C861737.0V6KO2IJN9@redhat.com>
X-Gitlab-Pipeline-ID: 113625
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/113625
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 21 Aug 2019 02:17:48 +0000 (UTC)
Date:   Tue, 20 Aug 2019 22:17:49 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: d3ad3ee990bc - Linux 5.2.10-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/113625

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

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ⚡⚡⚡ lvm thinp sanity [3]
         ⚡⚡⚡ storage: software RAID testing [4]
         🚧 ❌ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ Memory function: memfd_create [10]
         ✅ AMTU (Abstract Machine Test Utility) [11]
         ✅ LTP: openposix test suite [12]
         ✅ Ethernet drivers sanity [13]
         ✅ Networking socket: fuzz [14]
         ✅ Networking sctp-auth: sockopts test [15]
         ✅ Networking TCP: keepalive test [16]
         ✅ Networking UDP: socket [17]
         ✅ Networking tunnel: gre basic [18]
         ✅ Networking tunnel: vxlan basic [19]
         ✅ audit: audit testsuite test [20]
         ✅ httpd: mod_ssl smoke sanity [21]
         ✅ iotop: sanity [22]
         ✅ tuned: tune-processes-through-perf [23]
         ✅ Usex - version 1.9-29 [24]
         🚧 ✅ Networking route: pmtu [25]
         🚧 ✅ Networking route_func: local [26]
         🚧 ✅ Networking route_func: forward [26]
         🚧 ✅ Networking tunnel: geneve basic test [27]
         🚧 ✅ Networking ipsec: basic netns tunnel [28]
         🚧 ✅ trace: ftrace/tracer [29]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ Memory function: memfd_create [10]
         ✅ AMTU (Abstract Machine Test Utility) [11]
         ✅ LTP: openposix test suite [12]
         ✅ Ethernet drivers sanity [13]
         ✅ Networking socket: fuzz [14]
         ✅ Networking sctp-auth: sockopts test [15]
         ✅ Networking: igmp conformance test [30]
         ✅ Networking TCP: keepalive test [16]
         ✅ Networking UDP: socket [17]
         ✅ Networking tunnel: gre basic [18]
         ✅ Networking tunnel: vxlan basic [19]
         ✅ audit: audit testsuite test [20]
         ✅ httpd: mod_ssl smoke sanity [21]
         ✅ iotop: sanity [22]
         ✅ tuned: tune-processes-through-perf [23]
         ✅ pciutils: sanity smoke test [31]
         ✅ Usex - version 1.9-29 [24]
         ✅ storage: SCSI VPD [32]
         ✅ stress: stress-ng [33]
         🚧 ✅ Networking route: pmtu [25]
         🚧 ✅ Networking route_func: local [26]
         🚧 ✅ Networking route_func: forward [26]
         🚧 ✅ Networking tunnel: geneve basic test [27]
         🚧 ✅ Networking ipsec: basic netns transport [28]
         🚧 ✅ Networking ipsec: basic netns tunnel [28]
         🚧 ✅ trace: ftrace/tracer [29]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [1]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
