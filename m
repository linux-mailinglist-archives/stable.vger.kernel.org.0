Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA79E48F
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 11:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfH0JiG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 05:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfH0JiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 05:38:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68F448980ED
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 09:38:05 +0000 (UTC)
Received: from [172.54.124.177] (cpt-1056.paas.prod.upshift.rdu2.redhat.com [10.0.19.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC12160610;
        Tue, 27 Aug 2019 09:38:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.35C259CEB2.IG91O8OM2L@redhat.com>
X-Gitlab-Pipeline-ID: 126726
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/126726
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 27 Aug 2019 09:38:05 +0000 (UTC)
Date:   Tue, 27 Aug 2019 05:38:05 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: f7d5b3dc4792 - Linux 5.2.10

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/126726

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
  Commit: f7d5b3dc4792 - Linux 5.2.10


We grabbed the aa87c0d7819b commit of the stable queue repository.

We then merged the patchset with `git am`:

  asoc-simple_card_utils.h-care-null-dai-at-asoc_simpl.patch
  asoc-simple-card-fix-an-use-after-free-in-simple_dai.patch
  asoc-simple-card-fix-an-use-after-free-in-simple_for.patch
  asoc-audio-graph-card-fix-use-after-free-in-graph_da.patch
  asoc-audio-graph-card-fix-an-use-after-free-in-graph.patch
  asoc-audio-graph-card-add-missing-const-at-graph_get.patch
  regulator-axp20x-fix-dcdca-and-dcdcd-for-axp806.patch
  regulator-axp20x-fix-dcdc5-and-dcdc6-for-axp803.patch
  asoc-samsung-odroid-fix-an-use-after-free-issue-for-.patch
  asoc-samsung-odroid-fix-a-double-free-issue-for-cpu_.patch
  asoc-intel-bytcht_es8316-add-quirk-for-irbis-nb41-ne.patch
  hid-logitech-hidpp-add-usb-pid-for-a-few-more-suppor.patch
  hid-add-044f-b320-thrustmaster-inc.-2-in-1-dt.patch
  mips-kernel-only-use-i8253-clocksource-with-periodic.patch
  mips-fix-cacheinfo.patch
  libbpf-sanitize-var-to-conservative-1-byte-int.patch
  netfilter-ebtables-fix-a-memory-leak-bug-in-compat.patch
  asoc-dapm-fix-handling-of-custom_stop_condition-on-d.patch
  asoc-sof-use-__u32-instead-of-uint32_t-in-uapi-heade.patch
  spi-pxa2xx-balance-runtime-pm-enable-disable-on-erro.patch
  bpf-sockmap-sock_map_delete-needs-to-use-xchg.patch
  bpf-sockmap-synchronize_rcu-before-free-ing-map.patch
  bpf-sockmap-only-create-entry-if-ulp-is-not-already-.patch
  selftests-bpf-fix-sendmsg6_prog-on-s390.patch
  asoc-dapm-fix-a-memory-leak-bug.patch
  bonding-force-slave-speed-check-after-link-state-rec.patch
  net-mvpp2-don-t-check-for-3-consecutive-idle-frames-.patch
  selftests-forwarding-gre_multipath-enable-ipv4-forwa.patch
  selftests-forwarding-gre_multipath-fix-flower-filter.patch
  selftests-bpf-add-another-gso_segs-access.patch
  libbpf-fix-using-uninitialized-ioctl-results.patch
  can-dev-call-netif_carrier_off-in-register_candev.patch
  can-mcp251x-add-error-check-when-wq-alloc-failed.patch
  can-gw-fix-error-path-of-cgw_module_init.patch
  asoc-fail-card-instantiation-if-dai-format-setup-fai.patch
  staging-fbtft-fix-gpio-handling.patch
  libbpf-silence-gcc8-warning-about-string-truncation.patch
  st21nfca_connectivity_event_received-null-check-the-.patch
  st_nci_hci_connectivity_event_received-null-check-th.patch
  nl-mac-80211-fix-interface-combinations-on-crypto-co.patch
  asoc-ti-davinci-mcasp-fix-clk-pdir-handling-for-i2s-.patch
  asoc-rockchip-fix-mono-capture.patch
  asoc-ti-davinci-mcasp-correct-slot_width-posed-const.patch
  net-usb-qmi_wwan-add-the-broadmobi-bm818-card.patch
  qed-rdma-fix-the-hw_ver-returned-in-device-attribute.patch
  isdn-misdn-hfcsusb-fix-possible-null-pointer-derefer.patch
  habanalabs-fix-f-w-download-in-be-architecture.patch
  mac80211_hwsim-fix-possible-null-pointer-dereference.patch
  net-stmmac-manage-errors-returned-by-of_get_mac_addr.patch
  netfilter-ipset-actually-allow-destination-mac-addre.patch
  netfilter-ipset-copy-the-right-mac-address-in-bitmap.patch
  netfilter-ipset-fix-rename-concurrency-with-listing.patch
  rxrpc-fix-potential-deadlock.patch
  rxrpc-fix-the-lack-of-notification-when-sendmsg-fail.patch
  nvmem-use-the-same-permissions-for-eeprom-as-for-nvm.patch
  iwlwifi-mvm-avoid-races-in-rate-init-and-rate-perfor.patch
  iwlwifi-dbg_ini-move-iwl_dbg_tlv_load_bin-out-of-deb.patch
  iwlwifi-dbg_ini-move-iwl_dbg_tlv_free-outside-of-deb.patch
  iwlwifi-fix-locking-in-delayed-gtk-setting.patch
  iwlwifi-mvm-send-lq-command-always-async.patch
  enetc-fix-build-error-without-phylib.patch
  isdn-hfcsusb-fix-misdn-driver-crash-caused-by-transf.patch
  net-phy-phy_led_triggers-fix-a-possible-null-pointer.patch
  perf-bench-numa-fix-cpu0-binding.patch
  spi-pxa2xx-add-support-for-intel-tiger-lake.patch
  can-sja1000-force-the-string-buffer-null-terminated.patch
  can-peak_usb-force-the-string-buffer-null-terminated.patch
  asoc-amd-acp3x-use-dma_ops-of-parent-device-for-acp3.patch
  net-ethernet-qlogic-qed-force-the-string-buffer-null.patch
  enetc-select-phylib-while-config_fsl_enetc_vf-is-set.patch
  nfsv4-fix-a-credential-refcount-leak-in-nfs41_check_.patch
  nfsv4-when-recovering-state-fails-with-eagain-retry-.patch
  nfsv4.1-fix-open-stateid-recovery.patch
  nfsv4.1-only-reap-expired-delegations.patch
  nfsv4-fix-a-potential-sleep-while-atomic-in-nfs4_do_.patch
  nfs-fix-regression-whereby-fscache-errors-are-appear.patch
  hid-quirks-set-the-increment_usage_on_duplicate-quir.patch
  hid-input-fix-a4tech-horizontal-wheel-custom-usage.patch
  drm-rockchip-suspend-dp-late.patch
  smb3-fix-potential-memory-leak-when-processing-compo.patch
  smb3-kernel-oops-mounting-a-encryptdata-share-with-c.patch
  sched-deadline-fix-double-accounting-of-rq-running-b.patch
  sched-psi-reduce-psimon-fifo-priority.patch
  sched-psi-do-not-require-setsched-permission-from-th.patch
  s390-protvirt-avoid-memory-sharing-for-diag-308-set-.patch
  s390-mm-fix-dump_pagetables-top-level-page-table-wal.patch
  s390-put-_stext-and-_etext-into-.text-section.patch
  ata-rb532_cf-fix-unused-variable-warning-in-rb532_pa.patch
  net-cxgb3_main-fix-a-resource-leak-in-a-error-path-i.patch
  net-stmmac-fix-issues-when-number-of-queues-4.patch
  net-stmmac-tc-do-not-return-a-fragment-entry.patch
  drm-amdgpu-pin-the-csb-buffer-on-hw-init-for-gfx-v8.patch
  net-hisilicon-make-hip04_tx_reclaim-non-reentrant.patch
  net-hisilicon-fix-hip04-xmit-never-return-tx_busy.patch
  net-hisilicon-fix-dma_map_single-failed-on-arm64.patch
  nfsv4-ensure-state-recovery-handles-etimedout-correc.patch
  libata-have-ata_scsi_rw_xlat-fail-invalid-passthroug.patch
  libata-add-sg-safety-checks-in-sff-pio-transfers.patch
  x86-lib-cpu-address-missing-prototypes-warning.patch
  drm-vmwgfx-fix-memory-leak-when-too-many-retries-hav.patch
  block-aoe-fix-kernel-crash-due-to-atomic-sleep-when-.patch
  block-bfq-handle-null-return-value-by-bfq_init_rq.patch
  perf-ftrace-fix-failure-to-set-cpumask-when-only-one.patch
  perf-cpumap-fix-writing-to-illegal-memory-in-handlin.patch
  perf-pmu-events-fix-missing-cpu_clk_unhalted.core-ev.patch
  dt-bindings-riscv-fix-the-schema-compatible-string-f.patch
  kvm-arm64-don-t-write-junk-to-sysregs-on-reset.patch
  kvm-arm-don-t-write-junk-to-cp15-registers-on-reset.patch
  selftests-kvm-adding-config-fragments.patch
  iwlwifi-mvm-disable-tx-amsdu-on-older-nics.patch
  hid-wacom-correct-misreported-ekr-ring-values.patch
  hid-wacom-correct-distance-scale-for-2nd-gen-intuos-devices.patch
  revert-kvm-x86-mmu-zap-only-the-relevant-pages-when-removing-a-memslot.patch
  revert-dm-bufio-fix-deadlock-with-loop-device.patch
  clk-socfpga-stratix10-fix-rate-caclulationg-for-cnt_clks.patch
  ceph-clear-page-dirty-before-invalidate-page.patch
  ceph-don-t-try-fill-file_lock-on-unsuccessful-getfilelock-reply.patch
  libceph-fix-pg-split-vs-osd-re-connect-race.patch
  drm-amdgpu-gfx9-update-pg_flags-after-determining-if-gfx-off-is-possible.patch
  drm-nouveau-don-t-retry-infinitely-when-receiving-no-data-on-i2c-over-aux.patch
  scsi-ufs-fix-null-pointer-dereference-in-ufshcd_config_vreg_hpm.patch
  gpiolib-never-report-open-drain-source-lines-as-input-to-user-space.patch
  drivers-hv-vmbus-fix-virt_to_hvpfn-for-x86_pae.patch
  userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch
  x86-retpoline-don-t-clobber-rflags-during-call_nospec-on-i386.patch
  x86-apic-handle-missing-global-clockevent-gracefully.patch
  x86-cpu-amd-clear-rdrand-cpuid-bit-on-amd-family-15h-16h.patch
  x86-boot-save-fields-explicitly-zero-out-everything-else.patch
  x86-boot-fix-boot-regression-caused-by-bootparam-sanitizing.patch
  ib-hfi1-unsafe-psn-checking-for-tid-rdma-read-resp-packet.patch
  ib-hfi1-add-additional-checks-when-handling-tid-rdma-read-resp-packet.patch
  ib-hfi1-add-additional-checks-when-handling-tid-rdma-write-data-packet.patch
  ib-hfi1-drop-stale-tid-rdma-packets-that-cause-tiderr.patch
  psi-get-poll_work-to-run-when-calling-poll-syscall-next-time.patch
  dm-kcopyd-always-complete-failed-jobs.patch
  dm-dust-use-dust-block-size-for-badblocklist-index.patch
  dm-btree-fix-order-of-block-initialization-in-btree_split_beneath.patch
  dm-integrity-fix-a-crash-due-to-bug_on-in-__journal_read_write.patch
  dm-raid-add-missing-cleanup-in-raid_ctr.patch
  dm-space-map-metadata-fix-missing-store-of-apply_bops-return-value.patch
  dm-table-fix-invalid-memory-accesses-with-too-high-sector-number.patch
  dm-zoned-improve-error-handling-in-reclaim.patch
  dm-zoned-improve-error-handling-in-i-o-map-code.patch
  dm-zoned-properly-handle-backing-device-failure.patch
  genirq-properly-pair-kobject_del-with-kobject_add.patch
  mm-z3fold.c-fix-race-between-migration-and-destruction.patch
  mm-page_alloc-move_freepages-should-not-examine-struct-page-of-reserved-memory.patch
  mm-memcontrol-flush-percpu-vmstats-before-releasing-memcg.patch
  mm-memcontrol-flush-percpu-vmevents-before-releasing-memcg.patch
  mm-page_owner-handle-thp-splits-correctly.patch
  mm-zsmalloc.c-migration-can-leave-pages-in-zs_empty-indefinitely.patch
  mm-zsmalloc.c-fix-race-condition-in-zs_destroy_pool.patch
  mm-kasan-fix-false-positive-invalid-free-reports-with-config_kasan_sw_tags-y.patch
  xfs-fix-missing-ilock-unlock-when-xfs_setattr_nonsize-fails-due-to-edquot.patch
  ib-hfi1-drop-stale-tid-rdma-packets.patch
  dm-zoned-fix-potential-null-dereference-in-dmz_do_re.patch
  io_uring-fix-potential-hang-with-polled-io.patch
  io_uring-don-t-enter-poll-loop-if-we-have-cqes-pendi.patch
  io_uring-add-need_resched-check-in-inner-poll-loop.patch
  powerpc-allow-flush_-inval_-dcache_range-to-work-across-ranges-4gb.patch

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
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Ethernet drivers sanity [12]
         ✅ Networking socket: fuzz [13]
         ✅ audit: audit testsuite test [14]
         ✅ httpd: mod_ssl smoke sanity [15]
         ✅ iotop: sanity [16]
         ✅ tuned: tune-processes-through-perf [17]
         ✅ Usex - version 1.9-29 [18]
         ✅ storage: SCSI VPD [19]
         ✅ stress: stress-ng [20]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Ethernet drivers sanity [12]
         ✅ Networking socket: fuzz [13]
         ✅ audit: audit testsuite test [14]
         ✅ httpd: mod_ssl smoke sanity [15]
         ✅ iotop: sanity [16]
         ✅ tuned: tune-processes-through-perf [17]
         ✅ Usex - version 1.9-29 [18]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [6]
         ✅ Podman system integration test (as user) [6]
         ✅ LTP lite [7]
         ✅ Loopdev Sanity [8]
         ✅ jvm test suite [9]
         ✅ AMTU (Abstract Machine Test Utility) [10]
         ✅ LTP: openposix test suite [11]
         ✅ Ethernet drivers sanity [12]
         ✅ Networking socket: fuzz [13]
         ✅ audit: audit testsuite test [14]
         ✅ httpd: mod_ssl smoke sanity [15]
         ✅ iotop: sanity [16]
         ✅ tuned: tune-processes-through-perf [17]
         ✅ pciutils: sanity smoke test [21]
         ✅ Usex - version 1.9-29 [18]
         ✅ storage: SCSI VPD [19]
         ✅ stress: stress-ng [20]

      Host 2:
         ✅ Boot test [0]
         ✅ xfstests: xfs [1]
         ✅ selinux-policy: serge-testsuite [2]
         ✅ lvm thinp sanity [3]
         ✅ storage: software RAID testing [4]
         🚧 ✅ Storage blktests [5]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
