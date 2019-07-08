Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC4628FA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfGHTJf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 8 Jul 2019 15:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390491AbfGHTJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 15:09:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB64D883D7
        for <stable@vger.kernel.org>; Mon,  8 Jul 2019 19:09:34 +0000 (UTC)
Received: from [172.54.129.25] (cpt-1023.paas.prod.upshift.rdu2.redhat.com [10.0.19.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 692575C660;
        Mon,  8 Jul 2019 19:09:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Test report for kernel 5.1.17-rc1-16964bf.cki
 (stable)
CC:     Xiong Zhou <xzhou@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Message-ID: <cki.96099E3AF3.1AVGXDK36X@redhat.com>
X-Gitlab-Pipeline-ID: 27941
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 08 Jul 2019 19:09:34 +0000 (UTC)
Date:   Mon, 8 Jul 2019 15:09:35 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 16964bf47d80 - Linux 5.1.17-rc1

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED



One or more kernel tests failed:

  x86_64:
    ❌ xfstests: ext4
    ❌ xfstests: xfs

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

We compiled the kernel for 1 architecture:

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-16964bf47d80c29d28ccc8f7182bfa3e940118b1.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-16964bf47d80c29d28ccc8f7182bfa3e940118b1.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ Memory function: memfd_create [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [14]
       🚧 ✅ Networking sctp-auth: sockopts test [15]
       🚧 ✅ Networking: igmp conformance test [16]
       🚧 ✅ Networking route: pmtu [17]
       🚧 ✅ Networking route_func: local [18]
       🚧 ✅ Networking route_func: forward [18]
       🚧 ✅ Networking TCP: keepalive test [19]
       🚧 ✅ Networking UDP: socket [20]
       🚧 ✅ Networking tunnel: gre basic [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ tuned: tune-processes-through-perf [25]
       🚧 ✅ Storage blktests [26]
       🚧 ✅ storage: SCSI VPD [27]
       🚧 ✅ storage: software RAID testing [28]
       🚧 ✅ stress: stress-ng [29]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [30]

    Host 3:
       ✅ Boot test [0]
       ❌ xfstests: ext4 [31]
       ❌ xfstests: xfs [31]
       🚧 ✅ selinux-policy: serge-testsuite [32]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/gre/basic
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [29]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [30]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [31]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [32]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
