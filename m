Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096F54F4C1
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFVJeO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 22 Jun 2019 05:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfFVJeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:34:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33C8D5AFD9
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 09:34:13 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0DD51001B04;
        Sat, 22 Jun 2019 09:34:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.195B424D38.PKRJQICH8B@redhat.com>
X-Gitlab-Pipeline-ID: 13037
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sat, 22 Jun 2019 09:34:13 +0000 (UTC)
Date:   Sat, 22 Jun 2019 05:34:13 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7da3d9e6cd75 - Linux 5.1.13

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
  Commit: 7da3d9e6cd75 - Linux 5.1.13


We grabbed the 3c4da58feeac commit of the stable queue repository.

We then merged the patchset with `git am`:

  tcp-refine-memory-limit-test-in-tcp_fragment.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-08b45788bb575c0a7e837e22a612d2bc0938d209.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-08b45788bb575c0a7e837e22a612d2bc0938d209.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-08b45788bb575c0a7e837e22a612d2bc0938d209.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-08b45788bb575c0a7e837e22a612d2bc0938d209.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-08b45788bb575c0a7e837e22a612d2bc0938d209.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-08b45788bb575c0a7e837e22a612d2bc0938d209.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-08b45788bb575c0a7e837e22a612d2bc0938d209.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-08b45788bb575c0a7e837e22a612d2bc0938d209.tar.gz


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
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking TCP: keepalive test [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]


  ppc64le:
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
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking TCP: keepalive test [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]


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
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking TCP: keepalive test [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]


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
       🚧 ✅ Networking socket: fuzz [8]
       🚧 ✅ Networking TCP: keepalive test [9]
       🚧 ✅ tuned: tune-processes-through-perf [10]


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
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
