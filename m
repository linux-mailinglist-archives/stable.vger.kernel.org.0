Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DAA28EF9
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 04:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfEXCEG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 22:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731617AbfEXCEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 22:04:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDAF334CF
        for <stable@vger.kernel.org>; Fri, 24 May 2019 02:04:05 +0000 (UTC)
Received: from [172.54.114.147] (cpt-0011.paas.prod.upshift.rdu2.redhat.com [10.0.18.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ACBC5C230;
        Fri, 24 May 2019 02:04:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.5-rc1-089370e.cki
 (stable)
Message-ID: <cki.0F672B6956.8HZN124XPL@redhat.com>
X-Gitlab-Pipeline-ID: 10733
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10733?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 24 May 2019 02:04:05 +0000 (UTC)
Date:   Thu, 23 May 2019 22:04:06 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: ad8ad5ad6200 - Linux 5.1.5-rc1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-ad8ad5ad6200a933bc774415620bb31dd8b2da66.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-ad8ad5ad6200a933bc774415620bb31dd8b2da66.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-ad8ad5ad6200a933bc774415620bb31dd8b2da66.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-ad8ad5ad6200a933bc774415620bb31dd8b2da66.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-ad8ad5ad6200a933bc774415620bb31dd8b2da66.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-ad8ad5ad6200a933bc774415620bb31dd8b2da66.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-ad8ad5ad6200a933bc774415620bb31dd8b2da66.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-ad8ad5ad6200a933bc774415620bb31dd8b2da66.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:

  ppc64le:
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
     🚧 ✅ Networking route: pmtu [19]
     🚧 ✅ Networking route_func: local [20]
     🚧 ✅ Networking route_func: forward [20]
     🚧 ✅ Networking TCP: keepalive test [21]
     🚧 ✅ Networking UDP: socket [22]
     🚧 ✅ networking tunnel: geneve basic test [23]
     🚧 ✅ Networking ipsec: basic netns tunnel [24]
     🚧 ✅ Storage blktests [25]

  s390x:

  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

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
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/udp/udp_socket
    [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/tunnel/geneve/basic
    [24]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [25]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
