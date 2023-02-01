Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F636860E0
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjBAHo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjBAHou (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE8A5D910;
        Tue, 31 Jan 2023 23:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 754CB6162F;
        Wed,  1 Feb 2023 07:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AFCC433D2;
        Wed,  1 Feb 2023 07:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675237436;
        bh=9AJrXHBGhAiMUXwfSoc/ge5ds7XLE9N1FTnyUdJAQ6E=;
        h=From:To:Cc:Subject:Date:From;
        b=rhNu4JEQlQer4uOsEgoMcXwy5p0bx4hro1ieScuSLBmkC1wn7wJy6St9gek5ARIQv
         zgzaYjdrdTUkBKOatavdVch8p0SZMuTdrOIgZz5Fahq/3dkQlDTkmdU3Ui8kYM4RPr
         hkAZtzsOYaToHQq3mskawKJkXN+sltLaHdfJcav0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.9
Date:   Wed,  1 Feb 2023 08:43:39 +0100
Message-Id: <167523741998254@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.9 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml         |    4 
 Documentation/devicetree/bindings/regulator/samsung,s2mps14.yaml |   21 
 Documentation/devicetree/bindings/riscv/cpus.yaml                |    2 
 Documentation/x86/amd-memory-encryption.rst                      |   36 +
 Makefile                                                         |   17 
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi                            |    1 
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts                          |    2 
 arch/arm/boot/dts/imx7d-pico-dwarf.dts                           |    4 
 arch/arm/boot/dts/imx7d-pico-nymph.dts                           |    4 
 arch/arm/boot/dts/sam9x60.dtsi                                   |    2 
 arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi                        |    8 
 arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi                 |    8 
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi                     |    8 
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi                     |    8 
 arch/arm/mach-imx/cpu-imx25.c                                    |    1 
 arch/arm/mach-imx/cpu-imx27.c                                    |    1 
 arch/arm/mach-imx/cpu-imx31.c                                    |    1 
 arch/arm/mach-imx/cpu-imx35.c                                    |    1 
 arch/arm/mach-imx/cpu-imx5.c                                     |    1 
 arch/arm/mm/nommu.c                                              |    2 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi       |    4 
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts           |    1 
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi          |    1 
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi             |    1 
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts                     |    4 
 arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi            |   10 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                        |    3 
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts                |    6 
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi                    |    2 
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts                |   77 +-
 arch/arm64/boot/dts/qcom/msm8992.dtsi                            |    4 
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi                           |    2 
 arch/arm64/include/asm/efi.h                                     |   17 
 arch/arm64/include/asm/stacktrace.h                              |   15 
 arch/arm64/kernel/efi-rt-wrapper.S                               |   38 -
 arch/arm64/kernel/efi.c                                          |   23 
 arch/arm64/kernel/stacktrace.c                                   |   12 
 arch/arm64/kvm/vgic/vgic-v3.c                                    |   25 
 arch/arm64/kvm/vgic/vgic-v4.c                                    |    8 
 arch/arm64/kvm/vgic/vgic.h                                       |    1 
 arch/arm64/mm/fault.c                                            |    4 
 arch/riscv/kernel/head.S                                         |    2 
 arch/riscv/kernel/probes/simulate-insn.c                         |    4 
 arch/riscv/kernel/smpboot.c                                      |    3 
 arch/s390/include/asm/debug.h                                    |    6 
 arch/s390/kernel/vmlinux.lds.S                                   |    2 
 arch/s390/kvm/interrupt.c                                        |   12 
 arch/x86/boot/compressed/ident_map_64.c                          |    6 
 arch/x86/boot/compressed/misc.h                                  |    2 
 arch/x86/boot/compressed/sev.c                                   |   70 ++
 arch/x86/events/amd/core.c                                       |    2 
 arch/x86/events/intel/cstate.c                                   |   21 
 arch/x86/events/intel/uncore.c                                   |    1 
 arch/x86/events/msr.c                                            |    3 
 arch/x86/include/asm/acpi.h                                      |    8 
 arch/x86/include/asm/msr-index.h                                 |   20 
 arch/x86/include/uapi/asm/svm.h                                  |    6 
 arch/x86/kernel/i8259.c                                          |    1 
 arch/x86/kernel/irqinit.c                                        |    4 
 arch/x86/kvm/vmx/vmx.c                                           |   21 
 drivers/acpi/resource.c                                          |    7 
 drivers/acpi/sleep.c                                             |    6 
 drivers/acpi/video_detect.c                                      |   49 -
 drivers/ata/Kconfig                                              |    1 
 drivers/base/property.c                                          |   18 
 drivers/base/test/test_async_driver_probe.c                      |    2 
 drivers/block/rnbd/rnbd-clt.c                                    |    2 
 drivers/block/ublk_drv.c                                         |    7 
 drivers/cpufreq/armada-37xx-cpufreq.c                            |    2 
 drivers/cpufreq/cppc_cpufreq.c                                   |   11 
 drivers/cpufreq/cpufreq-dt-platdev.c                             |    2 
 drivers/dma/dmaengine.c                                          |    7 
 drivers/dma/ptdma/ptdma-dev.c                                    |    7 
 drivers/dma/ptdma/ptdma.h                                        |    2 
 drivers/dma/qcom/gpi.c                                           |    1 
 drivers/dma/tegra186-gpc-dma.c                                   |    1 
 drivers/dma/ti/k3-udma.c                                         |    5 
 drivers/dma/xilinx/xilinx_dma.c                                  |    4 
 drivers/edac/edac_device.c                                       |   15 
 drivers/edac/highbank_mc_edac.c                                  |    7 
 drivers/edac/qcom_edac.c                                         |    5 
 drivers/firmware/arm_scmi/shmem.c                                |    9 
 drivers/firmware/arm_scmi/virtio.c                               |    7 
 drivers/firmware/efi/runtime-wrappers.c                          |    1 
 drivers/firmware/google/coreboot_table.c                         |    9 
 drivers/firmware/google/coreboot_table.h                         |    1 
 drivers/gpio/gpio-ep93xx.c                                       |    2 
 drivers/gpio/gpio-mxc.c                                          |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                          |   10 
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c                           |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c            |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                             |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                |   28 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c        |   51 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c      |    6 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                    |   14 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c             |    1 
 drivers/gpu/drm/display/drm_dp_mst_topology.c                    |    4 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                   |    6 
 drivers/gpu/drm/drm_vma_manager.c                                |   76 +-
 drivers/gpu/drm/i915/display/intel_dp.c                          |    4 
 drivers/gpu/drm/i915/display/intel_panel.c                       |    7 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                         |    2 
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c                  |    8 
 drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c         |    3 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                            |   15 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                            |    7 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h                            |    1 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                          |    4 
 drivers/gpu/drm/msm/msm_gpu.c                                    |    2 
 drivers/gpu/drm/msm/msm_gpu.h                                    |   12 
 drivers/gpu/drm/panfrost/Kconfig                                 |    3 
 drivers/gpu/drm/vc4/vc4_bo.c                                     |    6 
 drivers/hid/amd-sfh-hid/amd_sfh_client.c                         |    2 
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c                    |    2 
 drivers/hid/hid-betopff.c                                        |   17 
 drivers/hid/hid-bigbenff.c                                       |    5 
 drivers/hid/hid-core.c                                           |    4 
 drivers/hid/hid-ids.h                                            |    1 
 drivers/hid/hid-quirks.c                                         |    1 
 drivers/hid/intel-ish-hid/ishtp/dma-if.c                         |   10 
 drivers/i2c/busses/i2c-designware-common.c                       |    9 
 drivers/i2c/busses/i2c-designware-platdrv.c                      |   20 
 drivers/infiniband/core/verbs.c                                  |    7 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                        |  200 ++++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h                        |    3 
 drivers/infiniband/sw/rxe/rxe_param.h                            |   10 
 drivers/infiniband/sw/rxe/rxe_pool.c                             |   22 
 drivers/input/mouse/synaptics.c                                  |    1 
 drivers/input/serio/i8042-acpipnpio.h                            |    7 
 drivers/interconnect/qcom/msm8996.c                              |   19 
 drivers/memory/atmel-sdramc.c                                    |    6 
 drivers/memory/mvebu-devbus.c                                    |    3 
 drivers/memory/tegra/tegra186.c                                  |   36 -
 drivers/net/dsa/microchip/ksz9477.c                              |    4 
 drivers/net/dsa/microchip/ksz9477_i2c.c                          |    2 
 drivers/net/ethernet/adi/adin1110.c                              |    2 
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                         |   23 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                        |   24 
 drivers/net/ethernet/amd/xgbe/xgbe.h                             |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |   13 
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h                    |    9 
 drivers/net/ethernet/broadcom/tg3.c                              |    8 
 drivers/net/ethernet/cadence/macb_main.c                         |    9 
 drivers/net/ethernet/engleder/tsnep_main.c                       |   15 
 drivers/net/ethernet/freescale/enetc/enetc.c                     |    4 
 drivers/net/ethernet/freescale/fec_main.c                        |    2 
 drivers/net/ethernet/intel/iavf/iavf.h                           |    2 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c                   |   10 
 drivers/net/ethernet/intel/iavf/iavf_main.c                      |   86 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                  |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c           |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c                |   18 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                |    1 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                   |    8 
 drivers/net/ethernet/mellanox/mlx5/core/qos.c                    |    3 
 drivers/net/ethernet/mellanox/mlx5/core/qos.h                    |    2 
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c            |   13 
 drivers/net/ethernet/microsoft/mana/gdma.h                       |    3 
 drivers/net/ethernet/microsoft/mana/gdma_main.c                  |    9 
 drivers/net/ethernet/renesas/ravb_main.c                         |   10 
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                     |   14 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c             |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    5 
 drivers/net/ipa/ipa_interrupt.c                                  |   10 
 drivers/net/ipa/ipa_interrupt.h                                  |   16 
 drivers/net/ipa/ipa_power.c                                      |   17 
 drivers/net/mdio/mdio-mux-meson-g12a.c                           |   23 
 drivers/net/phy/mdio_bus.c                                       |    7 
 drivers/net/usb/cdc_ether.c                                      |    6 
 drivers/net/usb/r8152.c                                          |    1 
 drivers/net/usb/sr9700.c                                         |    2 
 drivers/net/virtio_net.c                                         |    6 
 drivers/net/wan/fsl_ucc_hdlc.c                                   |    6 
 drivers/net/wireless/rndis_wlan.c                                |   19 
 drivers/nvme/host/core.c                                         |   25 
 drivers/nvme/host/fc.c                                           |   20 
 drivers/nvme/host/nvme.h                                         |   11 
 drivers/nvme/host/pci.c                                          |   25 
 drivers/nvme/host/rdma.c                                         |    3 
 drivers/nvme/host/tcp.c                                          |    5 
 drivers/nvme/target/loop.c                                       |    4 
 drivers/perf/arm-cmn.c                                           |    7 
 drivers/phy/phy-can-transceiver.c                                |    5 
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c                    |    4 
 drivers/phy/sunplus/phy-sunplus-usb2.c                           |    3 
 drivers/phy/ti/Kconfig                                           |    4 
 drivers/pinctrl/pinctrl-rockchip.c                               |   31 
 drivers/platform/x86/apple-gmux.c                                |   93 --
 drivers/platform/x86/asus-nb-wmi.c                               |   15 
 drivers/platform/x86/asus-wmi.c                                  |   21 
 drivers/platform/x86/asus-wmi.h                                  |    1 
 drivers/platform/x86/simatic-ipc.c                               |    3 
 drivers/platform/x86/thinkpad_acpi.c                             |   11 
 drivers/platform/x86/touchscreen_dmi.c                           |   25 
 drivers/reset/Kconfig                                            |    2 
 drivers/reset/reset-uniphier-glue.c                              |    4 
 drivers/scsi/hisi_sas/hisi_sas_main.c                            |    4 
 drivers/scsi/hpsa.c                                              |    2 
 drivers/scsi/scsi_transport_iscsi.c                              |   50 +
 drivers/soc/imx/imx8mp-blk-ctrl.c                                |    7 
 drivers/soc/imx/soc-imx8m.c                                      |    4 
 drivers/soc/qcom/cpr.c                                           |    6 
 drivers/spi/spi-cadence-xspi.c                                   |    5 
 drivers/spi/spidev.c                                             |    2 
 drivers/thermal/gov_fair_share.c                                 |    6 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c     |   28 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h     |    1 
 drivers/thermal/thermal_core.c                                   |   25 
 drivers/thermal/thermal_sysfs.c                                  |   11 
 drivers/ufs/core/ufshcd.c                                        |   29 
 drivers/usb/dwc3/Kconfig                                         |    2 
 drivers/usb/gadget/function/f_fs.c                               |    7 
 drivers/usb/typec/ucsi/ucsi.c                                    |   24 
 drivers/usb/typec/ucsi/ucsi.h                                    |    1 
 drivers/vfio/vfio_iommu_type1.c                                  |   31 
 drivers/w1/w1.c                                                  |    6 
 drivers/w1/w1_int.c                                              |    5 
 drivers/xen/pvcalls-front.c                                      |    4 
 fs/affs/file.c                                                   |    2 
 fs/btrfs/ctree.h                                                 |    6 
 fs/btrfs/space-info.c                                            |    3 
 fs/btrfs/zoned.c                                                 |    2 
 fs/cifs/cifsencrypt.c                                            |    1 
 fs/cifs/dfs_cache.c                                              |   42 -
 fs/cifs/sess.c                                                   |    2 
 fs/cifs/smb2pdu.c                                                |    1 
 fs/cifs/smbdirect.c                                              |    1 
 fs/erofs/zdata.c                                                 |   12 
 fs/ksmbd/connection.c                                            |   17 
 fs/ksmbd/ksmbd_netlink.h                                         |    3 
 fs/ksmbd/ndr.c                                                   |    8 
 fs/ksmbd/server.h                                                |    1 
 fs/ksmbd/smb2pdu.c                                               |    2 
 fs/ksmbd/smb2pdu.h                                               |    5 
 fs/ksmbd/transport_ipc.c                                         |    3 
 fs/ksmbd/transport_tcp.c                                         |   17 
 fs/nfsd/filecache.c                                              |   61 +
 fs/nfsd/nfs4proc.c                                               |    1 
 fs/overlayfs/copy_up.c                                           |    6 
 include/drm/drm_vma_manager.h                                    |    1 
 include/linux/apple-gmux.h                                       |  109 +++
 include/linux/platform_data/x86/simatic-ipc.h                    |    3 
 include/linux/thermal.h                                          |    1 
 include/net/mac80211.h                                           |    4 
 include/net/sch_generic.h                                        |    7 
 include/scsi/scsi_transport_iscsi.h                              |    9 
 include/uapi/linux/netfilter/nf_conntrack_sctp.h                 |    2 
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h               |    2 
 include/ufs/ufshcd.h                                             |    2 
 io_uring/io_uring.c                                              |   68 --
 io_uring/io_uring.h                                              |   16 
 io_uring/msg_ring.c                                              |    4 
 io_uring/net.c                                                   |   11 
 io_uring/timeout.c                                               |   10 
 kernel/bpf/hashtab.c                                             |    4 
 kernel/bpf/verifier.c                                            |    4 
 kernel/kcsan/kcsan_test.c                                        |    7 
 kernel/module/main.c                                             |   26 
 kernel/sched/fair.c                                              |   48 -
 kernel/trace/ftrace.c                                            |   23 
 kernel/trace/trace.c                                             |    2 
 kernel/trace/trace.h                                             |    1 
 kernel/trace/trace_events_hist.c                                 |    2 
 kernel/trace/trace_osnoise.c                                     |    5 
 kernel/trace/trace_output.c                                      |    3 
 lib/lockref.c                                                    |    1 
 lib/nlattr.c                                                     |    3 
 mm/compaction.c                                                  |    1 
 net/bluetooth/hci_conn.c                                         |   18 
 net/bluetooth/hci_event.c                                        |    5 
 net/bluetooth/hci_sync.c                                         |   14 
 net/bluetooth/iso.c                                              |  110 +--
 net/bluetooth/mgmt_util.h                                        |    2 
 net/bluetooth/rfcomm/sock.c                                      |    7 
 net/core/net_namespace.c                                         |    2 
 net/ipv4/fib_semantics.c                                         |    2 
 net/ipv4/inet_hashtables.c                                       |   17 
 net/ipv4/inet_timewait_sock.c                                    |    8 
 net/ipv4/metrics.c                                               |    2 
 net/ipv4/tcp.c                                                   |    2 
 net/ipv6/ip6_output.c                                            |   15 
 net/l2tp/l2tp_core.c                                             |  102 +--
 net/mac80211/agg-tx.c                                            |    2 
 net/mac80211/debugfs_sta.c                                       |    5 
 net/mac80211/driver-ops.h                                        |    2 
 net/mac80211/ht.c                                                |   37 +
 net/mac80211/ieee80211_i.h                                       |    2 
 net/mac80211/tx.c                                                |   30 
 net/mac80211/util.c                                              |   20 
 net/mctp/af_mctp.c                                               |   10 
 net/mctp/route.c                                                 |   34 -
 net/netfilter/nf_conntrack_proto_sctp.c                          |  118 +--
 net/netfilter/nf_conntrack_proto_tcp.c                           |   15 
 net/netfilter/nf_conntrack_standalone.c                          |    8 
 net/netfilter/nft_set_rbtree.c                                   |  332 ++++++----
 net/netlink/af_netlink.c                                         |   38 -
 net/netrom/nr_timer.c                                            |    1 
 net/nfc/llcp_core.c                                              |    1 
 net/sched/sch_gred.c                                             |    2 
 net/sched/sch_htb.c                                              |   27 
 net/sched/sch_taprio.c                                           |    2 
 net/sctp/bind_addr.c                                             |    6 
 samples/ftrace/ftrace-direct-multi-modify.c                      |    1 
 samples/ftrace/ftrace-direct-multi.c                             |    1 
 scripts/tracing/ftrace-bisect.sh                                 |   34 -
 security/tomoyo/Makefile                                         |    2 
 sound/soc/amd/yc/acp6x-mach.c                                    |   14 
 sound/soc/fsl/fsl-asoc-card.c                                    |    8 
 sound/soc/fsl/fsl_micfil.c                                       |   16 
 sound/soc/fsl/fsl_ssi.c                                          |    4 
 sound/soc/mediatek/Kconfig                                       |    4 
 sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c         |   22 
 sound/soc/sof/debug.c                                            |    4 
 sound/soc/sof/pm.c                                               |    9 
 tools/gpio/gpio-event-mon.c                                      |    1 
 tools/include/nolibc/ctype.h                                     |    3 
 tools/include/nolibc/errno.h                                     |    3 
 tools/include/nolibc/signal.h                                    |    3 
 tools/include/nolibc/stdio.h                                     |    3 
 tools/include/nolibc/stdlib.h                                    |    3 
 tools/include/nolibc/string.h                                    |    8 
 tools/include/nolibc/sys.h                                       |    2 
 tools/include/nolibc/time.h                                      |    3 
 tools/include/nolibc/types.h                                     |   70 +-
 tools/include/nolibc/unistd.h                                    |    3 
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c      |    9 
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c      |   42 -
 tools/testing/selftests/net/toeplitz.c                           |   12 
 virt/kvm/vfio.c                                                  |    6 
 333 files changed, 2822 insertions(+), 1518 deletions(-)

Adam Ford (3):
      arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux
      arm64: dts: imx8mp: Fix missing GPC Interrupt
      arm64: dts: imx8mp: Fix power-domain typo

Ahmad Fatoum (1):
      net: dsa: microchip: fix probe of I2C-connected KSZ8563

Akhil P Oommen (1):
      drm/msm/a6xx: Avoid gx gbit halt during rpm suspend

Akhil R (1):
      dmaengine: tegra: Fix memory leak in terminate_all()

Alexander Gordeev (1):
      s390: expicitly align _edata and _end symbols on page boundary

Alexander Potapenko (1):
      affs: initialize fsdata in affs_truncate()

Alexander Wetzel (2):
      wifi: mac80211: Proper mark iTXQs for resumption
      wifi: mac80211: Fix iTXQ AMPDU fragmentation handling

Alexandru Tachici (1):
      net: ethernet: adi: adin1110: Fix multicast offloading

Alexey V. Vissarionov (1):
      scsi: hpsa: Fix allocation size for scsi_host_alloc()

Allen-KH Cheng (1):
      ASoC: mediatek: mt8186: Add machine support for max98357a

Andre Przywara (1):
      r8152: add vendor/device ID pair for Microsoft Devkit

Andrew Halaney (1):
      net: stmmac: enable all safety features by default

Aniol Martí (1):
      ASoC: amd: yc: Add ASUS M5402RA into DMI table

Archie Pusaka (1):
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Ard Biesheuvel (3):
      arm64: efi: Recover from synchronous exceptions occurring in firmware
      arm64: efi: Avoid workqueue to check whether EFI runtime is live
      arm64: efi: Account for the EFI runtime stack in stack unwinder

Arnd Bergmann (3):
      drm/panfrost: fix GENERIC_ATOMIC64 dependency
      usb: dwc3: fix extcon dependency
      drm/i915/selftest: fix intel_selftest_modify_policy argument types

Ashish Mhetre (1):
      memory: tegra: Remove clients SID override programming

Bartosz Golaszewski (1):
      spi: spidev: remove debug messages that access spidev->spi without locking

Basavaraj Natikar (1):
      HID: amd_sfh: Fix warning unwind goto

Caleb Connolly (1):
      net: ipa: disable ipa interrupt during suspend

Chancel Liu (1):
      ASoC: fsl_micfil: Correct the number of steps on SX controls

Chen Zhongjin (1):
      driver core: Fix test_async_probe_init saves device in wrong array

Chris Mi (2):
      net/mlx5e: Set decap action based on attr for sample
      net/mlx5: E-switch, Fix switchdev mode after devlink reload

Chris Packham (1):
      arm64: dts: marvell: AC5/AC5X: Fix address for UART1

Chris Wilson (1):
      drm/i915/selftests: Unwind hugepages to drop wakeref on error

Christoph Hellwig (2):
      nvme: simplify transport specific device attribute handling
      nvme: consolidate setting the tagset flags

Christophe JAILLET (1):
      PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()

Chuang Wang (1):
      tracing/osnoise: Use built-in RCU list checking

Claudiu Beznea (1):
      ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60

Clément Léger (1):
      net: lan966x: add missing fwnode_handle_put() for ports node

Colin Ian King (1):
      perf/x86/amd: fix potential integer overflow on shift of a int

Cong Wang (2):
      l2tp: convert l2tp_tunnel_list to idr
      l2tp: close all race conditions in l2tp_tunnel_register()

Conor Dooley (2):
      dt-bindings: riscv: fix underscore requirement for multi-letter extensions
      dt-bindings: riscv: fix single letter canonical order

Cristian Marussi (3):
      firmware: arm_scmi: Harden shared memory access in fetch_response
      firmware: arm_scmi: Harden shared memory access in fetch_notification
      firmware: arm_scmi: Fix virtio channels cleanup on shutdown

Curtis Malainey (1):
      ASoC: SOF: Add FW state to debugfs

Daisuke Matsuda (2):
      RDMA/rxe: Fix inaccurate constants in rxe_type_info
      RDMA/rxe: Prevent faulty rkey generation

Dan Carpenter (2):
      thermal/core: fix error code in __thermal_cooling_device_register()
      gpio: mxc: Unlock on error path in mxc_flip_edge()

Dario Binacchi (1):
      ARM: imx: add missing of_node_put()

Dave Airlie (1):
      amdgpu: fix build on non-DCN platforms.

David Christensen (1):
      net/tg3: resolve deadlock in tg3_reset_task() during EEH

David Howells (1):
      cifs: Fix oops due to uncleared server->smbd_conn in reconnect

David Morley (1):
      tcp: fix rate_app_limited to default to 1

Dean Luick (5):
      IB/hfi1: Reject a zero-length user expected buffer
      IB/hfi1: Reserve user expected TIDs
      IB/hfi1: Fix expected receive setup error exit issues
      IB/hfi1: Immediately remove invalid memory from hardware
      IB/hfi1: Remove user expected buffer invalidate race

Dmitry Torokhov (1):
      Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Dylan Yudaken (1):
      io_uring: always prep_async for drain requests

Emanuele Ghidoli (2):
      arm64: dts: verdin-imx8mm: fix dahlia audio playback
      arm64: dts: verdin-imx8mm: fix dev board audio playback

Eric Dumazet (9):
      net/sched: sch_taprio: fix possible use-after-free
      l2tp: prevent lockdep issue in l2tp_tunnel_register()
      netlink: prevent potential spectre v1 gadgets
      netlink: annotate data races around nlk->portid
      netlink: annotate data races around dst_portid and dst_group
      netlink: annotate data races around sk_state
      ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
      ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
      net/sched: sch_taprio: do not schedule in taprio_reset()

Eric Huang (2):
      drm/amdkfd: Add sync after creating vram bo
      drm/amdkfd: Fix NULL pointer error for GC 11.0.1 on mGPU

Eric Pilmore (1):
      ptdma: pt_core_execute_cmd() should use spinlock

Esina Ekaterina (1):
      net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Evan Quan (1):
      drm/amd/pm: add missing AllowIHInterrupt message mapping for SMU13.0.0

Fabio Estevam (4):
      arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property
      ARM: dts: imx6ul-pico-dwarf: Use 'clock-frequency'
      ARM: dts: imx7d-pico: Use 'clock-frequency'
      ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Fabrizio Castro (1):
      dt-bindings: i2c: renesas,rzv2m: Fix SoC specific string

Florian Westphal (1):
      netfilter: conntrack: handle tcp challenge acks during connection reuse

Gao Xiang (1):
      erofs: fix kvcalloc() misuse with __GFP_NOFAIL

Gaosheng Cui (2):
      memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Geert Uytterhoeven (1):
      phy: phy-can-transceiver: Skip warning if no "max-bitrate"

Gergely Risko (1):
      ipv6: fix reachability confirmation with proxy_ndp

Gerhard Engleder (1):
      tsnep: Fix TX queue stop/wake for multiple queues

Giulio Benetti (1):
      ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Greg Kroah-Hartman (1):
      Linux 6.1.9

Guoqing Jiang (1):
      block/rnbd-clt: fix wrong max ID in ida_alloc_max

Haibo Chen (1):
      arm64: dts: imx93-11x11-evk: correct clock and strobe pad setting

Haiyang Zhang (1):
      net: mana: Fix IRQ name - add PCI and queue number

Hamza Mahfooz (1):
      drm/amd/display: fix issues with driver unload

Hans de Goede (8):
      platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK
      ACPI: video: Add backlight=native DMI quirk for HP Pavilion g6-1d80nr
      ACPI: video: Add backlight=native DMI quirk for HP EliteBook 8460p
      ACPI: video: Add backlight=native DMI quirk for Asus U46E
      platform/x86: asus-wmi: Fix kbd_dock_devid tablet-switch reporting
      platform/x86: apple-gmux: Move port defines to apple-gmux.h
      platform/x86: apple-gmux: Add apple_gmux_detect() helper
      ACPI: video: Fix apple gmux detection

Harsh Jain (1):
      drm/amdgpu: complete gfxoff allow signal during suspend without delay

Harshit Mogalapalli (1):
      Bluetooth: Fix a buffer overflow in mgmt_mesh_add()

Heiko Carstens (1):
      KVM: s390: interrupt: use READ_ONCE() before cmpxchg()

Heiner Kallweit (2):
      net: mdio: validate parameter addr in mdiobus_get_phy()
      net: stmmac: fix invalid call to mdiobus_get_phy()

Hendrik Borghorst (1):
      KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Henning Schild (2):
      platform/x86: simatic-ipc: correct name of a model
      platform/x86: simatic-ipc: add another model

Hui Tang (1):
      reset: uniphier-glue: Fix possible null-ptr-deref

Hui Wang (1):
      net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem

Ivo Borisov Shopov (1):
      tools: gpio: fix -c option of gpio-event-mon

Jack Pham (1):
      usb: ucsi: Ensure connector delayed work items are flushed

Jakub Kicinski (1):
      net: sched: gred: prevent races when adding offloads to stats

Jason Wang (1):
      virtio-net: correctly enable callback during start_xmit

Jason Xing (1):
      tcp: avoid the lookup process failing to get sk in ehash table

Jayesh Choudhary (1):
      dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG

Jeff Layton (1):
      nfsd: don't free files unconditionally in __nfsd_file_cache_purge

Jens Axboe (1):
      io_uring/net: cache provided buffer group value for multishot receives

Jeremy Kerr (3):
      net: mctp: add an explicit reference from a mctp_sk_key to sock
      net: mctp: move expiry timer delete to unhash
      net: mctp: mark socks as dead on unhash, prevent re-add

Jerome Brunet (1):
      net: mdio-mux-meson-g12a: force internal PHY off on mux switch

Jiasheng Jiang (1):
      HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Jiri Kosina (1):
      HID: revert CHERRY_MOUSE_000C quirk

Jisoo Jang (1):
      net: nfc: Fix use-after-free in local_cleanup()

Johan Hovold (2):
      arm64: dts: qcom: sc8280xp: fix primary USB-DP PHY reset
      scsi: ufs: core: Fix devfreq deadlocks

Jonas Karlman (2):
      pinctrl: rockchip: fix reading pull type on rk3568
      pinctrl: rockchip: fix mux route data for rk3568

Jonathan Kim (1):
      drm/amdgpu: remove unconditional trap enable on add gfx11 queues

Juergen Gross (1):
      acpi: Fix suspend with Xen PV

Kan Liang (4):
      perf/x86/cstate: Add Meteor Lake support
      perf/x86/msr: Add Meteor Lake support
      perf/x86/msr: Add Emerald Rapids
      perf/x86/intel/uncore: Add Emerald Rapids

Kees Cook (2):
      bnxt: Do not read past the end of test names
      firmware: coreboot: Check size of table entry and use flex-array

Keith Busch (2):
      nvme-pci: fix timeout request state check
      nvme: fix passthrough csi check

Koba Ko (1):
      dmaengine: Fix double increment of client_count in dma_chan_get()

Konrad Dybcio (5):
      interconnect: qcom: msm8996: Provide UFS clocks to A2NoC
      interconnect: qcom: msm8996: Fix regmap max_register values
      arm64: dts: qcom: msm8992: Don't use sfpb mutex
      arm64: dts: qcom: msm8992-libra: Fix the memory map
      cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist

Krzysztof Kozlowski (1):
      regulator: dt-bindings: samsung,s2mps14: add lost samsung,ext-control-gpios

Kuniyuki Iwashima (1):
      netrom: Fix use-after-free of a listening socket.

Kurt Kanzenbach (1):
      net: stmmac: Fix queue statistics reading

Lareine Khawaly (1):
      i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Ley Foon Tan (1):
      riscv: Move call to init_cpu_topology() to later initialization stage

Liao Chang (1):
      riscv/kprobe: Fix instruction simulation of JALR

Linus Torvalds (2):
      treewide: fix up files incorrectly marked executable
      Fix up more non-executable files marked executable

Liu Shixin (1):
      dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Lucas Stach (2):
      soc: imx: imx8mp-blk-ctrl: enable global pixclk with HDMI_TX_PHY PD
      soc: imx: imx8mp-blk-ctrl: don't set power device name

Luis Gerhorst (1):
      bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Luiz Augusto von Dentz (3):
      Bluetooth: ISO: Avoid circular locking dependency
      Bluetooth: ISO: Fix possible circular locking dependency
      Bluetooth: hci_event: Fix Invalid wait context

Lyude Paul (1):
      drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments

Manivannan Sadhasivam (2):
      EDAC/device: Respect any driver-supplied workqueue polling value
      EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Maor Dickman (2):
      net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT
      net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT

Marc Zyngier (1):
      KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

Marcelo Ricardo Leitner (1):
      sctp: fail if no bound addresses can be used for a given scope

Marco Felsch (1):
      arm64: dts: imx8mp-evk: pcie0-refclk cosmetic cleanup

Marek Vasut (2):
      gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock
      gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Marios Makassikis (1):
      ksmbd: do not sign response to session request for guest login

Mark Brown (2):
      ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC
      ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Fix profile modes on Intel platforms

Mark Rutland (1):
      ftrace: Export ftrace_free_filter() to modules

Mars Chen (1):
      ASoC: support machine driver with max98360

Masahiro Yamada (4):
      tomoyo: fix broken dependency on *.conf.default
      kbuild: export top-level LDFLAGS_vmlinux only to scripts/Makefile.vmlinux
      kbuild: fix 'make modules' error when CONFIG_DEBUG_INFO_BTF_MODULES=y
      riscv: fix -Wundef warning for CONFIG_RISCV_BOOT_SPINWAIT

Mateusz Guzik (1):
      lockref: stop doing cpu_relax in the cmpxchg loop

Max Filippov (1):
      kcsan: test: don't put the expect array on the stack

Maxime Ripard (2):
      drm/vc4: bo: Fix drmm_mutex_init memory hog
      drm/vc4: bo: Fix unused variable warning

Miaoqian Lin (2):
      soc: imx8m: Fix incorrect check for of_clk_get_by_name()
      EDAC/highbank: Fix memory leak in highbank_mc_probe()

Michael Klein (1):
      platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Michal Schmidt (1):
      iavf: fix temporary deadlock and failure to set MAC address

Miklos Szeredi (2):
      ovl: fix tmpfile leak
      ovl: fail on invalid uid/gid mapping at copy up

Miles Chen (1):
      cpufreq: armada-37xx: stop using 0 as NULL pointer

Ming Lei (1):
      block: ublk: move ublk_chr_class destroying after devices are removed

Namjae Jeon (3):
      ksmbd: add max connections parameter
      ksmbd: downgrade ndr version error message to debug
      ksmbd: limit pdu length size according to connection status

Naohiro Aota (1):
      btrfs: zoned: enable metadata over-commit for non-ZNS setup

Natalia Petrova (1):
      trace_events_hist: add check for return value of 'create_hist_field'

Nikita Shubin (1):
      gpio: ep93xx: Fix port F hwirq numbers in handler

Niklas Schnelle (2):
      s390/debug: add _ASM_S390_ prefix to header guard
      vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

Nikunj A Dadhania (1):
      x86/sev: Add SEV-SNP guest feature negotiation support

Nirmoy Das (2):
      drm/drm_vma_manager: Add drm_vma_node_allow_once()
      drm/i915: Fix a memory leak with reused mmap_offset

Oleksii Moisieiev (1):
      xen/pvcalls: free active map buffer on pvcalls_front_free_map

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
      netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Paolo Abeni (2):
      net: fix UaF in netns ops registration error path
      net: mctp: hold key reference when looking up a general key

Patrice Chotard (4):
      ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp15xx-dhcor-som
      ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp15xx-dhcom-som
      ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp157c-emstamp-argon
      ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp151a-prtt1l

Patrick Thompson (1):
      drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Paulo Alcantara (2):
      cifs: fix potential deadlock in cache_refresh_path()
      cifs: fix potential memory leaks in session setup

Pavel Begunkov (7):
      io_uring/msg_ring: fix remote queue to disabled ring
      io_uring: inline io_req_task_work_add()
      io_uring: inline __io_req_complete_post()
      io_uring: hold locks for io_req_complete_failed
      io_uring: use io_req_task_complete() in timeout
      io_uring: remove io_req_tw_post_queue
      io_uring: inline __io_req_complete_put()

Peter Foley (1):
      ata: pata_cs5535: Don't build on UML

Petr Pavlu (1):
      module: Don't wait for GOING modules

Pierre Gondois (2):
      cpufreq: CPPC: Add u64 casts to avoid overflowing
      sched/fair: Check if prev_cpu has highest spare cap in feec()

Pietro Borrello (3):
      HID: check empty report_list in hid_validate_values()
      HID: check empty report_list in bigben_probe()
      HID: betop: check shape of output reports

Qais Yousef (1):
      sched/uclamp: Fix a uninitialized variable warnings

Rafael J. Wysocki (1):
      thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Rahul Rameshbabu (1):
      sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb

Raju Rangoju (2):
      amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
      amd-xgbe: Delay AN timeout during KR training

Rakesh Sankaranarayanan (1):
      net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Randy Dunlap (3):
      reset: ti-sci: honor TI_SCI_PROTOCOL setting when not COMPILE_TEST
      phy: ti: fix Kconfig warning and operator precedence
      net: mlx5: eliminate anonymous module_init & module_exit

Ranjani Sridharan (2):
      ASoC: SOF: pm: Set target state earlier
      ASoC: SOF: pm: Always tear down pipelines before DSP suspend

Richard Fitzgerald (1):
      i2c: designware: Fix unbalanced suspended flag

Rob Clark (1):
      drm/msm/gpu: Fix potential double-free

Robert Hancock (1):
      net: macb: fix PTP TX timestamp failure due to packet padding

Robin Murphy (1):
      Partially revert "perf/arm-cmn: Optimise DTC counter accesses"

Ross Lagerwall (1):
      nvme-fc: fix initialization order

Sasha Levin (1):
      Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Shang XiaoJing (2):
      phy: usb: sunplus: Fix potential null-ptr-deref in sp_usb_phy_probe()
      phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Srinivas Pandruvada (1):
      thermal: intel: int340x: Protect trip temperature from concurrent updates

Sriram Yagnaraman (2):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
      netfilter: conntrack: unify established states for SCTP paths

Stefan Assmann (1):
      iavf: schedule watchdog immediately when changing primary MAC

Steven Rostedt (Google) (2):
      tracing: Make sure trace_printk() can output as soon as it can be used
      ftrace/scripts: Update the instructions for ftrace-bisect.sh

Sumit Gupta (1):
      cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Sven Schnelle (1):
      nolibc: fix fd_set type

Szymon Heidrich (2):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
      net: usb: sr9700: Handle negative len

Tamim Khan (1):
      ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA

Thomas Gleixner (1):
      x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Thomas Weißschuh (3):
      platform/x86: asus-nb-wmi: Add alternate mapping for KEY_CAMERA
      platform/x86: asus-wmi: Add quirk wmi_ignore_fan
      platform/x86: asus-wmi: Ignore fan on E410MA

Tim Harvey (1):
      arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity

Tonghao Zhang (1):
      bpf: hash map, avoid deadlock with suitable hash mask

Udipto Goswami (2):
      usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
      usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Vijaya Krishna Nivarthi (1):
      dmaengine: qcom: gpi: Set link_rx bit on GO TRE for rx operation

Ville Syrjälä (2):
      drm/i915: Allow panel fixed modes to have differing sync polarities
      drm/i915: Allow alternate fixed modes always for eDP

Viresh Kumar (2):
      thermal: Validate new state in cur_state_store()
      thermal: core: call put_device() only after device_register() fails

Vlad Buslov (1):
      net/mlx5e: Avoid false lock dependency warning on tc_ht even more

Vladimir Oltean (1):
      net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

Vlastimil Babka (1):
      Revert "mm/compaction: fix set skip in fast_find_migrateblock"

Warner Losh (1):
      tools/nolibc: Fix S_ISxxx macros

Wayne Lin (3):
      drm/display/dp_mst: Correct the kref of port.
      drm/amdgpu/display/mst: limit payload to be updated one by one
      drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD

Wei Fang (1):
      net: fec: Use page_pool_put_full_page when freeing rx buffers

Wenchao Hao (1):
      scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

Werner Sembach (1):
      Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Willem de Bruijn (1):
      selftests/net: toeplitz: fix race on tpacket_v3 block close

Willy Tarreau (2):
      tools/nolibc: fix missing includes causing build issues at -O0
      tools/nolibc: prevent gcc from making memset() loop over itself

Wim Van Boven (1):
      ASoC: amd: yc: Add Razer Blade 14 2022 into DMI table

Witold Sadowski (1):
      spi: cadence: Fix busy cycles calculation

Xingui Yang (1):
      scsi: hisi_sas: Use abort task set to reset SAS disks when discovered

Xingyuan Mo (1):
      NFSD: fix use-after-free in nfsd4_ssc_setup_dul()

Yang Yingliang (3):
      device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()
      w1: fix deadloop in __w1_remove_master_device()
      w1: fix WARNING after calling w1_process()

Yi Liu (1):
      kvm/vfio: Fix potential deadlock on vfio group_lock

Yihang Li (1):
      scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id

Ying Hsu (1):
      Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Yonatan Nachum (1):
      RDMA/core: Fix ib block iterator counter overflow

Yoshihiro Shimoda (2):
      net: ravb: Fix lack of register setting after system resumed for Gen3
      net: ravb: Fix possible hang if RIS2_QFF1 happen

Zhengchao Shao (2):
      Bluetooth: hci_conn: Fix memory leaks
      Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()

tongjian (1):
      ASoC: mediatek: mt8186: support rt5682s_max98360

