Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95411B3AE
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 12:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfEMKLI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 13 May 2019 06:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbfEMKLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 06:11:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7EC63082E24
        for <stable@vger.kernel.org>; Mon, 13 May 2019 10:11:07 +0000 (UTC)
Received: from [172.54.105.48] (cpt-0019.paas.prod.upshift.rdu2.redhat.com [10.0.18.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F9C81835C;
        Mon, 13 May 2019 10:11:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.1638B2B3B2.5480FS7KAI@redhat.com>
X-Gitlab-Pipeline-ID: 9756
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9756
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 13 May 2019 10:11:07 +0000 (UTC)
Date:   Mon, 13 May 2019 06:11:08 -0400
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
  platform-x86-sony-laptop-fix-unintentional-fall-through.patch
  platform-x86-thinkpad_acpi-disable-bluetooth-for-some-machines.patch
  platform-x86-dell-laptop-fix-rfkill-functionality.patch
  hwmon-pwm-fan-disable-pwm-if-fetching-cooling-data-fails.patch
  kernfs-fix-barrier-usage-in-__kernfs_new_node.patch
  virt-vbox-sanity-check-parameter-types-for-hgcm-calls-coming-from-userspace.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-5d9779f1baa858ae7081b0d20a8741b5a07b1f22.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ lvm thinp sanity [7]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [10]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ lvm thinp sanity [7]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [10]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ lvm thinp sanity [7]
     🚧 ✅ selinux-policy: serge-testsuite [10]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ lvm thinp sanity [7]
     🚧 ✅ selinux-policy: serge-testsuite [10]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
