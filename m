Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B254512DA92
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 18:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfLaRYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 12:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfLaRYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 12:24:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFEDF206DB;
        Tue, 31 Dec 2019 17:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577813088;
        bh=hiO1C89w2fTNFDPf3Z5j9BmkWkduJOdlfVVwCWIQoPc=;
        h=Date:From:To:Cc:Subject:From;
        b=cawwBEbrxQ3uKbxTkR8WwdLdgM6QQ14VQsrEN8lO5g0I0otS1e3UcGJnvPs34F2iW
         0UxYf+ynEHKhpPciw0pwDwrUod5g2uR9q5qhlCTfsXJ32jp/hadx+E8+S1PGOiQXpm
         RLHAnsJOztjZ4ERMXIOMoON36KnxRJPNXynq6wlY=
Date:   Tue, 31 Dec 2019 18:24:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.7
Message-ID: <20191231172446.GA2374306@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.7 kernel.

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

 Makefile                                                            |    2=
=20
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi                      |    4=
=20
 arch/arm64/kernel/psci.c                                            |   15=
 -
 arch/arm64/kvm/sys_regs.c                                           |    5=
=20
 arch/mips/include/asm/barrier.h                                     |   13=
=20
 arch/mips/include/asm/futex.h                                       |   15=
 -
 arch/mips/include/asm/pgtable-64.h                                  |    9=
=20
 arch/mips/ralink/Kconfig                                            |    1=
=20
 arch/powerpc/include/asm/spinlock.h                                 |    4=
=20
 arch/powerpc/kernel/irq.c                                           |    4=
=20
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                             |    4=
=20
 arch/powerpc/platforms/pseries/setup.c                              |    7=
=20
 arch/s390/crypto/sha_common.c                                       |    7=
=20
 arch/s390/include/asm/pgalloc.h                                     |   16=
 -
 arch/s390/include/asm/timex.h                                       |   16=
 -
 arch/s390/kernel/dis.c                                              |   13=
=20
 arch/s390/kernel/perf_cpum_cf.c                                     |   21=
 -
 arch/s390/kernel/perf_cpum_cf_diag.c                                |   10=
=20
 arch/s390/kernel/perf_event.c                                       |    8=
=20
 arch/s390/mm/maccess.c                                              |   12=
=20
 arch/s390/net/bpf_jit_comp.c                                        |    5=
=20
 arch/sh/include/cpu-sh4/cpu/sh7734.h                                |    2=
=20
 arch/x86/include/asm/crash.h                                        |    2=
=20
 arch/x86/include/asm/fixmap.h                                       |    2=
=20
 arch/x86/include/asm/syscall_wrapper.h                              |   23=
 -
 arch/x86/kernel/apic/io_apic.c                                      |    9=
=20
 arch/x86/kernel/cpu/mce/amd.c                                       |    4=
=20
 arch/x86/kernel/cpu/mce/core.c                                      |    2=
=20
 arch/x86/kernel/cpu/mce/therm_throt.c                               |    2=
=20
 arch/x86/kernel/early-quirks.c                                      |    2=
=20
 arch/x86/kvm/cpuid.c                                                |    6=
=20
 arch/x86/lib/x86-opcode-map.txt                                     |   18=
 -
 arch/x86/math-emu/fpu_system.h                                      |    6=
=20
 arch/x86/math-emu/reg_ld_str.c                                      |    6=
=20
 arch/x86/mm/pgtable.c                                               |    4=
=20
 block/blk-iocost.c                                                  |   13=
=20
 crypto/Kconfig                                                      |    1=
=20
 crypto/Makefile                                                     |    2=
=20
 crypto/asymmetric_keys/asym_tpm.c                                   |    1=
=20
 crypto/asymmetric_keys/public_key.c                                 |    1=
=20
 drivers/acpi/button.c                                               |   11=
=20
 drivers/ata/libata-core.c                                           |    3=
=20
 drivers/base/firmware_loader/builtin/Makefile                       |    3=
=20
 drivers/block/loop.c                                                |   26=
 +
 drivers/block/nbd.c                                                 |    6=
=20
 drivers/bluetooth/btusb.c                                           |    5=
=20
 drivers/char/hw_random/omap3-rom-rng.c                              |    3=
=20
 drivers/char/ipmi/ipmi_msghandler.c                                 |   23=
 +
 drivers/char/tpm/tpm-dev-common.c                                   |    8=
=20
 drivers/char/tpm/tpm_tis_core.c                                     |   35=
 +-
 drivers/clk/imx/clk-composite-8m.c                                  |    2=
=20
 drivers/clk/imx/clk-imx7ulp.c                                       |    1=
=20
 drivers/clk/imx/clk-pll14xx.c                                       |    2=
=20
 drivers/cpufreq/cpufreq.c                                           |    7=
=20
 drivers/cpufreq/sun50i-cpufreq-nvmem.c                              |   25=
 -
 drivers/crypto/atmel-aes.c                                          |   18=
 -
 drivers/crypto/atmel-authenc.h                                      |    2=
=20
 drivers/crypto/atmel-sha.c                                          |    2=
=20
 drivers/crypto/inside-secure/safexcel.c                             |    2=
=20
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c                           |   22=
 -
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                             |   12=
=20
 drivers/crypto/virtio/virtio_crypto_algs.c                          |   12=
=20
 drivers/crypto/vmx/Makefile                                         |    6=
=20
 drivers/edac/amd64_edac.c                                           |    2=
=20
 drivers/edac/ghes_edac.c                                            |   10=
=20
 drivers/extcon/extcon-sm5502.c                                      |    4=
=20
 drivers/extcon/extcon-sm5502.h                                      |    2=
=20
 drivers/firmware/efi/efi.c                                          |   28=
 +
 drivers/fsi/fsi-core.c                                              |   31=
 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                         |   10=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_test.c                            |    2=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h                           |   18=
 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                              |   12=
=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                               |    3=
=20
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c                              |   61=
 ++--
 drivers/gpu/drm/amd/amdgpu/si_ih.c                                  |    3=
=20
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c               |    3=
=20
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c                          |    5=
=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |    5=
=20
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c        |   10=
=20
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr_vbios_smu.c |    2=
=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                       |   17=
 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                    |    2=
=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c                  |    3=
=20
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c                     |    4=
=20
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c                        |    3=
=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                  |    5=
=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_optc.c                   |    4=
=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c               |    7=
=20
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c                 |   40=
 +-
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h                   |    6=
=20
 drivers/gpu/drm/amd/display/include/ddc_service_types.h             |    2=
=20
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c             |   13=
=20
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c           |   77=
 +++--
 drivers/gpu/drm/amd/display/modules/power/power_helpers.h           |    1=
=20
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c                          |    5=
=20
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_baco.c                   |   12=
=20
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c                          |    4=
=20
 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c                    |    2=
=20
 drivers/gpu/drm/bridge/analogix-anx78xx.c                           |    8=
=20
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                           |   12=
=20
 drivers/gpu/drm/drm_edid.c                                          |    6=
=20
 drivers/gpu/drm/drm_mipi_dbi.c                                      |    5=
=20
 drivers/gpu/drm/drm_vblank.c                                        |    6=
=20
 drivers/gpu/drm/exynos/exynos_hdmi.c                                |   31=
 +-
 drivers/gpu/drm/gma500/oaktrail_crtc.c                              |    2=
=20
 drivers/gpu/drm/meson/meson_vclk.c                                  |    9=
=20
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                         |   24=
 -
 drivers/gpu/drm/nouveau/nouveau_connector.c                         |   33=
 +-
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c               |    1=
=20
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c                      |    1=
=20
 drivers/gpu/drm/scheduler/sched_main.c                              |   43=
 +--
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                              |    4=
=20
 drivers/gpu/drm/tegra/sor.c                                         |    5=
=20
 drivers/gpu/drm/ttm/ttm_bo.c                                        |   44=
 +--
 drivers/gpu/drm/vc4/vc4_hdmi.c                                      |   13=
=20
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                              |   28=
 +
 drivers/gpu/host1x/job.c                                            |   11=
=20
 drivers/hwtracing/intel_th/core.c                                   |    7=
=20
 drivers/hwtracing/intel_th/intel_th.h                               |    2=
=20
 drivers/hwtracing/intel_th/msu.c                                    |   14=
=20
 drivers/hwtracing/intel_th/pci.c                                    |   10=
=20
 drivers/iio/adc/dln2-adc.c                                          |   20=
 -
 drivers/iio/adc/max1027.c                                           |    8=
=20
 drivers/iio/dac/Kconfig                                             |    4=
=20
 drivers/iio/dac/ad5446.c                                            |    6=
=20
 drivers/iio/light/bh1750.c                                          |    4=
=20
 drivers/iio/pressure/cros_ec_baro.c                                 |    3=
=20
 drivers/iio/temperature/max31856.c                                  |    2=
=20
 drivers/infiniband/core/device.c                                    |   22=
 +
 drivers/infiniband/hw/bnxt_re/main.c                                |    9=
=20
 drivers/infiniband/hw/bnxt_re/qplib_res.h                           |    8=
=20
 drivers/infiniband/hw/efa/efa_com.c                                 |    5=
=20
 drivers/infiniband/hw/hns/hns_roce_restrack.c                       |   10=
=20
 drivers/infiniband/hw/hns/hns_roce_srq.c                            |   24=
 -
 drivers/infiniband/hw/qedr/main.c                                   |    1=
=20
 drivers/infiniband/hw/qedr/verbs.c                                  |   12=
=20
 drivers/infiniband/sw/siw/siw_main.c                                |   20=
 -
 drivers/infiniband/sw/siw/siw_verbs.c                               |  143=
 ++++++++--
 drivers/infiniband/ulp/iser/iscsi_iser.c                            |    1=
=20
 drivers/iommu/intel-iommu.c                                         |   12=
=20
 drivers/iommu/iommu.c                                               |    8=
=20
 drivers/md/bcache/alloc.c                                           |    5=
=20
 drivers/md/bcache/bcache.h                                          |    2=
=20
 drivers/md/bcache/super.c                                           |   51=
 ++-
 drivers/md/md-bitmap.c                                              |    2=
=20
 drivers/md/md.c                                                     |   46=
 ++-
 drivers/media/i2c/Kconfig                                           |    1=
=20
 drivers/media/i2c/ad5820.c                                          |    1=
=20
 drivers/media/i2c/ov2659.c                                          |   18=
 -
 drivers/media/i2c/ov5640.c                                          |    5=
=20
 drivers/media/i2c/ov6650.c                                          |   75=
 +++--
 drivers/media/i2c/smiapp/smiapp-core.c                              |   12=
=20
 drivers/media/i2c/st-mipid02.c                                      |    5=
=20
 drivers/media/pci/cx88/cx88-video.c                                 |   11=
=20
 drivers/media/platform/am437x/am437x-vpfe.c                         |    4=
=20
 drivers/media/platform/aspeed-video.c                               |   12=
=20
 drivers/media/platform/exynos4-is/media-dev.c                       |    7=
=20
 drivers/media/platform/meson/ao-cec-g12a.c                          |   36=
 +-
 drivers/media/platform/meson/ao-cec.c                               |   30=
 +-
 drivers/media/platform/qcom/venus/core.c                            |    9=
=20
 drivers/media/platform/qcom/venus/hfi_venus.c                       |    6=
=20
 drivers/media/platform/rcar_drif.c                                  |    1=
=20
 drivers/media/platform/seco-cec/seco-cec.c                          |    1=
=20
 drivers/media/platform/ti-vpe/vpdma.h                               |    1=
=20
 drivers/media/platform/ti-vpe/vpe.c                                 |   52=
 ++-
 drivers/media/platform/vicodec/vicodec-core.c                       |    4=
=20
 drivers/media/platform/vim2m.c                                      |    8=
=20
 drivers/media/platform/vimc/vimc-common.c                           |    3=
=20
 drivers/media/platform/vimc/vimc-debayer.c                          |    1=
=20
 drivers/media/platform/vimc/vimc-scaler.c                           |    1=
=20
 drivers/media/platform/vimc/vimc-sensor.c                           |    1=
=20
 drivers/media/platform/vivid/vivid-core.c                           |    4=
=20
 drivers/media/radio/si470x/radio-si470x-i2c.c                       |    2=
=20
 drivers/media/usb/b2c2/flexcop-usb.c                                |    8=
=20
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                            |    9=
=20
 drivers/media/v4l2-core/v4l2-ctrls.c                                |    7=
=20
 drivers/media/v4l2-core/v4l2-ioctl.c                                |   33=
 +-
 drivers/misc/fastrpc.c                                              |    4=
=20
 drivers/misc/ocxl/file.c                                            |   23=
 -
 drivers/mmc/host/mtk-sd.c                                           |    2=
=20
 drivers/mmc/host/sdhci-msm.c                                        |   28=
 +
 drivers/mmc/host/sdhci-of-esdhc.c                                   |    7=
=20
 drivers/mmc/host/sdhci-pci-core.c                                   |   10=
=20
 drivers/mmc/host/sdhci.c                                            |   11=
=20
 drivers/mmc/host/sdhci.h                                            |    2=
=20
 drivers/mmc/host/tmio_mmc_core.c                                    |    2=
=20
 drivers/net/bonding/bond_main.c                                     |   39=
 +-
 drivers/net/can/flexcan.c                                           |   73=
 ++---
 drivers/net/can/m_can/tcan4x5x.c                                    |    2=
=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |    6=
=20
 drivers/net/can/xilinx_can.c                                        |    7=
=20
 drivers/net/dsa/Kconfig                                             |    1=
=20
 drivers/net/dsa/b53/b53_common.c                                    |   21=
 +
 drivers/net/dsa/sja1105/sja1105_main.c                              |    4=
=20
 drivers/net/ethernet/amazon/ena/ena_com.h                           |    2=
=20
 drivers/net/ethernet/amazon/ena/ena_ethtool.c                       |   24=
 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                   |   16=
 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |    8=
=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                           |    1=
=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c                   |    9=
=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                   |    2=
=20
 drivers/net/ethernet/cortina/gemini.c                               |    2=
=20
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c                    |   14=
=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                          |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                     |    3=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |    3=
=20
 drivers/net/ethernet/ibm/ibmvnic.c                                  |   19=
 -
 drivers/net/ethernet/intel/i40e/i40e_common.c                       |   13=
=20
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                      |   32=
 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   10=
=20
 drivers/net/ethernet/intel/ice/ice_controlq.c                       |    2=
=20
 drivers/net/ethernet/intel/ice/ice_controlq.h                       |    5=
=20
 drivers/net/ethernet/intel/ice/ice_ethtool.c                        |   13=
=20
 drivers/net/ethernet/intel/ice/ice_main.c                           |   18=
 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                    |   12=
=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                       |    3=
=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                     |    6=
=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c               |    7=
=20
 drivers/net/ethernet/netronome/nfp/flower/metadata.c                |   12=
=20
 drivers/net/ethernet/qlogic/qede/qede_filter.c                      |    2=
=20
 drivers/net/ethernet/qlogic/qede/qede_main.c                        |    4=
=20
 drivers/net/ethernet/qlogic/qla3xxx.c                               |    8=
=20
 drivers/net/ethernet/realtek/r8169_main.c                           |   18=
 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c               |    2=
=20
 drivers/net/ethernet/ti/Kconfig                                     |    1=
=20
 drivers/net/ethernet/ti/cpsw_ale.c                                  |    2=
=20
 drivers/net/ethernet/ti/davinci_cpdma.c                             |    5=
=20
 drivers/net/fjes/fjes_main.c                                        |    3=
=20
 drivers/net/phy/dp83867.c                                           |   15=
 -
 drivers/net/phy/phy_device.c                                        |   21=
 -
 drivers/net/team/team.c                                             |    5=
=20
 drivers/net/tun.c                                                   |    4=
=20
 drivers/net/usb/lan78xx.c                                           |    1=
=20
 drivers/net/wireless/ath/ath10k/coredump.c                          |   11=
=20
 drivers/net/wireless/ath/ath10k/htt_rx.c                            |    2=
=20
 drivers/net/wireless/ath/ath10k/mac.c                               |   26=
 -
 drivers/net/wireless/ath/ath10k/txrx.c                              |    2=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c             |    5=
=20
 drivers/net/wireless/intel/iwlwifi/dvm/led.c                        |    3=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/led.c                        |    3=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                         |    3=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                        |   13=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c                |   25=
 -
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                     |   30=
 ++
 drivers/net/wireless/marvell/libertas/if_sdio.c                     |    5=
=20
 drivers/net/wireless/marvell/mwifiex/pcie.c                         |    5=
=20
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c                     |    4=
=20
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                     |    4=
=20
 drivers/net/wireless/quantenna/qtnfmac/commands.c                   |    6=
=20
 drivers/net/wireless/quantenna/qtnfmac/event.c                      |    7=
=20
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c                  |    6=
=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h                    |    1=
=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c              |    1=
=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c               |    3=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c                 |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    5=
=20
 drivers/net/wireless/realtek/rtw88/coex.c                           |   24=
 +
 drivers/net/wireless/realtek/rtw88/main.c                           |    3=
=20
 drivers/nfc/nxp-nci/i2c.c                                           |    2=
=20
 drivers/nvme/host/core.c                                            |   14=
=20
 drivers/nvme/host/multipath.c                                       |    1=
=20
 drivers/nvmem/imx-ocotp.c                                           |    4=
=20
 drivers/parport/share.c                                             |   21=
 +
 drivers/phy/qualcomm/phy-qcom-usb-hs.c                              |    7=
=20
 drivers/phy/renesas/phy-rcar-gen2.c                                 |    5=
=20
 drivers/pinctrl/devicetree.c                                        |   25=
 +
 drivers/pinctrl/intel/pinctrl-baytrail.c                            |   81=
 +++--
 drivers/pinctrl/pinctrl-amd.c                                       |    3=
=20
 drivers/pinctrl/qcom/pinctrl-sc7180.c                               |   18=
 -
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c                               |   25=
 -
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                                 |    4=
=20
 drivers/platform/x86/hp-wmi.c                                       |    2=
=20
 drivers/power/supply/cpcap-battery.c                                |    8=
=20
 drivers/regulator/core.c                                            |    5=
=20
 drivers/regulator/max8907-regulator.c                               |   15=
 -
 drivers/soundwire/intel.c                                           |   10=
=20
 drivers/spi/spi-cadence.c                                           |    6=
=20
 drivers/spi/spi-dw.c                                                |    8=
=20
 drivers/spi/spi-fsl-spi.c                                           |    7=
=20
 drivers/spi/spi-gpio.c                                              |    4=
=20
 drivers/spi/spi-img-spfi.c                                          |    2=
=20
 drivers/spi/spi-pxa2xx.c                                            |    6=
=20
 drivers/spi/spi-sifive.c                                            |   11=
=20
 drivers/spi/spi-sprd-adi.c                                          |    3=
=20
 drivers/spi/spi-st-ssc4.c                                           |    3=
=20
 drivers/spi/spi-tegra20-slink.c                                     |    5=
=20
 drivers/spi/spidev.c                                                |    3=
=20
 drivers/staging/comedi/drivers/gsc_hpdi.c                           |   10=
=20
 drivers/staging/fbtft/fbtft-core.c                                  |    2=
=20
 drivers/staging/iio/frequency/ad9834.c                              |    4=
=20
 drivers/staging/media/imx/imx-media-capture.c                       |    6=
=20
 drivers/staging/media/imx/imx7-mipi-csis.c                          |    7=
=20
 drivers/staging/media/sunxi/cedrus/cedrus.c                         |    2=
=20
 drivers/staging/media/sunxi/cedrus/cedrus.h                         |    8=
=20
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c                    |    8=
=20
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h                    |   31=
 +-
 drivers/staging/mt7621-pci/Kconfig                                  |    1=
=20
 drivers/staging/rtl8188eu/core/rtw_xmit.c                           |    4=
=20
 drivers/staging/rtl8192u/r8192U_core.c                              |   17=
 -
 drivers/staging/wilc1000/wilc_hif.c                                 |    2=
=20
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c                   |   18=
 -
 drivers/tty/serial/atmel_serial.c                                   |   43=
 +--
 drivers/tty/serial/sprd_serial.c                                    |    3=
=20
 drivers/usb/core/devio.c                                            |   15=
 -
 drivers/usb/host/ehci-q.c                                           |   13=
=20
 drivers/usb/host/xhci-pci.c                                         |    6=
=20
 drivers/usb/renesas_usbhs/common.h                                  |    3=
=20
 drivers/usb/renesas_usbhs/mod_gadget.c                              |   12=
=20
 drivers/usb/usbip/usbip_common.c                                    |    3=
=20
 drivers/usb/usbip/vhci_rx.c                                         |   13=
=20
 drivers/xen/Kconfig                                                 |    3=
=20
 fs/btrfs/async-thread.c                                             |   56=
 +++
 fs/btrfs/ctree.c                                                    |    2=
=20
 fs/btrfs/ctree.h                                                    |    2=
=20
 fs/btrfs/disk-io.c                                                  |    2=
=20
 fs/btrfs/extent-tree.c                                              |    7=
=20
 fs/btrfs/extent_io.c                                                |    6=
=20
 fs/btrfs/file-item.c                                                |    7=
=20
 fs/btrfs/inode.c                                                    |   12=
=20
 fs/btrfs/ioctl.c                                                    |   10=
=20
 fs/btrfs/reada.c                                                    |   10=
=20
 fs/btrfs/relocation.c                                               |    1=
=20
 fs/btrfs/scrub.c                                                    |    3=
=20
 fs/btrfs/send.c                                                     |    6=
=20
 fs/btrfs/tests/free-space-tree-tests.c                              |    4=
=20
 fs/btrfs/tests/qgroup-tests.c                                       |    4=
=20
 fs/btrfs/tree-checker.c                                             |   18=
 +
 fs/btrfs/tree-log.c                                                 |   52=
 +++
 fs/btrfs/uuid-tree.c                                                |    2=
=20
 fs/ext4/dir.c                                                       |    5=
=20
 fs/ext4/inode.c                                                     |    4=
=20
 fs/ext4/namei.c                                                     |   32=
 +-
 fs/ext4/super.c                                                     |  143=
 ++++------
 include/drm/drm_dp_mst_helper.h                                     |    2=
=20
 include/linux/cpufreq.h                                             |   11=
=20
 include/linux/ipmi_smi.h                                            |   12=
=20
 include/linux/mod_devicetable.h                                     |    4=
=20
 include/linux/nvme.h                                                |    1=
=20
 include/linux/nvmem-consumer.h                                      |    2=
=20
 include/linux/phy.h                                                 |    2=
=20
 include/linux/sched/cpufreq.h                                       |    3=
=20
 include/net/arp.h                                                   |    4=
=20
 include/net/dst.h                                                   |    2=
=20
 include/net/ndisc.h                                                 |    8=
=20
 include/net/neighbour.h                                             |    1=
=20
 include/net/sock.h                                                  |   12=
=20
 include/trace/events/wbt.h                                          |   12=
=20
 include/uapi/linux/cec-funcs.h                                      |    6=
=20
 kernel/bpf/stackmap.c                                               |    7=
=20
 kernel/bpf/verifier.c                                               |   19=
 +
 kernel/cgroup/freezer.c                                             |    9=
=20
 kernel/events/core.c                                                |    6=
=20
 kernel/sched/core.c                                                 |    6=
=20
 kernel/sched/cpufreq.c                                              |   18=
 +
 kernel/sched/cpufreq_schedutil.c                                    |    8=
=20
 kernel/sched/sched.h                                                |    2=
=20
 kernel/trace/trace.c                                                |    2=
=20
 kernel/trace/trace_kprobe.c                                         |   27=
 +
 lib/ubsan.c                                                         |    5=
=20
 mm/vmscan.c                                                         |    2=
=20
 net/bluetooth/hci_conn.c                                            |    8=
=20
 net/bluetooth/hci_core.c                                            |   13=
=20
 net/bluetooth/hci_request.c                                         |    9=
=20
 net/can/j1939/socket.c                                              |   10=
=20
 net/core/neighbour.c                                                |    3=
=20
 net/core/net-sysfs.c                                                |    7=
=20
 net/mac80211/status.c                                               |    3=
=20
 net/nfc/nci/uart.c                                                  |    2=
=20
 net/packet/af_packet.c                                              |    3=
=20
 net/sctp/protocol.c                                                 |    5=
=20
 net/sctp/stream.c                                                   |    8=
=20
 net/smc/smc_core.c                                                  |    9=
=20
 samples/pktgen/functions.sh                                         |   17=
 -
 sound/core/pcm_native.c                                             |    7=
=20
 sound/core/timer.c                                                  |   10=
=20
 sound/firewire/bebob/bebob_stream.c                                 |   11=
=20
 sound/pci/hda/patch_ca0132.c                                        |   23=
 +
 sound/soc/codecs/rt5677.c                                           |    1=
=20
 sound/soc/codecs/wm2200.c                                           |    5=
=20
 sound/soc/codecs/wm5100.c                                           |    2=
=20
 sound/soc/codecs/wm8904.c                                           |    1=
=20
 sound/soc/intel/boards/bytcr_rt5640.c                               |   10=
=20
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c                 |    3=
=20
 sound/soc/soc-pcm.c                                                 |   14=
=20
 sound/soc/sof/imx/Kconfig                                           |    8=
=20
 sound/soc/sof/intel/hda.c                                           |    1=
=20
 sound/soc/sof/topology.c                                            |    4=
=20
 tools/arch/x86/lib/x86-opcode-map.txt                               |   18=
 -
 tools/bpf/Makefile                                                  |    6=
=20
 tools/lib/bpf/btf_dump.c                                            |    8=
=20
 tools/lib/bpf/libbpf.c                                              |   14=
=20
 tools/lib/bpf/xsk.c                                                 |   14=
=20
 tools/lib/subcmd/Makefile                                           |    4=
=20
 tools/lib/traceevent/parse-filter.c                                 |    9=
=20
 tools/memory-model/linux-kernel.cat                                 |    2=
=20
 tools/objtool/check.c                                               |    1=
=20
 tools/perf/arch/arm64/util/sym-handling.c                           |    3=
=20
 tools/perf/builtin-report.c                                         |    7=
=20
 tools/perf/pmu-events/arch/arm64/hisilicon/hip08/uncore-ddrc.json   |    2=
=20
 tools/perf/pmu-events/jevents.c                                     |   13=
=20
 tools/perf/tests/bp_signal.c                                        |   15=
 -
 tools/perf/tests/task-exit.c                                        |    9=
=20
 tools/perf/util/cs-etm.c                                            |    4=
=20
 tools/perf/util/dwarf-aux.c                                         |   80=
 ++++-
 tools/perf/util/dwarf-aux.h                                         |    3=
=20
 tools/perf/util/parse-events.c                                      |   26=
 +
 tools/perf/util/probe-finder.c                                      |   45=
 ++-
 tools/perf/util/session.c                                           |   44=
 +--
 tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c              |    1=
=20
 tools/testing/selftests/bpf/cgroup_helpers.c                        |    2=
=20
 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c      |    5=
=20
 tools/testing/selftests/bpf/progs/test_seg6_loop.c                  |    4=
=20
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c               |    5=
=20
 tools/testing/selftests/bpf/test_progs.c                            |   17=
 -
 tools/testing/selftests/bpf/test_tc_tunnel.sh                       |    5=
=20
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh        |    2=
=20
 tools/testing/selftests/net/so_txtime.c                             |    4=
=20
 tools/testing/selftests/net/tls.c                                   |   28=
 -
 tools/testing/selftests/net/udpgso.c                                |    3=
=20
 tools/testing/selftests/net/udpgso_bench_tx.c                       |    3=
=20
 tools/testing/selftests/proc/proc-self-map-files-002.c              |    6=
=20
 virt/kvm/arm/mmu.c                                                  |   21=
 +
 423 files changed, 3084 insertions(+), 1505 deletions(-)

Adham Abozaeid (1):
      staging: wilc1000: check if device is initialzied before changing vif

Adrian Hunter (3):
      x86/insn: Add some Intel instructions to the opcode map
      mmc: sdhci: Workaround broken command queuing on Intel GLK
      mmc: sdhci: Add a quirk for broken command queuing

Akeem G Abodunrin (1):
      ice: Only disable VF state when freeing each VF resources

Alan Stern (1):
      tools/memory-model: Fix data race detection for unordered store and l=
oad

Alex Williamson (1):
      iommu/vt-d: Set ISA bridge reserved region as relaxable

Alexander Lobakin (1):
      net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling

Alexander Shishkin (5):
      perf/core: Fix the mlock accounting, again
      intel_th: pci: Add Comet Lake PCH-V support
      intel_th: pci: Add Elkhart Lake SOC support
      intel_th: Fix freeing IRQs
      intel_th: msu: Fix window switching without windows

Alexandru Ardelean (1):
      iio: dln2-adc: fix iio_triggered_buffer_postenable() position

Alexey Budankov (1):
      perf session: Fix decompression of PERF_RECORD_COMPRESSED records

Allen Pais (2):
      libertas: fix a potential NULL pointer dereference
      drm/amdkfd: fix a potential NULL pointer dereference (v2)

Anand Jain (1):
      btrfs: send: remove WARN_ON for readonly mount

Andrea Merello (1):
      iio: max31856: add missing of_node and parent references to iio_dev

Andrea Righi (1):
      bcache: fix deadlock in bcache_allocator

Andrew Jeffery (1):
      fsi: core: Fix small accesses and unaligned offsets via sysfs

Andrey Grodzovsky (1):
      drm/amdgpu: Avoid accidental thread reactivation.

Andrii Nakryiko (4):
      selftests/bpf: Fix btf_dump padding test case
      libbpf: Fix struct end padding in btf_dump
      selftests/bpf: Make a copy of subtest name
      libbpf: Fix negative FD close() in xsk_setup_xdp_prog()

Andy Shevchenko (1):
      fbtft: Make sure string is NULL terminated

Anilkumar Kolli (1):
      ath10k: fix backtrace on coredump

Anthony Koo (2):
      drm/amd/display: set minimum abm backlight level
      drm/amd/display: correctly populate dpp refclk in fpga

Ard Biesheuvel (4):
      crypto: aegis128-neon - use Clang compatible cflags for ARM
      crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicit=
ly
      crypto: virtio - deal with unsupported input sizes
      efi/memreserve: Register reservations as 'reserved' in /proc/iomem

Aric Cyr (1):
      drm/amd/display: Properly round nominal frequency for SPD

Arnd Bergmann (3):
      x86/math-emu: Check __copy_from_user() result
      crypto: inside-secure - Fix a maybe-uninitialized warning
      Bluetooth: btusb: avoid unused function warning

Arthur Kiyanovski (2):
      net: ena: fix default tx interrupt moderation interval
      net: ena: fix issues in setting interrupt moderation params in ethtool

Bart Van Assche (2):
      block: Fix writeback throttling W=3D1 compiler warnings
      RDMA/core: Set DMA parameters correctly

Ben Dooks (Codethink) (2):
      Bluetooth: missed cpu_to_le16 conversion in hci_init4_req
      pinctrl: amd: fix __iomem annotation in amd_gpio_irq_handler()

Ben Greear (1):
      ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

Ben Hutchings (1):
      net: qlogic: Fix error paths in ql_alloc_large_buffers()

Ben Zhang (1):
      ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile

Benjamin Berg (1):
      x86/mce: Lower throttling MCE messages' priority to warning

Benoit Parrot (11):
      media: am437x-vpfe: Setting STD to current value is not an error
      media: i2c: ov2659: fix s_stream return value
      media: i2c: ov2659: Fix missing 720p register config
      media: ti-vpe: vpe: Fix Motion Vector vpdma stride
      media: ti-vpe: vpe: fix a v4l2-compliance warning about invalid pixel=
 format
      media: ti-vpe: vpe: fix a v4l2-compliance failure about frame sequenc=
e number
      media: ti-vpe: vpe: Make sure YUYV is set as default format
      media: ti-vpe: vpe: fix a v4l2-compliance failure causing a kernel pa=
nic
      media: ti-vpe: vpe: ensure buffers are cleaned up properly in abort c=
ases
      media: ti-vpe: vpe: fix a v4l2-compliance failure about invalid sizei=
mage
      media: ov5640: Make 2592x1944 mode only available at 15 fps

Bernard Metzler (2):
      RDMA/siw: Fix SQ/RQ drain logic
      RDMA/siw: Fix post_recv QP state locking

Biju Das (1):
      phy: renesas: phy-rcar-gen2: Fix the array off by one warning

Bjorn Andersson (2):
      ath10k: Correct error handling of dma_map_single()
      ath10k: Revert "ath10k: add cleanup in ath10k_sta_state()"

Brett Creeley (1):
      ice: Fix setting coalesce to handle DCB configuration

Brian Masney (1):
      drm/bridge: analogix-anx78xx: silence -EPROBE_DEFER warnings

Chaotian Jing (1):
      mmc: mediatek: fix CMD_TA to 2 for MT8173 HS200/HS400 mode

Charles Keepax (2):
      spi: dw: Correct handling of native chipselect
      spi: cadence: Correct handling of native chipselect

Chris Chiu (1):
      rtl8xxxu: fix RTL8723BU connection failure issue after warm reboot

Christian K=C3=B6nig (2):
      drm/amdgpu: grab the id mgr lock while accessing passid_mapping
      drm/ttm: return -EBUSY on pipelining with no_gpu_wait (v2)

Christophe JAILLET (2):
      media: seco-cec: Add a missing 'release_region()' in an error handlin=
g path
      media: cx88: Fix some error handling path in 'cx8800_initdev()'

Christophe Leroy (3):
      spi: fsl: don't map irq during probe
      spi: fsl: use platform_get_irq() instead of of_irq_to_resource()
      powerpc/irq: fix stack overflow verification

Chuhong Yuan (11):
      fjes: fix missed check in fjes_acpi_add
      staging: iio: ad9834: add a check for devm_clk_get
      media: st-mipid02: add a check for devm_gpiod_get_optional
      media: imx7-mipi-csis: Add a check for devm_regulator_get
      spi: sifive: disable clk when probe fails and remove
      media: si470x-i2c: add missed operations in remove
      spi: pxa2xx: Add missed security checks
      spi: tegra20-slink: add missed clk_unprepare
      ASoC: wm2200: add missed operations in remove and probe failure
      spi: st-ssc4: add missed pm_runtime_disable
      ASoC: wm5100: add missed pm_runtime_disable

Colin Ian King (2):
      RDMA/hns: Fix memory leak on 'context' on error return path
      drm/amdgpu: fix uninitialized variable pasid_mapping_needed

Coly Li (1):
      bcache: fix static checker warning in bcache_device_free()

Connor Kuehl (1):
      staging: rtl8188eu: fix possible null dereference

Corentin Labbe (1):
      crypto: sun4i-ss - Fix 64-bit size_t warnings on sun4i-ss-hash.c

Corey Minyard (1):
      ipmi: Don't allow device module unload when in use

Cristian Birsan (1):
      net: usb: lan78xx: Fix suspend/resume PHY register access error

Dan Carpenter (4):
      btrfs: return error pointer from alloc_test_extent_buffer
      drm/mipi-dbi: fix a loop in debugfs code
      staging: wilc1000: potential corruption in wilc_parse_join_bss_param()
      ext4: unlock on error in ext4_expand_extra_isize()

Daniel Kurtz (1):
      drm/bridge: dw-hdmi: Restore audio when setting a mode

Daniel T. Lee (1):
      samples: pktgen: fix proc_cmd command result check logic

Daniel Vetter (1):
      drm: Use EOPNOTSUPP, not ENOTSUPP

Dariusz Marcinkiewicz (2):
      drm/vc4/vc4_hdmi: fill in connector info
      drm: exynos: exynos_hdmi: use cec_notifier_conn_(un)register

Darrick J. Wong (1):
      loop: fix no-unmap write-zeroes request behavior

David Engraf (1):
      tty/serial: atmel: fix out of range clock divider handling

David Galiffi (1):
      drm/amd/display: Fix dongle_caps containing stale information.

Devesh Sharma (2):
      RDMA/bnxt_re: Fix missing le16_to_cpu
      RDMA/bnxt_re: Fix stat push into dma buffer on gen p5 devices

Dmitry Osipenko (1):
      regulator: core: Release coupled_rdevs on regulator_init_coupling() e=
rror

Dmytro Laktyushkin (1):
      drm/amd/display: enable hostvm based on roimmu active for dcn2.1

Eduard Hasenleithner (1):
      nvme: Discard workaround for non-conformant devices

Eric Auger (1):
      iommu: fix KASAN use-after-free in iommu_insert_resv_region

Eric Biggers (1):
      KEYS: asymmetric: return ENOMEM if akcipher_request_alloc() fails

Eric Dumazet (3):
      neighbour: remove neigh_cleanup() method
      bonding: fix bond_neigh_init()
      net: avoid potential false sharing in neighbor related code

Erkka Talvitie (1):
      USB: EHCI: Do not return -EPIPE when hub is disconnected

Eugeniu Rosca (1):
      mmc: tmio: Add MMC_CAP_ERASE to allow erase/discard/trim requests

Fabio Estevam (1):
      media: staging/imx: Use a shorter name for driver

Faiz Abbas (2):
      Revert "mmc: sdhci: Fix incorrect switch to HS mode"
      mmc: sdhci: Update the tuning failed messages to pr_debug level

Filipe Manana (3):
      Btrfs: make tree checker detect checksum items with overlapping ranges
      Btrfs: fix missing data checksums after replaying a log tree
      Btrfs: fix removal logic of the tree mod log that leads to use-after-=
free issues

Florian Fainelli (1):
      net: dsa: b53: Fix egress flooding settings

Frederic Barrat (1):
      ocxl: Fix concurrent AFU open and device removal

Gal Pressman (1):
      RDMA/efa: Clear the admin command buffer prior to its submission

Geert Uytterhoeven (4):
      net: dst: Force 4-byte alignment of dst_metrics
      Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit30 when using SSI_=
SCK2 and SSI_WS2"
      Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit31 when using SIM0=
_D"
      pinctrl: sh-pfc: sh7734: Fix duplicate TCLK1_B

Gerald Schaefer (1):
      s390/mm: add mm_pxd_folded() checks to pxd_free()

Gerd Hoffmann (1):
      drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper.

Greg Kroah-Hartman (1):
      Linux 5.4.7

Grygorii Strashko (3):
      net: ethernet: ti: davinci_cpdma: fix warning "device driver frees DM=
A memory with different size"
      net: phy: dp83867: enable robust auto-mdix
      net: ethernet: ti: ale: clean ale tbl on init and intf restart

Guenter Roeck (1):
      usb: xhci: Fix build warning seen with CONFIG_PM=3Dn

Guoqing Jiang (1):
      md/bitmap: avoid race window between md_bitmap_resize and bitmap_file=
_clear_bit

Gwendal Grignou (1):
      iio: cros_ec_baro: set info_mask_shared_by_all_available field

Hangbin Liu (1):
      team: call RCU read lock when walking the port_list

Hans Verkuil (5):
      media: cedrus: fill in bus_info for media device
      media: cec-funcs.h: add status_req checks
      media: vivid: media_device_cleanup was called too early
      media: vicodec: media_device_cleanup was called too early
      media: vim2m: media_device_cleanup was called too early

Hans de Goede (4):
      ACPI: button: Add DMI quirk for Medion Akoya E2215T
      ASoC: Intel: bytcr_rt5640: Update quirk for Acer Switch 10 SW5-012 2-=
in-1
      platform/x86: hp-wmi: Make buffer for HPWMI_FEATURE2_QUERY 128 bytes
      pinctrl: baytrail: Really serialize all register accesses

Hauke Mehrtens (1):
      ath10k: Check if station exists before forwarding tx airtime report

Hawking Zhang (1):
      drm/amdgpu: disallow direct upload save restore list from gfx driver

Heiko Carstens (1):
      s390/time: ensure get_clock_monotonic() returns monotonic values

Heiner Kallweit (1):
      r8169: respect EEE user setting when restarting network

Herbert Xu (2):
      crypto: atmel - Fix authenc support when it is set to m
      crypto: sun4i-ss - Fix 64-bit size_t warnings

Hewenliang (1):
      libtraceevent: Fix memory leakage in copy_filter_type

Honglei Wang (1):
      cgroup: freezer: don't change task and cgroups status unnecessarily

Ian Abbott (1):
      staging: comedi: gsc_hpdi: check dma_alloc_coherent() return value

Ian Rogers (2):
      perf tools: Splice events onto evlist even on error
      perf parse: If pmu configuration fails free terms

Ido Schimmel (2):
      selftests: forwarding: Delete IPv6 address at the end
      mlxsw: spectrum_router: Remove unlikely user-triggerable warning

Ilya Leoshkevich (3):
      s390: add error handling to perf_callchain_kernel
      s390/bpf: Use kvcalloc for addrs array
      s390/disassembler: don't hide instruction addresses

Ilya Maximets (1):
      libbpf: Fix passing uninitialized bytes to setsockopt

Ingo Rohloff (1):
      usb: usbfs: Suppress problematic bind and unbind uevents.

Ioana Ciornei (1):
      dpaa2-ptp: fix double free of the ptp_qoriq IRQ

Ivan Khoronzhuk (1):
      selftests/bpf: Correct path to include msg + path

Jack Zhang (1):
      drm/amdgpu/sriov: add ring_stop before ring_create in psp v11 code

Jae Hyun Yoo (2):
      media: aspeed: set hsync and vsync polarities to normal before starti=
ng mode detection
      media: aspeed: clear garbage interrupts

Jaehyun Chung (1):
      drm/amd/display: OTC underflow fix

Jagan Teki (1):
      drm/sun4i: dsi: Fix TCON DRQ set bits

James Clark (1):
      libsubcmd: Use -O0 with DEBUG=3D1

Jan H. Sch=C3=B6nherr (1):
      x86/mce: Fix possibly incorrect severity calculation on AMD

Jan Kara (2):
      ext4: fix ext4_empty_dir() for directories with holes
      ext4: check for directory entries too close to block end

Janusz Krzysztofik (5):
      media: ov6650: Fix control handler not freed on init error
      media: ov6650: Fix crop rectangle alignment not passed back
      media: ov6650: Fix stored frame format not in sync with hardware
      media: ov6650: Fix stored crop rectangle not in sync with hardware
      media: ov6650: Fix stored frame interval not in sync with hardware

Jaroslaw Gawin (1):
      i40e: Wrong 'Advertised FEC modes' after set FEC to AUTO

Jason Gunthorpe (1):
      xen/gntdev: Use select for DMA_SHARED_BUFFER

Jernej Skrabec (2):
      media: vim2m: Fix abort issue
      media: cedrus: Use helpers to access capture queue

Jerry Snitselaar (3):
      tpm_tis: reserve chip for duration of tpm_tis_core_init
      iommu: set group default domain before creating direct mappings
      iommu/vt-d: Allocate reserved region for ISA with correct permission

Jia-Ju Bai (1):
      net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart=
_tty_receive()

Jian Shen (1):
      net: hns3: log and clear hardware error after reset complete

Jiangfeng Xiao (1):
      net: hisilicon: Fix a BUG trigered by wrong bytes_compl

Jim Mattson (2):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD
      kvm: x86: Host feature SSBD doesn't imply guest feature AMD_SSBD

Jin Yao (1):
      perf report: Add warning when libunwind not compiled in

Jing Zhou (1):
      drm/amd/display: verify stream link before link test

Jiri Benc (1):
      selftests, bpf: Fix test_tc_tunnel hanging

Joakim Zhang (2):
      can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode ackno=
wledgment
      can: flexcan: add low power enter/exit acknowledgment helper

Johannes Berg (1):
      iwlwifi: check kasprintf() return value

John Garry (3):
      perf vendor events arm64: Fix Hisi hip08 DDRC PMU eventname
      libata: Ensure ata_port probe has completed before detach
      perf tools: Fix cross compile for ARM64

John Hurley (1):
      nfp: flower: fix stats id allocation

Josef Bacik (6):
      btrfs: don't double lock the subvol_sem for rename exchange
      btrfs: do not call synchronize_srcu() in inode_tree_del
      btrfs: abort transaction after failed inode updates in create_subvol
      btrfs: skip log replay on orphaned roots
      btrfs: do not leak reloc root if we fail to read the fs root
      btrfs: handle ENOENT in btrfs_uuid_tree_iterate

Josip Pavic (1):
      drm/amd/display: wait for set pipe mcp command completion

Jouni Hogander (1):
      net-sysfs: Call dev_hold always in rx_queue_add_kobject

Julian Parkin (1):
      drm/amd/display: Program DWB watermarks from correct state

Kai Vehmanen (1):
      ASoC: SOF: enable sync_write in hdac_bus

Kai-Heng Feng (1):
      x86/intel: Disable HPET on Intel Coffee Lake H platforms

Kamal Heib (1):
      RDMA/core: Fix return code when modify_port isn't supported

Kangjie Lu (2):
      drm/gma500: fix memory disclosures due to uninitialized bytes
      media: rcar_drif: fix a memory disclosure

Kefeng Wang (1):
      media: vim2m: Fix BUG_ON in vim2m_device_release()

Kevin Wang (1):
      drm/amdgpu: fix amdgpu trace event print string format error

Konstantin Khlebnikov (1):
      x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()

Krzysztof Wilczynski (1):
      iio: light: bh1750: Resolve compiler warning and make code more reada=
ble

Kuninori Morimoto (1):
      ASoC: soc-pcm: fixup dpcm_prune_paths() loop continue

Laurent Pinchart (1):
      drm/panel: Add missing drm_panel_init() in panel drivers

Le Ma (1):
      drm/amd/powerplay: avoid disabling ECC if RAS is enabled for VEGA20

Leo Yan (4):
      perf test: Report failure for mmap events
      perf test: Avoid infinite loop for task exit case
      perf tests: Disable bp_signal testing for arm64
      perf cs-etm: Fix definition of macro TO_CS_QUEUE_NR

Lianbo Jiang (1):
      x86/crash: Add a forward declaration of struct kimage

Lingling Xu (1):
      spi: sprd: adi: Add missing lock protection when rebooting

Linus Walleij (1):
      firmware_loader: Fix labels with comma for builtin firmware

Loic Poulain (1):
      media: venus: core: Fix msm8996 frequency table

Lorenzo Bianconi (1):
      mt76: fix possible out-of-bound access in mt7615_fill_txs/mt7603_fill=
_txs

Lu Baolu (1):
      iommu/vt-d: Fix dmar pte read access not set error

Luca Coelho (1):
      iwlwifi: pcie: move power gating workaround earlier in the flow

Lucas Stach (1):
      nvmem: imx-ocotp: reset error status on probe

Luigi Rizzo (1):
      net-af_xdp: Use correct number of channels from ethtool

Luiz Augusto von Dentz (1):
      Bluetooth: Fix advertising duplicated flags

Lukasz Majewski (1):
      spi: Add call to spi_slave_abort() function when spidev driver is rel=
eased

Luke Starrett (1):
      RDMA/bnxt_re: Fix chip number validation Broadcom's Gen P5 series

Lyude Paul (1):
      drm/nouveau: Don't grab runtime PM refs for HPD IRQs

Manish Chopra (3):
      qede: Disable hardware gro when xdp prog is installed
      qede: Fix multicast mac configuration
      bnx2x: Fix PF-VF communication over multi-cos queues.

Manjunath Patil (1):
      ixgbe: protect TX timestamping from API misuse

Mao Wenan (3):
      af_packet: set defaule value for tmo
      net: dsa: LAN9303: select REGMAP when LAN9303 enable
      net: ethernet: ti: Add dependency for TI_DAVINCI_EMAC

Marc Zyngier (1):
      KVM: arm/arm64: Properly handle faulting of device mappings

Marcelo Ricardo Leitner (1):
      sctp: fix memleak on err handling of stream initialization

Marcus Comstedt (1):
      KVM: PPC: Book3S HV: Fix regression on big endian hosts

Martin Tsai (1):
      drm/amd/display: Handle virtual signal type in disable_link()

Masami Hiramatsu (16):
      perf probe: Fix to find range-only function instance
      perf probe: Fix to list probe event with correct line number
      perf probe: Walk function lines in lexical blocks
      perf probe: Fix to probe an inline function which has no entry pc
      perf probe: Fix to show ranges of variables in functions without entr=
y_pc
      perf probe: Fix to show inlined function callsite without entry_pc
      perf probe: Fix to probe a function which has no entry pc
      perf probe: Skip overlapped location on searching variables
      perf probe: Return a better scope DIE if there is no best scope
      perf probe: Fix to show calling lines of inlined functions
      perf probe: Skip end-of-sequence and non statement lines
      perf probe: Filter out instances except for inlined subroutine and su=
bprogram
      selftests: proc: Make va_max 1MB
      selftests: net: Fix printf format warnings on arm
      tracing/kprobe: Check whether the non-suffixed symbol is notrace
      perf probe: Fix to show function entry line as probe-able

Matthias Kaehlcke (1):
      drm/bridge: dw-hdmi: Refuse DDC/CI transfers on the internal I2C cont=
roller

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL

Max Gurtovoy (2):
      IB/iser: bound protection_sg size by data_sg size
      nvme: introduce "Command Aborted By host" status code

Miaoqing Pan (1):
      ath10k: fix get invalid tx rate for Mesh metric

Michael Chan (1):
      bnxt_en: Improve RX buffer error handling.

Michael Ellerman (1):
      crypto: vmx - Avoid weird build failures

Michael Walle (1):
      ASoC: wm8904: fix regcache handling

Michal Kalderon (2):
      RDMA/qedr: Fix memory leak in user qp and mr
      RDMA/qedr: Fix srqs xarray initialization

Michal Swiatkowski (1):
      ice: Check for null pointer dereference when setting rings

Mihail Atanassov (1):
      drm/komeda: Workaround for broken FLIP_COMPLETE timestamps

Mika Westerberg (1):
      xhci-pci: Allow host runtime PM as default also for Intel Ice Lake xH=
CI

Mike Christie (1):
      nbd: fix shutdown and recv work deadlock v2

Mike Isely (1):
      media: pvrusb2: Fix oops on tear-down when radio support is not prese=
nt

Mike Rapoport (1):
      mips: fix build when "48 bits virtual memory" is enabled

Mikita Lipski (1):
      drm/amd/display: Rebuild mapped resources after pipe split

Miquel Raynal (1):
      iio: adc: max1027: Reset the device at probe time

Mitch Williams (1):
      ice: delay less

Nathan Chancellor (1):
      tools/power/cpupower: Fix initializer override in hsw_ext_cstates

Navid Emamdoost (5):
      net: gemini: Fix memory leak in gmac_setup_txqs
      staging: rtl8192u: fix multiple memory leaks on error path
      rtlwifi: prevent memory leak in rtl_usb_probe
      spi: gpio: prevent memory leak in spi_gpio_probe
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

Neil Armstrong (2):
      drm/meson: vclk: use the correct G12A frac max value
      media: meson/ao-cec: move cec_notifier_cec_adap_register after hw set=
up

Nicholas Nunley (1):
      i40e: initialize ITRN registers with correct values

Nikola Cornij (1):
      drm/amd/display: Set number of pipes to 1 if the second pipe was disa=
bled

Oak Zeng (1):
      drm/amdkfd: Fix MQD size calculation

Oleksij Rempel (1):
      can: j1939: j1939_sk_bind(): take priv after lock is held

Omar Sandoval (4):
      btrfs: don't prematurely free work in end_workqueue_fn()
      btrfs: don't prematurely free work in run_ordered_work()
      btrfs: don't prematurely free work in reada_start_machine_worker()
      btrfs: don't prematurely free work in scrub_missing_raid56_worker()

Ondrej Jirman (1):
      cpufreq: sun50i: Fix CPU speed bin detection

Padmanabhan Rajanbabu (1):
      net: stmmac: platform: Fix MDIO init for platforms without PHY

Pan Bian (2):
      spi: img-spfi: fix potential double release
      drm/amdgpu: fix potential double drop fence reference

Pascal Paillet (1):
      regulator: core: Let boot-on regulators be powered off

Paul Burton (2):
      MIPS: futex: Emit Loongson3 sync workarounds within asm
      MIPS: futex: Restore \n after sync instructions

Paul Kocialkowski (1):
      media: cedrus: Fix undefined shift with a SHIFT_AND_MASK_BITS macro

Peng Fan (3):
      clk: imx: clk-imx7ulp: Add missing sentinel of ulp_div_table
      clk: imx: clk-composite-8m: add lock to gate/mux
      clk: imx: pll14xx: fix clk_pll14xx_wait_lock

Petar Penkov (1):
      tun: fix data-race in gro_normal_list()

Peter Zijlstra (1):
      ubsan, x86: Annotate and allow __ubsan_handle_shift_out_of_bounds() i=
n uaccess regions

Pi-Hsun Shih (1):
      media: v4l2-ctrl: Lock main_hdl on operations of requests_queued.

Pierre-Louis Bossart (2):
      ASoC: SOF: imx: fix reverse CONFIG_SND_SOC_SOF_OF dependency
      soundwire: intel: fix PDI/stream mapping for Bulk

Ping-Ke Shih (3):
      rtw88: fix NSS of hw_cap
      rtw88: coex: Set 4 slot mode for A2DP
      rtlwifi: fix memory leak in rtl92c_set_fw_rsvdpagepkt()

Quentin Monnet (1):
      tools, bpf: Fix build for 'make -s tools/bpf O=3D<dir>'

Rafael J. Wysocki (1):
      cpufreq: Avoid leaving stale IRQ work items during CPU offline

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: remove monitor interface when detaching

Rajendra Nayak (1):
      pinctrl: qcom: sc7180: Add missing tile info in SDC_QDSD_PINGROUP/UFS=
_RESET

Ranjani Sridharan (1):
      ASoC: SOF: topology: set trigger order for FE DAI link

Rasmus Villemoes (1):
      mmc: sdhci-of-esdhc: Revert "mmc: sdhci-of-esdhc: add erratum A-00920=
4 support"

Raul E Rangel (2):
      drm/amd/display: fix struct init in update_bounding_box
      drm/amd/powerplay: fix struct init in renoir_print_clk_levels

Ricardo Ribalda Delgado (1):
      media: ad5820: Define entity function

Robert Richter (1):
      EDAC/ghes: Fix grain calculation

Rodrigo Siqueira (1):
      drm/drm_vblank: Change EINVAL by the correct errno

Russell King (4):
      mod_devicetable: fix PHY module format
      net: phy: ensure that phy IDs are correctly typed
      net: phy: avoid matching all-ones clause 45 PHY IDs
      net: phy: initialise phydev speed and duplex sanely

Sakari Ailus (1):
      media: smiapp: Register sensor after enabling runtime PM on the device

Sam Bobroff (1):
      drm/amdgpu: fix bad DMA from INTERRUPT_CNTL2

Sami Tolvanen (2):
      syscalls/x86: Use the correct function type in SYSCALL_DEFINE0
      x86/mm: Use the correct function type for native_set_fixmap()

Sean Nyekjaer (2):
      can: m_can: tcan4x5x: add required delay after reset
      can: flexcan: fix possible deadlock and out-of-order reception after =
wakeup

Sean Paul (1):
      drm: mst: Fix query_payload ack reply struct

Sebastian Reichel (1):
      nvmem: core: fix nvmem_cell_write inline function

Sergey Matyukevich (3):
      qtnfmac: fix debugfs support for multiple cards
      qtnfmac: fix invalid channel information output
      qtnfmac: fix using skb after free

Sergio Paracuellos (1):
      MIPS: ralink: enable PCI support only if driver for mt7621 SoC is sel=
ected

Seung-Woo Kim (1):
      media: exynos4-is: fix wrong mdev and v4l2 dev order in error path

Sharat Masetty (1):
      drm: msm: a6xx: fix debug bus register configuration

Shengjiu Wang (1):
      ASoC: soc-pcm: check symmetry before hw_params

Shuah Khan (1):
      media: vimc: Fix gpf in rmmod path when stream is active

Song Liu (1):
      bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()

Srikar Dronamraju (1):
      powerpc/vcpu: Assume dedicated processors as non-preempt

Srinivas Kandagatla (1):
      misc: fastrpc: fix memory leak from miscdev->name

Srinivas Neeli (1):
      can: xilinx_can: Fix missing Rx can packets on CANFD2.0

Stanimir Varbanov (1):
      media: venus: Fix occasionally failures to suspend

Stefan Popa (1):
      iio: dac: ad5446: Add support for new AD5600 DAC

Stephan Gerhold (3):
      NFC: nxp-nci: Fix probing without ACPI
      extcon: sm5502: Reset registers during initialization
      phy: qcom-usb-hs: Fix extcon double register after power cycle

Steven Price (1):
      drm: Don't free jobs in wait_event_interruptible()

Sudip Mukherjee (1):
      parport: load lowlevel driver if ports not found

Suwan Kim (2):
      usbip: Fix receive error in vhci-hcd when using scatter-gather
      usbip: Fix error path of vhci_recv_ret_submit()

Sven Schnelle (1):
      s390/ftrace: fix endless recursion in function_graph tracer

Szymon Janc (1):
      Bluetooth: Workaround directed advertising bug in Broadcom controllers

Tadeusz Struk (1):
      tpm: fix invalid locking in NONBLOCKING mode

Takashi Iwai (6):
      ALSA: pcm: Avoid possible info leaks from PCM stream buffers
      ALSA: hda/ca0132 - Keep power on during processing DSP response
      ALSA: hda/ca0132 - Avoid endless loop
      ALSA: hda/ca0132 - Fix work handling in delayed HP detection
      ALSA: pcm: Fix missing check of the new non-cached buffer type
      ALSA: timer: Limit max amount of slave instances

Takashi Sakamoto (1):
      ALSA: bebob: expand sleep just after breaking connections for protoco=
l version 1

Tejun Heo (1):
      iocost: over-budget forced IOs should schedule async delay

Thadeu Lima de Souza Cascardo (1):
      selftests: net: tls: remove recv_rcvbuf test

Theodore Ts'o (1):
      ext4: validate the debug_want_extra_isize mount option at parse time

Thierry Reding (2):
      drm/tegra: sor: Use correct SOR index on Tegra210
      gpu: host1x: Allocate gather copy for host1x

Thomas Falcon (1):
      ibmvnic: Fix completion structure initialization

Thomas Gleixner (1):
      x86/ioapic: Prevent inconsistent state when moving an interrupt

Thomas Pedersen (1):
      mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

Thomas Richter (1):
      s390/cpumf: Adjust registration of s390 PMU device drivers

Thor Thayer (1):
      spi: dw: Fix Designware SPI loopback

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      libbpf: Fix error handling in bpf_map__reuse_fd()

Tony Lindgren (3):
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not i=
dled
      power: supply: cpcap-battery: Check voltage before orderly_poweroff
      ARM: dts: Fix vcsi regulator to be always-on for droid4 to prevent ha=
ngs

Ursula Braun (1):
      net/smc: increase device refcount for added link group

Valentin Schneider (1):
      sched/uclamp: Fix overzealous type replacement

Vandana BN (1):
      media: v4l2-core: fix touch support in v4l_g_fmt

Vasily Gorbik (1):
      s390/kasan: support memcpy_real with TRACE_IRQFLAGS

Vasundhara Volam (1):
      bnxt_en: Return proper error code for non-existent NVM variable

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Correct the offset and value for DDR_CONFIG register

Veeraiyan Chidambaram (1):
      usb: renesas_usbhs: add suspend event support in gadget mode

Viresh Kumar (1):
      cpufreq: Register drivers only after CPU devices have been registered

Vitaly Prosyak (1):
      drm/amd/display: add new active dongle to existent w/a

Vlad Buslov (1):
      net/mlx5e: Verify that rule has at least one fwd/drop action

Vladimir Oltean (1):
      net: dsa: sja1105: Disallow management xmit during switch reset

Wang Xuerui (1):
      iwlwifi: mvm: fix unaligned read of rx_pkt_status

Weihang Li (1):
      RDMA/hns: Fix wrong parameters when initial mtt of srq->idx_que

Wenwen Wang (1):
      ath10k: add cleanup in ath10k_sta_state()

Will Deacon (2):
      pinctrl: devicetree: Avoid taking direct reference to device name str=
ing
      KVM: arm64: Ensure 'params' is initialised when looking up sys regist=
er

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Xin Long (1):
      sctp: fully initialize v4 addr in some functions

Yang Shi (1):
      mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG

Yang Yingliang (1):
      media: flexcop-usb: fix NULL-ptr deref in flexcop_usb_transfer_init()

Yangbo Lu (1):
      mmc: sdhci-of-esdhc: fix P2020 errata handling

Yazen Ghannam (2):
      EDAC/amd64: Set grain per DIMM
      x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]

Yizhuo (1):
      regulator: max8907: Fix the usage of uninitialized variable in max890=
7_regulator_probe()

Yonghan Ye (1):
      serial: sprd: Add clearing break interrupt operation

Yonghong Song (3):
      bpf, testing: Workaround a verifier failure for test_progs
      selftests, bpf: Workaround an alu32 sub-register spilling issue
      bpf: Provide better register bounds after jmp32 instructions

Yu-Hsuan Hsu (1):
      ASoC: Intel: kbl_rt5663_rt5514_max98927: Add dmic format constraint

YueHaibing (2):
      media: max2175: Fix build error without CONFIG_REGMAP_I2C
      s390/crypto: Fix unsigned variable compared with zero

Yufen Yu (2):
      md: no longer compare spare disk superblock events in super_load
      md: avoid invalid memory access for array sb->dev_roles

Yuming Han (1):
      tracing: use kvcalloc for tgid_map array allocation

Yunfeng Ye (2):
      arm64: psci: Reduce the waiting time for cpu_psci_cpu_kill()
      perf jevents: Fix resource leak in process_mapfile() and main()

Yunsheng Lin (1):
      net: hns3: add struct netdev_queue debug info for TX timeout

Zhan liu (1):
      drm/amd/display: setting the DIG_MODE to the correct value.

chen gong (1):
      drm/amd/powerplay: A workaround to GPU RESET on APU

joseph gravenor (1):
      drm/amd/display: fix header for RN clk mgr


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4LhF4ACgkQONu9yGCS
aT66Mg//TO1RXnsSBP5J42tYh7gcJTpE5FAFo1IUBy8FiyqVmkpwJMo3xKYkfzF9
3tgHhnYmCFNYWE4PumpofvTgq4Jdv4ULeFJGJjDVHRKo75MhXS48RzbeWWQxZhB2
NxoJ/cVMcZpSWm5gixjcIMbhmy2AL3BsG77teWuOugvVWLXWFl7WUxL+0Hg6P+6f
DpD5xdk4K13oIx+aD1dIUot1AF74gvOw7Ebl6/MPzsjld8FbGFBLDCcSAMmvCeYO
Sx84r2VMtZteZgxu3Ft+BpXSAl30pQ2ImEXPJM8j9R4AeU6nDtfkIQSDg+EKhdqP
yHkuMqYNniAPiAvClbX6mgaOKLIPqOg74FH+xJ06MB7KpuTrydajf6oNhLgfPICh
E6430FXPRE6Hve9iP8sl9jNdxdKPGuYAc3sJERztaya2McHIvquluIY/m+0GoBZo
6mrebH1P5Lygu350n6X7nRX4+7vUdVr3axoT1/tKz+eSSh2pxLT1Dtxbhh8YU3Qd
coph9NwtYolHY51rMZ7k0uKOePauirfI5v2cp9nBmSZz8EqsBck6GTT0Fuzb7kUx
AMqCoqzxl2CPsw/Hm4YCs5Ve9tqgTzhUYoA7sPz01YVn5XSieu0gyMgAl3l95MiZ
TSydZg9SmASUOLC5roQKOm3ModUZMhtK/j184L195rl/+O/pFFU=
=hj95
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
