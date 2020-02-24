Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AE169F9F
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 09:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBXH73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 02:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgBXH72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 02:59:28 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 921F220714;
        Mon, 24 Feb 2020 07:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582531166;
        bh=FmHGIKYbF4T6xmJrRBpZbAL35qVlWFHXktFhRS8fUTo=;
        h=Date:From:To:Cc:Subject:From;
        b=qDJ3aIk5+8MZa/DZiiYRTCMU1RaDn/2y5nnyaUXnF2zXcRE9pf5j+5EtrWxpPnqai
         ZJu3MRhrImDoNFa06f1XTeNnEDcCU435QEc8QAuwSZbfV28dpFA+1hdif8d1Hqlr5V
         sC6YA+UYhBD3mIncgmBccNzh/XHt7ba0D2Zbt8UY=
Date:   Mon, 24 Feb 2020 08:59:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.22
Message-ID: <20200224075923.GA680724@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.22 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/fb/fbcon.rst                              |    8 -
 Makefile                                                |    2=20
 arch/Kconfig                                            |    3=20
 arch/arm/Kconfig                                        |    4=20
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi                 |    7=20
 arch/arm/boot/dts/r8a7779.dtsi                          |    8 +
 arch/arm/boot/dts/rk3188-bqedison2qc.dts                |    3=20
 arch/arm/boot/dts/stm32f469-disco.dts                   |    8 +
 arch/arm/boot/dts/sun8i-h3.dtsi                         |   15 +
 arch/arm/configs/exynos_defconfig                       |    6=20
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi            |   16 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi            |   10 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi                   |    4=20
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts              |    2=20
 arch/arm64/boot/dts/rockchip/px30.dtsi                  |    6=20
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts         |    3=20
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi    |    3=20
 arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts       |   27 ---
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts        |    3=20
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi               |    1=20
 arch/arm64/include/asm/alternative.h                    |   32 ++--
 arch/arm64/include/asm/atomic_lse.h                     |   19 ++
 arch/arm64/include/asm/lse.h                            |    6=20
 arch/microblaze/kernel/cpu/cache.c                      |    3=20
 arch/mips/loongson64/loongson-3/platform.c              |    3=20
 arch/powerpc/Makefile.postlink                          |    4=20
 arch/powerpc/kernel/eeh_driver.c                        |    6=20
 arch/powerpc/kernel/pci_dn.c                            |   15 +
 arch/powerpc/kvm/emulate_loadstore.c                    |    5=20
 arch/powerpc/mm/fault.c                                 |    3=20
 arch/powerpc/platforms/powernv/pci-ioda.c               |   48 +++++-
 arch/powerpc/platforms/powernv/pci.c                    |   18 --
 arch/powerpc/platforms/pseries/lparcfg.c                |    4=20
 arch/powerpc/tools/relocs_check.sh                      |   20 +-
 arch/s390/Makefile                                      |    2=20
 arch/s390/include/asm/pci.h                             |    2=20
 arch/s390/kernel/mcount.S                               |   15 +
 arch/s390/kvm/interrupt.c                               |    6=20
 arch/s390/pci/pci.c                                     |    2=20
 arch/s390/pci/pci_clp.c                                 |   48 +++---
 arch/s390/pci/pci_sysfs.c                               |   63 +++++---
 arch/sh/include/cpu-sh2a/cpu/sh7269.h                   |   11 +
 arch/sparc/kernel/vmlinux.lds.S                         |    6=20
 arch/x86/entry/vdso/vdso32-setup.c                      |    1=20
 arch/x86/events/amd/core.c                              |   91 ++++++++----
 arch/x86/events/perf_event.h                            |    2=20
 arch/x86/include/asm/nmi.h                              |    1=20
 arch/x86/kernel/fpu/signal.c                            |    3=20
 arch/x86/kernel/nmi.c                                   |   20 +-
 arch/x86/kernel/sysfb_simplefb.c                        |    2=20
 arch/x86/lib/x86-opcode-map.txt                         |    2=20
 arch/x86/mm/pageattr.c                                  |    8 -
 arch/x86/platform/efi/efi.c                             |   41 ++---
 arch/x86/platform/efi/efi_64.c                          |    9 -
 block/bfq-iosched.c                                     |   12 +
 crypto/Kconfig                                          |    4=20
 drivers/acpi/acpica/dsfield.c                           |    2=20
 drivers/acpi/acpica/dswload.c                           |   21 ++
 drivers/acpi/button.c                                   |   11 +
 drivers/atm/fore200e.c                                  |   25 ++-
 drivers/base/dd.c                                       |    5=20
 drivers/base/platform.c                                 |   12 -
 drivers/block/brd.c                                     |   22 ++
 drivers/block/nbd.c                                     |   10 +
 drivers/block/rbd.c                                     |    2=20
 drivers/block/zram/zram_drv.c                           |    3=20
 drivers/bus/ti-sysc.c                                   |   10 +
 drivers/char/hpet.c                                     |    2=20
 drivers/char/random.c                                   |    5=20
 drivers/clk/at91/sam9x60.c                              |    1=20
 drivers/clk/clk.c                                       |   53 +++++--
 drivers/clk/imx/clk.h                                   |   37 ++--
 drivers/clk/meson/clk-pll.c                             |    9 +
 drivers/clk/meson/meson8b.c                             |   11 -
 drivers/clk/qcom/clk-rcg2.c                             |   11 -
 drivers/clk/qcom/clk-smd-rpm.c                          |    3=20
 drivers/clk/renesas/rcar-gen3-cpg.c                     |    6=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                   |   28 +++
 drivers/clk/ti/clk-7xx.c                                |    2=20
 drivers/clk/uniphier/clk-uniphier-peri.c                |   13 +
 drivers/clocksource/bcm2835_timer.c                     |    5=20
 drivers/clocksource/timer-davinci.c                     |    8 -
 drivers/crypto/Kconfig                                  |    2=20
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |   27 +--
 drivers/crypto/chelsio/chtls/chtls_cm.h                 |   21 ++
 drivers/crypto/chelsio/chtls/chtls_hw.c                 |    3=20
 drivers/devfreq/Kconfig                                 |    3=20
 drivers/devfreq/event/Kconfig                           |    2=20
 drivers/devfreq/event/exynos-ppmu.c                     |   13 +
 drivers/dma/dmaengine.c                                 |    4=20
 drivers/dma/fsl-qdma.c                                  |    2=20
 drivers/dma/imx-sdma.c                                  |   19 +-
 drivers/edac/sifive_edac.c                              |    4=20
 drivers/gpio/gpio-grgpio.c                              |   10 -
 drivers/gpio/gpiolib.c                                  |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c            |   19 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              |    2=20
 drivers/gpu/drm/amd/amdgpu/nv.c                         |    6=20
 drivers/gpu/drm/amd/amdgpu/soc15_common.h               |    1=20
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c                |    2=20
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c   |   10 -
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h    |   43 -----
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c        |   34 +++-
 drivers/gpu/drm/amd/display/dc/core/dc.c                |   17 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c           |    3=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c       |   16 +-
 drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c    |    2=20
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h    |    2=20
 drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h      |   43 +++++
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c       |   23 +--
 drivers/gpu/drm/drm_client_modeset.c                    |   72 +++++++++
 drivers/gpu/drm/drm_debugfs_crc.c                       |    4=20
 drivers/gpu/drm/drm_mipi_dbi.c                          |    4=20
 drivers/gpu/drm/gma500/framebuffer.c                    |    8 -
 drivers/gpu/drm/ingenic/ingenic-drm.c                   |   16 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                 |   18 ++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                   |   11 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                   |   11 +
 drivers/gpu/drm/nouveau/nouveau_dmem.c                  |    4=20
 drivers/gpu/drm/nouveau/nouveau_fence.c                 |    2=20
 drivers/gpu/drm/nouveau/nouveau_ttm.c                   |    4=20
 drivers/gpu/drm/nouveau/nvkm/core/memory.c              |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c     |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c          |   21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c        |    1=20
 drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c     |    5=20
 drivers/gpu/drm/panel/panel-simple.c                    |   37 ++++
 drivers/gpu/drm/qxl/qxl_kms.c                           |    2=20
 drivers/gpu/drm/radeon/radeon_display.c                 |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c              |    4=20
 drivers/ide/cmd64x.c                                    |    3=20
 drivers/ide/serverworks.c                               |    6=20
 drivers/infiniband/core/cache.c                         |  121 +++++++++--=
-----
 drivers/infiniband/core/core_priv.h                     |    1=20
 drivers/infiniband/core/device.c                        |   33 +---
 drivers/infiniband/hw/hfi1/chip.c                       |   11 +
 drivers/infiniband/hw/hfi1/chip.h                       |    2=20
 drivers/infiniband/hw/hfi1/chip_registers.h             |    1=20
 drivers/infiniband/hw/hfi1/driver.c                     |    1=20
 drivers/infiniband/hw/hfi1/hfi.h                        |    2=20
 drivers/infiniband/hw/hns/hns_roce_mr.c                 |    4=20
 drivers/infiniband/hw/mlx5/main.c                       |   34 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.h                   |    2=20
 drivers/input/touchscreen/edt-ft5x06.c                  |    7=20
 drivers/iommu/amd_iommu.c                               |    7=20
 drivers/iommu/amd_iommu_init.c                          |   19 +-
 drivers/iommu/amd_iommu_types.h                         |    2=20
 drivers/iommu/arm-smmu-v3.c                             |    3=20
 drivers/iommu/dmar.c                                    |    1=20
 drivers/iommu/intel-iommu.c                             |    3=20
 drivers/iommu/intel-pasid.c                             |   12 +
 drivers/iommu/intel-svm.c                               |    9 -
 drivers/iommu/iova.c                                    |    2=20
 drivers/irqchip/irq-gic-v3-its.c                        |    2=20
 drivers/irqchip/irq-gic-v3.c                            |    9 -
 drivers/irqchip/irq-mbigen.c                            |    1=20
 drivers/leds/leds-pca963x.c                             |    8 -
 drivers/md/bcache/bset.h                                |    3=20
 drivers/md/bcache/journal.c                             |    3=20
 drivers/md/bcache/stats.c                               |   10 -
 drivers/md/bcache/super.c                               |   79 ++++++----
 drivers/md/dm-thin.c                                    |   18 +-
 drivers/media/i2c/mt9v032.c                             |   10 +
 drivers/media/i2c/ov5640.c                              |    2=20
 drivers/media/pci/cx23885/cx23885-cards.c               |   24 +++
 drivers/media/pci/cx23885/cx23885-video.c               |    3=20
 drivers/media/pci/cx23885/cx23885.h                     |    1=20
 drivers/media/platform/sti/bdisp/bdisp-hw.c             |    6=20
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c      |   22 ++
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h      |    4=20
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c      |   20 +-
 drivers/media/usb/uvc/uvc_driver.c                      |   25 +++
 drivers/media/usb/uvc/uvcvideo.h                        |    1=20
 drivers/misc/xilinx_sdfec.c                             |   10 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |    1=20
 drivers/net/ethernet/cisco/enic/enic_main.c             |    2=20
 drivers/net/ethernet/freescale/gianfar.c                |   10 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c              |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c      |    3=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c    |    3=20
 drivers/net/ethernet/netronome/nfp/abm/cls.c            |   14 -
 drivers/net/ethernet/realtek/r8169_main.c               |    9 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c                |   96 +++++-------
 drivers/net/phy/fixed_phy.c                             |    7=20
 drivers/net/phy/realtek.c                               |   19 ++
 drivers/net/wan/fsl_ucc_hdlc.c                          |    5=20
 drivers/net/wan/hdlc_x25.c                              |   13 +
 drivers/net/wan/ixp4xx_hss.c                            |    4=20
 drivers/net/wireless/ath/ath10k/snoc.c                  |    5=20
 drivers/net/wireless/ath/ath10k/wmi-tlv.c               |    5=20
 drivers/net/wireless/ath/ath10k/wmi.c                   |    2=20
 drivers/net/wireless/ath/wil6210/txrx_edma.c            |    3=20
 drivers/net/wireless/broadcom/b43legacy/main.c          |    5=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c  |    3=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |   13 -
 drivers/net/wireless/intel/ipw2x00/ipw2100.c            |    7=20
 drivers/net/wireless/intel/ipw2x00/ipw2200.c            |    5=20
 drivers/net/wireless/intel/iwlegacy/3945-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/4965-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/common.c            |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c       |    8 -
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c             |    4=20
 drivers/net/wireless/intersil/hostap/hostap_ap.c        |    2=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c     |    3=20
 drivers/net/wireless/realtek/rtlwifi/pci.c              |   10 -
 drivers/net/wireless/realtek/rtw88/main.c               |   12 -
 drivers/net/wireless/realtek/rtw88/pci.c                |    5=20
 drivers/nfc/port100.c                                   |    2=20
 drivers/nvme/host/pci.c                                 |   23 +--
 drivers/nvme/target/core.c                              |    6=20
 drivers/opp/of.c                                        |   17 +-
 drivers/pci/controller/pcie-iproc.c                     |   24 +++
 drivers/pci/pci.c                                       |   24 ++-
 drivers/pci/pci.h                                       |    3=20
 drivers/pci/quirks.c                                    |   99 ++++++-----=
--
 drivers/pci/search.c                                    |    4=20
 drivers/perf/fsl_imx8_ddr_perf.c                        |   16 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c                |    8 -
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                     |    9 -
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                     |   39 +++--
 drivers/pwm/pwm-omap-dmtimer.c                          |   35 +++-
 drivers/pwm/pwm-pca9685.c                               |    4=20
 drivers/regulator/core.c                                |    2=20
 drivers/regulator/rk808-regulator.c                     |    2=20
 drivers/regulator/vctrl-regulator.c                     |   38 +++--
 drivers/remoteproc/remoteproc_core.c                    |    2=20
 drivers/reset/reset-uniphier.c                          |   13 +
 drivers/rtc/Kconfig                                     |   12 +
 drivers/scsi/aic7xxx/aic7xxx_core.c                     |    2=20
 drivers/scsi/iscsi_tcp.c                                |    4=20
 drivers/scsi/lpfc/lpfc_ct.c                             |   42 ++---
 drivers/scsi/scsi_transport_iscsi.c                     |   26 +++
 drivers/scsi/ufs/ufs-mediatek.c                         |   11 +
 drivers/scsi/ufs/ufs-qcom.c                             |    3=20
 drivers/scsi/ufs/ufshcd.c                               |   32 +---
 drivers/scsi/ufs/ufshcd.h                               |    9 -
 drivers/soc/tegra/fuse/tegra-apbmisc.c                  |    2=20
 drivers/spi/spi-fsl-lpspi.c                             |   32 ++--
 drivers/spi/spi-fsl-qspi.c                              |    2=20
 drivers/staging/media/meson/vdec/vdec.c                 |    2=20
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c          |    9 -
 drivers/tty/synclink_gt.c                               |   18 +-
 drivers/tty/synclinkmp.c                                |   24 +--
 drivers/uio/uio_dmem_genirq.c                           |    6=20
 drivers/usb/dwc2/gadget.c                               |    3=20
 drivers/usb/dwc3/host.c                                 |    6=20
 drivers/usb/gadget/udc/gr_udc.c                         |   16 +-
 drivers/usb/musb/omap2430.c                             |    2=20
 drivers/vfio/pci/vfio_pci_nvlink2.c                     |    6=20
 drivers/video/fbdev/pxa168fb.c                          |    6=20
 drivers/virtio/virtio_balloon.c                         |    2=20
 drivers/visorbus/visorchipset.c                         |   11 -
 drivers/vme/bridges/vme_fake.c                          |   30 ++-
 fs/btrfs/check-integrity.c                              |    3=20
 fs/btrfs/ctree.h                                        |   20 +-
 fs/btrfs/file-item.c                                    |    3=20
 fs/btrfs/inode.c                                        |  121 +++++++++++=
+----
 fs/btrfs/volumes.c                                      |   44 +++++
 fs/ceph/mds_client.c                                    |    3=20
 fs/ceph/super.c                                         |    5=20
 fs/cifs/cifs_dfs_ref.c                                  |   97 +++++-------
 fs/cifs/connect.c                                       |    6=20
 fs/cifs/dfs_cache.c                                     |    2=20
 fs/cifs/smb2pdu.c                                       |    3=20
 fs/ext4/file.c                                          |   10 -
 fs/ext4/readpage.c                                      |   17 +-
 fs/f2fs/data.c                                          |   13 -
 fs/f2fs/file.c                                          |   50 ++++--
 fs/f2fs/namei.c                                         |   27 +--
 fs/f2fs/sysfs.c                                         |   12 +
 fs/fuse/file.c                                          |   12 +
 fs/jbd2/checkpoint.c                                    |    2=20
 fs/jbd2/commit.c                                        |    4=20
 fs/jbd2/journal.c                                       |   24 +--
 fs/nfs/nfs42proc.c                                      |    4=20
 fs/nfsd/vfs.c                                           |   19 +-
 fs/ocfs2/dlm/Makefile                                   |    2=20
 fs/ocfs2/dlm/dlmast.c                                   |    8 -
 fs/ocfs2/dlm/dlmconvert.c                               |    8 -
 fs/ocfs2/dlm/dlmdebug.c                                 |    8 -
 fs/ocfs2/dlm/dlmdomain.c                                |    8 -
 fs/ocfs2/dlm/dlmlock.c                                  |    8 -
 fs/ocfs2/dlm/dlmmaster.c                                |    8 -
 fs/ocfs2/dlm/dlmrecovery.c                              |    8 -
 fs/ocfs2/dlm/dlmthread.c                                |    8 -
 fs/ocfs2/dlm/dlmunlock.c                                |    8 -
 fs/ocfs2/dlmfs/Makefile                                 |    2=20
 fs/ocfs2/dlmfs/dlmfs.c                                  |    4=20
 fs/ocfs2/dlmfs/userdlm.c                                |    6=20
 fs/ocfs2/journal.h                                      |    8 -
 fs/orangefs/orangefs-debugfs.c                          |    1=20
 fs/reiserfs/stree.c                                     |    3=20
 fs/reiserfs/super.c                                     |    2=20
 fs/udf/super.c                                          |   23 ++-
 include/linux/cpuhotplug.h                              |    1=20
 include/linux/dmaengine.h                               |    2=20
 include/linux/list_nulls.h                              |    8 -
 include/linux/pci.h                                     |    2=20
 include/linux/platform_data/ti-sysc.h                   |    1=20
 include/linux/raid/pq.h                                 |    3=20
 include/linux/rculist_nulls.h                           |    8 -
 include/media/v4l2-device.h                             |   12 -
 include/rdma/ib_verbs.h                                 |    9 -
 include/trace/events/rcu.h                              |    4=20
 kernel/bpf/inode.c                                      |    3=20
 kernel/cpu.c                                            |   13 +
 kernel/module.c                                         |   20 +-
 kernel/padata.c                                         |   30 ++-
 kernel/printk/printk.c                                  |    4=20
 kernel/rcu/tree.c                                       |   11 -
 kernel/rcu/tree_exp.h                                   |    2=20
 kernel/rcu/tree_plugin.h                                |   22 ++
 kernel/sched/core.c                                     |    3=20
 kernel/sched/topology.c                                 |   39 +++++
 kernel/time/alarmtimer.c                                |   20 +-
 kernel/trace/ftrace.c                                   |    5=20
 kernel/trace/trace_events_hist.c                        |   70 +++------
 kernel/trace/trace_events_trigger.c                     |    5=20
 kernel/trace/trace_stat.c                               |   31 ++--
 kernel/watchdog.c                                       |   10 -
 lib/debugobjects.c                                      |   46 +++---
 lib/raid6/mktables.c                                    |    2=20
 lib/scatterlist.c                                       |    2=20
 net/core/dev.c                                          |    4=20
 net/core/filter.c                                       |    2=20
 net/core/sock_map.c                                     |    3=20
 net/dsa/tag_qca.c                                       |    2=20
 net/netfilter/nft_tunnel.c                              |    3=20
 net/sched/cls_flower.c                                  |    1=20
 net/sched/cls_matchall.c                                |    1=20
 net/smc/smc_diag.c                                      |    5=20
 net/sunrpc/cache.c                                      |    2=20
 samples/bpf/Makefile                                    |    1=20
 scripts/Kbuild.include                                  |   15 -
 scripts/Kconfig.include                                 |    2=20
 scripts/kconfig/confdata.c                              |    2=20
 scripts/link-vmlinux.sh                                 |    4=20
 security/selinux/avc.c                                  |   53 +++----
 sound/core/control.c                                    |    5=20
 sound/pci/hda/patch_conexant.c                          |    1=20
 sound/pci/hda/patch_hdmi.c                              |    7=20
 sound/pci/hda/patch_realtek.c                           |   10 +
 sound/sh/aica.c                                         |    4=20
 sound/sh/sh_dac_audio.c                                 |    3=20
 sound/soc/atmel/Kconfig                                 |    2=20
 sound/soc/intel/boards/sof_rt5682.c                     |   43 +++++
 sound/soc/soc-topology.c                                |   42 ++---
 sound/soc/sof/intel/hda-dai.c                           |    3=20
 sound/soc/sof/intel/hda.h                               |    2=20
 sound/usb/card.c                                        |    4=20
 sound/usb/format.c                                      |    3=20
 sound/usb/pcm.c                                         |    4=20
 sound/usb/quirks.c                                      |   38 +++++
 sound/usb/quirks.h                                      |    5=20
 sound/usb/usx2y/usX2Yhwdep.c                            |    2=20
 tools/arch/x86/lib/x86-opcode-map.txt                   |    2=20
 tools/bpf/bpftool/cgroup.c                              |   56 +++++--
 tools/lib/api/fs/fs.c                                   |    4=20
 tools/objtool/Makefile                                  |    6=20
 tools/testing/selftests/bpf/test_select_reuseport.c     |   16 +-
 tools/testing/selftests/kselftest/runner.sh             |    2=20
 tools/testing/selftests/net/so_txtime.c                 |   84 ++++++++++-
 tools/testing/selftests/net/so_txtime.sh                |    9 -
 tools/testing/selftests/powerpc/eeh/eeh-functions.sh    |   10 -
 tools/testing/selftests/size/get_size.c                 |   24 ++-
 tools/usb/usbip/src/usbip_network.c                     |   40 +++--
 tools/usb/usbip/src/usbip_network.h                     |   12 -
 368 files changed, 3044 insertions(+), 1597 deletions(-)

Abel Vesa (1):
      clk: imx: Add correct failure handling for clk based helpers

Adam Ford (2):
      media: ov5640: Fix check for PLL1 exceeding max allowed rate
      drm/panel: simple: Add Logic PD Type 28 display support

Aditya Pakki (2):
      fore200e: Fix incorrect checks of NULL pointer dereference
      orinoco: avoid assertion in case of NULL pointer

Alex Deucher (3):
      drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency
      drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
      drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (=
v2)

Alexander Tsoy (2):
      ALSA: usb-audio: Add boot quirk for MOTU M Series
      ALSA: usb-audio: add implicit fb quirk for MOTU M Series

Alexandre Belloni (1):
      rtc: Kconfig: select REGMAP_I2C when necessary

Alexandre Ghiti (1):
      powerpc: Do not consider weak unresolved symbol relocations as bad

Alexey Kardashevskiy (1):
      vfio/spapr/nvlink2: Skip unpinning pages on error exit

Amanda Liu (1):
      drm/amd/display: Clear state after exiting fixed active VRR state

Amol Grover (1):
      nvmet: Pass lockdep expression to RCU lists

Anand Jain (1):
      btrfs: device stats, log when stats are zeroed

Andre Przywara (3):
      arm64: dts: allwinner: H6: Add PMU mode
      arm64: dts: allwinner: H5: Add PMU node
      arm: dts: allwinner: H3: Add PMU node

Andrei Otcheretianski (2):
      iwlwifi: mvm: Fix thermal zone registration
      iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()

Andrey Smirnov (2):
      ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3
      ARM: dts: imx6: rdu2: Limit USBH1 to Full Speed

Andrey Zhizhikin (1):
      tools lib api fs: Fix gcc9 stringop-truncation compilation error

Ard Biesheuvel (3):
      efi/x86: Map the entire EFI vendor string before copying it
      efi/x86: Don't panic or BUG() on non-critical error conditions
      x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd

Arnd Bergmann (7):
      PM / devfreq: exynos-ppmu: Fix excessive stack usage
      mlx5: work around high stack usage with gcc
      staging: rtl8188: avoid excessive stack usage
      wan: ixp4xx_hss: fix compile-testing on 64-bit
      visorbus: fix uninitialized variable access
      vme: bridges: reduce stack usage
      rbd: work around -Wuninitialized warning

Arvind Sankar (1):
      x86/sysfb: Fix check for bad VRAM size

Bartosz Golaszewski (1):
      clocksource: davinci: only enable clockevents once tim34 is initializ=
ed

Ben Skeggs (4):
      drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read fro=
m fw
      drm/nouveau/fault/gv100-: fix memory leak on module unload
      drm/nouveau/mmu: fix comptag memory leak
      drm/nouveau/disp/nv50-: prevent oops when no channel method map provi=
ded

Benjamin Gaignard (1):
      ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco

Bibby Hsieh (1):
      drm/mediatek: handle events when enabling/disabling crtc

Bjorn Andersson (1):
      arm64: dts: qcom: db845c: Enable ath10k 8bit host-cap quirk

Brandon Maier (1):
      remoteproc: Initialize rproc_class before use

Brendan Higgins (1):
      crypto: inside-secure - add unspecified HAS_IOMEM dependency

Can Guo (1):
      scsi: ufs: Complete pending requests in host reset and restore path

Cezary Rojewski (1):
      ASoC: SOF: Intel: hda: Fix SKL dai count

Changbin Du (1):
      x86/nmi: Remove irq_work from the long duration NMI handler

Chanwoo Choi (1):
      PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC depende=
ncy

Chao Yu (1):
      f2fs: fix memleak of kobject

Chen Zhou (2):
      dmaengine: fsl-qdma: fix duplicated argument to &&
      ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=3Dm

Chen-Yu Tsai (3):
      media: sun4i-csi: Deal with DRAM offset
      media: sun4i-csi: Fix data sampling polarity handling
      media: sun4i-csi: Fix [HV]sync polarity handling

Chris Down (1):
      bpf, btf: Always output invariant hit in pahole DWARF to BTF transform

Chris Mason (1):
      Btrfs: keep pages dirty when using btrfs_writepage_fixup_worker

Christian Borntraeger (1):
      KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups

Christoph Hellwig (2):
      bcache: rework error unwinding in register_bcache
      nvme-pci: remove nvmeq->tags

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error ha=
ndling path

Christophe Leroy (1):
      powerpc/mm: Don't log user reads to 0xffffffff

Colin Ian King (7):
      wil6210: fix break that is never reached because of zero'ing of a ret=
ry counter
      media: meson: add missing allocation failure check on new_buf
      drm/nouveau/nouveau: fix incorrect sizeof on args.src an args.dst
      clocksource/drivers/bcm2835_timer: Fix memory leak of timer
      drivers/block/zram/zram_drv.c: fix error return codes not being retur=
ned in writeback_store
      driver core: platform: fix u32 greater or equal to zero comparison
      iwlegacy: ensure loop counter addr does not wrap and cause an infinit=
e loop

Coly Li (5):
      bcache: fix use-after-free in register_bcache()
      bcache: fix memory corruption in bch_cache_accounting_clear()
      bcache: explicity type cast in bset_bkey_last()
      bcache: fix incorrect data type usage in btree_flush_write()
      bcache: properly initialize 'path' and 'err' in register_bcache()

Dan Carpenter (5):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()
      ALSA: usb-audio: unlock on error in probe
      cmd64x: potential buffer overflow in cmd64x_program_timings()
      ide: serverworks: potential overflow in svwks_set_pio_mode()

Daniel Drake (2):
      PCI: Add generic quirk for increasing D3hot delay
      PCI: Increase D3 delay for AMD Ryzen5/7 XHCI controllers

Daniel Jordan (1):
      padata: validate cpumask without removed CPU during offline

Daniel Vetter (1):
      radeon: insert 10ms sleep in dce5_crtc_load_lut

David S. Miller (1):
      sparc: Add .exit.data section.

David Sterba (2):
      btrfs: safely advance counter when looking up bio csums
      btrfs: separate definition of assertion failure handlers

Davide Caratti (2):
      net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
      net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Dingchen Zhang (1):
      drm: remove the newline for CRC source name.

Dmitry Osipenko (1):
      soc/tegra: fuse: Correct straps' address for older Tegra124 device tr=
ees

Dmitry Torokhov (2):
      net: phy: fixed_phy: fix use-after-free when checking link GPIO
      usb: dwc3: use proper initializers for property entries

Dor Askayo (1):
      drm/amd/display: do not allocate display_mode_lib unnecessarily

Douglas Anderson (1):
      clk: qcom: rcg2: Don't crash if our parent can't be found; return an =
error

Enric Balletbo i Serra (2):
      regulator: vctrl-regulator: Avoid deadlock getting and setting the vo=
ltage
      regulator: core: Fix exported symbols to the exported GPL version

Eric Biggers (1):
      ext4: fix deadlock allocating bio_post_read_ctx from mempool

Eric Dumazet (1):
      net/smc: fix leak of kernel memory to user space

Erik Kaneda (1):
      ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Eugen Hristev (2):
      media: i2c: mt9v032: fix enum mbus codes and frame sizes
      clk: at91: sam9x60: fix programmable clock prescaler

Felix Kuehling (1):
      drm/amdkfd: Fix permissions of hang_hws

Firo Yang (1):
      enic: prevent waking up stopped tx queues over watchdog reset

Forest Crossman (1):
      media: cx23885: Add support for AVerMedia CE310B

Geert Uytterhoeven (7):
      pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
      drm/mipi_dbi: Fix off-by-one bugs in mipi_dbi_blank()
      rtc: i2c/spi: Avoid inclusion of REGMAP support when not needed
      ARM: dts: r8a7779: Add device node for ARM global timer
      pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs
      driver core: Print device when resources present in really_probe()
      crypto: essiv - fix AEAD capitalization and preposition use in help t=
ext

Greg Kroah-Hartman (1):
      Linux 5.4.22

Grygorii Strashko (1):
      clk: ti: dra7: fix parent for gmac_clkctrl

Gustavo A. R. Silva (1):
      char: hpet: Fix out-of-bounds read bug

Hans de Goede (1):
      pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Harry Wentland (1):
      drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero

Hechao Li (1):
      bpf: Print error message for bpftool cgroup show

Heiner Kallweit (1):
      r8169: check that Realtek PHY driver module is loaded

Icenowy Zheng (1):
      clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Ido Schimmel (1):
      mlxsw: spectrum_dpipe: Add missing error path

Jacob Pan (3):
      iommu/vt-d: Fix off-by-one in PASID allocation
      iommu/vt-d: Match CPU and IOMMU paging mode
      iommu/vt-d: Avoid sending invalid page response

Jaegeuk Kim (4):
      f2fs: preallocate DIO blocks when forcing buffered_io
      f2fs: call f2fs_balance_fs outside of locked page
      f2fs: set I_LINKABLE early to avoid wrong access by vfs
      f2fs: free sysfs kobject

Jaihind Yadav (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_=
update()

Jakub Kicinski (1):
      Revert "nfp: abm: fix memory leak in nfp_abm_u32_knode_replace"

Jakub Sitnicki (1):
      bpf, sockhash: Synchronize_rcu before free'ing map

James Sewart (3):
      PCI: Fix pci_add_dma_alias() bitmask size
      PCI: Add nr_devfns parameter to pci_add_dma_alias()
      PCI: Add DMA alias quirk for PLX PEX NTB

James Smart (1):
      scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registrati=
on

Jan Kara (3):
      udf: Allow writing to 'Rewritable' partitions
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
      udf: Fix free space reporting for metadata and virtual partitions

Jason Ekstrand (1):
      ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid =
switch

Jean-Philippe Brucker (1):
      brcmfmac: sdio: Fix OOB interrupt initialization on brcm43362

Jeffrey Hugo (2):
      ath10k: Fix qmi init error handling
      clk: qcom: smd: Add missing bimc clock

Jerome Brunet (1):
      clk: actually call the clock init before any other callback of the cl=
ock

Jessica Yu (1):
      module: avoid setting info->name early in case we can fall back to in=
fo->mod->name

Jia-Ju Bai (4):
      gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpi=
o_irq_map/unmap()
      media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdis=
p_device_run()
      uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
      usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_pro=
be()

Jiewei Ke (1):
      RDMA/rxe: Fix error type of mmap_offset

Johan Jonker (3):
      arm64: dts: rockchip: fix dwmmc clock name for px30
      arm64: dts: rockchip: add reg property to brcmf sub-nodes
      ARM: dts: rockchip: add reg property to brcmf sub node for rk3188-bqe=
dison2qc

Johannes Thumshirn (1):
      btrfs: fix possible NULL-pointer dereference in integrity checks

John Garry (1):
      irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove probl=
ems

John Keeping (1):
      usb: dwc2: Fix IN FIFO allocation

John Ogness (1):
      printk: fix exclusive_console replaying

Jonathan Lemon (1):
      bnxt: Detach page from page pool before sending up the stack

Josef Bacik (1):
      btrfs: do not do delalloc reservation under page lock

Jun Lei (1):
      drm/amd/display: fixup DML dependencies

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail i=
nfo when load journal

Kai Vehmanen (1):
      ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

Kim Phillips (1):
      perf/x86/amd: Constrain Large Increment per Cycle events

Krzysztof Kozlowski (1):
      ARM: exynos_defconfig: Bring back explicitly wanted options

Kunihiko Hayashi (2):
      reset: uniphier: Add SCSSI reset control for each channel
      clk: uniphier: Add SCSSI clock gate for each channel

Leon Romanovsky (1):
      RDMA/mlx5: Don't fake udata for kernel path

Leonard Crestez (1):
      perf/imx_ddr: Fix cpu hotplug state cleanup

Li Guanglei (1):
      sched/core: Fix size of rq::uclamp initialization

Li RongQing (1):
      bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map

Liang Chen (1):
      bcache: cached_dev_free needs to put the sb page

Linus Walleij (1):
      net: ethernet: ixp4xx: Standard module init

Logan Gunthorpe (1):
      dmaengine: Store module owner in dma_device struct

Lokesh Vutla (1):
      arm64: dts: ti: k3-j721e-main: Add missing power-domains for smmu

Lorenz Bauer (1):
      selftests: bpf: Reset global state between reuseport test runs

Lu Baolu (1):
      iommu/vt-d: Remove unnecessary WARN_ON_ONCE()

Luc Van Oostenryck (1):
      misc: xilinx_sdfec: fix xsdfec_poll()'s return type

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths

Maciej Fijalkowski (1):
      i40e: Relax i40e_xsk_wakeup's return value when PF is busy

Manasi Navare (1):
      drm/fbdev: Fallback to non tiled mode if all tiles not present

Manu Gautam (1):
      arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Mao Wenan (1):
      NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_a=
dd_cpu().

Marc Zyngier (1):
      irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Marco Elver (2):
      rcu: Fix data-race due to atomic_t copy-by-value
      debugobjects: Fix various data races

Markus Elfring (1):
      drm/qxl: Complete exception handling in qxl_device_init()

Martin Blumenstingl (2):
      clk: meson: meson8b: make the CCF use the glitch-free mali mux
      net: phy: realtek: add logging for the RGMII TX delay configuration

Martin Schiller (1):
      wan/hdlc_x25: fix skb handling

Masahiro Yamada (4):
      kconfig: fix broken dependency in randconfig-generated .config
      kbuild: remove *.tmp file when filechk fails
      kbuild: use -S instead of -E for precise cc-option test in Kconfig
      ocfs2: make local header paths relative to C files

Masami Hiramatsu (2):
      modules: lockdep: Suppress suspicious RCU usage warning
      x86/decoder: Add TEST opcode to Group3-2

Matthieu Baerts (1):
      selftests: settings: tests can be in subsubdirs

Michael Bringmann (1):
      powerpc/pseries/lparcfg: Fix display of Maximum Memory

Michael S. Tsirkin (1):
      virtio_balloon: prevent pfn array overflow

Michael Walle (1):
      spi: spi-fsl-qspi: Ensure width is respected in spi-mem operations

Mike Marciniszyn (2):
      IB/hfi1: Add software counter for ctxt0 seq drop
      IB/hfi1: Add RcvShortLengthErrCnt to hfi1stats

Miklos Szeredi (1):
      fuse: don't overflow LLONG_MAX with end offset

Mikulas Patocka (1):
      dm thin: don't allow changing data device during thin-pool reload

Miquel Raynal (1):
      regulator: rk808: Lower log level on optional GPIOs being not availab=
le

Monk Liu (1):
      drm/amdgpu: fix KIQ ring test fail in TDR of SRIOV

Nathan Chancellor (8):
      drm/amdgpu: Ensure ret is always initialized when using SOC15_WAIT_ON=
_RREG
      media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2=
_device macros
      ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      tty: synclinkmp: Adjust indentation in several functions
      tty: synclink_gt: Adjust indentation in several functions
      hostap: Adjust indentation in prism2_hostapd_add_sta
      lib/scatterlist.c: adjust indentation in __sg_alloc_table

Navid Emamdoost (2):
      brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
      drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Neeraj Upadhyay (1):
      rcu: Fix missed wakeup of exp_wq waiters

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connectio=
ns

Nicola Lunghi (1):
      ALSA: usb-audio: add quirks for Line6 Helix devices fw>=3D2.82

Niklas Schnelle (2):
      s390/pci: Fix possible deadlock in recover_store()
      s390/pci: Recover handle in clp_set_pci_fn()

Nikola Cornij (1):
      drm/amd/display: Map ODM memory correctly when doing ODM combine

Nikolay Borisov (1):
      btrfs: Fix split-brain handling when changing FSID to metadata uuid

Oliver O'Halloran (4):
      powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid P=
E number
      powerpc/iov: Move VF pdev fixup into pcibios_fixup_iov()
      powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV
      selftests/eeh: Bump EEH wait time to 60s

Paolo Valente (1):
      block, bfq: do not plug I/O for bfq_queues with no proc refs

Parav Pandit (1):
      IB/core: Let IB core distribute cache update events

Paul Cercueil (1):
      gpu/drm: ingenic: Avoid null pointer deference in plane atomic update

Paul E. McKenney (1):
      rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls

Paul Kocialkowski (1):
      drm/gma500: Fixup fbdev stolen size usage evaluation

Paul Moore (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_=
insert()

Paulo Alcantara (SUSE) (1):
      cifs: Fix mount options set in automount

Per Forlin (1):
      net: dsa: tag_qca: Make sure there is headroom for tag

Peter Gro=DFe (1):
      ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Peter Rosin (1):
      fbdev: fix numbering of fbcon options

Peter Zijlstra (2):
      cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order
      asm-generic/tlb: add missing CONFIG symbol

Philipp Zabel (1):
      Input: edt-ft5x06 - work around first register access error

Philippe Schenker (1):
      spi: fsl-lpspi: fix only one cs-gpio working

Phong Tran (4):
      b43legacy: Fix -Wcast-function-type
      ipw2x00: Fix -Wcast-function-type
      iwlegacy: Fix -Wcast-function-type
      rtlwifi: rtl_pci: Fix -Wcast-function-type

Pierre-Louis Bossart (2):
      ASoC: soc-topology: fix endianness issues
      ASoC: SOF: Intel: hda-dai: fix compilation warning in pcm_prepare

Ping-Ke Shih (1):
      rtw88: fix rate mask for 1SS chip

Qian Cai (1):
      iommu/iova: Silence warnings under memory pressure

Rakesh Pillai (1):
      ath10k: Correct the DMA direction for management tx buffers

Rasmus Villemoes (1):
      net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Remi Pommarel (1):
      clk: meson: pll: Fix by 0 division in __pll_params_to_rate()

Ritesh Harjani (1):
      ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT

Rob Clark (1):
      drm/msm/adreno: fix zap vs no-zap handling

Robin Murphy (1):
      arm64: dts: rockchip: Fix NanoPC-T4 cooling maps

Ronnie Sahlberg (1):
      cifs: fix NULL dereference in match_prepath

Sam McNally (1):
      ASoC: Intel: sof_rt5682: Ignore the speaker amp when there isn't one.

Sami Tolvanen (2):
      arm64: lse: fix LSE atomics with LLVM's integrated assembler
      arm64: fix alternatives with LLVM's integrated assembler

Sascha Hauer (1):
      dmaengine: imx-sdma: Fix memory leak

Sathyanarayana Nujella (2):
      ASoC: intel: sof_rt5682: Add quirk for number of HDMI DAI's
      ASoC: intel: sof_rt5682: Add support for tgl-max98357a-rt5682

Sebastian Andrzej Siewior (1):
      x86/fpu: Deactivate FPU state after failure during state load

Sergei Shtylyov (1):
      clk: renesas: rcar-gen3: Allow changing the RPC[D2] clocks

Sergey Senozhatsky (1):
      char/random: silence a lockdep splat with printk()

Sergey Zakharchenko (1):
      media: uvcvideo: Add a quirk to force GEO GC6500 Camera bits-per-pixe=
l value

Shile Zhang (1):
      objtool: Fix ARCH=3Dx86_64 build error

Shuah Khan (1):
      usbip: Fix unsafe unaligned pointer usage

Shubhrajyoti Datta (1):
      microblaze: Prevent the overflow of the start

Siddhesh Poyarekar (1):
      kselftest: Minimise dependency of get_size on C library interfaces

Simon Schwartz (1):
      driver core: platform: Prevent resouce overflow from causing infinite=
 loops

Stanley Chu (2):
      scsi: ufs: pass device information to apply_dev_quirks
      scsi: ufs-mediatek: add apply_dev_quirks variant operation

Stefan Reiter (1):
      rcu/nocb: Fix dump_tree hierarchy print always active

Stephen Boyd (4):
      clk: qcom: Don't overwrite 'cfg' in clk_rcg2_dfs_populate_freq()
      clk: Use parent node pointer during registration if necessary
      gpiolib: Set lockdep class for hierarchical irq domains
      alarmtimer: Make alarmtimer platform device child of RTC device

Steve French (2):
      cifs: fix unitialized variable poential problem with network I/O cach=
e lock patch
      cifs: log warning message (once) if out of disk space

Steven Rostedt (VMware) (1):
      tracing: Fix very unlikely race of registering two stat tracers

Sun Ke (1):
      nbd: add a flush_workqueue in nbd_start_device

Suravee Suthikulpanit (2):
      iommu/amd: Check feature support bit before accessing MSI capability =
registers
      iommu/amd: Only support x2APIC with IVHD type 11h/40h

Takashi Iwai (3):
      ALSA: sh: Fix unused variable warnings
      ALSA: hda/realtek - Apply mic mute LED quirk for Dell E7xx laptops, t=
oo
      ALSA: sh: Fix compile warning wrt const

Takashi Sakamoto (1):
      ALSA: ctl: allow TLV read operation for callback type of element in l=
ocked case

Thomas Gleixner (1):
      watchdog/softlockup: Enforce that timestamp is valid on boot

Tiecheng Zhou (1):
      drm/amdgpu/sriov: workaround on rev_id for Navi12 under sriov

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_=
init()

Toke H=F8iland-J=F8rgensen (2):
      core: Don't skip generic XDP program execution for cloned SKBs
      samples/bpf: Set -fno-stack-protector when building BPF programs

Tom Zanussi (1):
      tracing: Simplify assignment parsing for hist triggers

Tony Lindgren (2):
      bus: ti-sysc: Implement quirk handling for CLKDM_NOAUTO
      usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Trond Myklebust (2):
      nfsd: Clone should commit src file metadata too
      sunrpc: Fix potential leaks in sunrpc_cache_unhash()

Uwe Kleine-K=F6nig (2):
      pwm: omap-dmtimer: Simplify error handling
      pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunc=
tional

Valdis Kletnieks (1):
      x86/vdso: Provide missing include file

Valentin Schneider (1):
      sched/topology: Assert non-NUMA topology masks don't (partially) over=
lap

Vasily Averin (4):
      bpf: map_seq_next should always increase position index
      ftrace: fpid_next() should increase position index
      trigger_next should increase position index
      help_next should increase position index

Vasily Gorbik (2):
      s390: adjust -mpacked-stack support check for clang 10
      s390/ftrace: generate traced function stack frame

Vinay Kumar Yadav (1):
      crypto: chtls - Fixed memory leak

Vincenzo Frascino (2):
      ARM: 8952/1: Disable kmemleak on XIP kernels
      ARM: 8951/1: Fix Kexec compilation issue.

Viresh Kumar (1):
      opp: Free static OPPs on errors while adding them

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver

Wei Liu (1):
      PCI: iproc: Apply quirk_paxc_bridge() for module as well as built-in

Wei Yongjun (1):
      EDAC/sifive: Fix return value check in ecc_register()

Wen Gong (1):
      ath10k: correct the tlv len of ath10k_wmi_tlv_op_gen_config_pno_start

Wenpeng Liang (1):
      RDMA/hns: Avoid printing address of mtt page

Wenwen Wang (1):
      NFS: Fix memory leaks

Will Deacon (1):
      iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Willem de Bruijn (1):
      selftests/net: make so_txtime more robust to timer variance

Xin Long (1):
      netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy

Xiubo Li (1):
      ceph: check availability of mds cluster on mount after wait timeout

Yan-Hsuan Chuang (1):
      rtw88: fix potential NULL skb access in TX ISR

Yong Zhao (1):
      drm/amdkfd: Fix a bug in SDMA RLC queue counting under HWS mode

Yongqiang Niu (1):
      drm/mediatek: Add gamma property according to hardware capability

YueHaibing (3):
      kernel/module: Fix memleak in module_add_modinfo_attrs()
      drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler
      drm/nouveau/drm/ttm: Remove set but not used variable 'mem'

Yunfeng Ye (1):
      reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Zahari Petkov (1):
      leds: pca963x: Fix open-drain initialization

Zenghui Yu (1):
      irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when build=
ing INVALL

Zhengyuan Liu (2):
      raid6/test: fix a compilation error
      raid6/test: fix a compilation warning

Zhiqiang Liu (1):
      brd: check and limit max_part par

wangyan (1):
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fs=
ync_trans()

yu kuai (2):
      drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get=
_connector_info_from_object_table
      pwm: Remove set but not set variable 'pwm'

zhangyi (F) (3):
      ext4, jbd2: ensure panic when aborting with zero errno
      jbd2: switch to use jbd2_journal_abort() when failed to submit the co=
mmit record
      jbd2: make sure ESHUTDOWN to be recorded in the journal superblock

zhengbin (1):
      KVM: PPC: Remove set but not used variable 'ra', 'rs', 'rt'


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5TglsACgkQONu9yGCS
aT7NZg/9F6ODjsgiryhg1gqEd3I8l7k0MWH8Q4wcq5ZNknfbJFWInUJj87GhWlpK
7PPfGf78h6IDRrSPHn1I0k7FB7IlLSFkkqyn71thp7iw1DQduXrFTuxPQHacKlOw
/ERD8bOoTKIF/AZ9b3N+fbKy2YDRTRsyEE1Gl+Z26/aTwhu4yGlbh8hAiU9CRh8b
qGkFm0V2fNR3xEjj8LglkGZWYkMbTDlIeY6tiXdnPeJp6NE5Zq5dqr3+OK0KaeV4
SLrqF5r3kTDG89lch/DQsISKRMJMkcZIvD2BDEjMhxxRGRakYej39hb+HokNz/e4
nBXXq4ouiGdqL9vtF/6Ut75bM6XUZDs8NQg5RsWgdwhRVvOgstr1UcyjuPOAMBJw
f65RMWWbx144Yl9FNN8oiQ3uIM/zyw3hmDxHbBCzdLlxoC2fBY0pDDocHDjnUyAx
UOGoWpjv2cHMbyY3UMOjZgC6WLz+fPpxMdh7kdRdUW2ayVNe352NtfrIhOydp4iL
YLMnhikBOCf8nPKBojivxWd3zZ5GW2NEKtJv2pXrD79d1y8NoWTvT+j2kh+4j8DF
hQhJAl5x+EE/CzDcFWc7g5msjm7fAyQGX5LLJR+kp3ntNw9MO+HiuRfuqtH8YBac
x5OCP3iYeY3t0RG7JRa7xqOUhNlWLk/Emgztm+Gd+wupQ2q7wNk=
=dOMi
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
