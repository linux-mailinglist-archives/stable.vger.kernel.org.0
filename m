Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0164F8E4BA
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 08:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfHOGFV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 15 Aug 2019 02:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61125 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOGFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 02:05:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1C6530613C5
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 06:05:20 +0000 (UTC)
Received: from [172.54.84.190] (cpt-1024.paas.prod.upshift.rdu2.redhat.com [10.0.19.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74FC71E0;
        Thu, 15 Aug 2019 06:05:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.102508E49F.UYG2NQSV5R@redhat.com>
X-Gitlab-Pipeline-ID: 100903
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/100903
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 15 Aug 2019 06:05:20 +0000 (UTC)
Date:   Thu, 15 Aug 2019 02:05:21 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: d36a8d2fb62c - Linux 5.2.8

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/100903



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

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: d36a8d2fb62c - Linux 5.2.8


We grabbed the d6535b968bdc commit of the stable queue repository.

We then merged the patchset with `git am`:

  revert-pci-add-missing-link-delays-required-by-the-pcie-spec.patch
  iio-ingenic-jz47xx-set-clock-divider-on-probe.patch
  iio-cros_ec_accel_legacy-fix-incorrect-channel-setting.patch
  iio-imu-mpu6050-add-missing-available-scan-masks.patch
  iio-adc-gyroadc-fix-uninitialized-return-code.patch
  iio-adc-max9611-fix-misuse-of-genmask-macro.patch
  staging-gasket-apex-fix-copy-paste-typo.patch
  staging-wilc1000-flush-the-workqueue-before-deinit-the-host.patch
  staging-android-ion-bail-out-upon-sigkill-when-allocating-memory.patch
  staging-fbtft-fix-probing-of-gpio-descriptor.patch
  staging-fbtft-fix-reset-assertion-when-using-gpio-descriptor.patch
  crypto-ccp-fix-oops-by-properly-managing-allocated-structures.patch
  crypto-ccp-add-support-for-valid-authsize-values-less-than-16.patch
  crypto-ccp-ignore-tag-length-when-decrypting-gcm-ciphertext.patch
  driver-core-platform-return-enxio-for-missing-gpioint.patch
  usb-usbfs-fix-double-free-of-usb-memory-upon-submiturb-error.patch
  revert-usb-rio500-simplify-locking.patch
  usb-iowarrior-fix-deadlock-on-disconnect.patch
  sound-fix-a-memory-leak-bug.patch
  mmc-cavium-set-the-correct-dma-max-segment-size-for-mmc_host.patch
  mmc-cavium-add-the-missing-dma-unmap-when-the-dma-has-finished.patch
  loop-set-pf_memalloc_noio-for-the-worker-thread.patch
  bdev-fixup-error-handling-in-blkdev_get.patch
  input-usbtouchscreen-initialize-pm-mutex-before-using-it.patch
  input-elantech-enable-smbus-on-new-2018-systems.patch
  input-synaptics-enable-rmi-mode-for-hp-spectre-x360.patch
  x86-mm-check-for-pfn-instead-of-page-in-vmalloc_sync_one.patch
  x86-mm-sync-also-unmappings-in-vmalloc_sync_all.patch
  mm-vmalloc-sync-unmappings-in-__purge_vmap_area_lazy.patch
  coresight-fix-debug_locks_warn_on-for-uninitialized-attribute.patch
  perf-annotate-fix-s390-gap-between-kernel-end-and-module-start.patch
  perf-db-export-fix-thread__exec_comm.patch
  perf-record-fix-module-size-on-s390.patch
  x86-purgatory-do-not-use-__builtin_memcpy-and-__builtin_memset.patch
  x86-purgatory-use-cflags_remove-rather-than-reset-kbuild_cflags.patch
  genirq-affinity-create-affinity-mask-for-single-vector.patch
  gfs2-gfs2_walk_metadata-fix.patch
  usb-host-xhci-rcar-fix-timeout-in-xhci_suspend.patch
  usb-yurex-fix-use-after-free-in-yurex_delete.patch
  usb-typec-ucsi-ccg-fix-uninitilized-symbol-error.patch
  usb-typec-tcpm-free-log-buf-memory-when-remove-debug-file.patch
  usb-typec-tcpm-remove-tcpm-dir-if-no-children.patch
  usb-typec-tcpm-add-null-check-before-dereferencing-config.patch
  usb-typec-tcpm-ignore-unsupported-unknown-alternate-mode-requests.patch
  can-rcar_canfd-fix-possible-irq-storm-on-high-load.patch
  can-flexcan-fix-stop-mode-acknowledgment.patch
  can-flexcan-fix-an-use-after-free-in-flexcan_setup_stop_mode.patch
  can-peak_usb-fix-potential-double-kfree_skb.patch
  powerpc-fix-off-by-one-in-max_zone_pfn-initializatio.patch
  netfilter-nfnetlink-avoid-deadlock-due-to-synchronou.patch
  vfio-ccw-set-pa_nr-to-0-if-memory-allocation-fails-f.patch
  vfio-ccw-don-t-call-cp_free-if-we-are-processing-a-c.patch
  netfilter-fix-rpfilter-dropping-vrf-packets-by-mista.patch
  netfilter-nf_tables-fix-module-autoload-for-redir.patch
  netfilter-conntrack-always-store-window-size-un-scal.patch
  netfilter-nft_hash-fix-symhash-with-modulus-one.patch
  scripts-sphinx-pre-install-fix-script-for-rhel-cento.patch
  scripts-sphinx-pre-install-don-t-use-latex-with-cent.patch
  scripts-sphinx-pre-install-fix-latexmk-dependencies.patch
  rq-qos-don-t-reset-has_sleepers-on-spurious-wakeups.patch
  rq-qos-set-ourself-task_uninterruptible-after-we-sch.patch
  rq-qos-use-a-mb-for-got_token.patch
  netfilter-nf_tables-support-auto-loading-for-inet-na.patch
  drm-amd-display-no-audio-endpoint-for-dell-mst-displ.patch
  drm-amd-display-clock-does-not-lower-in-updateplanes.patch
  drm-amd-display-wait-for-backlight-programming-compl.patch
  drm-amd-display-fix-dmcu-hang-when-going-into-modern.patch
  drm-amd-display-use-encoder-s-engine-id-to-find-matc.patch
  drm-amd-display-put-back-front-end-initialization-se.patch
  drm-amd-display-allocate-4-ddc-engines-for-rv2.patch
  drm-amd-display-fix-dc_create-failure-handling-and-6.patch
  drm-amd-display-only-enable-audio-if-speaker-allocat.patch
  drm-amd-display-increase-size-of-audios-array.patch
  iscsi_ibft-make-iscsi_ibft-dependson-acpi-instead-of.patch
  nl80211-fix-nl80211_he_max_capability_len.patch
  mac80211-fix-possible-memory-leak-in-ieee80211_assig.patch
  mac80211-don-t-warn-about-cw-params-when-not-using-t.patch
  allocate_flower_entry-should-check-for-null-deref.patch
  hwmon-occ-fix-division-by-zero-issue.patch
  hwmon-nct6775-fix-register-address-and-added-missed-.patch
  arm-dts-imx6ul-fix-clock-frequency-property-name-of-.patch
  powerpc-papr_scm-force-a-scm-unbind-if-initial-scm-b.patch
  arm64-force-ssbs-on-context-switch.patch
  arm64-entry-sp-alignment-fault-doesn-t-write-to-far_.patch
  iommu-vt-d-check-if-domain-pgd-was-allocated.patch
  drm-msm-dpu-correct-dpu-encoder-spinlock-initializat.patch
  drm-silence-variable-conn-set-but-not-used.patch
  arm64-dts-imx8mm-correct-sai3-rxc-txfs-pin-s-mux-opt.patch
  arm64-dts-imx8mq-fix-sai-compatible.patch
  cpufreq-pasemi-fix-use-after-free-in-pas_cpufreq_cpu.patch
  s390-qdio-add-sanity-checks-to-the-fast-requeue-path.patch
  alsa-compress-fix-regression-on-compressed-capture-s.patch
  alsa-compress-prevent-bypasses-of-set_params.patch
  alsa-compress-don-t-allow-paritial-drain-operations-.patch
  alsa-compress-be-more-restrictive-about-when-a-drain.patch
  perf-script-fix-off-by-one-in-brstackinsn-ipc-comput.patch
  perf-tools-fix-proper-buffer-size-for-feature-proces.patch
  perf-stat-fix-segfault-for-event-group-in-repeat-mod.patch
  perf-session-fix-loading-of-compressed-data-split-ac.patch
  perf-probe-avoid-calling-freeing-routine-multiple-ti.patch
  drbd-dynamically-allocate-shash-descriptor.patch
  acpi-iort-fix-off-by-one-check-in-iort_dev_find_its_.patch
  nvme-ignore-subnqn-for-adata-sx6000lnp.patch
  nvme-fix-memory-leak-caused-by-incorrect-subsystem-f.patch
  arm-davinci-fix-sleep.s-build-error-on-armv4.patch
  arm-dts-bcm-bcm47094-add-missing-cells-for-mdio-bus-.patch
  scsi-megaraid_sas-fix-panic-on-loading-firmware-cras.patch
  scsi-ibmvfc-fix-warn_on-during-event-pool-release.patch
  scsi-scsi_dh_alua-always-use-a-2-second-delay-before.patch
  test_firmware-fix-a-memory-leak-bug.patch
  tty-ldsem-locking-rwsem-add-missing-acquire-to-read_.patch
  perf-x86-intel-fix-slots-pebs-event-constraint.patch
  perf-x86-intel-fix-invalid-bit-13-for-icelake-msr_of.patch
  perf-x86-apply-more-accurate-check-on-hypervisor-pla.patch
  perf-core-fix-creating-kernel-counters-for-pmus-that.patch
  s390-dma-provide-proper-arch_zone_dma_bits-value.patch
  gen_compile_commands-lower-the-entry-count-threshold.patch
  hid-sony-fix-race-condition-between-rumble-and-device-remove.patch
  alsa-usb-audio-fix-a-memory-leak-bug.patch
  kvm-nsvm-properly-map-nested-vmcb.patch
  can-peak_usb-pcan_usb_pro-fix-info-leaks-to-usb-devices.patch
  can-peak_usb-pcan_usb_fd-fix-info-leaks-to-usb-devices.patch
  hwmon-nct7802-fix-wrong-detection-of-in4-presence.patch
  hwmon-lm75-fixup-tmp75b-clr_mask.patch
  drm-i915-fix-wrong-escape-clock-divisor-init-for-glk.patch
  alsa-firewire-fix-a-memory-leak-bug.patch
  alsa-hiface-fix-multiple-memory-leak-bugs.patch
  alsa-hda-don-t-override-global-pcm-hw-info-flag.patch
  alsa-hda-workaround-for-crackled-sound-on-amd-controller-1022-1457.patch
  mac80211-don-t-warn-on-short-wmm-parameters-from-ap.patch
  dax-dax_layout_busy_page-should-not-unmap-cow-pages.patch
  smb3-fix-deadlock-in-validate-negotiate-hits-reconnect.patch
  smb3-send-cap_dfs-capability-during-session-setup.patch
  nfsv4-fix-delegation-state-recovery.patch
  nfsv4-check-the-return-value-of-update_open_stateid.patch
  nfsv4-fix-an-oops-in-nfs4_do_setattr.patch
  kvm-fix-leak-vcpu-s-vmcs-value-into-other-pcpu.patch
  kvm-arm-arm64-sync-ich_vmcr_el2-back-when-about-to-block.patch
  mwifiex-fix-802.11n-wpa-detection.patch
  iwlwifi-don-t-unmap-as-page-memory-that-was-mapped-as-single.patch
  iwlwifi-mvm-fix-an-out-of-bound-access.patch
  iwlwifi-mvm-fix-a-use-after-free-bug-in-iwl_mvm_tx_tso_segment.patch
  iwlwifi-mvm-don-t-send-geo_tx_power_limit-on-version-41.patch
  iwlwifi-mvm-fix-version-check-for-geo_tx_power_limit-support.patch

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
         ✅ pciutils: update pci ids test [18]
         ✅ Usex - version 1.9-29 [19]


  x86_64:
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
         ✅ pciutils: sanity smoke test [20]
         ✅ pciutils: update pci ids test [18]
         ✅ Usex - version 1.9-29 [19]
         ✅ storage: SCSI VPD [21]
         ✅ stress: stress-ng [22]


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
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/update-pciids
    [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
    [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
    [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
