Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840F92C2D54
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 17:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390499AbgKXQvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 11:51:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgKXQvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 11:51:19 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E9E206D8;
        Tue, 24 Nov 2020 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606236678;
        bh=3116s1Z+EaboWO0N/1QK4WcUBSwyX0NnM/Pv3b5i//Q=;
        h=From:To:Cc:Subject:Date:From;
        b=LCbWdZ+QRIyHLugdFsTSP4gYsMVlWjCv9HO+6aPbzQAOuKIDrbvy0+IWzcsfnN1Hn
         kvbSm0kxwlrcGoVapA4VB0iF/0xcYXIcd6iLdIi7Fzy9beeKRSs6KSQuu3bd2lifGk
         tVndOXp0pQZA1SKNn6M8Zi6O3ySxmmmVDM/mES3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.246
Date:   Tue, 24 Nov 2020 17:51:13 +0100
Message-Id: <160623667314950@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.246 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/boot/dts/imx50-evk.dts                       |    2 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                   |    2 
 arch/arm64/kernel/psci.c                              |    5 -
 arch/mips/alchemy/common/clock.c                      |    9 ++-
 arch/mips/kernel/genex.S                              |    3 -
 arch/powerpc/kernel/ppc_ksyms.c                       |    4 -
 arch/s390/kernel/perf_cpum_sf.c                       |    2 
 arch/x86/kernel/cpu/microcode/intel.c                 |   49 ------------------
 arch/xtensa/mm/cache.c                                |   14 +++++
 drivers/atm/nicstar.c                                 |    2 
 drivers/input/misc/adxl34x.c                          |    2 
 drivers/net/can/dev.c                                 |    2 
 drivers/net/can/m_can/m_can.c                         |    4 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c          |    4 -
 drivers/net/ethernet/broadcom/b44.c                   |    3 -
 drivers/net/ethernet/mellanox/mlx4/fw.c               |    6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h               |    4 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    3 -
 drivers/net/usb/qmi_wwan.c                            |    2 
 drivers/pinctrl/pinctrl-rockchip.c                    |    2 
 drivers/regulator/ti-abb-regulator.c                  |   12 ++++
 drivers/tty/serial/imx.c                              |   20 +------
 fs/efivarfs/super.c                                   |    1 
 fs/ext4/ext4.h                                        |    3 -
 fs/libfs.c                                            |    6 +-
 include/net/mac80211.h                                |    6 ++
 net/bridge/br_device.c                                |    1 
 net/core/netpoll.c                                    |   22 ++++++--
 net/ipv6/ah6.c                                        |    3 -
 net/mac80211/debugfs.c                                |    1 
 net/mac80211/rc80211_minstrel.c                       |   27 +--------
 net/mac80211/rc80211_minstrel.h                       |    1 
 net/mac80211/sta_info.c                               |   32 +++++++----
 net/netlabel/netlabel_unlabeled.c                     |   17 ++++--
 net/sctp/input.c                                      |    4 -
 net/sctp/sm_sideeffect.c                              |    4 -
 net/sctp/transport.c                                  |    2 
 net/x25/af_x25.c                                      |    1 
 sound/core/control.c                                  |    2 
 sound/pci/mixart/mixart_core.c                        |    5 -
 tools/perf/builtin-lock.c                             |    2 
 42 files changed, 148 insertions(+), 150 deletions(-)

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
      powerpc/uaccess-flush: fix corenet64_smp_defconfig build

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
      Linux 4.4.246

Heiner Kallweit (1):
      net: bridge: add missing counters to ndo_get_stats64 callback

Jan Kara (1):
      ext4: fix bogus warning in ext4_update_dx_flag()

Jianqun Xu (1):
      pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq

Johannes Berg (2):
      mac80211: allow driver to prevent two stations w/ same address
      mac80211: free sta in sta_info_insert_finish() on errors

Leo Yan (1):
      perf lock: Don't free "lock_seq_stat" if read_count isn't zero

Max Filippov (1):
      xtensa: disable preemption around cache alias management calls

Nishanth Menon (1):
      regulator: ti-abb: Fix array out of bound read access on the first transition

Paul Burton (1):
      MIPS: Fix BUILD_ROLLBACK_PROLOGUE for microMIPS

Paul Moore (2):
      netlabel: fix our progress tracking in netlbl_unlabel_staticlist()
      netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

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

