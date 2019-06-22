Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C6B4F76D
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 19:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfFVRcJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Jun 2019 13:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfFVRcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 13:32:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11C323086258
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 17:32:09 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE2CC19C6A;
        Sat, 22 Jun 2019 17:32:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.126AECF00F.1S5F1IRNFZ@redhat.com>
X-Gitlab-Pipeline-ID: 13050
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sat, 22 Jun 2019 17:32:09 +0000 (UTC)
Date:   Sat, 22 Jun 2019 13:32:09 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 78778071092e - Linux 4.19.55

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
  Commit: 78778071092e - Linux 4.19.55


We grabbed the 753914230ffb commit of the stable queue repository.

We then merged the patchset with `git am`:

  tracing-silence-gcc-9-array-bounds-warning.patch
  objtool-support-per-function-rodata-sections.patch
  gcc-9-silence-address-of-packed-member-warning.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-4d9cb72a9736d6dff282b19f248cca1add79282f.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-4d9cb72a9736d6dff282b19f248cca1add79282f.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-4d9cb72a9736d6dff282b19f248cca1add79282f.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-4d9cb72a9736d6dff282b19f248cca1add79282f.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-4d9cb72a9736d6dff282b19f248cca1add79282f.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-4d9cb72a9736d6dff282b19f248cca1add79282f.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-4d9cb72a9736d6dff282b19f248cca1add79282f.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-4d9cb72a9736d6dff282b19f248cca1add79282f.tar.gz


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
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [9]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [9]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [9]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       🚧 ✅ tuned: tune-processes-through-perf [8]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ AMTU (Abstract Machine Test Utility) [2]
       ✅ LTP: openposix test suite [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ Usex - version 1.9-29 [7]
       🚧 ✅ tuned: tune-processes-through-perf [8]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [9]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
