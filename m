Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22404AE005
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384435AbiBHRzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384469AbiBHRzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:55:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45B3C0611DA;
        Tue,  8 Feb 2022 09:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FEBE617EB;
        Tue,  8 Feb 2022 17:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D3C340EC;
        Tue,  8 Feb 2022 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342921;
        bh=4XKJLjUi+U4JW5QMbXlnuojXxOzaZvxcWogiWXufCq4=;
        h=From:To:Cc:Subject:Date:From;
        b=Mne2yQh7T3PaDxstTO1fmRGUS7+GXvEA7NoV4fN+cYhjmgn/lTkVCp1rZVHQVHjLr
         5HqDLFiSruX7d5DnMhOTxGzeMQc3aYgBAD5mzJnI/zpsg/sHUHzwMzNqFcMsMWQ/NA
         yT2LfFiGQoDZiEcQIkV8vb3r4xlrgC2O6kOBOFX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.99
Date:   Tue,  8 Feb 2022 18:55:01 +0100
Message-Id: <1644342901205107@kroah.com>
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

I'm announcing the release of the 5.10.99 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/gpu/todo.rst                            |   18 ---
 Makefile                                              |    2 
 arch/x86/events/intel/core.c                          |   13 ++
 arch/x86/events/intel/pt.c                            |    5 -
 block/bio-integrity.c                                 |    2 
 drivers/dma-buf/dma-heap.c                            |    2 
 drivers/edac/altera_edac.c                            |    2 
 drivers/edac/xgene_edac.c                             |    2 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c      |   20 ++++
 drivers/gpu/drm/i915/display/intel_overlay.c          |    3 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c       |    2 
 drivers/infiniband/core/cma.c                         |   22 ++--
 drivers/infiniband/core/ucma.c                        |   34 ++++--
 drivers/infiniband/hw/hfi1/ipoib_main.c               |   13 --
 drivers/infiniband/hw/mlx4/main.c                     |    2 
 drivers/infiniband/sw/rdmavt/qp.c                     |    2 
 drivers/infiniband/sw/siw/siw.h                       |    7 -
 drivers/infiniband/sw/siw/siw_qp_rx.c                 |   20 ++--
 drivers/iommu/amd/init.c                              |    2 
 drivers/iommu/intel/irq_remapping.c                   |   13 ++
 drivers/net/dsa/Kconfig                               |    1 
 drivers/net/ethernet/google/gve/gve_adminq.c          |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h       |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c  |   19 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |   19 ++-
 drivers/net/ieee802154/ca8210.c                       |    1 
 drivers/net/ieee802154/mac802154_hwsim.c              |    1 
 drivers/net/ieee802154/mcr20a.c                       |    4 
 drivers/net/macsec.c                                  |   33 ++++--
 drivers/nvme/host/fabrics.h                           |    1 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                 |   23 +++-
 drivers/pinctrl/intel/pinctrl-intel.c                 |   64 +++++++-----
 drivers/rtc/rtc-mc146818-lib.c                        |    2 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                     |   21 ++--
 drivers/soc/mediatek/mtk-scpsys.c                     |   15 ---
 drivers/spi/spi-bcm-qspi.c                            |    2 
 drivers/spi/spi-meson-spicc.c                         |    5 +
 drivers/spi/spi-mt65xx.c                              |    2 
 drivers/spi/spi-uniphier.c                            |   18 ++-
 drivers/video/console/Kconfig                         |   20 ++++
 drivers/video/fbdev/core/fbcon.c                      |   68 +++++++++++--
 drivers/video/fbdev/core/fbcon.h                      |   15 ++-
 drivers/video/fbdev/core/fbcon_ccw.c                  |   10 +-
 drivers/video/fbdev/core/fbcon_cw.c                   |   10 +-
 drivers/video/fbdev/core/fbcon_rotate.h               |    4 
 drivers/video/fbdev/core/fbcon_ud.c                   |   20 ++--
 fs/btrfs/qgroup.c                                     |   21 +++-
 fs/ext4/ext4.h                                        |    3 
 fs/ext4/extents.c                                     |    4 
 fs/ext4/fast_commit.c                                 |   89 +++++++++---------
 fs/ext4/inline.c                                      |   10 +-
 fs/ext4/mballoc.c                                     |   26 +++--
 fs/fs_context.c                                       |    4 
 fs/nfsd/nfs4state.c                                   |    4 
 include/linux/pgtable.h                               |    1 
 kernel/audit.c                                        |   62 ++++++++----
 kernel/bpf/ringbuf.c                                  |    2 
 kernel/cgroup/cpuset.c                                |   10 ++
 mm/debug_vm_pgtable.c                                 |    2 
 mm/kmemleak.c                                         |   13 +-
 net/ieee802154/nl802154.c                             |    8 -
 security/selinux/ss/conditional.c                     |    3 
 sound/pci/hda/hda_generic.c                           |   17 +++
 sound/pci/hda/hda_generic.h                           |    3 
 sound/pci/hda/patch_realtek.c                         |   67 +++++++++++--
 sound/soc/codecs/cpcap.c                              |    2 
 sound/soc/codecs/max9759.c                            |    3 
 sound/soc/fsl/pcm030-audio-fabric.c                   |   11 +-
 sound/soc/soc-ops.c                                   |   29 +++++
 sound/soc/xilinx/xlnx_formatter_pcm.c                 |   27 ++++-
 sound/usb/quirks-table.h                              |    2 
 tools/bpf/resolve_btfids/Makefile                     |    6 +
 tools/perf/util/stat-display.c                        |   19 ++-
 tools/testing/selftests/exec/Makefile                 |    2 
 tools/testing/selftests/futex/Makefile                |    4 
 tools/testing/selftests/netfilter/nft_concat_range.sh |   72 ++++++++++++++
 76 files changed, 771 insertions(+), 322 deletions(-)

Albert Geantă (1):
      ALSA: hda/realtek: Add quirk for ASUS GU603

Andy Shevchenko (1):
      pinctrl: intel: Fix a glitch when updating IRQ flags on a preconfigured line

Arınç ÜNAL (1):
      net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY

Aun-Ali Zaidi (1):
      drm/amd/display: Force link_rate as LINK_RATE_RBR2 for 2018 15" Apple Retina panels

Benjamin Gaignard (1):
      spi: mediatek: Avoid NULL pointer crash in interrupt

Bernard Metzler (1):
      RDMA/siw: Fix broken RDMA Read Fence/Resume logic.

Camel Guo (1):
      net: stmmac: dump gmac4 DMA registers correctly

Christian Lachner (3):
      ALSA: hda/realtek: Add missing fixup-model entry for Gigabyte X570 ALC1220 quirks
      ALSA: hda/realtek: Fix silent output on Gigabyte X570S Aorus Master (newer chipset)
      ALSA: hda/realtek: Fix silent output on Gigabyte X570 Aorus Xtreme after reboot from Windows

Dai Ngo (1):
      nfsd: nfsd4_setclientid_confirm mistakenly expires confirmed client.

Dan Carpenter (2):
      drm/i915/overlay: Prevent divide by zero bugs in scaling
      ASoC: max9759: fix underflow in speaker_gain_control_put()

Florian Fainelli (1):
      pinctrl: bcm2835: Fix a few error paths

Florian Westphal (1):
      selftests: nft_concat_range: add test for reload with no element add/del

Greg Kroah-Hartman (1):
      Linux 5.10.99

Guenter Roeck (1):
      Revert "ASoC: mediatek: Check for error clk pointer"

Guoqing Jiang (1):
      iommu/vt-d: Fix potential memory leak in intel_setup_irq_remapping()

Haiyue Wang (1):
      gve: fix the wrong AdminQ buffer queue index check

Helge Deller (2):
      Revert "fbcon: Disable accelerated scrolling"
      fbcon: Add option to enable legacy hardware acceleration

Hou Tao (1):
      bpf: Use VM_MAP instead of VM_ALLOC for ringbuf

Ian Rogers (1):
      perf stat: Fix display of grouped aliased events

Jiasheng Jiang (1):
      ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name

Joerg Roedel (1):
      iommu/amd: Fix loop timeout issue in iommu_ga_log_enable()

John Meneghini (1):
      scsi: bnx2fc: Make bnx2fc_recv_frame() mp safe

Jonas Hahnfeld (1):
      ALSA: usb-audio: Correct quirk for VF0770

Jordy Zomer (1):
      dma-buf: heaps: Fix potential spectre v1 gadget

Kamal Dasu (1):
      spi: bcm-qspi: check for valid cs before applying chip select

Lang Yu (1):
      mm/kmemleak: avoid scanning potential huge holes

Leon Romanovsky (2):
      RDMA/ucma: Protect mc during concurrent multicast leaves
      RDMA/mlx4: Don't continue event handler after memory allocation failure

Lior Nahmanson (2):
      net: macsec: Fix offload support for NETDEV_UNREGISTER event
      net: macsec: Verify that send_sci is on when setting Tx sci explicitly

Maor Gottlieb (1):
      RDMA/cma: Use correct address when leaving multicast group

Mark Brown (3):
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
      ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Martin K. Petersen (1):
      block: bio-integrity: Advance seed correctly for larger interval sizes

Miaoqian Lin (2):
      spi: meson-spicc: add IRQ check in meson_spicc_probe
      ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Mike Marciniszyn (2):
      IB/hfi1: Fix AIP early init panic
      IB/rdmavt: Validate remote_addr during loopback atomic tests

Mike Rapoport (1):
      mm/pgtable: define pte_index so that preprocessor could recognize it

Miquel Raynal (4):
      net: ieee802154: hwsim: Ensure proper channel selection at probe time
      net: ieee802154: mcr20a: Fix lifs/sifs periods
      net: ieee802154: ca8210: Stop leaking skb's
      net: ieee802154: Return meaningful error codes from the netlink helpers

Muhammad Usama Anjum (2):
      selftests/exec: Remove pipe from TEST_GEN_FILES
      selftests: futex: Use variable MAKE instead of make

Nathan Chancellor (1):
      tools/resolve_btfids: Do not print any commands when building silently

Nick Lopez (1):
      drm/nouveau: fix off by one in BIOS boundary checking

Pasha Tatashin (1):
      mm/debug_vm_pgtable: remove pte entry from the page table

Paul Moore (1):
      audit: improve audit queue handling when "audit=1" on cmdline

Peter Zijlstra (1):
      x86/perf: Default set FREEZE_ON_SMI for all

Ritesh Harjani (2):
      ext4: fix error handling in ext4_restore_inline_data()
      ext4: fix error handling in ext4_fc_record_modified_inode()

Riwen Lu (1):
      rtc: cmos: Evaluate century appropriate

Robert Hancock (1):
      ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes

Sergey Shtylyov (2):
      EDAC/altera: Fix deferred probing
      EDAC/xgene: Fix deferred probing

Shin'ichiro Kawasaki (1):
      btrfs: fix deadlock between quota disable and qgroup rescan worker

Takashi Iwai (2):
      ALSA: hda: Fix UAF of leds class devs at unbinding
      ALSA: hda: realtek: Fix race at concurrent COEF updates

Tristan Hume (1):
      perf/x86/intel/pt: Fix crash with stop filters in single-range mode

Uday Shankar (1):
      nvme-fabrics: fix state check in nvmf_ctlr_matches_baseopts()

Vratislav Bendel (1):
      selinux: fix double free of cond_list on error paths

Waiman Long (1):
      cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Xin Xiong (1):
      spi: uniphier: fix reference count leak in uniphier_spi_probe()

Xin Yin (3):
      ext4: prevent used blocks from being allocated during fast commit replay
      ext4: modify the logic of ext4_mb_new_blocks_simple
      ext4: fix incorrect type issue during replay_del_range

Yannick Vignon (1):
      net: stmmac: ensure PTP time register reads are consistent

Yutian Yang (1):
      memcg: charge fs_context and legacy_fs_context

Łukasz Bartosik (1):
      pinctrl: intel: fix unexpected interrupt

