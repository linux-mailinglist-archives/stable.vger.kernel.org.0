Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5795674B
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFZK7F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 26 Jun 2019 06:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZK7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 06:59:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C09B07FDCA
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 10:59:04 +0000 (UTC)
Received: from [172.54.58.4] (cpt-1026.paas.prod.upshift.rdu2.redhat.com [10.0.19.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F34A100194A;
        Wed, 26 Jun 2019 10:59:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.9507B83390.MZ5KWR3W00@redhat.com>
X-Gitlab-Pipeline-ID: 13260
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 26 Jun 2019 10:59:04 +0000 (UTC)
Date:   Wed, 26 Jun 2019 06:59:05 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: aec3002d07fd - Linux 4.19.56

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
  Commit: aec3002d07fd - Linux 4.19.56


We grabbed the 75a33cedea47 commit of the stable queue repository.

We then merged the patchset with `git am`:

  perf-ui-helpline-use-strlcpy-as-a-shorter-form-of-strncpy-explicit-set-nul.patch
  perf-help-remove-needless-use-of-strncpy.patch
  perf-header-fix-unchecked-usage-of-strncpy.patch
  arm64-don-t-unconditionally-add-wno-psabi-to-kbuild_cflags.patch
  revert-x86-uaccess-ftrace-fix-ftrace_likely_update-v.patch
  ib-hfi1-close-psm-sdma_progress-sleep-window.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-e3c96ba0e9c54400082ac4392a685bd662857f46.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-e3c96ba0e9c54400082ac4392a685bd662857f46.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-e3c96ba0e9c54400082ac4392a685bd662857f46.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-e3c96ba0e9c54400082ac4392a685bd662857f46.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-e3c96ba0e9c54400082ac4392a685bd662857f46.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-e3c96ba0e9c54400082ac4392a685bd662857f46.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-e3c96ba0e9c54400082ac4392a685bd662857f46.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-e3c96ba0e9c54400082ac4392a685bd662857f46.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       🚧 ✅ tuned: tune-processes-through-perf [9]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ LTP: openposix test suite [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ tuned: tune-processes-through-perf [9]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
