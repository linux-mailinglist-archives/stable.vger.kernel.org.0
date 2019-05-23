Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2127EC1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfEWNvF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 09:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbfEWNvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 09:51:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E66B3308793B
        for <stable@vger.kernel.org>; Thu, 23 May 2019 13:51:04 +0000 (UTC)
Received: from [172.54.114.147] (cpt-0011.paas.prod.upshift.rdu2.redhat.com [10.0.18.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47B185D9C3;
        Thu, 23 May 2019 13:51:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.4-59a646a.cki
 (stable)
Message-ID: <cki.652954638A.V2F3P3G0SD@redhat.com>
X-Gitlab-Pipeline-ID: 10678
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10678?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 23 May 2019 13:51:04 +0000 (UTC)
Date:   Thu, 23 May 2019 09:51:05 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: e0e8106a6cf1 - Linux 5.1.4

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-e0e8106a6cf13b6abfccf6dac15bac32c9513f3e.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
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
     ✅ Boot test [0]
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
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
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
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

  x86_64:
     ✅ Boot test [0]
     ✅ kdump: sysrq-c - megaraid_sas [27]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [15]
     ✅ xfstests: xfs [15]
     ✅ selinux-policy: serge-testsuite [16]
     ✅ Boot test [0]
     ✅ kdump: sysrq-c [27]
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
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
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
