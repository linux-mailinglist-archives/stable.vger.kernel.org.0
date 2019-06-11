Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD9416C5
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 23:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407012AbfFKVTt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Jun 2019 17:19:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406712AbfFKVTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 17:19:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C2E4859FB
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 21:19:48 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1230E61D15;
        Tue, 11 Jun 2019 21:19:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.8E1A9DF750.6INDCME97T@redhat.com>
X-Gitlab-Pipeline-ID: 12091
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12091?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 11 Jun 2019 21:19:48 +0000 (UTC)
Date:   Tue, 11 Jun 2019 17:19:49 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 2df16141a2c4 - Linux 5.1.9

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
  Commit: 2df16141a2c4 - Linux 5.1.9


We then merged the patchset with `git am`:

  revert-drm-allow-render-capable-master-with-drm_auth.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  media-rockchip-vpu-fix-re-order-probe-error-remove-p.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  media-rockchip-vpu-add-missing-dont_use_autosuspend-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  rapidio-fix-a-null-pointer-dereference-when-create_w.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  fs-fat-file.c-issue-flush-after-the-writeback-of-fat.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  sysctl-return-einval-if-val-violates-minmax.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ipc-prevent-lockup-on-alloc_msg-and-free_msg.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-msm-correct-attempted-null-pointer-dereference-i.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-pl111-initialize-clock-spinlock-early.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-mprotect.c-fix-compilation-warning-because-of-unu.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-prevent-tracing-ipi_cpu_backtrace.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-hmm-select-mmu-notifier-when-selecting-hmm.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  hugetlbfs-on-restore-reserve-error-path-retain-subpo.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-memory_hotplug-release-memory-resource-after-arch.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mem-hotplug-fix-node-spanned-pages-when-we-have-a-no.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-cma.c-fix-crash-on-cma-allocation-if-bitmap-alloc.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  initramfs-free-initrd-memory-if-opening-initrd.image.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-compaction.c-fix-an-undefined-behaviour.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-memory_hotplug.c-fix-the-wrong-usage-of-n_high_me.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-cma.c-fix-the-bitmap-status-to-show-failed-alloca.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-page_mkclean-vs-madv_dontneed-race.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-cma_debug.c-fix-the-break-condition-in-cma_maxchu.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mm-slab.c-fix-an-infinite-loop-in-leaks_show.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  kernel-sys.c-prctl-fix-false-positive-in-validate_pr.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  thermal-rcar_gen3_thermal-disable-interrupt-in-.remo.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drivers-thermal-tsens-don-t-print-error-message-on-e.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mfd-tps65912-spi-add-missing-of-table-registration.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mfd-intel-lpss-set-the-device-in-reset-state-when-in.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-nouveau-disp-dp-respect-sink-limits-when-selecti.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mfd-twl6040-fix-device-init-errors-for-accctl-regist.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  perf-x86-intel-allow-pebs-multi-entry-in-watermark-m.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-nouveau-kms-gf119-gp10x-push-headsetcontroloutpu.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-nouveau-fix-duplication-of-nv50_head_atom-struct.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-bridge-adv7511-fix-low-refresh-rate-selection.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  objtool-don-t-use-ignore-flag-for-fake-jumps.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-nouveau-kms-gv100-fix-spurious-window-immediate-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  bpf-fix-undefined-behavior-in-narrow-load-handling.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  edac-mpc85xx-prevent-building-as-a-module.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pwm-meson-use-the-spin-lock-only-to-protect-register.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mailbox-stm32-ipcc-check-invalid-irq.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ntp-allow-tai-utc-offset-to-be-set-to-zero.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-panic-in-do_recover_data.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-panic-in-f2fs_inplace_write_data.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-error-path-of-recovery.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-panic-in-f2fs_remove_inode_page.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-do-sanity-check-on-free-nid.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-clear-dirty-inode-in-error-path-of-f2fs_.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-panic-in-dec_valid_block_count.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-use-inline-space-only-if-inline_xattr-is.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-panic-in-dec_valid_node_count.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-do-sanity-check-on-valid-block-count-of-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-avoid-deadloop-in-foreground-gc.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-retrieve-inline-xattr-space.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-to-do-checksum-even-if-inode-page-is-uptoda.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  media-atmel-atmel-isc-fix-asd-memory-allocation.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  percpu-remove-spurious-lock-dependency-between-percp.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  configfs-fix-possible-use-after-free-in-configfs_reg.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  uml-fix-a-boot-splat-wrt-use-of-cpu_all_mask.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-dwc-free-msi-in-dw_pcie_host_init-error-path.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-dwc-free-msi-irq-page-in-dw_pcie_free_msi.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  fbcon-don-t-reset-logo_shown-when-logo-is-currently-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ovl-do-not-generate-duplicate-fsnotify-events-for-fa.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mmc-mmci-prevent-polling-for-busy-detection-in-irq-c.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  netfilter-nf_flow_table-fix-missing-error-check-for-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  netfilter-nf_conntrack_h323-restore-boundary-check-c.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  mips-make-sure-dt-memory-regions-are-valid.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  netfilter-nf_tables-fix-base-chain-stat-rcu_derefere.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  watchdog-use-depends-instead-of-select-for-pretimeou.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  watchdog-imx2_wdt-fix-set_timeout-for-big-timeout-va.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  watchdog-fix-compile-time-error-of-pretimeout-govern.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  blk-mq-move-cancel-of-requeue_work-into-blk_mq_relea.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  iommu-vt-d-set-intel_iommu_gfx_mapped-correctly.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  vfio-pci-nvlink2-fix-potential-vma-leak.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  misc-pci_endpoint_test-fix-test_reg_bar-to-be-update.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-designware-ep-use-aligned-atu-window-for-raising.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nvme-pci-unquiesce-admin-queue-on-shutdown.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nvme-pci-shutdown-on-timeout-during-deletion.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  netfilter-nf_flow_table-check-ttl-value-in-flow-offl.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  netfilter-nf_flow_table-fix-netdev-refcnt-leak.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  alsa-hda-register-irq-handler-after-the-chip-initial.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  powerpc-pseries-track-lmb-nid-instead-of-using-devic.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm64-defconfig-update-ufshcd-for-hi3660-soc.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  iommu-vt-d-don-t-request-page-request-irq-under-dmar.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nvmem-core-fix-read-buffer-in-place.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nvmem-sunxi_sid-support-sid-on-a83t-and-h5.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  fuse-require-dev-fuse-reads-to-have-enough-buffer-ca.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  fuse-retrieve-cap-requested-size-to-negotiated-max_w.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nfsd-allow-fh_want_write-to-be-called-twice.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  nfsd-avoid-uninitialized-variable-warning.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  vfio-fix-warning-do-not-call-blocking-ops-when-task_.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  iommu-arm-smmu-v3-don-t-disable-smmu-in-kdump-kernel.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  switchtec-fix-unintended-mask-of-mrpc-event.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  net-thunderbolt-unregister-thunderboltip-protocol-ha.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  x86-pci-fix-pci-irq-routing-table-memory-leak.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  soc-tegra-pmc-remove-reset-sysfs-entries-on-error.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  i40e-queues-are-reserved-despite-invalid-argument-er.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  power-supply-cpcap-battery-fix-signed-counter-sample.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  platform-chrome-cros_ec_proto-check-for-null-transfe.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-keystone-invoke-phy_reset-api-before-enabling-ph.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-keystone-prevent-arm32-specific-code-to-be-compi.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  soc-mediatek-pwrap-zero-initialize-rdata-in-pwrap_in.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  clk-rockchip-turn-on-aclk_dmac1-for-suspend-on-rk328.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  usb-ohci-da8xx-disable-the-regulator-if-the-overcurr.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  iommu-vt-d-flush-iotlb-for-untrusted-device-in-time.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  soc-rockchip-set-the-proper-pwm-for-rk3288.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm64-dts-imx8mq-mark-iomuxc_gpr-as-i.mx6q-compatibl.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx51-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx50-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx53-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ahb-clock-t.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx6sll-specify-imx6sll_clk_ipg-as-ipg-clock.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx7d-specify-imx7d_clk_ipg-as-ipg-clock-to-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx6ul-specify-imx6ul_clk_ipg-as-ipg-clock-t.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ipg-clock-t.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-imx6qdl-specify-imx6qdl_clk_ipg-as-ipg-clock.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-rpadlpar-fix-leaked-device_node-references-in-ad.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-amd-display-disable-link-before-changing-link-se.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  drm-amd-display-use-plane-color_space-for-dpp-if-spe.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  alsa-seq-protect-in-kernel-ioctl-calls-with-mutex.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-omap2-pm33xx-core-do-not-turn-off-cefuse-as-ppa-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pinctrl-pinctrl-intel-move-gpio-suspend-resume-to-no.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  platform-x86-intel_pmc_ipc-adding-error-handling.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  power-supply-max14656-fix-potential-use-before-alloc.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  f2fs-fix-potential-recursive-call-when-enabling-data.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  net-hns3-return-0-and-print-warning-when-hit-duplica.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-dwc-remove-default-msi-initialization-for-platfo.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-rcar-fix-a-potential-null-pointer-dereference.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-rcar-fix-64bit-msi-message-address-handling.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  scsi-qla2xxx-reset-the-fcf_async_-sent-active-flags.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  input-goodix-add-gt5663-ctp-support.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  video-hgafb-fix-potential-null-pointer-dereference.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  video-imsttfb-fix-potential-null-pointer-dereference.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  block-bfq-increase-idling-for-weight-raised-queues.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pci-xilinx-check-for-__get_free_pages-failure.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm64-dts-qcom-qcs404-fix-regulator-supply-names.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  gpio-gpio-omap-add-check-for-off-wake-capable-gpios.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  gpio-gpio-omap-limit-errata-1.101-handling-to-wkup-d.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ice-add-missing-case-in-print_link_msg-for-printing-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  media-v4l2-ctrl-v4l2_ctrl_request_setup-returns-with.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  batman-adv-adjust-name-for-batadv_dat_send_data.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ice-enable-lan_en-for-the-right-recipes.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  ice-do-not-set-lb_en-for-prune-switch-rules.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  dmaengine-idma64-use-actual-device-for-dma-transfers.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pwm-tiehrpwm-update-shadow-register-for-disabling-pw.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  media-v4l2-fwnode-defaults-may-not-override-endpoint.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-dts-exynos-always-enable-necessary-apio_1v8-and-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  pwm-fix-deadlock-warning-when-removing-pwm-device.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-exynos-fix-undefined-instruction-during-exynos54.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  usb-typec-fusb302-check-vconn-is-off-when-we-start-t.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  soc-renesas-identify-r-car-m3-w-es1.3.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  arm-shmobile-porter-enable-r-car-gen2-regulator-quir.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  gpio-vf610-do-not-share-irq_chip.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a
  percpu-do-not-search-past-bitmap-when-allocating-an-.patch?id=cd033818a79dd318c32eb1fa653f75b6fb8eb72a

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-943b76f5396ac0e9c0169b19d56f6757b3e93cfa.tar.gz


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
