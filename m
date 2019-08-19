Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0446191E4A
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHSHuy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 19 Aug 2019 03:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfHSHuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 03:50:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF067308FBB4
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 07:50:53 +0000 (UTC)
Received: from [172.54.61.75] (cpt-1031.paas.prod.upshift.rdu2.redhat.com [10.0.19.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE0F5612BC;
        Mon, 19 Aug 2019 07:50:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.4FEF1BAE05.RUHKN5JQIS@redhat.com>
X-Gitlab-Pipeline-ID: 110057
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/110057
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 19 Aug 2019 07:50:53 +0000 (UTC)
Date:   Mon, 19 Aug 2019 03:50:54 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: aad39e30fb9e - Linux 5.2.9

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/110057

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
  Commit: aad39e30fb9e - Linux 5.2.9


We grabbed the 1c4296fc93aa commit of the stable queue repository.

We then merged the patchset with `git am`:

  keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
  sh-kernel-hw_breakpoint-fix-missing-break-in-switch-statement.patch
  seq_file-fix-problem-when-seeking-mid-record.patch
  mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
  mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
  mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
  mm-z3fold.c-fix-z3fold_destroy_pool-ordering.patch
  mm-z3fold.c-fix-z3fold_destroy_pool-race-condition.patch
  mm-memcontrol.c-fix-use-after-free-in-mem_cgroup_iter.patch
  mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
  mm-vmscan-do-not-special-case-slab-reclaim-when-watermarks-are-boosted.patch
  cpufreq-schedutil-don-t-skip-freq-update-when-limits-change.patch
  drm-amdgpu-fix-gfx9-soft-recovery.patch
  drm-nouveau-only-recalculate-pbn-vcpi-on-mode-connector-changes.patch
  xtensa-add-missing-isync-to-the-cpu_reset-tlb-code.patch
  arm64-ftrace-ensure-module-ftrace-trampoline-is-coherent-with-i-side.patch
  alsa-hda-realtek-add-quirk-for-hp-envy-x360.patch
  alsa-usb-audio-fix-a-stack-buffer-overflow-bug-in-check_input_term.patch
  alsa-usb-audio-fix-an-oob-bug-in-parse_audio_mixer_unit.patch
  alsa-hda-apply-workaround-for-another-amd-chip-1022-1487.patch
  alsa-hda-fix-a-memory-leak-bug.patch
  alsa-hda-add-a-generic-reboot_notify.patch
  alsa-hda-let-all-conexant-codec-enter-d3-when-rebooting.patch
  hid-holtek-test-for-sanity-of-intfdata.patch
  hid-hiddev-avoid-opening-a-disconnected-device.patch
  hid-hiddev-do-cleanup-in-failure-of-opening-a-device.patch
  input-kbtab-sanity-check-for-endpoint-type.patch
  input-iforce-add-sanity-checks.patch
  net-usb-pegasus-fix-improper-read-if-get_registers-fail.patch
  bpf-fix-access-to-skb_shared_info-gso_segs.patch
  netfilter-ebtables-also-count-base-chain-policies.patch
  riscv-correct-the-initialized-flow-of-fp-register.patch
  riscv-make-__fstate_clean-work-correctly.patch
  revert-i2c-imx-improve-the-error-handling-in-i2c_imx_dma_request.patch
  blk-mq-move-cancel-of-requeue_work-to-the-front-of-blk_exit_queue.patch
  io_uring-fix-manual-setup-of-iov_iter-for-fixed-buffers.patch
  rdma-hns-fix-sg-offset-non-zero-issue.patch
  ib-mlx5-replace-kfree-with-kvfree.patch
  clk-at91-generated-truncate-divisor-to-generated_max.patch
  clk-sprd-select-regmap_mmio-to-avoid-compile-errors.patch
  clk-renesas-cpg-mssr-fix-reset-control-race-conditio.patch
  dma-mapping-check-pfn-validity-in-dma_common_-mmap-g.patch
  platform-x86-pcengines-apuv2-fix-softdep-statement.patch
  platform-x86-intel_pmc_core-add-icl-nnpi-support-to-.patch
  mm-hmm-always-return-ebusy-for-invalid-ranges-in-hmm.patch
  xen-pciback-remove-set-but-not-used-variable-old_sta.patch
  irqchip-gic-v3-its-free-unused-vpt_page-when-alloc-v.patch
  irqchip-irq-imx-gpcv2-forward-irq-type-to-parent.patch
  f2fs-fix-to-read-source-block-before-invalidating-it.patch
  tools-perf-beauty-fix-usbdevfs_ioctl-table-generator.patch
  perf-header-fix-divide-by-zero-error-if-f_header.att.patch
  perf-header-fix-use-of-unitialized-value-warning.patch
  rdma-qedr-fix-the-hca_type-and-hca_rev-returned-in-d.patch
  alsa-pcm-fix-lost-wakeup-event-scenarios-in-snd_pcm_.patch
  libata-zpodd-fix-small-read-overflow-in-zpodd_get_me.patch
  powerpc-nvdimm-pick-nearby-online-node-if-the-device.patch
  drm-bridge-lvds-encoder-fix-build-error-while-config.patch
  drm-bridge-tc358764-fix-build-error.patch
  btrfs-fix-deadlock-between-fiemap-and-transaction-co.patch
  scsi-hpsa-correct-scsi-command-status-issue-after-re.patch
  scsi-qla2xxx-fix-possible-fcport-null-pointer-derefe.patch
  tracing-fix-header-include-guards-in-trace-event-hea.patch
  drm-amdkfd-fix-byte-align-on-vegam.patch
  drm-amd-powerplay-fix-null-pointer-dereference-aroun.patch
  drm-amdgpu-fix-error-handling-in-amdgpu_cs_process_f.patch
  drm-amdgpu-fix-a-potential-information-leaking-bug.patch
  ata-libahci-do-not-complain-in-case-of-deferred-prob.patch
  kbuild-modpost-handle-kbuild_extra_symbols-only-for-.patch
  kbuild-check-for-unknown-options-with-cc-option-usag.patch
  arm64-efi-fix-variable-si-set-but-not-used.patch
  riscv-fix-perf-record-without-libelf-support.patch
  arm64-lower-priority-mask-for-gic_prio_irqon.patch
  arm64-unwind-prohibit-probing-on-return_address.patch
  arm64-mm-fix-variable-pud-set-but-not-used.patch
  arm64-mm-fix-variable-tag-set-but-not-used.patch
  ib-core-add-mitigation-for-spectre-v1.patch
  ib-mlx5-fix-mr-registration-flow-to-use-umr-properly.patch
  rdma-restrack-track-driver-qp-types-in-resource-trac.patch
  ib-mad-fix-use-after-free-in-ib-mad-completion-handl.patch
  rdma-mlx5-release-locks-during-notifier-unregister.patch
  drm-msm-fix-add_gpu_components.patch
  rdma-hns-fix-error-return-code-in-hns_roce_v1_rsv_lp.patch
  drm-exynos-fix-missing-decrement-of-retry-counter.patch
  arm64-kprobes-recover-pstate.d-in-single-step-except.patch
  arm64-make-debug-exception-handlers-visible-from-rcu.patch
  revert-kmemleak-allow-to-coexist-with-fault-injectio.patch
  ocfs2-remove-set-but-not-used-variable-last_hash.patch
  page-flags-prioritize-kasan-bits-over-last-cpuid.patch
  asm-generic-fix-wtype-limits-compiler-warnings.patch
  tpm-tpm_ibm_vtpm-fix-unallocated-banks.patch
  arm64-kvm-regmap-fix-unexpected-switch-fall-through.patch
  staging-comedi-dt3000-fix-signed-integer-overflow-divider-base.patch
  staging-comedi-dt3000-fix-rounding-up-of-timer-divisor.patch
  iio-adc-max9611-fix-temperature-reading-in-probe.patch
  x86-boot-save-fields-explicitly-zero-out-everything-else.patch
  usb-core-fix-races-in-character-device-registration-and-deregistraion.patch
  usb-gadget-udc-renesas_usb3-fix-sysfs-interface-of-role.patch
  usb-cdc-acm-make-sure-a-refcount-is-taken-early-enough.patch
  usb-cdc-fix-sanity-checks-in-cdc-union-parser.patch
  usb-serial-option-add-d-link-dwm-222-device-id.patch
  usb-serial-option-add-support-for-zte-mf871a.patch
  usb-serial-option-add-the-broadmobi-bm818-card.patch
  usb-serial-option-add-motorola-modem-uarts.patch
  usb-setup-authorized_default-attributes-using-usb_bus_notify.patch

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
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Networking socket: fuzz [12]
         ✅ audit: audit testsuite test [13]
         ✅ httpd: mod_ssl smoke sanity [14]
         ✅ iotop: sanity [15]
         ✅ tuned: tune-processes-through-perf [16]
         ✅ Usex - version 1.9-29 [17]
         ✅ storage: SCSI VPD [18]
         ✅ stress: stress-ng [19]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Networking socket: fuzz [12]
         ✅ audit: audit testsuite test [13]
         ✅ httpd: mod_ssl smoke sanity [14]
         ✅ iotop: sanity [15]
         ✅ tuned: tune-processes-through-perf [16]
         ✅ Usex - version 1.9-29 [17]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Networking socket: fuzz [12]
         ✅ audit: audit testsuite test [13]
         ✅ httpd: mod_ssl smoke sanity [14]
         ✅ iotop: sanity [15]
         ✅ tuned: tune-processes-through-perf [16]
         ✅ pciutils: sanity smoke test [20]
         ✅ Usex - version 1.9-29 [17]
         ✅ storage: SCSI VPD [18]
         ✅ stress: stress-ng [19]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
