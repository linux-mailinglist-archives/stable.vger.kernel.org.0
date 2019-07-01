Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C621E2EDA0
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfE3Dif convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 23:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfE3Die (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:38:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4A51F449C
        for <stable@vger.kernel.org>; Thu, 30 May 2019 03:38:33 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C4666148C;
        Thu, 30 May 2019 03:38:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.7352B166A1.X6OFU70CT1@redhat.com>
X-Gitlab-Pipeline-ID: 11093
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11093?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 30 May 2019 03:38:33 +0000 (UTC)
Date:   Wed, 29 May 2019 23:38:34 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 8b2fc0058255 - Linux 4.19.46

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
  Commit: 8b2fc0058255 - Linux 4.19.46


We then merged the patchset with `git am`:

  x86-hide-the-int3_emulate_call-jmp-functions-from-uml.patch
  ext4-do-not-delete-unlinked-inode-from-orphan-list-on-failed-truncate.patch
  ext4-wait-for-outstanding-dio-during-truncate-in-nojournal-mode.patch
  f2fs-fix-use-of-number-of-devices.patch
  kvm-x86-fix-return-value-for-reserved-efer.patch
  bio-fix-improper-use-of-smp_mb__before_atomic.patch
  sbitmap-fix-improper-use-of-smp_mb__before_atomic.patch
  revert-scsi-sd-keep-disk-read-only-when-re-reading-partition.patch
  crypto-vmx-ctr-always-increment-iv-as-quadword.patch
  mmc-sdhci-iproc-cygnus-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  mmc-sdhci-iproc-set-no_hispd-bit-to-fix-hs50-data-hold-time-problem.patch
  kvm-svm-avic-fix-off-by-one-in-checking-host-apic-id.patch
  libnvdimm-pmem-bypass-config_hardened_usercopy-overhead.patch
  arm64-kernel-kaslr-reduce-module-randomization-range-to-2-gb.patch
  arm64-iommu-handle-non-remapped-addresses-in-mmap-and-get_sgtable.patch
  gfs2-fix-sign-extension-bug-in-gfs2_update_stats.patch
  btrfs-don-t-double-unlock-on-error-in-btrfs_punch_hole.patch
  btrfs-do-not-abort-transaction-at-btrfs_update_root-after-failure-to-cow-path.patch
  btrfs-avoid-fallback-to-transaction-commit-during-fsync-of-files-with-holes.patch
  btrfs-fix-race-between-ranged-fsync-and-writeback-of-adjacent-ranges.patch
  btrfs-sysfs-fix-error-path-kobject-memory-leak.patch
  btrfs-sysfs-don-t-leak-memory-when-failing-add-fsid.patch
  udlfb-fix-some-inconsistent-null-checking.patch
  fbdev-fix-divide-error-in-fb_var_to_videomode.patch
  nfsv4.2-fix-unnecessary-retry-in-nfs4_copy_file_range.patch
  nfsv4.1-fix-incorrect-return-value-in-copy_file_range.patch
  bpf-add-bpf_jit_limit-knob-to-restrict-unpriv-allocations.patch
  brcmfmac-assure-ssid-length-from-firmware-is-limited.patch
  brcmfmac-add-subtype-check-for-event-handling-in-data-path.patch
  arm64-errata-add-workaround-for-cortex-a76-erratum-1463225.patch
  btrfs-honor-path-skip_locking-in-backref-code.patch
  ovl-relax-warn_on-for-overlapping-layers-use-case.patch
  fbdev-fix-warning-in-__alloc_pages_nodemask-bug.patch
  media-cpia2-fix-use-after-free-in-cpia2_exit.patch
  media-serial_ir-fix-use-after-free-in-serial_ir_init_module.patch
  media-vb2-add-waiting_in_dqbuf-flag.patch
  media-vivid-use-vfree-instead-of-kfree-for-dev-bitmap_cap.patch
  ssb-fix-possible-null-pointer-dereference-in-ssb_host_pcmcia_exit.patch
  bpf-devmap-fix-use-after-free-read-in-__dev_map_entry_free.patch
  batman-adv-mcast-fix-multicast-tt-tvlv-worker-locking.patch
  at76c50x-usb-don-t-register-led_trigger-if-usb_register_driver-failed.patch
  acct_on-don-t-mess-with-freeze-protection.patch
  revert-btrfs-honour-fitrim-range-constraints-during-free-space-trim.patch
  gfs2-fix-lru_count-going-negative.patch
  cxgb4-fix-error-path-in-cxgb4_init_module.patch
  nfs-make-nfs_match_client-killable.patch
  ib-hfi1-fix-wq_mem_reclaim-warning.patch
  gfs2-fix-occasional-glock-use-after-free.patch
  mmc-core-verify-sd-bus-width.patch
  tools-bpf-fix-perf-build-error-with-uclibc-seen-on-a.patch
  selftests-bpf-set-rlimit_memlock-properly-for-test_l.patch
  bpftool-exclude-bash-completion-bpftool-from-.gitign.patch
  dmaengine-tegra210-dma-free-dma-controller-in-remove.patch
  net-ena-gcc-8-fix-compilation-warning.patch
  hv_netvsc-fix-race-that-may-miss-tx-queue-wakeup.patch
  bluetooth-ignore-cc-events-not-matching-the-last-hci.patch
  pinctrl-zte-fix-leaked-of_node-references.patch
  asoc-intel-kbl_da7219_max98357a-map-btn_0-to-key_pla.patch
  usb-dwc2-gadget-increase-descriptors-count-for-isoc-.patch
  usb-dwc3-move-synchronize_irq-out-of-the-spinlock-pr.patch
  asoc-hdmi-codec-unlock-the-device-on-startup-errors.patch
  powerpc-perf-return-accordingly-on-invalid-chip-id-i.patch
  powerpc-boot-fix-missing-check-of-lseek-return-value.patch
  powerpc-perf-fix-loop-exit-condition-in-nest_imc_eve.patch
  asoc-imx-fix-fiq-dependencies.patch
  spi-pxa2xx-fix-scr-divisor-calculation.patch
  brcm80211-potential-null-dereference-in-brcmf_cfg802.patch
  acpi-property-fix-handling-of-data_nodes-in-acpi_get.patch
  drm-nouveau-bar-nv50-ensure-bar-is-mapped.patch
  media-stm32-dcmi-return-appropriate-error-codes-duri.patch
  arm-vdso-remove-dependency-with-the-arch_timer-drive.patch
  arm64-fix-compiler-warning-from-pte_unmap-with-wunus.patch
  powerpc-watchdog-use-hrtimers-for-per-cpu-heartbeat.patch
  sched-cpufreq-fix-kobject-memleak.patch
  scsi-qla2xxx-fix-a-qla24xx_enable_msix-error-path.patch
  scsi-qla2xxx-fix-abort-handling-in-tcm_qla2xxx_write.patch
  scsi-qla2xxx-avoid-that-lockdep-complains-about-unsa.patch
  scsi-qla2xxx-fix-hardirq-unsafe-locking.patch
  x86-modules-avoid-breaking-w-x-while-loading-modules.patch
  btrfs-fix-data-bytes_may_use-underflow-with-fallocat.patch
  btrfs-fix-panic-during-relocation-after-enospc-befor.patch
  btrfs-don-t-panic-when-we-can-t-find-a-root-key.patch
  iwlwifi-pcie-don-t-crash-on-invalid-rx-interrupt.patch
  rtc-88pm860x-prevent-use-after-free-on-device-remove.patch
  rtc-stm32-manage-the-get_irq-probe-defer-case.patch
  scsi-qedi-abort-ep-termination-if-offload-not-schedu.patch
  s390-kexec_file-fix-detection-of-text-segment-in-elf.patch
  sched-nohz-run-nohz-idle-load-balancer-on-hk_flag_mi.patch
  w1-fix-the-resume-command-api.patch
  s390-qeth-address-type-mismatch-warning.patch
  dmaengine-pl330-_stop-clear-interrupt-status.patch
  mac80211-cfg80211-update-bss-channel-on-channel-swit.patch
  libbpf-fix-samples-bpf-build-failure-due-to-undefine.patch
  slimbus-fix-a-potential-null-pointer-dereference-in-.patch
  asoc-fsl_sai-update-is_slave_mode-with-correct-value.patch
  mwifiex-prevent-an-array-overflow.patch
  rsi-fix-null-pointer-dereference-in-kmalloc.patch
  net-cw1200-fix-a-null-pointer-dereference.patch
  nvme-set-0-capacity-if-namespace-block-size-exceeds-.patch
  nvme-rdma-fix-a-null-deref-when-an-admin-connect-tim.patch
  crypto-sun4i-ss-fix-invalid-calculation-of-hash-end.patch
  bcache-avoid-potential-memleak-of-list-of-journal_re.patch
  bcache-return-error-immediately-in-bch_journal_repla.patch
  bcache-fix-failure-in-journal-relplay.patch
  bcache-add-failure-check-to-run_cache_set-for-journa.patch
  bcache-avoid-clang-wunintialized-warning.patch
  rdma-cma-consider-scope_id-while-binding-to-ipv6-ll-.patch
  vfio-ccw-do-not-call-flush_workqueue-while-holding-t.patch
  vfio-ccw-release-any-channel-program-when-releasing-.patch
  x86-build-move-_etext-to-actual-end-of-.text.patch
  smpboot-place-the-__percpu-annotation-correctly.patch
  x86-mm-remove-in_nmi-warning-from-64-bit-implementat.patch
  mm-uaccess-use-unsigned-long-to-placate-ubsan-warnin.patch
  bluetooth-hci_qca-give-enough-time-to-rome-controlle.patch
  hid-logitech-hidpp-use-rap-instead-of-fap-to-get-the.patch
  pinctrl-pistachio-fix-leaked-of_node-references.patch
  pinctrl-samsung-fix-leaked-of_node-references.patch
  clk-rockchip-undo-several-noc-and-special-clocks-as-.patch
  perf-arm-cci-remove-broken-race-mitigation.patch
  dmaengine-at_xdmac-remove-bug_on-macro-in-tasklet.patch
  media-coda-clear-error-return-value-before-picture-r.patch
  media-ov6650-move-v4l2_clk_get-to-ov6650_video_probe.patch
  media-au0828-stop-video-streaming-only-when-last-use.patch
  media-ov2659-make-s_fmt-succeed-even-if-requested-fo.patch
  audit-fix-a-memory-leak-bug.patch
  media-stm32-dcmi-fix-crash-when-subdev-do-not-expose.patch
  media-au0828-fix-null-pointer-dereference-in-au0828_.patch
  media-pvrusb2-prevent-a-buffer-overflow.patch
  iio-adc-stm32-dfsdm-fix-unmet-direct-dependencies-de.patch
  block-fix-use-after-free-on-gendisk.patch
  powerpc-numa-improve-control-of-topology-updates.patch
  powerpc-64-fix-booting-large-kernels-with-strict_ker.patch
  random-fix-crng-initialization-when-random.trust_cpu.patch
  random-add-a-spinlock_t-to-struct-batched_entropy.patch
  cgroup-protect-cgroup-nr_-dying_-descendants-by-css_.patch
  sched-core-check-quota-and-period-overflow-at-usec-t.patch
  sched-rt-check-integer-overflow-at-usec-to-nsec-conv.patch
  sched-core-handle-overflow-in-cpu_shares_write_u64.patch
  staging-vc04_services-handle-kzalloc-failure.patch
  drm-msm-a5xx-fix-possible-object-reference-leak.patch
  irq_work-do-not-raise-an-ipi-when-queueing-work-on-t.patch
  thunderbolt-take-domain-lock-in-switch-sysfs-attribu.patch
  s390-qeth-handle-error-from-qeth_update_from_chp_des.patch
  usb-core-don-t-unbind-interfaces-following-device-re.patch
  x86-irq-64-limit-ist-stack-overflow-check-to-db-stac.patch
  drm-etnaviv-avoid-dma-api-warning-when-importing-buf.patch
  phy-sun4i-usb-make-sure-to-disable-phy0-passby-for-p.patch
  phy-mapphone-mdm6600-add-gpiolib-dependency.patch
  i40e-able-to-add-up-to-16-mac-filters-on-an-untruste.patch
  i40e-don-t-allow-changes-to-hw-vlan-stripping-on-act.patch
  acpi-iort-reject-platform-device-creation-on-numa-no.patch
  arm64-vdso-fix-clock_getres-for-clock_realtime.patch
  rdma-cxgb4-fix-null-pointer-dereference-on-alloc_skb.patch
  perf-x86-msr-add-icelake-support.patch
  perf-x86-intel-rapl-add-icelake-support.patch
  perf-x86-intel-cstate-add-icelake-support.patch
  hwmon-vt1211-use-request_muxed_region-for-super-io-a.patch
  hwmon-smsc47m1-use-request_muxed_region-for-super-io.patch
  hwmon-smsc47b397-use-request_muxed_region-for-super-.patch
  hwmon-pc87427-use-request_muxed_region-for-super-io-.patch
  hwmon-f71805f-use-request_muxed_region-for-super-io-.patch
  scsi-libsas-do-discovery-on-empty-phy-to-update-phy-.patch
  mmc-core-make-pwrseq_emmc-partially-support-sleepy-g.patch
  mmc_spi-add-a-status-check-for-spi_sync_locked.patch
  mmc-sdhci-of-esdhc-add-erratum-esdhc5-support.patch
  mmc-sdhci-of-esdhc-add-erratum-a-009204-support.patch
  mmc-sdhci-of-esdhc-add-erratum-esdhc-a001-and-a-0083.patch
  drm-amdgpu-fix-old-fence-check-in-amdgpu_fence_emit.patch
  pm-core-propagate-dev-power.wakeup_path-when-no-call.patch
  clk-rockchip-fix-video-codec-clocks-on-rk3288.patch
  extcon-arizona-disable-mic-detect-if-running-when-dr.patch
  clk-rockchip-make-rkpwm-a-critical-clock-on-rk3288.patch
  s390-zcrypt-initialize-variables-before_use.patch
  x86-microcode-fix-the-ancient-deprecated-microcode-l.patch
  s390-mm-silence-compiler-warning-when-compiling-with.patch
  s390-cio-fix-cio_irb-declaration.patch
  selftests-cgroup-fix-cleanup-path-in-test_memcg_subt.patch
  qmi_wwan-add-quirk-for-quectel-dynamic-config.patch
  cpufreq-ppc_cbe-fix-possible-object-reference-leak.patch
  cpufreq-pasemi-fix-possible-object-reference-leak.patch
  cpufreq-pmac32-fix-possible-object-reference-leak.patch
  cpufreq-kirkwood-fix-possible-object-reference-leak.patch
  block-sed-opal-fix-ioc_opal_enable_disable_mbr.patch
  x86-build-keep-local-relocations-with-ld.lld.patch
  drm-pl111-fix-possible-object-reference-leak.patch
  iio-ad_sigma_delta-properly-handle-spi-bus-locking-v.patch
  iio-hmc5843-fix-potential-null-pointer-dereferences.patch
  iio-common-ssp_sensors-initialize-calculated_time-in.patch
  iio-adc-ti-ads7950-fix-improper-use-of-mlock.patch
  selftests-bpf-ksym_search-won-t-check-symbols-exists.patch
  rtlwifi-fix-a-potential-null-pointer-dereference.patch
  mwifiex-fix-mem-leak-in-mwifiex_tm_cmd.patch
  brcmfmac-fix-missing-checks-for-kmemdup.patch
  b43-shut-up-clang-wuninitialized-variable-warning.patch
  brcmfmac-convert-dev_init_lock-mutex-to-completion.patch
  brcmfmac-fix-warning-during-usb-disconnect-in-case-o.patch
  brcmfmac-fix-race-during-disconnect-when-usb-complet.patch
  brcmfmac-fix-oops-when-bringing-up-interface-during-.patch
  rtc-xgene-fix-possible-race-condition.patch
  rtlwifi-fix-potential-null-pointer-dereference.patch
  scsi-ufs-fix-regulator-load-and-icc-level-configurat.patch
  scsi-ufs-avoid-configuring-regulator-with-undefined-.patch
  drm-panel-otm8009a-add-delay-at-the-end-of-initializ.patch
  arm64-cpu_ops-fix-a-leaked-reference-by-adding-missi.patch
  wil6210-fix-return-code-of-wmi_mgmt_tx-and-wmi_mgmt_.patch
  x86-uaccess-ftrace-fix-ftrace_likely_update-vs.-smap.patch
  x86-uaccess-signal-fix-ac-1-bloat.patch
  x86-ia32-fix-ia32_restore_sigcontext-ac-leak.patch
  x86-uaccess-fix-up-the-fixup.patch
  chardev-add-additional-check-for-minor-range-overlap.patch
  rdma-hns-fix-bad-endianess-of-port_pd-variable.patch
  sh-sh7786-add-explicit-i-o-cast-to-sh7786_mm_sel.patch
  hid-core-move-usage-page-concatenation-to-main-item.patch
  asoc-eukrea-tlv320-fix-a-leaked-reference-by-adding-.patch
  asoc-fsl_utils-fix-a-leaked-reference-by-adding-miss.patch
  cxgb3-l2t-fix-undefined-behaviour.patch
  hid-logitech-hidpp-change-low-battery-level-threshol.patch
  spi-tegra114-reset-controller-on-probe.patch
  kobject-don-t-trigger-kobject_uevent-kobj_remove-twi.patch
  media-video-mux-fix-null-pointer-dereferences.patch
  media-wl128x-prevent-two-potential-buffer-overflows.patch
  media-gspca-kill-urbs-on-usb-device-disconnect.patch
  efifb-omit-memory-map-check-on-legacy-boot.patch
  thunderbolt-property-fix-a-missing-check-of-kzalloc.patch
  thunderbolt-fix-to-check-the-return-value-of-kmemdup.patch
  timekeeping-force-upper-bound-for-setting-clock_real.patch
  scsi-qedf-add-missing-return-in-qedf_post_io_req-in-.patch
  virtio_console-initialize-vtermno-value-for-ports.patch
  tty-ipwireless-fix-missing-checks-for-ioremap.patch
  overflow-fix-wtype-limits-compilation-warnings.patch
  x86-mce-fix-machine_check_poll-tests-for-error-types.patch
  rcutorture-fix-cleanup-path-for-invalid-torture_type.patch
  x86-mce-handle-varying-mca-bank-counts.patch
  rcuperf-fix-cleanup-path-for-invalid-perf_type-strin.patch
  usb-core-add-pm-runtime-calls-to-usb_hcd_platform_sh.patch
  scsi-qla4xxx-avoid-freeing-unallocated-dma-memory.patch
  scsi-lpfc-avoid-uninitialized-variable-warning.patch
  selinux-avoid-uninitialized-variable-warning.patch
  batman-adv-allow-updating-dat-entry-timeouts-on-inco.patch
  dmaengine-tegra210-adma-use-devm_clk_-helpers.patch
  hwrng-omap-set-default-quality.patch
  thunderbolt-fix-to-check-return-value-of-ida_simple_.patch
  thunderbolt-fix-to-check-for-kmemdup-failure.patch
  drm-amd-display-fix-releasing-planes-when-exiting-od.patch
  thunderbolt-property-fix-a-null-pointer-dereference.patch
  e1000e-disable-runtime-pm-on-cnp.patch
  tinydrm-mipi-dbi-use-dma-safe-buffers-for-all-spi-tr.patch
  igb-exclude-device-from-suspend-direct-complete-opti.patch
  media-si2165-fix-a-missing-check-of-return-value.patch
  media-dvbsky-avoid-leaking-dvb-frontend.patch
  media-m88ds3103-serialize-reset-messages-in-m88ds310.patch
  media-staging-davinci_vpfe-disallow-building-with-co.patch
  drm-amd-display-fix-divide-by-0-in-memory-calculatio.patch
  drm-amd-display-set-stream-mode_changed-when-connect.patch
  scsi-ufs-fix-a-missing-check-of-devm_reset_control_g.patch
  media-vimc-stream-fix-thread-state-before-sleep.patch
  media-gspca-do-not-resubmit-urbs-when-streaming-has-.patch
  media-go7007-avoid-clang-frame-overflow-warning-with.patch
  media-vimc-zero-the-media_device-on-probe.patch
  scsi-lpfc-fix-fdmi-manufacturer-attribute-value.patch
  scsi-lpfc-fix-fc4type-information-for-fdmi.patch
  media-saa7146-avoid-high-stack-usage-with-clang.patch
  scsi-lpfc-fix-sli3-commands-being-issued-on-sli4-dev.patch
  spi-spi-topcliff-pch-fix-to-handle-empty-dma-buffers.patch
  drm-omap-dsi-fix-pm-for-display-blank-with-paired-ds.patch
  spi-rspi-fix-sequencer-reset-during-initialization.patch
  spi-imx-stop-buffer-overflow-in-rx-fifo-flush.patch
  spi-fix-zero-length-xfer-bug.patch
  asoc-davinci-mcasp-fix-clang-warning-without-config_.patch
  drm-v3d-handle-errors-from-irq-setup.patch
  drm-drv-hold-ref-on-parent-device-during-drm_device-.patch
  drm-wake-up-next-in-drm_read-chain-if-we-are-forced-.patch
  drm-sun4i-dsi-change-the-start-delay-calculation.patch
  vfio-ccw-prevent-quiesce-function-going-into-an-infi.patch
  drm-sun4i-dsi-enforce-boundaries-on-the-start-delay.patch
  nfs-fix-a-double-unlock-from-nfs_match-get_client.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-6bf1132746868f110c6d7104df5cc635f11c25aa.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-6bf1132746868f110c6d7104df5cc635f11c25aa.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-6bf1132746868f110c6d7104df5cc635f11c25aa.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-6bf1132746868f110c6d7104df5cc635f11c25aa.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-6bf1132746868f110c6d7104df5cc635f11c25aa.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-6bf1132746868f110c6d7104df5cc635f11c25aa.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-6bf1132746868f110c6d7104df5cc635f11c25aa.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-6bf1132746868f110c6d7104df5cc635f11c25aa.tar.gz


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
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Storage blktests [13]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [14]
       ✅ xfstests: xfs [14]
       ✅ selinux-policy: serge-testsuite [15]


  ppc64le:
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
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Storage blktests [13]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [14]
       ✅ xfstests: xfs [14]
       ✅ selinux-policy: serge-testsuite [15]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [15]

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
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Storage blktests [13]


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
       ✅ stress: stress-ng [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ Storage blktests [13]

    Host 2:
       ✅ Boot test [0]
       ✅ xfstests: ext4 [14]
       ✅ xfstests: xfs [14]
       ✅ selinux-policy: serge-testsuite [15]


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
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
