Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E32D52B566
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiERIxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiERIx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F2C6EC44;
        Wed, 18 May 2022 01:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B15F616D2;
        Wed, 18 May 2022 08:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821F1C34100;
        Wed, 18 May 2022 08:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652864006;
        bh=ffFSiCHYQIj3T2fF8dkTSudfF7Abxa7V/z7x8EBWznU=;
        h=From:To:Cc:Subject:Date:From;
        b=fn3ZlYBqbKsMukkWKmB2fgyon2e/Qdk4ogAuHF5Ay34JbiNdO5Vgwf+PKKH0yuR29
         x4RUY+te5GPEOagiTgiVM7x/TVEmeHjyTZMoArkkU8As73/e24oMeUwjRDNW0L7fOF
         bnc1d5aamHuPbBluW5+fmKAp3s/dMHhUj9LatG1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.117
Date:   Wed, 18 May 2022 10:53:18 +0200
Message-Id: <165286399817240@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.117 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm/include/asm/io.h                            |    3 +
 arch/arm/mm/ioremap.c                                |    8 +++
 arch/arm64/include/asm/io.h                          |    4 +
 arch/arm64/mm/ioremap.c                              |    9 +++
 arch/s390/Makefile                                   |   10 ++++
 drivers/base/firmware_loader/main.c                  |   17 +++++++
 drivers/gpu/drm/nouveau/nouveau_backlight.c          |    9 ++-
 drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c   |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                   |    2 
 drivers/hwmon/Kconfig                                |    2 
 drivers/hwmon/f71882fg.c                             |    5 +-
 drivers/hwmon/tmp401.c                               |   11 ++++
 drivers/net/dsa/bcm_sf2.c                            |    3 +
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    4 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c       |    4 +
 drivers/net/ethernet/intel/i40e/i40e_main.c          |   27 +++++------
 drivers/net/ethernet/mscc/ocelot_flower.c            |    5 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c              |    9 +++
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c  |    3 -
 drivers/net/ethernet/sfc/ef10.c                      |    5 ++
 drivers/net/ethernet/sfc/efx_channels.c              |   21 ++++----
 drivers/net/ethernet/sfc/ptp.c                       |   14 +++++
 drivers/net/ethernet/sfc/ptp.h                       |    1 
 drivers/net/ethernet/xilinx/xilinx_emaclite.c        |   15 ------
 drivers/net/phy/phy.c                                |   45 ++++++++++++++++---
 drivers/net/phy/sfp.c                                |   12 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c     |    2 
 drivers/net/wireless/mac80211_hwsim.c                |    3 +
 drivers/s390/net/ctcm_mpc.c                          |    6 --
 drivers/s390/net/ctcm_sysfs.c                        |    5 +-
 drivers/s390/net/lcs.c                               |    7 +-
 drivers/slimbus/qcom-ctrl.c                          |    4 -
 drivers/tty/n_gsm.c                                  |   12 +++--
 drivers/tty/serial/8250/8250_mtk.c                   |   22 +++++----
 drivers/tty/serial/digicolor-usart.c                 |    5 --
 drivers/usb/class/cdc-wdm.c                          |    1 
 drivers/usb/gadget/function/f_uvc.c                  |   32 ++++++++++++-
 drivers/usb/gadget/function/uvc.h                    |    2 
 drivers/usb/gadget/function/uvc_v4l2.c               |    3 -
 drivers/usb/serial/option.c                          |    4 +
 drivers/usb/serial/pl2303.c                          |    1 
 drivers/usb/serial/pl2303.h                          |    1 
 drivers/usb/serial/qcserial.c                        |    2 
 drivers/usb/typec/tcpm/tcpci.c                       |    2 
 drivers/usb/typec/tcpm/tcpci_mt6360.c                |   26 ++++++++++
 fs/ceph/file.c                                       |   16 +++++-
 fs/file_table.c                                      |    1 
 fs/gfs2/bmap.c                                       |   11 ++--
 fs/io_uring.c                                        |    2 
 fs/nfs/fs_context.c                                  |    2 
 include/linux/netdev_features.h                      |    4 -
 include/linux/sunrpc/xprtsock.h                      |    1 
 include/net/tc_act/tc_pedit.h                        |    1 
 include/trace/events/sunrpc.h                        |    1 
 kernel/cgroup/cpuset.c                               |    7 ++
 lib/dim/net_dim.c                                    |   44 +++++++++---------
 net/batman-adv/fragmentation.c                       |   11 ++++
 net/core/secure_seq.c                                |   12 +++--
 net/ipv4/ping.c                                      |   15 +++++-
 net/ipv4/route.c                                     |    1 
 net/mac80211/mlme.c                                  |    6 ++
 net/netlink/af_netlink.c                             |    1 
 net/sched/act_pedit.c                                |   26 +++++++++-
 net/smc/smc_rx.c                                     |    4 -
 net/sunrpc/rpc_pipe.c                                |    1 
 net/sunrpc/xprt.c                                    |   36 +++++++--------
 net/sunrpc/xprtsock.c                                |   37 ++++++++++-----
 net/tls/tls_device.c                                 |    3 +
 sound/soc/codecs/max98090.c                          |    5 +-
 sound/soc/soc-ops.c                                  |   18 +++++++
 tools/testing/selftests/vm/Makefile                  |   10 ++--
 72 files changed, 485 insertions(+), 183 deletions(-)

Alexandra Winter (3):
      s390/ctcm: fix variable dereferenced before check
      s390/ctcm: fix potential memory leak
      s390/lcs: fix variable dereferenced before check

Andreas Gruenbacher (1):
      gfs2: Fix filesystem block deallocation for short writes

AngeloGioacchino Del Regno (2):
      serial: 8250_mtk: Fix UART_EFR register address
      serial: 8250_mtk: Fix register address for XON/XOFF character

Camel Guo (1):
      hwmon: (tmp401) Add OF device ID table

ChiYuan Huang (1):
      usb: typec: tcpci_mt6360: Update for BMC PHY setting

Christophe JAILLET (1):
      drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()

Dan Aloni (1):
      nfs: fix broken handling of the softreval mount option

Dan Vacura (1):
      usb: gadget: uvc: allow for application to cleanly shutdown

Daniel Starke (1):
      tty: n_gsm: fix mux activation issues in gsm_config()

Eric Dumazet (2):
      netlink: do not reset transport header in netlink_recvmsg()
      tcp: resalt the secret every 10 seconds

Ethan Yang (1):
      USB: serial: qcserial: add support for Sierra Wireless EM7590

Florian Fainelli (2):
      net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
      net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()

Francesco Dolcini (1):
      net: phy: Fix race condition on link status change

Greg Kroah-Hartman (1):
      Linux 5.10.117

Guangguan Wang (1):
      net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Guenter Roeck (1):
      iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

Gustavo A. R. Silva (1):
      SUNRPC: Fix fall-through warnings for Clang

Jeff Layton (1):
      ceph: fix setting of xattrs on async created inodes

Jens Axboe (1):
      io_uring: always use original task when preparing req identity

Jesse Brandeburg (1):
      dim: initialize all struct fields

Ji-Ze Hong (Peter Hong) (1):
      hwmon: (f71882fg) Fix negative temperature

Jiapeng Chong (1):
      sfc: Use swap() instead of open coding it

Joel Savitz (1):
      selftests: vm: Makefile: rename TARGETS to VMTARGETS

Johannes Berg (1):
      mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Lokesh Dhoundiyal (1):
      ipv4: drop dst in multicast routing path

Manikanta Pubbisetty (1):
      mac80211: Reset MBSSID parameters upon connection

Manuel Ullmann (1):
      net: atlantic: always deep reset on pm op, fixing up my null deref regression

Mark Brown (3):
      ASoC: max98090: Reject invalid values in custom control put()
      ASoC: max98090: Generate notifications on changes for custom control
      ASoC: ops: Validate input values in snd_soc_put_volsw_range()

Matthew Hagan (1):
      net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT

Maxim Mikityanskiy (1):
      tls: Fix context leak on tls_device_down

Miaoqian Lin (1):
      slimbus: qcom: Fix IRQ check in qcom_slim_probe

Michael Tretter (1):
      usb: gadget: uvc: rename function to be more consistent

Mike Rapoport (1):
      arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map

Nicolas Dichtel (1):
      ping: fix address binding wrt vrf

Paolo Abeni (1):
      net/sched: act_pedit: really ensure the skb is writable

Randy Dunlap (1):
      hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Robin Murphy (1):
      drm/nouveau/tegra: Stop using iommu_present()

Scott Chen (1):
      USB: serial: pl2303: add device id for HP LM930 Display

Sergey Ryazanov (1):
      usb: cdc-wdm: fix reading stuck on device close

Shravya Kumbham (1):
      net: emaclite: Don't advertise 1000BASE-T and do auto negotiation

Sven Eckelmann (1):
      batman-adv: Don't skb_split skbuffs with frag_list

Sven Schnelle (1):
      s390: disable -Warray-bounds

Sven Schwermer (2):
      USB: serial: option: add Fibocom L610 modem
      USB: serial: option: add Fibocom MA510 modem

Taehee Yoo (2):
      net: sfc: fix memory leak due to ptp channel
      net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Tariq Toukan (1):
      net: Fix features skip in for_each_netdev_feature()

Thiébaud Weksteen (1):
      firmware_loader: use kernel credentials when reading firmware

Trond Myklebust (4):
      SUNRPC: Clean up scheduling of autoclose
      SUNRPC: Prevent immediate close+reconnect
      SUNRPC: Don't call connect() more than once on a TCP socket
      SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Uwe Kleine-König (1):
      usb: typec: tcpci: Don't skip cleanup in .remove() on error

Vladimir Oltean (4):
      net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
      net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
      net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
      net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters

Waiman Long (1):
      cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Xiaomeng Tong (1):
      i40e: i40e_main: fix a missing check on list iterator

Yang Yingliang (2):
      ionic: fix missing pci_release_regions() on error in ionic_probe()
      tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Zack Rusin (1):
      drm/vmwgfx: Initialize drm_mode_fb_cmd2

