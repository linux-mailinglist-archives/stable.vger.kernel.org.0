Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B97241E12
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgHKQUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgHKQUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:20:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26BA420658;
        Tue, 11 Aug 2020 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162853;
        bh=/io0XuZUwQpqx0T0Qq06oJk3nMiGYApmJ030dgh2tMI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ot1NLiIeqIEI/es4ZSkRtAKFq/qTGsqNlAkAPro+AsPsgrEVz+ejdlHoYACpsmV2P
         PyZ1kFDx8GHdRD0wY0fVfMqv9QI8In16xcVYpB6yC27o04tO/Or+7woFUx5oE/28dS
         Qetn2bm7TVtyaKgqKaFszNlntcYrO3/H+QLff7Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.15
Date:   Tue, 11 Aug 2020 18:21:01 +0200
Message-Id: <1597162861249166@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.15 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arm64/kernel/kaslr.c                        |   12 --
 arch/powerpc/include/asm/kasan.h                 |    2 
 arch/powerpc/mm/init_32.c                        |    2 
 arch/powerpc/mm/kasan/kasan_init_32.c            |    4 
 drivers/android/binder.c                         |   15 ++
 drivers/atm/atmtcp.c                             |   10 +
 drivers/firmware/qemu_fw_cfg.c                   |    7 -
 drivers/gpio/gpio-max77620.c                     |    5 
 drivers/gpu/drm/bochs/bochs_kms.c                |    1 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c     |    1 
 drivers/gpu/drm/drm_fb_helper.c                  |    6 -
 drivers/gpu/drm/nouveau/dispnv50/disp.c          |    2 
 drivers/gpu/drm/nouveau/nouveau_fbcon.c          |    3 
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c   |    6 -
 drivers/i2c/i2c-core-slave.c                     |    7 -
 drivers/leds/leds-88pm860x.c                     |   14 ++
 drivers/leds/leds-da903x.c                       |   14 ++
 drivers/leds/leds-lm3533.c                       |   12 +-
 drivers/leds/leds-lm36274.c                      |   15 ++
 drivers/leds/leds-wm831x-status.c                |   14 ++
 drivers/misc/lkdtm/heap.c                        |    9 -
 drivers/mtd/mtdchar.c                            |   56 +++++++++--
 drivers/net/ethernet/cadence/macb_main.c         |   11 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    6 -
 drivers/net/ethernet/intel/igb/igb_main.c        |    9 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |    1 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c      |   19 ++-
 drivers/net/ethernet/mscc/ocelot.c               |   10 -
 drivers/net/hyperv/netvsc_drv.c                  |    7 -
 drivers/net/usb/hso.c                            |    5 
 drivers/net/usb/lan78xx.c                        |  117 +++++------------------
 drivers/net/vxlan.c                              |   10 +
 drivers/nvme/host/pci.c                          |    2 
 drivers/pci/controller/pci-tegra.c               |   32 ------
 drivers/scsi/ufs/ufshcd.c                        |    9 -
 drivers/staging/android/ashmem.c                 |   12 ++
 drivers/staging/rtl8188eu/core/rtw_mlme.c        |    4 
 drivers/staging/rtl8712/hal_init.c               |    3 
 drivers/staging/rtl8712/usb_intf.c               |   11 +-
 drivers/usb/host/xhci-pci.c                      |   10 +
 drivers/usb/misc/iowarrior.c                     |   35 ++++--
 drivers/usb/serial/qcserial.c                    |    1 
 drivers/video/console/vgacon.c                   |    4 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c       |    2 
 fs/io_uring.c                                    |    3 
 fs/xattr.c                                       |   84 +++++++++++++++-
 include/drm/drm_mode_config.h                    |   12 ++
 include/linux/rhashtable.h                       |   56 ++++-------
 include/linux/skbuff.h                           |    1 
 include/linux/xattr.h                            |    2 
 include/net/addrconf.h                           |    1 
 include/net/sch_generic.h                        |    3 
 kernel/bpf/btf.c                                 |    5 
 lib/rhashtable.c                                 |   35 +++---
 net/9p/trans_fd.c                                |   24 +++-
 net/appletalk/atalk_proc.c                       |    2 
 net/bluetooth/hci_event.c                        |   11 +-
 net/bridge/br_device.c                           |    2 
 net/core/devlink.c                               |   24 +++-
 net/ipv4/fib_trie.c                              |    2 
 net/ipv4/gre_offload.c                           |   13 ++
 net/ipv4/tcp_input.c                             |    2 
 net/ipv6/anycast.c                               |   17 ++-
 net/ipv6/ipv6_sockglue.c                         |    1 
 net/ipv6/route.c                                 |    8 -
 net/mptcp/protocol.c                             |    3 
 net/mptcp/subflow.c                              |    6 +
 net/openvswitch/conntrack.c                      |   38 +++----
 net/openvswitch/flow.c                           |    1 
 net/rxrpc/call_object.c                          |   27 +++--
 net/rxrpc/conn_object.c                          |    8 -
 net/rxrpc/recvmsg.c                              |    2 
 net/rxrpc/sendmsg.c                              |    3 
 net/sched/act_ct.c                               |    8 +
 net/sched/cls_api.c                              |    1 
 net/wireless/nl80211.c                           |    6 -
 scripts/coccinelle/misc/add_namespace.cocci      |    8 +
 scripts/nsdeps                                   |    2 
 security/integrity/ima/Kconfig                   |    2 
 security/integrity/ima/ima_appraise.c            |    6 +
 security/smack/smackfs.c                         |   13 ++
 sound/core/seq/oss/seq_oss.c                     |    8 +
 sound/pci/hda/hda_codec.c                        |    8 +
 sound/pci/hda/hda_intel.c                        |    1 
 sound/pci/hda/patch_ca0132.c                     |   12 +-
 sound/pci/hda/patch_realtek.c                    |  114 ++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c               |    1 
 tools/testing/selftests/net/msg_zerocopy.c       |    5 
 90 files changed, 777 insertions(+), 357 deletions(-)

Adam Ford (1):
      omapfb: dss: Fix max fclk divider for omap36xx

Ben Skeggs (3):
      drm/nouveau/kms/tu102: wait for core update to complete when assigning windows
      drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason
      drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Bruno Meneguele (1):
      ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime

Christoph Hellwig (1):
      net/9p: validate fds in p9_fd_open

Christophe Leroy (1):
      Revert "powerpc/kasan: Fix shadow pages allocation failure"

Cong Wang (1):
      ipv6: fix memory leaks on IPV6_ADDRFORM path

Connor McAdams (3):
      ALSA: hda/ca0132 - Add new quirk ID for Recon3D.
      ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.
      ALSA: hda/ca0132 - Fix AE-5 microphone selection commands.

David Howells (1):
      rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Dinghao Liu (1):
      Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

Dmitry Osipenko (1):
      gpio: max77620: Fix missing release of interrupt

Eric Biggers (1):
      Smack: fix use-after-free in smk_write_relabel_self()

Erik Ekman (1):
      USB: serial: qcserial: add EM7305 QDL product ID

Forest Crossman (2):
      usb: xhci: define IDs for various ASMedia host controllers
      usb: xhci: Fix ASMedia ASM1142 DMA addressing

Francesco Ruggeri (1):
      igb: reinit_locked() should be called with rtnl_lock

Frank van der Linden (1):
      xattr: break delegations in {set,remove}xattr

Greg Kroah-Hartman (3):
      USB: iowarrior: fix up report size handling for some devices
      mtd: properly check all write ioctls for permissions
      Linux 5.7.15

Guenter Roeck (1):
      arm64: kaslr: Use standard early random function

Hangbin Liu (1):
      Revert "vxlan: fix tos value before xmit"

Herbert Xu (1):
      rhashtable: Restore RCU marking on rhash_lock_head

Huacai Chen (1):
      ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops

Hui Wang (1):
      Revert "ALSA: hda: call runtime_allow() for all hda controllers"

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      vxlan: Ensure FDB dump is performed under RCU

Jakub Kicinski (1):
      devlink: ignore -EOPNOTSUPP errors on dumpit

Jann Horn (1):
      binder: Prevent context manager from incrementing ref 0

Jianfeng Wang (1):
      tcp: apply a floor of 1 for RTT samples from TCP timestamps

Jitao Shi (1):
      drm/panel: Fix auo, kd101n80-45na horizontal noise on edges of panel

Johan Hovold (6):
      leds: wm831x-status: fix use-after-free on unbind
      leds: lm36274: fix use-after-free on unbind
      leds: da903x: fix use-after-free on unbind
      leds: lm3533: fix use-after-free on unbind
      leds: 88pm860x: fix use-after-free on unbind
      net: lan78xx: replace bogus endpoint lookup

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Kai-Heng Feng (1):
      nvme-pci: prevent SK hynix PC400 from using Write Zeroes command

Kees Cook (1):
      lkdtm/heap: Avoid edge and middle of slabs

Laurentiu Palcu (1):
      drm/bridge/adv7511: set the bridge type properly

Lorenzo Bianconi (2):
      net: gre: recompute gre csum for sctp over gre tunnels
      net: mvpp2: fix memory leak in mvpp2_rx

Matthias Maennich (1):
      scripts: add dummy report mode to add_namespace.cocci

Nicolas Chauvet (1):
      PCI: tegra: Revert tegra124 raw_violation_fixup

Nikolay Aleksandrov (1):
      net: bridge: clear bridge's private skb space on xmit

Paolo Abeni (2):
      mptcp: be careful on subflow creation
      mptcp: fix bogus sendmsg() return code under pressure

Pavel Begunkov (1):
      io_uring: fix lockup in io_fail_links()

Peilin Ye (5):
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()
      bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
      openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Philippe Duplessis-Guindon (1):
      tools lib traceevent: Fix memory leak in process_dynamic_array_len

Qiushi Wu (1):
      firmware: Fix a reference count leak.

Ranjani Sridharan (1):
      ALSA: hda: fix NULL pointer dereference during suspend

René van Dorst (1):
      net: ethernet: mtk_eth_soc: Always call mtk_gmac0_rgmii_adjust() for mt7623

Rustam Kovhaev (2):
      staging: rtl8712: handle firmware load failure
      usb: hso: check for return value in hso_serial_common_create()

Sam Ravnborg (1):
      drm/drm_fb_helper: fix fbdev with sparc64

Stanley Chu (1):
      scsi: ufs: Fix and simplify setup_xfer_req variant operation

Stefan Roese (1):
      net: macb: Properly handle phylink on at91sam9x

Stephen Hemminger (1):
      hv_netvsc: do not use VF device if link is down

Suren Baghdasaryan (1):
      staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai (1):
      ALSA: seq: oss: Serialize ioctls

Vincent Duvert (1):
      appletalk: Fix atalk_proc_init() return path

Willem de Bruijn (1):
      selftests/net: relax cpu affinity requirement in msg_zerocopy test

Wolfram Sang (2):
      i2c: slave: improve sanity check when registering
      i2c: slave: add sanity check when unregistering

Xin Long (1):
      net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()

Xin Xiong (1):
      atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Xiyu Yang (1):
      ipv6: Fix nexthop refcnt leak when creating ipv6 route info

YueHaibing (1):
      dpaa2-eth: Fix passing zero to 'PTR_ERR' warning

Yunhai Zhang (1):
      vgacon: Fix for missing check in scrollback handling

laurent brando (1):
      net: mscc: ocelot: fix hardware timestamp dequeue logic

wenxu (1):
      net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct

