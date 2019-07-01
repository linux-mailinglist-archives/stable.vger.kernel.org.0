Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615271A7E2
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfEKMqT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 11 May 2019 08:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfEKMqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 08:46:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37A5583F42
        for <stable@vger.kernel.org>; Sat, 11 May 2019 12:46:19 +0000 (UTC)
Received: from [172.54.105.48] (cpt-0019.paas.prod.upshift.rdu2.redhat.com [10.0.18.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B92BA6108E;
        Sat, 11 May 2019 12:46:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 5.1.1-6861bf3.cki
 (stable)
Message-ID: <cki.8D45814552.Q6UV0FSOH2@redhat.com>
X-Gitlab-Pipeline-ID: 9727
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9727
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sat, 11 May 2019 12:46:19 +0000 (UTC)
Date:   Sat, 11 May 2019 08:46:19 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: b724e9356404 - Linux 5.1.1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-b724e93564045d97ec1179d3acacdac60e658569.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-b724e93564045d97ec1179d3acacdac60e658569.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-b724e93564045d97ec1179d3acacdac60e658569.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-b724e93564045d97ec1179d3acacdac60e658569.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-b724e93564045d97ec1179d3acacdac60e658569.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-b724e93564045d97ec1179d3acacdac60e658569.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-b724e93564045d97ec1179d3acacdac60e658569.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-b724e93564045d97ec1179d3acacdac60e658569.tar.gz


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
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [8]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ lvm thinp sanity [12]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [13]
     ✅ xfstests: xfs [13]
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ audit: audit testsuite test [15]
     🚧 ✅ Storage blktests [16]
     🚧 ✅ stress: stress-ng [17]
     🚧 ✅ selinux-policy: serge-testsuite [18]

  ppc64le:
     ✅ Boot test [0]
     ✅ xfstests: ext4 [13]
     ✅ xfstests: xfs [13]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Memory function: memfd_create [3]
     ✅ AMTU (Abstract Machine Test Utility) [4]
     ✅ Ethernet drivers sanity [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [8]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ lvm thinp sanity [12]
     🚧 ✅ selinux-policy: serge-testsuite [18]
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ audit: audit testsuite test [15]
     🚧 ✅ Storage blktests [16]
     🚧 ✅ stress: stress-ng [17]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Memory function: memfd_create [3]
     ✅ Ethernet drivers sanity [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [8]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ lvm thinp sanity [12]
     ✅ Boot test [0]
     🚧 ✅ selinux-policy: serge-testsuite [18]
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ audit: audit testsuite test [15]
     🚧 ✅ Storage blktests [16]
     🚧 ✅ stress: stress-ng [17]
     🚧 ✅ kdump: sysrq-c [19]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Memory function: memfd_create [3]
     ✅ AMTU (Abstract Machine Test Utility) [4]
     ✅ Ethernet drivers sanity [5]
     ✅ httpd: mod_ssl smoke sanity [6]
     ✅ iotop: sanity [7]
     ✅ redhat-rpm-config: detect-kabi-provides sanity [8]
     ✅ redhat-rpm-config: kabi-whitelist-not-found sanity [9]
     ✅ tuned: tune-processes-through-perf [10]
     ✅ Usex - version 1.9-29 [11]
     ✅ lvm thinp sanity [12]
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ xfstests: ext4 [13]
     ✅ xfstests: xfs [13]
     🚧 ✅ kdump: sysrq-c [19]
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ audit: audit testsuite test [15]
     🚧 ✅ Storage blktests [16]
     🚧 ✅ stress: stress-ng [17]
     🚧 ✅ kdump: sysrq-c - megaraid_sas [19]
     🚧 ✅ selinux-policy: serge-testsuite [18]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/memory/function/memfd_create
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/detect-kabi-provides
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/redhat-rpm-config/kabi-whitelist-not-found
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
