Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E66F9FCD
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKMBEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:04:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727256AbfKMBEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 20:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573607044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sSc7pFIrKlNa9udpOIOxMRxWLR2Ad3/Eu3KhFAI5pUQ=;
        b=AS0KG43kvvZRTN6UgWwlkq+AKshPG0KdQjtoCuQ8kctGJIcVOMUSytagYDvRtF8Gn7gTiV
        1jzD5Cxh0qyX1x0AkiZeEq6P9G+rCQSCFgfJWWMiqxv2Mo5I08rSboCRBn6z68taEzdGBC
        JNaxxf7LE3dPaDn4Ysz09ERXWZCzdWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-hVvQAKZkO7GoPkEmv8kmkQ-1; Tue, 12 Nov 2019 20:04:02 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0FE1005502
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 01:04:01 +0000 (UTC)
Received: from [172.54.37.191] (cpt-1013.paas.prod.upshift.rdu2.redhat.com [10.0.19.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B84C377A;
        Wed, 13 Nov 2019 01:03:58 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Date:   Wed, 13 Nov 2019 01:03:58 -0000
Message-ID: <cki.2683A9640C.WPGD79N6QR@redhat.com>
X-Gitlab-Pipeline-ID: 281399
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/281399
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: hVvQAKZkO7GoPkEmv8kmkQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into thi=
s
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git
            Commit: 81584694bb70 - Linux 5.3.10

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/281399

Please reply to this email if you have any questions about the tests that w=
e
ran or if you have any suggestions on how to make future tests more effecti=
ve.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
___________________________________________________________________________=
___

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 81584694bb70 - Linux 5.3.10


We grabbed the 47a3e6698192 commit of the stable queue repository.

We then merged the patchset with `git am`:

  bonding-fix-state-transition-issue-in-link-monitoring.patch
  cdc-ncm-handle-incomplete-transfer-of-mtu.patch
  ipv4-fix-table-id-reference-in-fib_sync_down_addr.patch
  net-ethernet-octeon_mgmt-account-for-second-possible-vlan-header.patch
  net-fix-data-race-in-neigh_event_send.patch
  net-qualcomm-rmnet-fix-potential-uaf-when-unregistering.patch
  net-tls-fix-sk_msg-trim-on-fallback-to-copy-mode.patch
  net-usb-qmi_wwan-add-support-for-dw5821e-with-esim-support.patch
  nfc-fdp-fix-incorrect-free-object.patch
  nfc-netlink-fix-double-device-reference-drop.patch
  nfc-st21nfca-fix-double-free.patch
  qede-fix-null-pointer-deref-in-__qede_remove.patch
  net-mscc-ocelot-don-t-handle-netdev-events-for-other-netdevs.patch
  net-mscc-ocelot-fix-null-pointer-on-lag-slave-removal.patch
  net-tls-don-t-pay-attention-to-sk_write_pending-when-pushing-partial-reco=
rds.patch
  net-tls-add-a-tx-lock.patch
  selftests-tls-add-test-for-concurrent-recv-and-send.patch
  ipv6-fixes-rt6_probe-and-fib6_nh-last_probe-init.patch
  net-hns-fix-the-stray-netpoll-locks-causing-deadlock-in-napi-path.patch
  net-prevent-load-store-tearing-on-sk-sk_stamp.patch
  net-sched-prevent-duplicate-flower-rules-from-tcf_proto-destroy-race.patc=
h
  net-smc-fix-ethernet-interface-refcounting.patch
  vsock-virtio-fix-sock-refcnt-holding-during-the-shutdown.patch
  r8169-fix-page-read-in-r8168g_mdio_read.patch
  alsa-timer-fix-incorrectly-assigned-timer-instance.patch
  alsa-bebob-fix-to-detect-configured-source-of-sampling-clock-for-focusrit=
e-saffire-pro-i-o-series.patch
  alsa-hda-ca0132-fix-possible-workqueue-stall.patch
  mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch
  mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.patch
  mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.pa=
tch
  mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch
  mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch
  dump_stack-avoid-the-livelock-of-the-dump_lock.patch
  mm-slab-make-page_cgroup_ino-to-recognize-non-compound-slab-pages-properl=
y.patch
  btrfs-consider-system-chunk-array-size-for-new-system-chunks.patch
  btrfs-tree-checker-fix-wrong-check-on-max-devid.patch
  btrfs-save-i_size-to-avoid-double-evaluation-of-i_size_read-in-compress_f=
ile_range.patch
  tools-gpio-use-building_out_of_srctree-to-determine-srctree.patch
  pinctrl-intel-avoid-potential-glitches-if-pin-is-in-gpio-mode.patch
  perf-tools-fix-time-sorting.patch
  perf-map-use-zalloc-for-map_groups.patch
  drm-radeon-fix-si_enable_smc_cac-failed-issue.patch
  hid-wacom-generic-treat-serial-number-and-related-fields-as-unsigned.patc=
h
  mm-khugepaged-fix-might_sleep-warn-with-config_highpte-y.patch
  soundwire-depend-on-acpi.patch
  soundwire-depend-on-acpi-of.patch
  soundwire-bus-set-initial-value-to-port_status.patch
  blkcg-make-blkcg_print_stat-print-stats-only-for-online-blkgs.patch
  arm64-do-not-mask-out-pte_rdonly-in-pte_same.patch
  asoc-rsnd-dma-fix-ssi9-4-5-6-7-busif-dma-address.patch
  ceph-fix-use-after-free-in-__ceph_remove_cap.patch
  ceph-fix-rcu-case-handling-in-ceph_d_revalidate.patch
  ceph-add-missing-check-in-d_revalidate-snapdir-handling.patch
  ceph-don-t-try-to-handle-hashed-dentries-in-non-o_creat-atomic_open.patch
  ceph-don-t-allow-copy_file_range-when-stripe_count-1.patch
  iio-adc-stm32-adc-fix-stopping-dma.patch
  iio-imu-adis16480-make-sure-provided-frequency-is-positive.patch
  iio-imu-inv_mpu6050-fix-no-data-on-mpu6050.patch
  iio-srf04-fix-wrong-limitation-in-distance-measuring.patch
  arm-sunxi-fix-cpu-powerdown-on-a83t.patch
  arm-dts-imx6-logicpd-re-enable-snvs-power-key.patch
  cpufreq-intel_pstate-fix-invalid-epb-setting.patch
  clone3-validate-stack-arguments.patch
  netfilter-nf_tables-align-nft_expr-private-data-to-64-bit.patch
  netfilter-ipset-fix-an-error-code-in-ip_set_sockfn_get.patch
  intel_th-gth-fix-the-window-switching-sequence.patch
  intel_th-pci-add-comet-lake-pch-support.patch
  intel_th-pci-add-jasper-lake-pch-support.patch
  x86-dumpstack-64-don-t-evaluate-exception-stacks-before-setup.patch
  x86-apic-32-avoid-bogus-ldr-warnings.patch
  smb3-fix-persistent-handles-reconnect.patch
  can-usb_8dev-fix-use-after-free-on-disconnect.patch
  can-flexcan-disable-completely-the-ecc-mechanism.patch
  can-c_can-c_can_poll-only-read-status-register-after-status-irq.patch
  can-peak_usb-fix-a-potential-out-of-sync-while-decoding-packets.patch
  can-rx-offload-can_rx_offload_queue_sorted-fix-error-handling-avoid-skb-m=
em-leak.patch
  can-gs_usb-gs_can_open-prevent-memory-leak.patch
  can-dev-add-missing-of_node_put-after-calling-of_get_child_by_name.patch
  can-mcba_usb-fix-use-after-free-on-disconnect.patch
  can-peak_usb-fix-slab-info-leak.patch
  configfs-fix-a-deadlock-in-configfs_symlink.patch
  alsa-usb-audio-more-validations-of-descriptor-units.patch
  alsa-usb-audio-simplify-parse_audio_unit.patch
  alsa-usb-audio-unify-the-release-of-usb_mixer_elem_info-objects.patch
  alsa-usb-audio-remove-superfluous-blength-checks.patch
  alsa-usb-audio-clean-up-check_input_term.patch
  alsa-usb-audio-fix-possible-null-dereference-at-create_yamaha_midi_quirk.=
patch
  alsa-usb-audio-remove-some-dead-code.patch
  alsa-usb-audio-fix-copy-paste-error-in-the-validator.patch
  usbip-implement-sg-support-to-vhci-hcd-and-stub-driver.patch
  hid-google-add-magnemite-masterball-usb-ids.patch
  dmaengine-sprd-fix-the-link-list-pointer-register-co.patch
  bpf-lwtunnel-fix-reroute-supplying-invalid-dst.patch
  dmaengine-xilinx_dma-fix-64-bit-simple-axidma-transf.patch
  dmaengine-xilinx_dma-fix-control-reg-update-in-vdma_.patch
  dmaengine-sprd-fix-the-possible-memory-leak-issue.patch
  hid-intel-ish-hid-fix-wrong-error-handling-in-ishtp_.patch
  powerpc-32s-fix-allow-prevent_user_access-when-cross.patch
  rdma-mlx5-clear-old-rate-limit-when-closing-qp.patch
  iw_cxgb4-fix-ecn-check-on-the-passive-accept.patch
  rdma-siw-free-siw_base_qp-in-kref-release-routine.patch
  rdma-qedr-fix-reported-firmware-version.patch
  ib-core-use-rdma_read_gid_l2_fields-to-compare-gid-l.patch
  net-mlx5e-tx-fix-assumption-of-single-wqebb-of-nop-i.patch
  net-mlx5e-ktls-release-reference-on-dumped-fragments.patch
  net-mlx5e-tx-fix-consumer-index-of-error-cqe-dump.patch
  net-mlx5-prevent-memory-leak-in-mlx5_fpga_conn_creat.patch
  net-mlx5-fix-memory-leak-in-mlx5_fw_fatal_reporter_d.patch
  selftests-bpf-more-compatible-nc-options-in-test_tc_.patch
  scsi-qla2xxx-fixup-incorrect-usage-of-host_byte.patch
  scsi-lpfc-check-queue-pointer-before-use.patch
  scsi-ufs-bsg-wake-the-device-before-sending-raw-upiu.patch
  arc-plat-hsdk-enable-on-board-spi-nor-flash-ic.patch
  rdma-uverbs-prevent-potential-underflow.patch
  bpf-fix-use-after-free-in-subprog-s-jited-symbol-rem.patch
  net-stmmac-fix-the-problem-of-tso_xmit.patch
  net-openvswitch-free-vport-unless-register_netdevice.patch
  scsi-lpfc-honor-module-parameter-lpfc_use_adisc.patch
  scsi-qla2xxx-initialized-mailbox-to-prevent-driver-l.patch
  bpf-fix-use-after-free-in-bpf_get_prog_name.patch
  iwlwifi-pcie-fix-pci-id-0x2720-configs-that-should-b.patch
  iwlwifi-pcie-fix-all-9460-entries-for-qnj.patch
  iwlwifi-pcie-0x2720-is-qu-and-0x30dc-is-not.patch
  netfilter-nf_flow_table-set-timeout-before-insertion.patch
  drm-v3d-fix-memory-leak-in-v3d_submit_cl_ioctl.patch
  xsk-fix-registration-of-rx-only-sockets.patch
  net-phy-smsc-lan8740-add-phy_rst_after_clk_en-flag.patch
  ipvs-don-t-ignore-errors-in-case-refcounting-ip_vs-m.patch
  ipvs-move-old_secure_tcp-into-struct-netns_ipvs.patch
  netfilter-nft_payload-fix-missing-check-for-matching.patch
  rdma-nldev-skip-counter-if-port-doesn-t-match.patch
  bonding-fix-unexpected-iff_bonding-bit-unset.patch
  bonding-use-dynamic-lockdep-key-instead-of-subclass.patch
  macsec-fix-refcnt-leak-in-module-exit-routine.patch
  virt_wifi-fix-refcnt-leak-in-module-exit-routine.patch
  scsi-sd-define-variable-dif-as-unsigned-int-instead-.patch
  usb-dwc3-select-config_regmap_mmio.patch
  usb-fsl-check-memory-resource-before-releasing-it.patch
  usb-gadget-udc-atmel-fix-interrupt-storm-in-fifo-mod.patch
  usb-gadget-composite-fix-possible-double-free-memory.patch
  usb-dwc3-pci-prevent-memory-leak-in-dwc3_pci_probe.patch
  usb-gadget-configfs-fix-concurrent-issue-between-com.patch
  usb-dwc3-remove-the-call-trace-of-usbx_gfladj.patch
  perf-x86-amd-ibs-fix-reading-of-the-ibs-opdata-regis.patch
  perf-x86-amd-ibs-handle-erratum-420-only-on-the-affe.patch
  perf-x86-uncore-fix-event-group-support.patch
  usb-skip-endpoints-with-0-maxpacket-length.patch
  usb-ldusb-use-unsigned-size-format-specifiers.patch
  usbip-tools-fix-read_usb_vudc_device-error-path-hand.patch
  rdma-iw_cxgb4-avoid-freeing-skb-twice-in-arp-failure.patch
  rdma-hns-prevent-memory-leaks-of-eq-buf_list.patch
  hwmon-ina3221-fix-read-timeout-issue.patch
  scsi-qla2xxx-stop-timer-in-shutdown-path.patch
  sched-topology-don-t-try-to-build-empty-sched-domain.patch
  sched-topology-allow-sched_asym_cpucapacity-to-be-di.patch
  nvme-multipath-fix-possible-io-hang-after-ctrl-recon.patch
  fjes-handle-workqueue-allocation-failure.patch
  net-hisilicon-fix-trying-to-free-already-free-irq.patch
  wimax-i2400-fix-memory-leak-in-i2400m_op_rfkill_sw_t.patch
  net-mscc-ocelot-fix-vlan_filtering-when-enslaving-to.patch
  net-mscc-ocelot-refuse-to-overwrite-the-port-s-nativ.patch
  iommu-amd-apply-the-same-ivrs-ioapic-workaround-to-a.patch
  mt76-dma-fix-buffer-unmap-with-non-linear-skbs.patch
  drm-amdgpu-sdma5-do-not-execute-0-sized-ibs-v2.patch
  drm-sched-set-error-to-s_fence-if-hw-job-submission-.patch
  drm-amdgpu-if-amdgpu_ib_schedule-fails-return-back-t.patch
  drm-amd-display-do-not-synchronize-drr-displays.patch
  drm-amd-display-add-50us-buffer-as-wa-for-pstate-swi.patch
  drm-amd-display-passive-dp-hdmi-dongle-detection-fix.patch
  dc.c-use-kzalloc-without-test.patch
  sunrpc-the-tcp-back-channel-mustn-t-disappear-while-.patch
  sunrpc-the-rdma-back-channel-mustn-t-disappear-while.patch
  sunrpc-destroy-the-back-channel-when-we-destroy-the-.patch
  hv_netvsc-fix-error-handling-in-netvsc_attach.patch
  efi-tpm-return-einval-when-determining-tpm-final-eve.patch
  efi-libstub-arm-account-for-firmware-reserved-memory.patch
  x86-efi-never-relocate-kernel-below-lowest-acceptabl.patch
  arm64-cpufeature-enable-qualcomm-falkor-errata-1009-.patch
  usb-dwc3-gadget-fix-race-when-disabling-ep-with-canc.patch
  arm64-apply-arm64_erratum_845719-workaround-for-brah.patch
  arm64-brahma-b53-is-ssb-and-spectre-v2-safe.patch
  arm64-apply-arm64_erratum_843419-workaround-for-brah.patch
  nfsv4-don-t-allow-a-cached-open-with-a-revoked-deleg.patch
  net-ethernet-arc-add-the-missed-clk_disable_unprepar.patch
  igb-fix-constant-media-auto-sense-switching-when-no-.patch
  e1000-fix-memory-leaks.patch
  gve-fixes-dma-synchronization.patch
  ocfs2-protect-extent-tree-in-ocfs2_prepare_inode_for.patch
  pinctrl-cherryview-fix-irq_valid_mask-calculation.patch
  clk-imx8m-use-sys_pll1_800m-as-intermediate-parent-o.patch
  timekeeping-vsyscall-update-vdso-data-unconditionall.patch
  mm-filemap.c-don-t-initiate-writeback-if-mapping-has-no-dirty-pages.patch
  cgroup-writeback-don-t-switch-wbs-immediately-on-dead-wbs-if-the-memcg-is=
-dead.patch
  arm-dts-stm32-change-joystick-pinctrl-definition-on-.patch
  asoc-sof-intel-hda-stream-fix-the-config_-prefix-mis.patch
  usbip-fix-free-of-unallocated-memory-in-vhci-tx.patch
  bonding-fix-using-uninitialized-mode_lock.patch
  netfilter-ipset-copy-the-right-mac-address-in-hash-i.patch
  arm64-errata-update-stale-comment.patch
  net-ibmvnic-unlock-rtnl_lock-in-reset-so-linkwatch_e.patch
  drm-i915-rename-gen7-cmdparser-tables.patch
  drm-i915-disable-secure-batches-for-gen6.patch
  drm-i915-remove-master-tables-from-cmdparser.patch
  drm-i915-add-support-for-mandatory-cmdparsing.patch
  drm-i915-support-ro-ppgtt-mapped-cmdparser-shadow-buffers.patch
  drm-i915-allow-parsing-of-unsized-batches.patch
  drm-i915-add-gen9-bcs-cmdparsing.patch
  drm-i915-cmdparser-use-explicit-goto-for-error-paths.patch
  drm-i915-cmdparser-add-support-for-backward-jumps.patch
  drm-i915-cmdparser-ignore-length-operands-during-command-matching.patch
  drm-i915-lower-rm-timeout-to-avoid-dsi-hard-hangs.patch
  drm-i915-gen8-add-rc6-ctx-corruption-wa.patch
  drm-i915-cmdparser-fix-jump-whitelist-clearing.patch
  x86-msr-add-the-ia32_tsx_ctrl-msr.patch
  x86-cpu-add-a-helper-function-x86_read_arch_cap_msr.patch
  x86-cpu-add-a-tsx-cmdline-option-with-tsx-disabled-by-default.patch
  x86-speculation-taa-add-mitigation-for-tsx-async-abort.patch
  x86-speculation-taa-add-sysfs-reporting-for-tsx-async-abort.patch
  kvm-x86-export-mds_no-0-to-guests-when-tsx-is-enabled.patch
  x86-tsx-add-auto-option-to-the-tsx-cmdline-parameter.patch
  x86-speculation-taa-add-documentation-for-tsx-async-abort.patch
  x86-tsx-add-config-options-to-set-tsx-on-off-auto.patch
  x86-speculation-taa-fix-printing-of-taa_msg_smt-on-ibrs_all-cpus.patch
  x86-bugs-add-itlb_multihit-bug-infrastructure.patch
  x86-cpu-add-tremont-to-the-cpu-vulnerability-whitelist.patch
  cpu-speculation-uninline-and-export-cpu-mitigations-helpers.patch
  documentation-add-itlb_multihit-documentation.patch
  kvm-x86-powerpc-do-not-allow-clearing-largepages-debugfs-entry.patch
  kvm-mmu-itlb_multihit-mitigation.patch
  kvm-add-helper-function-for-creating-vm-worker-threads.patch
  kvm-x86-mmu-recovery-of-shattered-nx-large-pages.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 Memory function: kaslr
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking MACsec: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 Memory function: kaslr
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking MACsec: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: xfs
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 Memory function: kaslr
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking MACsec: sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 3:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/sanity

    Host 4:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/sanity

    Host 5:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 /kernel/infiniband/sanity

    Host 6:

       =E2=9A=A1 Internal infrastructure issues prevented one or more tests=
 (marked
       with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
       This is not the fault of the kernel that was tested.

       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 /kernel/infiniband/env_setup
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 /kernel/infiniband/sanity

  Test sources: https://github.com/CKI-project/tests-beaker
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to=
 existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. S=
uch tests are
executed but their results are not taken into account. Tests are waived whe=
n
their results are not reliable enough, e.g. when they're just introduced or=
 are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with =E2=8F=B1. Reports for non-upstream kernel=
s have
a Beaker recipe linked to next to each host.

