Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31DA47527
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 16:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFPOWO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 16 Jun 2019 10:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfFPOWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 10:22:14 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C42A659474
        for <stable@vger.kernel.org>; Sun, 16 Jun 2019 14:22:13 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 303D190C55;
        Sun, 16 Jun 2019 14:22:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-5.1
CC:     Petr Sklenar <psklenar@redhat.com>
Message-ID: <cki.59F9E4E860.MDCZ4Y8TH9@redhat.com>
X-Gitlab-Pipeline-ID: 12467
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12467?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sun, 16 Jun 2019 14:22:13 +0000 (UTC)
Date:   Sun, 16 Jun 2019 10:22:14 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7e1bdd68ffee - Linux 5.1.10

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
  Commit: 7e1bdd68ffee - Linux 5.1.10


We then merged the patchset with `git am`:

  drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
  nouveau-fix-build-with-config_nouveau_legacy_ctx_support-disabled.patch
  hid-input-make-sure-the-wheel-high-resolution-multiplier-is-set.patch
  hid-input-fix-assignment-of-.value.patch
  revert-hid-increase-maximum-report-size-allowed-by-hid_field_extract.patch
  hid-multitouch-handle-faulty-elo-touch-device.patch
  hid-wacom-don-t-set-tool-type-until-we-re-in-range.patch
  hid-wacom-don-t-report-anything-prior-to-the-tool-entering-range.patch
  hid-wacom-send-btn_touch-in-response-to-intuosp2_bt-eraser-contact.patch
  hid-wacom-correct-button-numbering-2nd-gen-intuos-pro-over-bluetooth.patch
  hid-wacom-sync-intuosp2_bt-touch-state-after-each-frame-if-necessary.patch
  revert-alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  alsa-oxfw-allow-pcm-capture-for-stanton-scs.1m.patch
  alsa-ice1712-check-correct-return-value-to-snd_i2c_sendbytes-ews-dmx-6fire.patch
  alsa-hda-realtek-update-headset-mode-for-alc256.patch
  alsa-firewire-motu-fix-destruction-of-data-for-isochronous-resources.patch
  selinux-log-raw-contexts-as-untrusted-strings.patch
  selinux-fix-a-missing-check-bug-in-selinux_add_mnt_opt.patch
  selinux-fix-a-missing-check-bug-in-selinux_sb_eat_lsm_opts.patch
  libata-extend-quirks-for-the-st1000lm024-drives-with-nolpm-quirk.patch
  io_uring-fix-memory-leak-of-unix-domain-socket-inode.patch
  mm-list_lru.c-fix-memory-leak-in-__memcg_init_list_lru_node.patch
  fs-ocfs2-fix-race-in-ocfs2_dentry_attach_lock.patch
  mm-vmscan.c-fix-trying-to-reclaim-unevictable-lru-page.patch
  signal-ptrace-don-t-leak-unitialized-kernel-memory-with-ptrace_peek_siginfo.patch
  ptrace-restore-smp_rmb-in-__ptrace_may_access.patch
  media-dvb-warning-about-dvb-frequency-limits-produces-too-much-noise.patch
  iommu-arm-smmu-avoid-constant-zero-in-tlbi-writes.patch
  smack-restore-the-smackfsdef-mount-option-and-add-missing-prefixes.patch
  i2c-acorn-fix-i2c-warning.patch
  bcache-fix-stack-corruption-by-preceding_key.patch
  bcache-only-set-bcache_dev_wb_running-when-cached-device-attached.patch
  cgroup-use-css_tryget-instead-of-css_tryget_online-in-task_get_css.patch
  asoc-cs42xx8-add-regcache-mask-dirty.patch
  asoc-fsl_asrc-fix-the-issue-about-unsupported-rate.patch
  asoc-soc-core-fixup-references-at-soc_cleanup_card_resources.patch
  drm-amdgpu-uvd-vcn-fetch-ring-s-read_ptr-after-alloc.patch
  drm-i915-sdvo-implement-proper-hdmi-audio-support-for-sdvo.patch
  drm-i915-dsi-use-a-fuzzy-check-for-burst-mode-clock-check.patch
  drm-i915-fix-per-pixel-alpha-with-ccs.patch
  drm-i915-dmc-protect-against-reading-random-memory.patch
  x86-uaccess-kcov-disable-stack-protector.patch
  alsa-seq-protect-in-kernel-ioctl-calls-with-mutex.patch
  alsa-seq-fix-race-of-get-subscription-call-vs-port-d.patch
  revert-alsa-seq-protect-in-kernel-ioctl-calls-with-m.patch
  drivers-misc-fix-out-of-bounds-access-in-function-pa.patch
  f2fs-fix-to-avoid-accessing-xattr-across-the-boundar.patch
  drivers-perf-arm_spe-don-t-error-on-high-order-pages.patch
  bpf-sockmap-only-stop-flush-strp-if-it-was-enabled-a.patch
  bpf-sockmap-remove-duplicate-queue-free.patch
  bpf-sockmap-fix-msg-sg.size-account-on-ingress-skb.patch
  scsi-qla2xxx-add-cleanup-for-pci-eeh-recovery.patch
  scsi-qedi-remove-memset-memcpy-to-nfunc-and-use-func.patch
  scsi-qedi-remove-set-but-not-used-variables-cdev-and.patch
  scsi-lpfc-resolve-lockdep-warnings.patch
  scsi-lpfc-correct-rcu-unlock-issue-in-lpfc_nvme_info.patch
  scsi-lpfc-add-check-for-loss-of-ndlp-when-sending-rr.patch
  arm64-print-physical-address-of-page-table-base-in-s.patch
  net-macb-fix-error-format-in-dev_err.patch
  enetc-fix-null-dma-address-unmap-for-tx-bd-extension.patch
  bpf-tcp-correctly-handle-dont_wait-flags-and-timeo-0.patch
  arm64-mm-inhibit-huge-vmap-with-ptdump.patch
  tools-bpftool-move-set_max_rlimit-before-__bpf_objec.patch
  selftests-bpf-fix-bpf_get_current_task.patch
  nvme-pci-fix-controller-freeze-wait-disabling.patch
  nvme-fix-srcu-locking-on-error-return-in-nvme_get_ns.patch
  nvme-remove-the-ifdef-around-nvme_nvm_ioctl.patch
  nvme-merge-nvme_ns_ioctl-into-nvme_ioctl.patch
  nvme-release-namespace-srcu-protection-before-perfor.patch
  nvme-fix-memory-leak-for-power-latency-tolerance.patch
  platform-x86-pmc_atom-add-lex-3i380d-industrial-pc-t.patch
  platform-x86-pmc_atom-add-several-beckhoff-automatio.patch
  scsi-myrs-fix-uninitialized-variable.patch
  scsi-bnx2fc-fix-incorrect-cast-to-u64-on-shift-opera.patch
  drm-amdgpu-keep-stolen-memory-on-picasso.patch
  libnvdimm-fix-compilation-warnings-with-w-1.patch
  selftests-fib_rule_tests-fix-local-ipv4-address-typo.patch
  selftests-timers-add-missing-fflush-stdout-calls.patch
  tracing-prevent-hist_field_var_ref-from-accessing-nu.patch
  usbnet-ipheth-fix-racing-condition.patch
  nvme-pci-use-blk-mq-mapping-for-unmanaged-irqs.patch
  tools-io_uring-fix-makefile-for-pthread-library-link.patch
  kvm-arm-arm64-move-cc-it-checks-under-hyp-s-makefile.patch
  kvm-nvmx-really-fix-the-size-checks-on-kvm_set_neste.patch
  kvm-selftests-fix-a-condition-in-test_hv_cpuid.patch
  kvm-vmx-fix-wmissing-prototypes-warnings.patch
  kvm-lapic-fix-lapic_timer_advance_ns-parameter-overf.patch
  kvm-x86-do-not-spam-dmesg-with-vmcs-vmcb-dumps.patch
  kvm-x86-pmu-mask-the-result-of-rdpmc-according-to-th.patch
  kvm-x86-pmu-do-not-mask-the-value-that-is-written-to.patch
  kvm-s390-fix-memory-slot-handling-for-kvm_set_user_m.patch
  kvm-selftests-aarch64-dirty_log_test-fix-unaligned-m.patch
  kvm-selftests-aarch64-fix-default-vm-mode.patch
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
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-4a29245e62f9564540162220e987eb9d732af630.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-4a29245e62f9564540162220e987eb9d732af630.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-4a29245e62f9564540162220e987eb9d732af630.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-4a29245e62f9564540162220e987eb9d732af630.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-4a29245e62f9564540162220e987eb9d732af630.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-4a29245e62f9564540162220e987eb9d732af630.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-4a29245e62f9564540162220e987eb9d732af630.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-4a29245e62f9564540162220e987eb9d732af630.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ❎ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking TCP: keepalive test [13]
       🚧 ✅ storage: SCSI VPD [14]
       🚧 ✅ storage: software RAID testing [15]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ❎ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking TCP: keepalive test [13]
       🚧 ✅ storage: software RAID testing [15]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ❎ tuned: tune-processes-through-perf [10]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking TCP: keepalive test [13]
       🚧 ✅ storage: software RAID testing [15]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       🚧 ✅ Storage SAN device stress [16]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ❎ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Networking TCP: keepalive test [13]
       🚧 ✅ storage: SCSI VPD [14]
       🚧 ✅ storage: software RAID testing [15]

    Host 3:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/hba/san-device-stress

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
