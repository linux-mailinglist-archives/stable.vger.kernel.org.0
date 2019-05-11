Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843021A66A
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 05:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfEKDlz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 10 May 2019 23:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbfEKDlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 23:41:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E75E308338E
        for <stable@vger.kernel.org>; Sat, 11 May 2019 03:41:54 +0000 (UTC)
Received: from [172.54.105.48] (cpt-0019.paas.prod.upshift.rdu2.redhat.com [10.0.18.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E1C92C6BF;
        Sat, 11 May 2019 03:41:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.EF4DA1053F.RY78TZMXFL@redhat.com>
X-Gitlab-Pipeline-ID: 9725
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9725
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 11 May 2019 03:41:54 +0000 (UTC)
Date:   Fri, 10 May 2019 23:41:55 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 9c2556f428cf - Linux 4.19.42

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
  Commit: 9c2556f428cf - Linux 4.19.42

We then merged the patchset with `git am`:

  bfq-update-internal-depth-state-when-queue-depth-cha.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-a94087ea875a88f434108c4a3b5d898aae80213f.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-a94087ea875a88f434108c4a3b5d898aae80213f.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-a94087ea875a88f434108c4a3b5d898aae80213f.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-a94087ea875a88f434108c4a3b5d898aae80213f.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-a94087ea875a88f434108c4a3b5d898aae80213f.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-a94087ea875a88f434108c4a3b5d898aae80213f.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-a94087ea875a88f434108c4a3b5d898aae80213f.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-a94087ea875a88f434108c4a3b5d898aae80213f.tar.gz


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
     ✅ lvm thinp sanity [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ lvm thinp sanity [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ lvm thinp sanity [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ lvm thinp sanity [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
