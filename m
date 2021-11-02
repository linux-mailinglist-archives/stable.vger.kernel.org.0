Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769E2443615
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 19:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhKBS4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 14:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhKBS4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 14:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5C8361051;
        Tue,  2 Nov 2021 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635879207;
        bh=1XczaIOPgVW9lY4JrVWz8mTOelnUiG0gkj8dLD/CWq0=;
        h=From:To:Cc:Subject:Date:From;
        b=C7PV/aQwDoqV7aQw6mgm7NGwT6OeL4BpDaUGAeox2K40++razTEpwLtrOIekiG1SM
         +9wW7nen8dV6jm8KWOcFzbqZUZ4Hh+GiLMJ5yQzEy4BPdJb6PclbIy8Px0xWsiAUfc
         3Oy1Ok1yQ7cthmfSpjSXm2yBR26UUAv6Mm9MV9Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.289
Date:   Tue,  2 Nov 2021 19:53:20 +0100
Message-Id: <1635879201112202@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.289 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 -
 arch/arm/Makefile                      |    2 -
 arch/arm/boot/bootp/Makefile           |    2 -
 arch/arm/boot/compressed/Makefile      |    2 -
 arch/arm/boot/compressed/decompress.c  |    3 +
 arch/arm/mm/proc-macros.S              |    1 
 arch/arm/probes/kprobes/core.c         |    2 -
 arch/nios2/platform/Kconfig.platform   |    1 
 arch/powerpc/net/bpf_jit_comp64.c      |   10 ++++-
 drivers/ata/sata_mv.c                  |    4 +-
 drivers/base/regmap/regcache-rbtree.c  |    7 +---
 drivers/mmc/host/dw_mmc-exynos.c       |   14 ++++++++
 drivers/mmc/host/sdhci.c               |    6 +++
 drivers/mmc/host/vub300.c              |   18 +++++-----
 drivers/net/ethernet/nxp/lpc_eth.c     |    5 +-
 drivers/net/phy/mdio_bus.c             |    1 
 drivers/net/usb/lan78xx.c              |    6 +++
 drivers/net/usb/usbnet.c               |    5 ++
 drivers/nfc/port100.c                  |    4 +-
 net/batman-adv/bridge_loop_avoidance.c |    8 +++-
 net/batman-adv/main.c                  |   56 +++++++++++++++++++++++----------
 net/batman-adv/network-coding.c        |    4 +-
 net/batman-adv/translation-table.c     |    4 +-
 net/sctp/sm_statefuns.c                |    4 ++
 24 files changed, 122 insertions(+), 49 deletions(-)

Arnd Bergmann (2):
      ARM: 9134/1: remove duplicate memcpy() definition
      ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype

Greg Kroah-Hartman (1):
      Linux 4.9.289

Guenter Roeck (1):
      nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Jaehoon Chung (1):
      mmc: dw_mmc: exynos: fix the finding clock sample value

Johan Hovold (2):
      mmc: vub300: fix control-message timeouts
      net: lan78xx: fix division by zero in send path

Krzysztof Kozlowski (1):
      nfc: port100: fix using -ERRNO as command type mask

Nathan Chancellor (1):
      ARM: 8819/1: Remove '-p' from LDFLAGS

Naveen N. Rao (1):
      powerpc/bpf: Fix BPF_MOD when imm == 1

Nick Desaulniers (1):
      ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Pavel Skripkin (2):
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
      net: batman-adv: fix error handling

Shawn Guo (1):
      mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Trevor Woerner (1):
      net: nxp: lpc_eth.c: avoid hang when bringing interface down

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Xin Long (2):
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: add vtag check in sctp_sf_violation

Yang Yingliang (1):
      regmap: Fix possible double-free in regcache_rbtree_exit()

Zheyu Ma (1):
      ata: sata_mv: Fix the error handling of mv_chip_id()

