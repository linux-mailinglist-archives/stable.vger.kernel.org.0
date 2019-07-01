Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D551751A68
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 20:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFXSXG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 24 Jun 2019 14:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53613 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfFXSXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 14:23:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 416E85F793
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 18:23:06 +0000 (UTC)
Received: from [172.54.210.214] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A354919936;
        Mon, 24 Jun 2019 18:23:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.1
Message-ID: <cki.E2C5EA9855.VXZ8CIN2V5@redhat.com>
X-Gitlab-Pipeline-ID: 13138
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 24 Jun 2019 18:23:06 +0000 (UTC)
Date:   Mon, 24 Jun 2019 14:23:06 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 5f0a74b46855 - Linux 5.1.14

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
  Commit: 5f0a74b46855 - Linux 5.1.14


We grabbed the b62a342d166f commit of the stable queue repository.

We then merged the patchset with `git am`:

  tracing-silence-gcc-9-array-bounds-warning.patch
  mmc-sdhci-sdhci-pci-o2micro-correctly-set-bus-width-when-tuning.patch
  mmc-sdhi-disallow-hs400-for-m3-w-es1.2-rz-g2m-and-v3h.patch
  mmc-mediatek-fix-sdio-irq-interrupt-handle-flow.patch
  mmc-mediatek-fix-sdio-irq-detection-issue.patch
  mmc-core-api-to-temporarily-disable-retuning-for-sdio-crc-errors.patch
  mmc-core-add-sdio_retune_hold_now-and-sdio_retune_release.patch
  mmc-core-prevent-processing-sdio-irqs-when-the-card-is-suspended.patch
  scsi-ufs-avoid-runtime-suspend-possibly-being-blocked-forever.patch
  usb-chipidea-udc-workaround-for-endpoint-conflict-issue.patch
  xhci-detect-usb-3.2-capable-host-controllers-correctly.patch
  usb-xhci-don-t-try-to-recover-an-endpoint-if-port-is-in-error-state.patch
  cifs-add-spinlock-for-the-openfilelist-to-cifsinodeinfo.patch
  cifs-fix-globalmid_lock-bug-in-cifs_reconnect.patch
  ib-hfi1-validate-fault-injection-opcode-user-input.patch
  ib-hfi1-close-psm-sdma_progress-sleep-window.patch
  ib-hfi1-avoid-hardlockup-with-flushlist_lock.patch
  ib-hfi1-correct-tid-qp-rcd-to-match-verbs-context.patch
  ib-hfi1-silence-txreq-allocation-warnings.patch
  iio-imu-st_lsm6dsx-fix-pm-support-for-st_lsm6dsx-i2c-controller.patch
  iio-temperature-mlx90632-relax-the-compatibility-check.patch
  input-synaptics-enable-smbus-on-thinkpad-e480-and-e580.patch
  input-uinput-add-compat-ioctl-number-translation-for-ui_-_ff_upload.patch
  input-silead-add-mssl0017-to-acpi_device_id.patch
  apparmor-fix-profile_mediates-for-untrusted-input.patch
  apparmor-enforce-nullbyte-at-end-of-tag-string.patch
  apparmor-reset-pos-on-failure-to-unpack-for-various-functions.patch
  revert-brcmfmac-disable-command-decode-in-sdio_aos.patch
  brcmfmac-sdio-disable-auto-tuning-around-commands-expected-to-fail.patch
  brcmfmac-sdio-don-t-tune-while-the-card-is-off.patch
  lkdtm-usercopy-moves-the-kernel_ds-test-to-non-canon.patch
  arc-fix-build-warnings.patch
  dmaengine-jz4780-fix-transfers-being-acked-too-soon.patch
  dmaengine-dw-axi-dmac-fix-null-dereference-when-poin.patch
  dmaengine-mediatek-cqdma-sleeping-in-atomic-context.patch
  dmaengine-sprd-fix-the-possible-crash-when-getting-d.patch
  dmaengine-sprd-add-validation-of-current-descriptor-.patch
  dmaengine-sprd-fix-the-incorrect-start-for-2-stage-d.patch
  dmaengine-sprd-fix-block-length-overflow.patch
  dmaengine-sprd-fix-the-right-place-to-configure-2-st.patch
  arc-plat-hsdk-add-missing-multicast-filter-bins-numb.patch
  arc-plat-hsdk-add-missing-fifo-size-entry-in-gmac-no.patch
  mips-mark-ginvt-as-__always_inline.patch
  fpga-stratix10-soc-fix-use-after-free-on-s10_init.patch
  fpga-dfl-afu-pass-the-correct-device-to-dma_mapping_.patch
  fpga-dfl-add-lockdep-classes-for-pdata-lock.patch
  parport-fix-mem-leak-in-parport_register_dev_model.patch
  parisc-fix-compiler-warnings-in-float-emulation-code.patch
  habanalabs-fix-bug-in-checking-huge-page-optimizatio.patch
  ib-rdmavt-fix-alloc_qpn-warn_on.patch
  ib-hfi1-insure-freeze_work-work_struct-is-canceled-o.patch
  ib-qib-hfi1-rdmavt-correct-ibv_devinfo-max_mr-value.patch
  ib-hfi1-validate-page-aligned-for-a-given-virtual-ad.patch
  mips-uprobes-remove-set-but-not-used-variable-epc.patch
  crypto-hmac-fix-memory-leak-in-hmac_init_tfm.patch
  xtensa-fix-section-mismatch-between-memblock_reserve.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-incorrect-test_core-skip.patch
  userfaultfd-selftest-fix-compiler-warning.patch
  selftests-vm-install-test_vmalloc.sh-for-run_vmtests.patch
  net-dsa-mv88e6xxx-avoid-error-message-on-remove-from.patch
  net-hns-fix-loopback-test-failed-at-copper-ports.patch
  mdesc-fix-a-missing-check-bug-in-get_vdev_port_node_.patch
  sparc-perf-fix-updated-event-period-in-response-to-p.patch
  net-ethernet-mediatek-use-hw_feature-to-judge-if-hwl.patch
  net-ethernet-mediatek-use-net_ip_align-to-judge-if-h.patch
  selftests-set-sysctl-bc_forwarding-properly-in-route.patch
  drm-arm-mali-dp-add-a-loop-around-the-second-set-cva.patch
  drm-arm-hdlcd-actually-validate-crtc-modes.patch
  drm-arm-hdlcd-allow-a-bit-of-clock-tolerance.patch
  nvmet-fix-data_len-to-0-for-bdev-backed-write_zeroes.patch
  kbuild-tar-pkg-enable-communication-with-jobserver.patch
  scripts-checkstack.pl-fix-arm64-wrong-or-unknown-arc.patch
  net-phylink-avoid-reducing-support-mask.patch
  scsi-ufs-check-that-space-was-properly-alloced-in-co.patch
  scsi-smartpqi-unlock-on-error-in-pqi_submit_raid_req.patch
  net-ipvlan-fix-ipvlan-device-tso-disabled-while-neti.patch
  udmabuf-actually-unmap-the-scatterlist.patch
  tests-fix-pidfd-test-compilation.patch
  s390-qeth-handle-limited-ipv4-broadcast-in-l3-tx-pat.patch
  s390-qeth-check-dst-entry-before-use.patch
  s390-qeth-fix-vlan-attribute-in-bridge_hostnotify-ud.patch
  hwmon-core-add-thermal-sensors-only-if-dev-of_node-i.patch
  hwmon-pmbus-core-treat-parameters-as-paged-if-on-mul.patch
  arm64-silence-gcc-warnings-about-arch-abi-drift.patch
  nvme-fix-u32-overflow-in-the-number-of-namespace-lis.patch
  ovl-detect-overlapping-layers.patch
  ovl-don-t-fail-with-disconnected-lower-nfs.patch
  ovl-fix-bogus-wmaybe-unitialized-warning.patch
  btrfs-start-readahead-also-in-seed-devices.patch
  can-xilinx_can-use-correct-bittiming_const-for-can-fd-core.patch
  can-flexcan-fix-timeout-when-set-small-bitrate.patch
  can-purge-socket-error-queue-on-sock-destruct.patch
  riscv-mm-synchronize-mmu-after-pte-change.patch
  powerpc-bpf-use-unsigned-division-instruction-for-64-bit-operations.patch
  arm-imx-cpuidle-imx6sx-restrict-the-sw2iso-increase-to-i.mx6sx.patch
  arm-mvebu_v7_defconfig-fix-ethernet-on-clearfog.patch
  arm-dts-dra76x-update-mmc2_hs200_manual1-iodelay-values.patch
  arm-dts-am57xx-idk-remove-support-for-voltage-switching-for-sd-card.patch
  arm64-sve-uapi-asm-ptrace.h-should-not-depend-on-uapi-linux-prctl.h.patch
  arm64-ssbd-explicitly-depend-on-linux-prctl.h.patch
  kvm-x86-mmu-allocate-pae-root-array-when-using-svm-s-32-bit-npt.patch
  ovl-make-i_ino-consistent-with-st_ino-in-more-cases.patch
  drm-vmwgfx-use-the-backdoor-port-if-the-hb-port-is-not-available.patch
  drm-i915-don-t-clobber-m-n-values-during-fastset-check.patch
  binder-fix-possible-uaf-when-freeing-buffer.patch
  staging-erofs-add-requirements-field-in-superblock.patch
  bluetooth-align-minimum-encryption-key-size-for-le-and-br-edr-connections.patch
  bluetooth-fix-regression-with-minimum-encryption-key-size-alignment.patch
  smb3-retry-on-status_insufficient_resources-instead-of-failing-write.patch
  x86-vdso-prevent-segfaults-due-to-hoisted-vclock-reads.patch
  fs-namespace-fix-unprivileged-mount-propagation.patch
  cfg80211-fix-memory-leak-of-wiphy-device-name.patch
  mac80211-drop-robust-management-frames-from-unknown-ta.patch
  nl-mac-80211-allow-4addr-ap-operation-on-crypto-controlled-devices.patch
  mac80211-handle-deauthentication-disassociation-from-tdls-peer.patch
  nl80211-fix-station_info-pertid-memory-leak.patch
  mac80211-do-not-use-stack-memory-with-scatterlist-for-gmac.patch
  x86-resctrl-don-t-stop-walking-closids-when-a-locksetup-group-is-found.patch
  powerpc-mm-64s-hash-reallocate-context-ids-on-fork.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d1efaff0626c499eb968d92d193abd238fa724e9.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-d1efaff0626c499eb968d92d193abd238fa724e9.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d1efaff0626c499eb968d92d193abd238fa724e9.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-d1efaff0626c499eb968d92d193abd238fa724e9.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d1efaff0626c499eb968d92d193abd238fa724e9.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-d1efaff0626c499eb968d92d193abd238fa724e9.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d1efaff0626c499eb968d92d193abd238fa724e9.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-d1efaff0626c499eb968d92d193abd238fa724e9.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ tuned: tune-processes-through-perf [13]
       🚧 ✅ storage: SCSI VPD [14]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ tuned: tune-processes-through-perf [13]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ tuned: tune-processes-through-perf [13]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ xfstests: xfs [1]
       ✅ selinux-policy: serge-testsuite [2]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [3]
       ✅ Loopdev Sanity [4]
       ✅ AMTU (Abstract Machine Test Utility) [5]
       ✅ LTP: openposix test suite [6]
       ✅ Ethernet drivers sanity [7]
       ✅ audit: audit testsuite test [8]
       ✅ httpd: mod_ssl smoke sanity [9]
       ✅ iotop: sanity [10]
       ✅ Usex - version 1.9-29 [11]
       🚧 ✅ Networking socket: fuzz [12]
       🚧 ✅ tuned: tune-processes-through-perf [13]
       🚧 ✅ storage: SCSI VPD [14]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
