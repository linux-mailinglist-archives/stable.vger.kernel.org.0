Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D7263543
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgIISCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgIISB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:01:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3CE621D81;
        Wed,  9 Sep 2020 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674513;
        bh=0D5ggXuWjuGBjRI+75zkevFVzoml+0jE0PCIMyEyxjU=;
        h=From:To:Cc:Subject:Date:From;
        b=L5xcF8TYcPsv0Sn/WvnE9hc7cPy5AUYU8RaBQUHI0IT70cq5wWiWGvf+mrxOCKdxS
         Dn7Nz8rg24DOSAn6XVLAhfF2WafYmlhLmrKNtePXDaCDvcsYUiuVuTIOX9pw+v/C14
         6ximC+4hyUe/CScktYY3dFdC7nvEOo9sIJXuZJf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.8
Date:   Wed,  9 Sep 2020 20:01:54 +0200
Message-Id: <159967451514613@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.8 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mmc/mtk-sd.txt            |    2 
 Documentation/filesystems/affs.rst                          |   16 -
 Makefile                                                    |    2 
 arch/arc/kernel/perf_event.c                                |   14 -
 arch/arc/mm/init.c                                          |   27 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi                    |    2 
 arch/mips/kernel/perf_event_mipsxx.c                        |    4 
 arch/mips/kernel/smp-bmips.c                                |    2 
 arch/mips/kernel/traps.c                                    |   12 +
 arch/mips/mm/c-r4k.c                                        |    4 
 arch/mips/oprofile/op_model_mipsxx.c                        |    4 
 arch/mips/sni/a20r.c                                        |    4 
 arch/s390/Kconfig                                           |    2 
 arch/s390/include/asm/percpu.h                              |   28 +-
 arch/x86/entry/common.c                                     |   12 -
 arch/x86/include/asm/ptrace.h                               |    2 
 arch/x86/include/asm/switch_to.h                            |   23 ++
 arch/x86/kernel/setup_percpu.c                              |    6 
 arch/x86/kernel/traps.c                                     |   66 ++---
 arch/x86/mm/fault.c                                         |  134 ++++++++++++
 arch/x86/mm/numa_emulation.c                                |    2 
 arch/x86/mm/pti.c                                           |    8 
 arch/x86/mm/tlb.c                                           |   37 +++
 block/blk-core.c                                            |    1 
 block/blk-iocost.c                                          |    5 
 block/blk-stat.c                                            |   17 -
 block/partitions/core.c                                     |   27 +-
 drivers/ata/libata-core.c                                   |    5 
 drivers/ata/libata-scsi.c                                   |    8 
 drivers/block/nbd.c                                         |    2 
 drivers/cpuidle/cpuidle.c                                   |    3 
 drivers/dma/at_hdmac.c                                      |   11 
 drivers/dma/dw-edma/dw-edma-core.c                          |   11 
 drivers/dma/fsldma.h                                        |   12 -
 drivers/dma/of-dma.c                                        |    8 
 drivers/dma/pl330.c                                         |    2 
 drivers/dma/ti/k3-udma.c                                    |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   12 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    2 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c               |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c            |    8 
 drivers/gpu/drm/amd/display/dc/dc_stream.h                  |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c       |    8 
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c        |   14 +
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c            |    2 
 drivers/gpu/drm/i915/display/intel_hdcp.c                   |   26 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                       |   12 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                    |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                 |   20 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c                   |    4 
 drivers/gpu/drm/msm/msm_atomic.c                            |   36 +++
 drivers/gpu/drm/msm/msm_drv.c                               |    8 
 drivers/gpu/drm/omapdrm/omap_crtc.c                         |    3 
 drivers/hid/hid-ids.h                                       |    3 
 drivers/hid/hid-quirks.c                                    |    3 
 drivers/hv/hv_util.c                                        |   65 ++++-
 drivers/hwmon/applesmc.c                                    |   31 +-
 drivers/hwmon/pmbus/isl68137.c                              |    7 
 drivers/i2c/busses/i2c-bcm-iproc.c                          |    4 
 drivers/iommu/Kconfig                                       |    2 
 drivers/iommu/amd/init.c                                    |   21 +
 drivers/iommu/amd/iommu.c                                   |   19 +
 drivers/iommu/intel/iommu.c                                 |   14 -
 drivers/iommu/intel/irq_remapping.c                         |   10 
 drivers/irqchip/irq-ingenic.c                               |    2 
 drivers/md/dm-cache-metadata.c                              |    8 
 drivers/md/dm-crypt.c                                       |    4 
 drivers/md/dm-integrity.c                                   |   12 +
 drivers/md/dm-mpath.c                                       |   22 +
 drivers/md/dm-thin-metadata.c                               |   10 
 drivers/md/dm-writecache.c                                  |   12 -
 drivers/md/persistent-data/dm-block-manager.c               |   14 -
 drivers/media/i2c/Kconfig                                   |    2 
 drivers/media/rc/rc-main.c                                  |   44 ++-
 drivers/media/test-drivers/vicodec/vicodec-core.c           |    1 
 drivers/misc/habanalabs/device.c                            |    7 
 drivers/misc/habanalabs/firmware_if.c                       |    9 
 drivers/misc/habanalabs/gaudi/gaudi.c                       |   90 +++++---
 drivers/misc/habanalabs/gaudi/gaudiP.h                      |    3 
 drivers/misc/habanalabs/gaudi/gaudi_coresight.c             |    8 
 drivers/misc/habanalabs/goya/goya.c                         |   31 ++
 drivers/misc/habanalabs/goya/goya_coresight.c               |    8 
 drivers/misc/habanalabs/habanalabs.h                        |    7 
 drivers/misc/habanalabs/memory.c                            |    9 
 drivers/misc/habanalabs/mmu.c                               |    2 
 drivers/misc/habanalabs/pci.c                               |    6 
 drivers/misc/habanalabs/sysfs.c                             |    7 
 drivers/mmc/host/mtk-sd.c                                   |   13 +
 drivers/mmc/host/sdhci-acpi.c                               |   67 +++++-
 drivers/mmc/host/sdhci-pci-core.c                           |   10 
 drivers/mmc/host/sdhci-tegra.c                              |   53 ++++
 drivers/net/dsa/mt7530.c                                    |    2 
 drivers/net/ethernet/arc/emac_mdio.c                        |    1 
 drivers/net/ethernet/broadcom/bcmsysport.c                  |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |   36 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c           |   16 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    2 
 drivers/net/ethernet/broadcom/tg3.c                         |   17 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c          |    8 
 drivers/net/ethernet/cortina/gemini.c                       |   34 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c               |    9 
 drivers/net/ethernet/mellanox/mlx4/mr.c                     |    2 
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c     |    2 
 drivers/net/ethernet/renesas/ravb_main.c                    |  110 ++++-----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                    |    2 
 drivers/net/ethernet/ti/cpsw.c                              |    2 
 drivers/net/ethernet/ti/cpsw_new.c                          |   29 +-
 drivers/net/gtp.c                                           |    1 
 drivers/net/phy/dp83867.c                                   |    4 
 drivers/net/usb/asix_common.c                               |    2 
 drivers/nvme/host/core.c                                    |    2 
 drivers/nvme/target/core.c                                  |    6 
 drivers/nvme/target/fc.c                                    |    4 
 drivers/opp/core.c                                          |   22 +
 drivers/opp/opp.h                                           |    2 
 drivers/staging/media/sunxi/cedrus/cedrus.c                 |    7 
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c                 |    4 
 drivers/thermal/ti-soc-thermal/omap4-thermal-data.c         |   23 +-
 drivers/thermal/ti-soc-thermal/omap4xxx-bandgap.h           |   10 
 drivers/tty/serial/qcom_geni_serial.c                       |    2 
 drivers/xen/xenbus/xenbus_client.c                          |   10 
 fs/affs/amigaffs.c                                          |   27 ++
 fs/affs/file.c                                              |   26 ++
 fs/afs/fs_probe.c                                           |    4 
 fs/afs/vl_probe.c                                           |    4 
 fs/btrfs/block-group.c                                      |    4 
 fs/btrfs/ctree.c                                            |    6 
 fs/btrfs/extent-tree.c                                      |    2 
 fs/btrfs/extent_io.c                                        |    8 
 fs/btrfs/extent_io.h                                        |    6 
 fs/btrfs/free-space-tree.c                                  |    4 
 fs/btrfs/ioctl.c                                            |   27 +-
 fs/btrfs/scrub.c                                            |  122 ++++++----
 fs/btrfs/tree-checker.c                                     |    2 
 fs/btrfs/volumes.c                                          |    3 
 fs/ceph/file.c                                              |    1 
 fs/eventpoll.c                                              |    6 
 fs/ext2/file.c                                              |    6 
 fs/gfs2/log.c                                               |   31 ++
 fs/gfs2/trans.c                                             |    1 
 fs/io_uring.c                                               |   16 +
 fs/xfs/libxfs/xfs_attr_leaf.c                               |    4 
 fs/xfs/libxfs/xfs_bmap.c                                    |    2 
 fs/xfs/xfs_bmap_util.c                                      |    2 
 fs/xfs/xfs_file.c                                           |   12 -
 include/drm/drm_hdcp.h                                      |    3 
 include/linux/bvec.h                                        |    9 
 include/linux/libata.h                                      |    1 
 include/linux/log2.h                                        |    2 
 include/linux/netfilter/nfnetlink.h                         |    3 
 include/net/af_rxrpc.h                                      |    2 
 include/net/netfilter/nf_tables.h                           |    2 
 include/trace/events/rxrpc.h                                |   27 +-
 include/uapi/linux/netfilter/nf_tables.h                    |    2 
 kernel/bpf/syscall.c                                        |    2 
 mm/hugetlb.c                                                |   49 +++-
 mm/khugepaged.c                                             |    2 
 mm/madvise.c                                                |    2 
 mm/memory.c                                                 |   36 ++-
 mm/migrate.c                                                |   17 +
 mm/rmap.c                                                   |    9 
 mm/slub.c                                                   |   12 -
 net/batman-adv/bat_v_ogm.c                                  |   11 
 net/batman-adv/bridge_loop_avoidance.c                      |    5 
 net/batman-adv/gateway_client.c                             |    6 
 net/bluetooth/hci_core.c                                    |    2 
 net/netfilter/nf_conntrack_proto_udp.c                      |   26 --
 net/netfilter/nf_tables_api.c                               |   64 ++---
 net/netfilter/nfnetlink.c                                   |   11 
 net/netfilter/nfnetlink_log.c                               |    3 
 net/netfilter/nfnetlink_queue.c                             |    2 
 net/netfilter/nft_flow_offload.c                            |    2 
 net/netfilter/nft_payload.c                                 |    4 
 net/packet/af_packet.c                                      |    7 
 net/rxrpc/ar-internal.h                                     |   13 -
 net/rxrpc/call_object.c                                     |    1 
 net/rxrpc/input.c                                           |  123 ++++++-----
 net/rxrpc/output.c                                          |   82 +++++--
 net/rxrpc/peer_object.c                                     |   16 +
 net/rxrpc/rtt.c                                             |    3 
 net/wireless/reg.c                                          |    3 
 scripts/checkpatch.pl                                       |    4 
 scripts/kconfig/streamline_config.pl                        |    5 
 sound/core/oss/mulaw.c                                      |    4 
 sound/firewire/digi00x/digi00x.c                            |    5 
 sound/firewire/tascam/tascam.c                              |   33 ++
 sound/pci/ca0106/ca0106_main.c                              |    3 
 sound/pci/hda/hda_intel.c                                   |    2 
 sound/pci/hda/patch_hdmi.c                                  |    1 
 sound/pci/hda/patch_realtek.c                               |   46 +++-
 sound/usb/pcm.c                                             |    2 
 sound/usb/quirks-table.h                                    |   60 ++++-
 sound/usb/quirks.c                                          |    1 
 tools/include/uapi/linux/perf_event.h                       |    2 
 tools/perf/Documentation/perf-stat.txt                      |    3 
 tools/perf/bench/synthesize.c                               |    4 
 tools/perf/builtin-record.c                                 |    2 
 tools/perf/builtin-sched.c                                  |    6 
 tools/perf/builtin-stat.c                                   |    8 
 tools/perf/builtin-top.c                                    |    2 
 tools/perf/pmu-events/jevents.c                             |    2 
 tools/perf/ui/browsers/hists.c                              |    3 
 tools/perf/util/cs-etm.c                                    |    9 
 tools/perf/util/intel-pt.c                                  |    9 
 tools/perf/util/stat.h                                      |    1 
 tools/testing/selftests/bpf/test_maps.c                     |    2 
 206 files changed, 2038 insertions(+), 781 deletions(-)

Adrian Hunter (1):
      mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers

Adrien Crivelli (1):
      ALSA: hda/realtek: Add quirk for Samsung Galaxy Book Ion NT950XCJ-X716A

Al Grant (3):
      perf cs-etm: Fix corrupt data after perf inject from
      perf intel-pt: Fix corrupt data after perf inject from
      perf tools: Correct SNOOPX field offset

Al Viro (1):
      fix regression in "epoll: Keep a reference on files added to the check list"

Alistair Popple (2):
      mm/rmap: fixup copying of soft dirty and uffd ptes
      mm/migrate: fixup setting UFFD_WP flag

Amit Engel (1):
      nvmet: Disable keep-alive timer when kato is cleared to 0h

Andy Lutomirski (1):
      x86/debug: Allow a single level of #DB recursion

Arnaldo Carvalho de Melo (1):
      perf top/report: Fix infinite loop in the TUI for grouped events

Bob Peterson (1):
      gfs2: add some much needed cleanup for log flushes that fail

Brandon Syu (1):
      drm/amd/display: Keep current gain when ABM disable immediately

Brian Foster (1):
      xfs: finish dfops on every insert range shift iteration

Chris Wilson (1):
      iommu/vt-d: Handle 36bit addressing for x86-32

Christoph Hellwig (1):
      block: fix locking in bdev_del_partition

Christophe JAILLET (1):
      nvmet-fc: Fix a missed _irqsave version of spin_lock in 'nvmet_fc_fod_op_done()'

Damien Le Moal (1):
      dm crypt: Initialize crypto wait structures

Dan Carpenter (1):
      net: gemini: Fix another missing clk_disable_unprepare() in probe

Dan Crawford (1):
      ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO

Dan Murphy (1):
      net: dp83867: Fix WoL SecureOn password

Darrick J. Wong (1):
      xfs: fix xfs_bmap_validate_extent_raw when checking attr fork of rt files

David Ahern (1):
      perf sched timehist: Fix use of CPU list with summary option

David Howells (4):
      rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()
      rxrpc: Fix loss of RTT samples due to interposed ACK
      rxrpc: Make rxrpc_kernel_get_srtt() indicate validity
      mm/khugepaged.c: fix khugepaged's request size in collapse_file

Denis Efremov (1):
      net: bcmgenet: fix mask check in bcmgenet_validate_flow()

Dinghao Liu (4):
      drm/amd/display: Fix memleak in amdgpu_dm_mode_config_init
      net: hns: Fix memleak in hns_nic_dev_probe
      net: systemport: Fix memleak in bcm_sysport_probe
      net: arc_emac: Fix memleak in arc_mdio_probe

Dmitry Baryshkov (1):
      drm/msm/a6xx: fix gmu start on newer firmware

Edwin Peer (1):
      bnxt_en: fix HWRM error when querying VF temperature

Eric Farman (1):
      s390: fix GENERIC_LOCKBREAK dependency typo in Kconfig

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

Florian Westphal (2):
      netfilter: nf_tables: fix destination register zeroing
      netfilter: conntrack: do not auto-delete clash entries on reply

František Kučera (1):
      ALSA: usb-audio: Add basic capture support for Pioneer DJ DJM-250MK2

Furquan Shaikh (1):
      drivers: gpu: amd: Initialize amdgpu_dm_backlight_caps object to 0 in amdgpu_dm_update_backlight_caps

Grant Peltier (1):
      hwmon: (pmbus/isl68137) remove READ_TEMPERATURE_1 telemetry for RAA228228

Greg Kroah-Hartman (1):
      Linux 5.8.8

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpsw: fix rmii 100Mbit link mode

Gustavo Pimentel (1):
      dmaengine: dw-edma: Fix scatter-gather address calculation

Hans Verkuil (1):
      media: vicodec: add missing v4l2_ctrl_request_hdl_put()

He Zhe (1):
      mips/oprofile: Fix fallthrough placement

Himadri Pandya (1):
      net: usb: Fix uninit-was-stored issue in asix_read_phy_addr()

Hou Pu (1):
      nbd: restore default timeout when setting it to zero

Huang Pei (1):
      MIPS: add missing MSACSR and upper MSA initialization

Huang Ying (1):
      x86, fakenuma: Fix invalid starting node ID

Jacopo Mondi (1):
      media: i2c: imx214: select V4L2_FWNODE

Jaehyun Chung (1):
      drm/amd/display: Revert HDCP disable sequence change

Jakub Kicinski (1):
      bnxt: don't enable NAPI until rings are ready

Jason Gunthorpe (1):
      include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Jeff Layton (1):
      ceph: don't allow setlease on cephfs

Jens Axboe (2):
      block: ensure bdi->io_pages is always initialized
      io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file

Jesper Dangaard Brouer (1):
      selftests/bpf: Fix massive output from test_maps

Jin Yao (1):
      perf stat: Turn off summary for interval mode by default

Jiufei Xue (2):
      io_uring: set table->files[i] to NULL when io_sqe_file_register failed
      io_uring: fix removing the wrong file in __io_sqe_files_update()

Joerg Roedel (1):
      mm: track page table modifications in __apply_to_page_range()

Johannes Berg (1):
      cfg80211: regulatory: reject invalid hints

John Stultz (1):
      tty: serial: qcom_geni_serial: Drop __init from qcom_geni_console_setup

Josef Bacik (5):
      btrfs: drop path before adding new uuid tree entry
      btrfs: fix potential deadlock in the search ioctl
      btrfs: allocate scrub workqueues outside of locks
      btrfs: set the correct lockdep class for new nodes
      btrfs: set the lockdep class for log tree extent buffers

Joshua Sivec (1):
      ALSA: usb-audio: Add implicit feedback quirk for UR22C

Jussi Kivilinna (1):
      batman-adv: bla: use netif_rx_ni when not in interrupt context

Kai Vehmanen (1):
      ALSA: hda/hdmi: always check pin power status in i915 pin fixup

Kalyan Thota (2):
      drm/msm/dpu: Fix reservation failures in modeset
      drm/msm/dpu: Fix scale params in plane validation

Keith Busch (1):
      nvme: fix controller instance leak

Krishna Manikandan (1):
      drm/msm: add shutdown support for display platform_driver

Landen Chao (1):
      net: dsa: mt7530: fix advertising unsupported 1000baseT_Half

Li Xinhai (1):
      mm/hugetlb: try preferred node first when alloc gigantic page from cma

Linus Lüssing (1):
      batman-adv: Fix own OGM check in aggregated OGMs

Linus Torvalds (1):
      fsldma: fix very broken 32-bit ppc ioread64 functionality

Louis Peens (1):
      nfp: flower: fix ABI mismatch between driver and firmware

Lu Baolu (1):
      iommu/vt-d: Serialize IOMMU GCMD register modifications

Marcos Paulo de Souza (1):
      btrfs: block-group: fix free-space bitmap threshold

Marek Szyprowski (1):
      dmaengine: pl330: Fix burst length if burst size is smaller than bus width

Max Chou (1):
      Bluetooth: Return NOTIFY_DONE for hci_suspend_notifier

Max Staudt (1):
      affs: fix basic permission bits to actually work

Michael Chan (3):
      bnxt_en: Fix ethtool -S statitics with XDP or TCs enabled.
      bnxt_en: Fix possible crash in bnxt_fw_reset_task().
      tg3: Fix soft lockup when tg3_reset_task() fails.

Mike Rapoport (1):
      arc: fix memory initialization for systems with two memory banks

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

Murali Karicheri (3):
      net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port
      net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port
      net: ethernet: ti: cpsw_new: fix error handling in cpsw_ndo_vlan_rx_kill_vid()

Namhyung Kim (1):
      perf jevents: Fix suspicious code in fixregex()

Nicholas Kazlauskas (1):
      drm/amd/display: Reject overlay plane configurations in multi-display scenarios

Nicolas Dichtel (1):
      gtp: add GTPA_LINK info to msg sent to userspace

Oded Gabbay (1):
      habanalabs: set max power according to card type

Ofir Bitton (6):
      habanalabs: unmap PCI bars upon iATU failure
      habanalabs: validate packet id during CB parse
      habanalabs: set clock gating according to mask
      habanalabs: proper handling of alloc size in coresight
      habanalabs: validate FW file size
      habanalabs: check correct vmalloc return code

Or Cohen (1):
      net/packet: fix overflow in tpacket_rcv

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add NFTA_SET_USERDATA if not null
      netfilter: nf_tables: incorrect enum nft_list_attributes definition
      netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS

Paul Cercueil (1):
      irqchip/ingenic: Leave parent IRQ unmasked on suspend

Pavan Chebbi (1):
      bnxt_en: Don't query FW when netif_running() is false.

Peter Ujfalusi (2):
      dmaengine: of-dma: Fix of_dma_router_xlate's of_dma_xlate handling
      dmaengine: ti: k3-udma: Fix the TR initialization for prep_slave_sg

Peter Zijlstra (2):
      cpuidle: Fixup IRQ state
      x86/entry: Fix AC assertion

Potnuri Bharat Teja (1):
      cxgb4: fix thermal zone device registration

Qu Wenruo (1):
      btrfs: tree-checker: fix the error message for transid error

Randy Dunlap (1):
      kconfig: streamline_config.pl: check defined(ENV variable) before using it

Raul E Rangel (1):
      mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040

Ray Jui (1):
      i2c: iproc: Fix shifting 31 bits

Rob Clark (2):
      drm/msm/dpu: fix unitialized variable error
      drm/msm: enable vblank during atomic commits

Samson Tam (1):
      drm/amd/display: Fix passive dongle mistaken as active dongle in EDID emulation

Sandeep Raghuraman (1):
      drm/amdgpu: Specify get_argument function for ci_smu_funcs

Sasha Levin (1):
      x86/mm/32: Bring back vmalloc faulting on x86_32

Sean Paul (1):
      drm/i915: Fix sha_text population code

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

Suravee Suthikulpanit (2):
      iommu/amd: Restore IRTE.RemapEn bit after programming IRTE
      iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE

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

Tejun Heo (3):
      libata: implement ATA_HORKAGE_MAX_TRIM_128M and apply to Sandisks
      blk-iocost: ioc_pd_free() shouldn't assume irq disabled
      blk-stat: make q->stats->lock irqsafe

Thomas Bogendoerfer (1):
      MIPS: SNI: Fix SCSI interrupt

Tiezhu Yang (3):
      perf top: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set
      MIPS: perf: Fix wrong check condition of Loongson event IDs
      Revert "ALSA: hda: Add support for Loongson 7A1000 controller"

Tom Rix (1):
      hwmon: (applesmc) check status earlier.

Tomi Valkeinen (1):
      drm/omap: fix incorrect lock state

Tong Zhang (2):
      drm/amd/display: should check error using DC_OK
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

Vineeth Pillai (2):
      hv_utils: return error if host timesysnc update is stale
      hv_utils: drain the timesync packets on onchannelcallback

Viresh Kumar (1):
      opp: Don't drop reference for an OPP table that was never parsed

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

Yonghong Song (1):
      bpf: Fix a buffer out-of-bound access when filling raw_tp link_info

Yu Kuai (3):
      dmaengine: at_hdmac: check return value of of_find_device_by_node() in at_dma_xlate()
      dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()
      dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

YueHaibing (1):
      perf bench: The do_run_multi_threaded() function must use IS_ERR(perf_session__new())

Yuusuke Ashizuka (1):
      ravb: Fixed to be able to unload modules

