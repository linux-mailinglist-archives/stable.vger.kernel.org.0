Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55945D70B
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 10:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351043AbhKYJYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 04:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348653AbhKYJWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 04:22:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 561E960234;
        Thu, 25 Nov 2021 09:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637831949;
        bh=vovfXsowRoI3IgDrJKtePq/qSuu+4d+h8T5ngxt2IUA=;
        h=From:To:Cc:Subject:Date:From;
        b=0ajdqNPJEZJzbLuwVtwLXo0L/f5GG1YHa2cpxyW6ovpPdd6iFJ4s39lshCizYhQ9p
         zq93Gz3pxQTtBt+HLR1M23eLJSUWw7qv/QQlbAjgz7YCaw2cW2vLe2B5U+zR12jB+3
         tv1zg3j8b0dg4DuXnsDhcAIAfVXbYPXYwuvjusew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.5
Date:   Thu, 25 Nov 2021 10:18:53 +0100
Message-Id: <163783193343224@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.5 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arc/kernel/process.c                                  |    2 
 arch/arm/Kconfig                                           |    1 
 arch/arm/boot/dts/bcm-nsp.dtsi                             |    4 
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts            |    2 
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts                 |   22 +
 arch/arm/boot/dts/bcm5301x.dtsi                            |   10 
 arch/arm/boot/dts/ls1021a-tsn.dts                          |    2 
 arch/arm/boot/dts/ls1021a.dtsi                             |   66 ++--
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi                  |    2 
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi          |    2 
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts                  |    6 
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts             |    8 
 arch/arm/boot/dts/sun8i-a33.dtsi                           |    4 
 arch/arm/boot/dts/sun8i-a83t.dtsi                          |    4 
 arch/arm/boot/dts/sun8i-h3.dtsi                            |    4 
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi             |    6 
 arch/arm64/boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi      |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi       |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi               |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi       |    2 
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi          |   12 
 arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts          |    1 
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi             |   16 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi             |   16 -
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts   |    4 
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi                  |    4 
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi                  |    2 
 arch/arm64/boot/dts/qcom/ipq6018.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/msm8996.dtsi                      |    2 
 arch/arm64/boot/dts/qcom/msm8998.dtsi                      |   22 -
 arch/arm64/boot/dts/qcom/qcs404.dtsi                       |    2 
 arch/arm64/boot/dts/qcom/sdm630.dtsi                       |    2 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                       |    2 
 arch/arm64/boot/dts/qcom/sm6125.dtsi                       |    2 
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts       |    4 
 arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts     |    4 
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                     |    4 
 arch/arm64/kvm/hyp/nvhe/setup.c                            |   14 
 arch/hexagon/include/asm/timer-regs.h                      |   26 -
 arch/hexagon/include/asm/timex.h                           |    3 
 arch/hexagon/kernel/time.c                                 |   12 
 arch/hexagon/lib/io.c                                      |    4 
 arch/m68k/kernel/traps.c                                   |    2 
 arch/mips/Kconfig                                          |    3 
 arch/mips/bcm63xx/clk.c                                    |    6 
 arch/mips/boot/compressed/Makefile                         |    6 
 arch/mips/generic/yamon-dt.c                               |    2 
 arch/mips/lantiq/clk.c                                     |    6 
 arch/mips/sni/time.c                                       |    4 
 arch/parisc/include/asm/rt_sigframe.h                      |    2 
 arch/parisc/kernel/signal.c                                |   13 
 arch/parisc/kernel/signal32.h                              |    2 
 arch/powerpc/boot/dts/charon.dts                           |    2 
 arch/powerpc/boot/dts/digsy_mtc.dts                        |    2 
 arch/powerpc/boot/dts/lite5200.dts                         |    2 
 arch/powerpc/boot/dts/lite5200b.dts                        |    2 
 arch/powerpc/boot/dts/media5200.dts                        |    2 
 arch/powerpc/boot/dts/mpc5200b.dtsi                        |    2 
 arch/powerpc/boot/dts/o2d.dts                              |    2 
 arch/powerpc/boot/dts/o2d.dtsi                             |    2 
 arch/powerpc/boot/dts/o2dnt2.dts                           |    2 
 arch/powerpc/boot/dts/o3dnt.dts                            |    2 
 arch/powerpc/boot/dts/pcm032.dts                           |    2 
 arch/powerpc/boot/dts/tqm5200.dts                          |    2 
 arch/powerpc/kernel/Makefile                               |    3 
 arch/powerpc/kernel/head_8xx.S                             |   13 
 arch/powerpc/kernel/signal.h                               |   10 
 arch/powerpc/kernel/signal_32.c                            |    6 
 arch/powerpc/kernel/signal_64.c                            |    9 
 arch/powerpc/kernel/watchdog.c                             |    6 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                    |    4 
 arch/powerpc/mm/numa.c                                     |   44 +--
 arch/powerpc/sysdev/dcr-low.S                              |    2 
 arch/powerpc/sysdev/xive/Kconfig                           |    1 
 arch/powerpc/sysdev/xive/common.c                          |    3 
 arch/riscv/Makefile                                        |    2 
 arch/s390/Kconfig                                          |    2 
 arch/s390/Makefile                                         |   10 
 arch/s390/boot/startup.c                                   |   88 ++----
 arch/s390/include/asm/kexec.h                              |    6 
 arch/s390/kernel/crash_dump.c                              |    4 
 arch/s390/kernel/ipl.c                                     |    3 
 arch/s390/kernel/machine_kexec_file.c                      |   18 +
 arch/s390/kernel/setup.c                                   |   10 
 arch/s390/kernel/traps.c                                   |    2 
 arch/s390/kernel/vdso64/Makefile                           |    5 
 arch/sh/Kconfig.debug                                      |    1 
 arch/sh/include/asm/sfp-machine.h                          |    8 
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                         |    5 
 arch/sh/math-emu/math.c                                    |  103 -------
 arch/sparc/kernel/signal_32.c                              |    4 
 arch/sparc/kernel/windows.c                                |    6 
 arch/um/kernel/trap.c                                      |    2 
 arch/x86/Kconfig                                           |    3 
 arch/x86/entry/vsyscall/vsyscall_64.c                      |    3 
 arch/x86/events/intel/core.c                               |    4 
 arch/x86/events/intel/uncore_snbep.c                       |   12 
 arch/x86/hyperv/hv_init.c                                  |    3 
 arch/x86/include/asm/kvm_host.h                            |    1 
 arch/x86/kernel/cpu/sgx/main.c                             |   12 
 arch/x86/kernel/setup.c                                    |   66 ++--
 arch/x86/kernel/vm86_32.c                                  |    4 
 arch/x86/kvm/hyperv.c                                      |    4 
 arch/x86/kvm/mmu/mmu.c                                     |    1 
 arch/x86/kvm/svm/sev.c                                     |    7 
 arch/x86/kvm/vmx/nested.c                                  |   22 +
 arch/x86/kvm/x86.c                                         |   10 
 arch/x86/kvm/x86.h                                         |   12 
 arch/x86/kvm/xen.c                                         |    4 
 block/blk-cgroup.c                                         |    9 
 block/blk-core.c                                           |    4 
 block/ioprio.c                                             |    9 
 drivers/ata/libata-core.c                                  |   11 
 drivers/base/firmware_loader/main.c                        |   13 
 drivers/bus/ti-sysc.c                                      |  110 +++++++
 drivers/clk/at91/sama7g5.c                                 |   11 
 drivers/clk/clk-ast2600.c                                  |   12 
 drivers/clk/imx/clk-imx6ul.c                               |    2 
 drivers/clk/ingenic/cgu.c                                  |    6 
 drivers/clk/qcom/gcc-msm8996.c                             |   15 -
 drivers/clk/sunxi-ng/ccu-sun4i-a10.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-a100-r.c                   |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c                     |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                      |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c                     |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c                     |    4 
 drivers/clk/sunxi-ng/ccu-sun5i.c                           |    2 
 drivers/clk/sunxi-ng/ccu-sun6i-a31.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-a33.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-a83t.c                      |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-de2.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                        |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-r.c                         |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-r40.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                       |    2 
 drivers/clk/sunxi-ng/ccu-sun9i-a80-de.c                    |    3 
 drivers/clk/sunxi-ng/ccu-sun9i-a80-usb.c                   |    3 
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c                       |    2 
 drivers/clk/sunxi-ng/ccu-suniv-f1c100s.c                   |    2 
 drivers/clk/sunxi-ng/ccu_common.c                          |   89 +++++-
 drivers/clk/sunxi-ng/ccu_common.h                          |    6 
 drivers/dma/xilinx/xilinx_dpdma.c                          |   15 -
 drivers/gpio/Kconfig                                       |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c             |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                 |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   35 ++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c      |    4 
 drivers/gpu/drm/amd/display/dc/dml/display_mode_enums.h    |    4 
 drivers/gpu/drm/amd/include/amd_shared.h                   |    3 
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                        |   10 
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h                    |    8 
 drivers/gpu/drm/drm_gem_cma_helper.c                       |    9 
 drivers/gpu/drm/drm_prime.c                                |    6 
 drivers/gpu/drm/i915/display/icl_dsi.c                     |   10 
 drivers/gpu/drm/i915/display/intel_bios.c                  |   85 ++++-
 drivers/gpu/drm/i915/display/intel_dp.c                    |   29 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c          |  154 ++++++----
 drivers/gpu/drm/nouveau/nouveau_drm.c                      |   42 ++
 drivers/gpu/drm/nouveau/nouveau_drv.h                      |    5 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c       |    1 
 drivers/gpu/drm/udl/udl_connector.c                        |    2 
 drivers/hid/hid-ids.h                                      |    3 
 drivers/hid/hid-multitouch.c                               |   13 
 drivers/hv/hv_balloon.c                                    |    2 
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c               |    6 
 drivers/infiniband/core/sysfs.c                            |    4 
 drivers/infiniband/core/verbs.c                            |    3 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                   |   12 
 drivers/infiniband/hw/mlx4/main.c                          |   18 +
 drivers/infiniband/sw/rxe/rxe_loc.h                        |    1 
 drivers/infiniband/sw/rxe/rxe_mr.c                         |   69 +++-
 drivers/infiniband/sw/rxe/rxe_mw.c                         |   30 --
 drivers/infiniband/sw/rxe/rxe_req.c                        |   14 
 drivers/infiniband/sw/rxe/rxe_verbs.h                      |   18 -
 drivers/iommu/apple-dart.c                                 |    5 
 drivers/iommu/intel/iommu.c                                |    6 
 drivers/memory/tegra/tegra20-emc.c                         |    1 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h       |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c               |    2 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c           |    4 
 drivers/net/ethernet/intel/e100.c                          |   18 -
 drivers/net/ethernet/intel/i40e/i40e.h                     |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c                |  160 +++++++----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c         |  121 ++------
 drivers/net/ethernet/intel/iavf/iavf.h                     |    1 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c             |   30 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c                |   55 ++-
 drivers/net/ethernet/intel/ice/ice.h                       |    5 
 drivers/net/ethernet/intel/ice/ice_main.c                  |    3 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c           |   78 ++---
 drivers/net/ethernet/marvell/mvmdio.c                      |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/cq.c               |    5 
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c         |   26 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h         |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h       |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   23 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            |   10 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    9 
 drivers/net/ethernet/mellanox/mlx5/core/lag.c              |   28 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c        |   24 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |   23 -
 drivers/net/ipa/ipa_endpoint.c                             |    5 
 drivers/net/ipa/ipa_resource.c                             |    2 
 drivers/net/tun.c                                          |    5 
 drivers/pinctrl/qcom/pinctrl-sdm845.c                      |    1 
 drivers/pinctrl/qcom/pinctrl-sm8350.c                      |    8 
 drivers/pinctrl/ralink/pinctrl-mt7620.c                    |    1 
 drivers/platform/x86/hp_accel.c                            |    2 
 drivers/platform/x86/think-lmi.c                           |   13 
 drivers/platform/x86/think-lmi.h                           |    1 
 drivers/ptp/ptp_ocp.c                                      |    9 
 drivers/scsi/advansys.c                                    |    4 
 drivers/scsi/lpfc/lpfc_crtn.h                              |    2 
 drivers/scsi/lpfc/lpfc_disc.h                              |   12 
 drivers/scsi/lpfc/lpfc_els.c                               |    7 
 drivers/scsi/lpfc/lpfc_hbadisc.c                           |  112 +++++++
 drivers/scsi/lpfc/lpfc_init.c                              |   12 
 drivers/scsi/lpfc/lpfc_scsi.c                              |   10 
 drivers/scsi/lpfc/lpfc_sli.c                               |   15 -
 drivers/scsi/pm8001/pm8001_init.c                          |   11 
 drivers/scsi/pm8001/pm8001_sas.h                           |    1 
 drivers/scsi/qla2xxx/qla_mbx.c                             |    6 
 drivers/scsi/scsi_debug.c                                  |   11 
 drivers/scsi/scsi_lib.c                                    |   25 +
 drivers/scsi/scsi_sysfs.c                                  |   30 +-
 drivers/scsi/smartpqi/smartpqi_init.c                      |   41 ++
 drivers/scsi/smartpqi/smartpqi_sis.c                       |   51 +++
 drivers/scsi/smartpqi/smartpqi_sis.h                       |    1 
 drivers/scsi/ufs/ufshcd.c                                  |    9 
 drivers/sh/maple/maple.c                                   |    5 
 drivers/spi/spi.c                                          |   12 
 drivers/staging/rtl8723bs/core/rtw_mlme.c                  |   12 
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c              |   11 
 drivers/staging/rtl8723bs/core/rtw_recv.c                  |   10 
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c               |   33 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c                  |   16 -
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c             |    2 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c             |    2 
 drivers/staging/wfx/bus_sdio.c                             |   17 -
 drivers/target/target_core_alua.c                          |    1 
 drivers/target/target_core_device.c                        |    2 
 drivers/target/target_core_internal.h                      |    1 
 drivers/target/target_core_transport.c                     |   76 +++--
 drivers/tty/tty_buffer.c                                   |    3 
 drivers/usb/host/max3421-hcd.c                             |   25 -
 drivers/usb/host/ohci-tmio.c                               |    2 
 drivers/usb/musb/tusb6010.c                                |    5 
 drivers/usb/typec/tipd/core.c                              |    2 
 drivers/video/console/sticon.c                             |   12 
 drivers/video/fbdev/efifb.c                                |   11 
 drivers/video/fbdev/simplefb.c                             |   11 
 fs/attr.c                                                  |    4 
 fs/btrfs/async-thread.c                                    |   14 
 fs/btrfs/scrub.c                                           |    4 
 fs/btrfs/volumes.c                                         |   21 -
 fs/exec.c                                                  |    2 
 fs/f2fs/f2fs.h                                             |    3 
 fs/f2fs/segment.c                                          |    2 
 fs/f2fs/super.c                                            |    4 
 fs/inode.c                                                 |    7 
 fs/nfsd/nfs4xdr.c                                          |    7 
 fs/pstore/Kconfig                                          |    1 
 fs/pstore/blk.c                                            |    2 
 fs/udf/dir.c                                               |   32 ++
 fs/udf/namei.c                                             |    3 
 fs/udf/super.c                                             |    2 
 include/linux/bpf.h                                        |    3 
 include/linux/dmaengine.h                                  |    2 
 include/linux/fs.h                                         |    2 
 include/linux/ipc_namespace.h                              |   15 +
 include/linux/mlx5/eswitch.h                               |    4 
 include/linux/platform_data/ti-sysc.h                      |    1 
 include/linux/printk.h                                     |    4 
 include/linux/sched/signal.h                               |    2 
 include/linux/sched/task.h                                 |    2 
 include/linux/skbuff.h                                     |   16 +
 include/linux/trace_events.h                               |    2 
 include/linux/virtio_net.h                                 |    7 
 include/net/nfc/nci_core.h                                 |    1 
 include/rdma/rdma_netlink.h                                |    2 
 include/sound/hdaudio_ext.h                                |    2 
 include/target/target_core_base.h                          |    6 
 include/trace/events/f2fs.h                                |   12 
 ipc/shm.c                                                  |  189 +++++++++----
 ipc/util.c                                                 |    6 
 kernel/bpf/cgroup.c                                        |    2 
 kernel/bpf/helpers.c                                       |    2 
 kernel/bpf/syscall.c                                       |   57 ++-
 kernel/bpf/verifier.c                                      |   27 +
 kernel/entry/syscall_user_dispatch.c                       |   12 
 kernel/printk/printk.c                                     |    5 
 kernel/sched/autogroup.c                                   |    2 
 kernel/sched/core.c                                        |   47 ++-
 kernel/sched/fair.c                                        |    4 
 kernel/sched/rt.c                                          |   12 
 kernel/sched/sched.h                                       |    3 
 kernel/signal.c                                            |   60 +++-
 kernel/trace/bpf_trace.c                                   |    2 
 kernel/trace/trace_events_hist.c                           |   14 
 lib/nmi_backtrace.c                                        |    6 
 mm/Kconfig                                                 |    3 
 mm/damon/dbgfs.c                                           |   15 -
 mm/highmem.c                                               |   32 +-
 mm/hugetlb.c                                               |   30 +-
 mm/slab.h                                                  |    2 
 net/core/filter.c                                          |    6 
 net/core/skbuff.c                                          |   14 
 net/core/sock.c                                            |    6 
 net/ipv4/bpf_tcp_ca.c                                      |    2 
 net/ipv4/tcp.c                                             |    3 
 net/ipv4/tcp_output.c                                      |    6 
 net/ipv4/udp.c                                             |   11 
 net/mac80211/cfg.c                                         |   12 
 net/mac80211/iface.c                                       |    4 
 net/mac80211/rx.c                                          |    2 
 net/mac80211/util.c                                        |    7 
 net/mac80211/wme.c                                         |    3 
 net/nfc/core.c                                             |   32 +-
 net/nfc/nci/core.c                                         |   30 +-
 net/sched/act_mirred.c                                     |   11 
 net/smc/smc_core.c                                         |    3 
 net/tipc/crypto.c                                          |    4 
 net/tipc/link.c                                            |    7 
 net/wireless/nl80211.c                                     |   34 +-
 net/wireless/nl80211.h                                     |    6 
 net/wireless/util.c                                        |    1 
 samples/bpf/xdp_redirect_cpu_user.c                        |    5 
 samples/bpf/xdp_sample_user.c                              |   28 +
 security/selinux/ss/hashtab.c                              |   17 -
 sound/core/Makefile                                        |    2 
 sound/hda/ext/hdac_ext_stream.c                            |   46 +--
 sound/hda/hdac_stream.c                                    |    4 
 sound/hda/intel-dsp-config.c                               |   22 +
 sound/isa/Kconfig                                          |    2 
 sound/isa/gus/gus_dma.c                                    |    2 
 sound/pci/Kconfig                                          |    1 
 sound/soc/codecs/es8316.c                                  |    7 
 sound/soc/codecs/nau8824.c                                 |   40 ++
 sound/soc/codecs/rt5651.c                                  |    7 
 sound/soc/codecs/rt5682.c                                  |   56 +++
 sound/soc/codecs/rt5682.h                                  |   20 +
 sound/soc/intel/boards/sof_sdw.c                           |   10 
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c          |   41 ++
 sound/soc/mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c    |    6 
 sound/soc/sh/rcar/dma.c                                    |    2 
 sound/soc/soc-dapm.c                                       |   29 +
 sound/soc/sof/intel/hda-dai.c                              |    7 
 sound/usb/clock.c                                          |    4 
 sound/usb/implicit.c                                       |    2 
 sound/usb/mixer_quirks.c                                   |   34 ++
 sound/usb/quirks-table.h                                   |   58 +++
 tools/build/feature/test-all.c                             |    1 
 tools/perf/bench/futex-lock-pi.c                           |    1 
 tools/perf/bench/futex-requeue.c                           |    1 
 tools/perf/bench/futex-wake-parallel.c                     |    1 
 tools/perf/bench/futex-wake.c                              |    1 
 tools/perf/tests/shell/record+zstd_comp_decomp.sh          |    2 
 tools/perf/util/bpf-event.c                                |    6 
 tools/perf/util/env.c                                      |    5 
 tools/perf/util/env.h                                      |    2 
 tools/testing/selftests/gpio/Makefile                      |    1 
 tools/testing/selftests/net/gre_gso.sh                     |   16 -
 372 files changed, 3118 insertions(+), 1563 deletions(-)

Adrian Hunter (2):
      scsi: ufs: core: Fix task management completion timeout race
      scsi: ufs: core: Fix another task management completion race

Ajish Koshy (1):
      scsi: pm80xx: Fix memory leak during rmmod

Akeem G Abodunrin (1):
      iavf: Restore VLAN filters after link down

Alex Elder (2):
      net: ipa: HOLB register sometimes must be written twice
      net: ipa: disable HOLB drop when updating timer

Alex Williamson (1):
      platform/x86: think-lmi: Abort probe on analyze failure

Alexander Antonov (3):
      perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server
      perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server
      perf/x86/intel/uncore: Fix IIO event constraints for Snowridge

Alexander Egorenkov (1):
      s390/dump: fix copying to user-space of swapped kdump oldmem

Alexander Lobakin (1):
      samples/bpf: Fix summary per-sec stats in xdp_sample_user

Alexander Mikhalitsyn (2):
      ipc: WARN if trying to remove ipc object which is absent
      shm: extend forced shm destroy to support objects from several IPC nses

Alexei Starovoitov (1):
      bpf: Fix inner map state pruning regression.

Alistair Delva (1):
      block: Check ADMIN before NICE for IOPRIO_CLASS_RT

Alvin Lee (1):
      drm/amd/display: Update swizzle mode enums

Amit Kumar Mahapatra (1):
      arm64: zynqmp: Do not duplicate flash partition label property

Anand K Mistry (1):
      drm/prime: Fix use after free in mmap with drm_gem_ttm_mmap

Anatolij Gustschin (1):
      powerpc/5200: dts: fix memory node unit name

Andreas Schwab (1):
      riscv: fix building external modules

AngeloGioacchino Del Regno (1):
      arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Ard Biesheuvel (1):
      kmap_local: don't assume kmap PTEs are linear arrays in memory

Arjun Roy (1):
      tcp: Fix uninitialized access in skb frags array for Rx 0cp.

Arnaldo Carvalho de Melo (1):
      tools build: Fix removal of feature-sync-compare-and-swap feature detection

Arnd Bergmann (1):
      dmaengine: remove debugfs #ifdef

Baoquan He (1):
      s390/kexec: fix memory leak of ipl report buffer

Bart Van Assche (2):
      MIPS: sni: Fix the build
      scsi: ufs: core: Improve SCSI abort handling

Bixuan Cui (1):
      ASoC: mediatek: mt8195: Add missing of_node_put()

Bjorn Andersson (2):
      pinctrl: qcom: sdm845: Enable dual edge errata
      pinctrl: qcom: sm8350: Correct UFS and SDC offsets

Bob Pearson (1):
      RDMA/rxe: Separate HW and SW l/rkeys

Boqun Feng (1):
      Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for dm_ring_size

Borislav Petkov (1):
      x86/boot: Pull up cmdline preparation and early param parsing

Brett Creeley (1):
      ice: Fix VF true promiscuous mode

Chao Yu (2):
      f2fs: fix wrong condition to trigger background checkpoint correctly
      f2fs: fix incorrect return value in f2fs_sanity_check_ckpt()

Chengfeng Ye (2):
      ALSA: gus: fix null pointer dereference on pointer block
      ALSA: usb-audio: fix null pointer dereference on pointer cs_desc

Christian Brauner (1):
      fs: handle circular mappings correctly

Christian Lamparter (1):
      ARM: BCM53016: Specify switch ports for Meraki MR32

Christophe JAILLET (1):
      platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Christophe Leroy (3):
      powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST
      powerpc/signal32: Fix sigset_t copy
      powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX

Chuck Lever (1):
      NFSD: Fix exposure in nfsd4_decode_bitmap()

Claudiu Beznea (1):
      clk: at91: sama7g5: remove prescaler part of master clock

Colin Ian King (2):
      MIPS: generic/yamon-dt: fix uninitialized variable error
      btrfs: make 1-bit bit-fields of scrub_page unsigned int

Cong Wang (1):
      udp: Validate checksum in udp_read_sock()

Cédric Le Goater (1):
      powerpc/xive: Change IRQ domain to a tree domain

Damien Le Moal (3):
      scsi: core: Fix scsi_mode_sense() buffer length handling
      ata: libata: improve ata_read_log_page() error message
      ata: libata: add missing ata_identify_page_supported() calls

Dan Carpenter (1):
      ptp: ocp: Fix a couple NULL vs IS_ERR() checks

Daniel Borkmann (1):
      bpf: Fix toctou on read-only map's constant scalar tracking

David Heidelberg (1):
      ARM: dts: qcom: fix memory and mdio nodes naming for RB3011

David Woodhouse (1):
      KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO

Derek Fang (1):
      ASoC: rt5682: fix a little pop while playback

Dmitrii Banshchikov (1):
      bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs

Dmitry Baryshkov (1):
      clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Dmitry Osipenko (1):
      memory: tegra20-emc: Add runtime dependency on devfreq governor module

Eric Dumazet (1):
      net: add and use skb_unclone_keeptruesize() helper

Eric W. Biederman (11):
      signal: Implement force_fatal_sig
      exit/syscall_user_dispatch: Send ordinary signals on failure
      signal/powerpc: On swapcontext failure force SIGSEGV
      signal/s390: Use force_sigsegv in default_trap_handler
      signal/sparc32: Exit with a fatal signal when try_to_clear_window_buffer fails
      signal/sparc32: In setup_rt_frame and setup_fram use force_fatal_sig
      signal/vm86_32: Properly send SIGSEGV when the vm86 state cannot be saved.
      signal/x86: In emulate_vsyscall force a signal instead of calling do_exit
      signal: Replace force_sigsegv(SIGSEGV) with force_fatal_sig(SIGSEGV)
      signal: Don't always set SA_IMMUTABLE for forced signals
      signal: Replace force_fatal_sig with force_exit_sig when in doubt

Eryk Rybak (3):
      i40e: Fix correct max_pkt_size on VF RX queue
      i40e: Fix changing previously set num_queue_pairs for PFs
      i40e: Fix ping is lost after configuring ADq on VF

Evan Quan (1):
      drm/amd/pm: avoid duplicate powergate/ungate setting

Ewan D. Milne (1):
      scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()

Fabio Aiuto (1):
      staging: rtl8723bs: remove possible deadlock when disconnect (v2)

Felix Fietkau (1):
      mac80211: drop check for DONT_REORDER in __ieee80211_select_queue

Frieder Schrempf (1):
      arm64: dts: imx8mm-kontron: Fix reset delays for ethernet PHY

Gao Xiang (1):
      f2fs: fix up f2fs_lookup tracepoints

Geert Uytterhoeven (1):
      pstore/blk: Use "%lu" to format unsigned long

Geraldo Nascimento (1):
      ALSA: usb-audio: disable implicit feedback sync for Behringer UFX1204 and UFX1604

Greg Kroah-Hartman (1):
      Linux 5.15.5

Grzegorz Szczurek (2):
      iavf: Fix for setting queues to 0
      i40e: Fix display error code in dmesg

Guanghui Feng (1):
      tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Guo Zhi (1):
      scsi: advansys: Fix kernel pointer leak

Hans Verkuil (1):
      drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame

Hans de Goede (5):
      staging: rtl8723bs: remove a second possible deadlock
      staging: rtl8723bs: remove a third possible deadlock
      ASoC: es8316: Use IRQF_NO_AUTOEN when requesting the IRQ
      ASoC: rt5651: Use IRQF_NO_AUTOEN when requesting the IRQ
      ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect

Heiko Carstens (1):
      s390/kexec: fix return code handling

Helge Deller (1):
      Revert "parisc: Reduce sigreturn trampoline to 3 instructions"

Hyeong-Jun Kim (1):
      f2fs: compress: disallow disabling compress on non-empty compressed file

Ian Rogers (1):
      perf bpf: Avoid memory leak from perf_env__insert_btf()

Imre Deak (2):
      drm/i915/dp: Ensure sink rate values are always valid
      drm/i915/dp: Ensure max link params are always valid

Jack Wang (1):
      RDMA/mlx4: Do not fail the registration on port stats

Jacob Keller (1):
      iavf: prevent accidental free of filter structure

Jakub Kicinski (1):
      selftests: net: switch to socat in the GSO GRE test

James Clark (1):
      perf tests: Remove bash construct from record+zstd_comp_decomp.sh

James Smart (4):
      scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
      scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
      scsi: lpfc: Fix link down processing to address NULL pointer dereference
      scsi: lpfc: Allow fabric node recovery if recovery is in progress before devloss

Jan Kara (1):
      udf: Fix crash after seekdir

Javier Martinez Canillas (1):
      fbdev: Prevent probing generic drivers if a FB is already registered

Jedrzej Jagielski (1):
      i40e: Fix creation of first queue by omitting it if is not power of two

Jeremy Cline (3):
      drm/nouveau: Add a dedicated mutex for the clients list
      drm/nouveau: use drm_dev_unplug() during device removal
      drm/nouveau: clean up all clients on device removal

Jesse Brandeburg (1):
      e100: fix device suspend/resume

Joel Stanley (1):
      clk/ast2600: Fix soc revision for AHB

Johan Hovold (1):
      drm/udl: fix control-message timeout

Johannes Berg (3):
      nl80211: fix radio statistics in survey dump
      mac80211: fix monitor_sdata RCU/locking assertions
      mac80211: fix radiotap header generation

Jonathan Davies (1):
      net: virtio_net_hdr_to_skb: count transport header in UFO

Josef Bacik (2):
      fs: export an inode_update_time helper
      btrfs: update device path inode time instead of bd_inode

José Expósito (1):
      HID: multitouch: disable sticky fingers for UPERFECT Y

Jérôme Pouiller (1):
      staging: wfx: ensure IRQ is ready before enabling it

Karen Sornek (1):
      i40e: Fix warning message and call stack during rmmod i40e driver

Kees Cook (1):
      Revert "mark pstore-blk as broken"

Keoseong Park (1):
      f2fs: fix to use WHINT_MODE

Konrad Dybcio (1):
      net/ipa: ipa_resource: Fix wrong for loop range

Kuldeep Singh (1):
      arm64: dts: ls1012a: Add serial alias for ls1012a-rdb

Kumar Kartikeya Dwivedi (1):
      samples/bpf: Fix incorrect use of strlen in xdp_redirect_cpu

Kuninori Morimoto (1):
      ASoC: rsnd: fixup DMAEngine API

Laibin Qiu (1):
      blkcg: Remove extra blkcg_bio_issue_init

Leon Romanovsky (3):
      RDMA/core: Set send and receive CQ before forwarding to the driver
      RDMA/netlink: Add __maybe_unused to static inline in C file
      ice: Delete always true check of PF pointer

Li Yang (2):
      ARM: dts: ls1021a: move thermal-zones node out of soc/
      ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Li Zhijian (1):
      selftests: gpio: fix gpio compiling error

Like Xu (1):
      perf/x86/vlbr: Add c->flags to vlbr event constraints

Lin Ma (3):
      NFC: reorganize the functions in nci_request
      NFC: reorder the logic in nfc_{un,}register_device
      NFC: add NCI_UNREG flag to eliminate the race

Linus Walleij (1):
      ARM: dts: ux500: Skomer regulator fixes

Lu Wei (1):
      maple: fix wrong return value of maple_bus_init().

Luis Chamberlain (1):
      firmware_loader: fix pre-allocated buf built-in firmware use

Maher Sanalla (1):
      net/mlx5: Lag, update tracker when state change event received

Mahesh Rajashekhara (1):
      scsi: smartpqi: Add controller handshake during kdump

Marcin Wojtas (1):
      net: mvmdio: fix compilation warning

Mark Bloch (1):
      net/mlx5: E-Switch, rebuild lag only when needed

Masahiro Yamada (1):
      powerpc: clean vdso32 and vdso64 directories

Masami Hiramatsu (1):
      tracing/histogram: Do not copy the fixed-size char array field over the field size

Mateusz Palczewski (1):
      iavf: Fix return of set the new channel count

Mathias Krause (1):
      sched/fair: Prevent dead task groups from regaining cfs_rq's

Matthew Brost (5):
      drm/i915/guc: Fix outstanding G2H accounting
      drm/i915/guc: Don't enable scheduling on a banned context, guc_id invalid, not registered
      drm/i915/guc: Workaround reset G2H is received after schedule done G2H
      drm/i915/guc: Don't drop ce->guc_active.lock when unwinding context
      drm/i915/guc: Unwind context requests in reverse order

Matthew Hagan (1):
      ARM: dts: NSP: Fix mpcore, mmc node names

Matthias Brugger (1):
      arm64: dts: rockchip: Disable CDN DP on Pinebook Pro

Maxim Levitsky (2):
      KVM: x86/mmu: include EFER.LMA in extended mmu role
      KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load

Maxime Ripard (3):
      ARM: dts: sunxi: Fix OPPs node name
      arm64: dts: allwinner: h5: Fix GPU thermal zone node name
      arm64: dts: allwinner: a100: Fix thermal zone node name

Meng Li (1):
      net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform

Michael Ellerman (2):
      powerpc/dcr: Use cmplwi instead of 3-argument cmpli
      KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()

Michael Walle (3):
      arm64: dts: hisilicon: fix arm,sp805 compatible string
      arm64: dts: freescale: fix arm,sp805 compatible string
      spi: fix use-after-free of the add_lock mutex

Michal Maloszewski (1):
      i40e: Fix NULL ptr dereference on VSI filter sync

Michal Simek (1):
      arm64: zynqmp: Fix serial compatible string

Mike Christie (3):
      scsi: target: Fix ordered tag handling
      scsi: target: Fix alua_tg_pt_gps_count tracking
      scsi: core: sysfs: Fix hang when device state is set via sysfs

Mina Almasry (1):
      hugetlb, userfaultfd: fix reservation restore on userfaultfd error

Mitch Williams (1):
      iavf: validate pointers

Nadav Amit (1):
      hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Nathan Chancellor (2):
      hexagon: export raw I/O routines for modules
      hexagon: clean up timer-regs.h

Neta Ostrovsky (1):
      net/mlx5: Update error handler for UCTX and UMEM

Nguyen Dinh Phi (1):
      cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Nicholas Nunley (3):
      iavf: check for null in iavf_fix_features
      iavf: free q_vectors before queues in iavf_disable_vf
      iavf: don't clear a lock we don't hold

Nicholas Piggin (3):
      powerpc/pseries: rename numa_dist_table to form2_distances
      powerpc/pseries: Fix numa FORM2 parsing fallback code
      printk: restore flushing of NMI buffers on remote CPUs after NMI backtraces

Nick Desaulniers (1):
      sh: check return code of request_irq

Nicolas Dichtel (1):
      tun: fix bonding active backup with arp monitoring

Nikolay Borisov (1):
      btrfs: fix memory ordering between normal and ordered work functions

Ondrej Mosnacek (1):
      selinux: fix NULL-pointer dereference when hashtab allocation fails

Paul Blakey (1):
      net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev

Paul Cercueil (1):
      clk: ingenic: Fix bugs with divided dividers

Pavel Skripkin (2):
      net: bnx2x: fix variable dereferenced before check
      net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Pierre-Louis Bossart (6):
      ASoC: SOF: Intel: hda-dai: fix potential locking issue
      ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec
      ASoC: Intel: soc-acpi: add missing quirk for TGL SDCA single amp
      ASoC: Intel: sof_sdw: add missing quirk for Dell SKU 0A45
      ALSA: hda: hdac_ext_stream: fix potential locking issues
      ALSA: hda: hdac_stream: fix potential locking issue in snd_hdac_stream_assign()

Piotr Marczak (1):
      iavf: Fix failure to exit out from last all-multicast mode

Quentin Perret (1):
      KVM: arm64: Fix host stage-2 finalization

Raed Salem (1):
      net/mlx5: E-Switch, return error if encap isn't supported

Rafał Miłecki (3):
      ARM: dts: BCM5301X: Fix nodes names
      ARM: dts: BCM5301X: Fix MDIO mux binding
      arm64: dts: broadcom: bcm4908: Move reboot syscon out of bus

Randy Dunlap (10):
      ALSA: ISA: not for M68K
      sh: fix kconfig unmet dependency warning for FRAME_POINTER
      sh: math-emu: drop unused functions
      sh: define __BIG_ENDIAN for math-emu
      mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set
      MIPS: boot/compressed/: add __bswapdi2() to target for ZSTD decompression
      mips: bcm63xx: add support for clk_get_parent()
      mips: lantiq: add support for clk_get_parent()
      gpio: rockchip: needs GENERIC_IRQ_CHIP to fix build errors
      x86/Kconfig: Fix an unused variable error in dell-smm-hwmon

Reinette Chatre (1):
      x86/sgx: Fix free page accounting

Roger Quadros (1):
      ARM: dts: omap: fix gpmc,mux-add-data type

Roi Dayan (1):
      net/mlx5e: CT, Fix multiple allocations and memleak of mod acts

Roman Li (1):
      drm/amd/display: Limit max DSC target bpp for specific monitors

Rustam Kovhaev (1):
      mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Samuel Holland (1):
      clk: sunxi-ng: Unregister clocks/resets when unbinding

Sean Christopherson (2):
      x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails
      KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs

Selvin Xavier (1):
      RDMA/bnxt_re: Check if the vlan is valid before reporting

SeongJae Park (2):
      mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation
      mm/damon/dbgfs: fix missed use of damon_dbgfs_lock

Sergio Paracuellos (1):
      pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'

Shawn Guo (3):
      arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property
      arm64: dts: qcom: ipq8074: Fix qcom,controlled-remotely property
      arm64: dts: qcom: sdm845: Fix qcom,controlled-remotely property

Sohaib Mohamed (1):
      perf bench futex: Fix memory leak of perf_cpu_map__new()

Sriharsha Basavapatna (1):
      bnxt_en: reject indirect blk offload when hw-tc-offload is off

Stefan Riedmueller (1):
      clk: imx: imx6ul: Move csi_sel mux to correct base register

Stephan Gerhold (1):
      arm64: dts: qcom: Fix node name of rpm-msg-ram device nodes

Steven Rostedt (VMware) (1):
      tracing: Add length protection to histogram string copies

Surabhi Boob (1):
      iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Sven Peter (2):
      usb: typec: tipd: Remove WARN_ON in tps6598x_block_read
      iommu/dart: Initialize DART_STREAMS_ENABLE

Sven Schnelle (2):
      s390/vdso: filter out -mstack-guard and -mstack-size
      parisc/sticon: fix reverse colors

Tadeusz Struk (1):
      tipc: check for null after calling kmemdup

Takashi Iwai (1):
      ASoC: DAPM: Cover regression by kctl change notification fix

Tariq Toukan (1):
      net/mlx5e: kTLS, Fix crash in RX resync flow

Teng Qi (1):
      iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Tetsuo Handa (1):
      sock: fix /proc/net/sockstat underflow in sk_clone_lock()

Thomas Gleixner (1):
      net: stmmac: Fix signed/unsigned wreckage

Thomas Zimmermann (1):
      drm/cma-helper: Release non-coherent memory with dma_free_noncoherent()

Tom Lendacky (1):
      KVM: x86: Assume a 64-bit hypercall for guests with protected state

Tony Lindgren (2):
      bus: ti-sysc: Add quirk handling for reinit on context lost
      bus: ti-sysc: Use context lost quirk for otg

Tvrtko Ursulin (1):
      iommu/vt-d: Do not falsely log intel_iommu is unsupported kernel option

Uwe Kleine-König (1):
      usb: max-3421: Use driver data instead of maintaining a list of bound devices

Valentine Fatiev (1):
      net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Vandita Kulkarni (1):
      Revert "drm/i915/tgl/dsi: Gate the ddi clocks after pll mapping"

Vasily Gorbik (2):
      s390/setup: avoid reserving memory above identity mapping
      s390/boot: simplify and fix kernel memory layout setup

Ville Syrjälä (1):
      drm/i915: Fix type1 DVI DP dual mode adapter heuristic for modern platforms

Vincent Donnefort (1):
      sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Vlad Buslov (1):
      net/mlx5e: Wait for concurrent flow deletion during neigh/fib events

Wen Gu (1):
      net/smc: Make sure the link_id is unique

William Overton (1):
      ALSA: usb-audio: Add support for the Pioneer DJM 750MK2 Mixer/Soundcard

Xin Long (2):
      tipc: only accept encrypted MSG_CRYPTO msgs
      net: sched: act_mirred: drop dst for the direction from egress to ingress

Yang Yingliang (2):
      usb: musb: tusb6010: check return value after calling platform_get_resource()
      usb: host: ohci-tmio: check return value after calling platform_get_resource()

Ye Bin (2):
      scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()
      scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()

Yu Kuai (1):
      blk-cgroup: fix missing put device in error path from blkg_conf_pref()

hongao (1):
      drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

wangyugui (1):
      RDMA/core: Use kvzalloc when allocating the struct ib_port

黄乐 (1):
      KVM: x86: Fix uninitialized eoi_exit_bitmap usage in vcpu_load_eoi_exitmap()

