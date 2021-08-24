Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A13F6791
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhHXRgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240885AbhHXRcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:32:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D573C611C8;
        Tue, 24 Aug 2021 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824776;
        bh=/W79Um/9f+MCSubtCw4OsPTPZBj5y29vQqttExpd5b8=;
        h=From:To:Cc:Subject:Date:From;
        b=FcPwoC6UjXvMI357FpAddjiPxwZMMSH0xEi3Wu0Kxr14zamIY5lN433YQP9BLtnss
         +hMEBl7MMC9aMBBfrlGzGZp3RL9PhRcOPAs2C0NVQboD6dbeC9pwYeUQQnQTSbe2NR
         SNbqfiUyz/CSaJU2MmJEeMeuIlw1I76porAkMWaT/B5OCncygqSV/m8LB5isxOkbRY
         W98B5xM/4jZ3GehnDA8260srZUaWLbiZPhVvvQ4wkgieWHhc6iMuQEHLVLy/BAFBk3
         gp6r6IRkh1MWUFO0+8WXj84+VGU1Rfgdq81uAm3As9AF71OwbInAJeosw4XOb8XE0M
         ikFInFIc8ffYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 4.9 00/43] 4.9.281-rc1 review
Date:   Tue, 24 Aug 2021 13:05:31 -0400
Message-Id: <20210824170614.710813-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.9.281 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 26 Aug 2021 05:06:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.9.y&id2=v4.9.280
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Colin Ian King (1):
  iio: adc: Fix incorrect exit of for-loop

Dan Williams (1):
  ACPI: NFIT: Fix support for virtual SPA ranges

Dave Gerlach (1):
  ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
  net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dongliang Mu (1):
  ipack: tpci200: fix many double free issues in tpci200_pci_probe

Greg Kroah-Hartman (1):
  i2c: dev: zero out array used for i2c reads from userspace

Harshvardhan Jha (1):
  scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Jaehoon Chung (1):
  mmc: dw_mmc: call the dw_mci_prep_stop_abort() by default

Jaroslav Kysela (1):
  ALSA: hda - fix the 'Capture Switch' value change notifications

Jeff Layton (2):
  locks: print a warning when mount fails due to lack of "mand" support
  fs: warn about impending deprecation of mandatory locks

Johannes Berg (1):
  mac80211: drop data frames without key on encrypted links

Maxim Levitsky (1):
  KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl
    (CVE-2021-3653)

Maximilian Heyne (1):
  xen/events: Fix race in set_evtchn_to_irq

Nathan Chancellor (1):
  vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
  tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B
    packets

NeilBrown (1):
  btrfs: prevent rename2 from exchanging a subvol with a directory from
    different parents

Ole Bjørn Midtbø (1):
  Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Pali Rohár (1):
  ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pavel Skripkin (1):
  net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
  dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller
    is not yet available

Randy Dunlap (2):
  x86/tools: Fix objdump version check again
  dccp: add do-while-0 stubs for dccp_pr_debug macros

Sasha Levin (1):
  Linux 4.9.281-rc1

Sreekanth Reddy (1):
  scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Sudeep Holla (1):
  ARM: dts: nomadik: Fix up interrupt controller node names

Takashi Iwai (2):
  ASoC: intel: atom: Fix reference to PCM buffer address
  ASoC: intel: atom: Fix breakage for PCM buffer address setup

Takeshi Misawa (1):
  net: Fix memory leak in ieee802154_raw_deliver

Thomas Gleixner (9):
  PCI/MSI: Enable and mask MSI-X early
  PCI/MSI: Do not set invalid bits in MSI mask
  PCI/MSI: Correct misleading comments
  PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
  PCI/MSI: Protect msi_desc::masked for multi-MSI
  PCI/MSI: Mask all unused MSI-X entries
  PCI/MSI: Enforce that MSI-X table entry is masked for update
  PCI/MSI: Enforce MSI[X] entry updates to be visible
  x86/fpu: Make init_fpstate correct with optimized XSAVE

Vincent Whitchurch (1):
  mmc: dw_mmc: Fix hang on data CRC error

Xie Yongji (1):
  vhost: Fix the calculation in vhost_overflow()

Yang Yingliang (1):
  net: bridge: fix memleak in br_add_if()

Ye Bin (1):
  scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

Yu Kuai (1):
  dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

 .../filesystems/mandatory-locking.txt         |  10 ++
 Makefile                                      |   4 +-
 arch/arm/boot/dts/am43x-epos-evm.dts          |   2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi    |   4 +-
 arch/x86/include/asm/fpu/internal.h           |  30 ++---
 arch/x86/include/asm/svm.h                    |   2 +
 arch/x86/kernel/fpu/xstate.c                  |  38 +++++-
 arch/x86/kvm/svm.c                            |   6 +-
 arch/x86/tools/chkobjdump.awk                 |   1 +
 drivers/acpi/nfit/core.c                      |   3 +
 drivers/base/core.c                           |   1 +
 drivers/dma/of-dma.c                          |   9 +-
 drivers/dma/sh/usb-dmac.c                     |   2 +-
 drivers/i2c/i2c-dev.c                         |   5 +-
 drivers/iio/adc/palmas_gpadc.c                |   4 +-
 drivers/ipack/carriers/tpci200.c              |  36 +++---
 drivers/mmc/host/dw_mmc.c                     |  21 ++--
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |   4 +-
 drivers/net/hamradio/6pack.c                  |   6 +
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/pci/msi.c                             | 119 ++++++++++++------
 drivers/scsi/device_handler/scsi_dh_rdac.c    |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c           |  21 +++-
 drivers/scsi/scsi_scan.c                      |   3 +-
 drivers/vhost/vhost.c                         |  10 +-
 drivers/xen/events/events_base.c              |  20 ++-
 fs/btrfs/inode.c                              |  10 +-
 fs/namespace.c                                |  15 ++-
 include/asm-generic/vmlinux.lds.h             |   1 +
 include/linux/device.h                        |   1 +
 include/linux/msi.h                           |   2 +-
 net/bluetooth/hidp/core.c                     |   2 +-
 net/bridge/br_if.c                            |   2 +
 net/dccp/dccp.h                               |   6 +-
 net/ieee802154/socket.c                       |   7 +-
 net/ipv4/tcp_bbr.c                            |   2 +-
 net/mac80211/debugfs_sta.c                    |   1 +
 net/mac80211/key.c                            |   1 +
 net/mac80211/sta_info.h                       |   1 +
 net/mac80211/tx.c                             |  12 +-
 sound/pci/hda/hda_generic.c                   |  10 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c  |   3 +-
 42 files changed, 294 insertions(+), 149 deletions(-)

-- 
2.30.2

