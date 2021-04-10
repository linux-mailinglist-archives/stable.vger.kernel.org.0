Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE59435ACF9
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhDJLgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhDJLgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00131610D1;
        Sat, 10 Apr 2021 11:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618054569;
        bh=P8TBfIEEAeMD2aLZUl+lRrtTFwG2hhGynffgruWVdzg=;
        h=From:To:Cc:Subject:Date:From;
        b=I7vh51YhmB2zdxtaHKzi6Llh3QgAo+2UBal1djpjfu5wH7OAekbT98ne0vysBY6VV
         Xlz9sUaktxfJtS/tXJbaCr208hzuS5wniwCMcPA5uE/tfEDQQfVWSJNQwdVU4nwnjI
         2Mwzc6iQrJNfDYU35yIpz34+zR3VNlz7yyVqK/3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.230
Date:   Sat, 10 Apr 2021 13:36:05 +0200
Message-Id: <16180545661866@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.230 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/arm/boot/dts/am33xx.dtsi             |    3 +++
 arch/ia64/kernel/mca.c                    |    2 +-
 arch/x86/Makefile                         |    2 +-
 arch/x86/net/bpf_jit_comp.c               |   11 ++++++++++-
 drivers/gpu/drm/msm/msm_fence.c           |    2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c   |    2 +-
 drivers/net/can/flexcan.c                 |    8 +++++++-
 drivers/net/ethernet/marvell/pxa168_eth.c |    2 +-
 drivers/platform/x86/thinkpad_acpi.c      |    8 +++++++-
 drivers/target/target_core_pscsi.c        |    8 ++++++++
 fs/cifs/file.c                            |    1 +
 fs/cifs/smb2misc.c                        |    4 ++--
 init/Kconfig                              |    3 +--
 net/mac80211/main.c                       |   13 ++++++++++++-
 15 files changed, 57 insertions(+), 14 deletions(-)

Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Arnd Bergmann (1):
      x86/build: Turn off -fcf-protection for realmode targets

Esteve Varela Colominas (1):
      platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Greg Kroah-Hartman (1):
      Linux 4.14.230

Heiko Carstens (1):
      init/Kconfig: make COMPILE_TEST depend on !S390

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Mans Rullgard (1):
      ARM: dts: am33xx: add aliases for mmc interfaces

Martin Wilck (1):
      scsi: target: pscsi: Clean up after failure in pscsi_map_sg()

Masahiro Yamada (1):
      init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Pavel Andrianov (1):
      net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Piotr Krysiuk (1):
      bpf, x86: Validate computation of branch displacements for x86-64

Rob Clark (1):
      drm/msm: Ratelimit invalid-fence message

Ronnie Sahlberg (1):
      cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich (1):
      ia64: mca: allocate early mca with GFP_ATOMIC

Tong Zhang (1):
      mISDN: fix crash in fritzpci

Vincent Whitchurch (1):
      cifs: Silently ignore unknown oplock break handle

