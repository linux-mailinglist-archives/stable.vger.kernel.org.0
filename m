Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432A635ED4E
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhDNGkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349237AbhDNGki (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE2EF613C4;
        Wed, 14 Apr 2021 06:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618382417;
        bh=/m8H+5jXHaUzWg2EfGzylxF5mBK3nbiPFNHnw9UAE0s=;
        h=From:To:Cc:Subject:Date:From;
        b=sR+jNUZwWhKbPBu+w3vXKN13XQZe4YnLX5YEe9c74YfTAh2FaGFViji4xHWke+mnt
         whCrxPEj0t/Ox2iuOiu/rQsMlqFcsKwL3SOrI/U0VkcZfnVRf/iyden4FhKIeKch+E
         EFXIdbhIPH0oCXLRRphdFUtx77RVlHvk/5c35NBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.187
Date:   Wed, 14 Apr 2021 08:40:13 +0200
Message-Id: <161838241321927@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.187 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |    1 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |    2 
 arch/ia64/include/asm/ptrace.h                     |    8 ---
 arch/nds32/mm/cacheflush.c                         |    2 
 arch/parisc/include/asm/cmpxchg.h                  |    2 
 arch/s390/kernel/cpcmd.c                           |    6 +-
 drivers/char/agp/Kconfig                           |    2 
 drivers/clk/clk.c                                  |   47 ++++++++----------
 drivers/clk/socfpga/clk-gate.c                     |    2 
 drivers/i2c/i2c-core-base.c                        |    7 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    3 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    6 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   23 +++++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |    3 -
 drivers/net/ethernet/freescale/gianfar.c           |    6 ++
 drivers/net/ethernet/intel/i40e/i40e.h             |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    1 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    9 +++
 drivers/net/ethernet/intel/ice/ice_controlq.h      |    4 -
 drivers/net/ieee802154/atusb.c                     |    1 
 drivers/net/tun.c                                  |   48 +++++++++++++++++++
 drivers/net/usb/hso.c                              |   33 ++++---------
 drivers/net/virtio_net.c                           |   52 ++++++++++++---------
 drivers/regulator/bd9571mwv-regulator.c            |    4 -
 drivers/soc/fsl/qbman/qman.c                       |    2 
 drivers/usb/usbip/stub_dev.c                       |   11 +++-
 drivers/usb/usbip/usbip_common.h                   |    3 +
 drivers/usb/usbip/usbip_event.c                    |    2 
 drivers/usb/usbip/vhci_hcd.c                       |    1 
 drivers/usb/usbip/vhci_sysfs.c                     |   30 ++++++++++--
 drivers/usb/usbip/vudc_dev.c                       |    1 
 drivers/usb/usbip/vudc_sysfs.c                     |    5 ++
 drivers/xen/events/events_base.c                   |   10 ++--
 drivers/xen/events/events_internal.h               |    2 
 fs/cifs/connect.c                                  |    1 
 fs/direct-io.c                                     |    5 +-
 fs/ocfs2/aops.c                                    |   11 ----
 fs/ocfs2/file.c                                    |    8 ++-
 include/linux/mlx5/mlx5_ifc.h                      |    8 +--
 include/linux/virtio_net.h                         |    2 
 include/net/netns/xfrm.h                           |    4 +
 include/net/red.h                                  |    4 -
 kernel/workqueue.c                                 |    2 
 net/batman-adv/translation-table.c                 |    2 
 net/ieee802154/nl-mac.c                            |    7 +-
 net/ieee802154/nl802154.c                          |   23 +++++++--
 net/ipv6/raw.c                                     |    2 
 net/ipv6/route.c                                   |    8 ++-
 net/mac802154/llsec.c                              |    2 
 net/ncsi/ncsi-manage.c                             |   20 +++++---
 net/nfc/llcp_sock.c                                |   10 ++++
 net/sched/act_api.c                                |    3 +
 net/sched/sch_teql.c                               |    3 +
 net/sctp/ipv6.c                                    |    7 +-
 net/tipc/socket.c                                  |    2 
 net/wireless/sme.c                                 |    2 
 net/xfrm/xfrm_interface.c                          |    3 +
 net/xfrm/xfrm_state.c                              |   10 ++--
 sound/drivers/aloop.c                              |   11 +++-
 sound/soc/codecs/wm8960.c                          |    8 ++-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |    6 +-
 sound/soc/sunxi/sun4i-codec.c                      |    5 ++
 64 files changed, 354 insertions(+), 173 deletions(-)

Ahmed S. Darwish (1):
      net: xfrm: Localize sequence counter per network namespace

Alexander Aring (8):
      net: ieee802154: nl-mac: fix check on panid
      net: ieee802154: fix nl802154 del llsec key
      net: ieee802154: fix nl802154 del llsec dev
      net: ieee802154: fix nl802154 add llsec key
      net: ieee802154: fix nl802154 del llsec devkey
      net: ieee802154: forbid monitor for set llsec params
      net: ieee802154: forbid monitor for del llsec seclevel
      net: ieee802154: stop dump llsec params for monitors

Alexander Gordeev (1):
      s390/cpcmd: fix inline assembly register clobbering

Anirudh Rayabharam (1):
      net: hso: fix null-ptr-deref during tty device unregistration

Arnd Bergmann (1):
      soc/fsl: qbman: fix conflicting alignment attributes

Aya Levin (1):
      net/mlx5: Fix PBMC register mapping

Bastian Germann (1):
      ASoC: sunxi: sun4i-codec: fill ASoC card owner

Claudiu Manoil (1):
      gianfar: Handle error code at MAC address change

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Eric Dumazet (2):
      net: ensure mac header is set in virtio_net_hdr_to_skb()
      sch_red: fix off-by-one checks in red_check_params()

Eryk Rybak (1):
      i40e: Fix kernel oops when i40e driver removes VF's

Eyal Birger (1):
      xfrm: interface: fix ipv4 pmtu check to honor ip header df

Fabio Pricoco (1):
      ice: Increase control queue timeout

Gao Xiang (1):
      parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Geert Uytterhoeven (1):
      regulator: bd9571mwv: Fix AVS and DVFS voltage range

Greg Kroah-Hartman (2):
      Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
      Linux 4.19.187

Hans de Goede (1):
      ASoC: intel: atom: Stop advertising non working S24LE support

Helge Deller (1):
      parisc: parisc-agp requires SBA IOMMU driver

Jack Qiu (1):
      fs: direct-io: fix missing sdio->boundary

Jonas Holmberg (1):
      ALSA: aloop: Fix initialization of controls

Krzysztof Kozlowski (1):
      clk: socfpga: fix iomem pointer cast on 64-bit

Kumar Kartikeya Dwivedi (1):
      net: sched: bump refcount for new action in ACT replace mode

Luca Fancellu (1):
      xen/evtchn: Change irq_info lock to raw_spinlock_t

Lukasz Bartosik (2):
      clk: fix invalid usage of list cursor in register
      clk: fix invalid usage of list cursor in unregister

Lv Yunlong (1):
      net:tipc: Fix a double free in tipc_sk_mcast_rcv

Maciej Żenczykowski (1):
      net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Marek Behún (1):
      ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Mateusz Palczewski (1):
      i40e: Added Asym_Pause to supported link modes

Mike Rapoport (1):
      nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Milton Miller (1):
      net/ncsi: Avoid channel_monitor hrtimer deadlock

Muhammad Usama Anjum (1):
      net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Pavel Skripkin (3):
      drivers: net: fix memory leak in atusb_probe
      drivers: net: fix memory leak in peak_usb_create_dev
      net: mac802154: Fix general protection fault

Pavel Tikhomirov (1):
      net: sched: sch_teql: fix null-pointer dereference

Phillip Potter (1):
      net: tun: set tun->dev->addr_len during TUNSETLINK processing

Potnuri Bharat Teja (1):
      RDMA/cxgb4: check for ipv6 address properly while destroying listener

Raed Salem (1):
      net/mlx5: Fix placement of log_max_flow_counter

Rahul Lakkireddy (1):
      cxgb4: avoid collecting SGE_QBASE regs during traffic

Sergei Trofimovich (1):
      ia64: fix user_stack_pointer() for ptrace()

Shengjiu Wang (1):
      ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips

Shuah Khan (4):
      usbip: add sysfs_lock to synchronize sysfs code paths
      usbip: stub-dev synchronize sysfs code paths
      usbip: vudc synchronize sysfs code paths
      usbip: synchronize event handler with sysfs code paths

Shyam Sundar S K (1):
      amd-xgbe: Update DMA coherency values

Stefan Riedmueller (1):
      ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces

Tetsuo Handa (1):
      batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Wengang Wang (1):
      ocfs2: fix deadlock between setattr and dio_end_io_write

Wolfram Sang (1):
      i2c: turn recovery error on init to debug

Xiaoming Ni (4):
      nfc: fix refcount leak in llcp_sock_bind()
      nfc: fix refcount leak in llcp_sock_connect()
      nfc: fix memory leak in llcp_sock_connect()
      nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Yuya Kusakabe (1):
      virtio_net: Add XDP meta data support

Zqiang (1):
      workqueue: Move the position of debug_work_activate() in __queue_work()

