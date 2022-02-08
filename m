Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782184AE035
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353204AbiBHR6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384580AbiBHRzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:55:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417D4C03FEF3;
        Tue,  8 Feb 2022 09:55:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD6D3B81CB8;
        Tue,  8 Feb 2022 17:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA01BC004E1;
        Tue,  8 Feb 2022 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644342929;
        bh=8Du88Yd6jFshlXYQIrBEhGvK2CTeHZMbDYg+E9vvjNA=;
        h=From:To:Cc:Subject:Date:From;
        b=QdFN3Ubo1ANUGJQVl/hKmkQXgCgL4m5hFCs5WR9L/ejy0PcnUBHgtJa+mTMG/3KCK
         U2wJBMTWoXA0DzcxmQ4Pet5LPJcGPtRcKYNFTIeXg2qkI/gYXgk8Oo57WhHYbrmyiD
         MWvTPGNZ3BK/8YAYZsRrnxivDPij5msTT9uqk2nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.22
Date:   Tue,  8 Feb 2022 18:55:08 +0100
Message-Id: <16443429086762@kroah.com>
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

I'm announcing the release of the 5.15.22 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/gpu/todo.rst                                   |   21 -
 Makefile                                                     |    2 
 arch/arm64/kvm/arm.c                                         |   51 ++-
 arch/arm64/kvm/handle_exit.c                                 |    8 
 arch/arm64/kvm/hyp/include/hyp/switch.h                      |    3 
 arch/x86/events/intel/core.c                                 |   13 
 arch/x86/events/intel/pt.c                                   |    5 
 block/bio-integrity.c                                        |    2 
 drivers/dma-buf/dma-heap.c                                   |    2 
 drivers/edac/altera_edac.c                                   |    2 
 drivers/edac/xgene_edac.c                                    |    2 
 drivers/gpio/gpio-idt3243x.c                                 |    2 
 drivers/gpio/gpio-mpc8xxx.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                      |    3 
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |   20 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c             |   20 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c      |    6 
 drivers/gpu/drm/i915/display/intel_overlay.c                 |    3 
 drivers/gpu/drm/i915/display/intel_tc.c                      |    3 
 drivers/gpu/drm/i915/i915_pci.c                              |    2 
 drivers/gpu/drm/kmb/kmb_plane.c                              |    6 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c              |    2 
 drivers/infiniband/core/cm.c                                 |    2 
 drivers/infiniband/core/cma.c                                |   22 -
 drivers/infiniband/core/ucma.c                               |   34 +-
 drivers/infiniband/hw/hfi1/ipoib_main.c                      |   27 +
 drivers/infiniband/hw/mlx4/main.c                            |    2 
 drivers/infiniband/sw/rdmavt/qp.c                            |    2 
 drivers/infiniband/sw/siw/siw.h                              |    7 
 drivers/infiniband/sw/siw/siw_qp_rx.c                        |   20 -
 drivers/infiniband/sw/siw/siw_verbs.c                        |    3 
 drivers/iommu/amd/init.c                                     |    2 
 drivers/iommu/intel/irq_remapping.c                          |   13 
 drivers/net/dsa/Kconfig                                      |    1 
 drivers/net/ethernet/google/gve/gve_adminq.c                 |    2 
 drivers/net/ethernet/intel/e1000e/e1000.h                    |    4 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |   20 +
 drivers/net/ethernet/intel/e1000e/netdev.c                   |   33 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c         |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h              |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c         |   19 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c        |   19 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            |    6 
 drivers/net/ieee802154/ca8210.c                              |    1 
 drivers/net/ieee802154/mac802154_hwsim.c                     |    1 
 drivers/net/ieee802154/mcr20a.c                              |    4 
 drivers/net/macsec.c                                         |   33 +-
 drivers/nvme/host/fabrics.h                                  |    1 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                        |   23 +
 drivers/pinctrl/intel/pinctrl-intel.c                        |   64 ++--
 drivers/pinctrl/sunxi/pinctrl-sun50i-h616.c                  |    8 
 drivers/rtc/rtc-mc146818-lib.c                               |    2 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                            |   21 -
 drivers/soc/mediatek/mtk-scpsys.c                            |   15 -
 drivers/spi/spi-bcm-qspi.c                                   |    2 
 drivers/spi/spi-meson-spicc.c                                |    5 
 drivers/spi/spi-mt65xx.c                                     |    2 
 drivers/spi/spi-stm32-qspi.c                                 |   47 +--
 drivers/spi/spi-uniphier.c                                   |   18 +
 drivers/video/console/Kconfig                                |   20 +
 drivers/video/fbdev/core/fbcon.c                             |   68 ++++
 drivers/video/fbdev/core/fbcon.h                             |   15 +
 drivers/video/fbdev/core/fbcon_ccw.c                         |   10 
 drivers/video/fbdev/core/fbcon_cw.c                          |   10 
 drivers/video/fbdev/core/fbcon_rotate.h                      |    4 
 drivers/video/fbdev/core/fbcon_ud.c                          |   20 -
 fs/9p/fid.c                                                  |    9 
 fs/btrfs/block-group.c                                       |   13 
 fs/btrfs/ioctl.c                                             |    5 
 fs/btrfs/qgroup.c                                            |   21 +
 fs/btrfs/transaction.c                                       |   24 +
 fs/btrfs/transaction.h                                       |    2 
 fs/ext4/ext4.h                                               |    3 
 fs/ext4/extents.c                                            |    4 
 fs/ext4/fast_commit.c                                        |   89 +++---
 fs/ext4/inline.c                                             |   10 
 fs/ext4/mballoc.c                                            |   26 +
 fs/nfsd/nfs4state.c                                          |    4 
 include/linux/kvm_host.h                                     |  112 +++++++-
 include/linux/pgtable.h                                      |    1 
 include/uapi/sound/asound.h                                  |    4 
 ipc/sem.c                                                    |    4 
 kernel/audit.c                                               |   62 +++-
 kernel/bpf/ringbuf.c                                         |    2 
 kernel/cgroup/cpuset.c                                       |   10 
 kernel/events/core.c                                         |   16 +
 mm/debug_vm_pgtable.c                                        |    2 
 mm/kmemleak.c                                                |   13 
 net/bridge/netfilter/nft_reject_bridge.c                     |    8 
 net/ieee802154/nl802154.c                                    |    8 
 net/mptcp/pm_netlink.c                                       |   34 +-
 net/smc/af_smc.c                                             |  133 ++++++++-
 net/smc/smc.h                                                |   20 +
 security/selinux/ss/conditional.c                            |    3 
 sound/pci/hda/hda_auto_parser.c                              |    2 
 sound/pci/hda/hda_codec.c                                    |    4 
 sound/pci/hda/hda_generic.c                                  |   17 +
 sound/pci/hda/hda_generic.h                                  |    3 
 sound/pci/hda/patch_realtek.c                                |   67 +++-
 sound/soc/codecs/cpcap.c                                     |    2 
 sound/soc/codecs/hdmi-codec.c                                |    2 
 sound/soc/codecs/lpass-rx-macro.c                            |    8 
 sound/soc/codecs/max9759.c                                   |    3 
 sound/soc/codecs/wcd938x.c                                   |   31 +-
 sound/soc/fsl/pcm030-audio-fabric.c                          |   11 
 sound/soc/generic/simple-card.c                              |   26 +
 sound/soc/soc-ops.c                                          |   29 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c                        |   27 +
 sound/usb/mixer.c                                            |    4 
 sound/usb/quirks-table.h                                     |    2 
 tools/bpf/resolve_btfids/Makefile                            |    6 
 tools/include/uapi/sound/asound.h                            |    4 
 tools/perf/util/stat-display.c                               |   19 -
 tools/testing/selftests/exec/Makefile                        |    2 
 tools/testing/selftests/futex/Makefile                       |    4 
 tools/testing/selftests/netfilter/nft_concat_range.sh        |   72 +++++
 tools/testing/selftests/netfilter/nft_nat.sh                 |  152 +++++++++++
 117 files changed, 1469 insertions(+), 492 deletions(-)

Albert Geantă (1):
      ALSA: hda/realtek: Add quirk for ASUS GU603

Andre Przywara (1):
      pinctrl: sunxi: Fix H616 I2S3 pin data

Andy Shevchenko (1):
      pinctrl: intel: Fix a glitch when updating IRQ flags on a preconfigured line

Anitha Chrisanthus (1):
      drm/kmb: Fix for build errors with Warray-bounds

Arnaldo Carvalho de Melo (1):
      tools include UAPI: Sync sound/asound.h copy with the kernel sources

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

Dan Carpenter (3):
      RDMA/siw: Fix refcounting leak in siw_create_qp()
      drm/i915/overlay: Prevent divide by zero bugs in scaling
      ASoC: max9759: fix underflow in speaker_gain_control_put()

Dmitry Osipenko (1):
      ASoC: hdmi-codec: Fix OOB memory accesses

Dominique Martinet (1):
      Revert "fs/9p: search open fids first"

Evan Quan (1):
      drm/amd/pm: correct the MGpuFanBoost support for Beige Goby

Filipe Manana (1):
      btrfs: fix use-after-free after failure to create a snapshot

Florian Fainelli (1):
      pinctrl: bcm2835: Fix a few error paths

Florian Westphal (2):
      selftests: nft_concat_range: add test for reload with no element add/del
      selftests: netfilter: check stateless nat udp checksum fixup

Greg Kroah-Hartman (1):
      Linux 5.15.22

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

Imre Deak (1):
      drm/i915/adlp: Fix TypeC PHY-ready status readout

James Morse (2):
      KVM: arm64: Avoid consuming a stale esr value when SError occur
      KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs

Jiasheng Jiang (1):
      ASoC: cpcap: Check for NULL pointer after calling of_get_child_by_name

Jisheng Zhang (1):
      net: stmmac: properly handle with runtime pm in stmmac_dvr_remove()

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

Marco Elver (1):
      perf: Copy perf_event_attr::sig_data on modification

Mario Limonciello (1):
      drm/amd: avoid suspend on dGPUs w/ s2idle support when runtime PM enabled

Mark Brown (3):
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
      ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
      ASoC: ops: Reject out of bounds values in snd_soc_put_xr_sx()

Mark Rutland (2):
      kvm: add guest_state_{enter,exit}_irqoff()
      kvm/arm64: rework guest entry logic

Mark Zhang (1):
      IB/cm: Release previously acquired reference counter in the cm_id_priv

Martin K. Petersen (1):
      block: bio-integrity: Advance seed correctly for larger interval sizes

Miaoqian Lin (2):
      spi: meson-spicc: add IRQ check in meson_spicc_probe
      ASoC: fsl: Add missing error handling in pcm030_fabric_probe

Mike Marciniszyn (3):
      IB/hfi1: Fix AIP early init panic
      IB/rdmavt: Validate remote_addr during loopback atomic tests
      IB/hfi1: Fix tstats alloc and dealloc

Mike Rapoport (1):
      mm/pgtable: define pte_index so that preprocessor could recognize it

Minghao Chi (1):
      ipc/sem: do not sleep with a spin lock held

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

Paolo Abeni (1):
      mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()

Pasha Tatashin (1):
      mm/debug_vm_pgtable: remove pte entry from the page table

Patrice Chotard (1):
      spi: stm32-qspi: Update spi registering

Paul Hsieh (1):
      drm/amd/display: watermark latencies is not enough on DCN31

Paul Moore (1):
      audit: improve audit queue handling when "audit=1" on cmdline

Peter Ujfalusi (1):
      ALSA: hda: Skip codec shutdown in case the codec is not registered

Peter Zijlstra (1):
      x86/perf: Default set FREEZE_ON_SMI for all

Phil Sutter (1):
      netfilter: nft_reject_bridge: Fix for missing reply from prerouting

Qu Wenruo (1):
      btrfs: don't start transaction for scrub if the fs is mounted read-only

Ritesh Harjani (2):
      ext4: fix error handling in ext4_restore_inline_data()
      ext4: fix error handling in ext4_fc_record_modified_inode()

Riwen Lu (1):
      rtc: cmos: Evaluate century appropriate

Robert Hancock (2):
      ASoC: xilinx: xlnx_formatter_pcm: Make buffer bytes multiple of period bytes
      ASoC: simple-card: fix probe failure on platform component

Sasha Neftin (1):
      e1000e: Separate ADP board type from TGP

Sergey Shtylyov (2):
      EDAC/altera: Fix deferred probing
      EDAC/xgene: Fix deferred probing

Shin'ichiro Kawasaki (1):
      btrfs: fix deadlock between quota disable and qgroup rescan worker

Srinivas Kandagatla (3):
      ASoC: codecs: wcd938x: fix incorrect used of portid
      ASoC: codecs: lpass-rx-macro: fix sidetone register offsets
      ASoC: codecs: wcd938x: fix return value of mixer put function

Takashi Iwai (3):
      ALSA: hda: Fix UAF of leds class devs at unbinding
      ALSA: hda: realtek: Fix race at concurrent COEF updates
      ALSA: hda: Fix signedness of sscanf() arguments

Tom Rix (1):
      ALSA: usb-audio: initialize variables that could ignore errors

Tristan Hume (1):
      perf/x86/intel/pt: Fix crash with stop filters in single-range mode

Uday Shankar (1):
      nvme-fabrics: fix state check in nvmf_ctlr_matches_baseopts()

Ville Syrjälä (1):
      drm/i915: Disable DSB usage for now

Vratislav Bendel (1):
      selinux: fix double free of cond_list on error paths

Waiman Long (1):
      cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning

Wen Gu (1):
      net/smc: Forward wakeup to smc socket waitqueue after fallback

Xin Xiong (1):
      spi: uniphier: fix reference count leak in uniphier_spi_probe()

Xin Yin (3):
      ext4: prevent used blocks from being allocated during fast commit replay
      ext4: modify the logic of ext4_mb_new_blocks_simple
      ext4: fix incorrect type issue during replay_del_range

Yang Li (2):
      gpio: idt3243x: Fix an ignored error return from platform_get_irq()
      gpio: mpc8xxx: Fix an ignored error return from platform_get_irq()

Yannick Vignon (1):
      net: stmmac: ensure PTP time register reads are consistent

Yuji Ishikawa (1):
      net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.

Łukasz Bartosik (1):
      pinctrl: intel: fix unexpected interrupt

