Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A629C90D
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 08:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbfHZGOs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 26 Aug 2019 02:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfHZGOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 02:14:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6133581DF1
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 06:14:46 +0000 (UTC)
Received: from [172.54.99.226] (cpt-1058.paas.prod.upshift.rdu2.redhat.com [10.0.19.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD215D9CC;
        Mon, 26 Aug 2019 06:14:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.CB4203A6BE.6Y0NKIF1U7@redhat.com>
X-Gitlab-Pipeline-ID: 124342
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/124342
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 26 Aug 2019 06:14:46 +0000 (UTC)
Date:   Mon, 26 Aug 2019 02:14:47 -0400
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

  https://artifacts.cki-project.org/pipelines/124342

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


We grabbed the 4a6e874ddb67 commit of the stable queue repository.

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

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]


  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ LTP lite [2]
         ✅ Loopdev Sanity [3]
         ✅ jvm test suite [4]
         ✅ AMTU (Abstract Machine Test Utility) [5]
         ✅ LTP: openposix test suite [6]
         ✅ Ethernet drivers sanity [7]
         ✅ Networking socket: fuzz [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [14]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [15]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
