Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663B655F76
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfFZDVb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 25 Jun 2019 23:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfFZDVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:21:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A3071368E6
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 03:21:30 +0000 (UTC)
Received: from [172.54.58.4] (cpt-1026.paas.prod.upshift.rdu2.redhat.com [10.0.19.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E2AF5C1A1;
        Wed, 26 Jun 2019 03:21:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.ABCC436F4A.GTCKDP2BSL@redhat.com>
X-Gitlab-Pipeline-ID: 13248
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 26 Jun 2019 03:21:30 +0000 (UTC)
Date:   Tue, 25 Jun 2019 23:21:31 -0400
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


We grabbed the 3773c1b5b5c3 commit of the stable queue repository.

We then merged the patchset with `git am`:

  perf-ui-helpline-use-strlcpy-as-a-shorter-form-of-strncpy-explicit-set-nul.patch
  perf-help-remove-needless-use-of-strncpy.patch
  perf-header-fix-unchecked-usage-of-strncpy.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-168974096085c3cab9f0c89dd756773ecaaeb708.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-168974096085c3cab9f0c89dd756773ecaaeb708.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-168974096085c3cab9f0c89dd756773ecaaeb708.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-168974096085c3cab9f0c89dd756773ecaaeb708.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-168974096085c3cab9f0c89dd756773ecaaeb708.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-168974096085c3cab9f0c89dd756773ecaaeb708.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-168974096085c3cab9f0c89dd756773ecaaeb708.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-168974096085c3cab9f0c89dd756773ecaaeb708.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [7]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [8]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [7]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [8]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [8]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [7]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [7]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [8]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
