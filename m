Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12816116C4
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 11:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfEBJ4w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 2 May 2019 05:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4387 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfEBJ4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 05:56:51 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66BAA3087940
        for <stable@vger.kernel.org>; Thu,  2 May 2019 09:56:51 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A05DA21B;
        Thu,  2 May 2019 09:56:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.47C4576842.EGKZNGSO8T@redhat.com>
X-Gitlab-Pipeline-ID: 9123
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9123
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 02 May 2019 09:56:51 +0000 (UTC)
Date:   Thu, 2 May 2019 05:56:51 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d5a2675b207d - Linux 5.0.11

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
  Commit: d5a2675b207d - Linux 5.0.11

We then merged the patchset with `git am`:

  selinux-use-kernel-linux-socket.h-for-genheaders-and-mdp.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-9d1283a4b8ba2ad2f1b935e20ce9d4a4c7f8916f.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [6]
     🚧 ✅ stress: stress-ng [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [6]
     🚧 ✅ stress: stress-ng [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [6]
     🚧 ✅ stress: stress-ng [7]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [6]
     🚧 ✅ stress: stress-ng [7]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
