Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C27283E7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 18:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbfEWQiV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 12:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbfEWQiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 12:38:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CDAE3179179
        for <stable@vger.kernel.org>; Thu, 23 May 2019 16:38:20 +0000 (UTC)
Received: from [172.54.114.147] (cpt-0011.paas.prod.upshift.rdu2.redhat.com [10.0.18.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B42662E043;
        Thu, 23 May 2019 16:38:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 4.19.45-ce3d589.cki
 (stable)
CC:     Xiumei Mu <xmu@redhat.com>, Hangbin Liu <haliu@redhat.com>
Message-ID: <cki.DCC6083B8C.Z9YRAGUFOI@redhat.com>
X-Gitlab-Pipeline-ID: 10677
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10677?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 23 May 2019 16:38:20 +0000 (UTC)
Date:   Thu, 23 May 2019 12:38:21 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: c3a072597748 - Linux 4.19.45

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

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
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-c3a0725977484ea2d7f17746d7e168d2b19f99a2.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-c3a0725977484ea2d7f17746d7e168d2b19f99a2.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-c3a0725977484ea2d7f17746d7e168d2b19f99a2.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-c3a0725977484ea2d7f17746d7e168d2b19f99a2.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-c3a0725977484ea2d7f17746d7e168d2b19f99a2.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-c3a0725977484ea2d7f17746d7e168d2b19f99a2.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-c3a0725977484ea2d7f17746d7e168d2b19f99a2.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-c3a0725977484ea2d7f17746d7e168d2b19f99a2.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Memory function: memfd_create [5]
     ✅ AMTU (Abstract Machine Test Utility) [6]
     ✅ Ethernet drivers sanity [7]
     ✅ audit: audit testsuite test [8]
     ✅ httpd: mod_ssl smoke sanity [9]
     ✅ iotop: sanity [10]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
     ✅ tuned: tune-processes-through-perf [13]
     ✅ Usex - version 1.9-29 [14]
     ✅ lvm thinp sanity [15]
     ✅ stress: stress-ng [16]
     🚧 ✅ Networking socket: fuzz [17]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [18]
     🚧 ✅ Networking: igmp conformance test [19]
     🚧 ✅ Networking route: pmtu [20]
     🚧 ✅ Networking route_func: local [21]
     🚧 ✅ Networking route_func: forward [21]
     🚧 ✅ Networking TCP: keepalive test [22]
     🚧 ✅ Networking UDP: socket [23]
     🚧 ✅ networking tunnel: geneve basic test [24]
     🚧 ✅ Networking ipsec: basic netns transport [25]
     🚧 ✅ Networking ipsec: basic netns tunnel [25]
     🚧 ✅ Storage blktests [26]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Memory function: memfd_create [5]
     ✅ AMTU (Abstract Machine Test Utility) [6]
     ✅ Ethernet drivers sanity [7]
     ✅ audit: audit testsuite test [8]
     ✅ httpd: mod_ssl smoke sanity [9]
     ✅ iotop: sanity [10]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
     ✅ tuned: tune-processes-through-perf [13]
     ✅ Usex - version 1.9-29 [14]
     ✅ lvm thinp sanity [15]
     ✅ stress: stress-ng [16]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     🚧 ✅ Networking socket: fuzz [17]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [18]
     🚧 ✅ Networking route: pmtu [20]
     🚧 ✅ Networking route_func: local [21]
     🚧 ✅ Networking route_func: forward [21]
     🚧 ✅ Networking TCP: keepalive test [22]
     🚧 ✅ Networking UDP: socket [23]
     🚧 ✅ networking tunnel: geneve basic test [24]
     🚧 ✅ Networking ipsec: basic netns tunnel [25]
     🚧 ✅ Storage blktests [26]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Memory function: memfd_create [5]
     ✅ Ethernet drivers sanity [7]
     ✅ audit: audit testsuite test [8]
     ✅ httpd: mod_ssl smoke sanity [9]
     ✅ iotop: sanity [10]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
     ✅ tuned: tune-processes-through-perf [13]
     ✅ Usex - version 1.9-29 [14]
     ✅ lvm thinp sanity [15]
     ✅ stress: stress-ng [16]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c [27]
     🚧 ✅ Networking socket: fuzz [17]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [18]
     🚧 ✅ Networking: igmp conformance test [19]
     🚧 ✅ Networking route: pmtu [20]
     🚧 ✅ Networking route_func: local [21]
     🚧 ✅ Networking route_func: forward [21]
     🚧 ❎ Networking TCP: keepalive test [22]
     🚧 ✅ Networking UDP: socket [23]
     🚧 ✅ networking tunnel: geneve basic test [24]
     🚧 ✅ Networking ipsec: basic netns transport [25]
     🚧 ✅ Networking ipsec: basic netns tunnel [25]
     🚧 ✅ Storage blktests [26]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [3]
     ✅ Loopdev Sanity [4]
     ✅ Memory function: memfd_create [5]
     ✅ AMTU (Abstract Machine Test Utility) [6]
     ✅ Ethernet drivers sanity [7]
     ✅ audit: audit testsuite test [8]
     ✅ httpd: mod_ssl smoke sanity [9]
     ✅ iotop: sanity [10]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [11]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [12]
     ✅ tuned: tune-processes-through-perf [13]
     ✅ Usex - version 1.9-29 [14]
     ✅ lvm thinp sanity [15]
     ✅ stress: stress-ng [16]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c [27]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ selinux-policy: serge-testsuite [2]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c - megaraid_sas [27]
     🚧 ✅ Networking socket: fuzz [17]
     🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
     🚧 ✅ Networking sctp-auth: sockopts test [18]
     🚧 ✅ Networking: igmp conformance test [19]
     🚧 ✅ Networking route: pmtu [20]
     🚧 ✅ Networking route_func: local [21]
     🚧 ✅ Networking route_func: forward [21]
     🚧 ✅ Networking TCP: keepalive test [22]
     🚧 ✅ Networking UDP: socket [23]
     🚧 ✅ networking tunnel: geneve basic test [24]
     🚧 ✅ Networking ipsec: basic netns transport [25]
     🚧 ✅ Networking ipsec: basic netns tunnel [25]
     🚧 ✅ Storage blktests [26]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
