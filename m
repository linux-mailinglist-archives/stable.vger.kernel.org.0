Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10938511A9F
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiD0NOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 09:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbiD0NOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 09:14:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E350039BBEA;
        Wed, 27 Apr 2022 06:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5529661BBE;
        Wed, 27 Apr 2022 13:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6030DC385A7;
        Wed, 27 Apr 2022 13:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651065096;
        bh=yT58KrG9K7lwWsv/Ds3xMWKwliUI7wCTCXv4UFFq4eA=;
        h=From:To:Cc:Subject:Date:From;
        b=nhd2tfIYsaXeJomcnIkEP+5KmM4wIvdnjlU/YVccLgD2dx1oGKjThohSSFMc/QgZ+
         Rzz5a6NC2gHh032GHYPjQ1X+18DCr8mMLrjkBpDIhPnoq1UvEj9ffGtaWqbHmhALr1
         sjuINOVF24zHd0f1EY7v11Iss2G5ZdWMvdwWYENI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.113
Date:   Wed, 27 Apr 2022 15:11:28 +0200
Message-Id: <165106508947180@kroah.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.113 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4/attributes.rst               |    2 
 Makefile                                                    |    2 
 arch/arc/kernel/entry.S                                     |    1 
 arch/arm/mach-vexpress/spc.c                                |    2 
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi           |    8 -
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi           |    8 -
 arch/arm64/include/asm/pgtable.h                            |    9 -
 arch/powerpc/kvm/book3s_64_vio.c                            |   45 ++++---
 arch/powerpc/kvm/book3s_64_vio_hv.c                         |   44 +++----
 arch/powerpc/perf/power9-pmu.c                              |    8 -
 arch/x86/include/asm/compat.h                               |    6 -
 arch/xtensa/kernel/coprocessor.S                            |    4 
 arch/xtensa/kernel/jump_label.c                             |    2 
 block/ioctl.c                                               |    2 
 drivers/ata/pata_marvell.c                                  |    2 
 drivers/dma/at_xdmac.c                                      |   12 +-
 drivers/dma/idxd/sysfs.c                                    |    6 +
 drivers/dma/imx-sdma.c                                      |    4 
 drivers/dma/mediatek/mtk-uart-apdma.c                       |    9 +
 drivers/edac/synopsys_edac.c                                |   16 +-
 drivers/gpio/gpiolib.c                                      |    4 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                  |    3 
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c       |   13 +-
 drivers/gpu/drm/vc4/vc4_dsi.c                               |    2 
 drivers/md/dm.c                                             |   17 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c             |    8 -
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c        |    8 -
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c             |   24 ++--
 drivers/net/ethernet/cadence/macb_main.c                    |    8 +
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c          |    8 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c                 |    4 
 drivers/net/ethernet/intel/igc/igc_i225.c                   |   11 +
 drivers/net/ethernet/intel/igc/igc_phy.c                    |    4 
 drivers/net/ethernet/micrel/Kconfig                         |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c       |    4 
 drivers/net/vxlan.c                                         |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    2 
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c             |    2 
 drivers/nvme/host/core.c                                    |   24 +++-
 drivers/nvme/host/nvme.h                                    |    5 
 drivers/nvme/host/pci.c                                     |    5 
 drivers/perf/arm_pmu.c                                      |   10 -
 drivers/platform/x86/samsung-laptop.c                       |    2 
 drivers/reset/tegra/reset-bpmp.c                            |    9 +
 drivers/scsi/qedi/qedi_iscsi.c                              |   69 +++++-------
 drivers/spi/atmel-quadspi.c                                 |    3 
 drivers/spi/spi-mtk-nor.c                                   |   12 +-
 drivers/staging/android/ion/ion.c                           |    3 
 fs/cifs/cifsfs.c                                            |    2 
 fs/ext4/ext4.h                                              |    6 -
 fs/ext4/extents.c                                           |   32 ++++-
 fs/ext4/inode.c                                             |   18 ++-
 fs/ext4/namei.c                                             |    4 
 fs/ext4/page-io.c                                           |    4 
 fs/ext4/super.c                                             |   19 ++-
 fs/gfs2/rgrp.c                                              |    9 -
 fs/hugetlbfs/inode.c                                        |    9 -
 fs/jbd2/commit.c                                            |    4 
 fs/stat.c                                                   |   19 +--
 include/linux/etherdevice.h                                 |    5 
 include/linux/sched.h                                       |    1 
 include/linux/sched/mm.h                                    |    8 +
 include/net/esp.h                                           |    2 
 include/net/netns/ipv6.h                                    |    4 
 kernel/events/core.c                                        |    2 
 kernel/events/internal.h                                    |    5 
 kernel/events/ring_buffer.c                                 |    5 
 kernel/sched/fair.c                                         |   10 -
 kernel/trace/trace_events_trigger.c                         |    9 +
 mm/mmap.c                                                   |    8 -
 mm/mmu_notifier.c                                           |   14 ++
 mm/oom_kill.c                                               |   54 ++++++---
 mm/page_alloc.c                                             |    2 
 net/can/isotp.c                                             |   10 +
 net/ipv4/esp4.c                                             |    5 
 net/ipv6/esp6.c                                             |    5 
 net/ipv6/ip6_gre.c                                          |   14 +-
 net/ipv6/route.c                                            |   11 +
 net/l3mdev/l3mdev.c                                         |    2 
 net/netlink/af_netlink.c                                    |    7 +
 net/openvswitch/flow_netlink.c                              |    2 
 net/packet/af_packet.c                                      |   13 +-
 net/rxrpc/net_ns.c                                          |    2 
 net/sched/cls_u32.c                                         |   24 ++--
 net/smc/af_smc.c                                            |    4 
 sound/pci/hda/patch_realtek.c                               |    1 
 sound/soc/atmel/sam9g20_wm8731.c                            |   61 ----------
 sound/soc/codecs/msm8916-wcd-digital.c                      |    9 +
 sound/soc/codecs/wcd934x.c                                  |   26 ----
 sound/soc/soc-dapm.c                                        |    6 -
 sound/usb/midi.c                                            |    1 
 sound/usb/usbaudio.h                                        |    2 
 tools/lib/perf/evlist.c                                     |    3 
 tools/perf/builtin-report.c                                 |   14 ++
 tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh |   17 ++
 95 files changed, 561 insertions(+), 394 deletions(-)

Adrian Hunter (1):
      perf tools: Fix segfault accessing sample_id xyarray

Alexey Kardashevskiy (1):
      KVM: PPC: Fix TCE handling for VFIO

Alistair Popple (1):
      mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

Allen-KH Cheng (1):
      spi: spi-mtk-nor: initialize spi controller after resume

Anshuman Khandual (1):
      arm64/mm: Remove [PUD|PMD]_TABLE_BIT from [pud|pmd]_bad()

Athira Rajeev (1):
      powerpc/perf: Fix power9 event alternatives

Bob Peterson (1):
      gfs2: assign rgrp glock before compute_bitstructs

Borislav Petkov (3):
      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
      mt76: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Christoph Hellwig (2):
      nvme: add a quirk to disable namespace identifiers
      nvme-pci: disable namespace identifiers for Qemu controllers

Christophe Leroy (1):
      mm, hugetlb: allow for "high" userspace addresses

Daniel Bristot de Oliveira (1):
      tracing: Dump stacktrace trigger to the corresponding instance

Darrick J. Wong (1):
      ext4: fix fallocate to use file_modified to update permissions consistently

Dave Jiang (2):
      dmaengine: idxd: add RO check for wq max_batch_size write
      dmaengine: idxd: add RO check for wq max_transfer_size write

Dave Stevenson (2):
      drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised
      drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare

David Ahern (1):
      l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu

David Howells (2):
      rxrpc: Restore removed timer deletion
      cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Eric Dumazet (4):
      net/sched: cls_u32: fix netns refcount changes in u32_change()
      net/sched: cls_u32: fix possible leak in u32_init_knode()
      ipv6: make ip6_rt_gc_expire an atomic_t
      netlink: reset network and mac headers in netlink_dump()

Greg Kroah-Hartman (1):
      Linux 5.10.113

Guo Ren (1):
      xtensa: patch_text: Fixup last cpu should be master

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Ido Schimmel (1):
      selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets

Jiapeng Chong (1):
      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

Kai-Heng Feng (1):
      net: atlantic: Avoid out-of-bounds indexing

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      ARM: vexpress/spc: Avoid negative array index when !SMP

Kevin Hao (1):
      net: stmmac: Use readl_poll_timeout_atomic() in atomic state

Khazhismel Kumykov (1):
      block/compat_ioctl: fix range check in BLKGETSIZE

Lee Jones (1):
      staging: ion: Prevent incorrect reference counting behavour

Leo Yan (1):
      perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event

Lv Ruyi (1):
      dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Manuel Ullmann (1):
      net: atlantic: invert deep par in pm functions, preventing null derefs

Marek Vasut (1):
      Revert "net: micrel: fix KS8851_MLL Kconfig"

Mario Limonciello (1):
      gpio: Request interrupts after IRQ is initialized

Mark Brown (1):
      ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Max Filippov (1):
      xtensa: fix a7 clobbering in coprocessor context load/store

Miaoqian Lin (3):
      ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
      dmaengine: imx-sdma: Fix error checking in sdma_event_remap
      drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage

Mike Christie (1):
      scsi: qedi: Fix failed disconnect handling

Mikulas Patocka (1):
      stat: fix inconsistency between struct stat and struct compat_stat

Muchun Song (1):
      arm64: mm: fix p?d_leaf()

Nico Pache (1):
      oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Oliver Hartkopp (1):
      can: isotp: stop timeout monitoring when no first frame was sent

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Peilin Ye (2):
      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
      ip6_gre: Fix skb_under_panic in __gre6_xmit()

Rob Herring (2):
      arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes
      arm_pmu: Validate single/group leader events

Sabrina Dubroca (1):
      esp: limit skb_page_frag_refill use to a single page

Sameer Pujar (1):
      reset: tegra-bpmp: Restore Handle errors in BPMP response

Sasha Neftin (3):
      igc: Fix infinite loop in release_swfw_sync
      igc: Fix BUG: scheduling while atomic
      e1000e: Fix possible overflow in LTR decoding

Sergey Matyukevich (1):
      ARC: entry: fix syscall_trace_exit argument

Shubhrajyoti Datta (1):
      EDAC/synopsys: Read the error count from the correct register

Srinivas Kandagatla (1):
      ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use

Tadeusz Struk (1):
      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Takashi Iwai (1):
      ALSA: usb-audio: Clear MIDI port active flag after draining

Theodore Ts'o (2):
      ext4: fix overhead calculation to account for the reserved gdt blocks
      ext4: force overhead calculation if the s_overhead_cluster makes no sense

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo NP70PNP

Tomas Melin (1):
      net: macb: Restart tx only if queue pointer is lagging

Tony Lu (1):
      net/smc: Fix sock leak when release after smc_shutdown()

Tudor Ambarus (1):
      spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Xiaoke Wang (1):
      drm/msm/mdp5: check the return of kzalloc()

Xiaomeng Tong (2):
      dma: at_xdmac: fix a missing check on list iterator
      ASoC: soc-dapm: fix two incorrect uses of list iterator

Xiongwei Song (1):
      mm: page_alloc: fix building error on -Werror=array-compare

Ye Bin (3):
      ext4: fix symlink file size not match to file content
      ext4: fix use-after-free in ext4_search_dir
      jbd2: fix a potential race while discarding reserved buffers after an abort

Zheyu Ma (1):
      ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Zhipeng Xie (1):
      perf/core: Fix perf_mmap fail when CONFIG_PERF_USE_VMALLOC enabled

kuyo chang (1):
      sched/pelt: Fix attach_entity_load_avg() corner case

wangjianjian (C) (1):
      ext4, doc: fix incorrect h_reserved size

zhangqilong (1):
      dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

