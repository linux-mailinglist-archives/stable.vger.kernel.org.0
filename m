Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE4E4ADFF1
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380724AbiBHRy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352766AbiBHRy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:54:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B472CC0613C9;
        Tue,  8 Feb 2022 09:54:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FA38B81CBA;
        Tue,  8 Feb 2022 17:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C04C340EC;
        Tue,  8 Feb 2022 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342895;
        bh=IuW90oNzwf6fPYlTgMqjNPx5vkCGyymY1ZojgOBus74=;
        h=From:To:Cc:Subject:Date:From;
        b=l3Dj6CPvc+VwQgpvDkn4wY0hnai5jGkRV4V6PPoGED6HX54oPOTtGt6neIqslsgk3
         rYqHx01qKgfJ/arUdp0FHRFOlPMr0BWUau1sGF0m1VFn+IRH+klKFhcvrsLyH43zj2
         2Ut3alP+PQeiLLC/2oJNH/dJQUGhT2kpnCr1oOlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.265
Date:   Tue,  8 Feb 2022 18:54:47 +0100
Message-Id: <1644342887240235@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 4.14.265 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/powerpc/kernel/Makefile                    |    1 
 arch/powerpc/lib/Makefile                       |    3 
 arch/s390/hypfs/hypfs_vm.c                      |    6 -
 block/bio-integrity.c                           |    2 
 drivers/edac/altera_edac.c                      |    2 
 drivers/edac/xgene_edac.c                       |    2 
 drivers/gpu/drm/i915/intel_overlay.c            |    3 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c           |    4 
 drivers/gpu/drm/msm/msm_drv.c                   |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |    2 
 drivers/hwmon/lm90.c                            |    2 
 drivers/infiniband/hw/mlx4/main.c               |    2 
 drivers/iommu/amd_iommu_init.c                  |    2 
 drivers/iommu/intel_irq_remapping.c             |   13 ++-
 drivers/misc/Makefile                           |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c        |   14 +++
 drivers/net/ethernet/ibm/ibmvnic.c              |    6 -
 drivers/net/ethernet/intel/i40e/i40e.h          |    8 -
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c  |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c     |   16 +--
 drivers/net/hamradio/yam.c                      |    4 
 drivers/net/ieee802154/ca8210.c                 |    1 
 drivers/net/macsec.c                            |    9 ++
 drivers/net/phy/phylink.c                       |    5 +
 drivers/net/usb/ipheth.c                        |    6 -
 drivers/rpmsg/rpmsg_char.c                      |   22 -----
 drivers/rtc/rtc-mc146818-lib.c                  |    2 
 drivers/s390/scsi/zfcp_fc.c                     |   13 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   41 ++++-----
 drivers/spi/spi-bcm-qspi.c                      |    2 
 drivers/spi/spi-meson-spicc.c                   |    5 +
 drivers/spi/spi-mt65xx.c                        |    2 
 drivers/staging/typec/tcpm.c                    |    3 
 drivers/tty/n_gsm.c                             |    4 
 drivers/tty/serial/8250/8250_pci.c              |  100 +++++++++++++++++++++++-
 drivers/tty/serial/stm32-usart.c                |    2 
 drivers/usb/common/ulpi.c                       |    7 +
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
 kernel/audit.c                                  |   62 ++++++++++----
 kernel/bpf/core.c                               |   59 ++++++++++++--
 kernel/power/wakelock.c                         |   12 --
 net/bluetooth/hci_event.c                       |   10 +-
 net/core/filter.c                               |   11 ++
 net/core/net-procfs.c                           |   38 ++++++++-
 net/core/rtnetlink.c                            |    6 -
 net/ieee802154/nl802154.c                       |    8 -
 net/ipv4/ip_output.c                            |   11 ++
 net/ipv4/ping.c                                 |    3 
 net/ipv4/raw.c                                  |    5 -
 net/ipv6/ip6_tunnel.c                           |    8 -
 net/netfilter/nf_nat_proto_common.c             |   36 ++++++--
 net/netfilter/nf_nat_proto_dccp.c               |    5 -
 net/netfilter/nf_nat_proto_sctp.c               |    5 -
 net/netfilter/nf_nat_proto_tcp.c                |    5 -
 net/netfilter/nf_nat_proto_udp.c                |   10 --
 net/netfilter/nft_payload.c                     |    3 
 net/packet/af_packet.c                          |   10 +-
 sound/soc/fsl/pcm030-audio-fabric.c             |   11 +-
 sound/soc/soc-ops.c                             |   29 ++++++
 tools/testing/selftests/futex/Makefile          |    4 
 71 files changed, 561 insertions(+), 216 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Do not disconnect while receiving VBUS off

Benjamin Gaignard (1):
      spi: mediatek: Avoid NULL pointer crash in interrupt

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Christophe Leroy (2):
      powerpc/32: Fix boot failure with GCC latent entropy plugin
      lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

Dai Ngo (1):
      nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

Dan Carpenter (1):
      drm/i915/overlay: Prevent divide by zero bugs in scaling

Daniel Borkmann (1):
      bpf: fix truncated jump targets on heavy expansions

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
      Linux 4.14.265

Guenter Roeck (1):
      hwmon: (lm90) Reduce maximum conversion rate for G781

Guoqing Jiang (1):
      iommu/vt-d: Fix potential memory leak in intel_setup_irq_remapping()

Hangyu Hua (1):
      yam: fix a memory leak in yam_siocdevprivate()

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jedrzej Jagielski (1):
      i40e: Increase delay to 1 s after global EMP reset

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Joe Damato (1):
      i40e: fix unsigned stat widths

Joerg Roedel (1):
      iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()

John Meneghini (2):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()
      scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Jon Hunter (1):
      usb: common: ulpi: Fix crash in ulpi_match()

José Expósito (1):
      drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable

Kamal Dasu (1):
      spi: bcm-qspi: check for valid cs before applying chip select

Leon Romanovsky (1):
      RDMA/mlx4: Don't continue event handler after memory allocation failure

Lior Nahmanson (1):
      net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Marek Behún (1):
      net: sfp: ignore disabled SFP node

Mark Brown (3):
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
      ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Martin K. Petersen (1):
      block: bio-integrity: Advance seed correctly for larger interval sizes

Matthias Kaehlcke (1):
      rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Miaoqian Lin (2):
      spi: meson-spicc: add IRQ check in meson_spicc_probe
      ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Miquel Raynal (2):
      net: ieee802154: ca8210: Stop leaking skb's
      net: ieee802154: Return meaningful error codes from the netlink helpers

Muhammad Usama Anjum (1):
      selftests: futex: Use variable MAKE instead of make

Nick Lopez (1):
      drm/nouveau: fix off by one in BIOS boundary checking

Pablo Neira Ayuso (1):
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Paul Moore (1):
      audit: improve audit queue handling when "audit=1" on cmdline

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

Sujit Kautkar (1):
      rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Sukadev Bhattiprolu (1):
      ibmvnic: don't spin in tasklet

Trond Myklebust (2):
      NFSv4: Handle case where the lookup of a directory fails
      NFSv4: nfs_atomic_open() can race when looking up a non-regular file

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Xin Long (1):
      ping: fix the sk_bound_dev_if match in ping_lookup

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

