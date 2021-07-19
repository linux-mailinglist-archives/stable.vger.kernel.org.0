Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A32A3CCF27
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 10:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhGSIKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235255AbhGSIKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4893861164;
        Mon, 19 Jul 2021 08:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626682026;
        bh=dp/1Wpphr/25DWJ4Bme7dvW5QBFDcS0kFSsyfgq1egg=;
        h=From:To:Cc:Subject:Date:From;
        b=bqabCodB50MolQnT+zDoBhViMtZ37EUHyvVt5hd+3pDH3Tww+OaL2uUTqJACFdfYI
         NlZ8tuFF6znEPHuaDtBS0eyVvkGoyOP0QCe10CQxCOlSpjXgXruEBaiTjFDenc/CVp
         kFGFJyXupDU24eH+AePtHNz4tek/aMRkvuxk2OVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.133
Date:   Mon, 19 Jul 2021 10:07:00 +0200
Message-Id: <1626682020242203@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.133 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/mips/boot/compressed/string.c                               |   17 +
 arch/mips/include/asm/hugetlb.h                                  |    8 
 arch/mips/include/asm/mipsregs.h                                 |    8 
 arch/mips/include/asm/pgalloc.h                                  |   10 -
 arch/mips/loongson64/loongson-3/numa.c                           |    3 
 arch/powerpc/include/asm/barrier.h                               |    2 
 arch/powerpc/mm/fault.c                                          |    4 
 block/blk-rq-qos.c                                               |    4 
 drivers/ata/ahci_sunxi.c                                         |    2 
 drivers/atm/iphase.c                                             |    2 
 drivers/atm/nicstar.c                                            |   26 +-
 drivers/bluetooth/btusb.c                                        |   15 +
 drivers/char/ipmi/ipmi_watchdog.c                                |   22 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c                          |    1 
 drivers/clk/tegra/clk-pll.c                                      |    9 
 drivers/clocksource/arm_arch_timer.c                             |    2 
 drivers/crypto/ccp/psp-dev.c                                     |    4 
 drivers/extcon/extcon-intel-mrfld.c                              |    9 
 drivers/firmware/qemu_fw_cfg.c                                   |    8 
 drivers/fpga/stratix10-soc.c                                     |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                 |   21 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                       |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c            |   22 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   24 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h                |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c          |   41 +++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                 |    2 
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c            |    9 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c               |    2 
 drivers/gpu/drm/amd/display/dc/irq_types.h                       |    2 
 drivers/gpu/drm/amd/include/navi10_enum.h                        |    2 
 drivers/gpu/drm/arm/malidp_planes.c                              |    9 
 drivers/gpu/drm/bridge/cdns-dsi.c                                |    2 
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                          |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                         |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c                       |    8 
 drivers/gpu/drm/mxsfb/Kconfig                                    |    1 
 drivers/gpu/drm/radeon/radeon_display.c                          |    1 
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c                  |    4 
 drivers/gpu/drm/scheduler/sched_entity.c                         |    5 
 drivers/gpu/drm/tegra/dc.c                                       |   10 -
 drivers/gpu/drm/tegra/drm.c                                      |    2 
 drivers/gpu/drm/vc4/vc4_drv.h                                    |    2 
 drivers/gpu/drm/virtio/virtgpu_kms.c                             |    1 
 drivers/gpu/drm/zte/Kconfig                                      |    1 
 drivers/hwtracing/coresight/coresight-tmc-etf.c                  |    2 
 drivers/infiniband/core/cma.c                                    |    3 
 drivers/infiniband/hw/cxgb4/qp.c                                 |    1 
 drivers/infiniband/sw/rxe/rxe_mr.c                               |    2 
 drivers/ipack/carriers/tpci200.c                                 |    5 
 drivers/isdn/hardware/mISDN/hfcpci.c                             |    2 
 drivers/md/persistent-data/dm-btree-remove.c                     |    3 
 drivers/md/persistent-data/dm-space-map-disk.c                   |    9 
 drivers/md/persistent-data/dm-space-map-metadata.c               |    9 
 drivers/media/i2c/saa6588.c                                      |    4 
 drivers/media/pci/bt8xx/bttv-driver.c                            |    6 
 drivers/media/pci/saa7134/saa7134-video.c                        |    6 
 drivers/media/platform/davinci/vpbe_display.c                    |    2 
 drivers/media/platform/davinci/vpbe_venc.c                       |    6 
 drivers/media/rc/bpf-lirc.c                                      |    3 
 drivers/media/usb/dvb-usb/dtv5100.c                              |    7 
 drivers/media/usb/gspca/sq905.c                                  |    2 
 drivers/media/usb/gspca/sunplus.c                                |    8 
 drivers/media/usb/uvc/uvc_video.c                                |   27 ++
 drivers/media/usb/zr364xx/zr364xx.c                              |    1 
 drivers/mmc/core/core.c                                          |    7 
 drivers/mmc/core/sd.c                                            |   10 -
 drivers/mmc/host/sdhci.c                                         |    4 
 drivers/mmc/host/sdhci.h                                         |    1 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                     |    4 
 drivers/net/ethernet/intel/e100.c                                |   12 -
 drivers/net/ethernet/intel/ice/ice_type.h                        |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                        |    5 
 drivers/net/ethernet/intel/igbvf/netdev.c                        |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                  |    4 
 drivers/net/ethernet/micrel/ks8842.c                             |    4 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c             |   19 --
 drivers/net/ethernet/realtek/r8169_main.c                        |    1 
 drivers/net/ethernet/sfc/ef10_sriov.c                            |   25 +-
 drivers/net/fjes/fjes_main.c                                     |    4 
 drivers/net/virtio_net.c                                         |    2 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                |   24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c         |   15 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h               |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c             |    3 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                  |   10 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                 |   11 -
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c           |   59 +++++-
 drivers/net/wireless/st/cw1200/cw1200_sdio.c                     |    1 
 drivers/net/wireless/ti/wl1251/cmd.c                             |    9 
 drivers/net/wireless/ti/wl12xx/main.c                            |    7 
 drivers/nvmem/core.c                                             |    9 
 drivers/pci/controller/pci-aardvark.c                            |   13 +
 drivers/pci/quirks.c                                             |   11 +
 drivers/pinctrl/pinctrl-amd.c                                    |    1 
 drivers/pinctrl/pinctrl-mcp23s08.c                               |   10 -
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |   20 +-
 fs/crypto/fname.c                                                |    9 
 fs/jfs/inode.c                                                   |    3 
 fs/reiserfs/journal.c                                            |   14 +
 fs/ubifs/super.c                                                 |    1 
 fs/ubifs/ubifs.h                                                 |    2 
 fs/ubifs/xattr.c                                                 |   44 +++-
 fs/udf/namei.c                                                   |    4 
 include/linux/mfd/abx500/ux500_chargalg.h                        |    2 
 include/linux/netdev_features.h                                  |    2 
 include/linux/wait.h                                             |    2 
 include/media/v4l2-subdev.h                                      |    4 
 include/net/sctp/structs.h                                       |    2 
 include/uapi/linux/ethtool.h                                     |    4 
 kernel/bpf/core.c                                                |   61 ++++--
 kernel/cpu.c                                                     |   49 +++++
 kernel/sched/wait.c                                              |    9 
 kernel/trace/trace.c                                             |   91 ++++++----
 lib/seq_buf.c                                                    |    4 
 net/bluetooth/hci_core.c                                         |   16 -
 net/bluetooth/mgmt.c                                             |    3 
 net/core/dev.c                                                   |   11 -
 net/ipv4/ip_output.c                                             |   32 +--
 net/ipv6/ip6_output.c                                            |   32 +--
 net/ipv6/output_core.c                                           |   28 ---
 net/sched/act_api.c                                              |    3 
 net/sctp/bind_addr.c                                             |   19 +-
 net/sctp/input.c                                                 |    8 
 net/sctp/ipv6.c                                                  |    7 
 net/sctp/protocol.c                                              |    7 
 net/sctp/sm_make_chunk.c                                         |   29 +--
 net/vmw_vsock/af_vsock.c                                         |    2 
 net/wireless/wext-spy.c                                          |   14 -
 net/xfrm/xfrm_user.c                                             |   28 +--
 security/selinux/avc.c                                           |   13 -
 security/smack/smackfs.c                                         |    2 
 sound/soc/tegra/tegra_alc5632.c                                  |    1 
 sound/soc/tegra/tegra_max98090.c                                 |    1 
 sound/soc/tegra/tegra_rt5640.c                                   |    1 
 sound/soc/tegra/tegra_rt5677.c                                   |    1 
 sound/soc/tegra/tegra_sgtl5000.c                                 |    1 
 sound/soc/tegra/tegra_wm8753.c                                   |    1 
 sound/soc/tegra/tegra_wm8903.c                                   |    1 
 sound/soc/tegra/tegra_wm9712.c                                   |    1 
 sound/soc/tegra/trimslice.c                                      |    1 
 tools/perf/bench/sched-messaging.c                               |    4 
 143 files changed, 895 insertions(+), 438 deletions(-)

Al Cooper (1):
      mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Andrey Grodzovsky (1):
      drm/sched: Avoid data corruptions

Andy Shevchenko (1):
      net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Arnd Bergmann (1):
      media: subdev: disallow ioctl for saa6588/davinci

Arturo Giusti (1):
      udf: Fix NULL pointer dereference in udf_symlink function

Benjamin Drung (1):
      media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Bibo Mao (1):
      hugetlb: clear huge pte during flush function on mips platform

Christian Löhle (1):
      mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Christophe JAILLET (1):
      nvmem: core: add a missing of_node_put

Christophe Leroy (1):
      powerpc/mm: Fix lockup on kernel exec fault

Dan Carpenter (1):
      drm/vc4: fix argument ordering in vc4_crtc_get_margins()

Daniel Borkmann (1):
      bpf: Fix up register-based shifts in interpreter to silence KUBSAN

Daniel Vetter (3):
      drm/tegra: Don't set allow_fb_modifiers explicitly
      drm/msm/mdp4: Fix modifier support enabling
      drm/arm/malidp: Always list modifiers

Dmitry Osipenko (2):
      clk: tegra: Ensure that PLLU configuration is applied properly
      ASoC: tegra: Set driver_name=tegra for all machine drivers

Dmytro Laktyushkin (1):
      drm/amd/display: fix use_max_lb flag for 420 pixel formats

Eric Biggers (1):
      fscrypt: don't ignore minor_hash when hash is 0

Felix Fietkau (1):
      mt76: mt7615: fix fixed-rate tx status reporting

Ferry Toth (1):
      extcon: intel-mrfld: Sync hardware and software state on init

Gao Xiang (1):
      MIPS: fix "mipsel-linux-ld: decompress.c:undefined reference to `memmove'"

Gerd Rausch (1):
      RDMA/cma: Fix rdma_resolve_route() memory leak

Greg Kroah-Hartman (1):
      Linux 5.4.133

Guchun Chen (1):
      drm/amd/display: fix incorrrect valid irq check

Gustavo A. R. Silva (1):
      wireless: wext-spy: Fix out-of-bounds warning

Harry Wentland (1):
      drm/amd/display: Reject non-zero src_y and src_x for video planes

Heiner Kallweit (1):
      r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM

Hou Tao (1):
      dm btree remove: assign new_root only when removal succeeds

Huang Pei (1):
      MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Ian Rogers (1):
      perf bench: Fix 2 memory sanitizer warnings

Jack Zhang (1):
      drm/amd/amdgpu/sriov disable all ip hw status by default

Jakub Kicinski (1):
      net: ip: avoid OOM kills with large UDP sends over loopback

Jan Kara (1):
      rq-qos: fix missed wake-ups in rq_qos_throttle try two

Jesse Brandeburg (2):
      e100: handle eeprom as little endian
      igb: handle vlan types with checker enabled

Jian Shen (1):
      net: fix mistake path for netdev_features_strings

Jiapeng Chong (1):
      RDMA/cxgb4: Fix missing error code in create_qp()

Jing Xiangfeng (1):
      drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Joe Thornber (1):
      dm space maps: don't reset space map allocation cursor when committing

Joerg Roedel (1):
      crypto: ccp - Annotate SEV Firmware file names

Johan Hovold (3):
      media: dtv5100: fix control-request directions
      media: gspca/sq905: fix control-request direction
      media: gspca/sunplus: fix zero-length control requests

Johannes Berg (3):
      iwlwifi: mvm: don't change band on bound PHY contexts
      iwlwifi: pcie: free IML DMA memory allocation
      iwlwifi: pcie: fix context info freeing

Joseph Greathouse (1):
      drm/amdgpu: Update NV SIMD-per-CU to 2

Kai-Heng Feng (1):
      Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Konstantin Kharlamov (1):
      PCI: Leave Apple Thunderbolt controllers on for s2idle or standby

Kuninori Morimoto (1):
      clk: renesas: r8a77995: Add ZA2 clock

Lee Gibson (1):
      wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Linus Walleij (1):
      power: supply: ab8500: Fix an old bug

Liwei Song (1):
      ice: set the value of global config lock timeout longer

Longpeng(Mike) (1):
      vsock: notify server to shutdown when client has pending signal

Lv Yunlong (1):
      ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

Marcelo Ricardo Leitner (2):
      sctp: validate from_addr_param return
      sctp: add size validation when walking chunks

Mark Yacoub (1):
      drm/amd/display: Verify Gamma & Degamma LUT sizes in amdgpu_dm_atomic_check

Maximilian Luz (1):
      pinctrl/amd: Add device HID for new AMD GPIO controller

Minchan Kim (1):
      selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Nathan Chancellor (2):
      powerpc/barrier: Avoid collision with clang's __lwsync macro
      qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute

Nick Desaulniers (1):
      MIPS: set mips32r5 for virt extensions

Nirmoy Das (1):
      drm/amdkfd: use allowed domain for vmbo validation

Pali Rohár (2):
      PCI: aardvark: Fix checking for PIO Non-posted Request
      PCI: aardvark: Implement workaround for the readback value of VEND_ID

Pascal Terjan (1):
      rtl8xxxu: Fix device info for RTL8192EU devices

Paul Burton (2):
      tracing: Simplify & fix saved_tgids logic
      tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT

Pavel Skripkin (3):
      reiserfs: add check for invalid 1st journal block
      media: zr364xx: fix memory leak in zr364xx_start_readpipe
      jfs: fix GPF in diFree

Petr Pavlu (1):
      ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Radim Pavlik (1):
      pinctrl: mcp23s08: fix race condition in irq handler

Roman Li (1):
      drm/amd/display: Update scaling settings on modeset

Russ Weight (1):
      fpga: stratix10-soc: Add missing fpga_mgr_free() call

Sai Prakash Ranjan (1):
      coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()

Samuel Holland (1):
      clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround

Sean Young (1):
      media, bpf: Do not copy more entries than user space requested

Sebastian Andrzej Siewior (1):
      net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT

Srinivas Pandruvada (1):
      thermal/drivers/int340x/processor_thermal: Fix tcc setting

Steffen Klassert (1):
      xfrm: Fix error reporting in xfrm_state_construct.

Tetsuo Handa (1):
      smackfs: restrict bytes count in smk_set_cipso()

Thomas Gleixner (1):
      cpu/hotplug: Cure the cpusets trainwreck

Thomas Hebb (1):
      drm/rockchip: dsi: remove extra component_del() call

Thomas Zimmermann (2):
      drm/mxsfb: Don't select DRM_KMS_FB_HELPER
      drm/zte: Don't select DRM_KMS_FB_HELPER

Tim Jiang (1):
      Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Timo Sigurdsson (1):
      ata: ahci_sunxi: Disable DIPM

Tony Lindgren (1):
      wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Vladimir Stempen (1):
      drm/amd/display: Release MST resources on switch from MST to SST

Wang Li (1):
      drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()

Wesley Chalmers (1):
      drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7

Willy Tarreau (1):
      ipv6: use prandom_u32() for ID generation

Wolfram Sang (1):
      mmc: core: clear flags before allowing to retune

Xianting Tian (1):
      virtio_net: Remove BUG() to avoid machine dead

Xiao Yang (1):
      RDMA/rxe: Don't overwrite errno from ib_umem_get()

Xie Yongji (1):
      drm/virtio: Fix double free on probe failure

Yang Yingliang (5):
      net: bcmgenet: check return value after calling platform_get_resource()
      net: mvpp2: check return value after calling platform_get_resource()
      net: micrel: check return value after calling platform_get_resource()
      fjes: check return value after calling platform_get_resource()
      net: sched: fix error return code in tcf_del_walker()

Yu Liu (1):
      Bluetooth: Fix the HCI to MGMT status conversion table

Yun Zhou (1):
      seq_buf: Fix overflow in seq_buf_putmem_hex()

Zheyu Ma (2):
      atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
      atm: nicstar: register the interrupt handler in the right place

Zhihao Cheng (1):
      ubifs: Fix races between xattr_{set|get} and listxattr operations

Zou Wei (6):
      atm: iphase: fix possible use-after-free in ia_module_exit()
      mISDN: fix possible use-after-free in HFC_cleanup()
      atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
      drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()
      cw1200: add missing MODULE_DEVICE_TABLE
      pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()

mark-yw.chen (1):
      Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.

xinhui pan (1):
      drm/amdkfd: Walk through list with dqm lock hold

zhanglianjie (1):
      MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops

Íñigo Huguet (2):
      sfc: avoid double pci_remove of VFs
      sfc: error code if SRIOV cannot be disabled

