Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32BCCC9C12
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 12:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfJCKU2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 3 Oct 2019 06:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfJCKU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 06:20:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19FC38A1C85
        for <stable@vger.kernel.org>; Thu,  3 Oct 2019 10:20:27 +0000 (UTC)
Received: from [172.54.122.170] (cpt-1052.paas.prod.upshift.rdu2.redhat.com [10.0.19.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1F456092F;
        Thu,  3 Oct 2019 10:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.22477FF33F.DXYRTR5KZL@redhat.com>
X-Gitlab-Pipeline-ID: 201555
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/201555
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 03 Oct 2019 10:20:27 +0000 (UTC)
Date:   Thu, 3 Oct 2019 06:20:27 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 0e7d6367ac13 - Linux 5.3.2

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/201555

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
  Commit: 0e7d6367ac13 - Linux 5.3.2


We grabbed the b8df56437954 commit of the stable queue repository.

We then merged the patchset with `git am`:

  arcnet-provide-a-buffer-big-enough-to-actually-receive-packets.patch
  cdc_ncm-fix-divide-by-zero-caused-by-invalid-wmaxpacketsize.patch
  ipv6-do-not-free-rt-if-fib_lookup_noref-is-set-on-suppress-rule.patch
  macsec-drop-skb-sk-before-calling-gro_cells_receive.patch
  net-phy-fix-dp83865-10-mbps-hdx-loopback-disable-function.patch
  net-qrtr-stop-rx_worker-before-freeing-node.patch
  net-sched-act_sample-don-t-push-mac-header-on-ip6gre-ingress.patch
  net_sched-add-max-len-check-for-tca_kind.patch
  net-stmmac-fix-page-pool-size.patch
  nfp-flower-fix-memory-leak-in-nfp_flower_spawn_vnic_reprs.patch
  nfp-flower-prevent-memory-leak-in-nfp_flower_spawn_phy_reprs.patch
  openvswitch-change-type-of-upcall_pid-attribute-to-nla_unspec.patch
  ppp-fix-memory-leak-in-ppp_write.patch
  sch_netem-fix-a-divide-by-zero-in-tabledist.patch
  selftests-update-fib_tests-to-handle-missing-ping6.patch
  skge-fix-checksum-byte-order.patch
  tcp_bbr-fix-quantization-code-to-not-raise-cwnd-if-not-probing-bandwidth.patch
  usbnet-ignore-endpoints-with-invalid-wmaxpacketsize.patch
  usbnet-sanity-checking-of-packet-sizes-and-device-mtu.patch
  net-rds-check-laddr_check-before-calling-it.patch
  net-mlx5e-fix-matching-on-tunnel-addresses-type.patch
  ipv6-fix-a-typo-in-fib6_rule_lookup.patch
  selftests-update-fib_nexthop_multiprefix-to-handle-missing-ping6.patch
  net-phy-micrel-add-asym-pause-workaround-for-ksz9021.patch
  net-sched-cbs-fix-not-adding-cbs-instance-to-list.patch
  ipv4-revert-removal-of-rt_uses_gateway.patch
  net_sched-add-policy-validation-for-action-attributes.patch
  vrf-do-not-attempt-to-create-ipv6-mcast-rule-if-ipv6-is-disabled.patch
  net-mlx5e-fix-traffic-duplication-in-ethtool-steering.patch
  net-sched-fix-possible-crash-in-tcf_action_destroy.patch
  tcp-better-handle-tcp_user_timeout-in-syn_sent-state.patch
  net-mlx5-add-device-id-of-upcoming-bluefield-2.patch
  misdn-enforce-cap_net_raw-for-raw-sockets.patch
  appletalk-enforce-cap_net_raw-for-raw-sockets.patch
  ax25-enforce-cap_net_raw-for-raw-sockets.patch
  ieee802154-enforce-cap_net_raw-for-raw-sockets.patch
  nfc-enforce-cap_net_raw-for-raw-sockets.patch
  alsa-hda-flush-interrupts-on-disabling.patch
  asoc-sof-intel-hda-make-hdac_device-device-managed.patch
  cpufreq-ap806-add-null-check-after-kcalloc.patch
  alsa-hda-hdmi-don-t-report-spurious-jack-state-chang.patch
  regulator-lm363x-fix-off-by-one-n_voltages-for-lm363.patch
  regulator-lm363x-fix-n_voltages-setting-for-lm36274.patch
  spi-dw-mmio-clock-should-be-shut-when-error-occurs.patch
  asoc-tlv320aic31xx-suppress-error-message-for-eprobe.patch
  asoc-sgtl5000-fix-of-unmute-outputs-on-probe.patch
  asoc-sgtl5000-fix-charge-pump-source-assignment.patch
  firmware-qcom_scm-use-proper-types-for-dma-mappings.patch
  dmaengine-bcm2835-print-error-in-case-setting-dma-ma.patch
  leds-leds-lp5562-allow-firmware-files-up-to-the-maxi.patch
  asoc-sof-reset-dma-state-in-prepare.patch
  media-dib0700-fix-link-error-for-dibx000_i2c_set_spe.patch
  media-mtk-cir-lower-de-glitch-counter-for-rc-mm-prot.patch
  asoc-sof-pci-mark-last_busy-value-at-runtime-pm-init.patch
  media-exynos4-is-fix-leaked-of_node-references.patch
  media-vivid-add-sanity-check-to-avoid-divide-error-a.patch
  media-vb2-reorder-checks-in-vb2_poll.patch
  media-vivid-work-around-high-stack-usage-with-clang.patch
  media-hdpvr-add-device-num-check-and-handling.patch
  media-i2c-ov5640-check-for-devm_gpiod_get_optional-e.patch
  time-tick-broadcast-fix-tick_broadcast_offline-lockd.patch
  sched-fair-fix-imbalance-due-to-cpu-affinity.patch
  sched-core-fix-cpu-controller-for-rt_group_sched.patch
  x86-apic-make-apic_pending_intr_clear-more-robust.patch
  sched-deadline-fix-bandwidth-accounting-at-all-level.patch
  x86-reboot-always-use-nmi-fallback-when-shutdown-via.patch
  rcu-tree-call-setschedule-gp-ktread-to-sched_fifo-ou.patch
  x86-apic-soft-disable-apic-before-initializing-it.patch
  alsa-hda-show-the-fatal-corb-rirb-error-more-clearly.patch
  alsa-i2c-ak4xxx-adda-fix-a-possible-null-pointer-der.patch
  rcu-add-destroy_work_on_stack-to-match-init_work_ons.patch
  edac-mc-fix-grain_bits-calculation.patch
  arm64-dts-imx8mq-correct-opp-table-according-to-late.patch
  media-iguanair-add-sanity-checks.patch
  cpuidle-teo-allow-tick-to-be-stopped-if-pm-qos-is-us.patch
  gpio-madera-add-support-for-cirrus-logic-cs47l15.patch
  gpio-madera-add-support-for-cirrus-logic-cs47l92.patch
  arm64-mm-free-the-initrd-reserved-memblock-in-a-alig.patch
  soc-amlogic-meson-clk-measure-protect-measure-with-a.patch
  base-soc-export-soc_device_register-unregister-apis.patch
  alsa-usb-audio-skip-bsynchaddress-endpoint-check-if-.patch
  ia64-unwind-fix-double-free-for-mod-arch.init_unw_ta.patch
  edac-altera-use-the-proper-type-for-the-irq-status-b.patch
  asoc-rsnd-don-t-call-clk_get_rate-under-atomic-conte.patch
  arm64-prefetch-fix-a-wtype-limits-warning.patch
  md-raid1-end-bio-when-the-device-faulty.patch
  md-don-t-call-spare_active-in-md_reap_sync_thread-if.patch
  md-don-t-set-in_sync-if-array-is-frozen.patch
  media-media-platform-fsl-viu.c-fix-build-for-microbl.patch
  media-staging-tegra-vde-fix-build-error.patch
  ras-fix-prototype-warnings.patch
  ras-build-debugfs.o-only-when-enabled-in-kconfig.patch
  asoc-hdac_hda-fix-page-fault-issue-by-removing-race.patch
  acpi-processor-don-t-print-errors-for-processorids-0.patch
  loop-add-loop_set_direct_io-to-compat-ioctl.patch
  perf-tools-fix-paths-in-include-statements.patch
  edac-pnd2-fix-ioremap-size-in-dnv_rd_reg.patch
  efi-cper-print-aer-info-of-pcie-fatal-error.patch
  firmware-arm_scmi-check-if-platform-has-released-shm.patch
  sched-fair-use-rq_lock-unlock-in-online_fair_sched_g.patch
  idle-prevent-late-arriving-interrupts-from-disruptin.patch
  blk-mq-fix-memory-leak-in-blk_mq_init_allocated_queu.patch
  media-gspca-zero-usb_buf-on-error.patch
  perf-config-honour-perf_config-env-var-to-specify-al.patch
  perf-test-vfs_getname-disable-.perfconfig-to-get-def.patch
  media-mtk-mdp-fix-reference-count-on-old-device-tree.patch
  media-i2c-tda1997x-prevent-potential-null-pointer-ac.patch
  media-fdp1-reduce-fcp-not-found-message-level-to-deb.patch
  media-em28xx-modules-workqueue-not-inited-for-2nd-de.patch
  arm64-efi-move-variable-assignments-after-sections.patch
  perf-unwind-fix-libunwind-when-tid-pid.patch
  media-rc-imon-allow-imon-rc-protocol-for-ffdc-7e-dev.patch
  dmaengine-iop-adma-use-correct-printk-format-strings.patch
  arm-xscale-fix-multi-cpu-compilation.patch
  perf-ftrace-use-cap_sys_admin-instead-of-euid-0.patch
  perf-record-support-aarch64-random-socket_id-assignm.patch
  media-vsp1-fix-memory-leak-of-dl-on-error-return-pat.patch
  media-i2c-ov5645-fix-power-sequence.patch
  media-omap3isp-don-t-set-streaming-state-on-random-s.patch
  media-imx-mipi-csi-2-don-t-fail-if-initial-state-tim.patch
  kasan-arm64-fix-config_kasan_sw_tags-kasan_inline.patch
  net-lpc-enet-fix-printk-format-strings.patch
  m68k-prevent-some-compiler-warnings-in-coldfire-buil.patch
  arm-dts-imx7d-cl-som-imx7-make-ethernet-work-again.patch
  arm64-dts-qcom-qcs404-evb-mark-wcss-clocks-protected.patch
  arm-dts-imx7-colibri-disable-hs400.patch
  x86-platform-intel-iosf_mbi-rewrite-locking.patch
  media-radio-si470x-kill-urb-on-error.patch
  media-hdpvr-add-terminating-0-at-end-of-string.patch
  asoc-uniphier-fix-double-reset-assersion-when-transi.patch
  powerpc-makefile-always-pass-synthetic-to-nm-if-supp.patch
  tools-headers-fixup-bitsperlong-per-arch-includes.patch
  asoc-sun4i-i2s-don-t-use-the-oversample-to-calculate.patch
  asoc-mchp-i2s-mcc-wait-for-rx-tx-rdy-only-if-control.patch
  led-triggers-fix-a-memory-leak-bug.patch
  asoc-mchp-i2s-mcc-fix-unprepare-of-gclk.patch
  nbd-add-missing-config-put.patch
  acpi-apei-release-resources-if-gen_pool_add-fails.patch
  arm64-entry-move-ct_user_exit-before-any-other-excep.patch
  s390-kasan-provide-uninstrumented-__strlen.patch
  media-mceusb-fix-eliminate-tx-ir-signal-length-limit.patch
  media-dvb-frontends-use-ida-for-pll-number.patch
  posix-cpu-timers-sanitize-bogus-warnons.patch
  media-dvb-core-fix-a-memory-leak-bug.patch
  edac-amd64-support-more-than-two-controllers-for-chi.patch
  cpufreq-imx-cpufreq-dt-add-i.mx8mn-support.patch
  libperf-fix-alignment-trap-with-xyarray-contents-in-.patch
  edac-amd64-recognize-dram-device-type-ecc-capability.patch
  edac-amd64-decode-syndrome-before-translating-addres.patch
  arm-at91-move-platform-specific-asm-offset.h-to-arch.patch
  soc-renesas-rmobile-sysc-set-genpd_flag_always_on-fo.patch
  soc-renesas-enable-arm_errata_754322-for-affected-co.patch
  pm-devfreq-fix-kernel-oops-on-governor-module-load.patch
  arm-omap2-move-platform-specific-asm-offset.h-to-arc.patch
  pm-devfreq-passive-use-non-devm-notifiers.patch
  pm-devfreq-exynos-bus-correct-clock-enable-sequence.patch
  media-cec-notifier-clear-cec_adap-in-cec_notifier_un.patch
  media-saa7146-add-cleanup-in-hexium_attach.patch
  media-cpia2_usb-fix-memory-leaks.patch
  media-saa7134-fix-terminology-around-saa7134_i2c_eep.patch
  perf-trace-beauty-ioctl-fix-off-by-one-error-in-cmd-.patch
  perf-report-fix-ns-time-sort-key-output.patch
  perf-script-fix-memory-leaks-in-list_scripts.patch
  media-aspeed-video-address-a-protential-usage-of-an-.patch
  media-ov9650-add-a-sanity-check.patch
  leds-lm3532-fixes-for-the-driver-for-stability.patch
  asoc-es8316-fix-headphone-mixer-volume-table.patch
  acpi-cppc-do-not-require-the-_psd-method.patch
  sched-cpufreq-align-trace-event-behavior-of-fast-swi.patch
  arm64-dts-meson-fix-boards-regulators-states-format.patch
  x86-apic-vector-warn-when-vector-space-exhaustion-br.patch
  arm64-kpti-ensure-patched-kernel-text-is-fetched-fro.patch
  perf-evlist-use-unshare-clone_fs-in-sb-threads-to-le.patch
  arm64-use-correct-ll-sc-atomic-constraints.patch
  jump_label-don-t-warn-on-__exit-jump-entries.patch
  x86-mm-pti-do-not-invoke-pti-functions-when-pti-is-d.patch
  asoc-fsl_ssi-fix-clock-control-issue-in-master-mode.patch
  x86-mm-pti-handle-unaligned-address-gracefully-in-pt.patch
  nvmet-fix-data-units-read-and-written-counters-in-sm.patch
  nvme-multipath-fix-ana-log-nsid-lookup-when-nsid-is-.patch
  alsa-firewire-motu-add-support-for-motu-4pre.patch
  iommu-amd-silence-warnings-under-memory-pressure.patch
  asoc-intel-haswell-adjust-machine-device-private-con.patch
  libata-ahci-drop-pcs-quirk-for-denverton-and-beyond.patch
  iommu-iova-avoid-false-sharing-on-fq_timer_on.patch
  libtraceevent-change-users-plugin-directory.patch
  asoc-dt-bindings-sun4i-spdif-fix-dma-names-warning.patch
  arm-dts-exynos-mark-ldo10-as-always-on-on-peach-pit-.patch
  x86-amd_nb-add-pci-device-ids-for-family-17h-model-7.patch
  acpi-custom_method-fix-memory-leaks.patch
  acpi-pci-fix-acpi_pci_irq_enable-memory-leak.patch
  closures-fix-a-race-on-wakeup-from-closure_sync.patch
  hwmon-k10temp-add-support-for-amd-family-17h-model-7.patch
  hwmon-acpi_power_meter-change-log-level-for-unsafe-s.patch
  md-raid1-fail-run-raid1-array-when-active-disk-less-.patch
  dmaengine-ti-edma-do-not-reset-reserved-param-slots.patch
  kprobes-prohibit-probing-on-bug-and-warn-address.patch
  x86-mm-fix-cpumask_of_node-error-condition.patch
  irqchip-sifive-plic-set-max-threshold-for-ignored-ha.patch
  s390-crypto-xts-aes-s390-fix-extra-run-time-crypto-s.patch
  irqchip-gic-v3-its-fix-lpi-release-for-multi-msi-dev.patch
  x86-cpu-add-tiger-lake-to-intel-family.patch
  platform-x86-intel_pmc_core-do-not-ioremap-ram.patch
  platform-x86-intel_pmc_core_pltdrv-module-removal-wa.patch
  soc-simple-card-utils-set-0hz-to-sysclk-when-shutdow.patch
  asoc-dmaengine-make-the-pcm-name-equal-to-pcm-id-if-.patch
  tools-power-x86-intel-speed-select-fix-memory-leak.patch
  spi-bcm2835-work-around-done-bit-erratum.patch
  io_uring-fix-wrong-sequence-setting-logic.patch
  block-make-rq-sector-size-accessible-for-block-stats.patch
  raid5-don-t-set-stripe_handle-to-stripe-which-is-in-.patch
  mmc-core-clarify-sdio_irq_pending-flag-for-mmc_cap2_.patch
  sched-psi-correct-overly-pessimistic-size-calculatio.patch
  mmc-sdhci-fix-incorrect-switch-to-hs-mode.patch
  mmc-core-add-helper-function-to-indicate-if-sdio-irq.patch
  mmc-dw_mmc-re-store-sdio-irqs-mask-at-system-resume.patch
  raid5-don-t-increment-read_errors-on-eilseq-return.patch
  mmc-mtk-sd-re-store-sdio-irqs-mask-at-system-resume.patch
  libertas-add-missing-sentinel-at-end-of-if_usb.c-fw_.patch
  e1000e-add-workaround-for-possible-stalled-packet.patch
  alsa-hda-add-a-quirk-model-for-fixing-huawei-mateboo.patch
  alsa-hda-drop-unsol-event-handler-for-intel-hdmi-cod.patch
  drm-amd-powerplay-smu7-enforce-minimal-vbitimeout-v2.patch
  media-ttusb-dec-fix-info-leak-in-ttusb_dec_send_comm.patch
  drm-fix-module-name-in-edid_firmware-log-message.patch
  alsa-hda-realtek-blacklist-pc-beep-for-lenovo-thinkc.patch
  iommu-amd-override-wrong-ivrs-ioapic-on-raven-ridge-.patch
  zd1211rw-remove-false-assertion-from-zd_mac_clear.patch
  btrfs-delayed-inode-kill-the-bug_on-in-btrfs_delete_.patch
  btrfs-extent-tree-make-sure-we-only-allocate-extents.patch
  btrfs-tree-checker-add-root_item-check.patch
  btrfs-detect-unbalanced-tree-with-empty-leaf-before-.patch
  kvm-nested-kvm-mmus-need-pae-root-too.patch
  media-omap3isp-set-device-on-omap3isp-subdevs.patch
  pm-devfreq-passive-fix-compiler-warning.patch
  arm-dts-logicpd-torpedo-baseboard-fix-missing-video.patch
  arm-omap2plus_defconfig-fix-missing-video.patch
  iwlwifi-fw-don-t-send-geo_tx_power_limit-command-to-fw-version-36.patch
  alsa-firewire-tascam-handle-error-code-when-getting-current-source-of-clock.patch
  alsa-firewire-tascam-check-intermediate-state-of-clock-status-and-retry.patch
  scsi-scsi_dh_rdac-zero-cdb-in-send_mode_select.patch
  scsi-qla2xxx-fix-relogin-to-prevent-modifying-scan_state-flag.patch
  printk-do-not-lose-last-line-in-kmsg-buffer-dump.patch
  ib-mlx5-free-mpi-in-mp_slave-mode.patch
  ib-hfi1-define-variables-as-unsigned-long-to-fix-kasan-warning.patch
  ib-hfi1-do-not-update-hcrc-for-a-kdeth-packet-during-fault-injection.patch
  rdma-fix-double-free-in-srq-creation-error-flow.patch
  randstruct-check-member-structs-in-is_pure_ops_struct.patch
  arm-dts-am3517-evm-fix-missing-video.patch
  rcu-tree-fix-sched_fifo-params.patch
  alsa-hda-realtek-pci-quirk-for-medion-e4254.patch
  blk-mq-add-callback-of-.cleanup_rq.patch
  scsi-implement-.cleanup_rq-callback.patch

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

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ Networking TCP: keepalive test
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         🚧 ⚡⚡⚡ LTP lite
         🚧 ⚡⚡⚡ POSIX pjd-fstest suites
         🚧 ⚡⚡⚡ Memory function: kaslr
         🚧 ⚡⚡⚡ Networking MACsec: sanity
         🚧 ⚡⚡⚡ Networking route: pmtu
         🚧 ⚡⚡⚡ ALSA PCM loopback test
         🚧 ⚡⚡⚡ ALSA Control (mixer) Userspace Element test
         🚧 ⚡⚡⚡ storage: dm/common
         🚧 ⚡⚡⚡ Networking route_func: local
         🚧 ⚡⚡⚡ Networking route_func: forward
         🚧 ⚡⚡⚡ Networking ipsec: basic netns transport
         🚧 ⚡⚡⚡ Networking ipsec: basic netns tunnel

  ppc64le:
      Host 1:
         ✅ Boot test
         ✅ Podman system integration test (as root)
         ✅ Podman system integration test (as user)
         ✅ Loopdev Sanity
         ✅ jvm test suite
         ✅ AMTU (Abstract Machine Test Utility)
         ✅ Ethernet drivers sanity
         ✅ Networking socket: fuzz
         ✅ Networking TCP: keepalive test
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ Usex - version 1.9-29
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ Memory function: kaslr
         🚧 ✅ Networking MACsec: sanity
         🚧 ✅ Networking route: pmtu
         🚧 ✅ Networking ipsec: basic netns tunnel
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ storage: dm/common
         🚧 ✅ Networking route_func: local
         🚧 ✅ Networking route_func: forward

      Host 2:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ❌ Storage blktests

  x86_64:
      Host 1:
         ✅ Boot test
         ✅ xfstests: xfs
         ✅ selinux-policy: serge-testsuite
         ✅ lvm thinp sanity
         ✅ storage: software RAID testing
         🚧 ✅ IOMMU boot test
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
         ✅ Networking TCP: keepalive test
         ✅ audit: audit testsuite test
         ✅ httpd: mod_ssl smoke sanity
         ✅ iotop: sanity
         ✅ tuned: tune-processes-through-perf
         ✅ pciutils: sanity smoke test
         ✅ Usex - version 1.9-29
         ✅ storage: SCSI VPD
         ✅ stress: stress-ng
         🚧 ✅ LTP lite
         🚧 ✅ POSIX pjd-fstest suites
         🚧 ✅ Memory function: kaslr
         🚧 ✅ Networking MACsec: sanity
         🚧 ✅ Networking route: pmtu
         🚧 ✅ ALSA PCM loopback test
         🚧 ✅ ALSA Control (mixer) Userspace Element test
         🚧 ✅ storage: dm/common
         🚧 ✅ Networking route_func: local
         🚧 ✅ Networking route_func: forward
         🚧 ✅ Networking ipsec: basic netns transport
         🚧 ✅ Networking ipsec: basic netns tunnel

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
