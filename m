Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCDF5119BB
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 16:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiD0NPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 09:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbiD0NPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 09:15:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66733A234F;
        Wed, 27 Apr 2022 06:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC93B826FA;
        Wed, 27 Apr 2022 13:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D21C385A7;
        Wed, 27 Apr 2022 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651065118;
        bh=acWYe8Q5a4OproE02aaAT2qSyjz5w2L03fDzT6o+joc=;
        h=From:To:Cc:Subject:Date:From;
        b=oGnGR74bMInr0pA+/+P7X4dnW3j+SkCqo3LYkxHt99M/bKMVmPhP2MXr6QV4QQ/XM
         rjx8TA47mbsJLwIQ2gLDojB4Qbt05dYgKkZ69vHDcAGX+60WyDG5numYp7L9YKbHu1
         MinuQ31Vp5xVGVusCyX9VbyNUTCpse1HGB15e+po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.5
Date:   Wed, 27 Apr 2022 15:11:42 +0200
Message-Id: <165106510338255@kroah.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.17.5 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4/attributes.rst                               |    2 
 Makefile                                                                    |    2 
 arch/arc/kernel/entry.S                                                     |    1 
 arch/arm/mach-vexpress/spc.c                                                |    2 
 arch/arm/xen/enlighten.c                                                    |    9 -
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi                           |    8 -
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi                           |    8 -
 arch/arm64/boot/dts/qcom/sc7180.dtsi                                        |    2 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                        |    2 
 arch/arm64/boot/dts/qcom/sm8350.dtsi                                        |    2 
 arch/arm64/include/asm/pgtable.h                                            |    4 
 arch/powerpc/kernel/time.c                                                  |   29 +---
 arch/powerpc/kvm/book3s_64_vio.c                                            |   45 +++---
 arch/powerpc/kvm/book3s_64_vio_hv.c                                         |   44 +++---
 arch/powerpc/perf/power10-pmu.c                                             |    2 
 arch/powerpc/perf/power9-pmu.c                                              |    8 -
 arch/riscv/kvm/vcpu.c                                                       |   21 +-
 arch/x86/include/asm/compat.h                                               |    6 
 arch/x86/include/asm/kvm_host.h                                             |    4 
 arch/x86/kvm/hyperv.c                                                       |   40 +----
 arch/x86/kvm/hyperv.h                                                       |    2 
 arch/x86/kvm/pmu.h                                                          |    9 +
 arch/x86/kvm/svm/pmu.c                                                      |    1 
 arch/x86/kvm/svm/sev.c                                                      |   61 +++-----
 arch/x86/kvm/vmx/nested.c                                                   |    5 
 arch/x86/kvm/vmx/pmu_intel.c                                                |    8 -
 arch/x86/kvm/vmx/vmx.c                                                      |    5 
 arch/x86/kvm/vmx/vmx.h                                                      |    1 
 arch/x86/kvm/x86.c                                                          |   29 ++--
 arch/xtensa/kernel/coprocessor.S                                            |    4 
 arch/xtensa/kernel/jump_label.c                                             |    2 
 block/ioctl.c                                                               |    2 
 drivers/ata/pata_marvell.c                                                  |    2 
 drivers/dma/at_xdmac.c                                                      |   12 -
 drivers/dma/dw-edma/dw-edma-v0-core.c                                       |    7 
 drivers/dma/idxd/device.c                                                   |    6 
 drivers/dma/idxd/submit.c                                                   |    5 
 drivers/dma/idxd/sysfs.c                                                    |    6 
 drivers/dma/imx-sdma.c                                                      |   32 ++--
 drivers/dma/mediatek/mtk-uart-apdma.c                                       |    9 -
 drivers/edac/synopsys_edac.c                                                |   16 +-
 drivers/firmware/cirrus/cs_dsp.c                                            |    3 
 drivers/gpio/gpiolib.c                                                      |    4 
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c                               |    4 
 drivers/gpu/drm/i915/display/intel_psr.c                                    |   38 ++---
 drivers/gpu/drm/msm/adreno/adreno_device.c                                  |   17 --
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                                  |    3 
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c                           |    2 
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c                       |   13 +
 drivers/gpu/drm/radeon/radeon_sync.c                                        |    2 
 drivers/gpu/drm/vc4/vc4_dsi.c                                               |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                                          |   43 ++----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                         |    8 -
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c                                     |    7 
 drivers/input/keyboard/omap4-keypad.c                                       |    2 
 drivers/net/ethernet/Kconfig                                                |   26 +--
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                             |    8 -
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c                        |    8 -
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c                             |   24 +--
 drivers/net/ethernet/cadence/macb_main.c                                    |    8 +
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c                          |    8 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c                                 |    4 
 drivers/net/ethernet/intel/ice/ice_eswitch.c                                |    3 
 drivers/net/ethernet/intel/ice/ice_eswitch.h                                |    2 
 drivers/net/ethernet/intel/ice/ice_nvm.c                                    |    1 
 drivers/net/ethernet/intel/igc/igc_i225.c                                   |   11 +
 drivers/net/ethernet/intel/igc/igc_phy.c                                    |    4 
 drivers/net/ethernet/intel/igc/igc_ptp.c                                    |   15 +-
 drivers/net/ethernet/mscc/ocelot.c                                          |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c                       |    4 
 drivers/net/vxlan.c                                                         |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c                     |    2 
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c                             |    2 
 drivers/nvme/host/core.c                                                    |   24 ++-
 drivers/nvme/host/nvme.h                                                    |    5 
 drivers/nvme/host/pci.c                                                     |    9 +
 drivers/perf/arm_pmu.c                                                      |   10 -
 drivers/platform/x86/samsung-laptop.c                                       |    2 
 drivers/reset/reset-rzg2l-usbphy-ctrl.c                                     |    4 
 drivers/reset/tegra/reset-bpmp.c                                            |    9 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                                              |    2 
 drivers/scsi/bnx2i/bnx2i_iscsi.c                                            |    2 
 drivers/scsi/cxgbi/libcxgbi.c                                               |    6 
 drivers/scsi/libiscsi.c                                                     |   27 ++-
 drivers/scsi/libiscsi_tcp.c                                                 |    2 
 drivers/scsi/qedi/qedi_iscsi.c                                              |   69 ++++-----
 drivers/scsi/scsi_transport_iscsi.c                                         |   71 ++++------
 drivers/scsi/sr_ioctl.c                                                     |   15 +-
 drivers/scsi/ufs/ufshcd.c                                                   |    5 
 drivers/spi/atmel-quadspi.c                                                 |    3 
 drivers/spi/spi-cadence-quadspi.c                                           |   19 ++
 drivers/spi/spi-mtk-nor.c                                                   |   12 +
 fs/cifs/cifsfs.c                                                            |    2 
 fs/cifs/connect.c                                                           |   11 +
 fs/cifs/dfs_cache.c                                                         |   19 +-
 fs/ext4/ext4.h                                                              |    7 
 fs/ext4/extents.c                                                           |   32 +++-
 fs/ext4/inode.c                                                             |   18 ++
 fs/ext4/ioctl.c                                                             |   16 ++
 fs/ext4/namei.c                                                             |    4 
 fs/ext4/page-io.c                                                           |    4 
 fs/ext4/super.c                                                             |   21 ++
 fs/gfs2/rgrp.c                                                              |    9 -
 fs/hugetlbfs/inode.c                                                        |    9 -
 fs/io_uring.c                                                               |   11 -
 fs/jbd2/commit.c                                                            |    4 
 fs/namei.c                                                                  |   22 +--
 fs/posix_acl.c                                                              |   10 +
 fs/stat.c                                                                   |   19 +-
 fs/xattr.c                                                                  |    6 
 include/linux/etherdevice.h                                                 |    5 
 include/linux/memcontrol.h                                                  |    5 
 include/linux/posix_acl_xattr.h                                             |    4 
 include/linux/sched.h                                                       |    1 
 include/linux/sched/mm.h                                                    |    8 +
 include/net/esp.h                                                           |    2 
 include/net/netns/ipv6.h                                                    |    4 
 include/scsi/libiscsi.h                                                     |    9 -
 include/scsi/scsi_transport_iscsi.h                                         |    2 
 kernel/events/core.c                                                        |    2 
 kernel/events/internal.h                                                    |    5 
 kernel/events/ring_buffer.c                                                 |    5 
 kernel/irq_work.c                                                           |    2 
 kernel/sched/fair.c                                                         |   10 -
 lib/xarray.c                                                                |    2 
 mm/memcontrol.c                                                             |   12 +
 mm/memory-failure.c                                                         |   13 +
 mm/mmap.c                                                                   |    8 -
 mm/mmu_notifier.c                                                           |   14 +
 mm/oom_kill.c                                                               |   54 +++++--
 mm/userfaultfd.c                                                            |   15 +-
 mm/workingset.c                                                             |    2 
 net/can/isotp.c                                                             |   10 +
 net/dsa/tag_hellcreek.c                                                     |    8 +
 net/ipv4/esp4.c                                                             |    5 
 net/ipv6/esp6.c                                                             |    5 
 net/ipv6/ip6_gre.c                                                          |   14 +
 net/ipv6/route.c                                                            |   11 -
 net/l3mdev/l3mdev.c                                                         |    2 
 net/netlink/af_netlink.c                                                    |    7 
 net/openvswitch/flow_netlink.c                                              |    2 
 net/packet/af_packet.c                                                      |   13 +
 net/rxrpc/net_ns.c                                                          |    2 
 net/sched/cls_u32.c                                                         |   24 +--
 net/smc/af_smc.c                                                            |    4 
 sound/hda/intel-dsp-config.c                                                |   18 ++
 sound/pci/hda/patch_hdmi.c                                                  |    6 
 sound/pci/hda/patch_realtek.c                                               |    1 
 sound/soc/atmel/sam9g20_wm8731.c                                            |   61 --------
 sound/soc/codecs/msm8916-wcd-digital.c                                      |    9 +
 sound/soc/codecs/rk817_codec.c                                              |    2 
 sound/soc/codecs/rt5682.c                                                   |   11 -
 sound/soc/codecs/rt5682s.c                                                  |   11 -
 sound/soc/codecs/wcd934x.c                                                  |   26 ---
 sound/soc/soc-dapm.c                                                        |    6 
 sound/soc/soc-topology.c                                                    |    4 
 sound/soc/sof/topology.c                                                    |   43 ++++++
 sound/usb/midi.c                                                            |    1 
 sound/usb/mixer_maps.c                                                      |    4 
 sound/usb/usbaudio.h                                                        |    2 
 tools/lib/perf/evlist.c                                                     |    3 
 tools/perf/builtin-report.c                                                 |   14 +
 tools/perf/builtin-script.c                                                 |    2 
 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh |   17 ++
 tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh                 |   17 ++
 tools/testing/selftests/kvm/aarch64/arch_timer.c                            |   15 +-
 166 files changed, 1109 insertions(+), 724 deletions(-)

Adrian Hunter (1):
      perf tools: Fix segfault accessing sample_id xyarray

Alex Elder (1):
      arm64: dts: qcom: add IPA qcom,qmp property

Alexey Kardashevskiy (1):
      KVM: PPC: Fix TCE handling for VFIO

Alistair Popple (1):
      mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

Allen-KH Cheng (1):
      spi: spi-mtk-nor: initialize spi controller after resume

Athira Rajeev (2):
      powerpc/perf: Fix power9 event alternatives
      powerpc/perf: Fix power10 event alternatives

Atish Patra (2):
      RISC-V: KVM: Remove 's' & 'u' as valid ISA extension
      RISC-V: KVM: Restrict the extensions that can be disabled

Bob Peterson (1):
      gfs2: assign rgrp glock before compute_bitstructs

Borislav Petkov (3):
      ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant
      mt76: Fix undefined behavior due to shift overflowing the constant
      brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Christian Brauner (1):
      fs: fix acl translation

Christian König (1):
      drm/radeon: fix logic inversion in radeon_sync_resv

Christoph Hellwig (3):
      nvme: add a quirk to disable namespace identifiers
      nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202
      nvme-pci: disable namespace identifiers for Qemu controllers

Christophe Leroy (1):
      mm, hugetlb: allow for "high" userspace addresses

Darrick J. Wong (1):
      ext4: fix fallocate to use file_modified to update permissions consistently

Dave Jiang (6):
      dmaengine: idxd: fix device cleanup on disable
      dmaengine: idxd: match type for retries var in idxd_enqcmds()
      dmaengine: idxd: fix retry value to be constant for duration of function call
      dmaengine: idxd: add RO check for wq max_batch_size write
      dmaengine: idxd: add RO check for wq max_transfer_size write
      dmaengine: idxd: skip clearing device context when device is read-only

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
      Linux 5.17.5

Guo Ren (1):
      xtensa: patch_text: Fixup last cpu should be master

Hangbin Liu (1):
      net/packet: fix packet_sock xmit return value checking

Heiner Kallweit (1):
      reset: renesas: Check return value of reset_control_deassert()

Herve Codina (1):
      dmaengine: dw-edma: Fix unaligned 64bit access

Hongbin Wang (1):
      vxlan: fix error return code in vxlan_fdb_append

Ido Schimmel (2):
      selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
      selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets

Jens Axboe (1):
      io_uring: free iovec if file assignment fails

Jianglei Nie (1):
      ice: Fix memory leak in ice_get_orom_civd_data()

Jiapeng Chong (1):
      platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

José Roberto de Souza (1):
      drm/i915/display/psr: Unset enable_psr2_sel_fetch if other checks in intel_psr2_config_valid() fails

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix warning about PCM count when used with SOF

Kai-Heng Feng (1):
      net: atlantic: Avoid out-of-bounds indexing

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      ARM: vexpress/spc: Avoid negative array index when !SMP

Kevin Groeneveld (1):
      dmaengine: imx-sdma: fix init of uart scripts

Kevin Hao (1):
      net: stmmac: Use readl_poll_timeout_atomic() in atomic state

Khazhismel Kumykov (1):
      block/compat_ioctl: fix range check in BLKGETSIZE

Kurt Kanzenbach (1):
      net: dsa: hellcreek: Calculate checksums in tagger

Leo Yan (2):
      perf script: Always allow field 'data_src' for auxtrace
      perf report: Set PERF_SAMPLE_DATA_SRC bit for Arm SPE event

Like Xu (1):
      KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog

Lv Ruyi (1):
      dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Maciej Fijalkowski (1):
      ice: allow creating VFs for !CONFIG_NET_SWITCHDEV

Manuel Ullmann (1):
      net: atlantic: invert deep par in pm functions, preventing null derefs

Mario Limonciello (1):
      gpio: Request interrupts after IRQ is initialized

Mark Brown (1):
      ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Matthew Wilcox (Oracle) (1):
      XArray: Disallow sibling entries of nodes

Matthias Schiffer (1):
      spi: cadence-quadspi: fix incorrect supports_op() return value

Maurizio Avogadro (1):
      ALSA: usb-audio: add mapping for MSI MAG X570S Torpedo MAX.

Max Filippov (1):
      xtensa: fix a7 clobbering in coprocessor context load/store

Miaoqian Lin (6):
      ASoC: rk817: Use devm_clk_get() in rk817_platform_probe
      ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component
      dmaengine: imx-sdma: Fix error checking in sdma_event_remap
      Input: omap4-keypad - fix pm_runtime_get_sync() error checking
      drm/vc4: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage
      arm/xen: Fix some refcount leaks

Michael Ellerman (1):
      powerpc/time: Always set decrementer in timer_interrupt()

Mike Christie (4):
      scsi: iscsi: Release endpoint ID when its freed
      scsi: iscsi: Merge suspend fields
      scsi: iscsi: Fix NOP handling during conn recovery
      scsi: qedi: Fix failed disconnect handling

Mikulas Patocka (1):
      stat: fix inconsistency between struct stat and struct compat_stat

Mingwei Zhang (1):
      KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs

Muchun Song (1):
      arm64: mm: fix p?d_leaf()

Nadav Amit (1):
      userfaultfd: mark uffd_wp regardless of VM_WRITE flag

NeilBrown (1):
      VFS: filename_create(): fix incorrect intent.

Nicholas Kazlauskas (1):
      drm/amd/display: Only set PSR version when valid

Nico Pache (1):
      oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

Oliver Hartkopp (1):
      can: isotp: stop timeout monitoring when no first frame was sent

Oliver Upton (1):
      selftests: KVM: Free the GIC FD when cleaning up in arch_timer

Paolo Valerio (1):
      openvswitch: fix OOB access in reserve_sfa_size()

Paulo Alcantara (2):
      cifs: fix NULL ptr dereference in refresh_mounts()
      cifs: use correct lock type in cifs_reconnect()

Pavel Begunkov (1):
      io_uring: fix leaks on IOPOLL and CQE_SKIP

Peilin Ye (2):
      ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
      ip6_gre: Fix skb_under_panic in __gre6_xmit()

Peter Ujfalusi (1):
      ASoC: topology: Correct error handling in soc_tplg_dapm_widget_create()

Peter Wang (1):
      scsi: ufs: core: scsi_get_lba() error fix

Pierre-Louis Bossart (2):
      ALSA: hda: intel-dsp-config: update AlderLake PCI IDs
      ASoC: SOF: topology: cleanup dailinks on widget unload

Richard Fitzgerald (1):
      firmware: cs_dsp: Fix overrun of unterminated control name string

Rob Clark (2):
      drm/msm/gpu: Rename runtime suspend/resume functions
      drm/msm/gpu: Remove mutex from wait_event condition

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

Sean Christopherson (4):
      KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
      KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race
      KVM: nVMX: Defer APICv updates while L2 is active until L1 is active
      KVM: SVM: Simplify and harden helper to flush SEV guest page(s)

Sergey Matyukevich (1):
      ARC: entry: fix syscall_trace_exit argument

Shakeel Butt (1):
      memcg: sync flush only if periodic flush is delayed

Shubhrajyoti Datta (1):
      EDAC/synopsys: Read the error count from the correct register

Srinivas Kandagatla (1):
      ASoC: codecs: wcd934x: do not switch off SIDO Buck when codec is in use

Stephen Hemminger (1):
      net: restore alpha order to Ethernet devices in config

Tadeusz Struk (1):
      ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Takashi Iwai (1):
      ALSA: usb-audio: Clear MIDI port active flag after draining

Theodore Ts'o (3):
      ext4: fix overhead calculation to account for the reserved gdt blocks
      ext4: force overhead calculation if the s_overhead_cluster makes no sense
      ext4: update the cached overhead value in the superblock

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo NP70PNP

Tom Rix (1):
      scsi: sr: Do not leak information in ioctl

Tomas Melin (1):
      net: macb: Restart tx only if queue pointer is lagging

Tony Lu (1):
      net/smc: Fix sock leak when release after smc_shutdown()

Tudor Ambarus (1):
      spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller

Vinicius Costa Gomes (1):
      igc: Fix suspending when PTM is active

Vitaly Kuznetsov (1):
      KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU

Vladimir Oltean (1):
      net: mscc: ocelot: fix broken IP multicast flooding

Wojciech Drewek (1):
      ice: fix crash in switchdev mode

Xiaoke Wang (2):
      drm/msm/disp: check the return value of kzalloc()
      drm/msm/mdp5: check the return of kzalloc()

Xiaomeng Tong (4):
      dma: at_xdmac: fix a missing check on list iterator
      ASoC: rt5682: fix an incorrect NULL check on list iterator
      ASoC: soc-dapm: fix two incorrect uses of list iterator
      codecs: rt5682s: fix an incorrect NULL check on list iterator

Xu Yu (1):
      mm/memory-failure.c: skip huge_zero_page in memory_failure()

Ye Bin (3):
      ext4: fix symlink file size not match to file content
      ext4: fix use-after-free in ext4_search_dir
      jbd2: fix a potential race while discarding reserved buffers after an abort

Zack Rusin (1):
      drm/vmwgfx: Fix gem refcounting and memory evictions

Zheyu Ma (1):
      ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Zhipeng Xie (1):
      perf/core: Fix perf_mmap fail when CONFIG_PERF_USE_VMALLOC enabled

Zqiang (1):
      irq_work: use kasan_record_aux_stack_noalloc() record callstack

kuyo chang (1):
      sched/pelt: Fix attach_entity_load_avg() corner case

wangjianjian (C) (1):
      ext4, doc: fix incorrect h_reserved size

zhangqilong (1):
      dmaengine: mediatek:Fix PM usage reference leak of mtk_uart_apdma_alloc_chan_resources

