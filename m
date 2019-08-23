Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B8F9A451
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 02:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfHWAgn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 22 Aug 2019 20:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731690AbfHWAgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 20:36:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 455B73082131
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 00:36:42 +0000 (UTC)
Received: from [172.54.99.226] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7AEE6DAD0;
        Fri, 23 Aug 2019 00:36:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.10-rc1-e94dc5d.cki
 (stable)
Message-ID: <cki.76BF5B7B7E.3NOBPCQEP9@redhat.com>
X-Gitlab-Pipeline-ID: 117089
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/117089
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 23 Aug 2019 00:36:42 +0000 (UTC)
Date:   Thu, 22 Aug 2019 20:36:42 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: e94dc5db6710 - Linux 5.2.10-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/117089

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
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ Memory function: memfd_create [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ Ethernet drivers sanity [8]
         ✅ Networking socket: fuzz [9]
         ✅ Networking sctp-auth: sockopts test [10]
         ✅ Networking TCP: keepalive test [11]
         ✅ Networking UDP: socket [12]
         ✅ Networking tunnel: gre basic [13]
         ✅ Networking tunnel: vxlan basic [14]
         ✅ audit: audit testsuite test [15]
         ✅ httpd: mod_ssl smoke sanity [16]
         ✅ iotop: sanity [17]
         ✅ tuned: tune-processes-through-perf [18]
         ✅ Usex - version 1.9-29 [19]
         🚧 ✅ Networking route: pmtu [20]
         🚧 ✅ Networking route_func: local [21]
         🚧 ✅ Networking route_func: forward [21]
         🚧 ✅ Networking tunnel: geneve basic test [22]
         🚧 ✅ Networking ipsec: basic netns tunnel [23]
         🚧 ✅ trace: ftrace/tracer [24]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [25]
         ✅ xfstests: xfs [25]
         ✅ selinux-policy: serge-testsuite [26]
         ✅ lvm thinp sanity [27]
         ✅ storage: software RAID testing [28]
         🚧 ✅ Storage blktests [29]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [25]
         ✅ xfstests: xfs [25]
         ✅ selinux-policy: serge-testsuite [26]
         ✅ lvm thinp sanity [27]
         ✅ storage: software RAID testing [28]
         🚧 ✅ Storage blktests [29]
         🚧 ✅ IOMMU boot test [30]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ Memory function: memfd_create [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ Ethernet drivers sanity [8]
         ✅ Networking socket: fuzz [9]
         ✅ Networking sctp-auth: sockopts test [10]
         ✅ Networking: igmp conformance test [31]
         ✅ Networking TCP: keepalive test [11]
         ✅ Networking UDP: socket [12]
         ✅ Networking tunnel: gre basic [13]
         ✅ Networking tunnel: vxlan basic [14]
         ✅ audit: audit testsuite test [15]
         ✅ httpd: mod_ssl smoke sanity [16]
         ✅ iotop: sanity [17]
         ✅ tuned: tune-processes-through-perf [18]
         ✅ pciutils: sanity smoke test [32]
         ✅ Usex - version 1.9-29 [19]
         ✅ storage: SCSI VPD [33]
         ✅ stress: stress-ng [34]
         🚧 ✅ Networking route: pmtu [20]
         🚧 ✅ Networking route_func: local [21]
         🚧 ✅ Networking route_func: forward [21]
         🚧 ✅ Networking tunnel: geneve basic test [22]
         🚧 ✅ Networking ipsec: basic netns transport [23]
         🚧 ✅ Networking ipsec: basic netns tunnel [23]
         🚧 ✅ trace: ftrace/tracer [24]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
