Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771A3471B8
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfFOSvo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Jun 2019 14:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOSvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 14:51:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEEC930821F9
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 18:51:43 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 427B760852;
        Sat, 15 Jun 2019 18:51:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
CC:     Petr Sklenar <psklenar@redhat.com>
Message-ID: <cki.E44E909028.14UCKSU2MQ@redhat.com>
X-Gitlab-Pipeline-ID: 12448
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12448?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 15 Jun 2019 18:51:43 +0000 (UTC)
Date:   Sat, 15 Jun 2019 14:51:44 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7aa823a959e1 - Linux 4.19.51

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED


One or more kernel tests failed:

  aarch64:
    ❎ tuned: tune-processes-through-perf

  ppc64le:
    ❎ tuned: tune-processes-through-perf

  s390x:
    ❎ tuned: tune-processes-through-perf

  x86_64:
    ❎ tuned: tune-processes-through-perf

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

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
  Commit: 7aa823a959e1 - Linux 4.19.51


We then merged the patchset with `git am`:

  drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
  nouveau-fix-build-with-config_nouveau_legacy_ctx_support-disabled.patch
  hid-multitouch-handle-faulty-elo-touch-device.patch
  hid-wacom-don-t-set-tool-type-until-we-re-in-range.patch
  hid-wacom-don-t-report-anything-prior-to-the-tool-entering-range.patch
  hid-wacom-send-btn_touch-in-response-to-intuosp2_bt-eraser-contact.patch
  hid-wacom-correct-button-numbering-2nd-gen-intuos-pro-over-bluetooth.patch
  hid-wacom-sync-intuosp2_bt-touch-state-after-each-frame-if-necessary.patch
  revert-alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  alsa-oxfw-allow-pcm-capture-for-stanton-scs.1m.patch
  alsa-hda-realtek-update-headset-mode-for-alc256.patch
  alsa-firewire-motu-fix-destruction-of-data-for-isochronous-resources.patch
  libata-extend-quirks-for-the-st1000lm024-drives-with-nolpm-quirk.patch
  mm-list_lru.c-fix-memory-leak-in-__memcg_init_list_lru_node.patch
  fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch
  mm-vmscan.c-fix-trying-to-reclaim-unevictable-lru-page.patch
  signal-ptrace-don-t-leak-unitialized-kernel-memory-with-ptrace_peek_siginfo.patch
  ptrace-restore-smp_rmb-in-__ptrace_may_access.patch
  iommu-arm-smmu-avoid-constant-zero-in-tlbi-writes.patch
  i2c-acorn-fix-i2c-warning.patch
  bcache-fix-stack-corruption-by-preceding_key.patch
  bcache-only-set-bcache_dev_wb_running-when-cached-device-attached.patch
  cgroup-use-css_tryget-instead-of-css_tryget_online-in-task_get_css.patch
  asoc-cs42xx8-add-regcache-mask-dirty.patch
  asoc-fsl_asrc-fix-the-issue-about-unsupported-rate.patch
  drm-i915-sdvo-implement-proper-hdmi-audio-support-for-sdvo.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3545b8c93e947e1224a5062e05e13c160caac7d9.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3545b8c93e947e1224a5062e05e13c160caac7d9.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3545b8c93e947e1224a5062e05e13c160caac7d9.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3545b8c93e947e1224a5062e05e13c160caac7d9.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3545b8c93e947e1224a5062e05e13c160caac7d9.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3545b8c93e947e1224a5062e05e13c160caac7d9.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3545b8c93e947e1224a5062e05e13c160caac7d9.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3545b8c93e947e1224a5062e05e13c160caac7d9.tar.gz


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
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ❎ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ storage: software RAID testing [10]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ❎ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ storage: software RAID testing [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ❎ tuned: tune-processes-through-perf [8]
       🚧 ✅ storage: software RAID testing [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ❎ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       🚧 ✅ storage: software RAID testing [10]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
