Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB813F66E2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbhHXR2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240217AbhHXR0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:26:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20F5861368;
        Tue, 24 Aug 2021 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824699;
        bh=26U9I56H9tFgpd0IPK42tFnNrGrg7F5XEZjja1lGlh0=;
        h=From:To:Cc:Subject:Date:From;
        b=lrezFavmgiB83DtWsDf+7qx65Bl7fyfBop3DyWaI6KzaXXP1HGO5NaUAmKlTH2+la
         SLxwi/pj5MTUpBY7bo1RbD+Y7uzCtLZFLXiCGyOCJYY8TtFKvMWj35lDeP6fk6d0gD
         DUi9MN8hJ4Gi5Bd38MVZrtBduUwaLv8sh+XWWjzCqUOlXgwO3VYt/lVFOD7jlWpdBY
         3tkUX2aLa7sm/TCvI1Kir+RnyVuHaHqrN7FHh5rM/kfNJ2hQhO5kyNgM/j8llCBwLt
         +3vFc6YfN861Lyl9J+JZXieVWzctiXdEqUfuwEULwuaZAM7g8xUWeR7ElzHL2IHrip
         CW73cBQ6KyEGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de
Subject: [PATCH 4.14 00/64] 4.14.245-rc1 review
Date:   Tue, 24 Aug 2021 13:03:53 -0400
Message-Id: <20210824170457.710623-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.14.245 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu 26 Aug 2021 05:04:55 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.244
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Andy Shevchenko (1):
  ptp_pch: Restore dependency on PCI

Babu Moger (1):
  x86/resctrl: Fix default monitoring groups reporting

Chris Lesiak (1):
  iio: humidity: hdc100x: Add margin to the conversion time

Colin Ian King (1):
  iio: adc: Fix incorrect exit of for-loop

DENG Qingfang (1):
  net: dsa: mt7530: add the missing RxUnicast MIB counter

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

Ivan T. Ivanov (1):
  net: usb: lan78xx: don't modify phy_device state concurrently

Jakub Kicinski (1):
  bnxt: don't lock the tx queue from napi poll

Jaroslav Kysela (1):
  ALSA: hda - fix the 'Capture Switch' value change notifications

Jeff Layton (2):
  locks: print a warning when mount fails due to lack of "mand" support
  fs: warn about impending deprecation of mandatory locks

Johannes Berg (1):
  mac80211: drop data frames without key on encrypted links

Jouni Malinen (5):
  ath: Use safer key clearing with key cache entries
  ath9k: Clear key cache explicitly on disabling hardware
  ath: Export ath_hw_keysetmac()
  ath: Modify ath_key_delete() to not need full key entry
  ath9k: Postpone key cache entry deletion for TXQ frames reference it

Longpeng(Mike) (1):
  vsock/virtio: avoid potential deadlock when vsock device remove

Maxim Levitsky (2):
  KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
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

Pu Lehui (1):
  powerpc/kprobes: Fix kprobe Oops happens in booke

Randy Dunlap (2):
  x86/tools: Fix objdump version check again
  dccp: add do-while-0 stubs for dccp_pr_debug macros

Richard Fitzgerald (4):
  ASoC: cs42l42: Correct definition of ADC Volume control
  ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
  ASoC: cs42l42: Fix inversion of ADC Notch Switch control
  ASoC: cs42l42: Remove duplicate control for WNF filter frequency

Roi Dayan (1):
  psample: Add a fwd declaration for skbuff

Saravana Kannan (2):
  net: mdio-mux: Don't ignore memory allocation errors
  net: mdio-mux: Handle -EPROBE_DEFER correctly

Sasha Levin (1):
  Linux 4.14.245-rc1

Sergey Marinkevich (1):
  netfilter: nft_exthdr: fix endianness of tcp option cast

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
 arch/powerpc/kernel/kprobes.c                 |   3 +-
 arch/x86/include/asm/fpu/internal.h           |  30 ++---
 arch/x86/include/asm/svm.h                    |   2 +
 arch/x86/kernel/cpu/intel_rdt_monitor.c       |  27 ++--
 arch/x86/kernel/fpu/xstate.c                  |  38 +++++-
 arch/x86/kvm/svm.c                            |  18 ++-
 arch/x86/tools/chkobjdump.awk                 |   1 +
 drivers/acpi/nfit/core.c                      |   3 +
 drivers/base/core.c                           |   1 +
 drivers/dma/of-dma.c                          |   9 +-
 drivers/dma/sh/usb-dmac.c                     |   2 +-
 drivers/i2c/i2c-dev.c                         |   5 +-
 drivers/iio/adc/palmas_gpadc.c                |   4 +-
 drivers/iio/humidity/hdc100x.c                |   6 +-
 drivers/ipack/carriers/tpci200.c              |  36 +++---
 drivers/mmc/host/dw_mmc.c                     |   6 +-
 drivers/net/dsa/mt7530.c                      |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  54 ++++----
 .../ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c   |   4 +-
 drivers/net/hamradio/6pack.c                  |   6 +
 drivers/net/phy/mdio-mux.c                    |  36 ++++--
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/net/usb/lan78xx.c                     |  16 ++-
 drivers/net/wireless/ath/ath.h                |   3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   1 +
 drivers/net/wireless/ath/ath9k/main.c         |  95 +++++++++++++-
 drivers/net/wireless/ath/key.c                |  41 +++---
 drivers/pci/msi.c                             | 120 ++++++++++++------
 drivers/ptp/Kconfig                           |   3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c    |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c           |  21 ++-
 drivers/scsi/scsi_scan.c                      |   3 +-
 drivers/vhost/vhost.c                         |  10 +-
 drivers/xen/events/events_base.c              |  20 ++-
 fs/btrfs/inode.c                              |  10 +-
 fs/namespace.c                                |  15 ++-
 include/asm-generic/vmlinux.lds.h             |   1 +
 include/linux/device.h                        |   1 +
 include/linux/msi.h                           |   2 +-
 include/net/psample.h                         |   2 +
 net/bluetooth/hidp/core.c                     |   2 +-
 net/bridge/br_if.c                            |   2 +
 net/dccp/dccp.h                               |   6 +-
 net/ieee802154/socket.c                       |   7 +-
 net/ipv4/tcp_bbr.c                            |   2 +-
 net/mac80211/debugfs_sta.c                    |   1 +
 net/mac80211/key.c                            |   1 +
 net/mac80211/sta_info.h                       |   1 +
 net/mac80211/tx.c                             |  12 +-
 net/netfilter/nft_exthdr.c                    |   8 +-
 net/vmw_vsock/virtio_transport.c              |   7 +-
 sound/pci/hda/hda_generic.c                   |  10 +-
 sound/soc/codecs/cs42l42.c                    |  18 +--
 sound/soc/intel/atom/sst-mfld-platform-pcm.c  |   3 +-
 60 files changed, 520 insertions(+), 246 deletions(-)

-- 
2.30.2

