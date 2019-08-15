Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78648E57E
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHOHXl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 15 Aug 2019 03:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfHOHXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 03:23:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F34A3309BF13
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 07:23:40 +0000 (UTC)
Received: from [172.54.84.190] (cpt-1024.paas.prod.upshift.rdu2.redhat.com [10.0.19.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05F64403A;
        Thu, 15 Aug 2019 07:23:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.2.9-rc1-2440e48.cki
 (stable)
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.BF9724DF28.NB2ZULIYXL@redhat.com>
X-Gitlab-Pipeline-ID: 100875
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/100875
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 15 Aug 2019 07:23:41 +0000 (UTC)
Date:   Thu, 15 Aug 2019 03:23:41 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 2440e485aeda - Linux 5.2.9-rc1

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/100875

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
         ✅ pciutils: update pci ids test [20]
         ✅ Usex - version 1.9-29 [21]
         ✅ storage: SCSI VPD [22]
         ✅ stress: stress-ng [23]
         🚧 ✅ Networking route: pmtu [24]
         🚧 ✅ Networking route_func: local [25]
         🚧 ✅ Networking route_func: forward [25]
         🚧 ✅ Networking tunnel: geneve basic test [26]
         🚧 ✅ Networking ipsec: basic netns transport [27]
         🚧 ✅ Networking ipsec: basic netns tunnel [27]
         🚧 ✅ trace: ftrace/tracer [28]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ✅ lvm thinp sanity [31]
         ✅ storage: software RAID testing [32]
         ✅ storage: iSCSI parameters [33]
         🚧 ✅ Storage blktests [34]


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
         ✅ pciutils: update pci ids test [20]
         ✅ Usex - version 1.9-29 [21]
         🚧 ✅ Networking route: pmtu [24]
         🚧 ✅ Networking route_func: local [25]
         🚧 ✅ Networking route_func: forward [25]
         🚧 ✅ Networking tunnel: geneve basic test [26]
         🚧 ✅ Networking ipsec: basic netns tunnel [27]
         🚧 ✅ trace: ftrace/tracer [28]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ⚡⚡⚡ lvm thinp sanity [31]
         ⚡⚡⚡ storage: software RAID testing [32]
         🚧 ❌ Storage blktests [34]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: ext4 [29]
         ✅ xfstests: xfs [29]
         ✅ selinux-policy: serge-testsuite [30]
         ✅ lvm thinp sanity [31]
         ✅ storage: software RAID testing [32]
         ✅ storage: iSCSI parameters [33]
         🚧 ✅ Storage blktests [34]


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
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/update-pciids
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [33]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/iscsi/params
    [34]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
