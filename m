Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A13EC8F7
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhHOMaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhHOM37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEC461103;
        Sun, 15 Aug 2021 12:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629030569;
        bh=TE+Gsh1f6uw1iAn/gQzFKqxIVRppMlymvuhQqv4+ILM=;
        h=From:To:Cc:Subject:Date:From;
        b=whNPnvGkIgBBRGlR9SXkvfEk5SZZug0xonBaCu3PJTETnJZjITRacxZRF5b8JRMTq
         +LqQWJ7ee0X7h7kJgGlyH3/KKIz2lEIUyZU0WNIUFyWIY3L0FAc+NTIm9DyK1Rtcmi
         TorADqVol9sDRa5Jhz9DtOjw1RdAywmiSkSYAD3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.59
Date:   Sun, 15 Aug 2021 14:29:25 +0200
Message-Id: <1629030565149238@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.59 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi |    4 -
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi       |    6 +
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi                 |   15 ++++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi                 |   15 ++++
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi                 |   15 ++++
 arch/x86/kvm/svm/sev.c                                    |    2 
 drivers/firmware/broadcom/tee_bnxt_fw.c                   |   14 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c             |    5 -
 drivers/net/ppp/ppp_generic.c                             |   19 ++++-
 drivers/tee/optee/call.c                                  |    2 
 drivers/tee/optee/core.c                                  |    3 
 drivers/tee/optee/rpc.c                                   |    5 -
 drivers/tee/optee/shm_pool.c                              |    8 +-
 drivers/tee/tee_shm.c                                     |    4 -
 drivers/usb/host/ehci-pci.c                               |    3 
 fs/namespace.c                                            |   42 +++++++----
 fs/vboxsf/dir.c                                           |   28 ++++---
 include/linux/mmzone.h                                    |    4 -
 include/linux/security.h                                  |    1 
 include/linux/tee_drv.h                                   |    1 
 kernel/trace/bpf_trace.c                                  |    5 -
 security/security.c                                       |    1 
 sound/core/pcm_native.c                                   |    5 +
 sound/pci/hda/patch_realtek.c                             |    2 
 tools/testing/selftests/resctrl/resctrl.h                 |    6 -
 tools/testing/selftests/resctrl/resctrlfs.c               |   52 ++------------
 27 files changed, 169 insertions(+), 100 deletions(-)

Adam Ford (3):
      arm64: dts: renesas: rzg2: Add usb2_clksel to RZ/G2 M/N/H
      arm64: dts: renesas: beacon: Fix USB extal reference
      arm64: dts: renesas: beacon: Fix USB ref clock references

Allen Pais (1):
      firmware: tee_bnxt: Release TEE shm, session, and context during kexec

Daniel Borkmann (1):
      bpf: Add lockdown check for probe_write_user helper

Greg Kroah-Hartman (1):
      Linux 5.10.59

Hans de Goede (2):
      vboxsf: Honor excl flag to the dir-inode create op
      vboxsf: Make vboxsf_dir_create() return the handle for the created file

Jeremy Szu (1):
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 650 G8 Notebook PC

Longfang Liu (1):
      USB:ehci:fix Kunpeng920 ehci hardware problem

Luke D Jones (1):
      ALSA: hda: Add quirk for ASUS Flow x13

Mike Rapoport (1):
      mm: make zone_to_nid() and zone_set_nid() available for DISCONTIGMEM

Miklos Szeredi (1):
      ovl: prevent private clone if bind mount is not allowed

Pali Rohár (1):
      ppp: Fix generating ppp unit id when ifname is not specified

Reinette Chatre (1):
      Revert "selftests/resctrl: Use resctrl/info for feature detection"

Sean Christopherson (1):
      KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB

Sumit Garg (1):
      tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Takashi Iwai (1):
      ALSA: pcm: Fix mmap breakage without explicit buffer setup

YueHaibing (1):
      net: xilinx_emaclite: Do not print real IOMEM pointer

