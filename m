Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52796EA9
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 03:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfHUBGp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 20 Aug 2019 21:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfHUBGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 21:06:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A0298980EA
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 01:06:44 +0000 (UTC)
Received: from [172.54.45.2] (cpt-1019.paas.prod.upshift.rdu2.redhat.com [10.0.19.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B30C55C1D6;
        Wed, 21 Aug 2019 01:06:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.10-rc1-0953e78.cki
 (stable)
CC:     Major Hayden <major@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Christine Flood <chf@redhat.com>,
        John Linville <linville@redhat.com>,
        Xiumei Mu <xmu@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ying Xu <yinxu@redhat.com>, Jianlin Shi <jishi@redhat.com>,
        Yi Chen <yiche@redhat.com>, Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Brano Nater <bnater@redhat.com>, David Jez <djez@redhat.com>,
        Petr Sklenar <psklenar@redhat.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        Jeff Bastian <jbastian@redhat.com>,
        Ziqian Sun <zsun@redhat.com>, Milos Malik <mmalik@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Jakub Krysl <jkrysl@redhat.com>,
        Changhui Zhong <czhong@redhat.com>
Message-ID: <cki.F32073CDEF.PB1O9FNVCQ@redhat.com>
X-Gitlab-Pipeline-ID: 113210
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/113210
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 21 Aug 2019 01:06:44 +0000 (UTC)
Date:   Tue, 20 Aug 2019 21:06:45 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 0953e780f37b - Linux 5.2.10-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/113210

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
         ❌ Boot test [0]
         ❌ Podman system integration test (as root) [1]
         ❌ Podman system integration test (as user) [1]
         ❌ LTP lite [2]
         ❌ Loopdev Sanity [3]
         ❌ jvm test suite [4]
         ❌ Memory function: memfd_create [5]
         ❌ AMTU (Abstract Machine Test Utility) [6]
         ❌ LTP: openposix test suite [7]
         ❌ Ethernet drivers sanity [8]
         ❌ Networking socket: fuzz [9]
         ❌ Networking sctp-auth: sockopts test [10]
         ❌ Networking: igmp conformance test [11]
         ❌ Networking TCP: keepalive test [12]
         ❌ Networking UDP: socket [13]
         ❌ Networking tunnel: gre basic [14]
         ❌ Networking tunnel: vxlan basic [15]
         ❌ audit: audit testsuite test [16]
         ❌ httpd: mod_ssl smoke sanity [17]
         ❌ iotop: sanity [18]
         ❌ tuned: tune-processes-through-perf [19]
         ❌ Usex - version 1.9-29 [20]
         ❌ storage: SCSI VPD [21]
         ❌ stress: stress-ng [22]
         🚧 ❌ Networking route: pmtu [23]
         🚧 ❌ Networking route_func: local [24]
         🚧 ❌ Networking route_func: forward [24]
         🚧 ❌ Networking tunnel: geneve basic test [25]
         🚧 ❌ Networking ipsec: basic netns transport [26]
         🚧 ❌ Networking ipsec: basic netns tunnel [26]
         🚧 ❌ trace: ftrace/tracer [27]

      Host 2:
         ❌ Boot test [0]
         ❌ xfstests: ext4 [28]
         ❌ xfstests: xfs [28]
         ❌ selinux-policy: serge-testsuite [29]
         ❌ lvm thinp sanity [30]
         ❌ storage: software RAID testing [31]
         🚧 ❌ Storage blktests [32]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [28]
         ✅ xfstests: xfs [28]
         ✅ selinux-policy: serge-testsuite [29]
         ✅ lvm thinp sanity [30]
         ✅ storage: software RAID testing [31]
         🚧 ✅ Storage blktests [32]

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
         ✅ Networking TCP: keepalive test [12]
         ✅ Networking UDP: socket [13]
         ✅ Networking tunnel: gre basic [14]
         ✅ Networking tunnel: vxlan basic [15]
         ✅ audit: audit testsuite test [16]
         ✅ httpd: mod_ssl smoke sanity [17]
         ✅ iotop: sanity [18]
         ✅ tuned: tune-processes-through-perf [19]
         ✅ Usex - version 1.9-29 [20]
         🚧 ✅ Networking route: pmtu [23]
         🚧 ✅ Networking route_func: local [24]
         🚧 ✅ Networking route_func: forward [24]
         🚧 ✅ Networking tunnel: geneve basic test [25]
         🚧 ✅ Networking ipsec: basic netns tunnel [26]
         🚧 ✅ trace: ftrace/tracer [27]


  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


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
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
