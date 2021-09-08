Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF90B4034BD
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 09:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbhIHHHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 03:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhIHHHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 03:07:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C1786113D;
        Wed,  8 Sep 2021 07:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631084801;
        bh=bzENUDQvlhOu/9k9BEnztyqzOCg+TmfEpoBVF7KGxVo=;
        h=From:To:Cc:Subject:Date:From;
        b=Sbt9fkrxZpSg1eifWll6Kzj48gxpeeq0nUVd5/3gjG6AA/mSfrmcPLfkQ76Fcb0j1
         a4P+jRoaWWzkJ0YMqbTCRpJRtj03l0ffjaB7zLhbmXROxJVCN+b8TEXCImpkc9Tj1I
         Q0O8KQZCxZx5p0OKzb3l4BqWo+O/LV1acY5eIsms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.15
Date:   Wed,  8 Sep 2021 09:06:35 +0200
Message-Id: <163108479524870@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.15 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts |    4 +
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi           |    2 
 arch/x86/events/amd/ibs.c                                   |    8 +++
 arch/x86/events/amd/power.c                                 |    1 
 arch/x86/events/intel/pt.c                                  |    2 
 arch/xtensa/Kconfig                                         |    2 
 drivers/block/Kconfig                                       |    4 -
 drivers/block/cryptoloop.c                                  |    2 
 drivers/gpu/ipu-v3/ipu-cpmem.c                              |   30 ++++++------
 drivers/media/usb/stkwebcam/stk-webcam.c                    |    6 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                          |   11 ++--
 drivers/net/ethernet/cadence/macb_ptp.c                     |   11 ++++
 drivers/net/ethernet/qlogic/qed/qed_main.c                  |    7 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c                |    2 
 drivers/reset/reset-zynqmp.c                                |    3 -
 drivers/usb/serial/cp210x.c                                 |   21 +++++---
 drivers/usb/serial/pl2303.c                                 |    1 
 fs/ceph/mdsmap.c                                            |    8 ++-
 fs/ext4/inline.c                                            |    6 ++
 fs/ext4/super.c                                             |    8 +++
 sound/core/pcm_lib.c                                        |    2 
 sound/pci/hda/patch_realtek.c                               |   11 ++++
 sound/usb/endpoint.c                                        |    5 ++
 24 files changed, 115 insertions(+), 44 deletions(-)

Bin Meng (2):
      riscv: dts: microchip: Use 'local-mac-address' for emac1
      riscv: dts: microchip: Add ethernet0 to the aliases node

Christoph Hellwig (1):
      cryptoloop: add a deprecation warning

Greg Kroah-Hartman (1):
      Linux 5.13.15

Harini Katakam (1):
      net: macb: Add a NULL check on desc_ptp

Jan Kara (1):
      ext4: fix e2fsprogs checksum failure for mounted filesystem

Johan Hovold (2):
      USB: serial: cp210x: fix control-characters error handling
      USB: serial: cp210x: fix flow-control error handling

Johnathon Clark (1):
      ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Kim Phillips (2):
      perf/x86/amd/ibs: Work around erratum #1197
      perf/x86/amd/power: Assign pmu.module

Krzysztof Hałasa (1):
      gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Nathan Rossi (1):
      net: dsa: mv88e6xxx: Update mv88e6393x serdes errata

Pavel Skripkin (1):
      media: stkwebcam: fix memory leak in stk_camera_probe

Randy Dunlap (1):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Robert Marko (1):
      USB: serial: pl2303: fix GL type detection

Sai Krishna Potthuri (1):
      reset: reset-zynqmp: Fixed the argument data type

Shai Malin (2):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption

Takashi Iwai (2):
      ALSA: usb-audio: Fix regression on Sony WALKMAN NW-A45 DAC
      ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Tuo Li (1):
      ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()

Xiaoyao Li (1):
      perf/x86/intel/pt: Fix mask of num_address_ranges

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

