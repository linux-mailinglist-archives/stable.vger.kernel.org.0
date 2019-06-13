Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41C945022
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 01:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfFMXi5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 13 Jun 2019 19:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbfFMXi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 19:38:57 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 53DD281F0C
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 23:38:56 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C690566D22;
        Thu, 13 Jun 2019 23:38:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.16EA273137.L2CIMEYYHZ@redhat.com>
X-Gitlab-Pipeline-ID: 12240
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12240?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 13 Jun 2019 23:38:56 +0000 (UTC)
Date:   Thu, 13 Jun 2019 19:38:57 -0400
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
  Commit: 768292d05361 - Linux 4.19.50


We then merged the patchset with `git am`:

  rapidio-fix-a-null-pointer-dereference-when-create_w.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  fs-fat-file.c-issue-flush-after-the-writeback-of-fat.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  sysctl-return-einval-if-val-violates-minmax.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  ipc-prevent-lockup-on-alloc_msg-and-free_msg.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-pl111-initialize-clock-spinlock-early.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-prevent-tracing-ipi_cpu_backtrace.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-hmm-select-mmu-notifier-when-selecting-hmm.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  hugetlbfs-on-restore-reserve-error-path-retain-subpo.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mem-hotplug-fix-node-spanned-pages-when-we-have-a-no.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-cma.c-fix-crash-on-cma-allocation-if-bitmap-alloc.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  initramfs-free-initrd-memory-if-opening-initrd.image.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-cma.c-fix-the-bitmap-status-to-show-failed-alloca.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-page_mkclean-vs-madv_dontneed-race.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-cma_debug.c-fix-the-break-condition-in-cma_maxchu.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mm-slab.c-fix-an-infinite-loop-in-leaks_show.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  kernel-sys.c-prctl-fix-false-positive-in-validate_pr.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  thermal-rcar_gen3_thermal-disable-interrupt-in-.remo.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drivers-thermal-tsens-don-t-print-error-message-on-e.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mfd-tps65912-spi-add-missing-of-table-registration.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mfd-intel-lpss-set-the-device-in-reset-state-when-in.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-nouveau-disp-dp-respect-sink-limits-when-selecti.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mfd-twl6040-fix-device-init-errors-for-accctl-regist.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  perf-x86-intel-allow-pebs-multi-entry-in-watermark-m.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-nouveau-kms-gf119-gp10x-push-headsetcontroloutpu.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-bridge-adv7511-fix-low-refresh-rate-selection.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  objtool-don-t-use-ignore-flag-for-fake-jumps.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-nouveau-kms-gv100-fix-spurious-window-immediate-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  bpf-fix-undefined-behavior-in-narrow-load-handling.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  edac-mpc85xx-prevent-building-as-a-module.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pwm-meson-use-the-spin-lock-only-to-protect-register.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mailbox-stm32-ipcc-check-invalid-irq.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  ntp-allow-tai-utc-offset-to-be-set-to-zero.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-avoid-panic-in-do_recover_data.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-avoid-panic-in-f2fs_inplace_write_data.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-avoid-panic-in-f2fs_remove_inode_page.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-do-sanity-check-on-free-nid.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-clear-dirty-inode-in-error-path-of-f2fs_.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-avoid-panic-in-dec_valid_block_count.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-use-inline-space-only-if-inline_xattr-is.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-do-sanity-check-on-valid-block-count-of-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  f2fs-fix-to-do-checksum-even-if-inode-page-is-uptoda.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  percpu-remove-spurious-lock-dependency-between-percp.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  configfs-fix-possible-use-after-free-in-configfs_reg.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  uml-fix-a-boot-splat-wrt-use-of-cpu_all_mask.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-dwc-free-msi-in-dw_pcie_host_init-error-path.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-dwc-free-msi-irq-page-in-dw_pcie_free_msi.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  ovl-do-not-generate-duplicate-fsnotify-events-for-fa.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mmc-mmci-prevent-polling-for-busy-detection-in-irq-c.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  netfilter-nf_flow_table-fix-missing-error-check-for-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  netfilter-nf_conntrack_h323-restore-boundary-check-c.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  mips-make-sure-dt-memory-regions-are-valid.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  netfilter-nf_tables-fix-base-chain-stat-rcu_derefere.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  watchdog-imx2_wdt-fix-set_timeout-for-big-timeout-va.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  watchdog-fix-compile-time-error-of-pretimeout-govern.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  blk-mq-move-cancel-of-requeue_work-into-blk_mq_relea.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  iommu-vt-d-set-intel_iommu_gfx_mapped-correctly.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  misc-pci_endpoint_test-fix-test_reg_bar-to-be-update.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-designware-ep-use-aligned-atu-window-for-raising.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nvme-pci-unquiesce-admin-queue-on-shutdown.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nvme-pci-shutdown-on-timeout-during-deletion.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  netfilter-nf_flow_table-check-ttl-value-in-flow-offl.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  netfilter-nf_flow_table-fix-netdev-refcnt-leak.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  alsa-hda-register-irq-handler-after-the-chip-initial.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nvmem-core-fix-read-buffer-in-place.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nvmem-sunxi_sid-support-sid-on-a83t-and-h5.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  fuse-retrieve-cap-requested-size-to-negotiated-max_w.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nfsd-allow-fh_want_write-to-be-called-twice.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  nfsd-avoid-uninitialized-variable-warning.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  vfio-fix-warning-do-not-call-blocking-ops-when-task_.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  iommu-arm-smmu-v3-don-t-disable-smmu-in-kdump-kernel.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  switchtec-fix-unintended-mask-of-mrpc-event.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  net-thunderbolt-unregister-thunderboltip-protocol-ha.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  x86-pci-fix-pci-irq-routing-table-memory-leak.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  i40e-queues-are-reserved-despite-invalid-argument-er.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  platform-chrome-cros_ec_proto-check-for-null-transfe.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-keystone-prevent-arm32-specific-code-to-be-compi.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  soc-mediatek-pwrap-zero-initialize-rdata-in-pwrap_in.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  clk-rockchip-turn-on-aclk_dmac1-for-suspend-on-rk328.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  soc-rockchip-set-the-proper-pwm-for-rk3288.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx51-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx50-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx53-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ahb-clock-t.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx6sll-specify-imx6sll_clk_ipg-as-ipg-clock.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx7d-specify-imx7d_clk_ipg-as-ipg-clock-to-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx6ul-specify-imx6ul_clk_ipg-as-ipg-clock-t.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ipg-clock-t.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-imx6qdl-specify-imx6qdl_clk_ipg-as-ipg-clock.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-rpadlpar-fix-leaked-device_node-references-in-ad.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  drm-amd-display-use-plane-color_space-for-dpp-if-spe.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  alsa-seq-protect-in-kernel-ioctl-calls-with-mutex.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-omap2-pm33xx-core-do-not-turn-off-cefuse-as-ppa-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  platform-x86-intel_pmc_ipc-adding-error-handling.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  power-supply-max14656-fix-potential-use-before-alloc.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  net-hns3-return-0-and-print-warning-when-hit-duplica.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-rcar-fix-a-potential-null-pointer-dereference.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-rcar-fix-64bit-msi-message-address-handling.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  scsi-qla2xxx-reset-the-fcf_async_-sent-active-flags.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  video-hgafb-fix-potential-null-pointer-dereference.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  video-imsttfb-fix-potential-null-pointer-dereference.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  block-bfq-increase-idling-for-weight-raised-queues.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pci-xilinx-check-for-__get_free_pages-failure.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  gpio-gpio-omap-add-check-for-off-wake-capable-gpios.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  ice-add-missing-case-in-print_link_msg-for-printing-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  dmaengine-idma64-use-actual-device-for-dma-transfers.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pwm-tiehrpwm-update-shadow-register-for-disabling-pw.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-dts-exynos-always-enable-necessary-apio_1v8-and-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  pwm-fix-deadlock-warning-when-removing-pwm-device.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  arm-exynos-fix-undefined-instruction-during-exynos54.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  usb-typec-fusb302-check-vconn-is-off-when-we-start-t.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  soc-renesas-identify-r-car-m3-w-es1.3.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  gpio-vf610-do-not-share-irq_chip.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2
  percpu-do-not-search-past-bitmap-when-allocating-an-.patch?id=b2518eb3670e3db2555467979c343aacb6d912a2

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3ab49b60afbaa3ee74e872def60b4e6f06e6fc3f.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ AMTU (Abstract Machine Test Utility) [3]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ Usex - version 1.9-29 [9]
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ storage: SCSI VPD [12]
       🚧 ✅ storage: software RAID testing [13]
       🚧 ✅ Libhugetlbfs - version 2.2.1 [14]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: xfs [15]
       ✅ selinux-policy: serge-testsuite [16]


  ppc64le:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [16]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [1]
       ✅ Loopdev Sanity [2]
       ✅ Ethernet drivers sanity [4]
       ✅ audit: audit testsuite test [5]
       ✅ httpd: mod_ssl smoke sanity [6]
       ✅ iotop: sanity [7]
       ✅ tuned: tune-processes-through-perf [8]
       ✅ lvm thinp sanity [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ storage: software RAID testing [13]


  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#vm/hugepage/libhugetlbfs
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
