Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2FC2F7CE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 09:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE3HQZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 May 2019 03:16:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbfE3HQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 03:16:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB48DC004BEB
        for <stable@vger.kernel.org>; Thu, 30 May 2019 07:16:23 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 556BC5C1B5;
        Thu, 30 May 2019 07:16:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.6-rc1-5285c6e.cki
 (stable)
CC:     Xiumei Mu <xmu@redhat.com>, Hangbin Liu <haliu@redhat.com>
Message-ID: <cki.EEC5C1A720.H9CYLE4DPN@redhat.com>
X-Gitlab-Pipeline-ID: 11099
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11099?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 30 May 2019 07:16:23 +0000 (UTC)
Date:   Thu, 30 May 2019 03:16:25 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 6df8e06907e1 - Linux 5.1.6-rc1

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
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-6df8e06907e10b03bfeb68d794def0a11133a8a3.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-6df8e06907e10b03bfeb68d794def0a11133a8a3.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-6df8e06907e10b03bfeb68d794def0a11133a8a3.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-6df8e06907e10b03bfeb68d794def0a11133a8a3.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-6df8e06907e10b03bfeb68d794def0a11133a8a3.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-6df8e06907e10b03bfeb68d794def0a11133a8a3.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-6df8e06907e10b03bfeb68d794def0a11133a8a3.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-6df8e06907e10b03bfeb68d794def0a11133a8a3.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ✅ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ Storage blktests [25]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [26]
       ✅ xfstests: xfs [26]
       ✅ selinux-policy: serge-testsuite [27]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ✅ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       ✅ stress: stress-ng [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ❎ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ Storage blktests [25]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [26]
       ✅ xfstests: xfs [26]
       ✅ selinux-policy: serge-testsuite [27]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [27]

    Host 2:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [28]

    Host 3:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ✅ tuned: tune-processes-through-perf [11]
       ✅ lvm thinp sanity [13]
       ✅ stress: stress-ng [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ Storage blktests [25]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c [28]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Memory function: memfd_create [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
       ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
       ✅ tuned: tune-processes-through-perf [11]
       ✅ Usex - version 1.9-29 [12]
       ✅ lvm thinp sanity [13]
       ✅ stress: stress-ng [14]
       🚧 ✅ Networking socket: fuzz [15]
       🚧 ✅ /kernel/networking/ipv6/Fujitsu-socketapi-test
       🚧 ✅ Networking sctp-auth: sockopts test [16]
       🚧 ✅ Networking: igmp conformance test [17]
       🚧 ✅ Networking route: pmtu [18]
       🚧 ✅ Networking route_func: local [19]
       🚧 ✅ Networking route_func: forward [19]
       🚧 ✅ Networking TCP: keepalive test [20]
       🚧 ✅ Networking UDP: socket [21]
       🚧 ✅ Networking tunnel: vxlan basic [22]
       🚧 ✅ Networking tunnel: geneve basic test [23]
       🚧 ✅ Networking ipsec: basic netns transport [24]
       🚧 ✅ Networking ipsec: basic netns tunnel [24]
       🚧 ✅ Storage blktests [25]

    Host 3:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [26]
       ✅ xfstests: xfs [26]
       ✅ selinux-policy: serge-testsuite [27]

    Host 4:
       ✅ Boot test [0]
       ✅ kdump: sysrq-c - megaraid_sas [28]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/vxlan/basic
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [26]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [27]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [28]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
