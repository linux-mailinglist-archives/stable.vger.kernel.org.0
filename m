Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FFAE8417
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbfJ2JST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbfJ2JST (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:18:19 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341F820717;
        Tue, 29 Oct 2019 09:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340697;
        bh=q8XFgcB4jDKwya47LrQUgKLfVm4Q60UwOANyhSymBjs=;
        h=Date:From:To:Cc:Subject:From;
        b=1c34SjajscY0ibqqDfioJ+oRg14QBJwnZpPXdX24ZS+tgoOWYiTbwh0llHGxiDPVd
         axAapwXPk1V5J5CVTH11HhhcKQ5hPhnJ7vV9WNEBLDGL2jUoSeZ29Psd4Vgl/L++q0
         xHYtGugJFWepTQ6ZOFNJAZzzzDPMTexdxErcxee4=
Date:   Tue, 29 Oct 2019 10:18:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.198
Message-ID: <20191029091814.GA581590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.198 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 -
 arch/arm/boot/dts/am4372.dtsi                           |    2 +
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |    3 +
 arch/mips/loongson64/common/serial.c                    |    2 -
 arch/parisc/mm/ioremap.c                                |   12 ++++--
 arch/xtensa/kernel/xtensa_ksyms.c                       |    7 ----
 drivers/base/core.c                                     |    3 +
 drivers/block/loop.c                                    |    1 
 drivers/cpufreq/cpufreq.c                               |   10 -----
 drivers/gpu/drm/drm_edid.c                              |    3 +
 drivers/infiniband/hw/cxgb4/mem.c                       |   28 +++++++++-------
 drivers/memstick/host/jmb38x_ms.c                       |    2 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.h          |    1 
 drivers/net/ethernet/broadcom/genet/bcmmii.c            |   11 ++++--
 drivers/net/ethernet/hisilicon/hns_mdio.c               |    6 ++-
 drivers/net/xen-netback/interface.c                     |    1 
 drivers/pci/pci.c                                       |   24 ++++++-------
 drivers/s390/scsi/zfcp_fsf.c                            |   16 +++++++--
 drivers/scsi/megaraid.c                                 |    4 +-
 drivers/scsi/qla2xxx/qla_target.c                       |    4 ++
 drivers/scsi/scsi_sysfs.c                               |   11 +++++-
 drivers/scsi/ufs/ufshcd.c                               |    3 +
 drivers/usb/class/usblp.c                               |    4 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c                    |    6 +--
 drivers/usb/misc/ldusb.c                                |   20 ++++++-----
 drivers/usb/misc/legousbtower.c                         |    5 --
 drivers/usb/serial/ti_usb_3410_5052.c                   |   10 +----
 fs/btrfs/extent-tree.c                                  |    1 
 fs/cifs/smb1ops.c                                       |    3 +
 mm/shmem.c                                              |   20 ++++++-----
 mm/slub.c                                               |   13 ++++++-
 net/ipv4/route.c                                        |    9 +++--
 net/mac80211/mlme.c                                     |    5 +-
 net/sched/act_api.c                                     |   12 ++++--
 net/sched/cls_u32.c                                     |    8 +++-
 net/sctp/socket.c                                       |    4 +-
 net/wireless/nl80211.c                                  |    3 +
 net/wireless/wext-sme.c                                 |    8 +++-
 scripts/namespace.pl                                    |   13 ++++---
 sound/soc/sh/rcar/core.c                                |    1 
 40 files changed, 184 insertions(+), 117 deletions(-)

Alessio Balsini (1):
      loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Christophe JAILLET (2):
      mips: Loongson: Fix the link time qualifier of 'serial_exit()'
      memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Eric Dumazet (1):
      net: avoid potential infinite loop in tc_ctl_action()

Florian Fainelli (2):
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
      net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Greg KH (1):
      RDMA/cxgb4: Do not dma memory off of the stack

Greg Kroah-Hartman (1):
      Linux 4.4.198

Gustavo A. R. Silva (1):
      usb: udc: lpc32xx: fix bad bit shift operation

Helge Deller (1):
      parisc: Fix vmap memory leak in ioremap()/iounmap()

Jacob Keller (1):
      namespace: fix namespace.pl script to support relative paths

Johan Hovold (5):
      USB: legousbtower: fix memleak on disconnect
      USB: serial: ti_usb_3410_5052: fix port-close races
      USB: ldusb: fix memleak on disconnect
      USB: usblp: fix use-after-free on disconnect
      USB: ldusb: fix read info leaks

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()

Junya Monden (1):
      ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting

Kai-Heng Feng (1):
      drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Kees Cook (1):
      net: sched: Fix memory exposure from short TCA_U32_SEL

Matthew Wilcox (Oracle) (1):
      memfd: Fix locking when tagging pins

Max Filippov (1):
      xtensa: drop EXPORT_SYMBOL for outs*/ins*

Miaoqing Pan (1):
      nl80211: fix null pointer dereference

Peter Ujfalusi (1):
      ARM: dts: am4372: Set memory bandwidth limit for DISPC

Qian Cai (1):
      mm/slub: fix a deadlock in show_slab_objects()

Qu Wenruo (1):
      btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()

Quinn Tran (1):
      scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Rafael J. Wysocki (2):
      cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown
      PCI: PM: Fix pci_power_up()

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF

Stanley Chu (1):
      scsi: ufs: skip shutdown if hba is not powered

Stefano Brivio (1):
      ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification

Tony Lindgren (1):
      ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Will Deacon (2):
      cfg80211: wext: avoid copying malformed SSIDs
      mac80211: Reject malformed SSID elements

Xiang Chen (1):
      scsi: megaraid: disable device when probe failed after enabled device

Xin Long (1):
      sctp: change sctp_prot .no_autobind with true

Yizhuo (1):
      net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

Yufen Yu (1):
      scsi: core: try to get module before removing device

