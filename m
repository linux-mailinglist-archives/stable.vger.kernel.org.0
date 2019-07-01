Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3BC1C8CD
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfENMdx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 May 2019 08:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfENMdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 08:33:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3804B3092659
        for <stable@vger.kernel.org>; Tue, 14 May 2019 12:33:52 +0000 (UTC)
Received: from [172.54.121.115] (cpt-large-cpu-04.paas.prod.upshift.rdu2.redhat.com [10.0.18.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C25605D6A6;
        Tue, 14 May 2019 12:33:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.AB24423427.PAZJI3WLR2@redhat.com>
X-Gitlab-Pipeline-ID: 9926
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9926
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 14 May 2019 12:33:52 +0000 (UTC)
Date:   Tue, 14 May 2019 08:33:52 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: b724e9356404 - Linux 5.1.1

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
  Commit: b724e9356404 - Linux 5.1.1

We then merged the patchset with `git am`:

  platform-x86-sony-laptop-fix-unintentional-fall-through.patch
  platform-x86-thinkpad_acpi-disable-bluetooth-for-some-machines.patch
  platform-x86-dell-laptop-fix-rfkill-functionality.patch
  hwmon-pwm-fan-disable-pwm-if-fetching-cooling-data-fails.patch
  hwmon-occ-fix-extended-status-bits.patch
  selftests-seccomp-handle-namespace-failures-gracefully.patch
  i2c-core-ratelimit-transfer-when-suspended-errors.patch
  kernfs-fix-barrier-usage-in-__kernfs_new_node.patch
  virt-vbox-sanity-check-parameter-types-for-hgcm-calls-coming-from-userspace.patch
  usb-serial-fix-unthrottle-races.patch
  mwl8k-fix-rate_idx-underflow.patch
  rtlwifi-rtl8723ae-fix-missing-break-in-switch-statement.patch
  mm-memory_hotplug-do-not-unlock-when-fails-to-take-the-device_hotplug_lock.patch
  don-t-jump-to-compute_result-state-from-check_result-state.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-07cde30453c1504213fb40197c87ab1b38e25d15.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-07cde30453c1504213fb40197c87ab1b38e25d15.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-07cde30453c1504213fb40197c87ab1b38e25d15.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-07cde30453c1504213fb40197c87ab1b38e25d15.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-07cde30453c1504213fb40197c87ab1b38e25d15.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-07cde30453c1504213fb40197c87ab1b38e25d15.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-07cde30453c1504213fb40197c87ab1b38e25d15.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-07cde30453c1504213fb40197c87ab1b38e25d15.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     🚧 ✅ selinux-policy: serge-testsuite [7]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [8]
     🚧 ✅ stress: stress-ng [9]
     🚧 ✅ selinux-policy: serge-testsuite [7]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
