Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380844A61A6
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiBAQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:56:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42404 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiBAQ4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:56:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 715AA60AFF;
        Tue,  1 Feb 2022 16:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C29C340F0;
        Tue,  1 Feb 2022 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643734594;
        bh=ndMBIcfDkjQjfvbW+806aGc1LHv7c0k0qL3S5Avw86U=;
        h=From:To:Cc:Subject:Date:From;
        b=G4zbF/hA2BkcR7YlYDicO1Xpsc2S1XTjfFpzX40DIF8LkJyW6n2bN5NhfzcZcZZds
         vuFRci2fnfkyTaf62pdUghO4YOAKBsxed9nLK24nZZRE1b+HJSjrmncZyFaeAD4BYY
         uoxj/uhl7sy+EIYSVRxI8JYxrJqzIb3xPXvM/0JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.176
Date:   Tue,  1 Feb 2022 17:56:30 +0100
Message-Id: <1643734590118249@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.176 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/can/tcan4x5x.txt    |    2 
 Makefile                                                  |    2 
 arch/arm64/kernel/process.c                               |   39 ++--
 arch/powerpc/kernel/Makefile                              |    1 
 arch/powerpc/lib/Makefile                                 |    3 
 arch/s390/hypfs/hypfs_vm.c                                |    6 
 block/bio.c                                               |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c              |    4 
 drivers/gpu/drm/msm/dsi/dsi.c                             |    7 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                     |    4 
 drivers/gpu/drm/msm/hdmi/hdmi.c                           |    7 
 drivers/gpu/drm/msm/msm_drv.c                             |    2 
 drivers/hwmon/lm90.c                                      |    7 
 drivers/mtd/nand/raw/mpc5121_nfc.c                        |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    3 
 drivers/net/ethernet/ibm/ibmvnic.c                        |  112 ++++++++------
 drivers/net/ethernet/intel/i40e/i40e.h                    |    9 -
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c            |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c               |   44 ++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c        |   59 +++++++
 drivers/net/hamradio/yam.c                                |    4 
 drivers/net/phy/broadcom.c                                |    1 
 drivers/net/phy/phy_device.c                              |    6 
 drivers/net/phy/phylink.c                                 |    5 
 drivers/rpmsg/rpmsg_char.c                                |   22 --
 drivers/s390/scsi/zfcp_fc.c                               |   13 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                         |   20 --
 drivers/tty/n_gsm.c                                       |    4 
 drivers/tty/serial/8250/8250_of.c                         |   11 +
 drivers/tty/serial/8250/8250_pci.c                        |  100 ++++++++++++
 drivers/tty/serial/stm32-usart.c                          |    2 
 drivers/usb/common/ulpi.c                                 |    7 
 drivers/usb/core/hcd.c                                    |   14 +
 drivers/usb/core/urb.c                                    |   12 +
 drivers/usb/gadget/function/f_sourcesink.c                |    1 
 drivers/usb/storage/unusual_devs.h                        |   10 +
 drivers/usb/typec/tcpm/tcpm.c                             |    3 
 drivers/usb/typec/ucsi/ucsi_ccg.c                         |    2 
 fs/btrfs/ioctl.c                                          |    6 
 fs/configfs/dir.c                                         |    6 
 fs/devpts/inode.c                                         |    2 
 fs/namei.c                                                |   10 -
 fs/nfs/dir.c                                              |   22 ++
 fs/nfsd/nfsctl.c                                          |    5 
 fs/udf/inode.c                                            |    9 -
 include/linux/fsnotify.h                                  |   48 +++++-
 include/linux/netdevice.h                                 |    1 
 include/net/ip.h                                          |   21 +-
 include/net/ip6_fib.h                                     |    2 
 include/net/route.h                                       |    2 
 kernel/power/wakelock.c                                   |   11 -
 kernel/trace/trace.c                                      |    3 
 kernel/trace/trace_events_hist.c                          |    1 
 net/bluetooth/hci_event.c                                 |   10 -
 net/core/net-procfs.c                                     |   38 ++++
 net/ipv4/ip_output.c                                      |   11 +
 net/ipv4/ping.c                                           |    3 
 net/ipv4/raw.c                                            |    5 
 net/ipv6/ip6_fib.c                                        |   23 +-
 net/ipv6/ip6_tunnel.c                                     |    8 -
 net/ipv6/route.c                                          |    2 
 net/netfilter/nf_conntrack_core.c                         |    8 -
 net/netfilter/nft_payload.c                               |    3 
 net/packet/af_packet.c                                    |    2 
 net/rxrpc/call_event.c                                    |    8 -
 net/rxrpc/output.c                                        |    2 
 net/sunrpc/rpc_pipe.c                                     |    4 
 67 files changed, 585 insertions(+), 245 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Amir Goldstein (2):
      fsnotify: fix fsnotify hooks in pseudo filesystems
      fsnotify: invalidate dcache before IN_DELETE event

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Do not disconnect while receiving VBUS off

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Christophe Leroy (1):
      powerpc/32: Fix boot failure with GCC latent entropy plugin

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

D Scott Phillips (1):
      arm64: errata: Fix exec handling in erratum 1418040 workaround

David Howells (1):
      rxrpc: Adjust retransmission backoff

Eric Dumazet (5):
      ipv4: avoid using shared IP generator for connected sockets
      ipv6: annotate accesses to fn->fn_sernum
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages
      ipv4: remove sparse error in ip_neigh_gw4()

Florian Westphal (1):
      netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Geert Uytterhoeven (1):
      mtd: rawnand: mpc5121: Remove unused variable in ads5121_select_chip()

Greg Kroah-Hartman (2):
      PM: wakeup: simplify the output logic of pm_show_wakelocks()
      Linux 5.4.176

Guenter Roeck (4):
      hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649
      hwmon: (lm90) Mark alert as broken for MAX6680
      hwmon: (lm90) Reduce maximum conversion rate for G781
      hwmon: (lm90) Mark alert as broken for MAX6654

Hangyu Hua (1):
      yam: fix a memory leak in yam_siocdevprivate()

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jedrzej Jagielski (2):
      i40e: Increase delay to 1 s after global EMP reset
      i40e: Fix issue when maximum queues is exceeded

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Joe Damato (1):
      i40e: fix unsigned stat widths

John Meneghini (1):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Jon Hunter (1):
      usb: common: ulpi: Fix crash in ulpi_match()

José Expósito (1):
      drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable

Lucas Stach (1):
      drm/etnaviv: relax submit size limits

Marc Kleine-Budde (1):
      dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config

Marek Behún (2):
      net: sfp: ignore disabled SFP node
      phylib: fix potential use-after-free

Matthias Kaehlcke (1):
      rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Miaoqian Lin (2):
      drm/msm/dsi: Fix missing put_device() call in dsi_get_phy
      drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy

OGAWA Hirofumi (1):
      block: Fix wrong offset in bio_truncate()

Pablo Neira Ayuso (1):
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Pavankumar Kondeti (1):
      usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Robert Hancock (2):
      serial: 8250: of: Fix mapped region size when using reg-offset property
      net: phy: broadcom: hook up soft_reset for BCM54616S

Sing-Han Chen (1):
      ucsi_ccg: Check DEV_INT bit only when starting CCG4

Steffen Maier (1):
      scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Sujit Kautkar (1):
      rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Sukadev Bhattiprolu (2):
      ibmvnic: init ->running_cap_crqs early
      ibmvnic: don't spin in tasklet

Sylwester Dziedziuch (1):
      i40e: Fix queues reservation for XDP

Tom Zanussi (1):
      tracing: Don't inc err_log entry count if entry allocation fails

Trond Myklebust (4):
      NFSv4: Handle case where the lookup of a directory fails
      NFSv4: nfs_atomic_open() can race when looking up a non-regular file
      NFS: Ensure the server has an up to date ctime before hardlinking
      NFS: Ensure the server has an up to date ctime before renaming

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Xiaoke Wang (1):
      tracing/histogram: Fix a potential memory leak for kstrdup()

Xin Long (1):
      ping: fix the sk_bound_dev_if match in ping_lookup

Yufeng Mo (1):
      net: hns3: handle empty unknown interrupt for VF

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

