Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE64D453B0
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 06:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfFNEqe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Jun 2019 00:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfFNEqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 00:46:34 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D51E3C057F2C
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 04:46:33 +0000 (UTC)
Received: from [172.54.212.135] (cpt-0039.paas.prod.upshift.rdu2.redhat.com [10.0.18.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B9045C673;
        Fri, 14 Jun 2019 04:46:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.8F5FAE659E.I1D30BYTU4@redhat.com>
X-Gitlab-Pipeline-ID: 12327
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/12327?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 14 Jun 2019 04:46:33 +0000 (UTC)
Date:   Fri, 14 Jun 2019 00:46:34 -0400
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

  rapidio-fix-a-null-pointer-dereference-when-create_w.patch
  fs-fat-file.c-issue-flush-after-the-writeback-of-fat.patch
  sysctl-return-einval-if-val-violates-minmax.patch
  ipc-prevent-lockup-on-alloc_msg-and-free_msg.patch
  drm-pl111-initialize-clock-spinlock-early.patch
  arm-prevent-tracing-ipi_cpu_backtrace.patch
  mm-hmm-select-mmu-notifier-when-selecting-hmm.patch
  hugetlbfs-on-restore-reserve-error-path-retain-subpo.patch
  mem-hotplug-fix-node-spanned-pages-when-we-have-a-no.patch
  mm-cma.c-fix-crash-on-cma-allocation-if-bitmap-alloc.patch
  initramfs-free-initrd-memory-if-opening-initrd.image.patch
  mm-cma.c-fix-the-bitmap-status-to-show-failed-alloca.patch
  mm-page_mkclean-vs-madv_dontneed-race.patch
  mm-cma_debug.c-fix-the-break-condition-in-cma_maxchu.patch
  mm-slab.c-fix-an-infinite-loop-in-leaks_show.patch
  kernel-sys.c-prctl-fix-false-positive-in-validate_pr.patch
  thermal-rcar_gen3_thermal-disable-interrupt-in-.remo.patch
  drivers-thermal-tsens-don-t-print-error-message-on-e.patch
  mfd-tps65912-spi-add-missing-of-table-registration.patch
  mfd-intel-lpss-set-the-device-in-reset-state-when-in.patch
  drm-nouveau-disp-dp-respect-sink-limits-when-selecti.patch
  mfd-twl6040-fix-device-init-errors-for-accctl-regist.patch
  perf-x86-intel-allow-pebs-multi-entry-in-watermark-m.patch
  drm-nouveau-kms-gf119-gp10x-push-headsetcontroloutpu.patch
  drm-bridge-adv7511-fix-low-refresh-rate-selection.patch
  objtool-don-t-use-ignore-flag-for-fake-jumps.patch
  drm-nouveau-kms-gv100-fix-spurious-window-immediate-.patch
  bpf-fix-undefined-behavior-in-narrow-load-handling.patch
  edac-mpc85xx-prevent-building-as-a-module.patch
  pwm-meson-use-the-spin-lock-only-to-protect-register.patch
  mailbox-stm32-ipcc-check-invalid-irq.patch
  ntp-allow-tai-utc-offset-to-be-set-to-zero.patch
  f2fs-fix-to-avoid-panic-in-do_recover_data.patch
  f2fs-fix-to-avoid-panic-in-f2fs_inplace_write_data.patch
  f2fs-fix-to-avoid-panic-in-f2fs_remove_inode_page.patch
  f2fs-fix-to-do-sanity-check-on-free-nid.patch
  f2fs-fix-to-clear-dirty-inode-in-error-path-of-f2fs_.patch
  f2fs-fix-to-avoid-panic-in-dec_valid_block_count.patch
  f2fs-fix-to-use-inline-space-only-if-inline_xattr-is.patch
  f2fs-fix-to-do-sanity-check-on-valid-block-count-of-.patch
  f2fs-fix-to-do-checksum-even-if-inode-page-is-uptoda.patch
  percpu-remove-spurious-lock-dependency-between-percp.patch
  configfs-fix-possible-use-after-free-in-configfs_reg.patch
  uml-fix-a-boot-splat-wrt-use-of-cpu_all_mask.patch
  pci-dwc-free-msi-in-dw_pcie_host_init-error-path.patch
  pci-dwc-free-msi-irq-page-in-dw_pcie_free_msi.patch
  ovl-do-not-generate-duplicate-fsnotify-events-for-fa.patch
  mmc-mmci-prevent-polling-for-busy-detection-in-irq-c.patch
  netfilter-nf_flow_table-fix-missing-error-check-for-.patch
  netfilter-nf_conntrack_h323-restore-boundary-check-c.patch
  mips-make-sure-dt-memory-regions-are-valid.patch
  netfilter-nf_tables-fix-base-chain-stat-rcu_derefere.patch
  watchdog-imx2_wdt-fix-set_timeout-for-big-timeout-va.patch
  watchdog-fix-compile-time-error-of-pretimeout-govern.patch
  blk-mq-move-cancel-of-requeue_work-into-blk_mq_relea.patch
  iommu-vt-d-set-intel_iommu_gfx_mapped-correctly.patch
  misc-pci_endpoint_test-fix-test_reg_bar-to-be-update.patch
  pci-designware-ep-use-aligned-atu-window-for-raising.patch
  nvme-pci-unquiesce-admin-queue-on-shutdown.patch
  nvme-pci-shutdown-on-timeout-during-deletion.patch
  netfilter-nf_flow_table-check-ttl-value-in-flow-offl.patch
  netfilter-nf_flow_table-fix-netdev-refcnt-leak.patch
  alsa-hda-register-irq-handler-after-the-chip-initial.patch
  nvmem-core-fix-read-buffer-in-place.patch
  nvmem-sunxi_sid-support-sid-on-a83t-and-h5.patch
  fuse-retrieve-cap-requested-size-to-negotiated-max_w.patch
  nfsd-allow-fh_want_write-to-be-called-twice.patch
  nfsd-avoid-uninitialized-variable-warning.patch
  vfio-fix-warning-do-not-call-blocking-ops-when-task_.patch
  iommu-arm-smmu-v3-don-t-disable-smmu-in-kdump-kernel.patch
  switchtec-fix-unintended-mask-of-mrpc-event.patch
  net-thunderbolt-unregister-thunderboltip-protocol-ha.patch
  x86-pci-fix-pci-irq-routing-table-memory-leak.patch
  i40e-queues-are-reserved-despite-invalid-argument-er.patch
  platform-chrome-cros_ec_proto-check-for-null-transfe.patch
  pci-keystone-prevent-arm32-specific-code-to-be-compi.patch
  soc-mediatek-pwrap-zero-initialize-rdata-in-pwrap_in.patch
  clk-rockchip-turn-on-aclk_dmac1-for-suspend-on-rk328.patch
  soc-rockchip-set-the-proper-pwm-for-rk3288.patch
  arm-dts-imx51-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch
  arm-dts-imx50-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch
  arm-dts-imx53-specify-imx5_clk_ipg-as-ahb-clock-to-s.patch
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ahb-clock-t.patch
  arm-dts-imx6sll-specify-imx6sll_clk_ipg-as-ipg-clock.patch
  arm-dts-imx7d-specify-imx7d_clk_ipg-as-ipg-clock-to-.patch
  arm-dts-imx6ul-specify-imx6ul_clk_ipg-as-ipg-clock-t.patch
  arm-dts-imx6sx-specify-imx6sx_clk_ipg-as-ipg-clock-t.patch
  arm-dts-imx6qdl-specify-imx6qdl_clk_ipg-as-ipg-clock.patch
  pci-rpadlpar-fix-leaked-device_node-references-in-ad.patch
  drm-amd-display-use-plane-color_space-for-dpp-if-spe.patch
  arm-omap2-pm33xx-core-do-not-turn-off-cefuse-as-ppa-.patch
  platform-x86-intel_pmc_ipc-adding-error-handling.patch
  power-supply-max14656-fix-potential-use-before-alloc.patch
  net-hns3-return-0-and-print-warning-when-hit-duplica.patch
  pci-rcar-fix-a-potential-null-pointer-dereference.patch
  pci-rcar-fix-64bit-msi-message-address-handling.patch
  scsi-qla2xxx-reset-the-fcf_async_-sent-active-flags.patch
  video-hgafb-fix-potential-null-pointer-dereference.patch
  video-imsttfb-fix-potential-null-pointer-dereference.patch
  block-bfq-increase-idling-for-weight-raised-queues.patch
  pci-xilinx-check-for-__get_free_pages-failure.patch
  gpio-gpio-omap-add-check-for-off-wake-capable-gpios.patch
  ice-add-missing-case-in-print_link_msg-for-printing-.patch
  dmaengine-idma64-use-actual-device-for-dma-transfers.patch
  pwm-tiehrpwm-update-shadow-register-for-disabling-pw.patch
  arm-dts-exynos-always-enable-necessary-apio_1v8-and-.patch
  pwm-fix-deadlock-warning-when-removing-pwm-device.patch
  arm-exynos-fix-undefined-instruction-during-exynos54.patch
  usb-typec-fusb302-check-vconn-is-off-when-we-start-t.patch
  soc-renesas-identify-r-car-m3-w-es1.3.patch
  gpio-vf610-do-not-share-irq_chip.patch
  percpu-do-not-search-past-bitmap-when-allocating-an-.patch
  revert-bluetooth-align-minimum-encryption-key-size-for-le-and-br-edr-connections.patch
  revert-drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
  ovl-check-the-capability-before-cred-overridden.patch
  ovl-support-stacked-seek_hole-seek_data.patch
  drm-vc4-fix-fb-references-in-async-update.patch
  alsa-seq-cover-unsubscribe_port-in-list_mutex.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-be3e0c1129ba4a5e30f2df16d9e1626e869834fd.tar.gz


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

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [16]


  x86_64:
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
