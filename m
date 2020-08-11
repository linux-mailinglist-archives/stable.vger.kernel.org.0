Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CF4241E1F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgHKQVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgHKQVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA212076C;
        Tue, 11 Aug 2020 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162876;
        bh=WbGv+uQid1lycEAJ2aFbuvf0wFqmWkvS5vHSghNCayk=;
        h=From:To:Cc:Subject:Date:From;
        b=XN33DoC4Kxmc67Tdi2xFeO2sLa3LVL4pjl+c+8X7avgIOIpRTgXgPUEqIk/GYegdE
         AJDU5AwkeKNxsVgweqDi7HxBZGUrcZxMSaB5llvgWdAYeexCcTaWgYC4fElJ3t0qRo
         ifg6YmDKDRs3/UTR6AbrBp1MIRBQyU14ZStu6guw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.139
Date:   Tue, 11 Aug 2020 18:21:16 +0200
Message-Id: <159716287625370@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.139 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 drivers/android/binder.c                           |   15 ++
 drivers/atm/atmtcp.c                               |   10 +
 drivers/firmware/qemu_fw_cfg.c                     |    7 -
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |    3 
 drivers/hv/channel_mgmt.c                          |   21 +--
 drivers/hv/vmbus_drv.c                             |    4 
 drivers/i2c/i2c-core-slave.c                       |    7 -
 drivers/leds/leds-88pm860x.c                       |   14 ++
 drivers/leds/leds-da903x.c                         |   14 ++
 drivers/leds/leds-lm3533.c                         |   12 +-
 drivers/leds/leds-wm831x-status.c                  |   14 ++
 drivers/mtd/mtdchar.c                              |   56 ++++++++--
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    4 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   51 ++++++---
 drivers/net/ethernet/intel/igb/igb_main.c          |    9 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    2 
 drivers/net/hyperv/netvsc_drv.c                    |    7 -
 drivers/net/usb/hso.c                              |    5 
 drivers/net/usb/lan78xx.c                          |  117 +++++----------------
 drivers/net/vxlan.c                                |   10 +
 drivers/staging/android/ashmem.c                   |   12 ++
 drivers/usb/host/xhci-pci.c                        |   10 +
 drivers/usb/misc/iowarrior.c                       |   35 ++++--
 drivers/usb/serial/qcserial.c                      |    1 
 drivers/video/console/vgacon.c                     |    4 
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |    2 
 fs/xattr.c                                         |   84 +++++++++++++--
 include/linux/hyperv.h                             |    2 
 include/linux/xattr.h                              |    2 
 include/net/addrconf.h                             |    1 
 net/9p/trans_fd.c                                  |   24 ++--
 net/bluetooth/hci_event.c                          |   11 +
 net/ipv4/fib_trie.c                                |    2 
 net/ipv4/gre_offload.c                             |   13 +-
 net/ipv6/anycast.c                                 |   17 ++-
 net/ipv6/ipv6_sockglue.c                           |    1 
 net/openvswitch/conntrack.c                        |   38 +++---
 net/rxrpc/call_object.c                            |   27 +++-
 net/rxrpc/conn_object.c                            |    8 -
 net/rxrpc/recvmsg.c                                |    2 
 net/rxrpc/sendmsg.c                                |    3 
 net/wireless/nl80211.c                             |    6 -
 security/smack/smackfs.c                           |   13 +-
 sound/core/seq/oss/seq_oss.c                       |    8 +
 sound/pci/hda/hda_intel.c                          |    1 
 tools/lib/traceevent/event-parse.c                 |    1 
 tools/testing/selftests/net/msg_zerocopy.c         |    5 
 48 files changed, 487 insertions(+), 230 deletions(-)

Adam Ford (1):
      omapfb: dss: Fix max fclk divider for omap36xx

Ben Skeggs (2):
      drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason
      drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Christoph Hellwig (1):
      net/9p: validate fds in p9_fd_open

Cong Wang (1):
      ipv6: fix memory leaks on IPV6_ADDRFORM path

David Howells (1):
      rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Dexuan Cui (1):
      Drivers: hv: vmbus: Ignore CHANNELMSG_TL_CONNECT_RESULT(23)

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
      Linux 4.19.139

Grzegorz Siwik (1):
      i40e: Wrong truncation from u16 to u8

Hangbin Liu (1):
      Revert "vxlan: fix tos value before xmit"

Hui Wang (1):
      Revert "ALSA: hda: call runtime_allow() for all hda controllers"

Ido Schimmel (2):
      ipv4: Silence suspicious RCU usage warning
      vxlan: Ensure FDB dump is performed under RCU

Jann Horn (1):
      binder: Prevent context manager from incrementing ref 0

Johan Hovold (5):
      leds: wm831x-status: fix use-after-free on unbind
      leds: da903x: fix use-after-free on unbind
      leds: lm3533: fix use-after-free on unbind
      leds: 88pm860x: fix use-after-free on unbind
      net: lan78xx: replace bogus endpoint lookup

Julian Squires (1):
      cfg80211: check vendor command doit pointer before use

Landen Chao (1):
      net: ethernet: mtk_eth_soc: fix MTU warnings

Lorenzo Bianconi (1):
      net: gre: recompute gre csum for sctp over gre tunnels

Martyna Szapar (2):
      i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
      i40e: Memory leak in i40e_config_iwarp_qvlist

Peilin Ye (4):
      Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()
      Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()
      openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Philippe Duplessis-Guindon (1):
      tools lib traceevent: Fix memory leak in process_dynamic_array_len

Qiushi Wu (1):
      firmware: Fix a reference count leak.

Rustam Kovhaev (1):
      usb: hso: check for return value in hso_serial_common_create()

Sergey Nemov (1):
      i40e: add num_vectors checker in iwarp handler

Stephen Hemminger (1):
      hv_netvsc: do not use VF device if link is down

Suren Baghdasaryan (1):
      staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai (1):
      ALSA: seq: oss: Serialize ioctls

Willem de Bruijn (1):
      selftests/net: relax cpu affinity requirement in msg_zerocopy test

Wolfram Sang (2):
      i2c: slave: improve sanity check when registering
      i2c: slave: add sanity check when unregistering

Xin Long (1):
      net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()

Xin Xiong (1):
      atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Yunhai Zhang (1):
      vgacon: Fix for missing check in scrollback handling

