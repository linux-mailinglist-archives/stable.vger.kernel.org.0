Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F31B18253
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 00:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfEHWko convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 8 May 2019 18:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfEHWko (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 18:40:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCC213092649
        for <stable@vger.kernel.org>; Wed,  8 May 2019 22:40:43 +0000 (UTC)
Received: from [172.54.42.34] (cpt-0010.paas.prod.upshift.rdu2.redhat.com [10.0.18.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 621D062671;
        Wed,  8 May 2019 22:40:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 4.19.41-rc1-721c545.cki
 (stable)
Message-ID: <cki.D9C3C37075.4ZHPVBFDGL@redhat.com>
X-Gitlab-Pipeline-ID: 9554
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9554
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 08 May 2019 22:40:43 +0000 (UTC)
Date:   Wed, 8 May 2019 18:40:44 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: f897c76a347c - Linux 4.19.41-rc1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-f897c76a347c330cca7fc03afaa64164eda545f7.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-f897c76a347c330cca7fc03afaa64164eda545f7.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-f897c76a347c330cca7fc03afaa64164eda545f7.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-f897c76a347c330cca7fc03afaa64164eda545f7.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-f897c76a347c330cca7fc03afaa64164eda545f7.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-f897c76a347c330cca7fc03afaa64164eda545f7.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-f897c76a347c330cca7fc03afaa64164eda545f7.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-f897c76a347c330cca7fc03afaa64164eda545f7.tar.gz


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

  s390x:
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
     ✅ Boot test [0]
     🚧 ✅ Networking route: pmtu [14]
     🚧 ✅ audit: audit testsuite test [15]
     🚧 ✅ Storage blktests [16]
     🚧 ✅ stress: stress-ng [17]
     🚧 ✅ kdump: sysrq-c [19]
     🚧 ✅ selinux-policy: serge-testsuite [18]

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
