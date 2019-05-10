Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B509199B0
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 10:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfEJI1v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 10 May 2019 04:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfEJI1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 04:27:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D58EC30018C0
        for <stable@vger.kernel.org>; Fri, 10 May 2019 08:27:50 +0000 (UTC)
Received: from [172.54.105.48] (cpt-0019.paas.prod.upshift.rdu2.redhat.com [10.0.18.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342EC1724E;
        Fri, 10 May 2019 08:27:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.C0BBEFADBE.QH1UTAVCX2@redhat.com>
X-Gitlab-Pipeline-ID: 9654
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9654
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 10 May 2019 08:27:50 +0000 (UTC)
Date:   Fri, 10 May 2019 04:27:51 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 21de7eb67cff - Linux 4.19.41

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
  Commit: 21de7eb67cff - Linux 4.19.41

We then merged the patchset with `git am`:

  net-stmmac-use-bfsize1-in-ndesc_init_rx_desc.patch
  scsi-libsas-fix-a-race-condition-when-smp-task-timeout.patch
  drivers-hv-vmbus-remove-the-undesired-put_cpu_ptr-in-hv_synic_cleanup.patch
  ubsan-fix-nasty-wbuiltin-declaration-mismatch-gcc-9-warnings.patch
  staging-greybus-power_supply-fix-prop-descriptor-request-size.patch
  staging-most-cdev-fix-chrdev_region-leak-in-mod_exit.patch
  asoc-tlv320aic3x-fix-reset-gpio-reference-counting.patch
  asoc-hdmi-codec-fix-s-pdif-dai.patch
  asoc-stm32-sai-fix-iec958-controls-indexation.patch
  asoc-stm32-sai-fix-exposed-capabilities-in-spdif-mod.patch
  asoc-soc-pcm-fix-a-codec-fixup-issue-in-tdm-case.patch
  asoc-intel-skl-fix-a-simultaneous-playback-capture-i.patch
  asoc-nau8824-fix-the-issue-of-the-widget-with-prefix.patch
  asoc-nau8810-fix-the-issue-of-widget-with-prefixed-n.patch
  asoc-samsung-odroid-fix-clock-configuration-for-4410.patch
  asoc-rt5682-recording-has-no-sound-after-booting.patch
  asoc-wm_adsp-add-locking-to-wm_adsp2_bus_error.patch
  clk-meson-gxbb-round-the-vdec-dividers-to-closest.patch
  asoc-stm32-dfsdm-manage-multiple-prepare.patch
  asoc-stm32-dfsdm-fix-debugfs-warnings-on-entry-creat.patch
  asoc-cs4270-set-auto-increment-bit-for-register-writ.patch
  asoc-dapm-fix-null-pointer-dereference-in-snd_soc_da.patch
  drm-omap-hdmi4_cec-fix-cec-clock-handling-for-pm.patch
  ib-hfi1-eliminate-opcode-tests-on-mr-deref.patch
  ib-hfi1-fix-the-allocation-of-rsm-table.patch
  mips-kgdb-fix-kgdb-support-for-smp-platforms.patch
  asoc-tlv320aic32x4-fix-common-pins.patch
  drm-mediatek-fix-an-error-code-in-mtk_hdmi_dt_parse_.patch
  perf-x86-intel-fix-handling-of-wakeup_events-for-mul.patch
  perf-x86-intel-initialize-tfa-msr.patch
  linux-kernel.h-use-parentheses-around-argument-in-u6.patch
  asoc-rockchip-pdm-fix-regmap_ops-hang-issue.patch
  drm-amd-display-fix-cursor-black-issue.patch
  asoc-cs35l35-disable-regulators-on-driver-removal.patch
  objtool-add-rewind_stack_do_exit-to-the-noreturn-lis.patch
  slab-fix-a-crash-by-reading-proc-slab_allocators.patch
  drm-sun4i-tcon-top-fix-null-invalid-pointer-derefere.patch
  virtio_pci-fix-a-null-pointer-reference-in-vp_del_vq.patch
  rdma-vmw_pvrdma-fix-memory-leak-on-pvrdma_pci_remove.patch
  rdma-hns-fix-bug-that-caused-srq-creation-to-fail.patch
  scsi-csiostor-fix-missing-data-copy-in-csio_scsi_err.patch
  drm-mediatek-fix-possible-object-reference-leak.patch
  asoc-intel-kbl-fix-wrong-number-of-channels.patch
  virtio-blk-limit-number-of-hw-queues-by-nr_cpu_ids.patch
  nvme-fc-correct-csn-initialization-and-increments-on.patch
  platform-x86-pmc_atom-drop-__initconst-on-dmi-table.patch
  perf-core-fix-perf_event_disable_inatomic-race.patch
  iommu-amd-set-exclusion-range-correctly.patch
  genirq-prevent-use-after-free-and-work-list-corrupti.patch
  usb-dwc3-fix-default-lpm_nyet_threshold-value.patch
  usb-serial-f81232-fix-interrupt-worker-not-stop.patch
  usb-cdc-acm-fix-unthrottle-races.patch
  usb-storage-set-virt_boundary_mask-to-avoid-sg-overflows.patch
  intel_th-pci-add-comet-lake-support.patch
  cpufreq-armada-37xx-fix-frequency-calculation-for-opp.patch
  soc-sunxi-fix-missing-dependency-on-regmap_mmio.patch
  scsi-lpfc-change-snprintf-to-scnprintf-for-possible-overflow.patch
  scsi-qla2xxx-fix-incorrect-region-size-setting-in-optrom-sysfs-routines.patch
  scsi-qla2xxx-fix-device-staying-in-blocked-state.patch
  bluetooth-hidp-fix-buffer-overflow.patch
  bluetooth-align-minimum-encryption-key-size-for-le-and-br-edr-connections.patch
  uas-fix-alignment-of-scatter-gather-segments.patch
  asoc-intel-avoid-oops-if-dma-setup-fails.patch
  locking-futex-allow-low-level-atomic-operations-to-return-eagain.patch
  arm64-futex-bound-number-of-ldxr-stxr-loops-in-futex_wake_op.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-f1ffdbe8316aa6d37b1d6d231a5a2aa9c61da45d.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ Storage blktests [10]
     🚧 ✅ stress: stress-ng [11]

  ppc64le:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ Storage blktests [10]
     🚧 ✅ stress: stress-ng [11]

  s390x:
     ✅ Boot test [0]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     🚧 ✅ selinux-policy: serge-testsuite [8]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ Storage blktests [10]
     🚧 ✅ stress: stress-ng [11]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ Ethernet drivers sanity [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [9]
     🚧 ✅ Storage blktests [10]
     🚧 ✅ stress: stress-ng [11]
     🚧 ✅ selinux-policy: serge-testsuite [8]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
