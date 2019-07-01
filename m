Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD94051F22
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 01:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfFXXcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 19:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfFXXcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 19:32:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 201D74E938
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 23:32:52 +0000 (UTC)
Received: from [172.54.90.237] (cpt-1046.paas.prod.upshift.rdu2.redhat.com [10.0.19.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD69D19C6A;
        Mon, 24 Jun 2019 23:32:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
Message-ID: <cki.81646CFC88.UKA4CPY12X@redhat.com>
X-Gitlab-Pipeline-ID: 13165
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 24 Jun 2019 23:32:52 +0000 (UTC)
Date:   Mon, 24 Jun 2019 19:32:52 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 78778071092e - Linux 4.19.55

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED




When we attempted to merge the patchset, we received an error:

  Patch is empty.

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
  Commit: 78778071092e - Linux 4.19.55


We grabbed the 6a904a97c13f commit of the stable queue repository.

We then merged the patchset with `git am`:

  tracing-silence-gcc-9-array-bounds-warning.patch
  objtool-support-per-function-rodata-sections.patch
  gcc-9-silence-address-of-packed-member-warning.patch
  ovl-support-the-fs_ioc_fs-sg-etxattr-ioctls.patch
  ovl-fix-wrong-flags-check-in-fs_ioc_fs-sg-etxattr-io.patch
  ovl-make-i_ino-consistent-with-st_ino-in-more-cases.patch
  ovl-detect-overlapping-layers.patch
  ovl-don-t-fail-with-disconnected-lower-nfs.patch
  ovl-fix-bogus-wmaybe-unitialized-warning.patch
  s390-jump_label-use-jdd-constraint-on-gcc9.patch
  s390-ap-rework-assembler-functions-to-use-unions-for.patch
  mmc-sdhci-sdhci-pci-o2micro-correctly-set-bus-width-when-tuning.patch
  mmc-core-api-to-temporarily-disable-retuning-for-sdio-crc-errors.patch
  mmc-core-add-sdio_retune_hold_now-and-sdio_retune_release.patch
  mmc-core-prevent-processing-sdio-irqs-when-the-card-is-suspended.patch
  scsi-ufs-avoid-runtime-suspend-possibly-being-blocked-forever.patch
  usb-chipidea-udc-workaround-for-endpoint-conflict-issue.patch
  xhci-detect-usb-3.2-capable-host-controllers-correctly.patch
  usb-xhci-don-t-try-to-recover-an-endpoint-if-port-is-in-error-state.patch
  ib-hfi1-validate-fault-injection-opcode-user-input.patch
  ib-hfi1-silence-txreq-allocation-warnings.patch
  iio-temperature-mlx90632-relax-the-compatibility-check.patch
  input-synaptics-enable-smbus-on-thinkpad-e480-and-e580.patch
  input-uinput-add-compat-ioctl-number-translation-for-ui_-_ff_upload.patch
  input-silead-add-mssl0017-to-acpi_device_id.patch
  apparmor-fix-profile_mediates-for-untrusted-input.patch
  apparmor-enforce-nullbyte-at-end-of-tag-string.patch
  brcmfmac-sdio-disable-auto-tuning-around-commands-expected-to-fail.patch
  brcmfmac-sdio-don-t-tune-while-the-card-is-off.patch
  arc-fix-build-warnings.patch
  dmaengine-dw-axi-dmac-fix-null-dereference-when-poin.patch
  dmaengine-sprd-fix-block-length-overflow.patch
  arc-plat-hsdk-add-missing-multicast-filter-bins-numb.patch
  arc-plat-hsdk-add-missing-fifo-size-entry-in-gmac-no.patch
  fpga-dfl-afu-pass-the-correct-device-to-dma_mapping_.patch
  fpga-dfl-add-lockdep-classes-for-pdata-lock.patch
  parport-fix-mem-leak-in-parport_register_dev_model.patch
  parisc-fix-compiler-warnings-in-float-emulation-code.patch
  ib-rdmavt-fix-alloc_qpn-warn_on.patch
  ib-hfi1-insure-freeze_work-work_struct-is-canceled-o.patch
  ib-qib-hfi1-rdmavt-correct-ibv_devinfo-max_mr-value.patch
  ib-hfi1-validate-page-aligned-for-a-given-virtual-ad.patch
  mips-uprobes-remove-set-but-not-used-variable-epc.patch
  xtensa-fix-section-mismatch-between-memblock_reserve.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-unexpected-testing-failure-on-t.patch
  kselftest-cgroup-fix-incorrect-test_core-skip.patch
  selftests-vm-install-test_vmalloc.sh-for-run_vmtests.patch
  net-dsa-mv88e6xxx-avoid-error-message-on-remove-from.patch
  net-hns-fix-loopback-test-failed-at-copper-ports.patch
  mdesc-fix-a-missing-check-bug-in-get_vdev_port_node_.patch
  sparc-perf-fix-updated-event-period-in-response-to-p.patch
  net-ethernet-mediatek-use-hw_feature-to-judge-if-hwl.patch
  net-ethernet-mediatek-use-net_ip_align-to-judge-if-h.patch
  drm-arm-mali-dp-add-a-loop-around-the-second-set-cva.patch
  drm-arm-hdlcd-actually-validate-crtc-modes.patch
  drm-arm-hdlcd-allow-a-bit-of-clock-tolerance.patch
  nvmet-fix-data_len-to-0-for-bdev-backed-write_zeroes.patch
  scripts-checkstack.pl-fix-arm64-wrong-or-unknown-arc.patch
  scsi-ufs-check-that-space-was-properly-alloced-in-co.patch
  scsi-smartpqi-unlock-on-error-in-pqi_submit_raid_req.patch
  net-ipvlan-fix-ipvlan-device-tso-disabled-while-neti.patch
  s390-qeth-fix-vlan-attribute-in-bridge_hostnotify-ud.patch
  hwmon-core-add-thermal-sensors-only-if-dev-of_node-i.patch
  hwmon-pmbus-core-treat-parameters-as-paged-if-on-mul.patch
  arm64-silence-gcc-warnings-about-arch-abi-drift.patch
  nvme-fix-u32-overflow-in-the-number-of-namespace-lis.patch
  btrfs-start-readahead-also-in-seed-devices.patch
  can-xilinx_can-use-correct-bittiming_const-for-can-fd-core.patch
  can-flexcan-fix-timeout-when-set-small-bitrate.patch
  can-purge-socket-error-queue-on-sock-destruct.patch
  riscv-mm-synchronize-mmu-after-pte-change.patch
  powerpc-bpf-use-unsigned-division-instruction-for-64-bit-operations.patch
  arm-imx-cpuidle-imx6sx-restrict-the-sw2iso-increase-to-i.mx6sx.patch
  arm-dts-dra76x-update-mmc2_hs200_manual1-iodelay-values.patch
  arm-dts-am57xx-idk-remove-support-for-voltage-switching-for-sd-card.patch
  arm64-sve-uapi-asm-ptrace.h-should-not-depend-on-uapi-linux-prctl.h.patch
  arm64-ssbd-explicitly-depend-on-linux-prctl.h.patch
  drm-vmwgfx-use-the-backdoor-port-if-the-hb-port-is-not-available.patch
  staging-erofs-add-requirements-field-in-superblock.patch
  bluetooth-align-minimum-encryption-key-size-for-le-and-br-edr-connections.patch
  bluetooth-fix-regression-with-minimum-encryption-key-size-alignment.patch
  smb3-retry-on-status_insufficient_resources-instead-of-failing-write.patch
  cfg80211-fix-memory-leak-of-wiphy-device-name.patch
  mac80211-drop-robust-management-frames-from-unknown-ta.patch
  nl-mac-80211-allow-4addr-ap-operation-on-crypto-controlled-devices.patch
  mac80211-handle-deauthentication-disassociation-from-tdls-peer.patch
  nl80211-fix-station_info-pertid-memory-leak.patch
  mac80211-do-not-use-stack-memory-with-scatterlist-for-gmac.patch
  x86-resctrl-don-t-stop-walking-closids-when-a-locksetup-group-is-found.patch
  powerpc-mm-64s-hash-reallocate-context-ids-on-fork.patch
  ib-hfi1-avoid-hardlockup-with-flushlist_lock.patch
