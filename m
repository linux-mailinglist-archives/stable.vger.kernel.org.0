Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AFE9E7EF
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 14:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfH0MbE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 08:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfH0MbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 08:31:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A54077BDA0
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 12:31:03 +0000 (UTC)
Received: from [172.54.124.177] (cpt-1056.paas.prod.upshift.rdu2.redhat.com [10.0.19.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA51760610;
        Tue, 27 Aug 2019 12:30:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.2.11-rc1-9f63171.cki
 (stable)
CC:     Yi Zhang <yi.zhang@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Hangbin Liu <haliu@redhat.com>, Ying Xu <yinxu@redhat.com>
Message-ID: <cki.98AD376375.DJWRK5AJEY@redhat.com>
X-Gitlab-Pipeline-ID: 126819
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/126819
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 27 Aug 2019 12:31:03 +0000 (UTC)
Date:   Tue, 27 Aug 2019 08:31:04 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 9f631715ffe6 - Linux 5.2.11-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/126819



One or more kernel tests failed:

  x86_64:
    ❌ Networking socket: fuzz
    ❌ Networking sctp-auth: sockopts test

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
         ✅ Networking: igmp conformance test [11]
         ✅ Networking TCP: keepalive test [12]
         ✅ Networking UDP: socket [13]
         ✅ Networking tunnel: gre basic [14]
         ✅ Networking tunnel: vxlan basic [15]
         ✅ audit: audit testsuite test [16]
         ✅ httpd: mod_ssl smoke sanity [17]
         ✅ iotop: sanity [18]
         ✅ tuned: tune-processes-through-perf [19]
         ✅ Usex - version 1.9-29 [20]
         ✅ storage: SCSI VPD [21]
         ✅ stress: stress-ng [22]
         🚧 ✅ Networking route: pmtu [23]
         🚧 ✅ Networking route_func: local [24]
         🚧 ✅ Networking route_func: forward [24]
         🚧 ✅ Networking tunnel: geneve basic test [25]
         🚧 ✅ Networking ipsec: basic netns transport [26]
         🚧 ✅ Networking ipsec: basic netns tunnel [26]
         🚧 ✅ Networking vnic: ipvlan/basic [27]
         🚧 ✅ trace: ftrace/tracer [28]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ✅ lvm thinp sanity [31]
         ✅ storage: software RAID testing [32]
         🚧 ✅ Storage blktests [33]


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
         🚧 ✅ Networking vnic: ipvlan/basic [27]
         🚧 ✅ trace: ftrace/tracer [28]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ⚡⚡⚡ lvm thinp sanity [31]
         ⚡⚡⚡ storage: software RAID testing [32]
         🚧 ❌ Storage blktests [33]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ✅ lvm thinp sanity [31]
         ✅ storage: software RAID testing [32]
         🚧 ✅ Storage blktests [33]
         🚧 ✅ IOMMU boot test [34]

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
         ❌ Networking socket: fuzz [9]
         ❌ Networking sctp-auth: sockopts test [10]
         ✅ Networking: igmp conformance test [11]
         ✅ Networking TCP: keepalive test [12]
         ✅ Networking UDP: socket [13]
         ✅ Networking tunnel: gre basic [14]
         ✅ Networking tunnel: vxlan basic [15]
         ✅ audit: audit testsuite test [16]
         ✅ httpd: mod_ssl smoke sanity [17]
         ✅ iotop: sanity [18]
         ✅ tuned: tune-processes-through-perf [19]
         ✅ pciutils: sanity smoke test [35]
         ✅ Usex - version 1.9-29 [20]
         ✅ storage: SCSI VPD [21]
         ✅ stress: stress-ng [22]
         🚧 ✅ Networking route: pmtu [23]
         🚧 ✅ Networking route_func: local [24]
         🚧 ✅ Networking route_func: forward [24]
         🚧 ✅ Networking tunnel: geneve basic test [25]
         🚧 ✅ Networking ipsec: basic netns transport [26]
         🚧 ✅ Networking ipsec: basic netns tunnel [26]
         🚧 ✅ Networking vnic: ipvlan/basic [27]
         🚧 ✅ trace: ftrace/tracer [28]


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
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/vnic/ipvlan/basic
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot
    [35]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
