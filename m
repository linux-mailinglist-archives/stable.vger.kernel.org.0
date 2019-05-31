Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452D1311A0
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEaPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 11:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfEaPx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 11:53:58 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B125526961;
        Fri, 31 May 2019 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559318033;
        bh=pS/MLgrQy+Eu7SoizEWQm2MAm4JwtDbEWGQaSigi+OI=;
        h=Date:From:To:Cc:Subject:From;
        b=VuuI0Gn80b20xuQbXva/Dg4WWxPm/dTIM+tdKBXLFul8DC2UUpLkppKuNhu3UyCNB
         WWyXE7++ZuW3NIZq3UVfWkDQiiDEAC3xMggvp1hI5Jz+q0ke8dfWZhVyzgdwcbToM/
         pDYzS/0j22jak/MgvZr+bgirPIzJgN+1FK2z8YwI=
Date:   Fri, 31 May 2019 08:53:53 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.6
Message-ID: <20190531155353.GA12244@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.6 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.txt                             |    1=
=20
 Documentation/devicetree/bindings/phy/qcom-qmp-phy.txt             |    6=
=20
 Makefile                                                           |    2=
=20
 arch/arm/include/asm/cp15.h                                        |    2=
=20
 arch/arm/vdso/vgettimeofday.c                                      |    5=
=20
 arch/arm64/Kconfig                                                 |   19=
=20
 arch/arm64/include/asm/cpucaps.h                                   |    3=
=20
 arch/arm64/include/asm/futex.h                                     |    2=
=20
 arch/arm64/include/asm/pgtable.h                                   |    3=
=20
 arch/arm64/include/asm/vdso_datapage.h                             |    1=
=20
 arch/arm64/kernel/asm-offsets.c                                    |    2=
=20
 arch/arm64/kernel/cpu_errata.c                                     |   24=
=20
 arch/arm64/kernel/cpu_ops.c                                        |    1=
=20
 arch/arm64/kernel/kaslr.c                                          |    6=
=20
 arch/arm64/kernel/module.c                                         |    2=
=20
 arch/arm64/kernel/syscall.c                                        |   31 +
 arch/arm64/kernel/vdso.c                                           |    3=
=20
 arch/arm64/kernel/vdso/gettimeofday.S                              |    7=
=20
 arch/arm64/mm/dma-mapping.c                                        |   10=
=20
 arch/arm64/mm/fault.c                                              |   37 +
 arch/powerpc/boot/addnote.c                                        |    6=
=20
 arch/powerpc/kernel/head_64.S                                      |    4=
=20
 arch/powerpc/kernel/watchdog.c                                     |   81 =
+-
 arch/powerpc/mm/numa.c                                             |   18=
=20
 arch/powerpc/perf/imc-pmu.c                                        |    7=
=20
 arch/powerpc/platforms/powernv/opal-imc.c                          |    2=
=20
 arch/s390/kernel/kexec_elf.c                                       |    7=
=20
 arch/s390/mm/pgtable.c                                             |    2=
=20
 arch/sh/include/cpu-sh4/cpu/sh7786.h                               |    2=
=20
 arch/x86/Makefile                                                  |    2=
=20
 arch/x86/events/intel/cstate.c                                     |    2=
=20
 arch/x86/events/intel/rapl.c                                       |    2=
=20
 arch/x86/events/msr.c                                              |    1=
=20
 arch/x86/ia32/ia32_signal.c                                        |   29=
=20
 arch/x86/include/asm/text-patching.h                               |    4=
=20
 arch/x86/include/asm/uaccess.h                                     |    7=
=20
 arch/x86/kernel/alternative.c                                      |   28=
=20
 arch/x86/kernel/cpu/hygon.c                                        |    5=
=20
 arch/x86/kernel/cpu/mce/core.c                                     |   66 =
+-
 arch/x86/kernel/cpu/mce/inject.c                                   |   14=
=20
 arch/x86/kernel/cpu/microcode/core.c                               |    3=
=20
 arch/x86/kernel/ftrace.c                                           |    8=
=20
 arch/x86/kernel/irq_64.c                                           |   19=
=20
 arch/x86/kernel/module.c                                           |    2=
=20
 arch/x86/kernel/signal.c                                           |   29=
=20
 arch/x86/kernel/vmlinux.lds.S                                      |    6=
=20
 arch/x86/kvm/irq.c                                                 |    7=
=20
 arch/x86/kvm/irq.h                                                 |    1=
=20
 arch/x86/kvm/pmu_amd.c                                             |    2=
=20
 arch/x86/kvm/svm.c                                                 |    6=
=20
 arch/x86/kvm/vmx/nested.c                                          |    4=
=20
 arch/x86/kvm/x86.c                                                 |    2=
=20
 arch/x86/lib/memcpy_64.S                                           |    3=
=20
 arch/x86/mm/fault.c                                                |    2=
=20
 arch/x86/platform/uv/tlb_uv.c                                      |    7=
=20
 block/bio.c                                                        |    2=
=20
 block/blk-mq-sched.c                                               |   12=
=20
 block/blk-mq.c                                                     |  139 =
++--
 block/blk.h                                                        |    2=
=20
 block/genhd.c                                                      |   19=
=20
 block/partition-generic.c                                          |    7=
=20
 block/sed-opal.c                                                   |    9=
=20
 crypto/hmac.c                                                      |    2=
=20
 drivers/acpi/arm64/iort.c                                          |   19=
=20
 drivers/acpi/property.c                                            |    8=
=20
 drivers/base/power/main.c                                          |    4=
=20
 drivers/bluetooth/btbcm.c                                          |    4=
=20
 drivers/bluetooth/btmtkuart.c                                      |    2=
=20
 drivers/bluetooth/hci_qca.c                                        |    5=
=20
 drivers/char/hw_random/omap-rng.c                                  |    1=
=20
 drivers/char/random.c                                              |   57 +
 drivers/char/virtio_console.c                                      |    3=
=20
 drivers/clk/renesas/r8a774a1-cpg-mssr.c                            |    8=
=20
 drivers/clk/renesas/r8a774c0-cpg-mssr.c                            |    2=
=20
 drivers/clk/renesas/r8a7795-cpg-mssr.c                             |    8=
=20
 drivers/clk/renesas/r8a7796-cpg-mssr.c                             |    8=
=20
 drivers/clk/renesas/r8a77965-cpg-mssr.c                            |    8=
=20
 drivers/clk/renesas/r8a77990-cpg-mssr.c                            |    2=
=20
 drivers/clk/renesas/r8a77995-cpg-mssr.c                            |    2=
=20
 drivers/clk/rockchip/clk-rk3288.c                                  |   21=
=20
 drivers/clk/zynqmp/divider.c                                       |    9=
=20
 drivers/cpufreq/armada-8k-cpufreq.c                                |    1=
=20
 drivers/cpufreq/cpufreq.c                                          |    1=
=20
 drivers/cpufreq/cpufreq_governor.c                                 |    2=
=20
 drivers/cpufreq/imx6q-cpufreq.c                                    |    4=
=20
 drivers/cpufreq/kirkwood-cpufreq.c                                 |   19=
=20
 drivers/cpufreq/pasemi-cpufreq.c                                   |    1=
=20
 drivers/cpufreq/pmac32-cpufreq.c                                   |    2=
=20
 drivers/cpufreq/ppc_cbe_cpufreq.c                                  |    1=
=20
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c                            |    5=
=20
 drivers/crypto/vmx/aesp8-ppc.pl                                    |    2=
=20
 drivers/dax/super.c                                                |   88 =
+--
 drivers/devfreq/devfreq.c                                          |    4=
=20
 drivers/dma/at_xdmac.c                                             |    6=
=20
 drivers/dma/pl330.c                                                |   10=
=20
 drivers/dma/tegra210-adma.c                                        |   28=
=20
 drivers/extcon/Kconfig                                             |    2=
=20
 drivers/extcon/extcon-arizona.c                                    |   10=
=20
 drivers/gpu/drm/amd/amdgpu/Makefile                                |    2=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c                          |   24=
=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                  |   12=
=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                           |   15=
=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                      |   81 =
++
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                   |   51 -
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c                  |    6=
=20
 drivers/gpu/drm/amd/display/dc/dc_link.h                           |    2=
=20
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.c                       |    4=
=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c              |   20=
=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c          |   19=
=20
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c            |    2=
=20
 drivers/gpu/drm/arm/display/komeda/Makefile                        |    4=
=20
 drivers/gpu/drm/drm_atomic_state_helper.c                          |    4=
=20
 drivers/gpu/drm/drm_drv.c                                          |    5=
=20
 drivers/gpu/drm/drm_file.c                                         |    1=
=20
 drivers/gpu/drm/drm_writeback.c                                    |   14=
=20
 drivers/gpu/drm/etnaviv/etnaviv_drv.c                              |    5=
=20
 drivers/gpu/drm/etnaviv/etnaviv_drv.h                              |    1=
=20
 drivers/gpu/drm/i915/gvt/Makefile                                  |    2=
=20
 drivers/gpu/drm/msm/Makefile                                       |    6=
=20
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                              |   10=
=20
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c                        |   15=
=20
 drivers/gpu/drm/msm/msm_gem_vma.c                                  |    2=
=20
 drivers/gpu/drm/nouveau/Kbuild                                     |    8=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c                     |   12=
=20
 drivers/gpu/drm/omapdrm/dss/dsi.c                                  |   60 =
+-
 drivers/gpu/drm/omapdrm/omap_connector.c                           |   28=
=20
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c                   |    3=
=20
 drivers/gpu/drm/pl111/pl111_versatile.c                            |    4=
=20
 drivers/gpu/drm/rcar-du/rcar_lvds.c                                |   10=
=20
 drivers/gpu/drm/sun4i/sun4i_tcon.c                                 |    4=
=20
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                             |    8=
=20
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h                             |    2=
=20
 drivers/gpu/drm/tinydrm/ili9225.c                                  |    6=
=20
 drivers/gpu/drm/tinydrm/mipi-dbi.c                                 |   58 +
 drivers/gpu/drm/v3d/v3d_drv.c                                      |    8=
=20
 drivers/gpu/drm/v3d/v3d_drv.h                                      |    2=
=20
 drivers/gpu/drm/v3d/v3d_irq.c                                      |   13=
=20
 drivers/hid/hid-core.c                                             |   36 -
 drivers/hid/hid-logitech-hidpp.c                                   |   23=
=20
 drivers/hwmon/f71805f.c                                            |   15=
=20
 drivers/hwmon/pc87427.c                                            |   14=
=20
 drivers/hwmon/smsc47b397.c                                         |   13=
=20
 drivers/hwmon/smsc47m1.c                                           |   28=
=20
 drivers/hwmon/vt1211.c                                             |   15=
=20
 drivers/iio/adc/Kconfig                                            |    1=
=20
 drivers/iio/adc/ad_sigma_delta.c                                   |   16=
=20
 drivers/iio/adc/ti-ads7950.c                                       |   19=
=20
 drivers/iio/common/ssp_sensors/ssp_iio.c                           |    2=
=20
 drivers/iio/magnetometer/hmc5843_i2c.c                             |    7=
=20
 drivers/iio/magnetometer/hmc5843_spi.c                             |    7=
=20
 drivers/infiniband/core/cma.c                                      |   25=
=20
 drivers/infiniband/hw/cxgb4/cm.c                                   |    2=
=20
 drivers/infiniband/hw/hfi1/init.c                                  |    3=
=20
 drivers/infiniband/hw/hns/hns_roce_ah.c                            |    2=
=20
 drivers/infiniband/hw/mlx5/odp.c                                   |   11=
=20
 drivers/infiniband/sw/rxe/rxe_mr.c                                 |   11=
=20
 drivers/md/bcache/alloc.c                                          |    5=
=20
 drivers/md/bcache/journal.c                                        |   26=
=20
 drivers/md/bcache/super.c                                          |   25=
=20
 drivers/md/dm-table.c                                              |   17=
=20
 drivers/md/dm.c                                                    |   20=
=20
 drivers/md/dm.h                                                    |    1=
=20
 drivers/media/common/videobuf2/videobuf2-core.c                    |   22=
=20
 drivers/media/dvb-frontends/m88ds3103.c                            |    9=
=20
 drivers/media/dvb-frontends/si2165.c                               |    8=
=20
 drivers/media/i2c/ov2659.c                                         |    6=
=20
 drivers/media/i2c/ov6650.c                                         |   25=
=20
 drivers/media/i2c/ov7670.c                                         |    1=
=20
 drivers/media/pci/saa7146/hexium_gemini.c                          |    5=
=20
 drivers/media/pci/saa7146/hexium_orion.c                           |    5=
=20
 drivers/media/platform/coda/coda-bit.c                             |    3=
=20
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c                 |    8=
=20
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c                 |   10=
=20
 drivers/media/platform/stm32/stm32-dcmi.c                          |   20=
=20
 drivers/media/platform/vicodec/codec-fwht.c                        |   29=
=20
 drivers/media/platform/vicodec/vicodec-core.c                      |   24=
=20
 drivers/media/platform/video-mux.c                                 |    5=
=20
 drivers/media/platform/vim2m.c                                     |   35 -
 drivers/media/platform/vimc/vimc-core.c                            |    2=
=20
 drivers/media/platform/vimc/vimc-streamer.c                        |    2=
=20
 drivers/media/platform/vivid/vivid-vid-cap.c                       |    2=
=20
 drivers/media/radio/wl128x/fmdrv_common.c                          |    7=
=20
 drivers/media/rc/serial_ir.c                                       |    9=
=20
 drivers/media/usb/au0828/au0828-video.c                            |   16=
=20
 drivers/media/usb/cpia2/cpia2_v4l.c                                |    3=
=20
 drivers/media/usb/dvb-usb-v2/dvbsky.c                              |   18=
=20
 drivers/media/usb/go7007/go7007-fw.c                               |    4=
=20
 drivers/media/usb/gspca/gspca.c                                    |   12=
=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                            |    2=
=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                            |    1=
=20
 drivers/media/v4l2-core/v4l2-fwnode.c                              |    6=
=20
 drivers/misc/fastrpc.c                                             |   44 +
 drivers/misc/habanalabs/device.c                                   |   32 -
 drivers/misc/habanalabs/goya/goya.c                                |    6=
=20
 drivers/misc/habanalabs/memory.c                                   |   11=
=20
 drivers/mmc/core/pwrseq_emmc.c                                     |   38 -
 drivers/mmc/core/sd.c                                              |    8=
=20
 drivers/mmc/host/mmc_spi.c                                         |    4=
=20
 drivers/mmc/host/sdhci-iproc.c                                     |    6=
=20
 drivers/mmc/host/sdhci-of-esdhc.c                                  |    8=
=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c                       |   27=
=20
 drivers/net/ethernet/chelsio/cxgb3/l2t.h                           |    2=
=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                    |   15=
=20
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                   |    7=
=20
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h                    |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                    |   20=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c                 |    5=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c             |   11=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c              |    5=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c           |   13=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c          |   12=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c           |    7=
=20
 drivers/net/ethernet/intel/e1000e/netdev.c                         |    2=
=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |    8=
=20
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                 |   22=
=20
 drivers/net/ethernet/intel/ice/ice.h                               |    1=
=20
 drivers/net/ethernet/intel/ice/ice_lib.c                           |    4=
=20
 drivers/net/ethernet/intel/ice/ice_main.c                          |   25=
=20
 drivers/net/ethernet/intel/ice/ice_txrx.c                          |  292 =
+++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h                          |    6=
=20
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c                   |   20=
=20
 drivers/net/ethernet/intel/igb/igb_main.c                          |    3=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h                  |    3=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |   38 -
 drivers/net/ethernet/ti/cpsw.c                                     |   12=
=20
 drivers/net/ethernet/ti/cpsw_ale.c                                 |   19=
=20
 drivers/net/ethernet/ti/cpsw_ale.h                                 |    3=
=20
 drivers/net/hyperv/netvsc.c                                        |   15=
=20
 drivers/net/phy/phy_device.c                                       |   16=
=20
 drivers/net/usb/qmi_wwan.c                                         |   65 =
+-
 drivers/net/wireless/ath/wil6210/cfg80211.c                        |    5=
=20
 drivers/net/wireless/ath/wil6210/wmi.c                             |   11=
=20
 drivers/net/wireless/atmel/at76c50x-usb.c                          |    4=
=20
 drivers/net/wireless/broadcom/b43/phy_lp.c                         |    6=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c        |    4=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |   10=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c        |   42 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c             |   27=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c          |    5=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                       |    3=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                       |    7=
=20
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                    |    6=
=20
 drivers/net/wireless/marvell/mwifiex/cfp.c                         |    3=
=20
 drivers/net/wireless/mediatek/mt76/dma.c                           |    3=
=20
 drivers/net/wireless/mediatek/mt76/mt76.h                          |    4=
=20
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c                 |    6=
=20
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c                  |    4=
=20
 drivers/net/wireless/mediatek/mt76/tx.c                            |   10=
=20
 drivers/net/wireless/mediatek/mt76/usb.c                           |    3=
=20
 drivers/net/wireless/realtek/rtlwifi/base.c                        |    5=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c                |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c          |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c                |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c                |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c                |    2=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c                |    4=
=20
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                        |   30 -
 drivers/net/wireless/st/cw1200/main.c                              |    5=
=20
 drivers/nvdimm/pmem.c                                              |   11=
=20
 drivers/nvme/host/core.c                                           |    7=
=20
 drivers/nvme/host/rdma.c                                           |   10=
=20
 drivers/nvme/host/tcp.c                                            |    8=
=20
 drivers/perf/arm-cci.c                                             |   21=
=20
 drivers/phy/allwinner/phy-sun4i-usb.c                              |    4=
=20
 drivers/phy/motorola/Kconfig                                       |    2=
=20
 drivers/phy/ti/Kconfig                                             |    2=
=20
 drivers/pinctrl/pinctrl-pistachio.c                                |    2=
=20
 drivers/pinctrl/pinctrl-st.c                                       |   15=
=20
 drivers/pinctrl/samsung/pinctrl-exynos-arm.c                       |    1=
=20
 drivers/pinctrl/zte/pinctrl-zx.c                                   |    1=
=20
 drivers/regulator/core.c                                           |    4=
=20
 drivers/regulator/da9055-regulator.c                               |    2=
=20
 drivers/regulator/da9062-regulator.c                               |    2=
=20
 drivers/regulator/da9063-regulator.c                               |    5=
=20
 drivers/regulator/da9211-regulator.c                               |    4=
=20
 drivers/regulator/lp8755.c                                         |   15=
=20
 drivers/regulator/ltc3589.c                                        |   10=
=20
 drivers/regulator/ltc3676.c                                        |   10=
=20
 drivers/regulator/pv88060-regulator.c                              |    4=
=20
 drivers/regulator/pv88080-regulator.c                              |    4=
=20
 drivers/regulator/pv88090-regulator.c                              |    4=
=20
 drivers/regulator/wm831x-dcdc.c                                    |    4=
=20
 drivers/regulator/wm831x-isink.c                                   |    2=
=20
 drivers/regulator/wm831x-ldo.c                                     |    2=
=20
 drivers/rtc/rtc-88pm860x.c                                         |    2=
=20
 drivers/rtc/rtc-stm32.c                                            |    9=
=20
 drivers/rtc/rtc-xgene.c                                            |   18=
=20
 drivers/s390/block/dcssblk.c                                       |    1=
=20
 drivers/s390/cio/cio.h                                             |    2=
=20
 drivers/s390/cio/vfio_ccw_drv.c                                    |   32 -
 drivers/s390/cio/vfio_ccw_ops.c                                    |   11=
=20
 drivers/s390/crypto/zcrypt_api.c                                   |    4=
=20
 drivers/s390/net/qeth_core.h                                       |   10=
=20
 drivers/s390/net/qeth_core_main.c                                  |   14=
=20
 drivers/scsi/libsas/sas_expander.c                                 |    5=
=20
 drivers/scsi/lpfc/lpfc_ct.c                                        |   22=
=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                                   |   15=
=20
 drivers/scsi/lpfc/lpfc_init.c                                      |   11=
=20
 drivers/scsi/lpfc/lpfc_nvme.c                                      |    8=
=20
 drivers/scsi/lpfc/lpfc_scsi.c                                      |    2=
=20
 drivers/scsi/lpfc/lpfc_sli.c                                       |   14=
=20
 drivers/scsi/qedf/qedf_io.c                                        |    1=
=20
 drivers/scsi/qedi/qedi_iscsi.c                                     |    3=
=20
 drivers/scsi/qla2xxx/qla_isr.c                                     |    6=
=20
 drivers/scsi/qla2xxx/qla_target.c                                  |   25=
=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                                 |    7=
=20
 drivers/scsi/qla4xxx/ql4_os.c                                      |    2=
=20
 drivers/scsi/sd.c                                                  |    3=
=20
 drivers/scsi/ufs/ufs-hisi.c                                        |    4=
=20
 drivers/scsi/ufs/ufshcd.c                                          |   28=
=20
 drivers/slimbus/qcom-ngd-ctrl.c                                    |    4=
=20
 drivers/spi/atmel-quadspi.c                                        |    6=
=20
 drivers/spi/spi-imx.c                                              |    2=
=20
 drivers/spi/spi-pxa2xx.c                                           |    8=
=20
 drivers/spi/spi-rspi.c                                             |    9=
=20
 drivers/spi/spi-stm32-qspi.c                                       |   46 -
 drivers/spi/spi-tegra114.c                                         |   32 -
 drivers/spi/spi-topcliff-pch.c                                     |   15=
=20
 drivers/spi/spi.c                                                  |   43 -
 drivers/ssb/bridge_pcmcia_80211.c                                  |    9=
=20
 drivers/staging/media/davinci_vpfe/Kconfig                         |    2=
=20
 drivers/staging/media/imx/imx-media-vdic.c                         |    6=
=20
 drivers/staging/media/ipu3/ipu3.c                                  |    2=
=20
 drivers/staging/media/sunxi/cedrus/cedrus.h                        |    3=
=20
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c                     |    3=
=20
 drivers/staging/mt7621-mmc/sd.c                                    |   27=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    3=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c     |    2=
=20
 drivers/thunderbolt/icm.c                                          |    5=
=20
 drivers/thunderbolt/property.c                                     |   12=
=20
 drivers/thunderbolt/switch.c                                       |   67 =
+-
 drivers/thunderbolt/tb.h                                           |    3=
=20
 drivers/thunderbolt/xdomain.c                                      |    8=
=20
 drivers/tty/ipwireless/main.c                                      |    8=
=20
 drivers/usb/core/hcd.c                                             |    3=
=20
 drivers/usb/core/hub.c                                             |    5=
=20
 drivers/usb/dwc2/gadget.c                                          |   27=
=20
 drivers/usb/dwc3/core.c                                            |    2=
=20
 drivers/usb/dwc3/gadget.c                                          |    2=
=20
 drivers/usb/gadget/function/f_fs.c                                 |    3=
=20
 drivers/video/fbdev/core/fbcmap.c                                  |    2=
=20
 drivers/video/fbdev/core/modedb.c                                  |    3=
=20
 drivers/video/fbdev/efifb.c                                        |    3=
=20
 drivers/w1/w1_io.c                                                 |    3=
=20
 drivers/xen/biomerge.c                                             |    5=
=20
 fs/afs/xattr.c                                                     |   15=
=20
 fs/btrfs/compression.c                                             |    1=
=20
 fs/btrfs/extent-tree.c                                             |   28=
=20
 fs/btrfs/file.c                                                    |   19=
=20
 fs/btrfs/relocation.c                                              |   31 -
 fs/btrfs/root-tree.c                                               |   17=
=20
 fs/btrfs/sysfs.c                                                   |    7=
=20
 fs/btrfs/tree-log.c                                                |    1=
=20
 fs/char_dev.c                                                      |    6=
=20
 fs/crypto/crypto.c                                                 |    2=
=20
 fs/crypto/fname.c                                                  |    4=
=20
 fs/crypto/keyinfo.c                                                |    4=
=20
 fs/crypto/policy.c                                                 |    6=
=20
 fs/ext4/inode.c                                                    |   23=
=20
 fs/gfs2/glock.c                                                    |   23=
=20
 fs/gfs2/incore.h                                                   |    1=
=20
 fs/gfs2/lock_dlm.c                                                 |    9=
=20
 fs/gfs2/log.c                                                      |    3=
=20
 fs/gfs2/lops.c                                                     |    6=
=20
 fs/gfs2/super.c                                                    |    8=
=20
 fs/internal.h                                                      |    2=
=20
 fs/io_uring.c                                                      |    2=
=20
 fs/nfs/client.c                                                    |    7=
=20
 fs/nfs/nfs4file.c                                                  |    2=
=20
 fs/overlayfs/dir.c                                                 |    2=
=20
 fs/overlayfs/inode.c                                               |    3=
=20
 include/crypto/hash.h                                              |    8=
=20
 include/drm/tinydrm/mipi-dbi.h                                     |    5=
=20
 include/linux/bio.h                                                |    2=
=20
 include/linux/cgroup-defs.h                                        |    5=
=20
 include/linux/dax.h                                                |   26=
=20
 include/linux/filter.h                                             |    1=
=20
 include/linux/fscrypt.h                                            |    3=
=20
 include/linux/genhd.h                                              |    1=
=20
 include/linux/hid.h                                                |    1=
=20
 include/linux/iio/adc/ad_sigma_delta.h                             |    1=
=20
 include/linux/mlx5/eswitch.h                                       |    2=
=20
 include/linux/mount.h                                              |    2=
=20
 include/linux/overflow.h                                           |   12=
=20
 include/linux/rcupdate.h                                           |    6=
=20
 include/linux/regulator/consumer.h                                 |    5=
=20
 include/linux/smpboot.h                                            |    2=
=20
 include/linux/time64.h                                             |   21=
=20
 include/media/videobuf2-core.h                                     |    1=
=20
 include/net/bluetooth/hci.h                                        |    1=
=20
 include/xen/xen.h                                                  |    4=
=20
 kernel/acct.c                                                      |    4=
=20
 kernel/auditfilter.c                                               |   12=
=20
 kernel/auditsc.c                                                   |   10=
=20
 kernel/bpf/devmap.c                                                |    3=
=20
 kernel/cgroup/cgroup.c                                             |    6=
=20
 kernel/irq_work.c                                                  |   75 =
+-
 kernel/jump_label.c                                                |   21=
=20
 kernel/module.c                                                    |    5=
=20
 kernel/rcu/rcuperf.c                                               |    5=
=20
 kernel/rcu/rcutorture.c                                            |    5=
=20
 kernel/sched/core.c                                                |    9=
=20
 kernel/sched/fair.c                                                |   16=
=20
 kernel/sched/rt.c                                                  |    5=
=20
 kernel/time/time.c                                                 |    2=
=20
 kernel/time/timekeeping.c                                          |    6=
=20
 kernel/trace/trace_branch.c                                        |    4=
=20
 kernel/trace/trace_events_hist.c                                   |    6=
=20
 lib/kobject_uevent.c                                               |   11=
=20
 lib/sbitmap.c                                                      |    2=
=20
 lib/strncpy_from_user.c                                            |    5=
=20
 lib/strnlen_user.c                                                 |    4=
=20
 net/batman-adv/distributed-arp-table.c                             |    4=
=20
 net/batman-adv/main.c                                              |    1=
=20
 net/batman-adv/multicast.c                                         |   11=
=20
 net/batman-adv/types.h                                             |    5=
=20
 net/bluetooth/hci_core.c                                           |    5=
=20
 net/bluetooth/hci_event.c                                          |   12=
=20
 net/bluetooth/hci_request.c                                        |    5=
=20
 net/bluetooth/hci_request.h                                        |    1=
=20
 net/mac80211/mlme.c                                                |    3=
=20
 net/netfilter/nf_conntrack_netlink.c                               |    2=
=20
 net/wireless/nl80211.c                                             |    5=
=20
 samples/bpf/asm_goto_workaround.h                                  |    1=
=20
 security/selinux/netlabel.c                                        |   14=
=20
 sound/pci/hda/hda_codec.c                                          |    8=
=20
 sound/soc/codecs/hdmi-codec.c                                      |    6=
=20
 sound/soc/codecs/wcd9335.c                                         |    1=
=20
 sound/soc/fsl/Kconfig                                              |    9=
=20
 sound/soc/fsl/eukrea-tlv320.c                                      |    4=
=20
 sound/soc/fsl/fsl_sai.c                                            |    2=
=20
 sound/soc/fsl/fsl_utils.c                                          |    1=
=20
 sound/soc/intel/boards/kbl_da7219_max98357a.c                      |    2=
=20
 sound/soc/soc-core.c                                               |   11=
=20
 sound/soc/ti/Kconfig                                               |    4=
=20
 sound/soc/ti/davinci-mcasp.c                                       |    2=
=20
 tools/bpf/bpftool/.gitignore                                       |    2=
=20
 tools/lib/bpf/bpf.c                                                |    2=
=20
 tools/lib/bpf/bpf.h                                                |    1=
=20
 tools/lib/bpf/xsk.c                                                |   77 =
+-
 tools/testing/selftests/bpf/test_libbpf_open.c                     |    2=
=20
 tools/testing/selftests/bpf/trace_helpers.c                        |    4=
=20
 tools/testing/selftests/cgroup/test_memcontrol.c                   |   38 -
 virt/kvm/eventfd.c                                                 |    9=
=20
 444 files changed, 3432 insertions(+), 1513 deletions(-)

Abhi Das (1):
      gfs2: fix race between gfs2_freeze_func and unmount

Adam Ludkiewicz (1):
      i40e: Able to add up to 16 MAC filters on an untrusted VF

Aditya Pakki (5):
      rsi: Fix NULL pointer dereference in kmalloc
      thunderbolt: Fix to check the return value of kmemdup
      thunderbolt: Fix to check return value of ida_simple_get
      thunderbolt: Fix to check for kmemdup failure
      spi : spi-topcliff-pch: Fix to handle empty DMA buffers

Akeem G Abodunrin (1):
      ice: Fix issue with VF reset and multiple VFs support on PFs

Akinobu Mita (2):
      media: ov2659: make S_FMT succeed even if requested format doesn't ma=
tch
      media: ov7670: restore default settings after power-up

Al Viro (1):
      acct_on(): don't mess with freeze protection

Alan Stern (1):
      USB: core: Don't unbind interfaces following device reset failure

Alexander Potapenko (1):
      media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

Alexandre Belloni (1):
      rtc: xgene: fix possible race condition

Alexandre Courbot (2):
      media: mtk-vcodec: fix access to incorrect planes member
      media: mtk-vcodec: fix access to vb2_v4l2_buffer struct

Alexei Starovoitov (1):
      samples/bpf: fix build with new clang

Amir Goldstein (1):
      ovl: relax WARN_ON() for overlapping layers use case

Andrea Merello (1):
      mmc: core: make pwrseq_emmc (partially) support sleepy GPIO controlle=
rs

Andrea Parri (2):
      bio: fix improper use of smp_mb__before_atomic()
      sbitmap: fix improper use of smp_mb__before_atomic()

Andreas Gruenbacher (2):
      gfs2: Fix sign extension bug in gfs2_update_stats
      gfs2: Fix occasional glock use-after-free

Andrey Smirnov (1):
      spi: Don't call spi_get_gpio_descs() before device name is set

Anirudh Venkataramanan (1):
      ice: Fix for adaptive interrupt moderation

Anju T Sudhakar (2):
      powerpc/perf: Return accordingly on invalid chip-id in
      powerpc/perf: Fix loop exit condition in nest_imc_event_init

Anthony Koo (1):
      drm/amd/display: Fix exception from AUX acquire failure

Ard Biesheuvel (2):
      arm64/kernel: kaslr: reduce module randomization range to 2 GB
      efifb: Omit memory map check on legacy boot

Arnd Bergmann (20):
      ASoC: imx: fix fiq dependencies
      s390: qeth: address type mismatch warning
      bcache: avoid clang -Wunintialized warning
      phy: mapphone-mdm6600: add gpiolib dependency
      phy: ti: usb2: fix OMAP_CONTROL_PHY dependency
      s390: zcrypt: initialize variables before_use
      s390: cio: fix cio_irb declaration
      b43: shut up clang -Wuninitialized variable warning
      scsi: qla4xxx: avoid freeing unallocated dma memory
      scsi: lpfc: avoid uninitialized variable warning
      selinux: avoid uninitialized variable warning
      spi: export tracepoint symbols to modules
      regulator: add regulator_get_linear_step() stub helper
      media: staging/intel-ipu3: mark PM function as __maybe_unused
      media: staging: davinci_vpfe: disallow building with COMPILE_TEST
      media: vicodec: avoid clang frame size warning
      media: go7007: avoid clang frame overflow warning with KASAN
      media: saa7146: avoid high stack usage with clang
      ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM
      ASoC: ti: fix davinci_mcasp_probe dependencies

Artemy Kovalyov (1):
      IB/mlx5: Compare only index part of a memory window rkey

Balakrishna Godavarthi (1):
      Bluetooth: hci_qca: Give enough time to ROME controller to bootup.

Bard liao (1):
      ALSA: hda: fix unregister device twice on ASoC driver

Bart Van Assche (4):
      scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
      scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()
      scsi: qla2xxx: Avoid that lockdep complains about unsafe locking in t=
cm_qla2xxx_close_session()
      scsi: qla2xxx: Fix hardirq-unsafe locking

Benjamin Coddington (1):
      NFS: Fix a double unlock from nfs_match,get_client

Bj=F6rn T=F6pel (1):
      libbpf: fix invalid munmap call

Bo YU (1):
      powerpc/boot: Fix missing check of lseek() return value

Bodong Wang (1):
      net/mlx5: E-Switch, Use atomic rep state to serialize state change

Borislav Petkov (2):
      x86/kvm/pmu: Set AMD's virt PMU version to 1
      x86/microcode: Fix the ancient deprecated microcode loading method

Brett Creeley (1):
      ice: Put __ICE_PREPARED_FOR_RESET check in ice_prepare_for_reset

Chad Dupuis (1):
      scsi: qedf: Add missing return in qedf_post_io_req() in the fcport of=
fload check

Charles Keepax (2):
      extcon: arizona: Disable mic detect if running when driver is removed
      regulator: core: Avoid potential deadlock on regulator_unregister

Chengguang Xu (1):
      chardev: add additional check for minor range overlap

Chris Lesiak (1):
      spi: Fix zero length xfer bug

Chris Wilson (1):
      drm: Wake up next in drm_read() chain if we are forced to putback the=
 event

Christian K=F6nig (1):
      drm/amdgpu: fix old fence check in amdgpu_fence_emit

Christoph Hellwig (1):
      arm64/iommu: handle non-remapped addresses in ->mmap and ->get_sgtable

Claudiu Beznea (1):
      spi: atmel-quadspi: fix crash while suspending

Colin Ian King (1):
      RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Coly Li (2):
      bcache: return error immediately in bch_journal_replay()
      bcache: add failure check to run_cache_set() for journal replay

Corentin Labbe (1):
      crypto: sun4i-ss - Fix invalid calculation of hash end

Dafna Hirschfeld (1):
      media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if deco=
ding fails

Dan Carpenter (4):
      brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcm=
d_handler()
      mwifiex: prevent an array overflow
      media: pvrusb2: Prevent a buffer overflow
      media: wl128x: prevent two potential buffer overflows

Dan Williams (2):
      dax: Arrange for dax_supported check to span multiple devices
      libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead

Daniel Axtens (1):
      crypto: vmx - CTR: always increment IV as quadword

Daniel Baluta (1):
      ASoC: fsl_sai: Update is_slave_mode with correct value

Daniel T. Lee (2):
      libbpf: fix samples/bpf build failure due to undefined UINT32_MAX
      selftests/bpf: ksym_search won't check symbols exists

Dave Ertman (1):
      ice: Prevent unintended multiple chain resets

David Francis (2):
      drm/amd/display: Update ABM crtc state on non-modeset
      drm/amd/display: Re-add custom degamma support

David Howells (1):
      afs: Fix getting the afs.fid xattr

David Kozub (1):
      block: sed-opal: fix IOC_OPAL_ENABLE_DISABLE_MBR

David Sterba (1):
      Revert "btrfs: Honour FITRIM range constraints during free space trim"

Dmytro Laktyushkin (1):
      drm/amd/display: fix releasing planes when exiting odm

Douglas Anderson (3):
      clk: rockchip: undo several noc and special clocks as critical on rk3=
288
      clk: rockchip: Fix video codec clocks on rk3288
      clk: rockchip: Make rkpwm a critical clock on rk3288

Enric Balletbo i Serra (1):
      PM / devfreq: Fix static checker warning in try_then_request_governor

Eric Anholt (1):
      drm/v3d: Handle errors from IRQ setup.

Eric Biggers (2):
      crypto: hash - fix incorrect HASH_MAX_DESCSIZE
      fscrypt: use READ_ONCE() to access ->i_crypt_info

Eric Dumazet (1):
      bpf: devmap: fix use-after-free Read in __dev_map_entry_free

Evan Green (1):
      dt-bindings: phy-qcom-qmp: Add UFS PHY reset

Ezequiel Garcia (1):
      media: gspca: Kill URBs on USB device disconnect

Fabien Dessenne (2):
      media: stm32-dcmi: return appropriate error codes during probe
      rtc: stm32: manage the get_irq probe defer case

Fabrice Gasnier (1):
      iio: adc: stm32-dfsdm: fix unmet direct dependencies detected

Farhan Ali (3):
      vfio-ccw: Do not call flush_workqueue while holding the spinlock
      vfio-ccw: Release any channel program when releasing/removing vfio-cc=
w mdev
      vfio-ccw: Prevent quiesce function going into an infinite loop

Fei Yang (1):
      usb: gadget: f_fs: don't free buffer prematurely

Ferry Toth (1):
      Bluetooth: btbcm: Add default address for BCM43341B

Filipe Manana (3):
      Btrfs: do not abort transaction at btrfs_update_root() after failure =
to COW path
      Btrfs: avoid fallback to transaction commit during fsync of files wit=
h holes
      Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Flavio Suligoi (1):
      spi: pxa2xx: fix SCR (divisor) calculation

Geert Uytterhoeven (3):
      spi: Add missing error handling for CS GPIOs
      sh: sh7786: Add explicit I/O cast to sh7786_mm_sel()
      spi: rspi: Fix sequencer reset during initialization

George Hilliard (2):
      staging: mt7621-mmc: Initialize completions a single time during probe
      staging: mt7621-mmc: Check for nonzero number of scatterlist entries

Greg Kroah-Hartman (1):
      Linux 5.1.6

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix allmulti cfg in dual_mac mode

Guenter Roeck (5):
      hwmon: (vt1211) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
      hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
      hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
      hwmon: (f71805f) Use request_muxed_region for Super-IO accesses

Gustavo A. R. Silva (1):
      cxgb3/l2t: Fix undefined behaviour

Haiyang Zhang (1):
      hv_netvsc: fix race that may miss tx queue wakeup

Hans Verkuil (6):
      media: vb2: add waiting_in_dqbuf flag
      media: au0828: stop video streaming only when last user stops
      media: vicodec: reset last_src/dst_buf based on the IS_OUTPUT
      media: gspca: do not resubmit URBs when streaming has stopped
      media: vimc: zero the media_device on probe
      media: vim2m: replace devm_kzalloc by kzalloc

Hans de Goede (2):
      HID: logitech-hidpp: use RAP instead of FAP to get the protocol versi=
on
      HID: logitech-hidpp: change low battery level threshold from 31 to 30=
 percent

Heiner Kallweit (1):
      net: phy: improve genphy_soft_reset

Helen Fornazier (1):
      media: vimc: stream: fix thread state before sleep

Huazhong Tan (5):
      net: hns3: fix pause configure fail problem
      net: hns3: use atomic_t replace u32 for arq's count
      net: hns3: fix keep_alive_timer not stop problem
      net: hns3: add error handler for initializing command queue
      net: hns3: check resetting status in hns3_get_stats()

Hugues Fruchet (1):
      media: stm32-dcmi: fix crash when subdev do not expose any formats

Ioana Ciocoi Radulescu (1):
      dpaa2-eth: Fix Rx classification status

James Hutchinson (1):
      media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

James Smart (8):
      scsi: lpfc: Fix FDMI manufacturer attribute value
      scsi: lpfc: Fix fc4type information for FDMI
      scsi: lpfc: Fix io lost on host resets
      scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices
      scsi: lpfc: Fix mailbox hang on adapter init
      scsi: lpfc: Resolve inconsistent check of hdwq in lpfc_scsi_cmd_iocb_=
cmpl
      scsi: lpfc: Resolve irq-unsafe lockdep heirarchy warning in lpfc_io_f=
ree
      scsi: lpfc: Fix use-after-free mailbox cmd completion

Jan Kara (2):
      ext4: do not delete unlinked inode from orphan list on failed truncate
      ext4: wait for outstanding dio during truncate in nojournal mode

Janusz Krzysztofik (1):
      media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Jernej Skrabec (1):
      media: cedrus: Add a quirk for not setting DMA offset

Jerome Brunet (1):
      ASoC: hdmi-codec: unlock the device on startup errors

Jeykumar Sankaran (1):
      drm/msm/dpu: release resources on modeset failure

Jian Shen (1):
      net: hns3: add protect when handling mac addr list

Jiri Kosina (1):
      x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc=
_fault()

Jiufei Xue (1):
      fbdev: fix WARNING in __alloc_pages_nodemask bug

Johannes Berg (2):
      iwlwifi: pcie: don't crash on invalid RX interrupt
      iwlwifi: mvm: IBSS: use BE FIFO for multicast

John Garry (1):
      scsi: libsas: Do discovery on empty PHY to update PHY info

Johnny Chang (1):
      btrfs: Check the compression level before getting a workspace

Jon DeVree (1):
      random: fix CRNG initialization when random.trust_cpu=3D1

Jon Derrick (1):
      drm/nouveau/bar/nv50: ensure BAR is mapped

Josef Bacik (2):
      btrfs: don't double unlock on error in btrfs_punch_hole
      btrfs: fix panic during relocation after ENOSPC before writeback happ=
ens

Jo=E3o Paulo Rechi Vita (1):
      Bluetooth: Ignore CC events not matching the last HCI command

Julian Wiedmann (1):
      s390/qeth: handle error from qeth_update_from_chp_desc()

Justin Chen (1):
      iio: adc: ti-ads7950: Fix improper use of mlock

Kai-Heng Feng (2):
      e1000e: Disable runtime PM on CNP+
      igb: Exclude device from suspend direct complete optimization

Kan Liang (3):
      perf/x86/msr: Add Icelake support
      perf/x86/intel/rapl: Add Icelake support
      perf/x86/intel/cstate: Add Icelake support

Kangjie Lu (13):
      slimbus: fix a potential NULL pointer dereference in of_qcom_slim_ngd=
_register
      net: cw1200: fix a NULL pointer dereference
      mmc_spi: add a status check for spi_sync_locked
      iio: hmc5843: fix potential NULL pointer dereferences
      rtlwifi: fix a potential NULL pointer dereference
      brcmfmac: fix missing checks for kmemdup
      media: video-mux: fix null pointer dereferences
      thunderbolt: property: Fix a missing check of kzalloc
      tty: ipwireless: fix missing checks for ioremap
      x86/platform/uv: Fix missing checks of kcalloc() return values
      thunderbolt: property: Fix a NULL pointer dereference
      media: si2165: fix a missing check of return value
      scsi: ufs: fix a missing check of devm_reset_control_get

Kees Cook (2):
      x86/build: Move _etext to actual end of .text
      x86/build: Keep local relocations with ld.lld

Kefeng Wang (1):
      ACPI/IORT: Reject platform device creation on NUMA node mapping failu=
re

Konstantin Khlebnikov (3):
      sched/core: Check quota and period overflow at usec to nsec conversion
      sched/rt: Check integer overflow at usec to nsec conversion
      sched/core: Handle overflow in cpu_shares_write_u64

Kristian Evensen (2):
      netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression
      qmi_wwan: Add quirk for Quectel dynamic config

Lars-Peter Clausen (1):
      iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Laurent Pinchart (4):
      drm: rcar-du: lvds: Set LVEN and LVRES bits together on D3
      drm: rcar-du: lvds: Fix post-DLL divider calculation
      drm: writeback: Fix leak of writeback job
      drm/omap: Notify all devices in the pipeline of output disconnection

Leon Romanovsky (3):
      RDMA/hns: Fix bad endianess of port_pd variable
      overflow: Fix -Wtype-limits compilation warnings
      RDMA/rxe: Fix slab-out-bounds access which lead to kernel crash later

Li RongQing (1):
      audit: fix a memleak caused by auditing load module

Linus L=FCssing (2):
      batman-adv: mcast: fix multicast tt/tvlv worker locking
      batman-adv: allow updating DAT entry timeouts on incoming ARP Replies

Linus Walleij (1):
      regulator: core: Actually put the gpiod after use

Lior David (1):
      wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext

Lorenzo Bianconi (1):
      mt76: remove mt76_queue dependency from tx_queue_skb function pointer

Luca Weiss (1):
      drm/msm: Fix NULL pointer dereference

Ludovic Barre (1):
      spi: stm32-qspi: add spi_master_put in release function

Mac Chiang (1):
      ASoC: Intel: kbl_da7219_max98357a: Map BTN_0 to KEY_PLAYPAUSE

Manish Rangankar (1):
      scsi: qedi: Abort ep termination if offload not scheduled

Marc Zyngier (1):
      ARM: vdso: Remove dependency with the arch_timer driver internals

Marek Szyprowski (1):
      usb: dwc3: move synchronize_irq() out of the spinlock protected block

Mariusz Bialonczyk (1):
      w1: fix the resume command API

Martin K. Petersen (1):
      Revert "scsi: sd: Keep disk read-only when re-reading partition"

Martin Leung (1):
      drm/amd/display: half bandwidth for YCbCr420 during validation

Martyna Szapar (1):
      i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c

Masahiro Yamada (2):
      bpftool: exclude bash-completion/bpftool from .gitignore pattern
      drm: prefix header search paths with $(srctree)/

Matthias Kaehlcke (1):
      Bluetooth: hci_qca: Fix crash with non-serdev devices

Maxime Ripard (3):
      drm/sun4i: dsi: Change the start delay calculation
      drm/sun4i: dsi: Restrict DSI tcon clock divider
      drm/sun4i: dsi: Enforce boundaries on the start delay

Michael Tretter (1):
      clk: zynqmp: fix check for fractional clock

Mika Westerberg (1):
      thunderbolt: Take domain lock in switch sysfs attribute callbacks

Mike Marciniszyn (1):
      IB/hfi1: Fix WQ_MEM_RECLAIM warning

Minas Harutyunyan (1):
      usb: dwc2: gadget: Increase descriptors count for ISOC's

Ming Lei (4):
      blk-mq: split blk_mq_alloc_and_init_hctx into two parts
      blk-mq: grab .q_usage_counter when queuing request from plug code path
      block: avoid to break XEN by multi-page bvec
      block: pass page to xen_biovec_phys_mergeable

Murton Liu (1):
      drm/amd/display: Fix Divide by 0 in memory calculations

Nadav Amit (2):
      x86/ftrace: Set trampoline pages as executable
      x86/modules: Avoid breaking W^X while loading modules

Nathan Chancellor (1):
      iio: common: ssp_sensors: Initialize calculated_time in ssp_common_pr=
ocess_data

Nathan Lynch (1):
      powerpc/numa: improve control of topology updates

Neeraj Upadhyay (1):
      rcu: Do a single rhp->func read in rcu_head_after_call_rcu()

Nicholas Kazlauskas (5):
      drm/amd/display: Initialize stream_update with memset
      drm/amd/display: Prevent cursor hotspot overflow for RV overlay planes
      drm/amd/display: Reset alpha state for planes to the correct values
      drm/amd/display: Set stream->mode_changed when connectors change
      drm/amd/display: Reset planes that were disabled in init_pipes

Nicholas Mc Guire (1):
      staging: vc04_services: handle kzalloc failure

Nicholas Nunley (1):
      i40e: don't allow changes to HW VLAN stripping on active port VLANs

Nicholas Piggin (3):
      powerpc/watchdog: Use hrtimers for per-CPU heartbeat
      sched/nohz: Run NOHZ idle load balancer on HK_FLAG_MISC CPUs
      irq_work: Do not raise an IPI when queueing work on the local CPU

Nicolas Ferre (1):
      dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Nicolas Saenz Julienne (1):
      HID: core: move Usage Page concatenation to Main item

Noralf Tr=F8nnes (2):
      tinydrm/mipi-dbi: Use dma-safe buffers for all SPI transfers
      drm/drv: Hold ref on parent device during drm_device lifetime

Oded Gabbay (3):
      habanalabs: prevent device PTE read/write during hard-reset
      habanalabs: all FD must be closed before removing device
      habanalabs: prevent CPU soft lockup on Palladium

Pankaj Gupta (1):
      virtio_console: initialize vtermno value for ports

Paolo Bonzini (1):
      KVM: x86: fix return value for reserved EFER

Parav Pandit (1):
      RDMA/cma: Consider scope_id while binding to ipv6 ll address

Paul E. McKenney (2):
      rcutorture: Fix cleanup path for invalid torture_type strings
      rcuperf: Fix cleanup path for invalid perf_type strings

Paul Kocialkowski (1):
      phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode

Peng Li (1):
      net: hns3: free the pending skb when clean RX ring

Peter Xu (1):
      kvm: Check irqchip mode before assign irqfd

Peter Zijlstra (7):
      x86/uaccess: Dont leak the AC flag into __put_user() argument evaluat=
ion
      mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GC=
C versions
      locking/static_key: Fix false positive warnings on concurrent dec/inc
      x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP
      x86/uaccess, signal: Fix AC=3D1 bloat
      x86/ia32: Fix ia32_restore_sigcontext() AC leak
      x86/uaccess: Fix up the fixup

Philipp Rudo (1):
      s390/kexec_file: Fix detection of text segment in ELF loader

Philipp Zabel (1):
      media: coda: clear error return value before picture run

Pierre-Louis Bossart (1):
      ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()

Ping-Ke Shih (1):
      rtlwifi: fix potential NULL pointer dereference

Piotr Figiel (4):
      brcmfmac: convert dev_init_lock mutex to completion
      brcmfmac: fix WARNING during USB disconnect in case of unempty psq
      brcmfmac: fix race during disconnect when USB completion is in progre=
ss
      brcmfmac: fix Oops when bringing up interface during USB disconnect

Pu Wen (1):
      x86/CPU/hygon: Fix phys_proc_id calculation logic for multi-die proce=
ssors

Qian Cai (1):
      arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-va=
riable

Qu Wenruo (1):
      btrfs: Don't panic when we can't find a root key

Ranjani Sridharan (1):
      ASoC: core: remove link components before cleaning up card resources

Raul E Rangel (1):
      mmc: core: Verify SD bus width

Robbie Ko (1):
      Btrfs: fix data bytes_may_use underflow with fallocate due to failed =
quota reserve

Roberto Bergantinos Corpas (1):
      NFS: make nfs_match_client killable

Robin Murphy (1):
      perf/arm-cci: Remove broken race mitigation

Roman Gushchin (2):
      cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
      selftests: cgroup: fix cleanup path in test_memcg_subtree_control()

Ross Lagerwall (1):
      gfs2: Fix lru_count going negative

Rouven Czerwinski (1):
      hwrng: omap - Set default quality

Russell Currey (1):
      powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX

Russell King (1):
      drm: etnaviv: avoid DMA API warning when importing buffers

Saeed Mahameed (1):
      net/mlx5e: Fix compilation warning in en_tc.c

Sagi Grimberg (3):
      nvme: set 0 capacity if namespace block size exceeds PAGE_SIZE
      nvme-rdma: fix a NULL deref when an admin connect times out
      nvme-tcp: fix a NULL deref when an admin connect times out

Sakari Ailus (1):
      media: v4l2-fwnode: The first default data lane is 0 on C-PHY

Sameeh Jubran (2):
      net: ena: gcc 8: fix compilation warning
      net: ena: fix: set freed objects to NULL to avoid failing future allo=
cations

Sameer Pujar (2):
      dmaengine: tegra210-dma: free dma controller in remove()
      dmaengine: tegra210-adma: use devm_clk_*() helpers

Samson Tam (1):
      drm/amd/display: Link train only when link is DP and backend is enabl=
ed

Sean Paul (1):
      drm/msm: dpu: Don't set frame_busy_mask for async updates

Sean Wang (1):
      Bluetooth: mediatek: Fixed incorrect type in assignment

Sebastian Andrzej Siewior (2):
      smpboot: Place the __percpu annotation correctly
      random: add a spinlock_t to struct batched_entropy

Sergey Matyukevich (1):
      mac80211/cfg80211: update bss channel on channel switch

Shenghui Wang (2):
      io_uring: use cpu_online() to check p->sq_thread_cpu instead of cpu_p=
ossible()
      bcache: avoid potential memleak of list of journal_replay(s) in the C=
ACHE_SYNC branch of run_cache_set

Shile Zhang (1):
      fbdev: fix divide error in fb_var_to_videomode

Shuah Khan (1):
      media: au0828: Fix NULL pointer dereference in au0828_analog_stream_e=
nable()

Sowjanya Komatineni (1):
      spi: tegra114: reset controller on probe

Srinivas Kandagatla (2):
      misc: fastrpc: consider address offset before sending to DSP
      misc: fastrpc: make sure memory read and writes are visible

Stanley Chu (2):
      scsi: ufs: Fix regulator load and icc-level configuration
      scsi: ufs: Avoid configuring regulator with undefined voltage range

Stefan Br=FCns (1):
      media: dvbsky: Avoid leaking dvb frontend

Steve Longerbeam (1):
      media: imx: vdic: Restore default case to prepare_vdi_in_buffers()

Steve Twiss (13):
      regulator: wm831x ldo: Fix notifier mutex lock warning
      regulator: wm831x isink: Fix notifier mutex lock warning
      regulator: ltc3676: Fix notifier mutex lock warning
      regulator: ltc3589: Fix notifier mutex lock warning
      regulator: pv88060: Fix notifier mutex lock warning
      regulator: lp8755: Fix notifier mutex lock warning
      regulator: da9211: Fix notifier mutex lock warning
      regulator: da9063: Fix notifier mutex lock warning
      regulator: pv88080: Fix notifier mutex lock warning
      regulator: wm831x: Fix notifier mutex lock warning
      regulator: pv88090: Fix notifier mutex lock warning
      regulator: da9062: Fix notifier mutex lock warning
      regulator: da9055: Fix notifier mutex lock warning

Steven Rostedt (VMware) (1):
      x86: Hide the int3_emulate_call/jmp functions from UML

Sugar Zhang (1):
      dmaengine: pl330: _stop: clear interrupt status

Suthikulpanit, Suravee (1):
      kvm: svm/avic: fix off-by-one in checking host APIC ID

Sven Van Asbroeck (1):
      rtc: 88pm860x: prevent use-after-free on device remove

Takeshi Kihara (2):
      clk: renesas: rcar-gen3: Correct parent clock of SYS-DMAC
      clk: renesas: rcar-gen3: Correct parent clock of Audio-DMAC

Tang Junhui (1):
      bcache: fix failure in journal relplay

Tetsuo Handa (1):
      kobject: Don't trigger kobject_uevent(KOBJ_REMOVE) twice.

Thierry Escande (1):
      misc: fastrpc: Fix a possible double free

Thomas Gleixner (2):
      x86/irq/64: Limit IST stack overflow check to #DB stack
      timekeeping: Force upper bound for setting CLOCK_REALTIME

Thomas Huth (1):
      s390/mm: silence compiler warning when compiling without CONFIG_PGSTE

Tobin C. Harding (2):
      btrfs: sysfs: Fix error path kobject memory leak
      btrfs: sysfs: don't leak memory when failing add fsid

Tom Zanussi (1):
      tracing: Add a check_val() check before updating cond_snapshot() trac=
k_val

Tony Lindgren (2):
      usb: core: Add PM runtime calls to usb_hcd_platform_shutdown
      drm/omap: dsi: Fix PM for display blank with paired dss_pll calls

Tony Luck (1):
      x86/mce: Fix machine_check_poll() tests for error types

Tony Nguyen (2):
      ice: Separate if conditions for ice_set_features()
      ice: Preserve VLAN Rx stripping settings

Trac Hoang (2):
      mmc: sdhci-iproc: cygnus: Set NO_HISPD bit to fix HS50 data hold time=
 problem
      mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem

Trent Piepho (1):
      spi: imx: stop buffer overflow in RX FIFO flush

Ulf Hansson (1):
      PM / core: Propagate dev->power.wakeup_path when no callbacks

Vincenzo Frascino (1):
      arm64: vdso: Fix clock_getres() for CLOCK_REALTIME

Vineet Gupta (1):
      tools/bpf: fix perf build error with uClibc (seen on ARC)

Viresh Kumar (1):
      cpufreq: Fix kobject memleak

Wanpeng Li (1):
      KVM: nVMX: Fix using __this_cpu_read() in preemptible context

Wen Yang (16):
      pinctrl: zte: fix leaked of_node references
      pinctrl: pistachio: fix leaked of_node references
      pinctrl: st: fix leaked of_node references
      pinctrl: samsung: fix leaked of_node references
      drm/msm: a5xx: fix possible object reference leak
      cpufreq: ppc_cbe: fix possible object reference leak
      cpufreq/pasemi: fix possible object reference leak
      cpufreq: pmac32: fix possible object reference leak
      cpufreq: kirkwood: fix possible object reference leak
      cpufreq: imx6q: fix possible object reference leak
      cpufreq: ap806: fix possible object reference leak
      drm/pl111: fix possible object reference leak
      arm64: cpu_ops: fix a leaked reference by adding missing of_node_put
      ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node=
_put
      ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put
      ASoC: wcd9335: fix a leaked reference by adding missing of_node_put

Wenjing Liu (2):
      drm/amd/display: use proper formula to calculate bandwidth from timing
      drm/amd/display: add pipe lock during stream update

Wenwen Wang (1):
      audit: fix a memory leak bug

Will Deacon (3):
      arm64: Kconfig: Make ARM64_PSEUDO_NMI depend on BROKEN for now
      arm64: errata: Add workaround for Cortex-A76 erratum #1463225
      arm64: futex: Fix FUTEX_WAKE_OP atomic ops with non-zero result value

Xiaoli Feng (1):
      Fix nfs4.2 return -EINVAL when do dedupe operation

Yannick Fertr=E9 (1):
      drm/panel: otm8009a: Add delay at the end of initialization

Yazen Ghannam (1):
      x86/mce: Handle varying MCA bank counts

Yinbo Zhu (3):
      mmc: sdhci-of-esdhc: add erratum eSDHC5 support
      mmc: sdhci-of-esdhc: add erratum A-009204 support
      mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

Yonghong Song (1):
      selftests/bpf: set RLIMIT_MEMLOCK properly for test_libbpf_open.c

YueHaibing (7):
      media: cpia2: Fix use-after-free in cpia2_exit
      media: serial_ir: Fix use-after-free in serial_ir_init_module
      ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit
      at76c50x-usb: Don't register led_trigger if usb_register_driver failed
      cxgb4: Fix error path in cxgb4_init_module
      mwifiex: Fix mem leak in mwifiex_tm_cmd
      extcon: axp288: Add a depends on ACPI to the Kconfig entry

Yufen Yu (1):
      block: fix use-after-free on gendisk

Yunsheng Lin (1):
      net: hns3: fix for TX clean num when cleaning TX BD


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzxTg4ACgkQONu9yGCS
aT43WQ//fOyXOQfD7SpSvnDL4rxjx5UUtA2Av4uxSFmNpevTEWIDPBVQ6TGr6yoq
yl0TDPM486q9KwHH3Yp1HOWA6dZmvkUTQXzz34Zwf7MAqxzRvKJqbXEq51pyYUym
A6vCQeiHmzl8BGNBoIJulDoztQXVVROAopCppjNqQLmpmb2o58cEff4SWy9CO+cH
jUq+NaRTbLeh43J/0yWO9ivkasdiVC6B9szQjr2oN8G9kAp79eMIM9Fpq3O+eYh3
tXUbVWwzzTVLIVWiexY1fwhpL6HLwYMe4oDYyshY+Tla5vr9dnJK7TEOm5Q7wW1P
tV99C2bJINXOhLTCpBGWjbz1yyXITcpOO7b+UNr1MFLO5LZ9MfvdAB6A135Gof8S
24e9wwANcdNXvIStXk/Os6ThATEEudwtE+bTeE8cFBz7cJrhbhfepIcsr9HxuNmC
c/+Is+SJ+r/w3z4SlfYCiktnIL+wkTSkhEEkdYAflX2wfJTQ9qQaHhuXoJ7nd+Hp
MYpgzAiPNjdliApQgxJzIAhlGkkkTUJf4rDKFhapVB0TIOBDc3YsCSTRNaqc8hEW
8B5mKtNa6hfMJPvrBB1VpMPqC/Slm99xCDqZZSvyLnDN9fjCVLm3eDcCtIeYgtJr
zF3GFUBQvqRFgEF4Pc/m1CLWqY0my8eFMzOu7nJiicbUTPO3C3o=
=XDux
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
