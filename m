Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91553F890A
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbhHZNew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 09:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhHZNev (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 09:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 966996103C;
        Thu, 26 Aug 2021 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629984844;
        bh=SOsAIEbNIncIJ1r7i5/YTWDkhnzDXDt8wsiam3KW8EQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bAlyBFZX2wzYR7WkhqWqBXRCISHjM/SHqLNWpYyCDxGqcsmNZSelx2kZ4O+0exV4M
         D/fLyK+eGatBv/ykm+jmcsWPjs1pwbpDAYrQnaOsxmEDcYJoVXjTHYnpkDKUzxCQ7W
         e6j7oknvJ45fR2nkzxUBNgQDAzMuqPYJBhBWNXpPX77nmmRlAVQOlPnlcRJACBd0be
         mLwQW7V98XXV2UVPQcgJg652E7R3HEaJSy0SYCvDd50GPUMHc0WcbPnWE1fdy4cm3I
         1oI9fRYLLAYsKXMo6jB4tgCkdLhpiNnNiUEyHKFAo23SyuQ7kCFUJl2Jk7vhH/Ykcg
         uBWeYc3UewlrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.4.282
Date:   Thu, 26 Aug 2021 09:34:01 -0400
Message-Id: <20210826133402.805077-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.4.282 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                                           |   2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +-
 arch/x86/include/asm/svm.h                         |   2 +
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/tools/chkobjdump.awk                      |   1 +
 drivers/base/core.c                                |   1 +
 drivers/dma/of-dma.c                               |   9 +-
 drivers/dma/sh/usb-dmac.c                          |   2 +-
 drivers/i2c/i2c-dev.c                              |   5 +-
 drivers/ipack/carriers/tpci200.c                   |  36 +++---
 drivers/mmc/host/dw_mmc.c                          |  47 +++++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 +
 drivers/pci/msi.c                                  | 129 +++++++++++++--------
 drivers/scsi/megaraid/megaraid_mm.c                |  21 +++-
 drivers/scsi/scsi_scan.c                           |   3 +-
 drivers/xen/events/events_base.c                   |  20 +++-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/linux/device.h                             |   1 +
 include/linux/msi.h                                |   2 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/dccp/dccp.h                                    |   6 +-
 net/ieee802154/socket.c                            |   7 +-
 sound/pci/hda/hda_generic.c                        |  10 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   3 +-
 25 files changed, 217 insertions(+), 111 deletions(-)

Dave Gerlach (1):
      ARM: dts: am43x-epos-evm: Reduce i2c0 bus speed for tps65218

Dinghao Liu (1):
      net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32

Dongliang Mu (1):
      ipack: tpci200: fix many double free issues in tpci200_pci_probe

Doug Anderson (1):
      mmc: dw_mmc: Wait for data transfer after response errors.

Douglas Anderson (1):
      mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Greg Kroah-Hartman (1):
      i2c: dev: zero out array used for i2c reads from userspace

Harshvardhan Jha (1):
      scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Jaehoon Chung (1):
      mmc: dw_mmc: call the dw_mci_prep_stop_abort() by default

Jaroslav Kysela (1):
      ALSA: hda - fix the 'Capture Switch' value change notifications

Maxim Levitsky (1):
      KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)

Maximilian Heyne (1):
      xen/events: Fix race in set_evtchn_to_irq

Nathan Chancellor (1):
      vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Ole Bjørn Midtbø (1):
      Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Pavel Skripkin (1):
      net: 6pack: fix slab-out-of-bounds in decode_data

Peter Ujfalusi (1):
      dmaengine: of-dma: router_xlate to return -EPROBE_DEFER if controller is not yet available

Randy Dunlap (2):
      x86/tools: Fix objdump version check again
      dccp: add do-while-0 stubs for dccp_pr_debug macros

Sasha Levin (1):
      Linux 4.4.282

Sreekanth Reddy (1):
      scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Takashi Iwai (2):
      ASoC: intel: atom: Fix reference to PCM buffer address
      ASoC: intel: atom: Fix breakage for PCM buffer address setup

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

Thomas Gleixner (8):
      PCI/MSI: Enable and mask MSI-X early
      PCI/MSI: Do not set invalid bits in MSI mask
      PCI/MSI: Correct misleading comments
      PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
      PCI/MSI: Protect msi_desc::masked for multi-MSI
      PCI/MSI: Mask all unused MSI-X entries
      PCI/MSI: Enforce that MSI-X table entry is masked for update
      PCI/MSI: Enforce MSI[X] entry updates to be visible

Vincent Whitchurch (1):
      mmc: dw_mmc: Fix hang on data CRC error

Yu Kuai (1):
      dmaengine: usb-dmac: Fix PM reference leak in usb_dmac_probe()

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmEnlqkACgkQ3qZv95d3
LNyA/Q/+PpMji8LleUymHOzWMgy1yJotUsOB9JEQXfCx7hzZfroVjZZ03HNLM9I3
MLLCAgmLMb1VEmCbE54n4hOQvFNYbTA0KP61BZXmJzkw4HocioFSF/3IXkQhpJCF
BtNGBKsI9lv4M1Cbydi1zk8R1WChuUyWO7YfviXNGr3L68hoIkGFzNM0qvusDMd0
AT2M+yWOuy5vkd64Esf6d3iLaVXG2fy7+BxQQbDBLcytEHemJmiqLKesDQtaQ5UK
r8b1Azfq7/yIaMlC+uNSLujfWTYn8ba9/N5omQqdXEKh5DVxsr3wjn2aoM2PBy6I
MD/vFWoJ7YzVbcv9wyVDVt+ub1nK+hc+krCUpHm0hz5sxT4+vnbLL4JruBnJm7Hl
ifnmxH4BXlae5ol+J/O2gC3KbKLk+N0NDWr/mDFWREcKPvWwQTDG1nrEeMoc/3Q+
KCkff6fjeukGXDPIoxTXIluAap41gdZjL9nZRmYeT37Jxf3x8wh68IplsAzhDZjF
/Yd/FGM4+ksibDhd0qfB6iJK+T6mlTUMkYUMZXe0P2OZAGUdh4k/qreJydrVGSFk
quE3CXhN5+uyd6eUnItXpFHM77nSCuOlUNR6+UpnU7u2HsmT1aboI71sEbwlUtDG
KUtyUu+t7EsG5NVFyiBgKnd08/gTvF89MNvgHyiPj6zullas64M=
=9XIW
-----END PGP SIGNATURE-----
