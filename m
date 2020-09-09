Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96318263540
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgIISBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIISBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:01:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5246921D46;
        Wed,  9 Sep 2020 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674510;
        bh=hOl5GhtI8Rolyu02yCt6CXAiqsiNyhvomJZ1Xfhfayk=;
        h=From:To:Cc:Subject:Date:From;
        b=zlOWvYRVQj0I3/o0uoNGVIK6Mxs3wz4MGfiD91sXJK5AiHJGXQgKk2MCG5RurjTUG
         y2SZfMXVBPaA1/LXEXCr8bUvKYUhe85EhxZiAmKivrqlHLI+Y4PuH+/gpszGnu4DwR
         2iu+dph0V2fjaIaTpM9VRs1cb0qyP3Q2CkAGCzUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.64
Date:   Wed,  9 Sep 2020 20:01:48 +0200
Message-Id: <1599674508105247@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.64 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mmc/mtk-sd.txt            |    2 
 Documentation/filesystems/affs.txt                          |   16 
 Makefile                                                    |    2 
 arch/arc/kernel/perf_event.c                                |   14 
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                    |    2 
 arch/mips/kernel/smp-bmips.c                                |    2 
 arch/mips/kernel/traps.c                                    |   12 
 arch/mips/mm/c-r4k.c                                        |    4 
 arch/s390/include/asm/percpu.h                              |   28 
 arch/x86/include/asm/ptrace.h                               |    2 
 arch/x86/mm/numa_emulation.c                                |    2 
 block/blk-core.c                                            |    1 
 block/blk-iocost.c                                          |    5 
 drivers/ata/libata-core.c                                   |    5 
 drivers/ata/libata-scsi.c                                   |    8 
 drivers/block/nbd.c                                         |    2 
 drivers/cpuidle/cpuidle.c                                   |    3 
 drivers/dma/at_hdmac.c                                      |    2 
 drivers/dma/dw-edma/dw-edma-core.c                          |   11 
 drivers/dma/fsldma.h                                        |   12 
 drivers/dma/of-dma.c                                        |    8 
 drivers/dma/pl330.c                                         |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   12 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c       |    8 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c        |   14 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                       |   12 
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                   |    4 
 drivers/gpu/drm/msm/msm_atomic.c                            |   36 +
 drivers/gpu/drm/msm/msm_drv.c                               |    8 
 drivers/gpu/drm/omapdrm/omap_crtc.c                         |    3 
 drivers/hid/hid-ids.h                                       |    3 
 drivers/hid/hid-quirks.c                                    |    3 
 drivers/hwmon/applesmc.c                                    |   31 -
 drivers/iommu/amd_iommu.c                                   |    2 
 drivers/iommu/intel-iommu.c                                 |   14 
 drivers/iommu/intel_irq_remapping.c                         |   10 
 drivers/md/dm-cache-metadata.c                              |    8 
 drivers/md/dm-crypt.c                                       |    2 
 drivers/md/dm-integrity.c                                   |   12 
 drivers/md/dm-mpath.c                                       |   22 
 drivers/md/dm-thin-metadata.c                               |   10 
 drivers/md/dm-writecache.c                                  |   12 
 drivers/md/persistent-data/dm-block-manager.c               |   14 
 drivers/media/platform/vicodec/vicodec-core.c               |    1 
 drivers/media/rc/rc-main.c                                  |   44 -
 drivers/misc/habanalabs/firmware_if.c                       |    9 
 drivers/misc/habanalabs/memory.c                            |    9 
 drivers/misc/habanalabs/mmu.c                               |    2 
 drivers/mmc/host/cqhci.c                                    |    6 
 drivers/mmc/host/cqhci.h                                    |    6 
 drivers/mmc/host/mtk-sd.c                                   |   13 
 drivers/mmc/host/sdhci-acpi.c                               |   67 +-
 drivers/mmc/host/sdhci-pci-core.c                           |   10 
 drivers/mmc/host/sdhci-tegra.c                              |   53 +
 drivers/net/dsa/microchip/ksz8795.c                         |    3 
 drivers/net/dsa/microchip/ksz9477.c                         |    3 
 drivers/net/dsa/mt7530.c                                    |    2 
 drivers/net/ethernet/arc/emac_mdio.c                        |    1 
 drivers/net/ethernet/broadcom/bcmsysport.c                  |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   36 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c           |    5 
 drivers/net/ethernet/broadcom/tg3.c                         |   17 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c          |    8 
 drivers/net/ethernet/cortina/gemini.c                       |   34 -
 drivers/net/ethernet/hisilicon/hns/hns_enet.c               |    9 
 drivers/net/ethernet/mellanox/mlx4/mr.c                     |    2 
 drivers/net/ethernet/renesas/ravb_main.c                    |  110 +--
 drivers/net/ethernet/ti/cpsw.c                              |    2 
 drivers/net/gtp.c                                           |    1 
 drivers/net/usb/asix_common.c                               |    2 
 drivers/nvme/host/core.c                                    |    2 
 drivers/nvme/target/core.c                                  |    6 
 drivers/nvme/target/fc.c                                    |    4 
 drivers/staging/media/sunxi/cedrus/cedrus.c                 |    7 
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c                 |    4 
 drivers/thermal/ti-soc-thermal/omap4-thermal-data.c         |   23 
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h           |   10 
 drivers/tty/serial/qcom_geni_serial.c                       |    2 
 drivers/vfio/pci/vfio_pci.c                                 |  349 +++++++++++-
 drivers/vfio/pci/vfio_pci_config.c                          |   51 +
 drivers/vfio/pci/vfio_pci_intrs.c                           |   14 
 drivers/vfio/pci/vfio_pci_private.h                         |   15 
 drivers/vfio/pci/vfio_pci_rdwr.c                            |   24 
 drivers/vfio/vfio_iommu_type1.c                             |   36 +
 drivers/xen/xenbus/xenbus_client.c                          |   10 
 fs/affs/amigaffs.c                                          |   27 
 fs/affs/file.c                                              |   26 
 fs/afs/fs_probe.c                                           |    4 
 fs/afs/vl_probe.c                                           |    4 
 fs/btrfs/ctree.c                                            |    6 
 fs/btrfs/extent-tree.c                                      |    2 
 fs/btrfs/extent_io.c                                        |    8 
 fs/btrfs/extent_io.h                                        |    6 
 fs/btrfs/ioctl.c                                            |   27 
 fs/btrfs/scrub.c                                            |  122 ++--
 fs/btrfs/tree-checker.c                                     |    2 
 fs/btrfs/volumes.c                                          |    3 
 fs/ceph/file.c                                              |    1 
 fs/eventpoll.c                                              |    6 
 fs/ext2/file.c                                              |    6 
 fs/xfs/libxfs/xfs_attr_leaf.c                               |    4 
 fs/xfs/libxfs/xfs_bmap.c                                    |    2 
 fs/xfs/xfs_file.c                                           |   12 
 include/linux/bvec.h                                        |    9 
 include/linux/libata.h                                      |    1 
 include/linux/log2.h                                        |    2 
 include/linux/netfilter/nfnetlink.h                         |    3 
 include/net/af_rxrpc.h                                      |    2 
 include/net/netfilter/nf_tables.h                           |    2 
 include/uapi/linux/netfilter/nf_tables.h                    |    2 
 mm/hugetlb.c                                                |   26 
 mm/khugepaged.c                                             |    2 
 mm/madvise.c                                                |    2 
 mm/slub.c                                                   |   12 
 net/batman-adv/bat_v_ogm.c                                  |   11 
 net/batman-adv/bridge_loop_avoidance.c                      |    5 
 net/batman-adv/gateway_client.c                             |    6 
 net/core/dev.c                                              |    9 
 net/netfilter/nf_tables_api.c                               |   64 +-
 net/netfilter/nfnetlink.c                                   |   11 
 net/netfilter/nfnetlink_log.c                               |    3 
 net/netfilter/nfnetlink_queue.c                             |    2 
 net/netfilter/nft_payload.c                                 |    4 
 net/packet/af_packet.c                                      |    7 
 net/rxrpc/input.c                                           |   21 
 net/rxrpc/peer_object.c                                     |   16 
 net/wireless/reg.c                                          |    3 
 scripts/checkpatch.pl                                       |    4 
 sound/core/oss/mulaw.c                                      |    4 
 sound/firewire/digi00x/digi00x.c                            |    5 
 sound/firewire/tascam/tascam.c                              |   33 -
 sound/pci/ca0106/ca0106_main.c                              |    3 
 sound/pci/hda/hda_intel.c                                   |    2 
 sound/pci/hda/patch_hdmi.c                                  |    1 
 sound/pci/hda/patch_realtek.c                               |   46 +
 sound/usb/pcm.c                                             |    1 
 tools/include/uapi/linux/perf_event.h                       |    2 
 tools/perf/builtin-record.c                                 |    2 
 tools/perf/pmu-events/jevents.c                             |    2 
 tools/testing/selftests/bpf/test_maps.c                     |    2 
 141 files changed, 1503 insertions(+), 502 deletions(-)

Adrian Hunter (2):
      mmc: cqhci: Add cqhci_deactivate()
      mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers

Adrien Crivelli (1):
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion NT950XCJ-X716A

Ajay Kaher (3):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory

Al Grant (1):
      perf tools: Correct SNOOPX field offset

Al Viro (1):
      fix regression in "epoll: Keep a reference on files added to the check list"

Alex Williamson (1):
      vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Alexander Lobakin (1):
      net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()

Amit Engel (1):
      nvmet: Disable keep-alive timer when kato is cleared to 0h

Chris Wilson (1):
      iommu/vt-d: Handle 36bit addressing for x86-32

Christophe JAILLET (1):
      nvmet-fc: Fix a missed _irqsave version of spin_lock in 'nvmet_fc_fod_op_done()'

Damien Le Moal (1):
      dm crypt: Initialize crypto wait structures

Dan Carpenter (1):
      net: gemini: Fix another missing clk_disable_unprepare() in probe

Dan Crawford (1):
      ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO

Darrick J. Wong (1):
      xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

David Howells (3):
      rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()
      rxrpc: Make rxrpc_kernel_get_srtt() indicate validity
      mm/khugepaged.c: fix khugepaged's request size in collapse_file

Dinghao Liu (4):
      drm/amd/display: Fix memleak in amdgpu_dm_mode_config_init
      net: hns: Fix memleak in hns_nic_dev_probe
      net: systemport: Fix memleak in bcm_sysport_probe
      net: arc_emac: Fix memleak in arc_mdio_probe

Dmitry Baryshkov (1):
      drm/msm/a6xx: fix gmu start on newer firmware

Edwin Peer (1):
      bnxt_en: fix HWRM error when querying VF temperature

Eric Sandeen (1):
      xfs: fix boundary test in xfs_attr_shortform_verify

Eugeniu Rosca (1):
      mm: slub: fix conversion of freelist_corrupted()

Evan Quan (1):
      drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting

Ezequiel Garcia (1):
      media: cedrus: Add missing v4l2_ctrl_request_hdl_put()

Florian Fainelli (2):
      MIPS: mm: BMIPS5000 has inclusive physical caches
      MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Westphal (1):
      netfilter: nf_tables: fix destination register zeroing

Furquan Shaikh (1):
      drivers: gpu: amd: Initialize amdgpu_dm_backlight_caps object to 0 in amdgpu_dm_update_backlight_caps

Greg Kroah-Hartman (1):
      Linux 5.4.64

Gustavo Pimentel (1):
      dmaengine: dw-edma: Fix scatter-gather address calculation

Hans Verkuil (1):
      media: vicodec: add missing v4l2_ctrl_request_hdl_put()

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Hou Pu (1):
      nbd: restore default timeout when setting it to zero

Huang Pei (1):
      MIPS: add missing MSACSR and upper MSA initialization

Huang Ying (1):
      x86, fakenuma: Fix invalid starting node ID

Jakub Kicinski (1):
      bnxt: don't enable NAPI until rings are ready

Jason Gunthorpe (1):
      include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Jeff Layton (1):
      ceph: don't allow setlease on cephfs

Jens Axboe (1):
      block: ensure bdi->io_pages is always initialized

Jesper Dangaard Brouer (1):
      selftests/bpf: Fix massive output from test_maps

Johannes Berg (1):
      cfg80211: regulatory: reject invalid hints

John Stultz (1):
      tty: serial: qcom_geni_serial: Drop __init from qcom_geni_console_setup

Josef Bacik (5):
      btrfs: drop path before adding new uuid tree entry
      btrfs: allocate scrub workqueues outside of locks
      btrfs: set the correct lockdep class for new nodes
      btrfs: set the lockdep class for log tree extent buffers
      btrfs: fix potential deadlock in the search ioctl

Joshua Sivec (1):
      ALSA: usb-audio: Add implicit feedback quirk for UR22C

Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Kai Vehmanen (1):
      ALSA: hda/hdmi: always check pin power status in i915 pin fixup

Kalyan Thota (1):
      drm/msm/dpu: Fix scale params in plane validation

Keith Busch (1):
      nvme: fix controller instance leak

Krishna Manikandan (1):
      drm/msm: add shutdown support for display platform_driver

Landen Chao (1):
      net: dsa: mt7530: fix advertising unsupported 1000baseT_Half

Linus Lüssing (1):
      batman-adv: Fix own OGM check in aggregated OGMs

Linus Torvalds (1):
      fsldma: fix very broken 32-bit ppc ioread64 functionality

Lu Baolu (1):
      iommu/vt-d: Serialize IOMMU GCMD register modifications

Marek Szyprowski (1):
      dmaengine: pl330: Fix burst length if burst size is smaller than bus width

Max Staudt (1):
      affs: fix basic permission bits to actually work

Michael Chan (2):
      bnxt_en: Fix possible crash in bnxt_fw_reset_task().
      tg3: Fix soft lockup when tg3_reset_task() fails.

Mike Snitzer (1):
      dm mpath: fix racey management of PG initialization

Mikulas Patocka (4):
      ext2: don't update mtime on COW faults
      xfs: don't update mtime on COW faults
      dm writecache: handle DAX to partitions on persistent memory correctly
      dm integrity: fix error reporting in bitmap mode after creation

Ming Lei (1):
      block: allow for_each_bvec to support zero len bvec

Mrinal Pandey (1):
      checkpatch: fix the usage of capture group ( ... )

Muchun Song (1):
      mm/hugetlb: fix a race between hugetlb sysctl handlers

Murali Karicheri (1):
      net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port

Namhyung Kim (1):
      perf jevents: Fix suspicious code in fixregex()

Nicholas Kazlauskas (1):
      drm/amd/display: Reject overlay plane configurations in multi-display scenarios

Nicolas Dichtel (1):
      gtp: add GTPA_LINK info to msg sent to userspace

Ofir Bitton (2):
      habanalabs: validate FW file size
      habanalabs: check correct vmalloc return code

Or Cohen (1):
      net/packet: fix overflow in tpacket_rcv

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add NFTA_SET_USERDATA if not null
      netfilter: nf_tables: incorrect enum nft_list_attributes definition
      netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Pavan Chebbi (1):
      bnxt_en: Don't query FW when netif_running() is false.

Peter Ujfalusi (1):
      dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling

Peter Zijlstra (1):
      cpuidle: Fixup IRQ state

Potnuri Bharat Teja (1):
      cxgb4: fix thermal zone device registration

Qu Wenruo (1):
      btrfs: tree-checker: fix the error message for transid error

Raul E Rangel (1):
      mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040

Rob Clark (1):
      drm/msm: enable vblank during atomic commits

Sasha Levin (1):
      Revert "net: dsa: microchip: set the correct number of ports"

Sean Young (2):
      media: rc: do not access device via sysfs after rc_unregister_device()
      media: rc: uevent sysfs file races with rc_unregister_device()

Sebastian Parschauer (1):
      HID: quirks: Always poll three more Lenovo PixArt mice

Shung-Hsi Yu (1):
      net: ethernet: mlx4: Fix memory allocation in mlx4_buddy_init()

Simon Leiner (1):
      xen/xenbus: Fix granting of vmalloc'd memory

Sowjanya Komatineni (1):
      sdhci: tegra: Add missing TMCLK for data timeout

Suravee Suthikulpanit (1):
      iommu/amd: Restore IRTE.RemapEn bit after programming IRTE

Sven Eckelmann (1):
      batman-adv: Avoid uninitialized chaddr when handling DHCP

Sven Schnelle (1):
      s390: don't trace preemption in percpu macros

Takashi Iwai (2):
      ALSA: pcm: oss: Remove superfluous WARN_ON() for mulaw sanity check
      ALSA: hda/realtek - Improved routing for Thinkpad X1 7th/8th Gen

Takashi Sakamoto (2):
      ALSA: firewire-digi00x: exclude Avid Adrenaline from detection
      ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tejun Heo (2):
      libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks
      blk-iocost: ioc_pd_free() shouldn't assume irq disabled

Tiezhu Yang (1):
      Revert "ALSA: hda: Add support for Loongson 7A1000 controller"

Tom Rix (1):
      hwmon: (applesmc) check status earlier.

Tomi Valkeinen (1):
      drm/omap: fix incorrect lock state

Tong Zhang (1):
      ALSA: ca0106: fix error code handling

Tony Lindgren (1):
      thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Vamshi K Sthambamkadi (1):
      tracing/kprobes, x86/ptrace: Fix regs argument order for i386

Vasundhara Volam (2):
      bnxt_en: Check for zero dir entries in NVRAM.
      bnxt_en: Fix PCI AER error recovery flow

Veera Vegivada (1):
      thermal: qcom-spmi-temp-alarm: Don't suppress negative temp

Vineet Gupta (1):
      ARC: perf: don't bail setup if pct irq missing in device-tree

Wayne Lin (1):
      drm/amd/display: Retry AUX write when fail occurs

Wei Li (1):
      perf record: Correct the help info of option "--no-bpf-event"

Wenbin Mei (3):
      arm64: dts: mt7622: add reset node for mmc device
      mmc: mediatek: add optional module reset property
      mmc: dt-bindings: Add resets/reset-names for Mediatek MMC bindings

Yang Shi (1):
      mm: madvise: fix vma user-after-free

Ye Bin (3):
      dm cache metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Fix use-after-free in dm_bm_set_read_only

Yu Kuai (1):
      dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

