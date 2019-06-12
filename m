Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6B741A59
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 04:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405826AbfFLCX5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Jun 2019 22:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405684AbfFLCX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 22:23:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F1CF3082E03
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 02:23:56 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D03BC60C9D;
        Wed, 12 Jun 2019 02:23:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.2A39666997.Z0QIUO6HDM@redhat.com>
X-Gitlab-Pipeline-ID: 12122
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12122?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 12 Jun 2019 02:23:56 +0000 (UTC)
Date:   Tue, 11 Jun 2019 22:23:57 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 768292d05361 - Linux 4.19.50

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
  Commit: 768292d05361 - Linux 4.19.50


We then merged the patchset with `git am`:

  rapidio-fix-a-null-pointer-dereference-when-create_w.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  fs-fat-file.c-issue-flush-after-the-writeback-of-fat.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  sysctl-return-einval-if-val-violates-minmax.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  ipc-prevent-lockup-on-alloc_msg-and-free_msg.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-pl111-initialize-clock-spinlock-early.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-prevent-tracing-ipi_cpu_backtrace.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-hmm-select-mmu-notifier-when-selecting-hmm.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  hugetlbfs-on-restore-reserve-error-path-retain-subpo.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mem-hotplug-fix-node-spanned-pages-when-we-have-a-no.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-cma.c-fix-crash-on-cma-allocation-if-bitmap-alloc.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  initramfs-free-initrd-memory-if-opening-initrd.image.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-cma.c-fix-the-bitmap-status-to-show-failed-alloca.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-page_mkclean-vs-madv_dontneed-race.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-cma_debug.c-fix-the-break-condition-in-cma_maxchu.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mm-slab.c-fix-an-infinite-loop-in-leaks_show.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  kernel-sys.c-prctl-fix-false-positive-in-validate_pr.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  thermal-rcar_gen3_thermal-disable-interrupt-in-.remo.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drivers-thermal-tsens-don-t-print-error-message-on-e.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mfd-tps65912-spi-add-missing-of-table-registration.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mfd-intel-lpss-set-the-device-in-reset-state-when-in.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-nouveau-disp-dp-respect-sink-limits-when-selecti.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mfd-twl6040-fix-device-init-errors-for-accctl-regist.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  perf-x86-intel-allow-pebs-multi-entry-in-watermark-m.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-nouveau-kms-gf119-gp10x-push-headsetcontroloutpu.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-bridge-adv7511-fix-low-refresh-rate-selection.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  objtool-don-t-use-ignore-flag-for-fake-jumps.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-nouveau-kms-gv100-fix-spurious-window-immediate-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  bpf-fix-undefined-behavior-in-narrow-load-handling.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  edac-mpc85xx-prevent-building-as-a-module.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pwm-meson-use-the-spin-lock-only-to-protect-register.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mailbox-stm32-ipcc-check-invalid-irq.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  ntp-allow-tai-utc-offset-to-be-set-to-zero.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-avoid-panic-in-do_recover_data.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-avoid-panic-in-f2fs_inplace_write_data.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-avoid-panic-in-f2fs_remove_inode_page.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-do-sanity-check-on-free-nid.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-clear-dirty-inode-in-error-path-of-f2fs_.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-avoid-panic-in-dec_valid_block_count.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-use-inline-space-only-if-inline_xattr-is.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-do-sanity-check-on-valid-block-count-of-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  f2fs-fix-to-do-checksum-even-if-inode-page-is-uptoda.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  percpu-remove-spurious-lock-dependency-between-percp.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  configfs-fix-possible-use-after-free-in-configfs_reg.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  uml-fix-a-boot-splat-wrt-use-of-cpu_all_mask.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-dwc-free-msi-in-dw_pcie_host_init-error-path.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-dwc-free-msi-irq-page-in-dw_pcie_free_msi.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  ovl-do-not-generate-duplicate-fsnotify-events-for-fa.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mmc-mmci-prevent-polling-for-busy-detection-in-irq-c.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  netfilter-nf_flow_table-fix-missing-error-check-for-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  netfilter-nf_conntrack_h323-restore-boundary-check-c.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  mips-make-sure-dt-memory-regions-are-valid.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  netfilter-nf_tables-fix-base-chain-stat-rcu_derefere.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  watchdog-imx2_wdt-fix-set_timeout-for-big-timeout-va.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  watchdog-fix-compile-time-error-of-pretimeout-govern.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  blk-mq-move-cancel-of-requeue_work-into-blk_mq_relea.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  iommu-vt-d-set-intel_iommu_gfx_mapped-correctly.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  misc-pci_endpoint_test-fix-test_reg_bar-to-be-update.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-designware-ep-use-aligned-atu-window-for-raising.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nvme-pci-unquiesce-admin-queue-on-shutdown.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nvme-pci-shutdown-on-timeout-during-deletion.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  netfilter-nf_flow_table-check-ttl-value-in-flow-offl.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  netfilter-nf_flow_table-fix-netdev-refcnt-leak.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  alsa-hda-register-irq-handler-after-the-chip-initial.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nvmem-core-fix-read-buffer-in-place.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nvmem-sunxi_sid-support-sid-on-a83t-and-h5.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  fuse-retrieve-cap-requested-size-to-negotiated-max_w.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nfsd-allow-fh_want_write-to-be-called-twice.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  nfsd-avoid-uninitialized-variable-warning.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  vfio-fix-warning-do-not-call-blocking-ops-when-task_.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  iommu-arm-smmu-v3-don-t-disable-smmu-in-kdump-kernel.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  switchtec-fix-unintended-mask-of-mrpc-event.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  net-thunderbolt-unregister-thunderboltip-protocol-ha.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  x86-pci-fix-pci-irq-routing-table-memory-leak.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  i40e-queues-are-reserved-despite-invalid-argument-er.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  platform-chrome-cros_ec_proto-check-for-null-transfe.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-keystone-prevent-arm32-specific-code-to-be-compi.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  soc-mediatek-pwrap-zero-initialize-rdata-in-pwrap_in.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  clk-rockchip-turn-on-aclk_dmac1-for-suspend-on-rk328.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  soc-rockchip-set-the-proper-pwm-for-rk3288.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx51-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx50-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx53-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ahb-clock-t.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx6sll-specify-imx6sll_clk_ipg-as-ipg-clock.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx7d-specify-imx7d_clk_ipg-as-ipg-clock-to-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx6ul-specify-imx6ul_clk_ipg-as-ipg-clock-t.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ipg-clock-t.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-imx6qdl-specify-imx6qdl_clk_ipg-as-ipg-clock.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-rpadlpar-fix-leaked-device_node-references-in-ad.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  drm-amd-display-use-plane-color_space-for-dpp-if-spe.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  alsa-seq-protect-in-kernel-ioctl-calls-with-mutex.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-omap2-pm33xx-core-do-not-turn-off-cefuse-as-ppa-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  platform-x86-intel_pmc_ipc-adding-error-handling.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  power-supply-max14656-fix-potential-use-before-alloc.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  net-hns3-return-0-and-print-warning-when-hit-duplica.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-rcar-fix-a-potential-null-pointer-dereference.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-rcar-fix-64bit-msi-message-address-handling.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  scsi-qla2xxx-reset-the-fcf_async_-sent-active-flags.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  video-hgafb-fix-potential-null-pointer-dereference.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  video-imsttfb-fix-potential-null-pointer-dereference.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  block-bfq-increase-idling-for-weight-raised-queues.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pci-xilinx-check-for-__get_free_pages-failure.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  gpio-gpio-omap-add-check-for-off-wake-capable-gpios.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  ice-add-missing-case-in-print_link_msg-for-printing-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  dmaengine-idma64-use-actual-device-for-dma-transfers.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pwm-tiehrpwm-update-shadow-register-for-disabling-pw.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-dts-exynos-always-enable-necessary-apio_1v8-and-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  pwm-fix-deadlock-warning-when-removing-pwm-device.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  arm-exynos-fix-undefined-instruction-during-exynos54.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  usb-typec-fusb302-check-vconn-is-off-when-we-start-t.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  soc-renesas-identify-r-car-m3-w-es1.3.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  gpio-vf610-do-not-share-irq_chip.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d
  percpu-do-not-search-past-bitmap-when-allocating-an-.patch?id=92b9533991497aa165ae88cee0ac8f684ec54d7d

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3b1bd29cf9cfd3a03104dfb957ea71327caa75b0.tar.gz


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
       ✅ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ storage: SCSI VPD [14]
       🚧 ✅ storage: software RAID testing [15]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [16]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ storage: software RAID testing [15]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [16]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ tuned: tune-processes-through-perf [10]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ storage: software RAID testing [15]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ Ethernet drivers sanity [6]
       ✅ audit: audit testsuite test [7]
       ✅ httpd: mod_ssl smoke sanity [8]
       ✅ iotop: sanity [9]
       ✅ tuned: tune-processes-through-perf [10]
       ✅ Usex - version 1.9-29 [11]
       ✅ lvm thinp sanity [12]
       🚧 ✅ Networking socket: fuzz [13]
       🚧 ✅ storage: SCSI VPD [14]
       🚧 ✅ storage: software RAID testing [15]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [16]

    Host 2:
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
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
