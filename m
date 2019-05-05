Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B803140A2
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 17:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfEEPb0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 May 2019 11:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfEEPb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 11:31:26 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 253DE309B165
        for <stable@vger.kernel.org>; Sun,  5 May 2019 15:31:26 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAA76611C7;
        Sun,  5 May 2019 15:31:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.154A73DCF5.P4HW2LJXB3@redhat.com>
X-Gitlab-Pipeline-ID: 9351
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9351
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sun, 05 May 2019 15:31:26 +0000 (UTC)
Date:   Sun, 5 May 2019 11:31:26 -0400
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
  iwlwifi-fix-driver-operation-for-5350.patch
  mwifiex-make-resume-actually-do-something-useful-again-on-sdio-cards.patch
  mtd-rawnand-marvell-clean-the-controller-state-before-each-operation.patch
  mac80211-don-t-attempt-to-rename-err_ptr-debugfs-dirs.patch
  i2c-synquacer-fix-enumeration-of-slave-devices.patch
  i2c-imx-correct-the-method-of-getting-private-data-in-notifier_call.patch
  i2c-prevent-runtime-suspend-of-adapter-when-host-notify-is-required.patch
  alsa-hda-realtek-add-new-dell-platform-for-headset-mode.patch
  alsa-hda-realtek-fixed-dell-aio-speaker-noise.patch
  alsa-hda-realtek-apply-the-fixup-for-asus-q325uar.patch
  usb-yurex-fix-protection-fault-after-device-removal.patch
  usb-w1-ds2490-fix-bug-caused-by-improper-use-of-altsetting-array.patch
  usb-dummy-hcd-fix-failure-to-give-back-unlinked-urbs.patch
  usb-usbip-fix-isoc-packet-num-validation-in-get_pipe.patch
  usb-core-fix-unterminated-string-returned-by-usb_string.patch
  usb-core-fix-bug-caused-by-duplicate-interface-pm-usage-counter.patch
  kvm-lapic-disable-timer-advancement-if-adaptive-tuning-goes-haywire.patch
  kvm-x86-consider-lapic-tsc-deadline-timer-expired-if-deadline-too-short.patch
  kvm-lapic-track-lapic-timer-advance-per-vcpu.patch
  kvm-lapic-allow-user-to-disable-adaptive-tuning-of-timer-advancement.patch
  kvm-lapic-convert-guest-tsc-to-host-time-domain-if-necessary.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-aec790dbdfc795a6ed19919743f285c57d331b72.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-aec790dbdfc795a6ed19919743f285c57d331b72.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-aec790dbdfc795a6ed19919743f285c57d331b72.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-aec790dbdfc795a6ed19919743f285c57d331b72.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-aec790dbdfc795a6ed19919743f285c57d331b72.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-aec790dbdfc795a6ed19919743f285c57d331b72.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-aec790dbdfc795a6ed19919743f285c57d331b72.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-aec790dbdfc795a6ed19919743f285c57d331b72.tar.gz


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
     ✅ Usex - version 1.9-29 [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [7]
     🚧 ✅ stress: stress-ng [8]
     🚧 ✅ selinux-policy: serge-testsuite [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [7]
     🚧 ✅ stress: stress-ng [8]
     🚧 ✅ selinux-policy: serge-testsuite [9]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [9]
     🚧 ✅ audit: audit testsuite test [7]
     🚧 ✅ stress: stress-ng [8]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ httpd: mod_ssl smoke sanity [3]
     ✅ iotop: sanity [4]
     ✅ tuned: tune-processes-through-perf [5]
     ✅ Usex - version 1.9-29 [6]
     🚧 ✅ selinux-policy: serge-testsuite [9]
     🚧 ✅ audit: audit testsuite test [7]
     🚧 ✅ stress: stress-ng [8]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
