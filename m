Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2F249893
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 10:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgHSIvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 04:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgHSIvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 04:51:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE22A207BB;
        Wed, 19 Aug 2020 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597827068;
        bh=7DwBWk2wJ7f6xP58Rc9otIqMeCq3E6o9l3ZUC5IbP4g=;
        h=From:To:Cc:Subject:Date:From;
        b=uy4tJmCfqgKGgroYoHKrzGIazuvErT7xeHin53Gn8WC2cZadFwclyJTCCFNkuIcO7
         epumURPPb6UEJ1KChhuqkyWFTU/KNTGeVHjl2pVX4rwSAyFv+Tf5uKerajCqWwh01y
         8w5kM/VxfBiqXRK592mU84rOY+2VpXO03JLd7uk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.59
Date:   Wed, 19 Aug 2020 10:51:26 +0200
Message-Id: <159782708615222@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.59 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-iio                       |    3 
 Makefile                                                      |    2 
 arch/arm/boot/dts/r8a7793-gose.dts                            |    4 
 arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi            |   18 +
 arch/arm/kernel/stacktrace.c                                  |   24 +
 arch/arm/mach-at91/pm.c                                       |   11 
 arch/arm/mach-exynos/mcpm-exynos.c                            |   10 
 arch/arm/mach-socfpga/pm.c                                    |    8 
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts               |    1 
 arch/arm64/boot/dts/hisilicon/hi3660-hikey960.dts             |   11 
 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dts                |    2 
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi                    |   10 
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi                 |    4 
 arch/m68k/mac/iop.c                                           |   21 -
 arch/mips/cavium-octeon/octeon-usb.c                          |    5 
 arch/mips/pci/pci-xtalk-bridge.c                              |    3 
 arch/parisc/include/asm/barrier.h                             |   61 ++++
 arch/parisc/include/asm/spinlock.h                            |    8 
 arch/parisc/kernel/entry.S                                    |   48 ++-
 arch/parisc/kernel/syscall.S                                  |   24 -
 arch/powerpc/boot/Makefile                                    |    2 
 arch/powerpc/boot/serial.c                                    |    2 
 arch/powerpc/include/asm/perf_event.h                         |    2 
 arch/powerpc/include/asm/ptrace.h                             |    2 
 arch/powerpc/include/asm/rtas.h                               |    2 
 arch/powerpc/include/asm/timex.h                              |    2 
 arch/powerpc/kernel/rtas.c                                    |  122 ---------
 arch/powerpc/kernel/vdso.c                                    |    2 
 arch/powerpc/mm/book3s64/pkeys.c                              |   16 -
 arch/powerpc/platforms/pseries/suspend.c                      |   22 -
 arch/s390/mm/gmap.c                                           |   27 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S                       |   14 -
 arch/x86/crypto/aesni-intel_asm.S                             |    6 
 arch/x86/kernel/apic/io_apic.c                                |    5 
 arch/x86/kernel/cpu/mce/inject.c                              |    2 
 arch/x86/kernel/process_64.c                                  |    2 
 block/blk-iocost.c                                            |    2 
 drivers/acpi/acpica/exprep.c                                  |    4 
 drivers/acpi/acpica/utdelete.c                                |    6 
 drivers/block/loop.c                                          |    4 
 drivers/bluetooth/btmrvl_sdio.c                               |    8 
 drivers/bluetooth/btmtksdio.c                                 |   16 +
 drivers/bluetooth/btusb.c                                     |   16 +
 drivers/bluetooth/hci_h5.c                                    |    2 
 drivers/bluetooth/hci_serdev.c                                |    3 
 drivers/bus/ti-sysc.c                                         |    6 
 drivers/char/agp/intel-gtt.c                                  |    4 
 drivers/char/tpm/tpm-chip.c                                   |    9 
 drivers/char/tpm/tpm.h                                        |    5 
 drivers/char/tpm/tpm2-space.c                                 |   26 +-
 drivers/char/tpm/tpmrm-dev.c                                  |    2 
 drivers/clk/bcm/clk-bcm63xx-gate.c                            |    1 
 drivers/clk/clk-scmi.c                                        |   22 +
 drivers/clk/qcom/clk-rpmh.c                                   |   15 +
 drivers/cpufreq/Kconfig.arm                                   |    1 
 drivers/cpufreq/armada-37xx-cpufreq.c                         |    1 
 drivers/cpufreq/cpufreq.c                                     |   58 ++--
 drivers/crypto/cavium/cpt/cptvf_algs.c                        |    1 
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c                  |   12 
 drivers/crypto/cavium/cpt/request_manager.h                   |    2 
 drivers/crypto/ccp/ccp-dev.h                                  |    1 
 drivers/crypto/ccp/ccp-ops.c                                  |   37 ++-
 drivers/crypto/ccree/cc_cipher.c                              |   30 +-
 drivers/crypto/hisilicon/sec/sec_algs.c                       |   34 +-
 drivers/crypto/qat/qat_common/qat_uclo.c                      |    9 
 drivers/edac/edac_device_sysfs.c                              |    1 
 drivers/edac/edac_pci_sysfs.c                                 |    2 
 drivers/firmware/arm_scmi/scmi_pm_domain.c                    |   12 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                     |   19 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c      |    2 
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c                     |    3 
 drivers/gpu/drm/arm/malidp_planes.c                           |    2 
 drivers/gpu/drm/bridge/sil-sii8620.c                          |    2 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                         |    6 
 drivers/gpu/drm/drm_debugfs.c                                 |    8 
 drivers/gpu/drm/drm_gem.c                                     |    4 
 drivers/gpu/drm/drm_mipi_dsi.c                                |    6 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                         |   19 +
 drivers/gpu/drm/imx/dw_hdmi-imx.c                             |   15 -
 drivers/gpu/drm/imx/imx-drm-core.c                            |    3 
 drivers/gpu/drm/imx/imx-ldb.c                                 |   15 -
 drivers/gpu/drm/imx/imx-tve.c                                 |   35 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                              |   21 -
 drivers/gpu/drm/imx/parallel-display.c                        |   15 -
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                         |   18 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c                      |    2 
 drivers/gpu/drm/msm/msm_gem.c                                 |   36 +-
 drivers/gpu/drm/nouveau/dispnv50/head.c                       |   24 +
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                     |    4 
 drivers/gpu/drm/nouveau/nouveau_drm.c                         |    8 
 drivers/gpu/drm/nouveau/nouveau_gem.c                         |    4 
 drivers/gpu/drm/nouveau/nouveau_sgdma.c                       |    9 
 drivers/gpu/drm/panel/panel-simple.c                          |    2 
 drivers/gpu/drm/radeon/ci_dpm.c                               |    2 
 drivers/gpu/drm/radeon/radeon_display.c                       |    4 
 drivers/gpu/drm/radeon/radeon_drv.c                           |    9 
 drivers/gpu/drm/radeon/radeon_kms.c                           |    4 
 drivers/gpu/drm/stm/ltdc.c                                    |    3 
 drivers/gpu/drm/tilcdc/tilcdc_panel.c                         |    6 
 drivers/gpu/drm/ttm/ttm_tt.c                                  |    3 
 drivers/gpu/host1x/debug.c                                    |    4 
 drivers/gpu/ipu-v3/ipu-common.c                               |    2 
 drivers/hid/hid-input.c                                       |    6 
 drivers/hwtracing/coresight/coresight-tmc-etf.c               |   13 -
 drivers/infiniband/core/device.c                              |   11 
 drivers/infiniband/core/nldev.c                               |    3 
 drivers/infiniband/core/verbs.c                               |    2 
 drivers/infiniband/hw/qedr/qedr.h                             |    4 
 drivers/infiniband/hw/qedr/verbs.c                            |   22 -
 drivers/infiniband/sw/rxe/rxe_recv.c                          |    6 
 drivers/infiniband/sw/rxe/rxe_verbs.c                         |    5 
 drivers/iommu/intel_irq_remapping.c                           |    8 
 drivers/irqchip/irq-mtk-sysirq.c                              |    8 
 drivers/irqchip/irq-ti-sci-inta.c                             |    2 
 drivers/leds/led-class.c                                      |    1 
 drivers/leds/leds-lm355x.c                                    |    7 
 drivers/macintosh/via-macii.c                                 |    9 
 drivers/md/bcache/super.c                                     |    9 
 drivers/md/md-cluster.c                                       |    1 
 drivers/md/md.c                                               |    9 
 drivers/media/firewire/firedtv-fw.c                           |    2 
 drivers/media/mc/mc-request.c                                 |   31 +-
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c              |    6 
 drivers/media/platform/exynos4-is/media-dev.c                 |    3 
 drivers/media/platform/marvell-ccic/mcam-core.c               |    2 
 drivers/media/platform/omap3isp/isppreview.c                  |    4 
 drivers/media/usb/dvb-usb/Kconfig                             |    1 
 drivers/misc/cxl/sysfs.c                                      |    2 
 drivers/mmc/host/sdhci-cadence.c                              |  123 +++++-----
 drivers/mmc/host/sdhci-pci-o2micro.c                          |    6 
 drivers/mtd/nand/raw/qcom_nandc.c                             |    7 
 drivers/net/dsa/mv88e6xxx/chip.c                              |    1 
 drivers/net/dsa/rtl8366.c                                     |   35 +-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c     |    2 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c       |    2 
 drivers/net/ethernet/cavium/thunder/nicvf_main.c              |    4 
 drivers/net/ethernet/freescale/fman/fman.c                    |    3 
 drivers/net/ethernet/freescale/fman/fman_dtsec.c              |    4 
 drivers/net/ethernet/freescale/fman/fman_mac.h                |    2 
 drivers/net/ethernet/freescale/fman/fman_memac.c              |    3 
 drivers/net/ethernet/freescale/fman/fman_port.c               |    9 
 drivers/net/ethernet/freescale/fman/fman_tgec.c               |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                   |    9 
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c                |    4 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c             |    9 
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c      |   42 +--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c               |    2 
 drivers/net/ethernet/toshiba/spider_net.c                     |    4 
 drivers/net/phy/phy_device.c                                  |    8 
 drivers/net/vmxnet3/vmxnet3_drv.c                             |    3 
 drivers/net/wan/lapbether.c                                   |   10 
 drivers/net/wireless/ath/ath10k/htt_tx.c                      |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c   |    4 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       |    6 
 drivers/net/wireless/intel/iwlegacy/common.c                  |    4 
 drivers/net/wireless/marvell/mwifiex/sdio.h                   |    4 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c            |   22 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c               |    7 
 drivers/net/wireless/realtek/rtw88/coex.c                     |    3 
 drivers/net/wireless/realtek/rtw88/fw.c                       |    2 
 drivers/net/wireless/realtek/rtw88/main.c                     |   11 
 drivers/net/wireless/ti/wl1251/event.c                        |    2 
 drivers/nvme/host/core.c                                      |   15 -
 drivers/nvme/host/multipath.c                                 |   17 +
 drivers/nvme/host/nvme.h                                      |    7 
 drivers/nvme/host/pci.c                                       |    2 
 drivers/nvme/host/rdma.c                                      |   12 
 drivers/nvme/host/tcp.c                                       |   12 
 drivers/parisc/sba_iommu.c                                    |    2 
 drivers/pci/access.c                                          |    8 
 drivers/pci/controller/pcie-cadence-host.c                    |    9 
 drivers/pci/controller/vmd.c                                  |    3 
 drivers/pci/pcie/aspm.c                                       |    1 
 drivers/pci/quirks.c                                          |    2 
 drivers/phy/marvell/phy-armada38x-comphy.c                    |   45 +++
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                      |   61 ++--
 drivers/phy/samsung/phy-exynos5-usbdrd.c                      |    4 
 drivers/pinctrl/pinctrl-single.c                              |   11 
 drivers/platform/x86/asus-nb-wmi.c                            |   82 ++++++
 drivers/platform/x86/intel-hid.c                              |    2 
 drivers/platform/x86/intel-vbtn.c                             |    2 
 drivers/power/supply/88pm860x_battery.c                       |    6 
 drivers/regulator/core.c                                      |   18 -
 drivers/s390/block/dasd_diag.c                                |   25 +-
 drivers/s390/net/qeth_l2_main.c                               |    4 
 drivers/scsi/arm/cumana_2.c                                   |    2 
 drivers/scsi/arm/eesox.c                                      |    2 
 drivers/scsi/arm/powertec.c                                   |    2 
 drivers/scsi/megaraid/megaraid_sas_base.c                     |    9 
 drivers/scsi/mesh.c                                           |    8 
 drivers/scsi/scsi_debug.c                                     |    6 
 drivers/soc/qcom/rpmh-rsc.c                                   |    1 
 drivers/spi/spi-lantiq-ssc.c                                  |   12 
 drivers/spi/spi-rockchip.c                                    |    2 
 drivers/spi/spidev.c                                          |   21 +
 drivers/staging/rtl8192u/r8192U_core.c                        |    2 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    1 
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c            |    2 
 drivers/usb/core/quirks.c                                     |   16 -
 drivers/usb/dwc2/platform.c                                   |    4 
 drivers/usb/gadget/function/f_uac2.c                          |    7 
 drivers/usb/gadget/udc/bdc/bdc_core.c                         |   13 -
 drivers/usb/gadget/udc/bdc/bdc_ep.c                           |   16 -
 drivers/usb/gadget/udc/net2280.c                              |    4 
 drivers/usb/mtu3/mtu3_core.c                                  |    6 
 drivers/usb/serial/cp210x.c                                   |   19 +
 drivers/usb/serial/iuu_phoenix.c                              |   14 -
 drivers/video/console/newport_con.c                           |   12 
 drivers/video/fbdev/neofb.c                                   |    1 
 drivers/video/fbdev/pxafb.c                                   |    4 
 drivers/video/fbdev/savage/savagefb_driver.c                  |    2 
 drivers/video/fbdev/sm712fb.c                                 |    2 
 drivers/xen/balloon.c                                         |   12 
 drivers/xen/gntdev-dmabuf.c                                   |    8 
 fs/9p/v9fs.c                                                  |    5 
 fs/btrfs/extent_io.c                                          |    2 
 fs/btrfs/space-info.c                                         |    2 
 fs/dlm/lockspace.c                                            |    6 
 fs/erofs/inode.c                                              |  121 ++++++---
 fs/io_uring.c                                                 |   21 +
 fs/kernfs/file.c                                              |    2 
 fs/minix/inode.c                                              |   36 ++
 fs/minix/itree_common.c                                       |    8 
 fs/nfs/pnfs.c                                                 |   46 +--
 fs/ocfs2/dlmglue.c                                            |    8 
 fs/pstore/platform.c                                          |    5 
 fs/xfs/libxfs/xfs_trans_space.h                               |    2 
 fs/xfs/scrub/bmap.c                                           |   22 +
 fs/xfs/xfs_reflink.c                                          |   21 +
 include/asm-generic/vmlinux.lds.h                             |    1 
 include/linux/bitfield.h                                      |    2 
 include/linux/tpm.h                                           |    1 
 include/linux/tpm_eventlog.h                                  |   11 
 include/linux/tracepoint.h                                    |    2 
 include/net/inet_connection_sock.h                            |    4 
 include/net/ip_vs.h                                           |   10 
 include/net/tcp.h                                             |    2 
 include/uapi/linux/seccomp.h                                  |    3 
 kernel/sched/core.c                                           |   21 +
 kernel/sched/fair.c                                           |   23 +
 kernel/sched/topology.c                                       |    2 
 kernel/seccomp.c                                              |    9 
 kernel/trace/blktrace.c                                       |   18 -
 lib/crc-t10dif.c                                              |   54 +++-
 lib/dynamic_debug.c                                           |   23 -
 lib/kobject.c                                                 |   33 +-
 mm/mmap.c                                                     |    1 
 net/bluetooth/6lowpan.c                                       |    5 
 net/core/sock.c                                               |   25 +-
 net/ipv4/inet_connection_sock.c                               |   97 ++++---
 net/ipv4/inet_hashtables.c                                    |    1 
 net/ipv4/sysctl_net_ipv4.c                                    |   16 -
 net/ipv4/tcp.c                                                |   16 -
 net/ipv4/tcp_fastopen.c                                       |   23 +
 net/netfilter/ipvs/ip_vs_core.c                               |   12 
 net/nfc/rawsock.c                                             |    7 
 net/packet/af_packet.c                                        |    9 
 net/socket.c                                                  |    2 
 net/sunrpc/auth_gss/gss_krb5_wrap.c                           |    2 
 net/sunrpc/auth_gss/svcauth_gss.c                             |    1 
 net/sunrpc/xprtrdma/svc_rdma_rw.c                             |   28 +-
 net/tls/tls_device.c                                          |    3 
 samples/bpf/fds_example.c                                     |    3 
 scripts/recordmcount.c                                        |    6 
 security/integrity/ima/ima.h                                  |    5 
 security/integrity/ima/ima_policy.c                           |    2 
 security/smack/smackfs.c                                      |    6 
 sound/pci/hda/patch_realtek.c                                 |    1 
 sound/soc/fsl/fsl_sai.c                                       |    5 
 sound/soc/fsl/fsl_sai.h                                       |    2 
 sound/soc/intel/boards/bxt_rt298.c                            |    2 
 sound/soc/meson/axg-card.c                                    |    2 
 sound/soc/meson/axg-tdm-formatter.c                           |   11 
 sound/soc/meson/axg-tdm-formatter.h                           |    1 
 sound/soc/meson/axg-tdm-interface.c                           |   26 +-
 sound/soc/meson/axg-tdmin.c                                   |   16 +
 sound/soc/meson/axg-tdmout.c                                  |    3 
 sound/soc/sof/nocodec.c                                       |    1 
 sound/usb/card.h                                              |    1 
 sound/usb/mixer_quirks.c                                      |    1 
 sound/usb/pcm.c                                               |    6 
 sound/usb/quirks-table.h                                      |   64 +++++
 sound/usb/quirks.c                                            |    3 
 sound/usb/stream.c                                            |    1 
 tools/bpf/bpftool/btf.c                                       |    2 
 tools/build/Build.include                                     |    3 
 tools/testing/selftests/powerpc/benchmarks/context_switch.c   |   21 +
 tools/testing/selftests/powerpc/eeh/eeh-functions.sh          |   11 
 tools/testing/selftests/powerpc/utils.c                       |   37 ++-
 tools/testing/selftests/seccomp/seccomp_bpf.c                 |    2 
 292 files changed, 2107 insertions(+), 1194 deletions(-)

Aditya Pakki (3):
      drm/radeon: Fix reference count leaks caused by pm_runtime_get_sync
      drm/nouveau: fix reference count leak in nouveau_debugfs_strap_peek
      drm/nouveau: fix multiple instances of reference count leaks

Akhil P Oommen (2):
      drm: msm: a6xx: fix gpu failure after system resume
      drm/msm: Fix a null pointer access in msm_gem_shrinker_count()

Alex Deucher (1):
      drm/amdgpu/display bail early in dm_pp_get_static_clocks

Alex Vesker (1):
      net/mlx5: DR, Change push vlan action sequence

Alim Akhtar (1):
      arm64: dts: exynos: Fix silent hang after boot on Espresso

Amir Goldstein (1):
      kernfs: do not call fsnotify() with name without a parent

Andrii Nakryiko (1):
      tools, build: Propagate build failures from tools/build/Makefile.build

Aneesh Kumar K.V (1):
      powerpc/book3s64/pkeys: Use PVR check instead of cpu feature

Armas Spann (1):
      platform/x86: asus-nb-wmi: add support for ASUS ROG Zephyrus G14 and G15

Arnd Bergmann (2):
      leds: lm355x: avoid enum conversion warning
      media: cxusb-analog: fix V4L2 dependency

Bartosz Golaszewski (1):
      irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock

Bjorn Helgaas (1):
      PCI: Fix pci_cfg_wait queue locking problem

Bolarinwa Olayemi Saheed (1):
      iwlegacy: Check the return value of pcie_capability_read_*()

Brant Merryman (2):
      USB: serial: cp210x: re-enable auto-RTS on open
      USB: serial: cp210x: enable usb generic throttle/unthrottle

Brian Foster (1):
      xfs: fix inode allocation block res calculation precedence

Chen-Yu Tsai (2):
      ARM: dts: sunxi: bananapi-m2-plus-v1.2: Add regulator supply to all CPU cores
      ARM: dts: sunxi: bananapi-m2-plus-v1.2: Fix CPU supply voltages

Chengming Zhou (1):
      iocost: Fix check condition of iocg abs_vdebt

Chris Packham (1):
      net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration

Christian Eggers (1):
      spi: spidev: Align buffers for DMA

Christian König (1):
      drm/radeon: disable AGP by default

Christoph Hellwig (1):
      nvme: add a Identify Namespace Identification Descriptor list quirk

Christophe JAILLET (5):
      video: pxafb: Fix the function used to balance a 'dma_alloc_coherent()' call
      scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()
      scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      net: spider_net: Fix the size used in a 'dma_free_coherent()' call

Chuck Lever (2):
      svcrdma: Fix page leak in svc_rdma_recv_read_chunk()
      SUNRPC: Fix ("SUNRPC: Add "@len" parameter to gss_unwrap()")

Chuhong Yuan (3):
      media: marvell-ccic: Add missed v4l2_async_notifier_cleanup()
      media: omap3isp: Add missed v4l2_ctrl_handler_free() for preview_init_entities()
      media: exynos4-is: Add missed check for pinctrl_lookup_state()

Chunfeng Yun (1):
      usb: mtu3: clear dual mode of u3port when disable device

Colin Ian King (4):
      md: raid0/linear: fix dereference before null check on pointer mddev
      drm/arm: fix unintentional integer overflow on left shift
      drm/radeon: fix array out-of-bounds read and write issues
      staging: rtl8192u: fix a dubious looking mask before a shift

Coly Li (1):
      bcache: fix super block seq numbers comparision in register_cache_set()

Cristian Marussi (1):
      firmware: arm_scmi: Fix SCMI genpd domain probing

Dan Carpenter (6):
      drm/gem: Fix a leak in drm_gem_objects_lookup()
      media: firewire: Using uninitialized values in node_probe()
      mwifiex: Prevent memory corruption handling keys
      thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()
      Smack: fix another vsscanf out of bounds
      Smack: prevent underflow in smk_set_cipso()

Danesh Petigara (1):
      usb: bdc: Halt controller on suspend

Dariusz Marcinkiewicz (1):
      media: cros-ec-cec: do not bail on device_init_wakeup failure

Darrick J. Wong (2):
      xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork
      xfs: fix reflink quota reservation accounting error

Dave Airlie (1):
      drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Dean Nelson (1):
      net: thunderx: initialize VF's mailbox mutex before first usage

Dejin Zheng (2):
      video: fbdev: sm712fb: fix an issue about iounmap for a wrong address
      console: newport_con: fix an issue about leak related system resources

Dilip Kota (1):
      spi: lantiq: fix: Rx overflow error in full duplex mode

Dmitry Osipenko (1):
      gpu: host1x: debug: Fix multiple channels emitting messages simultaneously

Dmitry Vyukov (1):
      io_uring: fix sq array offset calculation

Douglas Anderson (1):
      drm/bridge: ti-sn65dsi86: Clear old error bits before AUX transfers

Drew Fustini (1):
      pinctrl-single: fix pcs_parse_pinconf() return value

Emil Velikov (1):
      drm/mipi: use dcs write for mipi_dsi_dcs_set_tear_scanline

Eric Biggers (3):
      fs/minix: check return value of sb_getblk()
      fs/minix: don't allow getting deleted inodes
      fs/minix: reject too-large maximum file size

Eric Dumazet (1):
      x86/fsgsbase/64: Fix NULL deref in 86_fsgsbase_read_task

Erik Kaneda (1):
      ACPICA: Do not increment operation_region reference counts for field units

Evan Green (1):
      ath10k: Acquire tx_lock in tx error paths

Evan Quan (1):
      drm/amd/powerplay: fix compile error with ARCH=arc

Evgeny Novikov (3):
      video: fbdev: savage: fix memory leak on error handling path in probe
      video: fbdev: neofb: fix memory leak in neo_scan_monitor()
      usb: gadget: net2280: fix memory leak on probe error handling paths

Finn Thain (4):
      m68k: mac: Don't send IOP message until channel is idle
      m68k: mac: Fix IOP status/control register writes
      scsi: mesh: Fix panic after host or bus reset
      macintosh/via-macii: Access autopoll_devs when inside lock

Florinel Iordache (5):
      fsl/fman: use 32-bit unsigned integer
      fsl/fman: fix dereference null return value
      fsl/fman: fix unreachable code
      fsl/fman: check dereferencing null pointer
      fsl/fman: fix eth hash table allocation

Gao Xiang (1):
      erofs: fix extended inode could cross boundary

Gerald Schaefer (1):
      s390/gmap: improve THP splitting

Gilad Ben-Yossef (1):
      crypto: ccree - fix resource leak on error path

Grant Likely (1):
      HID: input: Fix devices that return multiple bytes in battery report

Greg Kroah-Hartman (1):
      Linux 5.4.59

Gregory Herrero (1):
      recordmcount: only record relocation of type R_AARCH64_CALL26 on arm64.

Guoyu Huang (1):
      io_uring: Fix NULL pointer dereference in loop_rw_iter()

Hanjun Guo (1):
      PCI: Release IVRS table in AMD ACS quirk

Hannes Reinecke (1):
      nvme-multipath: do not fall back to __nvme_find_path() for non-optimized paths

Harish (1):
      selftests/powerpc: Fix CPU affinity for child process

Hauke Mehrtens (1):
      spi: lantiq-ssc: Fix warning by using WQ_MEM_RECLAIM

Hector Martin (3):
      ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
      ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109
      ALSA: usb-audio: add quirk for Pioneer DDJ-RB

Heikki Krogerus (1):
      kobject: Avoid premature parent object freeing in kobject_cleanup()

Heiko Stuebner (3):
      arm64: dts: rockchip: fix rk3368-lion gmac reset gpio
      arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio
      arm64: dts: rockchip: fix rk3399-puma gmac reset gpio

Helge Deller (3):
      Revert "parisc: Drop LDCW barrier in CAS code when running UP"
      Revert "parisc: Use ldcw instruction for SMP spinlock release barrier"
      Revert "parisc: Revert "Release spinlocks using ordered store""

Herbert Xu (1):
      crc-t10dif: Fix potential crypto notify dead-lock

Hui Wang (1):
      ALSA: hda - fix the micmute led status for Lenovo ThinkCentre AIO

Ira Weiny (1):
      net/tls: Fix kmap usage

Ivan Kokshaysky (1):
      cpufreq: dt: fix oops on armada37xx

Jack Xiao (1):
      drm/amdgpu: avoid dereferencing a NULL pointer

Jakub Kicinski (1):
      bitfield.h: don't compile-time validate _val in FIELD_FIT

Jarkko Sakkinen (1):
      tpm: Unify the mismatching TPM space buffer sizes

Jason Baron (1):
      tcp: correct read of TFO keys on big endian systems

Jason Gunthorpe (1):
      RDMA/core: Fix bogus WARN_ON during ib_unregister_device_queued()

Jens Axboe (1):
      io_uring: set ctx sq/cq entry count earlier

Jerome Brunet (3):
      ASoC: meson: axg-tdm-interface: fix link fmt setup
      ASoC: meson: axg-tdmin: fix g12a skew
      ASoC: meson: axg-tdm-formatters: fix sclk inversion

Jian Cai (1):
      crypto: aesni - add compatibility with IAS

Jim Cromie (1):
      dyndbg: fix a BUG_ON in ddebug_describe_flags

Jing Xiangfeng (1):
      ASoC: meson: fixes the missed kfree() for axg_card_add_tdm_loopback

Johan Hovold (2):
      USB: serial: iuu_phoenix: fix led-activity helpers
      net: phy: fix memory leak in device-create error path

John Allen (1):
      crypto: ccp - Fix use of merged scatterlists

John David Anglin (2):
      parisc: Do not use an ordered store in pa_tlb_lock()
      parisc: Implement __smp_store_release and __smp_load_acquire barriers

John Garry (1):
      scsi: scsi_debug: Add check for sdebug_max_queue during module init

John Ogness (1):
      af_packet: TPACKET_V3: fix fill status rwlock imbalance

Jon Derrick (1):
      irqdomain/treewide: Free firmware node after domain removal

Jon Lin (1):
      spi: rockchip: Fix error in SPI slave pio read

Josef Bacik (1):
      btrfs: fix lockdep splat from btrfs_dump_space_info

Julian Anastasov (1):
      ipvs: allow connection reuse for unconfirmed conntrack

Julian Wiedmann (1):
      s390/qeth: don't process empty bridge port events

Kai-Heng Feng (1):
      leds: core: Flush scheduled work for system suspend

Kars Mulder (1):
      usb: core: fix quirks_param_set() writing to a const pointer

Kees Cook (1):
      seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID

Kishon Vijay Abraham I (1):
      PCI: cadence: Fix updating Vendor ID and Subsystem Vendor ID register

Laurent Pinchart (1):
      drm: panel: simple: Fix bpc for LG LB070WV8 panel

Leon Romanovsky (1):
      net/mlx5: Delete extra dump stack that gives nothing

Li Heng (1):
      RDMA/core: Fix return error value in _ib_modify_qp() to negative

Lihong Kou (1):
      Bluetooth: add a mutex lock to avoid UAF in do_enale_set

Linus Walleij (2):
      net: dsa: rtl8366: Fix VLAN semantics
      net: dsa: rtl8366: Fix VLAN set-up

Liu Yong (1):
      fs/io_uring.c: Fix uninitialized variable is referenced in io_submit_sqe

Lu Wei (2):
      platform/x86: intel-hid: Fix return value check in check_acpi_dev()
      platform/x86: intel-vbtn: Fix return value check in check_acpi_dev()

Lubomir Rintel (1):
      drm/etnaviv: Fix error path on failure to enable bus clk

Luis Chamberlain (2):
      blktrace: fix debugfs use after free
      loop: be paranoid on exit and prevent new additions / removals

Lyude Paul (1):
      drm/nouveau/kms/nv50-: Fix disabling dithering

Madhavan Srinivasan (1):
      powerpc/perf: Fix missing is_sier_aviable() during build

Marco Felsch (1):
      drm/imx: tve: fix regulator_disable error path

Marek Szyprowski (3):
      ARM: exynos: MCPM: Restore big.LITTLE cpuidle support
      phy: exynos5-usbdrd: Calibrating makes sense only for USB2.0 PHY
      usb: dwc2: Fix error path in gadget registration

Marek Vasut (1):
      drm/stm: repair runtime power management

Mark Zhang (1):
      RDMA/netlink: Remove CAP_NET_RAW check when dump a raw QP

Martin Wilck (1):
      nvme-multipath: fix logic for non-optimized paths

Masahiro Yamada (1):
      mmc: sdhci-cadence: do not use hardware tuning for SD mode

Matteo Croce (1):
      pstore: Fix linking when crypto API disabled

Maulik Shah (1):
      soc: qcom: rpmh-rsc: Set suppress_bind_attrs flag

Miaohe Lin (2):
      net: Fix potential memory leak in proto_register()
      net: Set fput_needed iff FDPUT_FPUT is set

Michael Ellerman (2):
      powerpc/32s: Fix CONFIG_BOOK3S_601 uses
      powerpc/boot: Fix CONFIG_PPC_MPC52XX references

Michael Tretter (1):
      drm/debugfs: fix plain echo to connector "force" attribute

Mike Tipton (1):
      clk: qcom: clk-rpmh: Wait for completion when enabling clocks

Mikhail Malygin (1):
      RDMA/rxe: Prevent access to wr->next ptr afrer wr is posted to send queue

Mikulas Patocka (2):
      crypto: hisilicon - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified
      crypto: cpt - don't sleep of CRYPTO_TFM_REQ_MAY_SLEEP was not specified

Milton Miller (1):
      powerpc/vdso: Fix vdso cpu truncation

Mirko Dietrich (1):
      ALSA: usb-audio: Creative USB X-Fi Pro SB1095 volume knob support

Nathan Huckleberry (1):
      ARM: 8992/1: Fix unwind_frame for clang-built kernels

Nathan Lynch (1):
      powerpc/rtas: don't online CPUs for partition suspend

Navid Emamdoost (1):
      drm/etnaviv: fix ref count leak via pm_runtime_get_sync

Nick Desaulniers (1):
      tracepoint: Mark __tracepoint_string's __used

Nicolas Boichat (2):
      Bluetooth: hci_h5: Set HCI_UART_RESET_ON_INIT to correct flags
      Bluetooth: hci_serdev: Only unregister device if it was registered

Niklas Söderlund (2):
      ARM: dts: gose: Fix ports node name for adv7180
      ARM: dts: gose: Fix ports node name for adv7612

Oleksandr Andrushchenko (1):
      xen/gntdev: Fix dmabuf import with non-zero sgt offset

Oliver O'Halloran (1):
      selftests/powerpc: Squash spurious errors due to device removal

Pali Rohár (4):
      mwifiex: Fix firmware filename for sd8977 chipset
      mwifiex: Fix firmware filename for sd8997 chipset
      btmrvl: Fix firmware filename for sd8977 chipset
      btmrvl: Fix firmware filename for sd8997 chipset

Paul E. McKenney (2):
      fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls
      mm/mmap.c: Add cond_resched() for exit_mmap() CPU stalls

Pavel Machek (1):
      ocfs2: fix unbalanced locking

Peng Liu (1):
      sched: correct SD_flags returned by tl->sd_flags()

Phil Elwell (1):
      staging: vchiq_arm: Add a matching unregister call

Philipp Zabel (1):
      drm/imx: fix use after free

Pierre-Louis Bossart (2):
      ASoC: SOF: nocodec: add missing .owner field
      ASoC: Intel: bxt_rt298: add missing .owner field

Prasanna Kerekoppa (1):
      brcmfmac: To fix Bss Info flag definition Bug

Qais Yousef (1):
      sched/uclamp: Fix initialization of struct uclamp_rq

Qingyu Li (1):
      net/nfc/rawsock.c: add CAP_NET_RAW check.

Qiushi Wu (2):
      EDAC: Fix reference count leaks
      agp/intel: Fix a memory leak on module initialisation failure

Ricardo Cañuelo (1):
      arm64: dts: hisilicon: hikey: fixes to comply with adi, adv7533 DT binding

Rob Clark (1):
      drm/msm: ratelimit crtc event overflow error

Roger Pau Monne (2):
      xen/balloon: fix accounting in alloc_xenballooned_pages error path
      xen/balloon: make the balloon wait interruptible

Romain Naour (1):
      include/asm-generic/vmlinux.lds.h: align ro_after_init

Ronak Doshi (1):
      vmxnet3: use correct tcp hdr length when packet is encapsulated

Ruslan Bilovol (1):
      usb: gadget: f_uac2: fix AC Interface Header Descriptor wTotalLength

Russell King (1):
      phy: armada-38x: fix NETA lockup when repeatedly switching speeds

Sagi Grimberg (2):
      nvme-tcp: fix controller reset hang during traffic
      nvme-rdma: fix controller reset hang during traffic

Sai Prakash Ranjan (1):
      coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()

Sandipan Das (1):
      selftests/powerpc: Fix online CPU selection

Sasi Kumar (1):
      bdc: Fix bug causing crash after multiple disconnects

Sean Wang (3):
      Bluetooth: btusb: fix up firmware download sequence
      Bluetooth: btmtksdio: fix up firmware download sequence
      mt76: mt7615: fix potential memory leak in mcu message handler

Sedat Dilek (1):
      crypto: aesni - Fix build with LLVM_IAS=1

Shannon Nelson (1):
      ionic: update eid test for overflow

Shengjiu Wang (1):
      ASoC: fsl_sai: Fix value of FSL_SAI_CR1_RFW_MASK

Sivaprakash Murugesan (1):
      mtd: rawnand: qcom: avoid write to unavailable register

Stefan Haberland (1):
      s390/dasd: fix inability to use DASD with DIAG driver

Stephan Gerhold (1):
      arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property

Steve Longerbeam (1):
      gpu: ipu-v3: Restore RGB32, BGR32

Sudeep Holla (1):
      clk: scmi: Fix min and max rate when registering clocks with discrete rates

Surabhi Boob (1):
      ice: Graceful error handling in HW table calloc failure

Sven Auhagen (1):
      cpufreq: ap806: fix cpufreq driver needs ap cpu clk

Sven Schnelle (1):
      parisc: mask out enable and reserved bits from sba imask

Tianjia Zhang (3):
      tools, bpftool: Fix wrong return value in do_dump()
      net: ethernet: aquantia: Fix wrong return value
      liquidio: Fix wrong return value in cn23xx_get_pf_num()

Tiezhu Yang (1):
      irqchip/ti-sci-inta: Fix return value about devm_ioremap_resource()

Tim Froidcoeur (2):
      net: refactor bind_bucket fastreuse into helper
      net: initialize fastreuse on inet_inherit_port

Tom Rix (3):
      drm/bridge: sil_sii8620: initialize return of sii8620_readb
      power: supply: check if calc_soc succeeded in pm860x_init_battery
      crypto: qat - fix double free in qat_uclo_create_batch_init_list

Tomas Henzl (1):
      scsi: megaraid_sas: Clear affinity hint

Tomasz Duszynski (1):
      iio: improve IIO_CONCENTRATION channel type description

Tomi Valkeinen (1):
      drm/tilcdc: fix leak & null ref in panel_connector_get_modes

Tony Lindgren (1):
      bus: ti-sysc: Add missing quirk flags for usb_host_hs

Tony Nguyen (1):
      iavf: Fix updating statistics

Trond Myklebust (2):
      NFS: Don't move layouts to plh_return_segs list while in use
      NFS: Don't return layout segments that are in use

Tsang-Shian Lin (2):
      rtw88: fix LDPC field for RA info
      rtw88: fix short GI capability based on current bandwidth

Tuomas Tynkkynen (1):
      media: media-request: Fix crash if memory allocation fails

Tyler Hicks (2):
      tpm: Require that all digests are present in TCG_PCR_EVENT2 structures
      ima: Have the LSM free its audit rule

Vincent Guittot (1):
      sched/fair: Fix NOHZ next idle balance

Viresh Kumar (1):
      cpufreq: Fix locking issues with governors

Vladimir Zapolskiy (1):
      regulator: fix memory leak on error path of regulator_register()

Wang Hai (3):
      cxl: Fix kobject memleak
      wl1251: fix always return 0 error
      dlm: Fix kobject memleak

Wei Yongjun (1):
      iavf: fix error return code in iavf_init_get_resources()

Wenbo Zhang (1):
      bpf: Fix fds_example SIGSEGV error

Wright Feng (2):
      brcmfmac: keep SDIO watchdog running when console_interval is non-zero
      brcmfmac: set state of hanger slot to FREE when flushing PSQ

Xie He (1):
      drivers/net/wan/lapbether: Added needed_headroom and a skb->len check

Xiongfeng Wang (1):
      PCI/ASPM: Add missing newline in sysfs 'policy'

Yan-Hsuan Chuang (1):
      rtw88: coex: only skip coex triggered by BT info

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: move irq registration to init

Yu Kuai (2):
      ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()
      MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()

Yuval Basson (1):
      RDMA/qedr: SRQ's bug fixes

Zhao Heming (1):
      md-cluster: fix wild pointer of unlock_all_bitmaps()

Zheng Bin (1):
      9p: Fix memory leak in v9fs_mount

Zhenzhong Duan (1):
      x86/mce/inject: Fix a wrong assignment of i_mce.status

Zhu Yanjun (1):
      RDMA/rxe: Skip dgid check in loopback mode

shirley her (1):
      mmc: sdhci-pci-o2micro: Bug fix for O2 host controller Seabird1

yu kuai (1):
      ARM: at91: pm: add missing put_device() call in at91_pm_sram_init()

Álvaro Fernández Rojas (1):
      clk: bcm63xx-gate: fix last clock availability

