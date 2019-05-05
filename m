Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD83414072
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfEEPFH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 May 2019 11:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbfEEPFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 11:05:07 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DD8C3082E56
        for <stable@vger.kernel.org>; Sun,  5 May 2019 15:05:07 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6407060C18;
        Sun,  5 May 2019 15:05:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.47CFEDE164.QJRCI8UTAJ@redhat.com>
X-Gitlab-Pipeline-ID: 9350
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9350
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sun, 05 May 2019 15:05:07 +0000 (UTC)
Date:   Sun, 5 May 2019 11:05:07 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e5b9547b1aa3 - Linux 5.0.13

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

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: e5b9547b1aa3 - Linux 5.0.13

We then merged the patchset with `git am`:

  selftests-seccomp-prepare-for-exclusive-seccomp-flags.patch
  seccomp-make-new_listener-and-tsync-flags-exclusive.patch
  arc-memset-fix-build-with-l1_cache_shift-6.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-cc07d5c1fe22528cfa0b466a1c2b36a7c656a34b.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
