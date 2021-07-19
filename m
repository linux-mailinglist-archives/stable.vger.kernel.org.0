Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5093CCF2B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhGSIKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhGSIKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D48861164;
        Mon, 19 Jul 2021 08:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626682038;
        bh=mhw7xSRFBPokuVNzVkPQKzjnjzpB1u8pxR2/20zKWbE=;
        h=From:To:Cc:Subject:Date:From;
        b=rLmFi0fyA9ZumY2JWEu4aLZWqY7c3AbGdsBfx9dobeeO9PsFd3ZoRhIFVDtDYZhEp
         xdMTQgywfC6DBczhfbBT265dd+fpuhUs2182sWf1bkYEjbze6lAQbEGw6kbRH9AgQt
         bPkm0r1dqh2TRjihXlPmgkfaKIKpSxU5TUOpsBWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.51
Date:   Mon, 19 Jul 2021 10:07:08 +0200
Message-Id: <162668202815218@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.51 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                                |    2 
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts                          |    5 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                                |   19 +
 arch/arm64/include/asm/tlb.h                                            |    4 
 arch/mips/Kconfig                                                       |    2 
 arch/mips/include/asm/cpu-features.h                                    |    4 
 arch/mips/include/asm/hugetlb.h                                         |    8 
 arch/mips/include/asm/mipsregs.h                                        |    8 
 arch/mips/include/asm/pgalloc.h                                         |   10 
 arch/mips/kernel/cpu-probe.c                                            |    5 
 arch/mips/loongson64/numa.c                                             |    3 
 arch/powerpc/include/asm/barrier.h                                      |    2 
 arch/powerpc/mm/fault.c                                                 |    4 
 arch/powerpc/platforms/powernv/vas-window.c                             |    9 
 block/blk-rq-qos.c                                                      |    4 
 drivers/ata/ahci_sunxi.c                                                |    2 
 drivers/atm/iphase.c                                                    |    2 
 drivers/atm/nicstar.c                                                   |   26 +
 drivers/block/loop.c                                                    |    3 
 drivers/bluetooth/btusb.c                                               |   24 +
 drivers/char/ipmi/ipmi_watchdog.c                                       |   22 -
 drivers/clk/renesas/r8a77995-cpg-mssr.c                                 |    1 
 drivers/clk/renesas/rcar-usb2-clock-sel.c                               |   24 +
 drivers/clk/tegra/clk-periph-gate.c                                     |   72 +++--
 drivers/clk/tegra/clk-periph.c                                          |   11 
 drivers/clk/tegra/clk-pll.c                                             |    9 
 drivers/clocksource/arm_arch_timer.c                                    |    2 
 drivers/extcon/extcon-intel-mrfld.c                                     |    9 
 drivers/firmware/qemu_fw_cfg.c                                          |    8 
 drivers/fpga/stratix10-soc.c                                            |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                        |   21 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c                                  |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h                                 |    5 
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                                  |    4 
 drivers/gpu/drm/amd/amdgpu/umc_v8_7.c                                   |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c                   |   68 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                       |   24 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h                       |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c                 |   41 ++
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                        |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c                   |    9 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                      |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c          |   78 ++---
 drivers/gpu/drm/amd/display/dc/irq_types.h                              |    2 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c                         |    1 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c              |    4 
 drivers/gpu/drm/amd/include/navi10_enum.h                               |    2 
 drivers/gpu/drm/arm/malidp_planes.c                                     |    9 
 drivers/gpu/drm/ast/ast_dp501.c                                         |  139 +++++++---
 drivers/gpu/drm/ast/ast_drv.h                                           |   12 
 drivers/gpu/drm/ast/ast_main.c                                          |   11 
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c                     |    4 
 drivers/gpu/drm/bridge/cdns-dsi.c                                       |    2 
 drivers/gpu/drm/bridge/lontium-lt9611.c                                 |    1 
 drivers/gpu/drm/bridge/nwl-dsi.c                                        |   61 ++--
 drivers/gpu/drm/drm_dp_helper.c                                         |    7 
 drivers/gpu/drm/i915/display/intel_dp.c                                 |    2 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                                 |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                                |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c                              |    8 
 drivers/gpu/drm/mxsfb/Kconfig                                           |    1 
 drivers/gpu/drm/nouveau/nouveau_display.c                               |    1 
 drivers/gpu/drm/radeon/radeon_display.c                                 |    1 
 drivers/gpu/drm/radeon/radeon_drv.c                                     |    8 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                         |    4 
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c                             |   21 -
 drivers/gpu/drm/scheduler/sched_entity.c                                |    8 
 drivers/gpu/drm/scheduler/sched_main.c                                  |   24 +
 drivers/gpu/drm/tegra/dc.c                                              |   10 
 drivers/gpu/drm/tegra/drm.c                                             |    2 
 drivers/gpu/drm/vc4/vc4_crtc.c                                          |    5 
 drivers/gpu/drm/vc4/vc4_drv.h                                           |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                          |   10 
 drivers/gpu/drm/vc4/vc4_txp.c                                           |    2 
 drivers/gpu/drm/virtio/virtgpu_kms.c                                    |    1 
 drivers/gpu/drm/zte/Kconfig                                             |    1 
 drivers/hwtracing/coresight/coresight-core.c                            |    2 
 drivers/hwtracing/coresight/coresight-tmc-etf.c                         |    2 
 drivers/infiniband/core/cma.c                                           |    3 
 drivers/infiniband/hw/cxgb4/qp.c                                        |    1 
 drivers/infiniband/sw/rxe/rxe_mr.c                                      |    2 
 drivers/infiniband/ulp/isert/ib_isert.c                                 |    4 
 drivers/infiniband/ulp/isert/ib_isert.h                                 |    3 
 drivers/infiniband/ulp/rtrs/rtrs-pri.h                                  |   13 
 drivers/ipack/carriers/tpci200.c                                        |    5 
 drivers/isdn/hardware/mISDN/hfcpci.c                                    |    2 
 drivers/md/dm-writecache.c                                              |   48 ++-
 drivers/md/dm-zoned-metadata.c                                          |    7 
 drivers/md/dm.c                                                         |    8 
 drivers/md/persistent-data/dm-btree-remove.c                            |    3 
 drivers/md/persistent-data/dm-space-map-disk.c                          |    9 
 drivers/md/persistent-data/dm-space-map-metadata.c                      |    9 
 drivers/media/i2c/saa6588.c                                             |    4 
 drivers/media/pci/bt8xx/bttv-driver.c                                   |    6 
 drivers/media/pci/saa7134/saa7134-video.c                               |    6 
 drivers/media/platform/davinci/vpbe_display.c                           |    2 
 drivers/media/platform/davinci/vpbe_venc.c                              |    6 
 drivers/media/rc/bpf-lirc.c                                             |    3 
 drivers/media/usb/dvb-usb/dtv5100.c                                     |    7 
 drivers/media/usb/gspca/sq905.c                                         |    2 
 drivers/media/usb/gspca/sunplus.c                                       |    8 
 drivers/media/usb/uvc/uvc_video.c                                       |   27 +
 drivers/media/usb/zr364xx/zr364xx.c                                     |    1 
 drivers/mfd/syscon.c                                                    |    2 
 drivers/misc/lkdtm/bugs.c                                               |    3 
 drivers/mmc/core/core.c                                                 |    7 
 drivers/mmc/core/sd.c                                                   |   10 
 drivers/mmc/host/sdhci-acpi.c                                           |   11 
 drivers/mmc/host/sdhci.c                                                |    4 
 drivers/mmc/host/sdhci.h                                                |    1 
 drivers/net/dsa/ocelot/seville_vsc9953.c                                |    5 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                            |    4 
 drivers/net/ethernet/freescale/fec_main.c                               |   32 ++
 drivers/net/ethernet/intel/e100.c                                       |   12 
 drivers/net/ethernet/intel/i40e/i40e_ptp.c                              |    8 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                            |    6 
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h                          |    4 
 drivers/net/ethernet/intel/ice/ice_type.h                               |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                               |    9 
 drivers/net/ethernet/intel/igbvf/netdev.c                               |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                         |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                         |    6 
 drivers/net/ethernet/mellanox/mlx5/core/lag.c                           |   19 -
 drivers/net/ethernet/micrel/ks8842.c                                    |    4 
 drivers/net/ethernet/moxa/moxart_ether.c                                |    5 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c                    |   19 -
 drivers/net/ethernet/realtek/r8169_main.c                               |    1 
 drivers/net/ethernet/sfc/ef10_sriov.c                                   |   25 -
 drivers/net/ethernet/sgi/ioc3-eth.c                                     |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                       |   21 +
 drivers/net/fjes/fjes_main.c                                            |    4 
 drivers/net/ipa/ipa_main.c                                              |    1 
 drivers/net/mdio/mdio-ipq8064.c                                         |   33 +-
 drivers/net/phy/realtek.c                                               |   15 +
 drivers/net/virtio_net.c                                                |   22 +
 drivers/net/wireless/ath/ath11k/mac.c                                   |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                       |   24 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                     |    4 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c                |   15 -
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h                      |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c                    |    3 
 drivers/net/wireless/mac80211_hwsim.c                                   |   48 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                         |   10 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c                        |    6 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                        |   11 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c                  |   59 +++-
 drivers/net/wireless/st/cw1200/cw1200_sdio.c                            |    1 
 drivers/net/wireless/ti/wl1251/cmd.c                                    |    9 
 drivers/net/wireless/ti/wl12xx/main.c                                   |    7 
 drivers/nvmem/core.c                                                    |    9 
 drivers/pci/controller/pci-aardvark.c                                   |   13 
 drivers/pci/quirks.c                                                    |   11 
 drivers/pinctrl/pinctrl-amd.c                                           |    1 
 drivers/pinctrl/pinctrl-equilibrium.c                                   |    1 
 drivers/pinctrl/pinctrl-mcp23s08.c                                      |   10 
 drivers/scsi/libiscsi.c                                                 |   26 -
 drivers/scsi/scsi_transport_iscsi.c                                     |   28 +-
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c        |   20 -
 fs/ext4/ext4.h                                                          |    4 
 fs/ext4/mmp.c                                                           |   28 --
 fs/ext4/super.c                                                         |   10 
 fs/f2fs/f2fs.h                                                          |    2 
 fs/f2fs/recovery.c                                                      |   23 +
 fs/f2fs/super.c                                                         |    8 
 fs/io-wq.c                                                              |    5 
 fs/io_uring.c                                                           |  118 +++-----
 fs/jfs/inode.c                                                          |    3 
 fs/reiserfs/journal.c                                                   |   14 +
 fs/ubifs/super.c                                                        |    1 
 fs/ubifs/ubifs.h                                                        |    2 
 fs/ubifs/xattr.c                                                        |   44 ++-
 fs/udf/namei.c                                                          |    4 
 include/linux/mfd/abx500/ux500_chargalg.h                               |    2 
 include/linux/netdev_features.h                                         |    2 
 include/linux/of_mdio.h                                                 |    7 
 include/linux/wait.h                                                    |    2 
 include/media/v4l2-subdev.h                                             |    4 
 include/net/flow_offload.h                                              |   12 
 include/net/sctp/structs.h                                              |    2 
 include/scsi/scsi_transport_iscsi.h                                     |    1 
 include/uapi/linux/ethtool.h                                            |    4 
 kernel/bpf/core.c                                                       |   61 +++-
 kernel/bpf/ringbuf.c                                                    |    2 
 kernel/cpu.c                                                            |   49 +++
 kernel/sched/fair.c                                                     |    6 
 kernel/sched/wait.c                                                     |    9 
 kernel/trace/trace.c                                                    |   91 +++---
 lib/seq_buf.c                                                           |    4 
 mm/memory-failure.c                                                     |    6 
 net/bluetooth/hci_core.c                                                |   16 -
 net/bluetooth/hci_event.c                                               |    6 
 net/bluetooth/l2cap_core.c                                              |    8 
 net/bluetooth/mgmt.c                                                    |    5 
 net/bridge/br_mrp.c                                                     |    6 
 net/core/dev.c                                                          |   11 
 net/ipv4/ip_output.c                                                    |   32 +-
 net/ipv4/tcp_input.c                                                    |   45 +--
 net/ipv6/ip6_output.c                                                   |   32 +-
 net/ipv6/output_core.c                                                  |   28 --
 net/mac80211/sta_info.c                                                 |   11 
 net/sched/act_api.c                                                     |    3 
 net/sched/cls_api.c                                                     |    2 
 net/sctp/bind_addr.c                                                    |   19 -
 net/sctp/input.c                                                        |    8 
 net/sctp/ipv6.c                                                         |    7 
 net/sctp/protocol.c                                                     |    7 
 net/sctp/sm_make_chunk.c                                                |   29 +-
 net/vmw_vsock/af_vsock.c                                                |    2 
 net/wireless/nl80211.c                                                  |    9 
 net/wireless/wext-spy.c                                                 |   14 -
 net/xfrm/xfrm_user.c                                                    |   28 +-
 security/selinux/avc.c                                                  |   13 
 security/smack/smackfs.c                                                |    2 
 sound/soc/tegra/tegra_alc5632.c                                         |    1 
 sound/soc/tegra/tegra_max98090.c                                        |    1 
 sound/soc/tegra/tegra_rt5640.c                                          |    1 
 sound/soc/tegra/tegra_rt5677.c                                          |    1 
 sound/soc/tegra/tegra_sgtl5000.c                                        |    1 
 sound/soc/tegra/tegra_wm8753.c                                          |    1 
 sound/soc/tegra/tegra_wm8903.c                                          |    1 
 sound/soc/tegra/tegra_wm9712.c                                          |    1 
 sound/soc/tegra/trimslice.c                                             |    1 
 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh      |    3 
 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh |    3 
 tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh            |    2 
 tools/testing/selftests/lkdtm/tests.txt                                 |    2 
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh                 |    2 
 tools/testing/selftests/net/forwarding/pedit_l4port.sh                  |    2 
 tools/testing/selftests/net/forwarding/skbedit_priority.sh              |    2 
 tools/testing/selftests/resctrl/README                                  |    2 
 tools/testing/selftests/resctrl/resctrl_tests.c                         |    4 
 232 files changed, 1770 insertions(+), 902 deletions(-)

Aaron Liu (1):
      drm/amdgpu: enable sdma0 tmz for Raven/Renoir(V2)

Al Cooper (1):
      mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Alex Bee (2):
      drm: rockchip: add missing registers for RK3188
      drm: rockchip: add missing registers for RK3066

Amber Lin (1):
      drm/amdkfd: Fix circular lock in nocpsch path

Amit Cohen (1):
      selftests: Clean forgotten resources as part of cleanup()

Andrey Grodzovsky (2):
      drm/scheduler: Fix hang when sched_entity released
      drm/sched: Avoid data corruptions

Andy Shevchenko (1):
      net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Ansuel Smith (1):
      net: mdio: ipq8064: add regmap config to disable REGCACHE

Arnd Bergmann (1):
      media: subdev: disallow ioctl for saa6588/davinci

Arturo Giusti (1):
      udf: Fix NULL pointer dereference in udf_symlink function

Benjamin Drung (1):
      media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Bibo Mao (1):
      hugetlb: clear huge pte during flush function on mips platform

Bixuan Cui (1):
      pinctrl: equilibrium: Add missing MODULE_DEVICE_TABLE

Brandon Syu (1):
      drm/amd/display: fix HDCP reset sequence on reinitialize

Cameron Nemo (2):
      arm64: dts: rockchip: add rk3328 dwc3 usb controller node
      arm64: dts: rockchip: Enable USB3 for rk3328 Rock64

Chao Yu (1):
      f2fs: fix to avoid racing on fsync_entry_slab by multi filesystem instances

Christian Löhle (1):
      mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Christophe JAILLET (1):
      nvmem: core: add a missing of_node_put

Christophe Leroy (1):
      powerpc/mm: Fix lockup on kernel exec fault

Damien Le Moal (2):
      dm: Fix dm_accept_partial_bio() relative to zone management commands
      dm zoned: check zone capacity

Dan Carpenter (2):
      drm/vc4: fix argument ordering in vc4_crtc_get_margins()
      ath11k: unlock on error path in ath11k_mac_op_add_interface()

Daniel Borkmann (1):
      bpf: Fix up register-based shifts in interpreter to silence KUBSAN

Daniel Lenski (1):
      Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)

Daniel Vetter (4):
      drm/tegra: Don't set allow_fb_modifiers explicitly
      drm/msm/mdp4: Fix modifier support enabling
      drm/arm/malidp: Always list modifiers
      drm/nouveau: Don't set allow_fb_modifiers explicitly

Davide Caratti (1):
      net/sched: cls_api: increase max_reclassify_loop

Dinghao Liu (1):
      clk: renesas: rcar-usb2-clock-sel: Fix error handling in .probe()

Dmitry Osipenko (3):
      clk: tegra: Fix refcounting of gate clocks
      clk: tegra: Ensure that PLLU configuration is applied properly
      ASoC: tegra: Set driver_name=tegra for all machine drivers

Dmytro Laktyushkin (1):
      drm/amd/display: fix use_max_lb flag for 420 pixel formats

Eli Cohen (1):
      net/mlx5: Fix lag port remapping logic

Felix Fietkau (1):
      mt76: mt7615: fix fixed-rate tx status reporting

Ferry Toth (1):
      extcon: intel-mrfld: Sync hardware and software state on init

Fugang Duan (1):
      net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Gerd Rausch (1):
      RDMA/cma: Fix rdma_resolve_route() memory leak

Gioh Kim (1):
      RDMA/rtrs: Change MAX_SESS_QUEUE_DEPTH

Greg Kroah-Hartman (1):
      Linux 5.10.51

Guchun Chen (1):
      drm/amd/display: fix incorrrect valid irq check

Gulam Mohamed (1):
      scsi: iscsi: Fix race condition between login and sync thread

Gustavo A. R. Silva (1):
      wireless: wext-spy: Fix out-of-bounds warning

Hans de Goede (1):
      mmc: sdhci-acpi: Disable write protect detection on Toshiba Encore 2 WT8-B

Haren Myneni (1):
      powerpc/powernv/vas: Release reference to tgid during window close

Harry Wentland (1):
      drm/amd/display: Reject non-zero src_y and src_x for video planes

Heiner Kallweit (1):
      r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM

Hilda Wu (1):
      Bluetooth: btusb: Add support USB ALT 3 for WBS

Horatiu Vultur (1):
      net: bridge: mrp: Update ring transitions.

Hou Tao (1):
      dm btree remove: assign new_root only when removal succeeds

Huang Pei (1):
      MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Huy Nguyen (1):
      net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet

Jack Zhang (1):
      drm/amd/amdgpu/sriov disable all ip hw status by default

Jacob Keller (2):
      ice: fix incorrect payload indicator on PTYPE
      ice: mark PTYPE 2 as reserved

Jakub Kicinski (1):
      net: ip: avoid OOM kills with large UDP sends over loopback

Jan Kara (1):
      rq-qos: fix missed wake-ups in rq_qos_throttle try two

Jens Axboe (1):
      io_uring: convert io_buffer_idr to XArray

Jeremy Linton (1):
      coresight: Propagate symlink failure

Jesse Brandeburg (4):
      e100: handle eeprom as little endian
      igb: handle vlan types with checker enabled
      igb: fix assignment on big endian machines
      i40e: fix PTP on 5Gb links

Jian Shen (1):
      net: fix mistake path for netdev_features_strings

Jiansong Chen (1):
      drm/amdgpu: remove unsafe optimization to drop preamble ib

Jiapeng Chong (1):
      RDMA/cxgb4: Fix missing error code in create_qp()

Jing Xiangfeng (1):
      drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Joakim Zhang (1):
      net: phy: realtek: add delay to fix RXC generation issue

Joe Thornber (1):
      dm space maps: don't reset space map allocation cursor when committing

Johan Hovold (3):
      media: dtv5100: fix control-request directions
      media: gspca/sq905: fix control-request direction
      media: gspca/sunplus: fix zero-length control requests

Johannes Berg (4):
      iwlwifi: mvm: don't change band on bound PHY contexts
      iwlwifi: pcie: free IML DMA memory allocation
      iwlwifi: pcie: fix context info freeing
      mac80211: consider per-CPU statistics if present

Jonathan Kim (1):
      drm/amdkfd: fix circular locking on get_wave_state

Joseph Greathouse (1):
      drm/amdgpu: Update NV SIMD-per-CU to 2

Kai-Heng Feng (1):
      Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Kees Cook (4):
      drm/amd/display: Avoid HDCP over-read and corruption
      drm/i915/display: Do not zero past infoframes.vsc
      lkdtm/bugs: XFAIL UNALIGNED_LOAD_STORE_WRITE
      selftests/lkdtm: Fix expected text for CR4 pinning

Kiran K (1):
      Bluetooth: Fix alt settings for incoming SCO with transparent coding format

Konstantin Kharlamov (1):
      PCI: Leave Apple Thunderbolt controllers on for s2idle or standby

Kuninori Morimoto (1):
      clk: renesas: r8a77995: Add ZA2 clock

KuoHsiang Chou (1):
      drm/ast: Fixed CVE for DP501

Lee Gibson (1):
      wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Limeng (1):
      mfd: syscon: Free the allocated name field of struct regmap_config

Linus Walleij (1):
      power: supply: ab8500: Fix an old bug

Liu Ying (1):
      drm/bridge: nwl-dsi: Force a full modeset when crtc_state->active is changed to be true

Liwei Song (1):
      ice: set the value of global config lock timeout longer

Longpeng(Mike) (1):
      vsock: notify server to shutdown when client has pending signal

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
      Bluetooth: L2CAP: Fix invalid access on ECRED Connection response

Lv Yunlong (1):
      ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

Lyude Paul (1):
      drm/dp: Handle zeroed port counts in drm_dp_read_downstream_info()

Marcelo Ricardo Leitner (2):
      sctp: validate from_addr_param return
      sctp: add size validation when walking chunks

Mark Yacoub (1):
      drm/amd/display: Verify Gamma & Degamma LUT sizes in amdgpu_dm_atomic_check

Mateusz Kwiatkowski (1):
      drm/vc4: Fix clock source for VEC PixelValve on BCM2711

Matthew Wilcox (Oracle) (1):
      io_uring: Convert personality_idr to XArray

Mauricio Faria de Oliveira (1):
      loop: fix I/O error on fsync() in detached loop devices

Max Gurtovoy (1):
      IB/isert: Align target max I/O size to initiator size

Maxime Ripard (3):
      drm/vc4: txp: Properly set the possible_crtcs mask
      drm/vc4: crtc: Skip the TXP
      drm/vc4: hdmi: Prevent clock unbalance

Maximilian Luz (1):
      pinctrl/amd: Add device HID for new AMD GPIO controller

Mike Christie (1):
      scsi: iscsi: Fix iSCSI cls conn state

Mikulas Patocka (4):
      dm writecache: don't split bios when overwriting contiguous cache content
      dm writecache: commit just one block, not a full page
      dm writecache: flush origin device when writing and cache is full
      dm writecache: write at least 4k when committing

Minchan Kim (1):
      selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Nathan Chancellor (2):
      powerpc/barrier: Avoid collision with clang's __lwsync macro
      qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute

Nick Desaulniers (1):
      MIPS: set mips32r5 for virt extensions

Nikola Cornij (1):
      drm/amd/display: Fix DCN 3.01 DSCCLK validation

Nirmoy Das (1):
      drm/amdkfd: use allowed domain for vmbo validation

Odin Ugedal (1):
      sched/fair: Ensure _sum and _avg values stay consistent

Oscar Salvador (1):
      mm,hwpoison: return -EBUSY when migration fails

Pali Rohár (2):
      PCI: aardvark: Fix checking for PIO Non-posted Request
      PCI: aardvark: Implement workaround for the readback value of VEND_ID

Pascal Terjan (1):
      rtl8xxxu: Fix device info for RTL8192EU devices

Paul Burton (2):
      tracing: Simplify & fix saved_tgids logic
      tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT

Paul Cercueil (3):
      MIPS: cpu-probe: Fix FPU detection on Ingenic JZ4760(B)
      MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER
      MIPS: MT extensions are not available on MIPS32r1

Paul M Stillwell Jr (1):
      ice: fix clang warning regarding deadcode.DeadStores

Pavel Begunkov (1):
      io_uring: fix false WARN_ONCE

Pavel Skripkin (4):
      reiserfs: add check for invalid 1st journal block
      media: zr364xx: fix memory leak in zr364xx_start_readpipe
      jfs: fix GPF in diFree
      ext4: fix memory leak in ext4_fill_super

Petr Pavlu (1):
      ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Ping-Ke Shih (1):
      cfg80211: fix default HE tx bitrate mask in 2G band

Radim Pavlik (1):
      pinctrl: mcp23s08: fix race condition in irq handler

Roman Li (1):
      drm/amd/display: Update scaling settings on modeset

Russ Weight (1):
      fpga: stratix10-soc: Add missing fpga_mgr_free() call

Rustam Kovhaev (1):
      bpf: Fix false positive kmemleak report in bpf_ringbuf_area_alloc()

Ryder Lee (1):
      mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode

Sai Prakash Ranjan (1):
      coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()

Samuel Holland (1):
      clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround

Sean Young (1):
      media, bpf: Do not copy more entries than user space requested

Sebastian Andrzej Siewior (1):
      net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT

Shaul Triebitz (1):
      iwlwifi: mvm: fix error print when session protection ends

Srinivas Pandruvada (1):
      thermal/drivers/int340x/processor_thermal: Fix tcc setting

Stanley.Yang (1):
      drm/amdgpu: fix bad address translation for sienna_cichlid

Steffen Klassert (1):
      xfrm: Fix error reporting in xfrm_state_construct.

Tedd Ho-Jeong An (1):
      Bluetooth: mgmt: Fix the command returns garbage parameter value

Tetsuo Handa (1):
      smackfs: restrict bytes count in smk_set_cipso()

Thomas Gleixner (1):
      cpu/hotplug: Cure the cpusets trainwreck

Thomas Hebb (1):
      drm/rockchip: dsi: remove extra component_del() call

Thomas Zimmermann (3):
      drm/mxsfb: Don't select DRM_KMS_FB_HELPER
      drm/zte: Don't select DRM_KMS_FB_HELPER
      drm/ast: Remove reference to struct drm_device.pdev

Tiezhu Yang (1):
      drm/radeon: Call radeon_suspend_kms() in radeon_pci_shutdown() for Loongson64

Tim Jiang (1):
      Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Timo Sigurdsson (1):
      ata: ahci_sunxi: Disable DIPM

Tony Lindgren (1):
      wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Vladimir Oltean (2):
      net: mdio: provide shim implementation of devm_of_mdiobus_register
      net: stmmac: the XPCS obscures a potential "PHY not found" error

Vladimir Stempen (1):
      drm/amd/display: Release MST resources on switch from MST to SST

Wang Li (1):
      drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()

Weilun Du (1):
      mac80211_hwsim: add concurrent channels scanning support over virtio

Wesley Chalmers (2):
      drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7
      drm/amd/display: Fix off-by-one error in DML

Willy Tarreau (1):
      ipv6: use prandom_u32() for ID generation

Wolfram Sang (1):
      mmc: core: clear flags before allowing to retune

Xianting Tian (1):
      virtio_net: Remove BUG() to avoid machine dead

Xiao Yang (1):
      RDMA/rxe: Don't overwrite errno from ib_umem_get()

Xiaochen Shen (1):
      selftests/resctrl: Fix incorrect parsing of option "-t"

Xie Yongji (2):
      drm/virtio: Fix double free on probe failure
      virtio-net: Add validation for used length

Yang Yingliang (10):
      net: mscc: ocelot: check return value after calling platform_get_resource()
      net: bcmgenet: check return value after calling platform_get_resource()
      net: mvpp2: check return value after calling platform_get_resource()
      net: micrel: check return value after calling platform_get_resource()
      net: moxa: Use devm_platform_get_and_ioremap_resource()
      net: sgi: ioc3-eth: check return value after calling platform_get_resource()
      fjes: check return value after calling platform_get_resource()
      net: ipa: Add missing of_node_put() in ipa_firmware_load()
      net: sched: fix error return code in tcf_del_walker()
      io_uring: fix clear IORING_SETUP_R_DISABLED in wrong function

Yejune Deng (1):
      io_uring: simplify io_remove_personalities()

Yu Kuai (1):
      drm: bridge: cdns-mhdp8546: Fix PM reference leak in

Yu Liu (1):
      Bluetooth: Fix the HCI to MGMT status conversion table

Yuchung Cheng (1):
      net: tcp better handling of reordering then loss cases

Yun Zhou (1):
      seq_buf: Fix overflow in seq_buf_putmem_hex()

Zhenyu Ye (1):
      arm64: tlb: fix the TTL value of tlb_get_level

Zheyu Ma (2):
      atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
      atm: nicstar: register the interrupt handler in the right place

Zhihao Cheng (1):
      ubifs: Fix races between xattr_{set|get} and listxattr operations

Zou Wei (8):
      atm: iphase: fix possible use-after-free in ia_module_exit()
      mISDN: fix possible use-after-free in HFC_cleanup()
      atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
      drm/bridge: lt9611: Add missing MODULE_DEVICE_TABLE
      drm/vc4: hdmi: Fix PM reference leak in vc4_hdmi_encoder_pre_crtc_co()
      drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()
      cw1200: add missing MODULE_DEVICE_TABLE
      pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()

gushengxian (1):
      flow_offload: action should not be NULL when it is referenced

mark-yw.chen (1):
      Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.

xinhui pan (1):
      drm/amdkfd: Walk through list with dqm lock hold

zhanglianjie (1):
      MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops

Íñigo Huguet (2):
      sfc: avoid double pci_remove of VFs
      sfc: error code if SRIOV cannot be disabled

