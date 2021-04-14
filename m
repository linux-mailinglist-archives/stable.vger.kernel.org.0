Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE435EDAD
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348249AbhDNGsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349338AbhDNGsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D66C6101B;
        Wed, 14 Apr 2021 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618382902;
        bh=0xYvBH3+4CzoEUIsoSKWhA2a6P/rTkgqtzpr4OXts4Y=;
        h=From:To:Cc:Subject:Date:From;
        b=UOdfJncPazV7MJGuiocqp0dLePkeWvp5T95Scx1IYBGk3Laj/uyWiJigk3USjw0JC
         6WbnHPJH20JM3GP4BTsbFi5GvckiCeRiQ4SuiqGHoL8I33z0IxWZ9xeaKb3X4kM+Gx
         GcuX/QIsrpsDWziBRhq0yPJzn9eUpCuBsg7KMXPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.112
Date:   Wed, 14 Apr 2021 08:48:18 +0200
Message-Id: <161838289817242@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.112 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    2 
 Makefile                                                       |    2 
 arch/arm/boot/dts/armada-385-turris-omnia.dts                  |    1 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi                   |    2 
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h                 |    2 
 arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h                 |    2 
 arch/ia64/include/asm/ptrace.h                                 |    8 
 arch/nds32/mm/cacheflush.c                                     |    2 
 arch/parisc/include/asm/cmpxchg.h                              |    2 
 arch/s390/kernel/cpcmd.c                                       |    6 
 drivers/char/agp/Kconfig                                       |    2 
 drivers/clk/clk.c                                              |   47 -
 drivers/clk/socfpga/clk-gate.c                                 |    2 
 drivers/counter/stm32-timer-cnt.c                              |   12 
 drivers/gpu/drm/i915/display/intel_acpi.c                      |   22 
 drivers/gpu/drm/msm/msm_drv.c                                  |    1 
 drivers/i2c/i2c-core-base.c                                    |    7 
 drivers/infiniband/core/addr.c                                 |    4 
 drivers/infiniband/hw/cxgb4/cm.c                               |    3 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                   |    6 
 drivers/net/dsa/lantiq_gswip.c                                 |  196 ++++
 drivers/net/ethernet/amd/xgbe/xgbe.h                           |    6 
 drivers/net/ethernet/cadence/macb_main.c                       |    7 
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c                 |   23 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     |    3 
 drivers/net/ethernet/freescale/gianfar.c                       |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c      |    4 
 drivers/net/ethernet/intel/i40e/i40e.h                         |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |   53 +
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |   11 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |    9 
 drivers/net/ethernet/intel/ice/ice_controlq.h                  |    4 
 drivers/net/ethernet/intel/ice/ice_switch.c                    |   15 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |   22 
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                   |   13 
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c                  |    1 
 drivers/net/ethernet/netronome/nfp/flower/main.h               |    8 
 drivers/net/ethernet/netronome/nfp/flower/metadata.c           |   16 
 drivers/net/ethernet/netronome/nfp/flower/offload.c            |   48 +
 drivers/net/ieee802154/atusb.c                                 |    1 
 drivers/net/phy/bcm-phy-lib.c                                  |   13 
 drivers/net/tun.c                                              |   48 +
 drivers/net/usb/hso.c                                          |   33 
 drivers/net/virtio_net.c                                       |   52 -
 drivers/ras/cec.c                                              |   15 
 drivers/regulator/bd9571mwv-regulator.c                        |    4 
 drivers/scsi/ufs/ufshcd.c                                      |  398 +++++-----
 drivers/scsi/ufs/ufshcd.h                                      |   18 
 drivers/scsi/ufs/ufshci.h                                      |    2 
 drivers/soc/fsl/qbman/qman.c                                   |    2 
 drivers/usb/usbip/stub_dev.c                                   |   11 
 drivers/usb/usbip/usbip_common.h                               |    3 
 drivers/usb/usbip/usbip_event.c                                |    2 
 drivers/usb/usbip/vhci_hcd.c                                   |    1 
 drivers/usb/usbip/vhci_sysfs.c                                 |   30 
 drivers/usb/usbip/vudc_dev.c                                   |    1 
 drivers/usb/usbip/vudc_sysfs.c                                 |    5 
 drivers/xen/events/events_base.c                               |   10 
 drivers/xen/events/events_internal.h                           |    2 
 fs/cifs/connect.c                                              |    1 
 fs/direct-io.c                                                 |    5 
 fs/hostfs/hostfs_kern.c                                        |   19 
 fs/ocfs2/aops.c                                                |   11 
 fs/ocfs2/file.c                                                |    8 
 include/linux/mlx5/mlx5_ifc.h                                  |    8 
 include/linux/skmsg.h                                          |    8 
 include/linux/virtio_net.h                                     |    2 
 include/net/netns/xfrm.h                                       |    4 
 include/net/red.h                                              |    4 
 include/net/sock.h                                             |    9 
 include/net/xfrm.h                                             |    2 
 kernel/gcov/clang.c                                            |   29 
 kernel/workqueue.c                                             |    2 
 net/batman-adv/translation-table.c                             |    2 
 net/can/bcm.c                                                  |   10 
 net/can/raw.c                                                  |   14 
 net/core/sock.c                                                |   12 
 net/hsr/hsr_device.c                                           |    1 
 net/hsr/hsr_forward.c                                          |    6 
 net/ieee802154/nl-mac.c                                        |    7 
 net/ieee802154/nl802154.c                                      |   23 
 net/ipv4/esp4_offload.c                                        |    6 
 net/ipv4/udp.c                                                 |    4 
 net/ipv6/esp6_offload.c                                        |    6 
 net/ipv6/raw.c                                                 |    2 
 net/ipv6/route.c                                               |    8 
 net/mac80211/tx.c                                              |    2 
 net/mac802154/llsec.c                                          |    2 
 net/ncsi/ncsi-manage.c                                         |   20 
 net/nfc/llcp_sock.c                                            |   10 
 net/openvswitch/conntrack.c                                    |   14 
 net/rds/message.c                                              |    3 
 net/sched/act_api.c                                            |    3 
 net/sched/sch_teql.c                                           |    3 
 net/sctp/ipv6.c                                                |    7 
 net/tipc/socket.c                                              |    2 
 net/wireless/sme.c                                             |    2 
 net/xfrm/xfrm_interface.c                                      |    3 
 net/xfrm/xfrm_state.c                                          |   10 
 sound/drivers/aloop.c                                          |   11 
 sound/pci/hda/patch_realtek.c                                  |   16 
 sound/soc/codecs/wm8960.c                                      |    8 
 sound/soc/intel/atom/sst-mfld-platform-pcm.c                   |    6 
 sound/soc/sof/intel/hda-dsp.c                                  |   15 
 sound/soc/sunxi/sun4i-codec.c                                  |    5 
 tools/perf/builtin-inject.c                                    |    2 
 106 files changed, 1087 insertions(+), 502 deletions(-)

Adrian Hunter (1):
      perf inject: Fix repipe usage

Ahmed S. Darwish (1):
      net: xfrm: Localize sequence counter per network namespace

Al Viro (1):
      hostfs: fix memory handling in follow_link()

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

Andy Shevchenko (1):
      hostfs: Use kasprintf() instead of fixed buffer formatting

Anirudh Rayabharam (1):
      net: hso: fix null-ptr-deref during tty device unregistration

Arkadiusz Kubalewski (2):
      i40e: Fix sparse warning: missing error code 'err'
      i40e: Fix sparse error: 'vsi->netdev' could be null

Arnd Bergmann (1):
      soc/fsl: qbman: fix conflicting alignment attributes

Aya Levin (2):
      net/mlx5e: Fix ethtool indication of connector type
      net/mlx5: Fix PBMC register mapping

Bart Van Assche (2):
      scsi: ufs: Avoid busy-waiting by eliminating tag conflicts
      scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs

Bastian Germann (1):
      ASoC: sunxi: sun4i-codec: fill ASoC card owner

Can Guo (2):
      scsi: ufs: core: Fix task management request completion timeout
      scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs

Claudiu Beznea (1):
      net: macb: restore cmp registers on resume path

Claudiu Manoil (1):
      gianfar: Handle error code at MAC address change

Daniel Jurgens (1):
      net/mlx5: Don't request more than supported EQs

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Eric Dumazet (2):
      net: ensure mac header is set in virtio_net_hdr_to_skb()
      sch_red: fix off-by-one checks in red_check_params()

Eryk Rybak (2):
      i40e: Fix kernel oops when i40e driver removes VF's
      i40e: Fix display statistics for veb_tc

Eyal Birger (1):
      xfrm: interface: fix ipv4 pmtu check to honor ip header df

Fabio Pricoco (1):
      ice: Increase control queue timeout

Fabrice Gasnier (1):
      counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register

Florian Fainelli (1):
      net: phy: broadcom: Only advertise EEE for supported modes

Gao Xiang (1):
      parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Geert Uytterhoeven (1):
      regulator: bd9571mwv: Fix AVS and DVFS voltage range

Greg Kroah-Hartman (2):
      Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
      Linux 5.4.112

Guangbin Huang (1):
      net: hns3: clear VF down state bit before request link status

Guennadi Liakhovetski (1):
      ASoC: SOF: Intel: HDA: fix core status verification

Hans de Goede (1):
      ASoC: intel: atom: Stop advertising non working S24LE support

Helge Deller (1):
      parisc: parisc-agp requires SBA IOMMU driver

Ilya Maximets (1):
      openvswitch: fix send of uninitialized stack memory in ct limit reply

Jacek Bułatek (1):
      ice: Fix for dereference of NULL pointer

Jack Qiu (1):
      fs: direct-io: fix missing sdio->boundary

Johannes Berg (1):
      mac80211: fix TXQ AC confusion

John Fastabend (1):
      bpf, sockmap: Fix sk->prot unhash op reset

Jonas Holmberg (1):
      ALSA: aloop: Fix initialization of controls

Krzysztof Kozlowski (1):
      clk: socfpga: fix iomem pointer cast on 64-bit

Kumar Kartikeya Dwivedi (1):
      net: sched: bump refcount for new action in ACT replace mode

Kurt Kanzenbach (1):
      net: hsr: Reset MAC header for Tx path

Leon Romanovsky (1):
      RDMA/addr: Be strict with gid size

Luca Fancellu (1):
      xen/evtchn: Change irq_info lock to raw_spinlock_t

Lukasz Bartosik (2):
      clk: fix invalid usage of list cursor in register
      clk: fix invalid usage of list cursor in unregister

Lv Yunlong (3):
      ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx
      net:tipc: Fix a double free in tipc_sk_mcast_rcv
      net/rds: Fix a use after free in rds_message_map_pages

Maciej Żenczykowski (1):
      net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Marek Behún (1):
      ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Martin Blumenstingl (3):
      net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
      net: dsa: lantiq_gswip: Don't use PHY auto polling
      net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

Mateusz Palczewski (1):
      i40e: Added Asym_Pause to supported link modes

Mike Rapoport (1):
      nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Milton Miller (1):
      net/ncsi: Avoid channel_monitor hrtimer deadlock

Muhammad Usama Anjum (1):
      net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Nick Desaulniers (1):
      gcov: re-fix clang-11+ support

Norman Maurer (1):
      net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);

Oliver Hartkopp (1):
      can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Oliver Stäbler (1):
      arm64: dts: imx8mm/q: Fix pad control of SD1_DATA0

Paolo Abeni (1):
      net: let skb_orphan_partial wake-up waiters.

Pavel Skripkin (3):
      drivers: net: fix memory leak in atusb_probe
      drivers: net: fix memory leak in peak_usb_create_dev
      net: mac802154: Fix general protection fault

Pavel Tikhomirov (1):
      net: sched: sch_teql: fix null-pointer dereference

Payal Kshirsagar (1):
      ASoC: SOF: Intel: hda: remove unnecessary parentheses

Phillip Potter (1):
      net: tun: set tun->dev->addr_len during TUNSETLINK processing

Potnuri Bharat Teja (1):
      RDMA/cxgb4: check for ipv6 address properly while destroying listener

Raed Salem (1):
      net/mlx5: Fix placement of log_max_flow_counter

Rafał Miłecki (1):
      dt-bindings: net: ethernet-controller: fix typo in NVMEM

Rahul Lakkireddy (1):
      cxgb4: avoid collecting SGE_QBASE regs during traffic

Robert Malz (1):
      ice: Cleanup fltr list in case of allocation issues

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

Steffen Klassert (1):
      xfrm: Fix NULL pointer dereference on policy lookup

Stephen Boyd (1):
      drm/msm: Set drvdata to NULL when msm_drm_init() fails

Takashi Iwai (2):
      ALSA: hda/realtek: Fix speaker amp setup on Acer Aspire E1
      drm/i915: Fix invalid access to ACPI _DSM objects

Tetsuo Handa (1):
      batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Venkat Gopalakrishnan (1):
      scsi: ufs: Fix irq return code

Wengang Wang (1):
      ocfs2: fix deadlock between setattr and dio_end_io_write

William Roche (1):
      RAS/CEC: Correct ce_add_elem()'s returned values

Wolfram Sang (1):
      i2c: turn recovery error on init to debug

Xiaoming Ni (4):
      nfc: fix refcount leak in llcp_sock_bind()
      nfc: fix refcount leak in llcp_sock_connect()
      nfc: fix memory leak in llcp_sock_connect()
      nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xin Long (1):
      esp: delete NETIF_F_SCTP_CRC bit from features for esp offload

Yinjun Zhang (1):
      nfp: flower: ignore duplicate merge hints from FW

Yuya Kusakabe (1):
      virtio_net: Add XDP meta data support

Zheng Yongjun (1):
      net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()

Zqiang (1):
      workqueue: Move the position of debug_work_activate() in __queue_work()

