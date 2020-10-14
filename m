Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E9E28DE57
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgJNKML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgJNKML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 06:12:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3802068E;
        Wed, 14 Oct 2020 10:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602670328;
        bh=QLH6xolUMaD7r3TsNcCTarAJjxBxW9jxTS8NZIcoFvI=;
        h=From:To:Cc:Subject:Date:From;
        b=ghRecAvM6BKoaqKwEF4vLElp1CZohKWqJspY+78hPfKrkV9oMDAF9p8HRgZ0FNOH7
         yfvAf6/CDGoC6JL8EaBCVTZ2TdIVp1XjvCFvqh3KZ/aK9VfqAHLhUzLdwZoZFsPETJ
         DM2jmn+KoQNb+NoQKqvaozWFdje/ZBKNy2HIqsJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.151
Date:   Wed, 14 Oct 2020 12:12:42 +0200
Message-Id: <16026703628599@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.151 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts |    1 
 drivers/base/dd.c                                      |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                |    1 
 drivers/gpu/drm/nouveau/nouveau_mem.c                  |    2 
 drivers/i2c/busses/i2c-i801.c                          |    1 
 drivers/i2c/busses/i2c-meson.c                         |   42 ++++--
 drivers/i2c/busses/i2c-owl.c                           |    6 
 drivers/mmc/core/queue.c                               |    2 
 drivers/mtd/nand/raw/sunxi_nand.c                      |    2 
 drivers/net/bonding/bond_main.c                        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c        |   14 +-
 drivers/net/ethernet/renesas/ravb_main.c               |  110 ++++++++---------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   15 --
 drivers/net/macsec.c                                   |    4 
 drivers/net/phy/Kconfig                                |    1 
 drivers/net/team/team.c                                |    3 
 drivers/net/usb/ax88179_178a.c                         |    1 
 drivers/net/usb/rtl8150.c                              |   16 +-
 drivers/nvme/host/core.c                               |    4 
 drivers/platform/x86/Kconfig                           |    1 
 drivers/platform/x86/intel-vbtn.c                      |   64 +++++++--
 drivers/platform/x86/thinkpad_acpi.c                   |    6 
 drivers/video/console/newport_con.c                    |    7 -
 drivers/video/fbdev/core/fbcon.c                       |   12 +
 drivers/video/fbdev/core/fbcon.h                       |    7 -
 drivers/video/fbdev/core/fbcon_rotate.c                |    1 
 drivers/video/fbdev/core/tileblit.c                    |    1 
 fs/cifs/smb2ops.c                                      |    2 
 include/linux/font.h                                   |   13 ++
 include/linux/khugepaged.h                             |    5 
 include/net/xfrm.h                                     |   16 --
 kernel/events/core.c                                   |    5 
 kernel/umh.c                                           |    9 +
 lib/fonts/font_10x18.c                                 |    9 -
 lib/fonts/font_6x10.c                                  |    9 -
 lib/fonts/font_6x11.c                                  |    9 -
 lib/fonts/font_7x14.c                                  |    9 -
 lib/fonts/font_8x16.c                                  |    9 -
 lib/fonts/font_8x8.c                                   |    9 -
 lib/fonts/font_acorn_8x8.c                             |    9 -
 lib/fonts/font_mini_4x6.c                              |    8 -
 lib/fonts/font_pearl_8x8.c                             |    9 -
 lib/fonts/font_sun12x22.c                              |    9 -
 lib/fonts/font_sun8x16.c                               |    7 -
 mm/khugepaged.c                                        |   25 +++
 mm/page_alloc.c                                        |    3 
 net/openvswitch/conntrack.c                            |   22 ++-
 net/rxrpc/conn_event.c                                 |    6 
 net/rxrpc/key.c                                        |   18 ++
 net/sctp/auth.c                                        |    1 
 net/wireless/nl80211.c                                 |    3 
 net/xfrm/xfrm_interface.c                              |    2 
 net/xfrm/xfrm_state.c                                  |   42 +++++-
 tools/perf/builtin-top.c                               |    4 
 55 files changed, 394 insertions(+), 210 deletions(-)

Aaron Ma (1):
      platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse

Anant Thazhemadam (3):
      net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
      net: team: fix memory leak in __team_options_register
      net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails

Antony Antony (4):
      xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Aya Levin (2):
      net/mlx5e: Fix VLAN cleanup flow
      net/mlx5e: Fix VLAN create flow

Chaitanya Kulkarni (1):
      nvme-core: put ctrl ref when module ref get fail

Coly Li (1):
      mmc: core: don't set limits.discard_granularity as 0

Cristian Ciocaltea (1):
      i2c: owl: Clear NACK and BUS error bits

David Howells (3):
      rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()
      rxrpc: Fix some missing _bh annotations on locking conn->state_lock
      rxrpc: Fix server keyring leak

Dinh Nguyen (1):
      arm64: dts: stratix10: add status to qspi dts node

Dumitru Ceara (1):
      openvswitch: handle DNAT tuple collision

Eric Dumazet (4):
      macsec: avoid use-after-free in macsec_handle_frame()
      sctp: fix sctp_auth_init_hmacs() error path
      team: set dev->needed_headroom in team_setup_by_port()
      bonding: set dev->needed_headroom in bond_setup_by_slave()

Geert Uytterhoeven (1):
      Revert "ravb: Fixed to be able to unload modules"

Greg Kroah-Hartman (1):
      Linux 4.19.151

Hans de Goede (2):
      platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360
      platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Hugh Dickins (1):
      mm/khugepaged: fix filemap page_to_pgoff(page) != offset

Jean Delvare (1):
      i2c: i801: Exclude device from suspend direct complete optimization

Jerome Brunet (1):
      i2c: meson: fix clock setting overwrite

Kajol Jain (1):
      perf: Fix task_function_call() error handling

Karol Herbst (1):
      drm/nouveau/mem: guard against NULL pointer access in mem_del

Linus Torvalds (1):
      usermodehelper: reset umask to default before executing user process

Marc Dionne (1):
      rxrpc: Fix rxkad token xdr encoding

Miquel Raynal (1):
      mtd: rawnand: sunxi: Fix the probe error path

Necip Fazil Yildiran (1):
      platform/x86: fix kconfig dependency warning for FUJITSU_LAPTOP

Nicolas Belin (1):
      i2c: meson: fixup rate calculation with filter delay

Peilin Ye (3):
      fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h
      Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts
      fbcon: Fix global-out-of-bounds read in fbcon_get_font()

Philip Yang (1):
      drm/amdgpu: prevent double kfree ttm->sg

Randy Dunlap (1):
      mdio: fix mdio-thunder.c dependency & build error

Sabrina Dubroca (1):
      xfrmi: drop ignore_df check before updating pmtu

Tetsuo Handa (1):
      driver core: Fix probe_count imbalance in really_probe()

Tom Rix (1):
      platform/x86: thinkpad_acpi: initialize tp_nvram_state variable

Tommi Rantala (1):
      perf top: Fix stdio interface input handling with glibc 2.28+

Vijay Balakrishna (1):
      mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

Vladimir Zapolskiy (1):
      cifs: Fix incomplete memory allocation on setxattr path

Voon Weifeng (1):
      net: stmmac: removed enabling eee in EEE set callback

Wilken Gottwalt (1):
      net: usb: ax88179_178a: fix missing stop entry in driver_info

