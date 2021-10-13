Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77DC42BA7B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhJMIfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238450AbhJMIc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 04:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46299610CB;
        Wed, 13 Oct 2021 08:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634113856;
        bh=7RMZc1TMCdB19mYN2DUzEsOhq9zC/hxC5BfQeZadXDU=;
        h=From:To:Cc:Subject:Date:From;
        b=ujomPyJ8EupFd2pNHuz3iA4r4qkCcSBSpnZ8yzwUm1uNGlWq61Rb2Y4wjc5kl7r96
         ktuudb7IXSfSWdii1eKS9FVSYk09DPKLmpyBsFaw1qB3+EIUCbZ129zxUcqdbAm/D9
         vxsn6NngRGISCVG3YpdC1AyuV2C72bTKsLblyfkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.211
Date:   Wed, 13 Oct 2021 10:30:53 +0200
Message-Id: <1634113853177207@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.211 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/boot/dts/omap3430-sdp.dts          |    2 
 arch/arm/boot/dts/qcom-apq8064.dtsi         |    3 -
 arch/arm/mach-imx/pm-imx6.c                 |    2 
 arch/arm/net/bpf_jit_32.c                   |   19 +++++++++
 arch/mips/net/bpf_jit.c                     |   57 +++++++++++++++++++++-------
 arch/powerpc/boot/dts/fsl/t1023rdb.dts      |    2 
 arch/x86/Kconfig                            |    2 
 arch/xtensa/kernel/irq.c                    |    2 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c   |    1 
 drivers/i2c/i2c-core-acpi.c                 |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c |    5 +-
 drivers/net/phy/mdio_bus.c                  |    7 +++
 drivers/net/phy/sfp.c                       |    2 
 drivers/ptp/ptp_pch.c                       |    1 
 drivers/usb/Kconfig                         |    3 -
 drivers/usb/class/cdc-acm.c                 |    8 +++
 drivers/xen/balloon.c                       |   21 +++++++---
 drivers/xen/privcmd.c                       |    7 +--
 fs/nfsd/nfs4xdr.c                           |   19 +++++----
 fs/overlayfs/dir.c                          |   10 +++-
 kernel/bpf/stackmap.c                       |    3 -
 net/bridge/br_netlink.c                     |    2 
 net/core/rtnetlink.c                        |    2 
 net/netlink/af_netlink.c                    |   14 ++++--
 net/sched/sch_fifo.c                        |    3 +
 26 files changed, 147 insertions(+), 53 deletions(-)

Andy Shevchenko (1):
      ptp_pch: Load module automatically if ID matches

Ben Hutchings (1):
      Partially revert "usb: Kconfig: using select for USB_COMMON dependency"

David Heidelberg (1):
      ARM: dts: qcom: apq8064: use compatible which contains chipid

Eric Dumazet (4):
      net_sched: fix NULL deref in fifo_set_limit()
      net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
      netlink: annotate data races around nlk->bound
      rtnetlink: fix if_nlmsg_stats_size() under estimation

Greg Kroah-Hartman (1):
      Linux 4.19.211

Jamie Iles (1):
      i2c: acpi: fix resource leak in reconfiguration device addition

Jan Beulich (1):
      xen/privcmd: fix error handling in mmap-resource processing

Jiri Benc (1):
      i40e: fix endless loop under rtnl

Johan Almbladh (1):
      bpf, arm: Fix register clobbering in div/mod implementation

Johan Hovold (2):
      USB: cdc-acm: fix racy tty buffer accesses
      USB: cdc-acm: fix break reporting

Juergen Gross (1):
      xen/balloon: fix cancelled balloon action

Lukas Bulwahn (1):
      x86/Kconfig: Correct reference to MWINCHIP3D

Max Filippov (1):
      xtensa: call irqchip_init only when CONFIG_USE_OF is selected

Oleksij Rempel (1):
      ARM: imx6: disable the GIC CPU interface before calling stby-poweroff sequence

Pali Rohár (1):
      powerpc/fsl/dts: Fix phy-connection-type for fm1mac3

Pavel Skripkin (1):
      phy: mdio: fix memory leak

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

Roger Quadros (1):
      ARM: dts: omap3430-sdp: Fix NAND device node

Sean Anderson (1):
      net: sfp: Fix typo in state machine debug string

Sylwester Dziedziuch (1):
      i40e: Fix freeing of uninitialized misc IRQ vector

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow in prealloc_elems_and_freelist()

Trond Myklebust (1):
      nfsd4: Handle the NFSv4 READDIR 'dircount' hint being zero

Yang Yingliang (1):
      drm/nouveau/debugfs: fix file release memory leak

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

