Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E41892F
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 13:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfEILmQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 May 2019 07:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfEILmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 07:42:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08F37F74BF
        for <stable@vger.kernel.org>; Thu,  9 May 2019 11:42:16 +0000 (UTC)
Received: from [172.54.42.34] (cpt-0010.paas.prod.upshift.rdu2.redhat.com [10.0.18.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCDE3643EA;
        Thu,  9 May 2019 11:42:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Test report for kernel 4.19.42-rc1-65f453a.cki
 (stable)
Message-ID: <cki.9374FF4589.AWI2F081T9@redhat.com>
X-Gitlab-Pipeline-ID: 9574
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9574
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 09 May 2019 11:42:16 +0000 (UTC)
Date:   Thu, 9 May 2019 07:42:16 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a recent commit from this kernel tree:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
            Commit: 487b15502665 - Linux 4.19.42-rc1

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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-487b15502665ed34010b1e79164938fbeba123f0.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable-aarch64-487b15502665ed34010b1e79164938fbeba123f0.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-487b15502665ed34010b1e79164938fbeba123f0.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable-ppc64le-487b15502665ed34010b1e79164938fbeba123f0.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-487b15502665ed34010b1e79164938fbeba123f0.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable-s390x-487b15502665ed34010b1e79164938fbeba123f0.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-487b15502665ed34010b1e79164938fbeba123f0.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable-x86_64-487b15502665ed34010b1e79164938fbeba123f0.tar.gz


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
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ audit: audit testsuite test [16]
     🚧 ✅ Storage blktests [17]
     🚧 ✅ stress: stress-ng [18]

  ppc64le:
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
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ audit: audit testsuite test [16]
     🚧 ✅ Storage blktests [17]
     🚧 ✅ stress: stress-ng [18]
     🚧 ✅ selinux-policy: serge-testsuite [14]

  s390x:
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
     ✅ Boot test [0]
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ audit: audit testsuite test [16]
     🚧 ✅ Storage blktests [17]
     🚧 ✅ stress: stress-ng [18]
     🚧 ✅ selinux-policy: serge-testsuite [14]

  x86_64:
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
     ✅ Boot test [0]
     ✅ xfstests: ext4 [1]
     ✅ xfstests: xfs [1]
     ✅ Boot test [0]
     🚧 ✅ kdump: sysrq-c [19]
     🚧 ✅ Networking route: pmtu [15]
     🚧 ✅ audit: audit testsuite test [16]
     🚧 ✅ Storage blktests [17]
     🚧 ✅ stress: stress-ng [18]
     🚧 ✅ selinux-policy: serge-testsuite [14]
     🚧 ✅ kdump: sysrq-c - megaraid_sas [19]

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
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/kdump/kdump-sysrq-c

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
