Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA182C2D5D
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 17:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390604AbgKXQvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 11:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390576AbgKXQvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 11:51:37 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30CE206D9;
        Tue, 24 Nov 2020 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606236696;
        bh=doY+OdkC8Y7f15aRZJj+tFs4NeH/3qef+S66z8cWAKs=;
        h=From:To:Cc:Subject:Date:From;
        b=2j7t0VbiFv7+RdAh8ulhI96x8fFgxbRsfNI74oKBXOK2r83YGCkDlSRhtFeBETuqd
         cj9LFiCYiunKEKmEyiSqpwA3vYZWwMVqLcA1sjMp7/3lX/XUzj9ODC7FKpQeCRKBXk
         flUi/DC1KrbZsJ0DFzROPHhlOjMRIe34of2HXx+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.246
Date:   Tue, 24 Nov 2020 17:51:22 +0100
Message-Id: <160623668212620@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.246 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/boot/dts/imx50-evk.dts                       |    2 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                   |    2 
 arch/arm64/kernel/psci.c                              |    5 -
 arch/mips/alchemy/common/clock.c                      |    9 +++
 arch/mips/mm/tlb-r4k.c                                |    1 
 arch/powerpc/include/asm/book3s/64/kup-radix.h        |    1 
 arch/s390/kernel/perf_cpum_sf.c                       |    2 
 arch/x86/kernel/cpu/microcode/intel.c                 |   48 ------------------
 arch/xtensa/mm/cache.c                                |   14 +++++
 drivers/atm/nicstar.c                                 |    2 
 drivers/iio/accel/kxcjk-1013.c                        |   15 +++--
 drivers/input/misc/adxl34x.c                          |    2 
 drivers/net/can/dev.c                                 |    2 
 drivers/net/can/m_can/m_can.c                         |    4 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c          |    4 -
 drivers/net/ethernet/broadcom/b44.c                   |    3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c     |    2 
 drivers/net/ethernet/faraday/ftgmac100.c              |    4 +
 drivers/net/ethernet/mellanox/mlx4/fw.c               |    6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h               |    4 -
 drivers/net/ethernet/mellanox/mlxsw/core.c            |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    3 -
 drivers/net/usb/qmi_wwan.c                            |    2 
 drivers/pinctrl/pinctrl-rockchip.c                    |    2 
 drivers/regulator/core.c                              |   29 ++++------
 drivers/regulator/ti-abb-regulator.c                  |   12 ++++
 drivers/tty/serial/imx.c                              |   20 +------
 fs/efivarfs/super.c                                   |    1 
 fs/ext4/ext4.h                                        |    3 -
 fs/libfs.c                                            |    6 +-
 fs/super.c                                            |   33 +-----------
 fs/xfs/libxfs/xfs_rmap_btree.c                        |   16 +++---
 net/bridge/br_device.c                                |    1 
 net/core/devlink.c                                    |    6 +-
 net/core/netpoll.c                                    |   22 ++++++--
 net/ipv4/inet_diag.c                                  |    4 +
 net/ipv4/tcp_bbr.c                                    |    2 
 net/ipv6/ah6.c                                        |    3 -
 net/mac80211/rc80211_minstrel.c                       |   27 +---------
 net/mac80211/rc80211_minstrel.h                       |    1 
 net/mac80211/sta_info.c                               |   14 +----
 net/netlabel/netlabel_unlabeled.c                     |   17 ++++--
 net/sctp/input.c                                      |    4 -
 net/sctp/sm_sideeffect.c                              |    4 -
 net/sctp/transport.c                                  |    2 
 net/x25/af_x25.c                                      |    1 
 sound/core/control.c                                  |    2 
 sound/pci/mixart/mixart_core.c                        |    5 -
 tools/perf/builtin-lock.c                             |    2 
 50 files changed, 173 insertions(+), 207 deletions(-)

Alejandro Concepcion Rodriguez (1):
      can: dev: can_restart(): post buffer from the right context

Aya Levin (1):
      net/mlx4_core: Fix init_hca fields offset

Chen Yu (1):
      x86/microcode/intel: Check patch signature before saving microcode for early loading

Colin Ian King (1):
      can: peak_usb: fix potential integer overflow on shift of a int

Dan Carpenter (1):
      Input: adxl34x - clean up a data type in adxl34x_probe()

Daniel Axtens (1):
      powerpc/uaccess-flush: fix missing includes in kup-radix.h

Darrick J. Wong (2):
      vfs: remove lockdep bogosity in __sb_start_write
      xfs: revert "xfs: fix rmap key and record comparison functions"

Edwin Peer (1):
      bnxt_en: read EEPROM A2h address using page 0

Fabio Estevam (1):
      ARM: dts: imx50-evk: Fix the chip select 1 IOMUX

Felix Fietkau (2):
      mac80211: minstrel: remove deferred sampling code
      mac80211: minstrel: fix tx status processing corner case

Filip Moc (1):
      net: usb: qmi_wwan: Set DTR quirk for MR400

Florian Fainelli (1):
      net: Have netpoll bring-up DSA management interface

Fugang Duan (1):
      tty: serial: imx: keep console clocks always on

Greg Kroah-Hartman (1):
      Linux 4.9.246

Hans de Goede (1):
      iio: accel: kxcjk1013: Replace is_smo8500_device with an acpi_type enum

Heiner Kallweit (1):
      net: bridge: add missing counters to ndo_get_stats64 callback

Ido Schimmel (1):
      mlxsw: core: Use variable timeout for EMAD retries

Jan Kara (1):
      ext4: fix bogus warning in ext4_update_dx_flag()

Jianqun Xu (1):
      pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Joel Stanley (1):
      net: ftgmac100: Fix crash when removing driver

Johannes Berg (1):
      mac80211: free sta in sta_info_insert_finish() on errors

Leo Yan (1):
      perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Max Filippov (1):
      xtensa: disable preemption around cache alias management calls

Michał Mirosław (1):
      regulator: fix memory leak with repeated set_machine_constraints()

Nishanth Menon (1):
      regulator: ti-abb: Fix array out of bound read access on the first transition

Paul Moore (2):
      netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
      netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

Randy Dunlap (1):
      MIPS: export has_transparent_hugepage() for modules

Ryan Sharpelletti (1):
      tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Sebastian Andrzej Siewior (1):
      atm: nicstar: Unmap DMA on send error

Sergey Matyukevich (1):
      arm: dts: imx6qdl-udoo: fix rgmii phy-mode for ksz9031 phy

Takashi Iwai (1):
      ALSA: mixart: Fix mutex deadlock

Takashi Sakamoto (1):
      ALSA: ctl: fix error path at adding user-defined element set

Thomas Richter (1):
      s390/cpum_sf.c: fix file permission for cpum_sfb_size

Vamshi K Sthambamkadi (1):
      efivarfs: fix memory leak in efivarfs_create()

Wang Hai (2):
      devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
      inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()

Will Deacon (1):
      arm64: psci: Avoid printing in cpu_psci_cpu_die()

Wu Bo (1):
      can: m_can: m_can_handle_state_change(): fix state change

Xie He (1):
      net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request

Xin Long (1):
      sctp: change to hold/put transport for proto_unreach_timer

Yicong Yang (1):
      libfs: fix error cast of negative value in simple_attr_write()

Zhang Changzhong (3):
      ah6: fix error return code in ah6_input()
      net: b44: fix error return code in b44_init_one()
      qlcnic: fix error return code in qlcnic_83xx_restart_hw()

Zhang Qilong (1):
      MIPS: Alchemy: Fix memleak in alchemy_clk_setup_cpu

