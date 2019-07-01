Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAE34CAD
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfFDPzg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Jun 2019 11:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbfFDPzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 11:55:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F5486411E
        for <stable@vger.kernel.org>; Tue,  4 Jun 2019 15:55:35 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF152BE6F;
        Tue,  4 Jun 2019 15:55:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.A7194BB10E.451SEJ6XNG@redhat.com>
X-Gitlab-Pipeline-ID: 11485
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11485?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 04 Jun 2019 15:55:35 +0000 (UTC)
Date:   Tue, 4 Jun 2019 11:55:35 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 2f7d9d47575e - Linux 5.1.7

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
  Commit: 2f7d9d47575e - Linux 5.1.7


We then merged the patchset with `git am`:

  sparc64-fix-regression-in-non-hypervisor-tlb-flush-xcall.patch
  include-linux-bitops.h-sanitize-rotate-primitives.patch
  xhci-update-bounce-buffer-with-correct-sg-num.patch
  xhci-use-zu-for-printing-size_t-type.patch
  xhci-convert-xhci_handshake-to-use-readl_poll_timeout_atomic.patch
  usb-xhci-avoid-null-pointer-deref-when-bos-field-is-null.patch
  usbip-usbip_host-fix-bug-sleeping-function-called-from-invalid-context.patch
  usbip-usbip_host-fix-stub_dev-lock-context-imbalance-regression.patch
  usb-fix-slab-out-of-bounds-write-in-usb_get_bos_descriptor.patch
  usb-sisusbvga-fix-oops-in-error-path-of-sisusb_probe.patch
  usb-add-lpm-quirk-for-surface-dock-gige-adapter.patch
  usb-rio500-refuse-more-than-one-device-at-a-time.patch
  usb-rio500-fix-memory-leak-in-close-after-disconnect.patch
  media-usb-siano-fix-general-protection-fault-in-smsusb.patch
  media-usb-siano-fix-false-positive-uninitialized-variable-warning.patch
  media-smsusb-better-handle-optional-alignment.patch
  brcmfmac-fix-null-pointer-derefence-during-usb-disconnect.patch
  scsi-zfcp-fix-missing-zfcp_port-reference-put-on-ebusy-from-port_remove.patch
  scsi-zfcp-fix-to-prevent-port_remove-with-pure-auto-scan-luns-only-sdevs.patch
  tracing-avoid-memory-leak-in-predicate_parse.patch
  btrfs-fix-wrong-ctime-and-mtime-of-a-directory-after-log-replay.patch
  btrfs-fix-race-updating-log-root-item-during-fsync.patch
  btrfs-fix-fsync-not-persisting-changed-attributes-of-a-directory.patch
  btrfs-correct-zstd-workspace-manager-lock-to-use-spin_lock_bh.patch
  btrfs-qgroup-check-bg-while-resuming-relocation-to-avoid-null-pointer-dereference.patch
  btrfs-incremental-send-fix-file-corruption-when-no-holes-feature-is-enabled.patch
  btrfs-reloc-also-queue-orphan-reloc-tree-for-cleanup-to-avoid-bug_on.patch
  iio-dac-ds4422-ds4424-fix-chip-verification.patch
  iio-adc-ads124-avoid-buffer-overflow.patch
  iio-adc-modify-npcm-adc-read-reference-voltage.patch
  iio-adc-ti-ads8688-fix-timestamp-is-not-updated-in-buffer.patch
  s390-crypto-fix-gcm-aes-s390-selftest-failures.patch
  s390-crypto-fix-possible-sleep-during-spinlock-aquired.patch
  kvm-ppc-book3s-hv-xive-do-not-clear-irq-data-of-passthrough-interrupts.patch
  kvm-ppc-book3s-hv-fix-lockdep-warning-when-entering-guest-on-power9.patch
  kvm-ppc-book3s-hv-restore-sprg3-in-kvmhv_p9_guest_entry.patch
  powerpc-perf-fix-mmcra-corruption-by-bhrb_filter.patch
  powerpc-kexec-fix-loading-of-kernel-initramfs-with-kexec_file_load.patch
  alsa-line6-assure-canceling-delayed-work-at-disconnection.patch
  alsa-hda-realtek-set-default-power-save-node-to-0.patch
  alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  kvm-s390-do-not-report-unusabled-ids-via-kvm_cap_max_vcpu_id.patch
  drm-nouveau-i2c-disable-i2c-bus-access-after-fini.patch
  i2c-mlxcpld-fix-wrong-initialization-order-in-probe.patch
  i2c-synquacer-fix-synquacer_i2c_doxfer-return-value.patch
  tty-serial-msm_serial-fix-xon-xoff.patch
  tty-max310x-fix-external-crystal-register-setup.patch
  mm-memcg-consider-subtrees-in-memory.events.patch
  memcg-make-it-work-on-sparse-non-0-node-systems.patch
  kasan-initialize-tag-to-0xff-in-__kasan_kmalloc.patch
  kernel-signal.c-trace_signal_deliver-when-signal_group_exit.patch
  signal-arm64-use-force_sig-not-force_sig_fault-for-sigkill.patch
  mm-compaction-make-sure-we-isolate-a-valid-pfn.patch
  arm64-fix-the-arm64_personality-syscall-wrapper-redirection.patch
  docs-fix-conf.py-for-sphinx-2.0.patch
  doc-cope-with-the-deprecation-of-autoreporter.patch
  doc-cope-with-sphinx-logging-deprecations.patch
  x86-ima-check-efi_runtime_services-before-using.patch
  ima-fix-wrong-signed-policy-requirement-when-not-appraising.patch
  ima-show-rules-with-ima_inmask-correctly.patch
  evm-check-hash-algorithm-passed-to-init_desc.patch
  clk-imx-imx8mm-fix-int-pll-clk-gate.patch
  vt-fbcon-deinitialize-resources-in-visual_init-after-failed-memory-allocation.patch
  serial-sh-sci-disable-dma-for-uart_console.patch
  staging-vc04_services-prevent-integer-overflow-in-create_pagelist.patch
  staging-wlan-ng-fix-adapter-initialization-failure.patch
  cifs-fix-memory-leak-of-pneg_inbuf-on-eopnotsupp-ioctl-case.patch
  cifs-cifs_read_allocate_pages-don-t-iterate-through-whole-page-array-on-enomem.patch
  revert-lockd-show-pid-of-lockd-for-remote-locks.patch
  gcc-plugins-fix-build-failures-under-darwin-host.patch
  drm-tegra-gem-fix-cpu-cache-maintenance-for-bo-s-allocated-using-get_pages.patch
  drm-vmwgfx-fix-user-space-handle-equal-to-zero.patch
  drm-vmwgfx-fix-compat-mode-shader-operation.patch
  drm-vmwgfx-don-t-send-drm-sysfs-hotplug-events-on-initial-master-set.patch
  drm-sun4i-fix-sun8i-hdmi-phy-clock-initialization.patch
  drm-sun4i-fix-sun8i-hdmi-phy-configuration-for-148.5-mhz.patch
  drm-imx-ipuv3-plane-fix-atomic-update-status-query-for-non-plus-i.mx6q.patch
  drm-fb-helper-generic-call-drm_client_add-after-setup-is-done.patch
  drm-atomic-wire-file_priv-through-for-property-changes.patch
  drm-expose-fb_damage_clips-property-to-atomic-aware-user-space-only.patch
  drm-rockchip-shutdown-drm-subsystem-on-shutdown.patch
  drm-lease-make-sure-implicit-planes-are-leased.patch
  drm-cma-helper-fix-drm_gem_cma_free_object.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-bbe47c6bd3b0bb11d5f51d3dfa004be12c1f4db3.tar.gz


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
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ stress: stress-ng [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       🚧 ✅ stress: stress-ng [9]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ audit: audit testsuite test [4]
       ✅ httpd: mod_ssl smoke sanity [5]
       ✅ iotop: sanity [6]
       ✅ tuned: tune-processes-through-perf [7]
       ✅ Usex - version 1.9-29 [8]
       🚧 ✅ stress: stress-ng [9]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [10]


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
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
