Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0449F35ACE1
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDJLUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234091AbhDJLUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A33EC610C8;
        Sat, 10 Apr 2021 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618053595;
        bh=9n5C4KlXRWHxif3VrWOJum6JBwXrOuB1kxeIQPXtKVM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZePvQyzNGKXvpz0uXpRTG27j3epNqlp5qnBFkZZKVo1D8Nfak1bc6GiRXSc7HF4o7
         EDyksT4T5JS5UetZ6goaiJAcOnT989n3vMH7Ukr2d8xEVS8B3SitowShmhxt+qJ+Zc
         xUPfSH5GuM2I6MM/h4GB8YJJMAraRPaGJo5RVZkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.266
Date:   Sat, 10 Apr 2021 13:19:51 +0200
Message-Id: <161805359112471@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.266 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/ia64/kernel/mca.c                    |    2 +-
 arch/x86/Makefile                         |    2 +-
 arch/x86/net/bpf_jit_comp.c               |   11 ++++++++++-
 drivers/isdn/hardware/mISDN/mISDNipac.c   |    2 +-
 drivers/mtd/nand/diskonchip.c             |    7 ++-----
 drivers/mtd/nand/orion_nand.c             |    2 +-
 drivers/mtd/nand/pasemi_nand.c            |    4 +++-
 drivers/mtd/nand/plat_nand.c              |    2 +-
 drivers/mtd/nand/sharpsl.c                |    2 +-
 drivers/mtd/nand/socrates_nand.c          |    2 +-
 drivers/mtd/nand/tmio_nand.c              |    2 +-
 drivers/net/can/flexcan.c                 |    8 +++++++-
 drivers/net/ethernet/marvell/pxa168_eth.c |    2 +-
 fs/cifs/file.c                            |    1 +
 fs/cifs/smb2misc.c                        |    4 ++--
 init/Kconfig                              |    2 +-
 kernel/trace/trace.c                      |   14 ++++++++++++++
 net/mac80211/main.c                       |   13 ++++++++++++-
 sound/pci/hda/patch_realtek.c             |    1 -
 20 files changed, 62 insertions(+), 23 deletions(-)

Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Arnd Bergmann (1):
      x86/build: Turn off -fcf-protection for realmode targets

Greg Kroah-Hartman (1):
      Linux 4.4.266

Heiko Carstens (1):
      init/Kconfig: make COMPILE_TEST depend on !S390

Karthikeyan Kathirvel (1):
      mac80211: choose first enabled channel for monitor

Masahiro Yamada (1):
      init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Miquel Raynal (7):
      mtd: rawnand: tmio: Fix the probe error path
      mtd: rawnand: socrates: Fix the probe error path
      mtd: rawnand: sharpsl: Fix the probe error path
      mtd: rawnand: plat_nand: Fix the probe error path
      mtd: rawnand: pasemi: Fix the probe error path
      mtd: rawnand: orion: Fix the probe error path
      mtd: rawnand: diskonchip: Fix the probe error path

Pavel Andrianov (1):
      net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Piotr Krysiuk (1):
      bpf, x86: Validate computation of branch displacements for x86-64

Richard Weinberger (1):
      init/Kconfig: make COMPILE_TEST depend on !UML

Ronnie Sahlberg (1):
      cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich (1):
      ia64: mca: allocate early mca with GFP_ATOMIC

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda/realtek - Fix pincfg for Dell XPS 13 9370

Steven Rostedt (VMware) (1):
      tracing: Add a vmalloc_sync_mappings() for safe measure

Tong Zhang (1):
      mISDN: fix crash in fritzpci

Vincent Whitchurch (1):
      cifs: Silently ignore unknown oplock break handle

