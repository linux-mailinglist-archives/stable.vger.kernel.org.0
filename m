Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9992A267A53
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILMnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgILMmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:42:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729B321548;
        Sat, 12 Sep 2020 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914555;
        bh=ynOCq3/VfcRYqBrCFiKao7zEG8m9yK1Egd/nOBKt5Mg=;
        h=From:To:Cc:Subject:Date:From;
        b=urDyR6XwObU8hwRV6MgrsAaorMjE+/MPg764ueTYjVUAHHKbBg7/b8kfYCqKY9z8Q
         UpsT9gXLKolcCBz6Wjg0f4YeCHoufpRAYrPOMIwuMfMtYgi3GPHZlaJQ0B42orwH/Q
         hLlQ7nnMLSDJh18yhQh2+mR1MbJmFxajKZfVaclA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.236
Date:   Sat, 12 Sep 2020 14:42:36 +0200
Message-Id: <1599914556142190@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.236 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/affs.txt                  |   16 
 Makefile                                            |    2 
 arch/arm64/include/asm/kvm_arm.h                    |    3 
 arch/arm64/include/asm/kvm_asm.h                    |   43 ++
 arch/arm64/kernel/vmlinux.lds.S                     |    8 
 arch/arm64/kvm/hyp/entry.S                          |   26 +
 arch/arm64/kvm/hyp/hyp-entry.S                      |   63 ++-
 arch/arm64/kvm/hyp/switch.c                         |   39 +-
 arch/mips/kernel/smp-bmips.c                        |    2 
 arch/mips/mm/c-r4k.c                                |    4 
 arch/s390/include/asm/percpu.h                      |   28 -
 arch/xtensa/platforms/iss/simdisk.c                 |    1 
 drivers/ata/libata-core.c                           |    5 
 drivers/ata/libata-scsi.c                           |    8 
 drivers/block/brd.c                                 |    1 
 drivers/block/rbd.c                                 |    9 
 drivers/block/zram/zram_drv.h                       |    1 
 drivers/dma/at_hdmac.c                              |    2 
 drivers/dma/of-dma.c                                |    8 
 drivers/dma/pl330.c                                 |    2 
 drivers/hid/hid-core.c                              |   15 
 drivers/hid/hid-input.c                             |    4 
 drivers/hid/hid-multitouch.c                        |    2 
 drivers/hwmon/applesmc.c                            |   31 -
 drivers/ide/ide-cd.c                                |    8 
 drivers/ide/ide-cd.h                                |    6 
 drivers/iommu/intel_irq_remapping.c                 |   10 
 drivers/md/dm-cache-metadata.c                      |    8 
 drivers/md/dm-thin-metadata.c                       |    8 
 drivers/net/ethernet/arc/emac_mdio.c                |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |   12 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |    3 
 drivers/net/ethernet/broadcom/tg3.c                 |   17 
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |    9 
 drivers/net/ethernet/mellanox/mlx4/mr.c             |    2 
 drivers/net/ethernet/renesas/ravb_main.c            |  110 +++---
 drivers/net/usb/asix_common.c                       |    2 
 drivers/net/usb/dm9601.c                            |    4 
 drivers/net/usb/qmi_wwan.c                          |    8 
 drivers/nvdimm/nd.h                                 |    1 
 drivers/nvme/target/core.c                          |    6 
 drivers/scsi/gdth.h                                 |    3 
 drivers/thermal/ti-soc-thermal/omap4-thermal-data.c |   23 -
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h   |   10 
 drivers/vfio/pci/vfio_pci.c                         |  351 ++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c                  |   51 ++
 drivers/vfio/pci/vfio_pci_intrs.c                   |   14 
 drivers/vfio/pci/vfio_pci_private.h                 |   16 
 drivers/vfio/pci/vfio_pci_rdwr.c                    |   29 +
 drivers/vfio/vfio_iommu_type1.c                     |   36 +-
 drivers/xen/xenbus/xenbus_client.c                  |   10 
 fs/affs/amigaffs.c                                  |   63 ++-
 fs/affs/file.c                                      |   26 +
 fs/btrfs/ctree.c                                    |    8 
 fs/btrfs/extent_io.c                                |    8 
 fs/btrfs/extent_io.h                                |    6 
 fs/btrfs/ioctl.c                                    |   27 +
 fs/btrfs/volumes.c                                  |    3 
 fs/ceph/file.c                                      |    1 
 fs/eventpoll.c                                      |    6 
 include/linux/blkdev.h                              |   42 +-
 include/linux/bvec.h                                |    9 
 include/linux/device-mapper.h                       |    2 
 include/linux/hid.h                                 |   42 +-
 include/linux/ide.h                                 |    1 
 include/linux/libata.h                              |    1 
 include/linux/log2.h                                |    2 
 include/linux/uaccess.h                             |   26 +
 include/net/inet_connection_sock.h                  |    4 
 include/net/netfilter/nf_tables.h                   |    2 
 include/uapi/linux/msdos_fs.h                       |    2 
 include/uapi/linux/netfilter/nf_tables.h            |    2 
 mm/hugetlb.c                                        |   26 +
 mm/maccess.c                                        |  167 ++++++++-
 mm/slub.c                                           |   12 
 net/batman-adv/bridge_loop_avoidance.c              |    5 
 net/batman-adv/gateway_client.c                     |    6 
 net/core/dev.c                                      |    3 
 net/core/netpoll.c                                  |    2 
 net/ipv4/inet_connection_sock.c                     |   37 +-
 net/ipv4/inet_hashtables.c                          |    1 
 net/netfilter/nf_tables_api.c                       |    3 
 net/netfilter/nft_payload.c                         |    4 
 net/netlabel/netlabel_domainhash.c                  |   59 +--
 net/sctp/socket.c                                   |   16 
 net/wireless/reg.c                                  |    3 
 scripts/checkpatch.pl                               |    4 
 sound/core/oss/mulaw.c                              |    4 
 sound/firewire/digi00x/digi00x.c                    |    5 
 sound/firewire/tascam/tascam.c                      |   30 +
 sound/pci/ca0106/ca0106_main.c                      |    3 
 tools/perf/Documentation/perf-record.txt            |    4 
 tools/perf/Documentation/perf-stat.txt              |    4 
 93 files changed, 1365 insertions(+), 397 deletions(-)

Al Viro (1):
      fix regression in "epoll: Keep a reference on files added to the check list"

Alex Williamson (4):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
      vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Amit Engel (1):
      nvmet: Disable keep-alive timer when kato is cleared to 0h

Bart Van Assche (1):
      block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into <linux/blkdev.h>

Bjørn Mork (1):
      qmi_wwan: new Telewell and Sierra device IDs

Daniel Borkmann (1):
      uaccess: Add non-pagefault user-space write function

Daniele Palmas (2):
      net: usb: qmi_wwan: add Telit 0x1050 composition
      drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201

Dinghao Liu (2):
      net: hns: Fix memleak in hns_nic_dev_probe
      net: arc_emac: Fix memleak in arc_mdio_probe

Eugeniu Rosca (1):
      mm: slub: fix conversion of freelist_corrupted()

Fabian Frederick (1):
      fs/affs: use octal for permissions

Florian Fainelli (2):
      MIPS: mm: BMIPS5000 has inclusive physical caches
      MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Westphal (1):
      netfilter: nf_tables: fix destination register zeroing

Greg Kroah-Hartman (1):
      Linux 4.9.236

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Jakub Kicinski (2):
      bnxt: don't enable NAPI until rings are ready
      net: disable netpoll on fresh napis

James Morse (4):
      KVM: arm64: Add kvm_extable for vaxorcism code
      KVM: arm64: Defer guest entry when an asynchronous exception is pending
      KVM: arm64: Survive synchronous exceptions caused by AT instructions
      KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

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

Michael Chan (1):
      tg3: Fix soft lockup when tg3_reset_task() fails.

Ming Lei (1):
      block: allow for_each_bvec to support zero len bvec

Mrinal Pandey (1):
      checkpatch: fix the usage of capture group ( ... )

Muchun Song (1):
      mm/hugetlb: fix a race between hugetlb sysctl handlers

Nikolay Borisov (2):
      btrfs: Remove redundant extent_buffer_get in get_old_root
      btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add NFTA_SET_USERDATA if not null
      netfilter: nf_tables: incorrect enum nft_list_attributes definition

Paul Moore (1):
      netlabel: fix problems with mapping removal

Peter Ujfalusi (1):
      dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling

Rogan Dawes (1):
      usb: qmi_wwan: add D-Link DWM-222 A2 device ID

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

Takashi Sakamoto (2):
      ALSA: firewire-digi00x: exclude Avid Adrenaline from detection
      ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tejun Heo (1):
      libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tom Rix (1):
      hwmon: (applesmc) check status earlier.

Tong Zhang (1):
      ALSA: ca0106: fix error code handling

Tony Lindgren (1):
      thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Vasundhara Volam (2):
      bnxt_en: Check for zero dir entries in NVRAM.
      bnxt_en: Fix PCI AER error recovery flow

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

Ye Bin (2):
      dm cache metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Avoid returning cmd->bm wild pointer on error

Yu Kuai (1):
      dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

