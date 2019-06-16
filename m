Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19201475B2
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 18:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfFPQBm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 16 Jun 2019 12:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfFPQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 12:01:42 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4E9B81F0F
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 16:01:41 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 606EF17165;
        Sun, 16 Jun 2019 16:01:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
CC:     Petr Sklenar <psklenar@redhat.com>
Message-ID: <cki.D63AFC48B7.30EPEIHBMB@redhat.com>
X-Gitlab-Pipeline-ID: 12466
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12466?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Sun, 16 Jun 2019 16:01:41 +0000 (UTC)
Date:   Sun, 16 Jun 2019 12:01:42 -0400
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
  x86-uaccess-kcov-disable-stack-protector.patch
  alsa-seq-protect-in-kernel-ioctl-calls-with-mutex.patch
  alsa-seq-fix-race-of-get-subscription-call-vs-port-d.patch
  revert-alsa-seq-protect-in-kernel-ioctl-calls-with-m.patch
  s390-kasan-fix-strncpy_from_user-kasan-checks.patch
  drivers-misc-fix-out-of-bounds-access-in-function-pa.patch
  f2fs-fix-to-avoid-accessing-xattr-across-the-boundar.patch
  scsi-qedi-remove-memset-memcpy-to-nfunc-and-use-func.patch
  scsi-qedi-remove-set-but-not-used-variables-cdev-and.patch
  scsi-lpfc-correct-rcu-unlock-issue-in-lpfc_nvme_info.patch
  scsi-lpfc-add-check-for-loss-of-ndlp-when-sending-rr.patch
  arm64-mm-inhibit-huge-vmap-with-ptdump.patch
  nvme-fix-srcu-locking-on-error-return-in-nvme_get_ns.patch
  nvme-remove-the-ifdef-around-nvme_nvm_ioctl.patch
  nvme-merge-nvme_ns_ioctl-into-nvme_ioctl.patch
  nvme-release-namespace-srcu-protection-before-perfor.patch
  nvme-fix-memory-leak-for-power-latency-tolerance.patch
  platform-x86-pmc_atom-add-lex-3i380d-industrial-pc-t.patch
  platform-x86-pmc_atom-add-several-beckhoff-automatio.patch
  scsi-bnx2fc-fix-incorrect-cast-to-u64-on-shift-opera.patch
  libnvdimm-fix-compilation-warnings-with-w-1.patch
  selftests-fib_rule_tests-fix-local-ipv4-address-typo.patch
  selftests-timers-add-missing-fflush-stdout-calls.patch
  tracing-prevent-hist_field_var_ref-from-accessing-nu.patch
  usbnet-ipheth-fix-racing-condition.patch
  kvm-arm-arm64-move-cc-it-checks-under-hyp-s-makefile.patch
  kvm-x86-pmu-mask-the-result-of-rdpmc-according-to-th.patch
  kvm-x86-pmu-do-not-mask-the-value-that-is-written-to.patch
  kvm-s390-fix-memory-slot-handling-for-kvm_set_user_m.patch
  tools-kvm_stat-fix-fields-filter-for-child-events.patch
  drm-vmwgfx-integer-underflow-in-vmw_cmd_dx_set_shader-leading-to-an-invalid-read.patch
  drm-vmwgfx-null-pointer-dereference-from-vmw_cmd_dx_view_define.patch
  usb-dwc2-fix-dma-cache-alignment-issues.patch
  usb-dwc2-host-fix-wmaxpacketsize-handling-fix-webcam-regression.patch
  usb-fix-chipmunk-like-voice-when-using-logitech-c270-for-recording-audio.patch
  usb-usb-storage-add-new-id-to-ums-realtek.patch
  usb-serial-pl2303-add-allied-telesis-vt-kit3.patch
  usb-serial-option-add-support-for-simcom-sim7500-sim7600-rndis-mode.patch
  usb-serial-option-add-telit-0x1260-and-0x1261-compositions.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-58f56310e0e2d66ce3ea8303baf2fd26fe278353.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-58f56310e0e2d66ce3ea8303baf2fd26fe278353.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-58f56310e0e2d66ce3ea8303baf2fd26fe278353.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-58f56310e0e2d66ce3ea8303baf2fd26fe278353.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-58f56310e0e2d66ce3ea8303baf2fd26fe278353.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-58f56310e0e2d66ce3ea8303baf2fd26fe278353.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-58f56310e0e2d66ce3ea8303baf2fd26fe278353.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-58f56310e0e2d66ce3ea8303baf2fd26fe278353.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ❎ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ storage: SCSI VPD [9]
       🚧 ✅ storage: software RAID testing [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ❎ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ storage: software RAID testing [10]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ❎ tuned: tune-processes-through-perf [7]
       🚧 ✅ storage: software RAID testing [10]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       🚧 ✅ Storage SAN device stress [12]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [11]

    Host 3:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ❎ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ storage: SCSI VPD [9]
       🚧 ✅ storage: software RAID testing [10]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
