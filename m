Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D80267A51
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgILMm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILMm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:42:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4AC21531;
        Sat, 12 Sep 2020 12:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914547;
        bh=KPrO00vtFReI/+gdkH0Pln+7k3NQu3ZCVlQabnllelM=;
        h=From:To:Cc:Subject:Date:From;
        b=aL8xIyDxfR/Ejw9nrSAJxDpuoKTQ/icuzf3Lao+US+YYUHhUtpBfWoUrjcfQs/uGG
         3M0I1Pu5WpBmRGV/673UWib5pb/tJ8IRfNmIDBZuNThNiCybuzYgORGrY4WLrs51P6
         i/Zv+da01J9Cig4EhKn1cHeNLznzYyULG0Brc5G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.236
Date:   Sat, 12 Sep 2020 14:42:30 +0200
Message-Id: <15999145500103@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.236 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/affs.txt                  |   16 +
 Makefile                                            |    2 
 arch/s390/include/asm/percpu.h                      |   28 +--
 drivers/dma/at_hdmac.c                              |    2 
 drivers/dma/of-dma.c                                |    8 
 drivers/dma/pl330.c                                 |    2 
 drivers/hid/hid-core.c                              |   15 +
 drivers/hid/hid-input.c                             |    4 
 drivers/hid/hid-multitouch.c                        |    2 
 drivers/hwmon/applesmc.c                            |   31 +--
 drivers/iommu/intel_irq_remapping.c                 |   10 -
 drivers/md/dm-cache-metadata.c                      |    8 
 drivers/md/dm-thin-metadata.c                       |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |   11 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |    3 
 drivers/net/ethernet/broadcom/tg3.c                 |   17 +
 drivers/net/ethernet/mellanox/mlx4/mr.c             |    2 
 drivers/net/ethernet/renesas/ravb_main.c            |  110 +++++------
 drivers/net/usb/asix_common.c                       |    2 
 drivers/net/usb/dm9601.c                            |    4 
 drivers/net/usb/qmi_wwan.c                          |  185 +++++++++++++++++++-
 drivers/thermal/ti-soc-thermal/omap4-thermal-data.c |   23 +-
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h   |   10 -
 drivers/xen/xenbus/xenbus_client.c                  |   10 -
 fs/affs/amigaffs.c                                  |   63 ++++--
 fs/affs/file.c                                      |   26 ++
 fs/btrfs/ctree.c                                    |    8 
 fs/btrfs/extent_io.c                                |    8 
 fs/btrfs/extent_io.h                                |    6 
 fs/btrfs/ioctl.c                                    |   27 ++
 fs/btrfs/volumes.c                                  |    3 
 fs/ceph/file.c                                      |    1 
 fs/eventpoll.c                                      |    6 
 include/linux/hid.h                                 |   42 +++-
 include/linux/log2.h                                |    2 
 include/linux/uaccess.h                             |   26 ++
 include/net/inet_connection_sock.h                  |    4 
 include/net/netfilter/nf_tables.h                   |    2 
 include/uapi/linux/netfilter/nf_tables.h            |    2 
 mm/hugetlb.c                                        |   26 ++
 mm/maccess.c                                        |  167 ++++++++++++++++--
 mm/page_alloc.c                                     |    7 
 net/batman-adv/bridge_loop_avoidance.c              |    5 
 net/batman-adv/gateway_client.c                     |    6 
 net/core/dev.c                                      |    3 
 net/core/netpoll.c                                  |    2 
 net/ipv4/inet_connection_sock.c                     |   46 +++-
 net/ipv4/inet_hashtables.c                          |    1 
 net/netfilter/nft_payload.c                         |    4 
 net/sctp/socket.c                                   |   16 -
 net/wireless/reg.c                                  |    3 
 scripts/checkpatch.pl                               |    4 
 sound/core/oss/mulaw.c                              |    4 
 sound/firewire/digi00x/digi00x.c                    |   18 +
 sound/firewire/digi00x/digi00x.h                    |    1 
 sound/firewire/tascam/tascam.c                      |   30 +++
 sound/pci/ca0106/ca0106_main.c                      |    3 
 tools/perf/Documentation/perf-record.txt            |    4 
 tools/perf/Documentation/perf-stat.txt              |    4 
 59 files changed, 840 insertions(+), 253 deletions(-)

Al Viro (1):
      fix regression in "epoll: Keep a reference on files added to the check list"

Bjørn Mork (5):
      net: qmi_wwan: MDM9x30 specific power management
      net: qmi_wwan: support "raw IP" mode
      net: qmi_wwan: should hold RTNL while changing netdev type
      net: qmi_wwan: ignore bogus CDC Union descriptors
      qmi_wwan: add support for Quectel EC21 and EC25

Daniel Borkmann (1):
      uaccess: Add non-pagefault user-space write function

Daniele Palmas (4):
      NET: usb: qmi_wwan: add support for Telit LE922A PID 0x1040
      drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201
      net: usb: qmi_wwan: add Telit ME910 support
      net: usb: qmi_wwan: add Telit 0x1050 composition

Fabian Frederick (1):
      fs/affs: use octal for permissions

Florian Westphal (1):
      netfilter: nf_tables: fix destination register zeroing

Greg Kroah-Hartman (1):
      Linux 4.4.236

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Jakub Kicinski (2):
      bnxt: don't enable NAPI until rings are ready
      net: disable netpoll on fresh napis

Jason Gunthorpe (1):
      include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Jeff Layton (1):
      ceph: don't allow setlease on cephfs

Johannes Berg (1):
      cfg80211: regulatory: reject invalid hints

Josef Bacik (3):
      btrfs: drop path before adding new uuid tree entry
      btrfs: set the lockdep class for log tree extent buffers
      btrfs: fix potential deadlock in the search ioctl

Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Kim Phillips (1):
      perf record/stat: Explicitly call out event modifiers in the documentation

Lu Baolu (1):
      iommu/vt-d: Serialize IOMMU GCMD register modifications

Marc Zyngier (2):
      HID: core: Correctly handle ReportSize being zero
      HID: core: Sanitize event code and type when mapping input

Marek Szyprowski (1):
      dmaengine: pl330: Fix burst length if burst size is smaller than bus width

Masami Hiramatsu (1):
      uaccess: Add non-pagefault user-space read functions

Max Staudt (1):
      affs: fix basic permission bits to actually work

Mel Gorman (1):
      mm, page_alloc: remove unnecessary variable from free_pcppages_bulk

Michael Chan (2):
      tg3: Fix soft lockup when tg3_reset_task() fails.
      bnxt_en: Failure to update PHY is not fatal condition.

Mrinal Pandey (1):
      checkpatch: fix the usage of capture group ( ... )

Muchun Song (1):
      mm/hugetlb: fix a race between hugetlb sysctl handlers

Nikolay Borisov (2):
      btrfs: Remove redundant extent_buffer_get in get_old_root
      btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind

Pablo Neira Ayuso (1):
      netfilter: nf_tables: incorrect enum nft_list_attributes definition

Patrik Halfar (1):
      Add Dell Wireless 5809e Gobi 4G HSPA+ Mobile Broadband Card (rev3) to qmi_wwan

Peter Ujfalusi (1):
      dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling

Rogan Dawes (1):
      usb: qmi_wwan: add D-Link DWM-222 A2 device ID

Schemmel Hans-Christoph (1):
      qmi_wwan: Added support for Gemalto's Cinterion PHxx WWAN interface

Shung-Hsi Yu (1):
      net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Simon Leiner (1):
      xen/xenbus: Fix granting of vmalloc'd memory

Sven Eckelmann (1):
      batman-adv: Avoid uninitialized chaddr when handling DHCP

Sven Schnelle (1):
      s390: don't trace preemption in percpu macros

Takashi Iwai (1):
      ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check

Takashi Sakamoto (3):
      ALSA: firewire-digi00x: add support for console models of Digi00x series
      ALSA: firewire-digi00x: exclude Avid Adrenaline from detection
      ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tom Rix (1):
      hwmon: (applesmc) check status earlier.

Tong Zhang (1):
      ALSA: ca0106: fix error code handling

Tony Lindgren (1):
      thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Vasundhara Volam (1):
      bnxt_en: Check for zero dir entries in NVRAM.

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

Ye Bin (2):
      dm cache metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Avoid returning cmd->bm wild pointer on error

Yu Kuai (1):
      dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

