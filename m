Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE48B639575
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 11:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiKZKmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 05:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKZKmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 05:42:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57227BF72;
        Sat, 26 Nov 2022 02:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0A17B8119B;
        Sat, 26 Nov 2022 10:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E45C433D6;
        Sat, 26 Nov 2022 10:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669459357;
        bh=HZbfl2G6Dt0TPP1TtA83NsFG8my9fwPk/yw2+yVYx4A=;
        h=From:To:Cc:Subject:Date:From;
        b=WYHTvhUMs8q4iGD1QZTDsElHKupjhcXczV3GMk4OVw/+0b/AqSNGQb2ci43OsHdmg
         ctX451ouK6bd9tf44LENs/t4God4ULhwiVu0kPULU/oe35cSwu2ypAF6IfyZvGtCHQ
         gPUtPCB4d6fj+moAHDlBOfuIA2CBtiHm5rTiiGQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.10
Date:   Sat, 26 Nov 2022 11:20:50 +0100
Message-Id: <166945805116240@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.10 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/driver-api/miscellaneous.rst                          |    5 
 Documentation/process/code-of-conduct-interpretation.rst            |    2 
 Makefile                                                            |    2 
 arch/arm/boot/dts/imx7s.dtsi                                        |    4 
 arch/arm/boot/dts/sama7g5-pinfunc.h                                 |    2 
 arch/arm/mach-at91/pm_suspend.S                                     |    7 
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts           |   32 +
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                           |    4 
 arch/arm64/boot/dts/freescale/imx8mn.dtsi                           |    2 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi                               |    2 
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts                            |   13 
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts                            |   12 
 arch/arm64/boot/dts/qcom/sc7280.dtsi                                |    3 
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts                           |    6 
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi                              |   36 -
 arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi             |    6 
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi                |    6 
 arch/arm64/boot/dts/qcom/sm8250.dtsi                                |    1 
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts                             |   12 
 arch/arm64/include/asm/cputype.h                                    |    2 
 arch/arm64/include/asm/pgtable.h                                    |    4 
 arch/arm64/mm/mmu.c                                                 |    8 
 arch/arm64/mm/pageattr.c                                            |   11 
 arch/mips/kernel/relocate_kernel.S                                  |   15 
 arch/mips/loongson64/reset.c                                        |   10 
 arch/powerpc/Kconfig                                                |    2 
 arch/s390/include/asm/processor.h                                   |   11 
 arch/x86/events/amd/core.c                                          |    5 
 arch/x86/events/amd/uncore.c                                        |    1 
 arch/x86/events/intel/pt.c                                          |    9 
 arch/x86/include/asm/intel-family.h                                 |   11 
 arch/x86/kernel/cpu/bugs.c                                          |   13 
 arch/x86/kernel/cpu/sgx/ioctl.c                                     |    3 
 arch/x86/kernel/fpu/core.c                                          |    2 
 arch/x86/kvm/kvm-asm-offsets.c                                      |    2 
 arch/x86/kvm/svm/sev.c                                              |    4 
 arch/x86/kvm/svm/svm.c                                              |   91 +---
 arch/x86/kvm/svm/svm.h                                              |   10 
 arch/x86/kvm/svm/svm_ops.h                                          |    5 
 arch/x86/kvm/svm/vmenter.S                                          |  136 +++++-
 arch/x86/kvm/xen.c                                                  |    7 
 block/blk-cgroup.c                                                  |    2 
 block/blk-core.c                                                    |    1 
 block/blk-mq.c                                                      |    1 
 block/blk-settings.c                                                |    8 
 block/sed-opal.c                                                    |   32 +
 drivers/accessibility/speakup/main.c                                |    2 
 drivers/accessibility/speakup/utils.h                               |    2 
 drivers/acpi/scan.c                                                 |    1 
 drivers/acpi/x86/utils.c                                            |    6 
 drivers/ata/libata-scsi.c                                           |   10 
 drivers/ata/libata-transport.c                                      |   19 
 drivers/block/drbd/drbd_main.c                                      |    4 
 drivers/cxl/core/mbox.c                                             |    2 
 drivers/cxl/pmem.c                                                  |    2 
 drivers/firmware/arm_scmi/bus.c                                     |   11 
 drivers/firmware/arm_scmi/common.h                                  |    5 
 drivers/firmware/arm_scmi/driver.c                                  |   32 -
 drivers/firmware/arm_scmi/mailbox.c                                 |    2 
 drivers/firmware/arm_scmi/optee.c                                   |    2 
 drivers/firmware/arm_scmi/shmem.c                                   |   31 +
 drivers/firmware/arm_scmi/smc.c                                     |    2 
 drivers/firmware/google/coreboot_table.c                            |   37 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                          |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c                              |    9 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   35 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h                   |    6 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c              |   10 
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c                  |   30 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c                  |   12 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c                   |    1 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c                 |    2 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c       |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c                |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c      |    7 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c   |    4 
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c               |    2 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                           |   23 -
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h                       |    8 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h                        |   10 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                        |   11 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                      |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                      |    9 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c                |   30 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c                |   30 +
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c                   |   51 +-
 drivers/gpu/drm/drm_drv.c                                           |    2 
 drivers/gpu/drm/drm_internal.h                                      |    3 
 drivers/gpu/drm/imx/imx-tve.c                                       |    5 
 drivers/gpu/drm/lima/lima_devfreq.c                                 |   15 
 drivers/gpu/drm/msm/adreno/adreno_device.c                          |   10 
 drivers/gpu/drm/msm/msm_gpu.c                                       |    2 
 drivers/gpu/drm/msm/msm_gpu.h                                       |    4 
 drivers/gpu/drm/panel/panel-simple.c                                |    2 
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c                        |   10 
 drivers/gpu/drm/scheduler/sched_entity.c                            |    6 
 drivers/gpu/drm/vc4/vc4_kms.c                                       |    8 
 drivers/i2c/busses/i2c-i801.c                                       |    1 
 drivers/i2c/busses/i2c-tegra.c                                      |   16 
 drivers/iio/accel/bma400_core.c                                     |   24 -
 drivers/iio/adc/at91_adc.c                                          |    4 
 drivers/iio/adc/mp2629_adc.c                                        |    5 
 drivers/iio/pressure/ms5611.h                                       |   12 
 drivers/iio/pressure/ms5611_core.c                                  |   51 +-
 drivers/iio/pressure/ms5611_spi.c                                   |    2 
 drivers/iio/trigger/iio-trig-sysfs.c                                |    6 
 drivers/infiniband/hw/efa/efa_main.c                                |    4 
 drivers/input/joystick/iforce/iforce-main.c                         |    8 
 drivers/input/serio/i8042.c                                         |    4 
 drivers/iommu/intel/iommu.c                                         |    8 
 drivers/iommu/intel/pasid.c                                         |    5 
 drivers/isdn/mISDN/core.c                                           |    2 
 drivers/isdn/mISDN/dsp_pipeline.c                                   |    3 
 drivers/md/dm-bufio.c                                               |    2 
 drivers/md/dm-crypt.c                                               |    1 
 drivers/md/dm-ioctl.c                                               |    4 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                             |    2 
 drivers/mmc/core/core.c                                             |    8 
 drivers/mmc/host/sdhci-pci-core.c                                   |    2 
 drivers/mmc/host/sdhci-pci-o2micro.c                                |    7 
 drivers/mtd/nand/onenand/Kconfig                                    |    1 
 drivers/mtd/nand/raw/qcom_nandc.c                                   |   12 
 drivers/net/ethernet/amazon/ena/ena_netdev.c                        |    8 
 drivers/net/ethernet/atheros/ag71xx.c                               |    3 
 drivers/net/ethernet/broadcom/bgmac.c                               |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |   62 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                           |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c                      |    3 
 drivers/net/ethernet/cavium/liquidio/lio_main.c                     |   34 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                         |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c    |   20 
 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h    |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                     |  167 ++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                     |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |   11 
 drivers/net/ethernet/huawei/hinic/hinic_main.c                      |    9 
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c                 |   16 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c            |    2 
 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c            |    3 
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c              |    3 
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c                 |    3 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                |    6 
 drivers/net/ethernet/pensando/ionic/ionic_main.c                    |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |    3 
 drivers/net/macvlan.c                                               |    6 
 drivers/net/mctp/mctp-i2c.c                                         |   47 +-
 drivers/net/mhi_net.c                                               |    2 
 drivers/net/netdevsim/dev.c                                         |    1 
 drivers/net/phy/dp83867.c                                           |    7 
 drivers/net/phy/marvell.c                                           |   16 
 drivers/net/thunderbolt.c                                           |   19 
 drivers/net/usb/smsc95xx.c                                          |   46 +-
 drivers/nvme/host/ioctl.c                                           |    6 
 drivers/nvme/host/nvme.h                                            |   16 
 drivers/nvme/host/pci.c                                             |    4 
 drivers/nvme/target/auth.c                                          |    2 
 drivers/nvme/target/configfs.c                                      |    1 
 drivers/parport/parport_pc.c                                        |    2 
 drivers/pinctrl/devicetree.c                                        |    2 
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c                    |    3 
 drivers/pinctrl/pinctrl-rockchip.c                                  |   40 +
 drivers/platform/surface/aggregator/ssh_packet_layer.c              |   24 -
 drivers/platform/x86/amd/pmc.c                                      |    3 
 drivers/platform/x86/intel/pmc/core.c                               |    2 
 drivers/platform/x86/intel/pmc/pltdrv.c                             |    9 
 drivers/platform/x86/thinkpad_acpi.c                                |    4 
 drivers/s390/block/dcssblk.c                                        |    1 
 drivers/s390/scsi/zfcp_fsf.c                                        |    2 
 drivers/scsi/scsi_debug.c                                           |    6 
 drivers/scsi/scsi_transport_sas.c                                   |   13 
 drivers/siox/siox-core.c                                            |    2 
 drivers/slimbus/Kconfig                                             |    2 
 drivers/slimbus/stream.c                                            |    8 
 drivers/soc/imx/soc-imx8m.c                                         |   11 
 drivers/spi/spi-intel.c                                             |    2 
 drivers/spi/spi-stm32.c                                             |    1 
 drivers/spi/spi-tegra210-quad.c                                     |    5 
 drivers/target/loopback/tcm_loop.c                                  |    3 
 drivers/tty/n_gsm.c                                                 |    2 
 drivers/tty/serial/8250/8250_lpss.c                                 |   17 
 drivers/tty/serial/8250/8250_omap.c                                 |   45 +
 drivers/tty/serial/8250/8250_port.c                                 |    7 
 drivers/tty/serial/fsl_lpuart.c                                     |   76 ++-
 drivers/tty/serial/imx.c                                            |    1 
 drivers/usb/cdns3/host.c                                            |   56 +-
 drivers/usb/chipidea/otg_fsm.c                                      |    2 
 drivers/usb/core/quirks.c                                           |    3 
 drivers/usb/dwc3/core.c                                             |   10 
 drivers/usb/dwc3/host.c                                             |   10 
 drivers/usb/host/bcma-hcd.c                                         |   10 
 drivers/usb/serial/option.c                                         |   19 
 drivers/usb/typec/mux/intel_pmc_mux.c                               |   15 
 drivers/usb/typec/tipd/core.c                                       |    6 
 drivers/vfio/vfio_main.c                                            |   50 +-
 drivers/xen/pcpu.c                                                  |    2 
 fs/btrfs/raid56.c                                                   |    6 
 fs/btrfs/tests/qgroup-tests.c                                       |   16 
 fs/buffer.c                                                         |    4 
 fs/ceph/snap.c                                                      |    3 
 fs/cifs/connect.c                                                   |   14 
 fs/cifs/ioctl.c                                                     |    4 
 fs/cifs/misc.c                                                      |    6 
 fs/cifs/smb2misc.c                                                  |   12 
 fs/cifs/smb2ops.c                                                   |   10 
 fs/cifs/smb2transport.c                                             |    6 
 fs/erofs/fscache.c                                                  |  226 ++++------
 fs/gfs2/ops_fstype.c                                                |   17 
 fs/hugetlbfs/inode.c                                                |   32 -
 fs/namei.c                                                          |    2 
 fs/netfs/buffered_read.c                                            |   20 
 fs/netfs/io.c                                                       |    3 
 fs/nfs/nfs4proc.c                                                   |    6 
 fs/nfsd/nfs4state.c                                                 |    1 
 fs/ntfs/attrib.c                                                    |   28 +
 fs/ntfs/inode.c                                                     |    7 
 include/linux/blkdev.h                                              |   15 
 include/linux/bpf.h                                                 |    4 
 include/linux/hugetlb.h                                             |    2 
 include/linux/io_uring.h                                            |    3 
 include/linux/ring_buffer.h                                         |    2 
 include/linux/trace.h                                               |    4 
 include/linux/wireless.h                                            |   10 
 include/net/ip.h                                                    |    2 
 include/net/ipv6.h                                                  |    2 
 include/soc/at91/sama7-ddr.h                                        |    5 
 include/uapi/linux/ip.h                                             |    6 
 include/uapi/linux/ipv6.h                                           |    6 
 io_uring/io_uring.c                                                 |   12 
 io_uring/io_uring.h                                                 |    4 
 io_uring/net.c                                                      |   23 -
 io_uring/poll.c                                                     |   41 +
 kernel/bpf/percpu_freelist.c                                        |   23 -
 kernel/bpf/syscall.c                                                |   11 
 kernel/bpf/trampoline.c                                             |   15 
 kernel/bpf/verifier.c                                               |   14 
 kernel/events/core.c                                                |   25 -
 kernel/kprobes.c                                                    |    8 
 kernel/rseq.c                                                       |   19 
 kernel/trace/bpf_trace.c                                            |    6 
 kernel/trace/ftrace.c                                               |    5 
 kernel/trace/kprobe_event_gen_test.c                                |   48 +-
 kernel/trace/rethook.c                                              |    4 
 kernel/trace/ring_buffer.c                                          |   71 ++-
 kernel/trace/synth_event_gen_test.c                                 |   16 
 kernel/trace/trace.c                                                |   12 
 kernel/trace/trace_eprobe.c                                         |    3 
 kernel/trace/trace_events_synth.c                                   |    5 
 mm/filemap.c                                                        |    2 
 mm/hugetlb.c                                                        |   12 
 mm/maccess.c                                                        |    2 
 mm/memory-failure.c                                                 |    5 
 net/9p/trans_fd.c                                                   |   45 +
 net/bluetooth/l2cap_core.c                                          |    2 
 net/bpf/test_run.c                                                  |    1 
 net/bridge/br_vlan.c                                                |   17 
 net/caif/chnl_net.c                                                 |    3 
 net/dsa/dsa2.c                                                      |   10 
 net/dsa/dsa_priv.h                                                  |    1 
 net/dsa/master.c                                                    |    3 
 net/dsa/port.c                                                      |   16 
 net/ipv4/tcp_cdg.c                                                  |    2 
 net/kcm/kcmsock.c                                                   |   60 --
 net/netfilter/ipset/ip_set_core.c                                   |    8 
 net/netlink/af_netlink.c                                            |    8 
 net/sctp/outqueue.c                                                 |   13 
 net/sunrpc/auth_gss/auth_gss.c                                      |    2 
 net/wireless/wext-core.c                                            |   17 
 net/x25/x25_dev.c                                                   |    2 
 sound/pci/hda/patch_realtek.c                                       |    2 
 sound/soc/amd/yc/acp6x-mach.c                                       |   21 
 sound/soc/codecs/jz4725b.c                                          |   34 -
 sound/soc/codecs/mt6660.c                                           |    8 
 sound/soc/codecs/rt1019.c                                           |   20 
 sound/soc/codecs/rt1019.h                                           |    6 
 sound/soc/codecs/rt1308-sdw.h                                       |    2 
 sound/soc/codecs/rt5514-spi.c                                       |   15 
 sound/soc/codecs/rt5677-spi.c                                       |   19 
 sound/soc/codecs/rt5682s.c                                          |   15 
 sound/soc/codecs/rt5682s.h                                          |    1 
 sound/soc/codecs/tas2764.c                                          |   19 
 sound/soc/codecs/tas2770.c                                          |   20 
 sound/soc/codecs/tas2780.c                                          |   19 
 sound/soc/codecs/wm5102.c                                           |    6 
 sound/soc/codecs/wm5110.c                                           |    6 
 sound/soc/codecs/wm8962.c                                           |   54 ++
 sound/soc/codecs/wm8997.c                                           |    6 
 sound/soc/fsl/fsl_asrc.c                                            |    2 
 sound/soc/fsl/fsl_esai.c                                            |    2 
 sound/soc/fsl/fsl_sai.c                                             |    2 
 sound/soc/intel/boards/sof_rt5682.c                                 |   12 
 sound/soc/intel/boards/sof_sdw.c                                    |   11 
 sound/soc/soc-core.c                                                |   17 
 sound/soc/soc-utils.c                                               |    2 
 sound/soc/sof/topology.c                                            |   20 
 sound/usb/midi.c                                                    |    4 
 tools/testing/cxl/test/cxl.c                                        |    4 
 tools/testing/selftests/bpf/test_progs.c                            |    2 
 tools/testing/selftests/bpf/test_verifier.c                         |    2 
 tools/testing/selftests/futex/functional/Makefile                   |    6 
 tools/testing/selftests/intel_pstate/Makefile                       |    6 
 tools/testing/selftests/kexec/Makefile                              |    6 
 tools/testing/selftests/pidfd/pidfd_wait.c                          |   10 
 304 files changed, 2491 insertions(+), 1294 deletions(-)

Aashish Sharma (1):
      tracing: Fix warning on variable 'struct trace_array'

Adrian Hunter (1):
      perf/x86/intel/pt: Fix sampling using single range output

Aishwarya Kothari (1):
      drm/panel: simple: set bpc field for logic technologies displays

Akhil P Oommen (1):
      drm/msm/gpu: Fix crash during system suspend after unbind

Akira Yokosawa (1):
      docs/driver-api/miscellaneous: Remove kernel-doc of serial_core.c

Al Viro (1):
      block: blk_add_rq_to_plug(): clear stale 'last' after flush

Alban Crequy (1):
      maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()

Alexander Potapenko (2):
      misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()
      mm: fs: initialize fsdata passed to write_begin/write_end interface

Alexander Stein (1):
      arm64: dts: imx8mm-tqma8mqml-mba8mx: Fix USB DR

Alexandru Tachici (1):
      net: usb: smsc95xx: fix external PHY reset

Alvin Lee (2):
      drm/amd/display: Don't return false if no stream
      drm/amd/display: Enable timing sync on DCN32

Aminuddin Jamaluddin (1):
      net: phy: marvell: add sleep time after enabling the loopback bit

Amit Cohen (1):
      mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed

Anastasia Belova (2):
      cifs: add check for returning value of SMB2_close_init
      cifs: add check for returning value of SMB2_set_info_init

Andreas Gruenbacher (1):
      gfs2: Switch from strlcpy to strscpy

Andrew Price (1):
      gfs2: Check sb_bsize_shift after reading superblock

AngeloGioacchino Del Regno (1):
      pinctrl: mediatek: common-v2: Fix bias-disable for PULL_PU_PD_RSEL_TYPE

Ard Biesheuvel (1):
      arm64: fix rodata=full again

Baisong Zhong (1):
      bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Bean Huo (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro

Benjamin Block (1):
      scsi: zfcp: Fix double free of FSF request when qdio send fails

Benjamin Coddington (1):
      NFSv4: Retry LOCK on OLD_STATEID during delegation return

Benoît Monin (1):
      USB: serial: option: add Sierra Wireless EM9191

Borys Popławski (1):
      x86/sgx: Add overflow check in sgx_validate_offset_length()

Brian Masney (1):
      arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy

Brian Norris (1):
      firmware: coreboot: Register bus in module init

Chen Jun (1):
      Input: i8042 - fix leaking of platform device on module removal

Chen Zhongjin (2):
      ASoC: core: Fix use-after-free in snd_soc_exit()
      ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Chevron Li (1):
      mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout

Chris Mason (1):
      blk-cgroup: properly pin the parent in blkcg_css_online

Christian König (1):
      drm/scheduler: fix fence ref counting

Christian Marangi (1):
      mtd: rawnand: qcom: handle ret from parse with codeword_fixup

Chuang Wang (1):
      net: macvlan: Use built-in RCU list checking

Chuck Lever (1):
      SUNRPC: Fix crasher in gss_unwrap_resp_integ()

Claudiu Beznea (1):
      ARM: at91: pm: avoid soft resetting AC DLL

Colin Ian King (1):
      ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"

Cong Wang (1):
      kcm: close race conditions on sk_receive_queue

Cristian Marussi (2):
      firmware: arm_scmi: Cleanup the core driver removal callback
      firmware: arm_scmi: Make tx_prepare time out eventually

D Scott Phillips (1):
      arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro

Dan Carpenter (1):
      drbd: use after free in drbd_create_device()

Dan Williams (1):
      tools/testing/cxl: Fix some error exits

Daniil Tatianin (1):
      ring_buffer: Do not deactivate non-existant pages

David Howells (2):
      netfs: Fix missing xas_retry() calls in xarray iteration
      netfs: Fix dodgy maths

Davide Tronchin (3):
      USB: serial: option: remove old LARA-R6 PID
      USB: serial: option: add u-blox LARA-R6 00B modem
      USB: serial: option: add u-blox LARA-L6 modem

Derek Fang (2):
      ASoC: rt5682s: Fix the TDM Tx settings
      ASoC: rt1019: Fix the TDM settings

Dillon Varone (1):
      drm/amd/display: Fix prefetch calculations for dcn32

Dominique Martinet (2):
      9p: trans_fd/p9_conn_cancel: drop client lock earlier
      net/9p: use a dedicated spinlock for trans_fd

Douglas Anderson (6):
      arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed
      arm64: dts: qcom: sa8295p-adp: Specify which LDO modes are allowed
      arm64: dts: qcom: sc8280xp-crd: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8150-xperia-kumano: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8250-xperia-edo: Specify which LDO modes are allowed
      arm64: dts: qcom: sm8350-hdk: Specify which LDO modes are allowed

Duoming Zhou (2):
      tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
      usb: chipidea: fix deadlock in ci_otg_del_timer

Dylan Yudaken (1):
      io_uring: calculate CQEs from the user visible value

Eiichi Tsukata (1):
      KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign()

Emil Flink (1):
      ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro

Eric Dumazet (3):
      macvlan: enforce a consistent minimal mtu
      tcp: cdg: allow tcp_cdg_release() to be called multiple times
      kcm: avoid potential race in kcm_tx_work

Erico Nunes (1):
      drm/lima: Fix opp clkname setting in case of missing regulator

Evan Quan (3):
      drm/amd/pm: enable runpm support over BACO for SMU13.0.7
      drm/amd/pm: enable runpm support over BACO for SMU13.0.0
      drm/amd/pm: fix SMU13 runpm hang due to unintentional workaround

Fangzhi Zuo (1):
      drm/amd/display: Ignore Cable ID Feature

Filipe Manana (1):
      btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Gaosheng Cui (2):
      drm/vc4: kms: Fix IS_ERR() vs NULL check for vc4_kms
      bnxt_en: Remove debugfs when pci_register_driver failed

Gayatri Kammela (1):
      platform/x86/intel: pmc/core: Add Raptor Lake support to pmc core driver

George Shen (4):
      drm/amd/display: Fix DCN32 DSC delay calculation
      drm/amd/display: Use forced DSC bpp in DML
      drm/amd/display: Round up DST_after_scaler to nearest int
      drm/amd/display: Support parsing VRAM info v3.0 from VBIOS

Gerald Schaefer (1):
      s390/dcssblk: fix deadlock when adding a DCSS

Greg Kroah-Hartman (1):
      Linux 6.0.10

Guangbin Huang (1):
      net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process

Hangbin Liu (1):
      net: use struct_group to copy ip/ipv6 header addresses

Hans de Goede (1):
      ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]

Hawkins Jiawei (4):
      wifi: wext: use flex array destination for memcpy()
      ntfs: fix use-after-free in ntfs_attr_find()
      ntfs: fix out-of-bounds read in ntfs_attr_find()
      ntfs: check overflow when iterating ATTR_RECORDs

Ido Schimmel (1):
      bridge: switchdev: Fix memory leaks when changing VLAN protocol

Ilpo Järvinen (4):
      serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
      serial: 8250: Flush DMA Rx on RLSI
      serial: 8250_lpss: Configure DMA also w/o DMA filter
      serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake

Jaco Coetzee (1):
      nfp: change eeprom length to max length enumerators

James Houghton (1):
      hugetlbfs: don't delete error page from pagecache

Janne Grunau (1):
      usb: dwc3: Do not get extcon device when usb-role-switch is used

Jason Gunthorpe (2):
      vfio: Rename vfio_ioctl_check_extension()
      vfio: Split the register_device ops call into functions

Jason Montleon (2):
      ASoC: rt5514: fix legacy dai naming
      ASoC: rt5677: fix legacy dai naming

Jeff Layton (1):
      nfsd: put the export reference in nfsd4_verify_deleg_dentry

Jelle van der Waa (1):
      platform/x86: thinkpad_acpi: Fix reporting a non present second fan on some models

Jeremy Kerr (1):
      mctp i2c: don't count unused / invalid keys for flow release

Jian Shen (1):
      net: hns3: fix incorrect hw rss hash type of rx packet

Jie Wang (1):
      net: hns3: fix return value check bug of rx copybreak

Jingbo Xu (4):
      erofs: clean up .read_folio() and .readahead() in fscache mode
      erofs: get correct count for unmapped range in fscache mode
      erofs: put metabuf in error path in fscache mode
      erofs: fix missing xas_retry() in fscache mode

Jiri Olsa (1):
      bpf: Prevent bpf program recursion for raw tracepoint probes

Johan Hovold (7):
      arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock
      arm64: dts: qcom: sc8280xp: fix USB0 PHY PCS_MISC registers
      arm64: dts: qcom: sc8280xp: fix USB1 PHY RX1 registers
      arm64: dts: qcom: sc8280xp: fix USB PHY PCS registers
      arm64: dts: qcom: sc8280xp: drop broken DP PHY nodes
      arm64: dts: qcom: sc8280xp: fix UFS PHY serdes size
      Revert "usb: dwc3: disable USB core PHY management"

Jonathan Cameron (2):
      cxl/mbox: Add a check on input payload size
      iio: accel: bma400: Ensure VDDIO is enable defore reading the chip ID.

Kees Cook (1):
      netlink: Bounds-check struct nlmsgerr creation

Keith Busch (4):
      block: make dma_alignment a stacking queue_limit
      dm-crypt: provide dma_alignment limit in io_hints
      nvme: restrict management ioctls to admin
      nvme: ensure subsystem reset is single threaded

Krishna Yarlagadda (1):
      spi: tegra210-quad: Fix combined sequence

Krzysztof Kozlowski (2):
      mtd: onenand: omap2: add dependency on GPMC
      slimbus: stream: correct presence rate frequencies

Leohearts (1):
      ASoC: amd: yc: Add Lenovo Thinkbook 14+ 2022 21D0 to quirks table

Li Huafei (1):
      kprobes: Skip clearing aggrprobe's post_handler in kprobe-on-ftrace case

Li Jun (1):
      usb: cdns3: host: fix endless superspeed hub port reset

Li Zhijian (1):
      ksefltests: pidfd: Fix wait_states: Test terminated by timeout

Liao Chang (1):
      MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed

Linus Walleij (1):
      USB: bcma: Make GPIO explicitly optional

Liu Jian (1):
      net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()

Liu Shixin (1):
      arm64/mm: fix incorrect file_map_count for non-leaf pmd/pud

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Maarten Zanders (1):
      ASoC: fsl_asrc fsl_esai fsl_sai: allow CONFIG_PM=N

Maciej W. Rozycki (1):
      parport_pc: Avoid FIFO port location truncation

Marco Elver (1):
      perf: Improve missing SIGTRAP checking

Marek Vasut (4):
      spi: stm32: Print summary 'callbacks suppressed' message
      ARM: dts: imx7: Fix NAND controller size-cells
      arm64: dts: imx8mm: Fix NAND controller size-cells
      arm64: dts: imx8mn: Fix NAND controller size-cells

Mario Limonciello (3):
      ACPI: x86: Add another system to quirk list for forcing StorageD3Enable
      drm/amd: Fail the suspend if resources can't be evicted
      platform/x86/amd: pmc: Remove more CONFIG_DEBUG_FS checks

Martin Povišer (3):
      ASoC: tas2770: Fix set_tdm_slot in case of single slot
      ASoC: tas2764: Fix set_tdm_slot in case of single slot
      ASoC: tas2780: Fix set_tdm_slot in case of single slot

Mathieu Desnoyers (1):
      rseq: Use pr_warn_once() when deprecated/unknown ABI flags are encountered

Matthias Schiffer (1):
      serial: 8250_omap: remove wait loop from Errata i202 workaround

Mauro Lima (1):
      spi: intel: Fix the offset to get the 64K erase opcode

Maximilian Luz (1):
      platform/surface: aggregator: Do not check for repeated unsequenced packets

Mel Gorman (1):
      x86/fpu: Drop fpregs lock before inheriting FPU permissions

Melissa Wen (1):
      drm/amd/display: don't enable DRM CRTC degamma property for DCE

Michael Ellerman (1):
      powerpc/64e: Fix amdgpu build on Book3E w/o AltiVec

Michael Margolin (1):
      RDMA/efa: Add EFA 0xefa2 PCI ID

Michael Sit Wei Hong (1):
      net: phy: dp83867: Fix SGMII FIFO depth for non OF devices

Michael Tretter (2):
      drm/rockchip: vop2: fix null pointer in plane_atomic_disable
      drm/rockchip: vop2: disable planes when disabling the crtc

Mihai Sain (1):
      ARM: dts: at91: sama7g5: fix signal name of pin PB2

Mike Kravetz (1):
      hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache

Mike Rapoport (1):
      arm64/mm: fold check for KFENCE into can_set_direct_map()

Mikulas Patocka (1):
      dm ioctl: fix misbehavior if list_versions races with module loading

Mitja Spes (2):
      iio: pressure: ms5611: fixed value compensation bug
      iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Mohd Faizal Abdul Rahim (1):
      net: stmmac: ensure tx function is not running in stmmac_xdp_release()

Mushahid Hussain (1):
      speakup: fix a segfault caused by switching consoles

Nam Cao (1):
      i2c: i801: add lis3lv02d's I2C address for Vostro 5568

Nathan Huckleberry (1):
      drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nevenko Stupar (1):
      drm/amd/display: Investigate tool reported FCLK P-state deviations

Nicolas Dumazet (1):
      usb: add NO_LPM quirk for Realforce 87U Keyboard

Niklas Cassel (1):
      ata: libata-core: do not issue non-internal commands once EH is pending

Paolo Bonzini (4):
      KVM: SVM: remove dead field from struct svm_cpu_data
      KVM: SVM: do not allocate struct svm_cpu_data dynamically
      KVM: SVM: restore host save area from assembly
      KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly

Pavel Begunkov (6):
      io_uring/poll: fix double poll req->flags races
      io_uring: update res mask in io_poll_check_events
      io_uring: fix tw losing poll events
      io_uring: fix multishot accept request leaks
      io_uring: fix multishot recv request leaks
      io_uring: disallow self-propelled ring polling

Peng Fan (1):
      arm64: dts: imx93-pinfunc: drop execution permission

Peter Ujfalusi (1):
      ASoC: SOF: topology: No need to assign core ID if token parsing failed

Pierre-Louis Bossart (1):
      ASoC: Intel: sof_sdw: add quirk variant for LAPBC710 NUC15

Pu Lehui (1):
      selftests/bpf: Fix casting error when cross-compiling test_verifier for 32-bit platforms

Qu Wenruo (1):
      btrfs: raid56: properly handle the error when unable to find the missing stripe

Quentin Schulz (1):
      pinctrl: rockchip: list all pins in a possible mux route for PX30

Rajat Khandelwal (1):
      usb: typec: mux: Enter safe mode only when pins need to be reconfigured

Ravi Bangoria (1):
      perf/x86/amd: Fix crash due to race between amd_pmu_enable_all, perf NMI and throttling

Reinhard Speyerer (1):
      USB: serial: option: add Fibocom FM160 0x0111 composition

Ricardo Cañuelo (3):
      selftests/futex: fix build for clang
      selftests/intel_pstate: fix build for ARCH=x86_64
      selftests/kexec: fix build for ARCH=x86_64

Robert Marko (1):
      arm64: dts: qcom: ipq8074: correct APCS register space size

Rodrigo Siqueira (2):
      drm/amd/display: Remove wrong pipe control lock
      drm/amd/display: Add HUBP surface flip interrupt handler

Roger Pau Monné (1):
      platform/x86/intel: pmc: Don't unconditionally attach Intel PMC when virtualized

Roman Li (1):
      drm/amd/display: Fix optc2_configure warning on dcn314

Rongwei Zhang (1):
      MIPS: fix duplicate definitions for exported symbols

Sagi Grimberg (2):
      nvmet: fix a memory leak
      nvmet: fix a memory leak in nvmet_auth_set_key

Sandipan Das (1):
      perf/x86/amd/uncore: Fix memory leak for events array

Saravanan Sekar (2):
      iio: adc: mp2629: fix wrong comparison of channel
      iio: adc: mp2629: fix potential array out of bound access

Satya Priya (1):
      arm64: dts: qcom: sc7280: Add the reset reg for lpass audiocc on SC7280

Serge Semin (1):
      block: sed-opal: kmalloc the cmd/resp buffers

Shang XiaoJing (8):
      drm/drv: Fix potential memory leak in drm_dev_init()
      drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()
      net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
      net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()
      tracing: Fix memory leak in test_gen_synth_cmd() and test_empty_synth_event()
      tracing: Fix wild-memory-access in register_synth_event()
      tracing: kprobe: Fix potential null-ptr-deref on trace_event_file in kprobe_event_gen_test_exit()
      tracing: kprobe: Fix potential null-ptr-deref on trace_array in kprobe_event_gen_test_exit()

Shawn Guo (1):
      serial: imx: Add missing .thaw_noirq hook

Sherry Sun (1):
      tty: serial: fsl_lpuart: don't break the on-going transfer when global reset

Shuah Khan (1):
      docs: update mediator contact information in CoC doc

Shuming Fan (1):
      ASoC: rt1308-sdw: add the default value of some registers

Shyam Prasad N (1):
      cifs: always iterate smb sessions using primary channel

Shyam Sundar S K (1):
      platform/x86/amd: pmc: Add new ACPI ID AMDI0009

Siarhei Volkau (4):
      ASoC: codecs: jz4725b: add missed Line In power control bit
      ASoC: codecs: jz4725b: fix reported volume for Master ctl
      ASoC: codecs: jz4725b: use right control for Capture Volume
      ASoC: codecs: jz4725b: fix capture selector naming

Simon Rettberg (1):
      drm/display: Don't assume dual mode adaptors support i2c sub-addressing

Steven Rostedt (Google) (3):
      tracing/ring-buffer: Have polling block on watermark
      tracing: Fix race where eprobes can be called before the event
      ring-buffer: Include dropped pages in counting dirty patches

Stylon Wang (2):
      drm/amd/display: Fix invalid DPIA AUX reply causing system hang
      drm/amd/display: Fix access timeout to DPIA AUX at boot time

Sven Peter (1):
      usb: typec: tipd: Prevent uninitialized event{1,2} in IRQ handler

Takashi Iwai (2):
      ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()
      ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Tetsuo Handa (2):
      Input: iforce - invert valid length check when fetching device IDs
      9p/trans_fd: always use O_NONBLOCK read/write

Thierry Reding (1):
      i2c: tegra: Allocate DMA memory for DMA engine

Tiago Dias Ferreira (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000

Tina Zhang (2):
      iommu/vt-d: Preset Access bit for IOVA in FL non-leaf paging entries
      iommu/vt-d: Set SRE bit only when hardware has SRS cap

Tony Lindgren (3):
      serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()
      serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()
      serial: 8250: omap: Flush PM QOS work on remove

Tony Luck (1):
      x86/cpu: Add several Intel server CPU model numbers

Ulf Hansson (1):
      arm64: dts: qcom: sm8250: Disable the not yet supported cluster idle state

Vasily Gorbik (1):
      s390: avoid using global register for current_stack_pointer

Vikas Gupta (2):
      bnxt_en: refactor bnxt_cancel_reservations()
      bnxt_en: fix the handling of PCIE-AER

Vladimir Oltean (2):
      net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
      net: dsa: don't leak tagger-owned storage on switch driver unbind

Wang ShaoBo (1):
      mISDN: fix misuse of put_device() in mISDN_register_device()

Wang Wensheng (2):
      ftrace: Fix the possible incorrect kernel message
      ftrace: Optimize the allocation for mcount entries

Wang Yufen (3):
      bpf: Fix memory leaks in __check_func_call
      netdevsim: Fix memory leak of nsim_dev->fa_cookie
      tracing: Fix memory leak in tracing_read_pipe()

Wei Yongjun (3):
      net: bgmac: Drop free_netdev() from bgmac_enet_remove()
      net: mhi: Fix memory leak in mhi_net_dellink()
      net/x25: Fix skb leak in x25_lapb_receive_frame()

Xiaolei Wang (2):
      ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK
      soc: imx8m: Enable OCOTP clock before reading the register

Xin Long (2):
      sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
      sctp: clear out_curr if all frag chunks of current msg are pruned

Xiongfeng Wang (1):
      mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Xiu Jianfeng (1):
      ftrace: Fix null pointer dereference in ftrace_add_mod()

Xiubo Li (1):
      ceph: avoid putting the realm twice when decoding snaps fails

Xu Kuohai (1):
      bpf: Initialize same number of free nodes for each pcpu_freelist

Yang Jihong (1):
      selftests/bpf: Fix test_progs compilation failure in 32-bit arch

Yang Yingliang (11):
      scsi: scsi_transport_sas: Fix error handling in sas_phy_add()
      siox: fix possible memory leak in siox_device_add()
      ata: libata-transport: fix double ata_host_put() in ata_tport_add()
      ata: libata-transport: fix error handling in ata_tport_add()
      ata: libata-transport: fix error handling in ata_tlink_add()
      ata: libata-transport: fix error handling in ata_tdev_add()
      mISDN: fix possible memory leak in mISDN_dsp_element_register()
      xen/pcpu: fix possible memory leak in register_pcpu()
      iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()
      iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()
      scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Yann Gautier (1):
      mmc: core: properly select voltage range without power cycle

Yi Yang (1):
      rethook: fix a potential memleak in rethook_alloc()

Yifan Zhang (1):
      drm/amdgpu: set fb_modifiers_not_supported in vkms

Yiqing Yao (1):
      drm/amdgpu: Adjust MES polling timeout for sriov

Yong Zhi (1):
      ASoC: Intel: sof_rt5682: Add quirk for Rex board

Yu Zhe (1):
      cxl/pmem: Use size_add() against integer overflow

Yuan Can (5):
      net: hinic: Fix error handling in hinic_module_init()
      net: ionic: Fix error handling in ionic_init_module()
      net: ena: Fix error handling in ena_init()
      net: thunderbolt: Fix error handling in tbnet_init()
      scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()

Zeng Heng (1):
      pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Zhang Qilong (4):
      ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"
      ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"
      ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"
      ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe

Zhang Xiaoxu (2):
      cifs: Fix connections leak when tlink setup failed
      cifs: Fix wrong return value checking when GETFLAGS

Zheng Bin (1):
      slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m

Zheng Yejian (1):
      tracing: Fix potential null-pointer-access of entry in list 'tr->err_log'

Zhengchao Shao (2):
      net: liquidio: release resources when liquidio driver open failed
      net: caif: fix double disconnect client in chnl_net_open()

Zhihao Cheng (1):
      dm bufio: Fix missing decrement of no_sleep_enabled if dm_bufio_client_create failed

Ziyang Xuan (4):
      octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()
      octeon_ep: ensure octep_get_link_status() successfully before octep_link_up()
      octeon_ep: fix potential memory leak in octep_device_setup()
      octeon_ep: ensure get mac address successfully before eth_hw_addr_set()

linkt (1):
      ASoC: amd: yc: Adding Lenovo ThinkBook 14 Gen 4+ ARA and Lenovo ThinkBook 16 Gen 4+ ARA to the Quirks List

Đoàn Trần Công Danh (1):
      speakup: replace utils' u_char with unsigned char

