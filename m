Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F5E6A3E
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 00:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfJ0XrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 19:47:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56066 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727957AbfJ0XrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 19:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572220030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SVhDfYi3Zc56U6vnrzYhZqImRyfR0bOvJOLCcOWBliA=;
        b=QIp6D56HAJevVUR469eNZwF81PsHiLdTDk8CivqyYYida+rVDNyDG1e8Nf2GDR41MtsvG0
        h00CjzPf2lj+6XLRcXY8aaW7ZKcr0tOKfLb/1bNBgrEp88+r/Wf+CkQ1qPC0Zdcb8V5yfU
        7qEBYd7Tpd6tM/WUQGnrRszxcnLys4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-uAD85mMXPdC43OzYaNZk0Q-1; Sun, 27 Oct 2019 19:47:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C20C81005500
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 23:47:07 +0000 (UTC)
Received: from [172.54.88.5] (cpt-1048.paas.prod.upshift.rdu2.redhat.com [10.0.19.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF3825D9E5;
        Sun, 27 Oct 2019 23:47:04 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Date:   Sun, 27 Oct 2019 23:47:04 -0000
CC:     Xiong Zhou <xzhou@redhat.com>, Jakub Krysl <jkrysl@redhat.com>
Message-ID: <cki.A68324370A.MIDC3VFKLY@redhat.com>
X-Gitlab-Pipeline-ID: 251522
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/251522
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: uAD85mMXPdC43OzYaNZk0Q-1
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
            Commit: 365dab61f74e - Linux 5.3.7

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/251522

One or more kernel tests failed:

    ppc64le:
     =E2=9D=8C xfstests: xfs

    aarch64:
     =E2=9D=8C xfstests: xfs
     =E2=9D=8C lvm thinp sanity

    x86_64:
     =E2=9D=8C xfstests: xfs

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this messa=
ge.

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
  Commit: 365dab61f74e - Linux 5.3.7


We grabbed the 3b22940455ac commit of the stable queue repository.

We then merged the patchset with `git am`:

  drm-free-the-writeback_job-when-it-with-an-empty-fb.patch
  drm-clear-the-fence-pointer-when-writeback-job-signa.patch
  clk-ti-dra7-fix-mcasp8-clock-bits.patch
  arm-dts-fix-wrong-clocks-for-dra7-mcasp.patch
  nvme-pci-fix-a-race-in-controller-removal.patch
  scsi-ufs-skip-shutdown-if-hba-is-not-powered.patch
  scsi-megaraid-disable-device-when-probe-failed-after.patch
  scsi-qla2xxx-silence-fwdump-template-message.patch
  scsi-qla2xxx-fix-unbound-sleep-in-fcport-delete-path.patch
  scsi-qla2xxx-fix-stale-mem-access-on-driver-unload.patch
  scsi-qla2xxx-fix-n2n-link-reset.patch
  scsi-qla2xxx-fix-n2n-link-up-fail.patch
  arm-dts-fix-gpio0-flags-for-am335x-icev2.patch
  arm-omap2-fix-missing-reset-done-flag-for-am3-and-am.patch
  arm-omap2-add-missing-lcdc-midlemode-for-am335x.patch
  arm-omap2-fix-warnings-with-broken-omap2_set_init_vo.patch
  nvme-tcp-fix-wrong-stop-condition-in-io_work.patch
  nvme-pci-save-pci-state-before-putting-drive-into-de.patch
  nvme-fix-an-error-code-in-nvme_init_subsystem.patch
  nvme-rdma-fix-max_hw_sectors-calculation.patch
  added-quirks-for-adata-xpg-sx8200-pro-512gb.patch
  nvme-add-quirk-for-kingston-nvme-ssd-running-fw-e8fk.patch
  nvme-allow-64-bit-results-in-passthru-commands.patch
  drm-komeda-prevent-memory-leak-in-komeda_wb_connecto.patch
  nvme-rdma-fix-possible-use-after-free-in-connect-tim.patch
  blk-mq-honor-io-scheduler-for-multiqueue-devices.patch
  ieee802154-ca8210-prevent-memory-leak.patch
  arm-dts-am4372-set-memory-bandwidth-limit-for-dispc.patch
  net-dsa-qca8k-use-up-to-7-ports-for-all-operations.patch
  mips-dts-ar9331-fix-interrupt-controller-size.patch
  xen-efi-set-nonblocking-callbacks.patch
  loop-change-queue-block-size-to-match-when-using-dio.patch
  nl80211-fix-null-pointer-dereference.patch
  mac80211-fix-txq-null-pointer-dereference.patch
  netfilter-nft_connlimit-disable-bh-on-garbage-collec.patch
  net-mscc-ocelot-add-missing-of_node_put-after-callin.patch
  net-dsa-rtl8366rb-add-missing-of_node_put-after-call.patch
  net-stmmac-xgmac-not-all-unicast-addresses-may-be-av.patch
  net-stmmac-dwmac4-always-update-the-mac-hash-filter.patch
  net-stmmac-correctly-take-timestamp-for-ptpv2.patch
  net-stmmac-do-not-stop-phy-if-wol-is-enabled.patch
  net-ag71xx-fix-mdio-subnode-support.patch
  risc-v-clear-load-reservations-while-restoring-hart-.patch
  riscv-fix-memblock-reservation-for-device-tree-blob.patch
  drm-amdgpu-fix-multiple-memory-leaks-in-acp_hw_init.patch
  drm-amd-display-memory-leak.patch
  mips-loongson-fix-the-link-time-qualifier-of-serial_.patch
  net-hisilicon-fix-usage-of-uninitialized-variable-in.patch
  net-stmmac-avoid-deadlock-on-suspend-resume.patch
  selftests-kvm-fix-libkvm-build-error.patch
  lib-textsearch-fix-escapes-in-example-code.patch
  s390-mm-fix-wunused-but-set-variable-warnings.patch
  r8152-set-macpassthru-in-reset_resume-callback.patch
  net-phy-allow-for-reset-line-to-be-tied-to-a-sleepy-.patch
  net-phy-fix-write-to-mii-ctrl1000-register.patch
  namespace-fix-namespace.pl-script-to-support-relativ.patch
  convert-filldir-64-from-__put_user-to-unsafe_put_use.patch
  elf-don-t-use-map_fixed_noreplace-for-elf-executable.patch
  make-filldir-64-verify-the-directory-entry-filename-.patch
  uaccess-implement-a-proper-unsafe_copy_to_user-and-s.patch
  filldir-64-remove-warn_on_once-for-bad-directory-ent.patch
  net_sched-fix-backward-compatibility-for-tca_kind.patch
  net_sched-fix-backward-compatibility-for-tca_act_kin.patch
  libata-ahci-fix-pcs-quirk-application.patch
  md-raid0-fix-warning-message-for-parameter-default_l.patch
  revert-drm-radeon-fix-eeh-during-kexec.patch
  ocfs2-fix-panic-due-to-ocfs2_wq-is-null.patch
  nvme-pci-set-the-prp2-correctly-when-using-more-than-4k-page.patch
  ipv4-fix-race-condition-between-route-lookup-and-invalidation.patch
  ipv4-return-enetunreach-if-we-can-t-create-route-but-saddr-is-valid.patch
  net-avoid-potential-infinite-loop-in-tc_ctl_action.patch
  net-bcmgenet-fix-rgmii_mode_en-value-for-genet-v1-2-3.patch
  net-bcmgenet-set-phydev-dev_flags-only-for-internal-phys.patch
  net-i82596-fix-dma_alloc_attr-for-sni_82596.patch
  net-ibmvnic-fix-eoi-when-running-in-xive-mode.patch
  net-ipv6-fix-listify-ip6_rcv_finish-in-case-of-forwarding.patch
  net-stmmac-disable-enable-ptp_ref_clk-in-suspend-resume-flow.patch
  rxrpc-fix-possible-null-pointer-access-in-icmp-handling.patch
  sched-etf-fix-ordering-of-packets-with-same-txtime.patch
  sctp-change-sctp_prot-.no_autobind-with-true.patch
  net-aquantia-temperature-retrieval-fix.patch
  net-aquantia-when-cleaning-hw-cache-it-should-be-toggled.patch
  net-aquantia-do-not-pass-lro-session-with-invalid-tcp-checksum.patch
  net-aquantia-correctly-handle-macvlan-and-multicast-coexistence.patch
  net-phy-micrel-discern-ksz8051-and-ksz8795-phys.patch
  net-phy-micrel-update-ksz87xx-phy-name.patch
  net-avoid-errors-when-trying-to-pop-mlps-header-on-non-mpls-packets.patch
  net-sched-fix-corrupted-l2-header-with-mpls-push-and-pop-actions.patch
  netdevsim-fix-error-handling-in-nsim_fib_init-and-nsim_fib_exit.patch
  net-ethernet-broadcom-have-drivers-select-dimlib-as-needed.patch
  net-phy-fix-link-partner-information-disappear-issue.patch
  lsm-safesetid-stop-releasing-uninitialized-ruleset.patch
  rxrpc-use-rcu-protection-while-reading-sk-sk_user_da.patch
  io_uring-fix-bad-inflight-accounting-for-setup_iopoll-setup_sqthread.patc=
h
  io_uring-fix-corrupted-user_data.patch
  usb-legousbtower-fix-memleak-on-disconnect.patch
  alsa-hda-realtek-add-support-for-alc711.patch
  alsa-hda-realtek-enable-headset-mic-on-asus-mj401ta.patch
  alsa-usb-audio-disable-quirks-for-boss-katana-amplifiers.patch
  alsa-hda-force-runtime-pm-on-nvidia-hdmi-codecs.patch
  usb-udc-lpc32xx-fix-bad-bit-shift-operation.patch
  usb-serial-ti_usb_3410_5052-fix-port-close-races.patch
  usb-ldusb-fix-memleak-on-disconnect.patch
  usb-usblp-fix-use-after-free-on-disconnect.patch
  usb-ldusb-fix-read-info-leaks.patch
  binder-don-t-modify-vma-bounds-in-mmap-handler.patch
  mips-tlbex-fix-build_restore_pagemask-kscratch-restore.patch
  staging-wlan-ng-fix-exit-return-when-sme-key_idx-num_wepkeys.patch
  scsi-zfcp-fix-reaction-on-bit-error-threshold-notification.patch
  scsi-sd-ignore-a-failure-to-sync-cache-due-to-lack-of-authorization.patch
  scsi-core-save-restore-command-resid-for-error-handling.patch
  scsi-core-try-to-get-module-before-removing-device.patch
  scsi-ch-make-it-possible-to-open-a-ch-device-multiple-times-again.patch
  revert-input-elantech-enable-smbus-on-new-2018-systems.patch
  input-da9063-fix-capability-and-drop-key_sleep.patch
  input-synaptics-rmi4-avoid-processing-unknown-irqs.patch
  input-st1232-fix-reporting-multitouch-coordinates.patch
  asoc-rsnd-reinitialize-bit-clock-inversion-flag-for-every-format-setting.=
patch
  acpi-cppc-set-pcc_data-to-null-in-acpi_cppc_processor_exit.patch
  acpi-nfit-fix-unlock-on-error-in-scrub_show.patch
  iwlwifi-pcie-change-qu-with-jf-devices-to-use-qu-configuration.patch
  cfg80211-wext-avoid-copying-malformed-ssids.patch
  mac80211-reject-malformed-ssid-elements.patch
  drm-edid-add-6-bpc-quirk-for-sdc-panel-in-lenovo-g50.patch
  drm-ttm-restore-ttm-prefaulting.patch
  drm-panfrost-handle-resetting-on-timeout-better.patch
  drm-amdgpu-bail-earlier-when-amdgpu.cik_-si_support-is-not-set-to-1.patch
  drm-amdgpu-sdma5-fix-mask-value-of-poll_regmem-packet-for-pipe-sync.patch
  drm-i915-userptr-never-allow-userptr-into-the-mappable-ggtt.patch
  drm-i915-favor-last-vbt-child-device-with-conflicting-aux-ch-ddc-pin.patc=
h
  drm-amdgpu-vce-fix-allocation-size-in-enc-ring-test.patch
  drm-amdgpu-vcn-fix-allocation-size-in-enc-ring-test.patch
  drm-amdgpu-uvd6-fix-allocation-size-in-enc-ring-test-v2.patch
  drm-amdgpu-uvd7-fix-allocation-size-in-enc-ring-test-v2.patch
  drm-amdgpu-user-pages-array-memory-leak-fix.patch
  drivers-base-memory.c-don-t-access-uninitialized-memmaps-in-soft_offline_=
page_store.patch
  fs-proc-page.c-don-t-access-uninitialized-memmaps-in-fs-proc-page.c.patch
  io_uring-fix-broken-links-with-offloading.patch
  io_uring-fix-race-for-sqes-with-userspace.patch
  io_uring-used-cached-copies-of-sq-dropped-and-cq-ove.patch
  mmc-mxs-fix-flags-passed-to-dmaengine_prep_slave_sg.patch
  mmc-cqhci-commit-descriptors-before-setting-the-doorbell.patch
  mmc-sdhci-omap-fix-tuning-procedure-for-temperatures-20c.patch
  mm-memory-failure.c-don-t-access-uninitialized-memmaps-in-memory_failure.=
patch
  mm-slub-fix-a-deadlock-in-show_slab_objects.patch
  mm-page_owner-don-t-access-uninitialized-memmaps-when-reading-proc-pagety=
peinfo.patch
  mm-memory_hotplug-don-t-access-uninitialized-memmaps-in-shrink_pgdat_span=
.patch
  mm-memunmap-don-t-access-uninitialized-memmap-in-memunmap_pages.patch
  mm-memcg-slab-fix-panic-in-__free_slab-caused-by-premature-memcg-pointer-=
release.patch
  mm-compaction-fix-wrong-pfn-handling-in-__reset_isolation_pfn.patch
  mm-memcg-get-number-of-pages-on-the-lru-list-in-memcgroup-base-on-lru_zon=
e_size.patch
  mm-memblock-do-not-enforce-current-limit-for-memblock_phys-family.patch
  hugetlbfs-don-t-access-uninitialized-memmaps-in-pfn_range_valid_gigantic.=
patch
  mm-memory-failure-poison-read-receives-sigkill-instead-of-sigbus-if-mmape=
d-more-than-once.patch
  zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch
  xtensa-drop-export_symbol-for-outs-ins.patch
  xtensa-fix-change_bit-in-exclusive-access-option.patch
  s390-zcrypt-fix-memleak-at-release.patch
  s390-kaslr-add-support-for-r_390_glob_dat-relocation-type.patch
  lib-vdso-make-clock_getres-posix-compliant-again.patch
  parisc-fix-vmap-memory-leak-in-ioremap-iounmap.patch
  edac-ghes-fix-use-after-free-in-ghes_edac-remove-path.patch
  arm64-kvm-trap-vm-ops-when-arm64_workaround_cavium_tx2_219_tvm-is-set.pat=
ch
  arm64-avoid-cavium-tx2-erratum-219-when-switching-ttbr.patch
  arm64-enable-workaround-for-cavium-tx2-erratum-219-when-running-smt.patch
  arm64-allow-cavium_tx2_erratum_219-to-be-selected.patch
  cifs-avoid-using-mid-0xffff.patch
  cifs-fix-missed-free-operations.patch
  cifs-fix-use-after-free-of-file-info-structures.patch
  perf-aux-fix-aux-output-stopping.patch
  tracing-fix-race-in-perf_trace_buf-initialization.patch
  fs-dax-fix-pmd-vs-pte-conflict-detection.patch
  dm-cache-fix-bugs-when-a-gfp_nowait-allocation-fails.patch
  irqchip-sifive-plic-switch-to-fasteoi-flow.patch
  x86-boot-64-make-level2_kernel_pgt-pages-invalid-outside-kernel-area.patc=
h
  x86-apic-x2apic-fix-a-null-pointer-deref-when-handling-a-dying-cpu.patch
  x86-hyperv-make-vapic-support-x2apic-mode.patch
  pinctrl-cherryview-restore-strago-dmi-workaround-for-all-versions.patch
  pinctrl-armada-37xx-fix-control-of-pins-32-and-up.patch
  pinctrl-armada-37xx-swap-polarity-on-led-group.patch
  btrfs-block-group-fix-a-memory-leak-due-to-missing-btrfs_put_block_group.=
patch
  btrfs-add-missing-extents-release-on-file-extent-cluster-relocation-error=
.patch
  btrfs-don-t-needlessly-create-extent-refs-kernel-thread.patch
  btrfs-fix-qgroup-double-free-after-failure-to-reserve-metadata-for-delall=
oc.patch
  btrfs-check-for-the-full-sync-flag-while-holding-the-inode-lock-during-fs=
ync.patch
  btrfs-tracepoints-fix-wrong-parameter-order-for-qgroup-events.patch
  btrfs-tracepoints-fix-bad-entry-members-of-qgroup-events.patch
  kvm-ppc-book3s-hv-xive-ensure-vp-isn-t-already-in-use.patch
  memstick-jmb38x_ms-fix-an-error-handling-path-in-jmb38x_ms_probe.patch
  cpufreq-avoid-cpufreq_suspend-deadlock-on-system-shutdown.patch
  ceph-just-skip-unrecognized-info-in-ceph_reply_info_extra.patch
  xen-netback-fix-error-path-of-xenvif_connect_data.patch
  pci-pm-fix-pci_power_up.patch
  opp-of-drop-incorrect-lockdep_assert_held.patch
  of-reserved_mem-add-missing-of_node_put-for-proper-ref-counting.patch
  blk-rq-qos-fix-first-node-deletion-of-rq_qos_del.patch

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
       =E2=9D=8C xfstests: xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9D=8C lvm thinp sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

    Host 2:
       =E2=9C=85 Boot test
       =E2=9D=8C xfstests: xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9D=8C xfstests: xfs
       =E2=9C=85 selinux-policy: serge-testsuite
       =E2=9C=85 lvm thinp sanity
       =E2=9C=85 storage: software RAID testing
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking route: pmtu
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
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
       =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =F0=9F=9A=A7 =E2=9C=85 storage: dm/common

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

