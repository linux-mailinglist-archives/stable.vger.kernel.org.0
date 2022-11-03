Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72826618067
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiKCPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiKCPCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C7E19C1F;
        Thu,  3 Nov 2022 08:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05F1A61F27;
        Thu,  3 Nov 2022 15:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295CCC433C1;
        Thu,  3 Nov 2022 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487748;
        bh=fOEeKvy47kXB46FLcr8UVCLN6Yee3fgMFXBTz5lVyC0=;
        h=From:To:Cc:Subject:Date:From;
        b=bgsvQhJRuF50mnpu794rVzaDp7WB6iMuT9mmOxYBcRstw52Dkqfdq8lZjpt5lCLu2
         PLnzmXvNdRq3uUur2ksEGa8onlTehuDlV3799Krz0dONmYRFlSy1aAetLEY63DTtqS
         kj9yKMc6LfUKL1wrpdpFcP4l6y6pLkV2IzD78/cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.223
Date:   Fri,  4 Nov 2022 00:03:00 +0900
Message-Id: <166748778013044@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.223 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arc/include/asm/io.h                                |    2 
 arch/arc/mm/ioremap.c                                    |    2 
 arch/s390/include/asm/futex.h                            |    3 
 arch/s390/pci/pci_mmio.c                                 |    8 -
 arch/x86/kernel/unwind_orc.c                             |    2 
 drivers/base/power/domain.c                              |    4 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c      |    5 
 drivers/gpu/drm/msm/dsi/dsi.c                            |    6 
 drivers/gpu/drm/msm/hdmi/hdmi.c                          |    5 
 drivers/iio/light/tsl2583.c                              |    2 
 drivers/media/platform/vivid/vivid-core.c                |   22 +++
 drivers/media/platform/vivid/vivid-core.h                |    2 
 drivers/media/platform/vivid/vivid-vid-cap.c             |   27 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c                |   14 ++
 drivers/mmc/core/sdio_bus.c                              |    3 
 drivers/mtd/nand/raw/marvell_nand.c                      |    2 
 drivers/net/can/mscan/mpc5xxx_can.c                      |    8 -
 drivers/net/can/rcar/rcar_canfd.c                        |    6 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c        |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c         |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c              |   17 +-
 drivers/net/ethernet/freescale/enetc/enetc.c             |    5 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c           |  100 +++++++++------
 drivers/net/ethernet/intel/i40e/i40e_type.h              |    4 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c       |   43 ++++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h       |    1 
 drivers/net/ethernet/lantiq_etop.c                       |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c            |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c |    3 
 drivers/net/ethernet/micrel/ksz884x.c                    |    2 
 drivers/net/ethernet/socionext/netsec.c                  |    2 
 drivers/usb/core/quirks.c                                |    9 +
 drivers/usb/dwc3/gadget.c                                |    8 -
 drivers/usb/gadget/udc/bdc/bdc_udc.c                     |    1 
 drivers/usb/host/xhci-mem.c                              |   20 +--
 drivers/usb/host/xhci-pci.c                              |    8 +
 drivers/video/fbdev/smscufx.c                            |   55 ++++----
 drivers/xen/gntdev.c                                     |   30 +++-
 fs/kernfs/dir.c                                          |    5 
 fs/xfs/xfs_bmap_util.c                                   |    2 
 fs/xfs/xfs_file.c                                        |   17 ++
 fs/xfs/xfs_qm.c                                          |    1 
 include/linux/mlx5/driver.h                              |    2 
 include/media/v4l2-common.h                              |    3 
 include/uapi/linux/videodev2.h                           |    3 
 kernel/cgroup/cgroup-v1.c                                |    3 
 kernel/power/hibernate.c                                 |    2 
 mm/hugetlb.c                                             |    2 
 net/can/j1939/transport.c                                |    4 
 net/core/net_namespace.c                                 |    7 +
 net/ieee802154/socket.c                                  |    4 
 net/ipv4/nexthop.c                                       |    2 
 net/ipv4/tcp_input.c                                     |    3 
 net/kcm/kcmsock.c                                        |   23 ++-
 net/mac802154/rx.c                                       |    5 
 net/openvswitch/datapath.c                               |    3 
 net/tipc/topsrv.c                                        |   16 +-
 sound/aoa/soundbus/i2sbus/core.c                         |    7 -
 sound/pci/ac97/ac97_codec.c                              |    1 
 sound/pci/au88x0/au88x0.h                                |    6 
 sound/pci/au88x0/au88x0_core.c                           |    2 
 sound/synth/emux/emux.c                                  |    7 -
 tools/iio/iio_utils.c                                    |    4 
 tools/perf/util/auxtrace.c                               |   10 +
 66 files changed, 422 insertions(+), 175 deletions(-)

Aaron Conole (1):
      openvswitch: switch from WARN to pr_warn

Adrian Hunter (1):
      perf auxtrace: Fix address filter symbol name match for modules

Alexander Stein (1):
      media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Anssi Hannula (1):
      can: kvaser_usb: Fix possible completions during init_completion

Biju Das (1):
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Chandan Babu R (3):
      xfs: finish dfops on every insert range shift iteration
      xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
      xfs: force the log after remapping a synchronous-writes file

Chen Zhongjin (1):
      x86/unwind/orc: Fix unreliable stack dump with gcov

Chen Zhou (1):
      cgroup-v1: add disabled controller check in cgroup1_parse_param()

Christian A. Ehrhardt (1):
      kernfs: fix use-after-free in __kernfs_remove

Dongliang Mu (1):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Eric Dumazet (2):
      kcm: annotate data-races around kcm->rx_psock
      kcm: annotate data-races around kcm->rx_wait

Greg Kroah-Hartman (1):
      Linux 5.4.223

Hannu Hartikainen (1):
      USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Hans Verkuil (4):
      media: vivid: s_fbuf: add more sanity checks
      media: vivid: dev->bitmap_cap wasn't freed in all cases
      media: v4l2-dv-timings: add sanity checks for blanking values
      media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'

Heiko Carstens (2):
      s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
      s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Hyong Youb Kim (1):
      net/mlx5e: Do not increment ESN when updating IPsec ESN state

Hyunwoo Kim (1):
      fbdev: smscufx: Fix several use-after-free bugs

Jan Beulich (1):
      Xen/gntdev: don't ignore kernel unmapping error

Jason A. Donenfeld (1):
      ALSA: au88x0: use explicitly signed char

Jens Glathe (1):
      usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Johan Hovold (2):
      drm/msm/dsi: fix memory corruption with too many bridges
      drm/msm/hdmi: fix memory corruption with too many bridges

Justin Chen (1):
      usb: bdc: change state when port disconnected

M. Vefa Bicakci (1):
      xen/gntdev: Prevent leaking grants

Mario Limonciello (1):
      PM: hibernate: Allow hybrid sleep to work with s2idle

Mathias Nyman (1):
      xhci: Remove device endpoints from bandwidth list when freeing the device

Matthew Ma (1):
      mmc: core: Fix kernel panic when remove non-standard SDIO card

Matti Vaittinen (1):
      tools: iio: iio_utils: fix digit calculation

Miquel Raynal (1):
      mac802154: Fix LQI recording

Nathan Huckleberry (1):
      drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Neal Cardwell (1):
      tcp: fix indefinite deferral of RTO with SACK reneging

Nicolas Dichtel (1):
      nh: fix scope used to find saddr when adding non gw nh

Raju Rangoju (2):
      amd-xgbe: fix the SFP compliance codes check for DAC cables
      amd-xgbe: add the bit rate quirk for Molex cables

Randy Dunlap (1):
      arc: iounmap() arg is volatile

Rik van Riel (1):
      mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Shreeya Patel (1):
      iio: light: tsl2583: Fix module unloading

Slawomir Laba (2):
      i40e: Fix ethtool rx-flow-hash setting for X722
      i40e: Fix flow-type by setting GL_HASH_INSET registers

Steven Rostedt (Google) (1):
      ALSA: Use del_timer_sync() before freeing timer

Sudeep Holla (1):
      PM: domains: Fix handling of unavailable/disabled idle states

Sylwester Dziedziuch (1):
      i40e: Fix VF hang when reset is triggered on another VF

Takashi Iwai (1):
      ALSA: aoa: Fix I2S device accounting

Tariq Toukan (1):
      net/mlx5: Fix possible use-after-free in async command interface

Thinh Nguyen (2):
      usb: dwc3: gadget: Stop processing more requests on IMI
      usb: dwc3: gadget: Don't set IMI for no_interrupt

Tony O'Brien (1):
      mtd: rawnand: marvell: Use correct logic for nand-keep-config

Vladimir Oltean (1):
      net: enetc: survive memory pressure without crashing

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

Xin Long (1):
      tipc: fix a null-ptr-deref in tipc_topsrv_accept

Yang Yingliang (6):
      can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
      ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
      net: netsec: fix error handling in netsec_register_mdio()
      net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
      ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
      net: ehea: fix possible memory leak in ehea_register_port()

Zhang Changzhong (1):
      net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao (1):
      net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed

