Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9924E148BD
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 13:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfEFLQD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 May 2019 07:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfEFLQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 07:16:03 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E34C7E437
        for <stable@vger.kernel.org>; Mon,  6 May 2019 11:16:03 +0000 (UTC)
Received: from [172.54.27.0] (cpt-0009.paas.prod.upshift.rdu2.redhat.com [10.0.18.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 016A05D969;
        Mon,  6 May 2019 11:15:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-5.0
CC:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>
Message-ID: <cki.7E6F9B004D.B5E2BOYZ3L@redhat.com>
X-Gitlab-Pipeline-ID: 9362
X-Gitlab-Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/9362
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 06 May 2019 11:16:03 +0000 (UTC)
Date:   Mon, 6 May 2019 07:16:03 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e5b9547b1aa3 - Linux 5.0.13

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

One or more kernel tests failed:

  aarch64:

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
  Commit: e5b9547b1aa3 - Linux 5.0.13

We then merged the patchset with `git am`:

  selftests-seccomp-prepare-for-exclusive-seccomp-flags.patch
  seccomp-make-new_listener-and-tsync-flags-exclusive.patch
  arc-memset-fix-build-with-l1_cache_shift-6.patch
  iwlwifi-fix-driver-operation-for-5350.patch
  mwifiex-make-resume-actually-do-something-useful-again-on-sdio-cards.patch
  mtd-rawnand-marvell-clean-the-controller-state-before-each-operation.patch
  mac80211-don-t-attempt-to-rename-err_ptr-debugfs-dirs.patch
  i2c-synquacer-fix-enumeration-of-slave-devices.patch
  i2c-imx-correct-the-method-of-getting-private-data-in-notifier_call.patch
  i2c-prevent-runtime-suspend-of-adapter-when-host-notify-is-required.patch
  alsa-hda-realtek-add-new-dell-platform-for-headset-mode.patch
  alsa-hda-realtek-fixed-dell-aio-speaker-noise.patch
  alsa-hda-realtek-apply-the-fixup-for-asus-q325uar.patch
  usb-yurex-fix-protection-fault-after-device-removal.patch
  usb-w1-ds2490-fix-bug-caused-by-improper-use-of-altsetting-array.patch
  usb-dummy-hcd-fix-failure-to-give-back-unlinked-urbs.patch
  usb-usbip-fix-isoc-packet-num-validation-in-get_pipe.patch
  usb-core-fix-unterminated-string-returned-by-usb_string.patch
  usb-core-fix-bug-caused-by-duplicate-interface-pm-usage-counter.patch
  kvm-lapic-disable-timer-advancement-if-adaptive-tuning-goes-haywire.patch
  kvm-x86-consider-lapic-tsc-deadline-timer-expired-if-deadline-too-short.patch
  kvm-lapic-track-lapic-timer-advance-per-vcpu.patch
  kvm-lapic-allow-user-to-disable-adaptive-tuning-of-timer-advancement.patch
  kvm-lapic-convert-guest-tsc-to-host-time-domain-if-necessary.patch
  arm64-dts-rockchip-fix-rk3328-roc-cc-gmac2io-tx-rx_d.patch
  hid-increase-maximum-report-size-allowed-by-hid_fiel.patch
  hid-logitech-check-the-return-value-of-create_single.patch
  hid-debug-fix-race-condition-with-between-rdesc_show.patch
  rtc-cros-ec-fail-suspend-resume-if-wake-irq-can-t-be.patch
  rtc-sh-fix-invalid-alarm-warning-for-non-enabled-ala.patch
  arm-omap2-add-missing-of_node_put-after-of_device_is.patch
  batman-adv-reduce-claim-hash-refcnt-only-for-removed.patch
  batman-adv-reduce-tt_local-hash-refcnt-only-for-remo.patch
  batman-adv-reduce-tt_global-hash-refcnt-only-for-rem.patch
  batman-adv-fix-warning-in-function-batadv_v_elp_get_.patch
  arm-dts-rockchip-fix-gpu-opp-node-names-for-rk3288.patch
  reset-meson-audio-arb-fix-missing-.owner-setting-of-.patch
  arm-dts-fix-dcan-clkctrl-clock-for-am3.patch
  i40e-fix-i40e_ptp_adjtime-when-given-a-negative-delt.patch
  igb-fix-warn_once-on-runtime-suspend.patch
  ixgbe-fix-mdio-bus-registration.patch
  i40e-fix-wol-support-check.patch
  riscv-fix-accessing-8-byte-variable-from-rv32.patch
  hid-quirks-fix-keyboard-touchpad-on-lenovo-miix-630.patch
  net-hns3-fix-compile-error.patch
  xdp-fix-cpumap-redirect-skb-creation-bug.patch
  net-mlx5-e-switch-protect-from-invalid-memory-access.patch
  net-mlx5-e-switch-fix-esw-manager-vport-indication-f.patch
  bonding-show-full-hw-address-in-sysfs-for-slave-entr.patch
  net-stmmac-use-correct-dma-buffer-size-in-the-rx-des.patch
  net-stmmac-ratelimit-rx-error-logs.patch
  net-stmmac-don-t-stop-napi-processing-when-dropping-.patch
  net-stmmac-don-t-overwrite-discard_frame-status.patch
  net-stmmac-fix-dropping-of-multi-descriptor-rx-frame.patch
  net-stmmac-don-t-log-oversized-frames.patch
  jffs2-fix-use-after-free-on-symlink-traversal.patch
  debugfs-fix-use-after-free-on-symlink-traversal.patch
  mfd-twl-core-disable-irq-while-suspended.patch
  block-use-blk_free_flush_queue-to-free-hctx-fq-in-bl.patch
  rtc-da9063-set-uie_unsupported-when-relevant.patch
  hid-input-add-mapping-for-assistant-key.patch
  vfio-pci-use-correct-format-characters.patch
  scsi-core-add-new-rdac-lenovo-de_series-device.patch
  scsi-storvsc-fix-calculation-of-sub-channel-count.patch
  arm-mach-at91-pm-fix-possible-object-reference-leak.patch
  blk-mq-do-not-reset-plug-rq_count-before-the-list-is.patch
  arm64-fix-wrong-check-of-on_sdei_stack-in-nmi-contex.patch
  net-hns-fix-kasan-use-after-free-in-hns_nic_net_xmit.patch
  net-hns-use-napi_poll_weight-for-hns-driver.patch
  net-hns-fix-probabilistic-memory-overwrite-when-hns-.patch
  net-hns-fix-icmp6-neighbor-solicitation-messages-dis.patch
  net-hns-fix-warning-when-remove-hns-driver-with-smmu.patch
  libcxgb-fix-incorrect-ppmax-calculation.patch
  kvm-svm-prevent-dbg_decrypt-and-dbg_encrypt-overflow.patch
  kmemleak-powerpc-skip-scanning-holes-in-the-.bss-sec.patch
  hugetlbfs-fix-memory-leak-for-resv_map.patch
  sh-fix-multiple-function-definition-build-errors.patch
  null_blk-prevent-crash-from-bad-home_node-value.patch
  xsysace-fix-error-handling-in-ace_setup.patch
  fs-stream_open-opener-for-stream-like-files-so-that-.patch
  arm-orion-don-t-use-using-64-bit-dma-masks.patch
  arm-iop-don-t-use-using-64-bit-dma-masks.patch
  perf-x86-amd-update-generic-hardware-cache-events-for-family-17h.patch
  bluetooth-btusb-request-wake-pin-with-noautoen.patch
  bluetooth-mediatek-fix-up-an-error-path-to-restore-bdev-tx_state.patch
  clk-qcom-add-missing-freq-for-usb30_master_clk-on-8998.patch
  usb-dwc3-reset-num_trbs-after-skipping.patch
  staging-iio-adt7316-allow-adt751x-to-use-internal-vref-for-all-dacs.patch
  staging-iio-adt7316-fix-the-dac-read-calculation.patch
  staging-iio-adt7316-fix-handling-of-dac-high-resolution-option.patch
  staging-iio-adt7316-fix-the-dac-write-calculation.patch
  scsi-hisi_sas-fix-to-only-call-scsi_get_prot_op-for-non-null-scsi_cmnd.patch
  scsi-rdma-srpt-fix-a-credit-leak-for-aborted-commands.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-6cec7217203fd93112e66d21f43e36a219d9a60a.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue-aarch64-6cec7217203fd93112e66d21f43e36a219d9a60a.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-6cec7217203fd93112e66d21f43e36a219d9a60a.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue-ppc64le-6cec7217203fd93112e66d21f43e36a219d9a60a.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-6cec7217203fd93112e66d21f43e36a219d9a60a.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue-s390x-6cec7217203fd93112e66d21f43e36a219d9a60a.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-6cec7217203fd93112e66d21f43e36a219d9a60a.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue-x86_64-6cec7217203fd93112e66d21f43e36a219d9a60a.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ❎ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  x86_64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ Loopdev Sanity [2]
     ✅ AMTU (Abstract Machine Test Utility) [3]
     ✅ Ethernet drivers sanity [4]
     ✅ httpd: mod_ssl smoke sanity [5]
     ✅ iotop: sanity [6]
     ✅ tuned: tune-processes-through-perf [7]
     ✅ Usex - version 1.9-29 [8]
     ✅ lvm thinp sanity [9]
     ✅ Boot test [0]
     ✅ xfstests: xfs [10]
     🚧 ✅ audit: audit testsuite test [11]
     🚧 ✅ stress: stress-ng [12]
     🚧 ✅ selinux-policy: serge-testsuite [13]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
