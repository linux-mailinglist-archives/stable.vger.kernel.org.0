Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C154640B5F
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiLBQ4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiLBQzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09938DB683;
        Fri,  2 Dec 2022 08:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50E9DB8220E;
        Fri,  2 Dec 2022 16:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BADCC433D6;
        Fri,  2 Dec 2022 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670000125;
        bh=knOWs0xmg4/RA9akLigvBRbTquXWhta8R+eAbRo5/HM=;
        h=From:To:Cc:Subject:Date:From;
        b=GCrLZ9E2jdRuxZDtNVz6WUElJk0Jp9CouZknsQ5CPWxMUjy75k3+Z8Ovx/Xeb+MS2
         nRmUWOm6WpT5MfiOj7hCKmPjlPuX/QO73peMWuKwATNLkh/e+ARNkzz1/e4YL1S9S0
         iWoI3rp/dJUYhqKrIMtCSidJkgqbuZKt+Fqe/bLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.11
Date:   Fri,  2 Dec 2022 17:55:14 +0100
Message-Id: <16700001158223@kroah.com>
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

I'm announcing the release of the 6.0.11 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml   |    7 
 Makefile                                                            |    2 
 arch/arm/boot/dts/am335x-pcm-953.dtsi                               |   28 -
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi                         |    9 
 arch/arm/boot/dts/imx6q-prti6q.dts                                  |    4 
 arch/arm/mach-mxs/mach-mxs.c                                        |    4 
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts                 |    2 
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts                  |    7 
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts                  |    2 
 arch/arm64/include/asm/syscall_wrapper.h                            |    2 
 arch/loongarch/include/asm/pgtable.h                                |    8 
 arch/loongarch/kernel/process.c                                     |    9 
 arch/mips/include/asm/fw/fw.h                                       |    2 
 arch/mips/pic32/pic32mzda/early_console.c                           |   13 
 arch/mips/pic32/pic32mzda/init.c                                    |    2 
 arch/nios2/boot/Makefile                                            |    2 
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts                 |   38 +
 arch/riscv/kernel/vdso/Makefile                                     |    3 
 arch/riscv/kernel/vdso/vdso.lds.S                                   |    2 
 arch/s390/Kconfig                                                   |    6 
 arch/s390/Makefile                                                  |    2 
 arch/s390/boot/Makefile                                             |    3 
 arch/s390/boot/startup.c                                            |    3 
 arch/s390/kernel/crash_dump.c                                       |    2 
 arch/x86/hyperv/hv_init.c                                           |   54 +-
 arch/x86/include/asm/cpufeatures.h                                  |    3 
 arch/x86/kernel/cpu/tsx.c                                           |   38 -
 arch/x86/kvm/mmu/mmu.c                                              |   13 
 arch/x86/kvm/svm/nested.c                                           |    6 
 arch/x86/kvm/svm/svm.c                                              |   16 
 arch/x86/kvm/vmx/nested.c                                           |    3 
 arch/x86/kvm/x86.c                                                  |   18 
 arch/x86/kvm/xen.c                                                  |   32 +
 arch/x86/mm/ioremap.c                                               |    8 
 arch/x86/power/cpu.c                                                |   23 -
 block/bfq-cgroup.c                                                  |    4 
 block/blk-mq.c                                                      |    7 
 block/blk-settings.c                                                |    1 
 block/blk.h                                                         |    1 
 drivers/acpi/video_detect.c                                         |   14 
 drivers/android/binder_alloc.c                                      |    7 
 drivers/bus/intel-ixp4xx-eb.c                                       |    9 
 drivers/bus/sunxi-rsb.c                                             |   38 -
 drivers/cpufreq/Kconfig.x86                                         |    2 
 drivers/cpufreq/amd-pstate.c                                        |   21 
 drivers/dma-buf/dma-buf.c                                           |   23 -
 drivers/dma-buf/dma-heap.c                                          |   28 -
 drivers/fpga/Kconfig                                                |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c                |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c                    |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                      |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                             |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c                             |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                             |   16 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                              |   26 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h                              |   26 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c                           |    2 
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c                              |    6 
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h                      |   31 -
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm              |   27 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                   |   44 +-
 drivers/gpu/drm/amd/display/dc/dc.h                                 |    3 
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c             |    3 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c                  |  213 ++++------
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c               |    1 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c       |   11 
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c             |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c                |   22 -
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c      |    1 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.h |    2 
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c              |    8 
 drivers/gpu/drm/amd/display/dc/gpio/dcn32/hw_factory_dcn32.c        |   14 
 drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c                        |    9 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c             |   25 -
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c             |    4 
 drivers/gpu/drm/display/drm_dp_mst_topology.c                       |    2 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                      |   12 
 drivers/gpu/drm/i915/display/intel_display_power.c                  |    8 
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c                             |    4 
 drivers/gpu/drm/i915/gt/intel_gt.c                                  |    5 
 drivers/gpu/drm/i915/gvt/kvmgt.c                                    |    3 
 drivers/gpu/drm/tegra/drm.c                                         |    4 
 drivers/gpu/host1x/dev.c                                            |    4 
 drivers/hv/channel_mgmt.c                                           |    6 
 drivers/hv/vmbus_drv.c                                              |    1 
 drivers/iio/accel/bma400_core.c                                     |    4 
 drivers/iio/adc/aspeed_adc.c                                        |   11 
 drivers/iio/industrialio-sw-trigger.c                               |    6 
 drivers/iio/light/apds9960.c                                        |   12 
 drivers/input/misc/soc_button_array.c                               |   14 
 drivers/input/mouse/synaptics.c                                     |    1 
 drivers/input/serio/i8042-x86ia64io.h                               |    8 
 drivers/input/touchscreen/goodix.c                                  |   11 
 drivers/md/dm-integrity.c                                           |   21 
 drivers/md/dm-log-writes.c                                          |    1 
 drivers/net/arcnet/com20020_cs.c                                    |   11 
 drivers/net/bonding/bond_main.c                                     |   17 
 drivers/net/can/usb/gs_usb.c                                        |   39 -
 drivers/net/dsa/sja1105/sja1105_mdio.c                              |    6 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                   |   12 
 drivers/net/ethernet/cavium/liquidio/lio_main.c                     |    4 
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c                   |    4 
 drivers/net/ethernet/davicom/dm9051.c                               |    4 
 drivers/net/ethernet/engleder/tsnep_main.c                          |   57 ++
 drivers/net/ethernet/freescale/enetc/enetc.c                        |   32 -
 drivers/net/ethernet/freescale/enetc/enetc.h                        |   10 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c                    |   77 +--
 drivers/net/ethernet/intel/iavf/iavf.h                              |    1 
 drivers/net/ethernet/intel/iavf/iavf_main.c                         |   41 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                     |    8 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c             |    3 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c                 |    2 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c                 |    7 
 drivers/net/ethernet/marvell/prestera/prestera_main.c               |    1 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                         |   12 
 drivers/net/ethernet/mellanox/mlx4/qp.c                             |    3 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                       |   47 +-
 drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h       |   45 ++
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c           |   16 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h           |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                     |   17 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c                  |    9 
 drivers/net/ethernet/mellanox/mlx5/core/main.c                      |    9 
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c                |   88 ++++
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c               |   14 
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c                    |    2 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                |    3 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c                |    6 
 drivers/net/ethernet/qlogic/qla3xxx.c                               |    1 
 drivers/net/ethernet/sfc/ef100_netdev.c                             |    1 
 drivers/net/ipvlan/ipvlan.h                                         |    1 
 drivers/net/ipvlan/ipvlan_main.c                                    |    2 
 drivers/net/macsec.c                                                |   28 -
 drivers/net/phy/at803x.c                                            |    4 
 drivers/net/usb/cdc_ncm.c                                           |    1 
 drivers/net/usb/qmi_wwan.c                                          |    1 
 drivers/net/virtio_net.c                                            |    3 
 drivers/net/wireless/ath/ath11k/qmi.h                               |    2 
 drivers/net/wireless/cisco/airo.c                                   |   18 
 drivers/net/wireless/mac80211_hwsim.c                               |    5 
 drivers/net/wireless/microchip/wilc1000/cfg80211.c                  |   39 +
 drivers/net/wireless/microchip/wilc1000/hif.c                       |   21 
 drivers/net/wwan/iosm/iosm_ipc_coredump.c                           |    1 
 drivers/net/wwan/iosm/iosm_ipc_devlink.c                            |    1 
 drivers/net/wwan/iosm/iosm_ipc_pcie.c                               |    2 
 drivers/net/wwan/t7xx/t7xx_modem_ops.c                              |    2 
 drivers/nfc/st-nci/se.c                                             |   49 +-
 drivers/nvme/host/core.c                                            |    3 
 drivers/nvme/host/pci.c                                             |    2 
 drivers/nvme/target/configfs.c                                      |    7 
 drivers/pci/controller/pci-hyperv.c                                 |   90 +++-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c                             |    4 
 drivers/platform/surface/surface_aggregator_registry.c              |   37 +
 drivers/platform/x86/acer-wmi.c                                     |    9 
 drivers/platform/x86/asus-wmi.c                                     |    2 
 drivers/platform/x86/hp-wmi.c                                       |    3 
 drivers/platform/x86/ideapad-laptop.c                               |   62 ++
 drivers/platform/x86/intel/hid.c                                    |    3 
 drivers/platform/x86/intel/pmt/class.c                              |   31 +
 drivers/platform/x86/thinkpad_acpi.c                                |    8 
 drivers/platform/x86/touchscreen_dmi.c                              |   25 +
 drivers/power/supply/ab8500_btemp.c                                 |    9 
 drivers/power/supply/ip5xxx_power.c                                 |    2 
 drivers/regulator/core.c                                            |    8 
 drivers/regulator/rt5759-regulator.c                                |    1 
 drivers/regulator/twl6030-regulator.c                               |    2 
 drivers/s390/block/dasd_eckd.c                                      |    6 
 drivers/s390/crypto/ap_bus.c                                        |    5 
 drivers/s390/crypto/zcrypt_msgtype6.c                               |   21 
 drivers/scsi/ibmvscsi/ibmvfc.c                                      |   14 
 drivers/scsi/mpi3mr/mpi3mr_os.c                                     |    3 
 drivers/scsi/scsi_debug.c                                           |    7 
 drivers/scsi/scsi_transport_iscsi.c                                 |   31 -
 drivers/scsi/storvsc_drv.c                                          |   69 +--
 drivers/spi/spi-dw-dma.c                                            |    3 
 drivers/spi/spi-imx.c                                               |   13 
 drivers/spi/spi-stm32.c                                             |    2 
 drivers/spi/spi-tegra210-quad.c                                     |    9 
 drivers/tee/optee/device.c                                          |    2 
 drivers/tty/n_gsm.c                                                 |   69 +--
 drivers/tty/serial/8250/8250_omap.c                                 |    7 
 drivers/usb/cdns3/cdnsp-gadget.c                                    |   12 
 drivers/usb/cdns3/cdnsp-ring.c                                      |   17 
 drivers/usb/dwc3/dwc3-exynos.c                                      |   11 
 drivers/usb/dwc3/gadget.c                                           |   22 -
 drivers/virt/coco/sev-guest/sev-guest.c                             |   84 +++
 drivers/xen/platform-pci.c                                          |    7 
 drivers/xen/xen-pciback/conf_space_capability.c                     |    9 
 fs/btrfs/ioctl.c                                                    |   23 -
 fs/btrfs/sysfs.c                                                    |    7 
 fs/btrfs/tree-log.c                                                 |   59 ++
 fs/btrfs/zoned.c                                                    |    9 
 fs/ceph/caps.c                                                      |   50 --
 fs/cifs/cifsfs.c                                                    |    4 
 fs/cifs/sess.c                                                      |    4 
 fs/ext4/extents.c                                                   |   18 
 fs/fs-writeback.c                                                   |   30 -
 fs/fscache/volume.c                                                 |    7 
 fs/fuse/file.c                                                      |   37 -
 fs/nfsd/vfs.c                                                       |    7 
 fs/nilfs2/sufile.c                                                  |    8 
 fs/zonefs/super.c                                                   |   60 ++
 fs/zonefs/zonefs.h                                                  |    6 
 include/linux/blkdev.h                                              |    1 
 include/linux/bpf.h                                                 |   39 +
 include/linux/fault-inject.h                                        |    7 
 include/linux/fscache.h                                             |    2 
 include/linux/mlx5/driver.h                                         |    1 
 include/net/neighbour.h                                             |    2 
 include/sound/sof/info.h                                            |    4 
 include/uapi/linux/audit.h                                          |    2 
 init/Kconfig                                                        |    2 
 io_uring/filetable.c                                                |    2 
 io_uring/io_uring.h                                                 |    9 
 io_uring/poll.c                                                     |   49 +-
 kernel/bpf/dispatcher.c                                             |   22 -
 kernel/gcov/clang.c                                                 |    2 
 lib/Kconfig.debug                                                   |    1 
 lib/fault-inject.c                                                  |   13 
 lib/vdso/Makefile                                                   |    2 
 mm/damon/sysfs.c                                                    |    4 
 mm/failslab.c                                                       |   12 
 mm/memcontrol.c                                                     |    2 
 mm/page_alloc.c                                                     |    7 
 mm/vmscan.c                                                         |   24 -
 net/9p/trans_fd.c                                                   |    2 
 net/core/flow_dissector.c                                           |    2 
 net/core/neighbour.c                                                |   58 +-
 net/dccp/ipv4.c                                                     |    2 
 net/dccp/ipv6.c                                                     |    2 
 net/ipv4/Kconfig                                                    |   10 
 net/ipv4/esp4_offload.c                                             |    3 
 net/ipv4/fib_trie.c                                                 |    4 
 net/ipv4/inet_hashtables.c                                          |   10 
 net/ipv4/ip_input.c                                                 |    5 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                                  |    4 
 net/ipv4/tcp_ipv4.c                                                 |    2 
 net/ipv6/esp6_offload.c                                             |    3 
 net/ipv6/tcp_ipv6.c                                                 |    2 
 net/ipv6/xfrm6_policy.c                                             |    6 
 net/key/af_key.c                                                    |   34 +
 net/mac80211/main.c                                                 |    8 
 net/mac80211/mesh_pathtbl.c                                         |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                               |    2 
 net/netfilter/ipset/ip_set_hash_ip.c                                |    8 
 net/netfilter/nf_conntrack_core.c                                   |    2 
 net/netfilter/nf_conntrack_netlink.c                                |   24 -
 net/netfilter/nf_conntrack_standalone.c                             |    2 
 net/netfilter/nf_flow_table_offload.c                               |    4 
 net/netfilter/nf_tables_api.c                                       |    6 
 net/netfilter/nft_ct.c                                              |    6 
 net/netfilter/xt_connmark.c                                         |   18 
 net/nfc/nci/core.c                                                  |    2 
 net/nfc/nci/data.c                                                  |    4 
 net/openvswitch/conntrack.c                                         |    8 
 net/rxrpc/ar-internal.h                                             |    1 
 net/rxrpc/conn_client.c                                             |   38 +
 net/sched/Kconfig                                                   |    2 
 net/sched/act_connmark.c                                            |    4 
 net/sched/act_ct.c                                                  |    8 
 net/sched/act_ctinfo.c                                              |    6 
 net/tipc/discover.c                                                 |    5 
 net/tipc/topsrv.c                                                   |   20 
 net/wireless/util.c                                                 |    6 
 net/xfrm/xfrm_device.c                                              |   15 
 net/xfrm/xfrm_replay.c                                              |    2 
 sound/hda/intel-dsp-config.c                                        |    5 
 sound/soc/amd/yc/acp6x-mach.c                                       |    7 
 sound/soc/codecs/hdac_hda.h                                         |    4 
 sound/soc/codecs/max98373-i2c.c                                     |    4 
 sound/soc/codecs/sgtl5000.c                                         |    1 
 sound/soc/intel/boards/bytcht_es8316.c                              |    7 
 sound/soc/intel/boards/sof_es8336.c                                 |   60 ++
 sound/soc/intel/common/soc-acpi-intel-icl-match.c                   |   13 
 sound/soc/soc-pcm.c                                                 |    5 
 sound/soc/sof/ipc3-topology.c                                       |   15 
 sound/soc/stm/stm32_adfsdm.c                                        |   11 
 sound/usb/endpoint.c                                                |    3 
 sound/usb/quirks.c                                                  |    2 
 sound/usb/usbaudio.h                                                |    3 
 tools/iio/iio_generic_buffer.c                                      |    4 
 tools/testing/selftests/bpf/verifier/ref_tracking.c                 |   36 +
 tools/testing/selftests/net/io_uring_zerocopy_tx.sh                 |    2 
 tools/testing/selftests/net/mptcp/mptcp_join.sh                     |    6 
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh                  |    9 
 tools/testing/selftests/net/mptcp/simult_flows.sh                   |    5 
 tools/testing/selftests/net/udpgro.sh                               |    4 
 tools/testing/selftests/net/udpgro_bench.sh                         |    2 
 tools/testing/selftests/net/udpgro_frglist.sh                       |    2 
 virt/kvm/pfncache.c                                                 |    7 
 293 files changed, 2598 insertions(+), 1226 deletions(-)

Adrien Thierry (1):
      selftests/net: give more time to udpgro bg processes to complete startup

Ai Chao (1):
      ALSA: usb-audio: add quirk to fix Hamedal C20 disconnect issue

Alejandro Concepción Rodríguez (1):
      iio: light: apds9960: fix wrong register for gesture gain

Aleksandr Miloserdov (1):
      nvmet: fix memory leak in nvmet_subsys_attr_model_store_locked

Alex Deucher (2):
      drm/amdgpu/psp: don't free PSP buffers on suspend
      drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"

Alexandre Belloni (1):
      init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash

Alvin Lee (2):
      drm/amd/display: Add debug option for allocating extra way for cursor
      drm/amd/display: Update MALL SS NumWays calculation

Aman Dhoot (1):
      Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Anand Jain (3):
      btrfs: free btrfs_path before copying inodes to userspace
      btrfs: free btrfs_path before copying fspath to userspace
      btrfs: free btrfs_path before copying subvol info to userspace

Andreas Kemnade (1):
      regulator: twl6030: re-add TWL6032_SUBCLASS

Andrzej Hajda (1):
      drm/i915: fix TLB invalidation for Gen12 video and compute engines

Aneesh Kumar K.V (1):
      mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1

Anjana Hari (1):
      pinctrl: qcom: sc8280xp: Rectify UFS reset pins

Arnav Rawat (1):
      platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops

Asher Song (1):
      Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""

Aurabindo Pillai (1):
      drm/amd/display: Zeromem mypipe heap struct before using it

Baokun Li (1):
      ext4: fix use-after-free in ext4_ext_shift_extents

Bart Van Assche (1):
      scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC

Billy Tsai (2):
      iio: adc: aspeed: Remove the trim valid dts property.
      dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"

Brent Mendelsohn (1):
      ASoC: amd: yc: Add Alienware m17 R5 AMD into DMI table

Brian King (1):
      scsi: ibmvfc: Avoid path failures during live migration

Carlos Llamas (1):
      binder: validate alloc->mm in ->mmap() handler

Chaitanya Dhere (1):
      drm/amd/display: Fix FCLK deviation and tool compile issues

Chen Zhongjin (3):
      xfrm: Fix ignored return value in xfrm6_init()
      iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails
      nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Chen-Yu Tsai (1):
      arm64: dts: rockchip: Fix Pine64 Quartz4-B PMIC interrupt

ChenXiaoSong (1):
      cifs: fix missing unlock in cifs_file_copychunk_range()

Chris Mi (1):
      net/mlx5e: Offload rule only when all encaps are valid

Christian König (1):
      drm/amdgpu: always register an MMU notifier for userptr

Christian Langrock (1):
      xfrm: replay: Fix ESN wrap around for GSO

Christoph Hellwig (3):
      blk-mq: fix queue reference leak on blk_mq_alloc_disk_for_queue failure
      btrfs: zoned: fix missing endianness conversion in sb_write_pointer
      btrfs: use kvcalloc in btrfs_get_dev_zone_info

Chuck Lever (1):
      NFSD: Fix reads with a non-zero offset that don't end on a page boundary

Damien Le Moal (2):
      zonefs: Fix active zone accounting
      zonefs: fix zone report size in __zonefs_io_error()

Dan Carpenter (1):
      cifs: Use after free in debug code

Daniel Xu (1):
      netfilter: conntrack: Fix data-races around ct mark

David Belanger (1):
      drm/amdgpu: Enable SA software trap.

David E. Box (1):
      platform/x86/intel/pmt: Sapphire Rapids PMT errata fix

David Howells (2):
      rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]
      fscache: fix OOB Read in __fscache_acquire_volume

David Woodhouse (3):
      KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
      KVM: x86/xen: Validate port number in SCHEDOP_poll
      KVM: Update gfn_to_pfn_cache khva when it moves within the same page

Dawei Li (1):
      dma-buf: fix racing conflict of dma_heap_add()

Detlev Casanova (1):
      ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Dexuan Cui (1):
      PCI: hv: Only reuse existing IRTE allocation for Multi-MSI

Diana Wang (1):
      nfp: fill splittable of devlink_port_attrs correctly

Dillon Varone (2):
      drm/amd/display: use uclk pstate latency for fw assisted mclk validation dcn32
      drm/amd/display: Update soc bounding box for dcn32/dcn321

Dominik Haller (1):
      ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Dong Chenchen (1):
      iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()

Emil Renner Berthing (1):
      riscv: dts: sifive unleashed: Add PWM controlled LEDs

Enrico Sau (1):
      net: usb: qmi_wwan: add Telit 0x103a composition

Eric Huang (1):
      drm/amdkfd: Fix a memory limit issue

Eyal Birger (1):
      xfrm: fix "disable_policy" on ipv4 early demux

Fabio Estevam (1):
      ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties

Fedor Pchelkin (2):
      Revert "tty: n_gsm: avoid call of sleeping functions from atomic context"
      Revert "tty: n_gsm: replace kicktimer with delayed_work"

Felix Fietkau (1):
      netfilter: flowtable_offload: add missing locking

Filipe Manana (1):
      btrfs: do not modify log tree while holding a leaf from fs tree locked

Frieder Schrempf (1):
      spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Gaosheng Cui (1):
      audit: fix undefined behavior in bit shift for AUDIT_BIT

George Shen (1):
      drm/amd/display: Fix calculation for cursor CAB allocation

Gerhard Engleder (1):
      tsnep: Fix rotten packets

Gleb Mazovetskiy (1):
      tcp: configurable source port perturb table size

Greg Kroah-Hartman (2):
      lib/vdso: use "grep -E" instead of "egrep"
      Linux 6.0.11

Guchun Chen (1):
      drm/amdgpu: disable BACO support on more cards

Hamza Mahfooz (1):
      drm/amd/display: only fill dirty rectangles when PSR is enabled

Hangbin Liu (1):
      bonding: fix ICMPv6 header handling when receiving IPv6 messages

Hanjun Guo (1):
      net: wwan: t7xx: Fix the ACPI memory leak

Hans de Goede (10):
      ACPI: video: Add backlight=native DMI quirk for Dell G15 5515
      platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1
      drm: panel-orientation-quirks: Add quirk for Nanote UMPC-01
      drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
      ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01
      Input: goodix - try resetting the controller when no config is set
      Input: soc_button_array - add use_low_level_irq module parameter
      Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
      platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)
      platform/x86: ideapad-laptop: Add module parameters to match DMI quirk tables

Harald Freudenberger (1):
      s390/zcrypt: fix warning about field-spanning write

Heiko Carstens (2):
      s390: always build relocatable kernel
      s390/crashdump: fix TOD programmable field size

Herbert Xu (1):
      af_key: Fix send_acquire race with pfkey_register

Huacai Chen (2):
      LoongArch: Clear FPU/SIMD thread info flags for kernel thread
      LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()

Hui Tang (1):
      net: mvpp2: fix possible invalid pointer dereference

Imre Deak (1):
      drm/i915: Fix warn in intel_display_power_*_domain() functions

Ivan Hu (1):
      platform/x86/intel/hid: Add some ACPI device IDs

Ivan Vecera (2):
      iavf: Fix a crash during reset task
      iavf: Do not restart Tx queues after reset task failure

Jack Xiao (1):
      drm/amd/amdgpu: reserve vm invalidation engine for firmware

Jaco Coetzee (1):
      nfp: add port from netdev validation for EEPROM access

Jakob Unterwurzacher (1):
      arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Jason A. Donenfeld (2):
      wifi: airo: do not assign -1 to unsigned char
      MIPS: pic32: treat port as signed integer

Jason Ekstrand (1):
      dma-buf: Use dma_fence_unwrap_for_each when importing fences

Jay Cornwall (1):
      drm/amdkfd: update GFX11 CWSR trap handler

Jens Axboe (1):
      io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available

Jiasheng Jiang (2):
      ASoC: max98373: Add checks for devm_kcalloc
      octeontx2-pf: Add check for devm_kcalloc

Johannes Weiner (1):
      mm: vmscan: fix extreme overreclaim and swap floods

Jon Hunter (1):
      spi: tegra210-quad: Don't initialise DMA if not supported

Jonas Jelonek (1):
      wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Josef Bacik (1):
      btrfs: free btrfs_path before copying root refs to userspace

Jozsef Kadlecsik (1):
      netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface

Junxiao Chang (1):
      ASoC: hdac_hda: fix hda pcm buffer overflow issue

Kai Vehmanen (1):
      ASoC: SOF: ipc3-topology: use old pipeline teardown flow with SOF2.1 and older

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Smart Experience App event

Kazuki Takiguchi (1):
      KVM: x86/mmu: Fix race condition in direct_page_fault

Keith Busch (4):
      nvme: quiet user passthrough command errors
      block: make blk_set_default_limits() private
      dm-integrity: set dma_alignment limit in io_hints
      dm-log-writes: set dma_alignment limit in io_hints

Kenneth Lee (1):
      ceph: Use kcalloc for allocating multiple elements

Krishna Yarlagadda (1):
      spi: tegra210-quad: Fix duplicate resource error

Kuniyuki Iwashima (2):
      arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.
      dccp/tcp: Reset saddr on failure after inet6?_hash_connect().

Lee, Alvin (1):
      drm/amd/display: Added debug option for forcing subvp num ways

Lennard Gäher (1):
      platform/x86: thinkpad_acpi: Enable s2idle quirk for 21A1 machine type

Leon Romanovsky (1):
      net: liquidio: simplify if expression

Lev Popov (1):
      arm64: dts: rockchip: fix quartz64-a bluetooth configuration

Li Hua (1):
      test_kprobes: fix implicit declaration error of test_kprobes

Li Liguang (1):
      mm: correctly charge compressed memory to its memcg

Li Zetao (1):
      virtio_net: Fix probe failed when modprobe virtio_net

Lin Ma (3):
      nfc/nci: fix race with opening and closing
      io_uring/filetable: fix file reference underflow
      io_uring/poll: fix poll_refs race with cancelation

Linus Walleij (2):
      power: supply: ab8500: Defer thermal zone probe
      bus: ixp4xx: Don't touch bit 7 on IXP42x

Liu Jian (2):
      net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
      net: sparx5: fix error handling in sparx5_port_open()

Liu Shixin (1):
      NFC: nci: fix memory leak in nci_rx_data_packet()

Lukas Wunner (1):
      serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Lyude Paul (2):
      drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code
      drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

M Chetan Kumar (1):
      net: wwan: iosm: fix kernel test robot reported errors

Mahesh Bandewar (1):
      ipvlan: hold lower dev to avoid possible use-after-free

Manyi Li (1):
      platform/x86: ideapad-laptop: Disable touchpad_switch

Marc Kleine-Budde (1):
      spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first

Marek Marczykowski-Górecki (1):
      xen-pciback: Allow setting PCI_MSIX_FLAGS_MASKALL too

Marek Szyprowski (1):
      usb: dwc3: exynos: Fix remove() function

Martin Faltesek (3):
      nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
      nfc: st-nci: fix memory leaks in EVT_TRANSACTION
      nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION

Matthew Auld (1):
      drm/i915/ttm: never purge busy objects

Matthieu Baerts (2):
      selftests: mptcp: run mptcp_sockopt from a new netns
      selftests: mptcp: fix mibit vs mbit mix up

Matti Vaittinen (1):
      tools: iio: iio_generic_buffer: Fix read size

Maxim Levitsky (5):
      KVM: x86: nSVM: leave nested mode on vCPU free
      KVM: x86: forcibly leave nested mode on vCPU reset
      KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
      KVM: x86: add kvm_leave_nested
      KVM: x86: remove exit_int_info warning in svm_handle_exit

Maximilian Luz (2):
      platform/surface: aggregator_registry: Add support for Surface Pro 9
      platform/surface: aggregator_registry: Add support for Surface Laptop 5

Michael Grzeschik (2):
      ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl
      usb: dwc3: gadget: conditionally remove requests

Michael Kelley (2):
      scsi: storvsc: Fix handling of srb_status and capacity change events
      x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Miklos Szeredi (1):
      fuse: lock inode unconditionally in fuse_fallocate()

Mikulas Patocka (2):
      dm integrity: flush the journal on suspend
      dm integrity: clear the journal on suspend

Moshe Shemesh (4):
      net/mlx5: Fix FW tracer timestamp calculation
      net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint
      net/mlx5: Fix handling of entry refcount when command is not issued to FW
      net/mlx5: Fix sync reset event handler error flow

Mukesh Ojha (1):
      gcov: clang: fix the buffer overflow issue

Nathan Chancellor (2):
      RISC-V: vdso: Do not add missing symbols to version section in linker script
      bpf: Add explicit cast to 'void *' for __BPF_DISPATCHER_UPDATE()

Nicolas Cavallari (1):
      wifi: mac80211: Fix ack frame idr leak when mesh has no route

Olivier Moysan (1):
      ASoC: stm32: dfsdm: manage cb buffers cleanup

Ondrej Jirman (1):
      power: supply: ip5xxx: Fix integer overflow in current_now calculation

Pablo Neira Ayuso (1):
      netfilter: nf_tables: do not set up extensions for end interval

Paolo Abeni (1):
      selftests: mptcp: gives slow test-case more time

Paul Zhang (1):
      wifi: cfg80211: Fix bitrates overflow issue

Pavel Begunkov (4):
      selftests/net: don't tests batched TCP io_uring zc
      io_uring/poll: lockdep annote io_poll_req_insert_locked
      io_uring: cmpxchg for poll arm refs release
      io_uring: make poll refs more robust

Pawan Gupta (2):
      x86/tsx: Add a feature bit for TSX control MSR support
      x86/pm: Add enumeration check before spec MSRs save/restore setup

Pawel Laszczak (2):
      usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
      usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1

Perry Yuan (1):
      cpufreq: amd-pstate: change amd-pstate driver to be built-in type

Peter Gonda (1):
      virt/sev-guest: Prevent IV reuse in the SNP guest driver

Peter Kosyh (1):
      net/mlx4: Check retval of mlx4_bitmap_init

Peter Zijlstra (1):
      bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

Phil Turnbull (4):
      wifi: wilc1000: validate pairwise and authentication suite offsets
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
      wifi: wilc1000: validate number of channels

Philip Yang (1):
      drm/amdgpu: Drop eviction lock when allocating PT BO

Pierre-Louis Bossart (2):
      ASoC: Intel: soc-acpi: add ES83x6 support to IceLake
      ASoC: hda: intel-dsp-config: add ES83x6 quirk for IceLake

Qi Zheng (1):
      mm: fix unexpected changes to {failslab|fail_page_alloc}.attr

Ramesh Errabolu (1):
      drm/amdgpu: Enable Aldebaran devices to report CU Occupancy

Randy Dunlap (1):
      nios2: add FORCE for vmlinuz.gz

Richard Fitzgerald (1):
      ASoC: soc-pcm: Don't zero TDM masks in __soc_pcm_open()

Robin Murphy (1):
      gpu: host1x: Avoid trying to use GART on Tegra20

Roi Dayan (1):
      net/mlx5: E-Switch, Set correctly vport destination

Roy Novich (1):
      net/mlx5: Do not query pci info while pci disabled

Russ Weight (1):
      fpga: m10bmc-sec: Fix kconfig dependencies

Sabrina Dubroca (1):
      Revert "net: macsec: report real_dev features when HW offloading is enabled"

Samuel Holland (2):
      bus: sunxi-rsb: Remove the shutdown callback
      bus: sunxi-rsb: Support atomic transfers

Santiago Ruano Rincón (1):
      net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP

Sean Christopherson (1):
      drm/i915/gvt: Get reference to KVM iff attachment to VM is successful

Sean Nyekjaer (1):
      spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

SeongJae Park (1):
      mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed

Shay Drory (1):
      net/mlx5: SF: Fix probing active SFs during driver probe phase

Shin'ichiro Kawasaki (1):
      scsi: mpi3mr: Suppress command reply debug prints

Slawomir Laba (1):
      iavf: Fix race condition between iavf_shutdown and iavf_remove

Stefan Assmann (1):
      iavf: remove INITIAL_MAC_SET to allow gARP to work properly

Stefan Haberland (1):
      s390/dasd: fix no record found for raw_track_access

Steve Su (1):
      drm/amd/display: Fix gpio port mapping issue

Svyatoslav Feldsherov (1):
      fs: do not update freeing inode i_io_list

Takashi Iwai (1):
      Input: i8042 - apply probe defer to more ASUS ZenBook models

Thinh Nguyen (2):
      usb: dwc3: gadget: Return -ESHUTDOWN on ep disable
      usb: dwc3: gadget: Clear ep descriptor last

Thomas Jarosch (1):
      xfrm: Fix oops in __xfrm_state_delete()

Thomas Zeitlhofer (1):
      net: neigh: decrement the family specific qlen

Tsung-hua Lin (1):
      drm/amd/display: No display after resume from WB/CB

Tyler J. Stachecki (1):
      wifi: ath11k: Fix QCN9074 firmware boot on x86

Vasanth Sadhasivan (1):
      can: gs_usb: remove dma allocations

Vishwanath Pai (1):
      netfilter: ipset: regression in ip_set_hash_ip.c

Vitaly Kuznetsov (1):
      x86/hyperv: Restore VP assist page after cpu offlining/onlining

Vladimir Oltean (3):
      net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
      net: enetc: cache accesses to &priv->si->hw
      net: enetc: preserve TX ring priority across reconfiguration

Wang Hai (2):
      net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
      arcnet: fix potential memory leak in com20020_probe()

Wang ShaoBo (1):
      net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()

Wei Yongjun (2):
      net: phy: at803x: fix error return code in at803x_probe()
      s390/ap: fix memory leak in ap_init_qci_info()

Wyes Karny (1):
      cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init

Xin Long (3):
      tipc: set con sock in tipc_conn_alloc
      tipc: add an extra conn_get in tipc_conn_alloc
      net: sched: allow act_ct to be built without NF_NAT

Xiongfeng Wang (3):
      spi: dw-dma: decrease reference count in dw_spi_dma_init_mfld()
      octeontx2-af: Fix reference count issue in rvu_sdp_init()
      platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

Xiubo Li (1):
      ceph: fix NULL pointer dereference for req->r_session

Yan Cangang (1):
      net: ethernet: mtk_eth_soc: fix resource leak in error path

Yang Yingliang (8):
      regulator: rt5759: fix OOB in validate_desc()
      regulator: core: fix UAF in destroy_regulator()
      tee: optee: fix possible memory leak in optee_register_device()
      octeontx2-af: debugsfs: fix pci device refcount leak
      net: pch_gbe: fix pci device refcount leak while module exiting
      Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
      Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()
      bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Youlin Li (1):
      selftests/bpf: Add verifier test for release_reference()

Yu Kuai (1):
      block, bfq: fix null pointer dereference in bfq_bio_bfqg()

Yu Liao (1):
      net: thunderx: Fix the ACPI memory leak

Yuan Can (1):
      net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()

YueHaibing (2):
      macsec: Fix invalid error code set
      tipc: check skb_linearize() return value in tipc_disc_rcv()

Zeng Heng (1):
      regulator: core: fix kobject release warning and memory leak in regulator_register()

Zhang Changzhong (3):
      net/qla3xxx: fix potential memleak in ql3xxx_send()
      sfc: fix potential memleak in __ef100_hard_start_xmit()
      net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()

Zhang Xiaoxu (1):
      zonefs: Fix race between modprobe and mount

Zhen Lei (1):
      btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()

Zheng Yongjun (1):
      ARM: mxs: fix memory leak in mxs_machine_init()

Zhengchao Shao (1):
      9p/fd: fix issue of list_del corruption in p9_fd_cancel()

Zhou Guanghui (1):
      scsi: iscsi: Fix possible memory leak when device_register() failed

Zhu Ning (1):
      ASoC: sof_es8336: reduce pop noise on speaker

Ziyang Xuan (2):
      net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
      ipv4: Fix error return code in fib_table_insert()

ruanjinjie (1):
      xen/platform-pci: add missing free_irq() in error path

taozhang (1):
      wifi: mac80211: fix memory free error when registering wiphy fail

