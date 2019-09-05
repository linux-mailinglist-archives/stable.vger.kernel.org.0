Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4249CA98D9
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfIEDT4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Sep 2019 23:19:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbfIEDT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 23:19:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3B2787648
        for <stable@vger.kernel.org>; Thu,  5 Sep 2019 03:19:55 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22FA460852;
        Thu,  5 Sep 2019 03:19:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
CC:     Yi Zhang <yi.zhang@redhat.com>
Message-ID: <cki.997D712D47.NMATI0WU6Q@redhat.com>
X-Gitlab-Pipeline-ID: 144281
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/144281
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 05 Sep 2019 03:19:55 +0000 (UTC)
Date:   Wed, 4 Sep 2019 23:19:56 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: c3915fe1bf12 - Linux 5.2.11

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/144281

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
  Commit: c3915fe1bf12 - Linux 5.2.11


We grabbed the 865ab84c192e commit of the stable queue repository.

We then merged the patchset with `git am`:

  dmaengine-ste_dma40-fix-unneeded-variable-warning.patch
  nvme-multipath-revalidate-nvme_ns_head-gendisk-in-nv.patch
  afs-fix-the-cb.probeuuid-service-handler-to-reply-co.patch
  afs-fix-loop-index-mixup-in-afs_deliver_vl_get_entry.patch
  fs-afs-fix-a-possible-null-pointer-dereference-in-af.patch
  afs-fix-off-by-one-in-afs_rename-expected-data-versi.patch
  afs-only-update-d_fsdata-if-different-in-afs_d_reval.patch
  afs-fix-missing-dentry-data-version-updating.patch
  nvmet-fix-use-after-free-bug-when-a-port-is-removed.patch
  nvmet-loop-flush-nvme_delete_wq-when-removing-the-po.patch
  nvmet-file-fix-nvmet_file_flush-always-returning-an-.patch
  nvme-core-fix-extra-device_put-call-on-error-path.patch
  nvme-fix-a-possible-deadlock-when-passthru-commands-.patch
  nvme-rdma-fix-possible-use-after-free-in-connect-err.patch
  nvme-fix-controller-removal-race-with-scan-work.patch
  nvme-pci-fix-async-probe-remove-race.patch
  soundwire-cadence_master-fix-register-definition-for.patch
  soundwire-cadence_master-fix-definitions-for-intstat.patch
  auxdisplay-panel-need-to-delete-scan_timer-when-misc.patch
  btrfs-trim-check-the-range-passed-into-to-prevent-ov.patch
  ib-mlx5-fix-implicit-mr-release-flow.patch
  dmaengine-stm32-mdma-fix-a-possible-null-pointer-der.patch
  omap-dma-omap_vout_vrfb-fix-off-by-one-fi-value.patch
  iommu-dma-handle-sg-length-overflow-better.patch
  dma-direct-don-t-truncate-dma_required_mask-to-bus-a.patch
  usb-gadget-composite-clear-suspended-on-reset-discon.patch
  usb-gadget-mass_storage-fix-races-between-fsg_disabl.patch
  habanalabs-fix-dram-usage-accounting-on-context-tear.patch
  habanalabs-fix-endianness-handling-for-packets-from-.patch
  habanalabs-fix-completion-queue-handling-when-host-i.patch
  habanalabs-fix-endianness-handling-for-internal-qman.patch
  habanalabs-fix-device-irq-unmasking-for-be-host.patch
  xen-blkback-fix-memory-leaks.patch
  arm64-cpufeature-don-t-treat-granule-sizes-as-strict.patch
  riscv-fix-flush_tlb_range-end-address-for-flush_tlb_.patch
  i2c-rcar-avoid-race-when-unregistering-slave-client.patch
  i2c-emev2-avoid-race-when-unregistering-slave-client.patch
  drm-scheduler-use-job-count-instead-of-peek.patch
  drm-ast-fixed-reboot-test-may-cause-system-hanged.patch
  usb-host-fotg2-restart-hcd-after-port-reset.patch
  tools-hv-fixed-python-pep8-flake8-warnings-for-lsvmb.patch
  tools-hv-fix-kvp-and-vss-daemons-exit-code.patch
  locking-rwsem-add-missing-acquire-to-read_slowpath-e.patch
  lcoking-rwsem-add-missing-acquire-to-read_slowpath-s.patch
  watchdog-bcm2835_wdt-fix-module-autoload.patch
  selftests-bpf-install-files-test_xdp_vlan.sh.patch
  drm-bridge-tfp410-fix-memleak-in-get_modes.patch
  mt76-usb-fix-rx-a-msdu-support.patch
  ipv6-addrconf-allow-adding-multicast-addr-if-ifa_f_mcautojoin-is-set.patch
  ipv6-fix-return-value-of-ipv6_mc_may_pull-for-malformed-packets.patch
  net-cpsw-fix-null-pointer-exception-in-the-probe-error-path.patch
  net-fix-__ip_mc_inc_group-usage.patch
  net-smc-make-sure-epollout-is-raised.patch
  tcp-make-sure-epollout-wont-be-missed.patch
  ipv4-mpls-fix-mpls_xmit-for-iptunnel.patch
  openvswitch-fix-conntrack-cache-with-timeout.patch
  ipv4-icmp-fix-rt-dst-dev-null-pointer-dereference.patch
  xfrm-xfrm_policy-fix-dst-dev-null-pointer-dereference-in-collect_md-mode.patch
  mm-zsmalloc.c-fix-build-when-config_compaction-n.patch
  alsa-usb-audio-check-mixer-unit-bitmap-yet-more-strictly.patch
  alsa-hda-ca0132-add-new-sbz-quirk.patch
  alsa-line6-fix-memory-leak-at-line6_init_pcm-error-path.patch
  alsa-hda-fixes-inverted-conexant-gpio-mic-mute-led.patch
  alsa-seq-fix-potential-concurrent-access-to-the-deleted-pool.patch
  alsa-usb-audio-fix-invalid-null-check-in-snd_emuusb_set_samplerate.patch
  alsa-usb-audio-add-implicit-fb-quirk-for-behringer-ufx1604.patch
  kvm-x86-skip-populating-logical-dest-map-if-apic-is-not-sw-enabled.patch
  kvm-x86-hyper-v-don-t-crash-on-kvm_get_supported_hv_cpuid-when-kvm_intel.nested-is-disabled.patch
  kvm-x86-don-t-update-rip-or-do-single-step-on-faulting-emulation.patch
  uprobes-x86-fix-detection-of-32-bit-user-mode.patch
  x86-mm-cpa-prevent-large-page-split-when-ftrace-flips-rw-on-kernel-text.patch
  x86-apic-do-not-initialize-ldr-and-dfr-for-bigsmp.patch
  x86-apic-include-the-ldr-when-clearing-out-apic-registers.patch
  hid-logitech-hidpp-remove-support-for-the-g700-over-.patch
  ftrace-fix-null-pointer-dereference-in-t_probe_next.patch
  ftrace-check-for-successful-allocation-of-hash.patch
  ftrace-check-for-empty-hash-and-comment-the-race-with-registering-probes.patch
  usbtmc-more-sanity-checking-for-packet-size.patch
  usb-storage-add-new-jms567-revision-to-unusual_devs.patch
  usb-cdc-wdm-fix-race-between-write-and-disconnect-due-to-flag-abuse.patch
  usb-hcd-use-managed-device-resources.patch
  usb-chipidea-udc-don-t-do-hardware-access-if-gadget-has-stopped.patch
  usb-host-ohci-fix-a-race-condition-between-shutdown-and-irq.patch
  usb-host-xhci-rcar-fix-typo-in-compatible-string-matching.patch
  usb-storage-ums-realtek-update-module-parameter-description-for-auto_delink_en.patch
  usb-storage-ums-realtek-whitelist-auto-delink-support.patch
  tools-power-turbostat-fix-caller-parameter-of-get_tdp_amd.patch
  kvm-ppc-book3s-fix-incorrect-guest-to-user-translation-error-handling.patch
  kvm-arm-arm64-vgic-fix-potential-deadlock-when-ap_list-is-long.patch
  kvm-arm-arm64-vgic-v2-handle-sgi-bits-in-gicd_i-s-c-pendr0-as-wi.patch
  mei-me-add-tiger-lake-point-lp-device-id.patch
  revert-mmc-sdhci-tegra-drop-get_ro-implementation.patch
  mmc-sdhci-of-at91-add-quirk-for-broken-hs200.patch
  mmc-sdhci-cadence-enable-v4_mode-to-fix-adma-64-bit-addressing.patch
  mmc-core-fix-init-of-sd-cards-reporting-an-invalid-vdd-range.patch
  mmc-sdhci-sprd-fixed-incorrect-clock-divider.patch
  mmc-sdhci-sprd-add-sdhci_quirk2_preset_value_broken.patch
  stm-class-fix-a-double-free-of-stm_source_device.patch
  intel_th-pci-add-support-for-another-lewisburg-pch.patch
  intel_th-pci-add-tiger-lake-support.patch
  typec-tcpm-fix-a-typo-in-the-comparison-of-pdo_max_voltage.patch
  fsi-scom-don-t-abort-operations-for-minor-errors.patch
  lkdtm-bugs-fix-build-error-in-lkdtm_exhaust_stack.patch
  nfsv4-pnfs-fix-a-page-lock-leak-in-nfs_pageio_resend.patch
  nfs-ensure-o_direct-reports-an-error-if-the-bytes-read-written-is-0.patch
  revert-nfsv4-flexfiles-abort-i-o-early-if-the-layout-segment-was-invalidated.patch
  lib-logic_pio-fix-rcu-usage.patch
  lib-logic_pio-avoid-possible-overlap-for-unregistering-regions.patch
  lib-logic_pio-add-logic_pio_unregister_range.patch
  drm-amdgpu-add-aptx-quirk-for-dell-latitude-5495.patch
  drm-amdgpu-fix-gfxoff-on-picasso-and-raven2.patch
  drm-i915-don-t-deballoon-unused-ggtt-drm_mm_node-in-linux-guest.patch
  drm-i915-call-dma_set_max_seg_size-in-i915_driver_hw_probe.patch
  i2c-piix4-fix-port-selection-for-amd-family-16h-model-30h.patch
  bus-hisi_lpc-unregister-logical-pio-range-to-avoid-potential-use-after-free.patch
  bus-hisi_lpc-add-.remove-method-to-avoid-driver-unbind-crash.patch
  vmci-release-resource-if-the-work-is-already-queued.patch
  crypto-ccp-ignore-unconfigured-ccp-device-on-suspend-resume.patch
  sunrpc-don-t-handle-errors-if-the-bind-connect-succeeded.patch
  mt76-mt76x0u-do-not-reset-radio-on-resume.patch
  mms-sdhci-sprd-add-sdhci_quirk_broken_card_detection.patch
  mm-memcg-partially-revert-mm-memcontrol.c-keep-local-vm-counters-in-sync-with-the-hierarchical-ones.patch
  mm-memcontrol-fix-percpu-vmstats-and-vmevents-flush.patch
  revert-cfg80211-fix-processing-world-regdomain-when-non-modular.patch
  mac80211-fix-possible-sta-leak.patch
  cfg80211-fix-extended-key-id-key-install-checks.patch
  mac80211-don-t-memset-rxcb-prior-to-pae-intercept.patch
  mac80211-correctly-set-noencrypt-for-pae-frames.patch
  mmc-sdhci-sprd-clear-the-uhs-i-modes-read-from-regis.patch
  mmc-sdhci-sprd-implement-the-get_max_timeout_count-i.patch
  mmc-sdhci-sprd-add-get_ro-hook-function.patch
  iwlwifi-add-new-cards-for-22000-and-fix-struct-name.patch
  iwlwifi-add-new-cards-for-22000-and-change-wrong-str.patch
  iwlwifi-add-new-cards-for-9000-and-20000-series.patch
  iwlwifi-change-0x02f0-fw-from-qu-to-quz.patch
  iwlwifi-pcie-add-support-for-qu-c-step-devices.patch
  iwlwifi-pcie-don-t-switch-fw-to-qnj-when-ax201-is-de.patch
  iwlwifi-pcie-handle-switching-killer-qu-b0-nics-to-c.patch
  drm-i915-do-not-create-a-new-max_bpc-prop-for-mst-co.patch
  drm-i915-dp-fix-dsc-enable-code-to-use-cpu_transcode.patch
  x86-ptrace-fix-up-botched-merge-of-spectrev1-fix.patch
  bpf-fix-use-after-free-in-prog-symbol-exposure.patch
  hsr-implement-dellink-to-clean-up-resources.patch

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
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking: igmp conformance test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ✅ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns transport [17]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]
         🚧 ✅ trace: ftrace/tracer [18]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [19]
         🚧 ✅ Storage blktests [20]


  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [19]
         🚧 ❌ Storage blktests [20]

      Host 2:
         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         🚧 ✅ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]
         🚧 ✅ trace: ftrace/tracer [18]


  x86_64:
      Host 1:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [1]
         ✅ Podman system integration test (as user) [1]
         ✅ Loopdev Sanity [2]
         ✅ jvm test suite [3]
         ✅ AMTU (Abstract Machine Test Utility) [4]
         ✅ LTP: openposix test suite [5]
         ✅ Ethernet drivers sanity [6]
         ✅ Networking socket: fuzz [7]
         ✅ Networking: igmp conformance test [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [21]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ⚡⚡⚡ LTP lite [15]
         🚧 ✅ Memory function: kaslr [16]
         🚧 ✅ Networking ipsec: basic netns transport [17]
         🚧 ✅ Networking ipsec: basic netns tunnel [17]
         🚧 ✅ trace: ftrace/tracer [18]

      Host 2:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [19]
         🚧 ✅ Storage blktests [20]
         🚧 ✅ IOMMU boot test [22]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/igmp/conformance
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#memory/function/kaslr
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/ipsec/ipsec_basic/ipsec_basic_netns
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#trace/ftrace/tracer
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/iommu/boot

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
