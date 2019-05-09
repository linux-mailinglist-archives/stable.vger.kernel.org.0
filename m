Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8374188CE
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEILQ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 9 May 2019 07:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfEILQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 07:16:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 559763DDBE
        for <stable@vger.kernel.org>; Thu,  9 May 2019 11:16:27 +0000 (UTC)
Received: from [172.54.42.34] (cpt-0010.paas.prod.upshift.rdu2.redhat.com [10.0.18.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB86B608E4;
        Thu,  9 May 2019 11:16:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.0
Message-ID: <cki.076C0D57F0.5BZ1IRUPAJ@redhat.com>
X-Gitlab-Pipeline-ID: 9570
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9570
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 09 May 2019 11:16:27 +0000 (UTC)
Date:   Thu, 9 May 2019 07:16:28 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 274ede3e1a5f - Linux 5.0.14

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
  Commit: 274ede3e1a5f - Linux 5.0.14

We then merged the patchset with `git am`:

  net-stmmac-use-bfsize1-in-ndesc_init_rx_desc.patch
  drivers-hv-vmbus-remove-the-undesired-put_cpu_ptr-in-hv_synic_cleanup.patch
  ubsan-fix-nasty-wbuiltin-declaration-mismatch-gcc-9-warnings.patch
  staging-greybus-power_supply-fix-prop-descriptor-request-size.patch
  staging-wilc1000-avoid-gfp_kernel-allocation-from-atomic-context.patch
  staging-most-cdev-fix-chrdev_region-leak-in-mod_exit.patch
  staging-most-sound-pass-correct-device-when-creating-a-sound-card.patch
  asoc-tlv320aic3x-fix-reset-gpio-reference-counting.patch
  asoc-hdmi-codec-fix-s-pdif-dai.patch
  asoc-stm32-sai-fix-iec958-controls-indexation.patch
  asoc-stm32-sai-fix-exposed-capabilities-in-spdif-mod.patch
  asoc-stm32-sai-fix-race-condition-in-irq-handler.patch
  asoc-soc-pcm-fix-a-codec-fixup-issue-in-tdm-case.patch
  asoc-hdac_hda-use-correct-format-to-setup-hda-codec.patch
  asoc-intel-skl-fix-a-simultaneous-playback-capture-i.patch
  asoc-dpcm-prevent-snd_soc_dpcm-use-after-free.patch
  asoc-nau8824-fix-the-issue-of-the-widget-with-prefix.patch
  asoc-nau8810-fix-the-issue-of-widget-with-prefixed-n.patch
  asoc-samsung-odroid-fix-clock-configuration-for-4410.patch
  asoc-rt5682-check-jd-status-when-system-resume.patch
  asoc-rt5682-fix-jack-type-detection-issue.patch
  asoc-rt5682-recording-has-no-sound-after-booting.patch
  asoc-wm_adsp-add-locking-to-wm_adsp2_bus_error.patch
  clk-meson-gxbb-round-the-vdec-dividers-to-closest.patch
  asoc-stm32-dfsdm-manage-multiple-prepare.patch
  asoc-stm32-dfsdm-fix-debugfs-warnings-on-entry-creat.patch
  asoc-cs4270-set-auto-increment-bit-for-register-writ.patch
  asoc-dapm-fix-null-pointer-dereference-in-snd_soc_da.patch
  drm-omap-hdmi4_cec-fix-cec-clock-handling-for-pm.patch
  ib-hfi1-clear-the-iowait-pending-bits-when-qp-is-put.patch
  ib-hfi1-eliminate-opcode-tests-on-mr-deref.patch
  ib-hfi1-fix-the-allocation-of-rsm-table.patch
  mips-kgdb-fix-kgdb-support-for-smp-platforms.patch
  asoc-tlv320aic32x4-fix-common-pins.patch
  drm-mediatek-fix-an-error-code-in-mtk_hdmi_dt_parse_.patch
  perf-x86-intel-fix-handling-of-wakeup_events-for-mul.patch
  perf-x86-intel-initialize-tfa-msr.patch
  linux-kernel.h-use-parentheses-around-argument-in-u6.patch
  iov_iter-fix-build-error-without-config_crypto.patch
  xtensa-fix-initialization-of-pt_regs-syscall-in-star.patch
  asoc-rockchip-pdm-fix-regmap_ops-hang-issue.patch
  drm-amdkfd-add-picasso-pci-id.patch
  drm-amdgpu-adjust-ib-test-timeout-for-xgmi-configura.patch
  drm-amdgpu-amdgpu_device_recover_vram-always-failed-.patch
  drm-amd-display-fix-cursor-black-issue.patch
  asoc-cs35l35-disable-regulators-on-driver-removal.patch
  objtool-add-rewind_stack_do_exit-to-the-noreturn-lis.patch
  slab-fix-a-crash-by-reading-proc-slab_allocators.patch
  drm-sun4i-tcon-top-fix-null-invalid-pointer-derefere.patch
  virtio_pci-fix-a-null-pointer-reference-in-vp_del_vq.patch
  rdma-vmw_pvrdma-fix-memory-leak-on-pvrdma_pci_remove.patch
  rdma-hns-fix-bug-that-caused-srq-creation-to-fail.patch
  keys-trusted-fix-wvarags-warning.patch
  scsi-csiostor-fix-missing-data-copy-in-csio_scsi_err.patch
  drm-mediatek-fix-possible-object-reference-leak.patch
  drm-mediatek-fix-the-rate-and-divder-of-hdmi-phy-for.patch
  drm-mediatek-make-implementation-of-recalc_rate-for-.patch
  drm-mediatek-remove-flag-clk_set_rate_parent-for-mt2.patch
  drm-mediatek-using-new-factor-for-tvdpll-for-mt2701-.patch
  drm-mediatek-no-change-parent-rate-in-round_rate-for.patch
  asoc-intel-kbl-fix-wrong-number-of-channels.patch
  asoc-stm32-sai-fix-master-clock-management.patch
  alsa-hda-fix-racy-display-power-access.patch
  virtio-blk-limit-number-of-hw-queues-by-nr_cpu_ids.patch
  blk-mq-introduce-blk_mq_complete_request_sync.patch
  nvme-cancel-request-synchronously.patch
  nvme-fc-correct-csn-initialization-and-increments-on.patch
  nvmet-fix-discover-log-page-when-offsets-are-used.patch
  platform-x86-pmc_atom-drop-__initconst-on-dmi-table.patch
  nfsv4.1-fix-incorrect-return-value-in-copy_file_rang.patch
  perf-core-fix-perf_event_disable_inatomic-race.patch
  iommu-amd-set-exclusion-range-correctly.patch
  genirq-prevent-use-after-free-and-work-list-corrupti.patch
  usb-dwc3-allow-building-usb_dwc3_qcom-without-extcon.patch
  usb-dwc3-fix-default-lpm_nyet_threshold-value.patch
  usb-serial-f81232-fix-interrupt-worker-not-stop.patch
  usb-cdc-acm-fix-unthrottle-races.patch
  usb-storage-set-virt_boundary_mask-to-avoid-sg-overflows.patch
  intel_th-pci-add-comet-lake-support.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-cf43af6e2ca6b4f251b0c426942c3b59b7f79012.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     🚧 ✅ selinux-policy: serge-testsuite [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ Storage blktests [12]
     🚧 ✅ stress: stress-ng [13]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     🚧 ✅ selinux-policy: serge-testsuite [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ Storage blktests [12]
     🚧 ✅ stress: stress-ng [13]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ Storage blktests [12]
     🚧 ✅ stress: stress-ng [13]
     🚧 ✅ selinux-policy: serge-testsuite [10]

  x86_64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     🚧 ✅ selinux-policy: serge-testsuite [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ Storage blktests [12]
     🚧 ✅ stress: stress-ng [13]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
