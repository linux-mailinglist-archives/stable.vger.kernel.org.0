Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F245FD2AED
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbfJJNRw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 10 Oct 2019 09:17:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388141AbfJJNRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 09:17:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 224EE309BF02
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 13:17:51 +0000 (UTC)
Received: from [172.54.131.27] (cpt-1021.paas.prod.upshift.rdu2.redhat.com [10.0.19.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D50DA10018F8;
        Thu, 10 Oct 2019 13:17:45 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
CC:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Zhaojuan Guo <zguo@redhat.com>
Message-ID: <cki.F0813025BB.NWYWPQSD42@redhat.com>
X-Gitlab-Pipeline-ID: 215962
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/215962
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 10 Oct 2019 13:17:51 +0000 (UTC)
Date:   Thu, 10 Oct 2019 09:17:51 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 52020d3f6633 - Linux 5.3.5

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/215962

One or more kernel tests failed:

    x86_64:
      ❌ Boot test
      ❌ Boot test
      ❌ Boot test
      ❌ Boot test

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

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 52020d3f6633 - Linux 5.3.5


We grabbed the 0a9f51931637 commit of the stable queue repository.

We then merged the patchset with `git am`:

  s390-process-avoid-potential-reading-of-freed-stack.patch
  s390-sclp-fix-bit-checked-for-has_sipl.patch
  kvm-s390-test-for-bad-access-register-and-size-at-the-start-of-s390_mem_op.patch
  s390-topology-avoid-firing-events-before-kobjs-are-created.patch
  s390-cio-avoid-calling-strlen-on-null-pointer.patch
  s390-cio-exclude-subchannels-with-no-parent-from-pseudo-check.patch
  s390-dasd-fix-error-handling-during-online-processing.patch
  revert-s390-dasd-add-discard-support-for-ese-volumes.patch
  kvm-s390-fix-__insn32_query-inline-assembly.patch
  kvm-ppc-book3s-enable-xive-native-capability-only-if-opal-has-required-functions.patch
  kvm-ppc-book3s-hv-xive-free-escalation-interrupts-before-disabling-the-vp.patch
  kvm-ppc-book3s-hv-don-t-push-xive-context-when-not-using-xive-device.patch
  kvm-ppc-book3s-hv-fix-race-in-re-enabling-xive-escalation-interrupts.patch
  kvm-ppc-book3s-hv-check-for-mmu-ready-on-piggybacked-virtual-cores.patch
  kvm-ppc-book3s-hv-don-t-lose-pending-doorbell-request-on-migration-on-p9.patch
  kvm-x86-fix-userspace-set-invalid-cr4.patch
  nbd-fix-max-number-of-supported-devs.patch
  pm-devfreq-tegra-fix-khz-to-hz-conversion.patch
  asoc-define-a-set-of-dapm-pre-post-up-events.patch
  asoc-sgtl5000-improve-vag-power-and-mute-control.patch
  powerpc-xive-implement-get_irqchip_state-method-for-xive-to-fix-shutdown-race.patch
  powerpc-mce-fix-mce-handling-for-huge-pages.patch
  powerpc-mce-schedule-work-from-irq_work.patch
  powerpc-603-fix-handling-of-the-dirty-flag.patch
  powerpc-32s-fix-boot-failure-with-debug_pagealloc-without-kasan.patch
  powerpc-ptdump-fix-addresses-display-on-ppc32.patch
  powerpc-powernv-restrict-opal-symbol-map-to-only-be-readable-by-root.patch
  powerpc-pseries-fix-cpu_hotplug_lock-acquisition-in-resize_hpt.patch
  powerpc-powernv-ioda-fix-race-in-tce-level-allocation.patch
  powerpc-kasan-fix-parallel-loading-of-modules.patch
  powerpc-kasan-fix-shadow-area-set-up-for-modules.patch
  powerpc-book3s64-mm-don-t-do-tlbie-fixup-for-some-hardware-revisions.patch
  powerpc-book3s64-radix-rename-cpu_ftr_p9_tlbie_bug-feature-flag.patch
  powerpc-mm-add-a-helper-to-select-page_kernel_ro-or-page_readonly.patch
  powerpc-mm-fix-an-oops-in-kasan_mmu_init.patch
  powerpc-mm-fixup-tlbie-vs-mtpidr-mtlpidr-ordering-issue-on-power9.patch
  can-mcp251x-mcp251x_hw_reset-allow-more-time-after-a-reset.patch
  tools-lib-traceevent-fix-robust-test-of-do_generate_dynamic_list_file.patch
  tools-lib-traceevent-do-not-free-tep-cmdlines-in-add_new_comm-on-failure.patch
  crypto-qat-silence-smp_processor_id-warning.patch
  crypto-skcipher-unmap-pages-after-an-external-error.patch
  crypto-cavium-zip-add-missing-single_release.patch
  crypto-caam-qi-fix-error-handling-in-ern-handler.patch
  crypto-caam-fix-concurrency-issue-in-givencrypt-descriptor.patch
  crypto-ccree-account-for-tee-not-ready-to-report.patch
  crypto-ccree-use-the-full-crypt-length-value.patch
  mips-treat-loongson-extensions-as-ases.patch
  power-supply-sbs-battery-use-correct-flags-field.patch
  power-supply-sbs-battery-only-return-health-when-battery-present.patch
  tracing-make-sure-variable-reference-alias-has-correct-var_ref_idx.patch
  usercopy-avoid-highmem-pfn-warning.patch
  timer-read-jiffies-once-when-forwarding-base-clk.patch
  pci-vmd-fix-config-addressing-when-using-bus-offsets.patch
  pci-hv-avoid-use-of-hv_pci_dev-pci_slot-after-freeing-it.patch
  pci-vmd-fix-shadow-offsets-to-reflect-spec-changes.patch
  pci-restore-resizable-bar-size-bits-correctly-for-1mb-bars.patch
  selftests-tpm2-add-the-missing-test_files-assignment.patch
  selftests-pidfd-fix-undefined-reference-to-pthread_create.patch
  watchdog-imx2_wdt-fix-min-calculation-in-imx2_wdt_set_timeout.patch
  perf-tools-fix-segfault-in-cpu_cache_level__read.patch
  perf-stat-fix-a-segmentation-fault-when-using-repeat-forever.patch
  drm-i915-dp-fix-dsc-bpp-calculations-v5.patch
  drm-atomic-reject-flip_async-unconditionally.patch
  drm-atomic-take-the-atomic-toys-away-from-x.patch
  drm-mali-dp-mark-expected-switch-fall-through.patch
  drm-omap-fix-max-fclk-divider-for-omap36xx.patch
  drm-msm-dsi-fix-return-value-check-for-clk_get_parent.patch
  drm-nouveau-kms-nv50-don-t-create-mstms-for-edp-connectors.patch
  drm-amd-powerplay-change-metrics-update-period-from-1ms-to-100ms.patch
  drm-i915-gvt-update-vgpu-workload-head-pointer-correctly.patch
  drm-i915-userptr-acquire-the-page-lock-around-set_page_dirty.patch
  drm-i915-to-make-vgpu-ppgtt-notificaiton-as-atomic-operation.patch
  mac80211-keep-bhs-disabled-while-calling-drv_tx_wake_queue.patch
  mmc-tegra-implement-set_dma_mask.patch
  mmc-sdhci-improve-adma-error-reporting.patch
  mmc-sdhci-of-esdhc-set-dma-snooping-based-on-dma-coherence.patch
  mmc-sdhci-let-drivers-define-their-dma-mask.patch
  revert-locking-pvqspinlock-don-t-wait-if-vcpu-is-preempted.patch
  libnvdimm-altmap-track-namespace-boundaries-in-altmap.patch
  sched-add-__assembly__-guards-around-struct-clone_args.patch
  dts-arm-gta04-introduce-legacy-spi-cs-high-to-make-display-work-again.patch
  xen-balloon-set-pages-pageoffline-in-balloon_add_region.patch
  xen-xenbus-fix-self-deadlock-after-killing-user-process.patch
  ieee802154-atusb-fix-use-after-free-at-disconnect.patch
  nl80211-validate-beacon-head.patch
  cfg80211-validate-ssid-mbssid-element-ordering-assumption.patch
  cfg80211-initialize-on-stack-chandefs.patch
  drivers-thermal-qcom-tsens-fix-memory-leak-from-qfpr.patch
  ima-always-return-negative-code-for-error.patch
  ima-fix-freeing-ongoing-ahash_request.patch
  fs-nfs-fix-possible-null-pointer-dereferences-in-enc.patch
  xprtrdma-toggle-xprt_congested-in-xprtrdma-s-slot-me.patch
  xprtrdma-send-queue-size-grows-after-a-reconnect.patch
  9p-transport-error-uninitialized.patch
  9p-avoid-attaching-writeback_fid-on-mmap-with-type-p.patch
  xen-pci-reserve-mcfg-areas-earlier.patch
  fuse-fix-request-limit.patch
  ceph-fix-directories-inode-i_blkbits-initialization.patch
  ceph-fetch-cap_gen-under-spinlock-in-ceph_add_cap.patch
  ceph-reconnect-connection-if-session-hang-in-opening.patch
  sunrpc-rpc-level-errors-should-always-set-task-tk_rp.patch
  watchdog-aspeed-add-support-for-ast2600.patch
  netfilter-nf_tables-allow-lookups-in-dynamic-sets.patch
  drm-amdgpu-fix-kfd-related-kernel-oops-on-hawaii.patch
  drm-amdgpu-check-for-valid-number-of-registers-to-re.patch
  perf-probe-fix-to-clear-tev-nargs-in-clear_probe_tra.patch
  pnfs-ensure-we-do-clear-the-return-on-close-layout-s.patch
  sunrpc-don-t-try-to-parse-incomplete-rpc-messages.patch
  pwm-stm32-lp-add-check-in-case-requested-period-cann.patch
  selftests-seccomp-fix-build-on-older-kernels.patch
  x86-purgatory-disable-the-stackleak-gcc-plugin-for-t.patch
  ntb-point-to-right-memory-window-index.patch
  thermal-fix-use-after-free-when-unregistering-therma.patch
  thermal_hwmon-sanitize-thermal_zone-type.patch
  iommu-amd-fix-downgrading-default-page-sizes-in-allo.patch
  libnvdimm-region-initialize-bad-block-for-volatile-n.patch
  libnvdimm-fix-endian-conversion-issues.patch
  fuse-fix-memleak-in-cuse_channel_open.patch
  libnvdimm-nfit_test-fix-acpi_handle-redefinition.patch
  sched-membarrier-call-sync_core-only-before-usermode.patch
  sched-membarrier-fix-private-expedited-registration-.patch
  sched-core-fix-migration-to-invalid-cpu-in-__set_cpu.patch
  perf-build-add-detection-of-java-11-openjdk-devel-pa.patch
  include-trace-events-writeback.h-fix-wstringop-trunc.patch
  selftests-bpf-adjust-strobemeta-loop-to-satisfy-late.patch
  kernel-elfcore.c-include-proper-prototypes.patch
  libbpf-fix-false-uninitialized-variable-warning.patch
  blk-mq-move-lockdep_assert_held-into-elevator_exit.patch
  bpf-fix-bpf_event_output-re-entry-issue.patch
  net-dsa-microchip-always-set-regmap-stride-to-1.patch
  i2c-qcom-geni-disable-dma-processing-on-the-lenovo-y.patch
  perf-unwind-fix-libunwind-build-failure-on-i386-syst.patch
  mlxsw-spectrum_flower-fail-in-case-user-specifies-mu.patch
  nfp-abm-fix-memory-leak-in-nfp_abm_u32_knode_replace.patch
  drm-radeon-bail-earlier-when-radeon.cik_-si_support-.patch
  btrfs-fix-selftests-failure-due-to-uninitialized-i_m.patch
  kvm-nvmx-fix-consistency-check-on-injected-exception.patch
  tick-broadcast-hrtimer-fix-a-race-in-bc_set_next.patch
  perf-stat-reset-previous-counts-on-repeat-with-inter.patch
  riscv-avoid-interrupts-being-erroneously-enabled-in-.patch
  vfs-fix-eoverflow-testing-in-put_compat_statfs64.patch
  coresight-etm4x-use-explicit-barriers-on-enable-disable.patch
  staging-erofs-fix-an-error-handling-in-erofs_readdir.patch
  staging-erofs-some-compressed-cluster-should-be-submitted-for-corrupted-images.patch
  staging-erofs-add-two-missing-erofs_workgroup_put-for-corrupted-images.patch
  staging-erofs-avoid-endless-loop-of-invalid-lookback-distance-0.patch
  staging-erofs-detect-potential-multiref-due-to-corrupted-images.patch
  libnvdimm-prevent-nvdimm-from-requesting-key-when-se.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ trace: ftrace/tracer

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ Storage blktests

      Host 2:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ trace: ftrace/tracer

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ stress: stress-ng
         🚧 ❌ LTP lite
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ trace: ftrace/tracer

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ IOMMU boot test
         🚧 ✅ Storage blktests

      Host 3:
         ❌ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity
      Host 4:
         ❌ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity

      Host 5:
         ❌ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity
      Host 6:
         ❌ Boot test
         🚧 ❌ /kernel/infiniband/env_setup
         🚧 ❌ /kernel/infiniband/sanity

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.

