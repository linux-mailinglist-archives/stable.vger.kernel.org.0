Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120714ADFEA
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiBHRyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352766AbiBHRyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:54:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3D4C061579;
        Tue,  8 Feb 2022 09:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836EFB81CA5;
        Tue,  8 Feb 2022 17:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45178C004E1;
        Tue,  8 Feb 2022 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342887;
        bh=PXqWBuNMwcBti6POF7jxCab7d/1oiSuHAH+hwQqqJ04=;
        h=From:To:Cc:Subject:Date:From;
        b=TRDIpboaQ2fvUBiZaQoAlzYeZVEei5Y1dY0Kud/msIqcicBLwTNWJrv0j/fzF1IIG
         JL7Byr2Z2TO+GNX20Psyx/B02/6OwxCxEx11TzZ6f9xIqvTOyW3YoUGULlo+GYqtb+
         qddXeVJWaRwJqV5HfomjDFDskGgiS/AY5Qsb30HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.300
Date:   Tue,  8 Feb 2022 18:54:42 +0100
Message-Id: <16443428839687@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.300 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/powerpc/kernel/Makefile                    |    1 
 arch/powerpc/lib/Makefile                       |    3 
 arch/s390/hypfs/hypfs_vm.c                      |    6 -
 drivers/edac/altera_edac.c                      |    2 
 drivers/edac/xgene_edac.c                       |    2 
 drivers/gpu/drm/msm/msm_drv.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |    2 
 drivers/hwmon/lm90.c                            |    2 
 drivers/iommu/amd_iommu_init.c                  |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c        |   14 +++
 drivers/net/macsec.c                            |    9 ++
 drivers/net/usb/ipheth.c                        |    6 -
 drivers/rtc/rtc-mc146818-lib.c                  |    2 
 drivers/s390/scsi/zfcp_fc.c                     |   13 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   41 ++++-----
 drivers/spi/spi-bcm-qspi.c                      |    2 
 drivers/spi/spi-mt65xx.c                        |    2 
 drivers/tty/n_gsm.c                             |    4 
 drivers/tty/serial/8250/8250_pci.c              |  100 +++++++++++++++++++++++-
 drivers/tty/serial/stm32-usart.c                |    2 
 drivers/usb/core/hcd.c                          |   14 +++
 drivers/usb/core/urb.c                          |   12 ++
 drivers/usb/gadget/function/f_sourcesink.c      |    1 
 drivers/usb/storage/unusual_devs.h              |   10 ++
 fs/ext4/inline.c                                |   10 ++
 fs/nfs/dir.c                                    |   18 ++++
 fs/nfsd/nfs4state.c                             |    4 
 fs/udf/inode.c                                  |    9 --
 include/linux/netdevice.h                       |    1 
 include/net/ip.h                                |   21 ++---
 include/net/netfilter/nf_nat_l4proto.h          |    2 
 kernel/power/wakelock.c                         |   12 --
 net/bluetooth/hci_event.c                       |   10 +-
 net/can/bcm.c                                   |   20 ++--
 net/core/net-procfs.c                           |   38 ++++++++-
 net/core/rtnetlink.c                            |    6 -
 net/ieee802154/nl802154.c                       |    8 -
 net/ipv4/ip_output.c                            |   11 ++
 net/ipv4/raw.c                                  |    5 -
 net/ipv6/ip6_tunnel.c                           |    8 -
 net/netfilter/nf_nat_proto_common.c             |   36 ++++++--
 net/netfilter/nf_nat_proto_dccp.c               |    5 -
 net/netfilter/nf_nat_proto_sctp.c               |    5 -
 net/netfilter/nf_nat_proto_tcp.c                |    5 -
 net/netfilter/nf_nat_proto_udp.c                |    5 -
 net/netfilter/nf_nat_proto_udplite.c            |    5 -
 net/packet/af_packet.c                          |   10 +-
 sound/soc/fsl/pcm030-audio-fabric.c             |   11 +-
 sound/soc/soc-ops.c                             |   29 ++++++
 50 files changed, 409 insertions(+), 141 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Benjamin Gaignard (1):
      spi: mediatek: Avoid NULL pointer crash in interrupt

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Christophe Leroy (1):
      powerpc/32: Fix boot failure with GCC latent entropy plugin

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

Dai Ngo (1):
      nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

Eric Dumazet (5):
      ipv4: avoid using shared IP generator for connected sockets
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages
      rtnetlink: make sure to refresh master_dev/m_ops in __rtnl_newlink()
      af_packet: fix data-race in packet_setsockopt / packet_setsockopt

Florian Westphal (2):
      netfilter: nat: remove l4 protocol port rovers
      netfilter: nat: limit port clash resolution attempts

Georgi Valkov (1):
      ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

Greg Kroah-Hartman (2):
      PM: wakeup: simplify the output logic of pm_show_wakelocks()
      Linux 4.9.300

Guenter Roeck (1):
      hwmon: (lm90) Reduce maximum conversion rate for G781

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Joerg Roedel (1):
      iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()

John Meneghini (2):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()
      scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Kamal Dasu (1):
      spi: bcm-qspi: check for valid cs before applying chip select

Lior Nahmanson (1):
      net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Mark Brown (3):
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
      ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Miaoqian Lin (1):
      ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Miquel Raynal (1):
      net: ieee802154: Return meaningful error codes from the netlink helpers

Nick Lopez (1):
      drm/nouveau: fix off by one in BIOS boundary checking

Pavankumar Kondeti (1):
      usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Raju Rangoju (1):
      net: amd-xgbe: ensure to reset the tx_timer_active flag

Ritesh Harjani (1):
      ext4: fix error handling in ext4_restore_inline_data()

Riwen Lu (1):
      rtc: cmos: Evaluate century appropriate

Sergey Shtylyov (2):
      EDAC/altera: Fix deferred probing
      EDAC/xgene: Fix deferred probing

Shyam Sundar S K (1):
      net: amd-xgbe: Fix skb data length underflow

Steffen Maier (1):
      scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Trond Myklebust (2):
      NFSv4: Handle case where the lookup of a directory fails
      NFSv4: nfs_atomic_open() can race when looking up a non-regular file

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Ziyang Xuan (1):
      can: bcm: fix UAF of bcm op

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

