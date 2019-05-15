Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1BC1F41E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfEOMUt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 May 2019 08:20:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfEOMUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 08:20:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E54F307CDC1
        for <stable@vger.kernel.org>; Wed, 15 May 2019 12:20:47 +0000 (UTC)
Received: from [172.54.252.220] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D08C1001E61;
        Wed, 15 May 2019 12:20:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 4.19.44-rc1-a18efe7.cki
 (stable)
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.F2949DC56A.Z3JIE1A4QR@redhat.com>
X-Gitlab-Pipeline-ID: 10114
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10114?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 15 May 2019 12:20:47 +0000 (UTC)
Date:   Wed, 15 May 2019 08:20:47 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: b5001f5eab58 - Linux 4.19.44-rc1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ Boot test [0]
     ✅ LTP lite [2]
     ✅ Loopdev Sanity [3]
     ✅ Memory function: memfd_create [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ httpd: mod_ssl smoke sanity [7]
     ✅ iotop: sanity [8]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
     ✅ tuned: tune-processes-through-perf [11]
     ✅ Usex - version 1.9-29 [12]
     ✅ lvm thinp sanity [13]
     🚧 ✅ selinux-policy: serge-testsuite [14]
     🚧 ✅ Networking sctp-auth: sockopts test [15]
     🚧 ✅ Networking: igmp conformance test [16]
     🚧 ✅ Networking route: pmtu [17]
     🚧 ✅ Networking TCP: keepalive test [18]
     🚧 ✅ audit: audit testsuite test [19]
     🚧 ✅ Storage blktests [20]
     🚧 ✅ stress: stress-ng [21]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ Boot test [0]
     ✅ LTP lite [2]
     ✅ Loopdev Sanity [3]
     ✅ Memory function: memfd_create [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ httpd: mod_ssl smoke sanity [7]
     ✅ iotop: sanity [8]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
     ✅ tuned: tune-processes-through-perf [11]
     ✅ Usex - version 1.9-29 [12]
     ✅ lvm thinp sanity [13]
     🚧 ✅ selinux-policy: serge-testsuite [14]
     🚧 ✅ Networking sctp-auth: sockopts test [15]
     🚧 ✅ Networking route: pmtu [17]
     🚧 ✅ Networking TCP: keepalive test [18]
     🚧 ✅ audit: audit testsuite test [19]
     🚧 ✅ Storage blktests [20]
     🚧 ✅ stress: stress-ng [21]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [2]
     ✅ Loopdev Sanity [3]
     ✅ Memory function: memfd_create [4]
     ✅ Ethernet drivers sanity [6]
     ✅ httpd: mod_ssl smoke sanity [7]
     ✅ iotop: sanity [8]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
     ✅ tuned: tune-processes-through-perf [11]
     ✅ Usex - version 1.9-29 [12]
     ✅ lvm thinp sanity [13]
     🚧 ✅ selinux-policy: serge-testsuite [14]
     🚧 ✅ kdump: sysrq-c [22]
     🚧 ✅ Networking sctp-auth: sockopts test [15]
     🚧 ✅ Networking: igmp conformance test [16]
     🚧 ✅ Networking route: pmtu [17]
     🚧 ✅ Networking TCP: keepalive test [18]
     🚧 ✅ audit: audit testsuite test [19]
     🚧 ❎ Storage blktests [20]
     🚧 ✅ stress: stress-ng [21]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [2]
     ✅ Loopdev Sanity [3]
     ✅ Memory function: memfd_create [4]
     ✅ AMTU (Abstract Machine Test Utility) [5]
     ✅ Ethernet drivers sanity [6]
     ✅ httpd: mod_ssl smoke sanity [7]
     ✅ iotop: sanity [8]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [9]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [10]
     ✅ tuned: tune-processes-through-perf [11]
     ✅ Usex - version 1.9-29 [12]
     ✅ lvm thinp sanity [13]
     🚧 ✅ kdump: sysrq-c - megaraid_sas [22]
     🚧 ✅ selinux-policy: serge-testsuite [14]
     🚧 ✅ kdump: sysrq-c [22]
     🚧 ✅ Networking sctp-auth: sockopts test [15]
     🚧 ✅ Networking: igmp conformance test [16]
     🚧 ✅ Networking route: pmtu [17]
     🚧 ✅ Networking TCP: keepalive test [18]
     🚧 ✅ audit: audit testsuite test [19]
     🚧 ✅ Storage blktests [20]
     🚧 ✅ stress: stress-ng [21]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
