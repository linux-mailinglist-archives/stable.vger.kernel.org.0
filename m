Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C82443611
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 19:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhKBSzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 14:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhKBSzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 14:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB6E6008E;
        Tue,  2 Nov 2021 18:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635879200;
        bh=3Rw8Y2li1jO3ftpGHL2PI78vpcLtn1ikB0xqAMipXLo=;
        h=From:To:Cc:Subject:Date:From;
        b=zaNEXDbhPlk06/Kw4YZdAajDrqr5E3UWSqJNil8dghBpM15k1t010U32/rmetXIHJ
         3tJpDZNCL21ye4Jg5HqWfaJJ2VnzWfoYrYILt9u3H+j1plehFdkziSpxzB0afMS7tB
         CJkSFCI5IsIag1FzgBUB+itPeEt7KhQIb7kMPEqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.291
Date:   Tue,  2 Nov 2021 19:53:16 +0100
Message-Id: <163587919642151@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.291 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 arch/arm/Makefile                     |    2 +-
 arch/arm/boot/bootp/Makefile          |    2 +-
 arch/arm/boot/compressed/Makefile     |    2 --
 arch/arm/boot/compressed/decompress.c |    3 +++
 arch/arm/mm/proc-macros.S             |    1 +
 arch/arm/probes/kprobes/core.c        |    2 +-
 arch/nios2/platform/Kconfig.platform  |    1 +
 drivers/ata/sata_mv.c                 |    4 ++--
 drivers/base/regmap/regcache-rbtree.c |    7 +++----
 drivers/mmc/host/dw_mmc-exynos.c      |   14 ++++++++++++++
 drivers/mmc/host/sdhci.c              |    6 ++++++
 drivers/mmc/host/vub300.c             |   18 +++++++++---------
 drivers/net/phy/mdio_bus.c            |    1 -
 drivers/net/usb/lan78xx.c             |    6 ++++++
 drivers/net/usb/usbnet.c              |    5 +++++
 drivers/nfc/port100.c                 |    4 ++--
 net/sctp/sm_statefuns.c               |    4 ++++
 18 files changed, 60 insertions(+), 24 deletions(-)

Arnd Bergmann (2):
      ARM: 9134/1: remove duplicate memcpy() definition
      ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype

Greg Kroah-Hartman (1):
      Linux 4.4.291

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

Nick Desaulniers (1):
      ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Pavel Skripkin (1):
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"

Shawn Guo (1):
      mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Xin Long (2):
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: add vtag check in sctp_sf_violation

Yang Yingliang (1):
      regmap: Fix possible double-free in regcache_rbtree_exit()

Zheyu Ma (1):
      ata: sata_mv: Fix the error handling of mv_chip_id()

