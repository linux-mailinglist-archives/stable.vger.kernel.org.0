Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66963F88EA
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbhHZN2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242749AbhHZN1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E8C9610A7;
        Thu, 26 Aug 2021 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984420;
        bh=cxTDwCt87GozSMGJ5OwtHxQAqfCRmKwSXHJztgLfUTU=;
        h=From:To:Cc:Subject:Date:From;
        b=fgW1m3Z3tYBViDXdpkhULjAO1F+k1L0OEN9FgxPeE5YdHxjcA0ft5Dad9WGuS1M9D
         D505mjjZh+gjV3TRkf1TgW9kp1IKL0Jf68mp7xonQNs2Xxpc/NRUzYtqSvOlHdB1Zk
         O82W9AeF0sSTMHP4YJGDRHTSVSKwxTOL0w0j0U3TzkZA4IuMcc8id6/5waJAQ9VTcA
         cT0rlu02iJpwqqV9c+/jGGOf1UxiG1RRgtbshFYbUHFhacmrf7xOtEqhRHA0oI57UG
         /bCeTcHpCsME4k2STbpoEc6t1pyOmVGQCV6fSgcDTtdgO49gmAaYdEuNaBtHRVwlX9
         5rMV4axO3zr1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.9.281
Date:   Thu, 26 Aug 2021 09:26:57 -0400
Message-Id: <20210826132658.804987-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.9.281 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Documentation/filesystems/mandatory-locking.txt    |  10 ++
 Makefile                                           |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +-
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi         |   4 +-
 arch/x86/include/asm/fpu/internal.h                |  30 ++----
 arch/x86/include/asm/svm.h                         |   2 +
 arch/x86/kernel/fpu/xstate.c                       |  38 ++++++-
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/tools/chkobjdump.awk                      |   1 +
 drivers/acpi/nfit/core.c                           |   3 +
 drivers/base/core.c                                |   1 +
 drivers/dma/of-dma.c                               |   9 +-
 drivers/dma/sh/usb-dmac.c                          |   2 +-
 drivers/i2c/i2c-dev.c                              |   5 +-
 drivers/iio/adc/palmas_gpadc.c                     |   4 +-
 drivers/ipack/carriers/tpci200.c                   |  36 +++----
 drivers/mmc/host/dw_mmc.c                          |  21 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 ++
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/pci/msi.c                                  | 119 ++++++++++++++-------
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   4 +-
 drivers/scsi/megaraid/megaraid_mm.c                |  21 ++--
 drivers/scsi/scsi_scan.c                           |   3 +-
 drivers/vhost/vhost.c                              |  10 +-
 drivers/xen/events/events_base.c                   |  20 ++--
 fs/btrfs/inode.c                                   |  10 +-
 fs/namespace.c                                     |  15 ++-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/device.h                             |   1 +
 include/linux/msi.h                                |   2 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/bridge/br_if.c                                 |   2 +
 net/dccp/dccp.h                                    |   6 +-
 net/ieee802154/socket.c                            |   7 +-
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/mac80211/debugfs_sta.c                         |   1 +
 net/mac80211/key.c                                 |   1 +
 net/mac80211/sta_info.h                            |   1 +
 net/mac80211/tx.c                                  |  12 ++-
 sound/pci/hda/hda_generic.c                        |  10 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   3 +-
 42 files changed, 293 insertions(+), 148 deletions(-)

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
      KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)

Maximilian Heyne (1):
      xen/events: Fix race in set_evtchn_to_irq

Nathan Chancellor (1):
      vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
      tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

NeilBrown (1):
      btrfs: prevent rename2 from exchanging a subvol with a directory from different parents

Ole Bjørn Midtbø (1):
      Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Pali Rohár (1):
      ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pavel Skripkin (1):
      net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
      dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available

Randy Dunlap (2):
      x86/tools: Fix objdump version check again
      dccp: add do-while-0 stubs for dccp_pr_debug macros

Sasha Levin (1):
      Linux 4.9.281

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

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmEnlqAACgkQ3qZv95d3
LNyrGw//dYQ+y353RRN7xKcTSf/ve8SLx8+uhMlXvha5t3t513IaUdIpmSoXA3O8
lvHADGbeLJC2wkSst35ZF3biWTZwlV5UF5BKwUEn+nY2n0qHzAnZMq45WqMD0uZD
V2EGTXHD59dbYtSzME4AgRpa+PNP42AEVE2vRrI8dcbSyRYxovuQuogDjXBMOIZA
05Iug+TrgG73+CpI4CnjLb+uB5WzdM/sJHhmclOCPIdVey9Lu6ha6owSs68Cbxa4
dO58TjG7/FS5E5dsvobFGklgYJOTrOUgOS186X00S6VSf5dOlCI7D2k8eZvWYsua
9NtK00gQhaAPVQkd4IQCSTC5zY+J3Kyd4Eh2UReZSD0kb0C6mzOGWzUXEemyVuGR
5y0r6QLmowteBpJKo+7xXr3OoxV6eZAvCSTNpRS5xeIpqmWwrcKQV4DlcdCqXsWy
Zzh0ez8jTIs6Zo2I938Kpu1n0JB/bLy2RkoOzjLvbEV4SogThviHFwCPWlwEfDj6
J6pLR44o8+OCFR27aydUtOAexXw4z6eiiQQgJEeQmTuWSNxDCpVOlzLuiYEX6bGX
lj9Exs61msoDEEJk3idlpAj2P7fa3ocd3nk6gGENciDqHZfrbFVL0DUnhQH+/wN6
2XXHih7PWPmaonfSI0IkGitCY+LL5okBd2td+AoU3UhQZGD+YyQ=
=LEIH
-----END PGP SIGNATURE-----
