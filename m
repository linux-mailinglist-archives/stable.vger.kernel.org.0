Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1626353D
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgIISBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIISBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:01:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE08421D7D;
        Wed,  9 Sep 2020 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674494;
        bh=evXOXaKiF48oPSdgPWbvdDREkNlASG92ghuDeT5IYx4=;
        h=From:To:Cc:Subject:Date:From;
        b=gnEbFzx3SLXr749DMakm4ixzMcKgCfBL1wb2r55lhNU93kU3DSTM06MQHmvHjh8/b
         qNe/Su0fEGFYsqvWWJ8lGH8bv3TWlXGqAUH4mUmsYAdfx0P8+nNx2VffVVEHbbptE/
         +M1/jxec63v6KbVWvy/WQQC3LH4ulSaSx+Jos8Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.144
Date:   Wed,  9 Sep 2020 20:01:39 +0200
Message-Id: <159967449966136@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.144 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
 arch/arm64/kvm/hyp/entry.S                          |   31 +
 arch/arm64/kvm/hyp/hyp-entry.S                      |   63 ++-
 arch/arm64/kvm/hyp/switch.c                         |   39 ++
 arch/mips/kernel/smp-bmips.c                        |    2 
 arch/mips/mm/c-r4k.c                                |    4 
 arch/s390/include/asm/percpu.h                      |   28 -
 arch/x86/mm/numa_emulation.c                        |    2 
 drivers/ata/libata-core.c                           |    5 
 drivers/ata/libata-scsi.c                           |    8 
 drivers/cpuidle/cpuidle.c                           |    3 
 drivers/dma/at_hdmac.c                              |    2 
 drivers/dma/of-dma.c                                |    8 
 drivers/dma/pl330.c                                 |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c               |   12 
 drivers/gpu/drm/msm/msm_drv.c                       |    8 
 drivers/hid/hid-core.c                              |   15 
 drivers/hid/hid-input.c                             |    4 
 drivers/hid/hid-multitouch.c                        |    2 
 drivers/hwmon/applesmc.c                            |   31 -
 drivers/iommu/intel_irq_remapping.c                 |   10 
 drivers/md/dm-cache-metadata.c                      |    8 
 drivers/md/dm-thin-metadata.c                       |    8 
 drivers/md/dm-writecache.c                          |   12 
 drivers/media/rc/rc-main.c                          |   44 +-
 drivers/net/ethernet/arc/emac_mdio.c                |    1 
 drivers/net/ethernet/broadcom/bcmsysport.c          |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |   26 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c   |    5 
 drivers/net/ethernet/broadcom/tg3.c                 |   17 
 drivers/net/ethernet/cortina/gemini.c               |   34 -
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |    9 
 drivers/net/ethernet/mellanox/mlx4/mr.c             |    2 
 drivers/net/ethernet/renesas/ravb_main.c            |  110 +++---
 drivers/net/gtp.c                                   |    1 
 drivers/net/usb/asix_common.c                       |    2 
 drivers/net/usb/qmi_wwan.c                          |    2 
 drivers/nvme/target/core.c                          |    6 
 drivers/nvme/target/fc.c                            |    4 
 drivers/target/target_core_user.c                   |   15 
 drivers/thermal/ti-soc-thermal/omap4-thermal-data.c |   23 -
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h   |   10 
 drivers/tty/serial/qcom_geni_serial.c               |    2 
 drivers/vfio/pci/vfio_pci.c                         |  349 ++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_config.c                  |   51 ++
 drivers/vfio/pci/vfio_pci_intrs.c                   |   14 
 drivers/vfio/pci/vfio_pci_private.h                 |   16 
 drivers/vfio/pci/vfio_pci_rdwr.c                    |   24 +
 drivers/vfio/vfio_iommu_type1.c                     |   36 +-
 drivers/xen/xenbus/xenbus_client.c                  |   10 
 fs/affs/amigaffs.c                                  |   27 +
 fs/affs/file.c                                      |   26 +
 fs/btrfs/ctree.c                                    |    8 
 fs/btrfs/extent_io.c                                |    8 
 fs/btrfs/extent_io.h                                |    6 
 fs/btrfs/ioctl.c                                    |   27 +
 fs/btrfs/volumes.c                                  |    3 
 fs/ceph/file.c                                      |    1 
 fs/eventpoll.c                                      |    6 
 fs/ext2/file.c                                      |    6 
 fs/xfs/libxfs/xfs_attr_leaf.c                       |    4 
 fs/xfs/libxfs/xfs_bmap.c                            |    2 
 fs/xfs/xfs_file.c                                   |   12 
 include/linux/bvec.h                                |    9 
 include/linux/hid.h                                 |   42 +-
 include/linux/libata.h                              |    1 
 include/linux/log2.h                                |    2 
 include/linux/netfilter/nfnetlink.h                 |    3 
 include/linux/uaccess.h                             |   26 +
 include/net/netfilter/nf_tables.h                   |    2 
 include/uapi/linux/netfilter/nf_tables.h            |    2 
 mm/hugetlb.c                                        |   26 +
 mm/maccess.c                                        |  167 ++++++++-
 mm/slub.c                                           |   12 
 net/batman-adv/bat_v_ogm.c                          |   11 
 net/batman-adv/bridge_loop_avoidance.c              |    5 
 net/batman-adv/gateway_client.c                     |    6 
 net/netfilter/nf_tables_api.c                       |   64 +--
 net/netfilter/nfnetlink.c                           |   11 
 net/netfilter/nfnetlink_log.c                       |    3 
 net/netfilter/nfnetlink_queue.c                     |    2 
 net/netfilter/nft_payload.c                         |    4 
 net/wireless/reg.c                                  |    3 
 scripts/checkpatch.pl                               |    4 
 sound/core/oss/mulaw.c                              |    4 
 sound/firewire/digi00x/digi00x.c                    |    5 
 sound/pci/ca0106/ca0106_main.c                      |    3 
 sound/pci/hda/patch_hdmi.c                          |    1 
 sound/pci/hda/patch_realtek.c                       |    1 
 tools/include/uapi/linux/perf_event.h               |    2 
 tools/perf/Documentation/perf-record.txt            |    4 
 tools/perf/Documentation/perf-stat.txt              |    4 
 tools/perf/pmu-events/jevents.c                     |    2 
 tools/testing/selftests/bpf/test_maps.c             |    2 
 98 files changed, 1377 insertions(+), 390 deletions(-)

Al Grant (1):
      perf tools: Correct SNOOPX field offset

Al Viro (1):
      fix regression in "epoll: Keep a reference on files added to the check list"

Alex Williamson (4):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
      vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Amit Engel (1):
      nvmet: Disable keep-alive timer when kato is cleared to 0h

Bodo Stroesser (2):
      scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
      scsi: target: tcmu: Optimize use of flush_dcache_page

Christophe JAILLET (1):
      nvmet-fc: Fix a missed _irqsave version of spin_lock in 'nvmet_fc_fod_op_done()'

Dan Carpenter (1):
      net: gemini: Fix another missing clk_disable_unprepare() in probe

Dan Crawford (1):
      ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO

Daniel Borkmann (1):
      uaccess: Add non-pagefault user-space write function

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1050 composition

Darrick J. Wong (1):
      xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

Dinghao Liu (3):
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

Florian Fainelli (2):
      MIPS: mm: BMIPS5000 has inclusive physical caches
      MIPS: BMIPS: Also call bmips_cpu_setup() for secondary cores

Florian Westphal (1):
      netfilter: nf_tables: fix destination register zeroing

Greg Kroah-Hartman (1):
      Linux 4.19.144

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Huang Ying (1):
      x86, fakenuma: Fix invalid starting node ID

Jakub Kicinski (1):
      bnxt: don't enable NAPI until rings are ready

James Morse (4):
      KVM: arm64: Add kvm_extable for vaxorcism code
      KVM: arm64: Defer guest entry when an asynchronous exception is pending
      KVM: arm64: Survive synchronous exceptions caused by AT instructions
      KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

Jason Gunthorpe (1):
      include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Jeff Layton (1):
      ceph: don't allow setlease on cephfs

Jesper Dangaard Brouer (1):
      selftests/bpf: Fix massive output from test_maps

Johannes Berg (1):
      cfg80211: regulatory: reject invalid hints

John Stultz (1):
      tty: serial: qcom_geni_serial: Drop __init from qcom_geni_console_setup

Josef Bacik (3):
      btrfs: drop path before adding new uuid tree entry
      btrfs: set the lockdep class for log tree extent buffers
      btrfs: fix potential deadlock in the search ioctl

Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Kai Vehmanen (1):
      ALSA: hda/hdmi: always check pin power status in i915 pin fixup

Kim Phillips (1):
      perf record/stat: Explicitly call out event modifiers in the documentation

Krishna Manikandan (1):
      drm/msm: add shutdown support for display platform_driver

Linus Lüssing (1):
      batman-adv: Fix own OGM check in aggregated OGMs

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

Mikulas Patocka (3):
      ext2: don't update mtime on COW faults
      xfs: don't update mtime on COW faults
      dm writecache: handle DAX to partitions on persistent memory correctly

Ming Lei (1):
      block: allow for_each_bvec to support zero len bvec

Mrinal Pandey (1):
      checkpatch: fix the usage of capture group ( ... )

Muchun Song (1):
      mm/hugetlb: fix a race between hugetlb sysctl handlers

Namhyung Kim (1):
      perf jevents: Fix suspicious code in fixregex()

Nicolas Dichtel (1):
      gtp: add GTPA_LINK info to msg sent to userspace

Nikolay Borisov (2):
      btrfs: Remove redundant extent_buffer_get in get_old_root
      btrfs: Remove extraneous extent_buffer_get from tree_mod_log_rewind

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

Rogan Dawes (1):
      usb: qmi_wwan: add D-Link DWM-222 A2 device ID

Sean Young (2):
      media: rc: do not access device via sysfs after rc_unregister_device()
      media: rc: uevent sysfs file races with rc_unregister_device()

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

Takashi Sakamoto (1):
      ALSA: firewire-digi00x: exclude Avid Adrenaline from detection

Tejun Heo (1):
      libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks

Tom Rix (1):
      hwmon: (applesmc) check status earlier.

Tong Zhang (1):
      ALSA: ca0106: fix error code handling

Tony Lindgren (1):
      thermal: ti-soc-thermal: Fix bogus thermal shutdowns for omap4430

Vasundhara Volam (2):
      bnxt_en: Check for zero dir entries in NVRAM.
      bnxt_en: Fix PCI AER error recovery flow

Ye Bin (2):
      dm cache metadata: Avoid returning cmd->bm wild pointer on error
      dm thin metadata: Avoid returning cmd->bm wild pointer on error

Yu Kuai (1):
      dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

