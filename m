Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DF93889E5
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 10:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhESIzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 04:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233441AbhESIzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 04:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE20561059;
        Wed, 19 May 2021 08:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621414426;
        bh=qHJRmsdneZLH0fIqj1G3kt6MdRjmBKUxHzjWWLhQqvg=;
        h=From:To:Cc:Subject:Date:From;
        b=ogd6n5w1BVAaEbw4X6joW5k1iUVbkU6crg8eN0ODEbGF6YN8w1o5cQTaO08xKdjfr
         7xjPzU1mWLRYe/IGL6Quj2b5cGDt/mz0rjI7JihibHzIgWinhlDi68lwmhTRSj8+Cy
         KRig24oefN02CeS9PBeF51Ly/pu00cCMxeZZShbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.22
Date:   Wed, 19 May 2021 10:53:41 +0200
Message-Id: <162141437223831@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note, this is the LAST 5.11.y release, this branch is now end-of-life.

Everyone should move to the 5.12.y tree at this point in time.

---------------------------------------

I'm announcing the release of the 5.11.22 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 .gitignore                                                       |    1 
 Documentation/devicetree/bindings/media/renesas,vin.yaml         |   46 
 Documentation/devicetree/bindings/pci/rcar-pci-host.yaml         |   12 
 Documentation/devicetree/bindings/serial/8250.yaml               |    5 
 Documentation/devicetree/bindings/thermal/rcar-gen3-thermal.yaml |   43 
 Documentation/dontdiff                                           |    1 
 Makefile                                                         |    4 
 arch/arc/include/asm/page.h                                      |   12 
 arch/arc/include/asm/pgtable.h                                   |   12 
 arch/arc/include/uapi/asm/page.h                                 |    1 
 arch/arc/kernel/entry.S                                          |    4 
 arch/arc/mm/init.c                                               |   11 
 arch/arc/mm/ioremap.c                                            |    5 
 arch/arc/mm/tlb.c                                                |    2 
 arch/arm/boot/dts/dra7-l4.dtsi                                   |    4 
 arch/arm/boot/dts/dra7.dtsi                                      |   20 
 arch/arm/kernel/hw_breakpoint.c                                  |    2 
 arch/arm64/include/asm/daifflags.h                               |    3 
 arch/arm64/kernel/entry-common.c                                 |   17 
 arch/arm64/kernel/entry.S                                        |   85 -
 arch/arm64/mm/flush.c                                            |    4 
 arch/arm64/mm/proc.S                                             |   12 
 arch/ia64/include/asm/module.h                                   |    6 
 arch/ia64/kernel/module.c                                        |   29 
 arch/mips/include/asm/div64.h                                    |   55 -
 arch/mips/kernel/cpu-probe.c                                     |    3 
 arch/powerpc/kernel/head_32.h                                    |    6 
 arch/powerpc/kernel/iommu.c                                      |    4 
 arch/powerpc/kernel/setup_32.c                                   |    2 
 arch/powerpc/kernel/smp.c                                        |    6 
 arch/powerpc/lib/feature-fixups.c                                |   35 
 arch/powerpc/mm/book3s64/hash_utils.c                            |   13 
 arch/powerpc/platforms/pseries/hotplug-cpu.c                     |    3 
 arch/powerpc/sysdev/xive/common.c                                |    9 
 arch/powerpc/sysdev/xive/native.c                                |    6 
 arch/powerpc/sysdev/xive/xive-internal.h                         |    1 
 arch/riscv/kernel/smp.c                                          |    2 
 arch/sh/kernel/traps.c                                           |    1 
 arch/x86/include/asm/idtentry.h                                  |   15 
 arch/x86/include/asm/kvm_host.h                                  |    4 
 arch/x86/include/asm/processor.h                                 |    2 
 arch/x86/kernel/cpu/amd.c                                        |   16 
 arch/x86/kernel/nmi.c                                            |   10 
 arch/x86/kernel/smpboot.c                                        |    2 
 arch/x86/kvm/cpuid.c                                             |    3 
 arch/x86/kvm/emulate.c                                           |    2 
 arch/x86/kvm/kvm_emulate.h                                       |    1 
 arch/x86/kvm/lapic.c                                             |    2 
 arch/x86/kvm/mmu/mmu.c                                           |   49 
 arch/x86/kvm/svm/sev.c                                           |    3 
 arch/x86/kvm/svm/svm.c                                           |    2 
 arch/x86/kvm/vmx/nested.c                                        |   29 
 arch/x86/kvm/vmx/vmx.c                                           |   30 
 arch/x86/kvm/x86.c                                               |   40 
 block/bfq-iosched.c                                              |    3 
 block/blk-iocost.c                                               |   14 
 block/blk-mq-sched.c                                             |    8 
 block/blk-mq.c                                                   |   11 
 block/kyber-iosched.c                                            |    5 
 block/mq-deadline.c                                              |    3 
 drivers/acpi/device_pm.c                                         |    1 
 drivers/acpi/scan.c                                              |    1 
 drivers/ata/ahci_brcm.c                                          |   46 
 drivers/base/power/runtime.c                                     |   10 
 drivers/block/nbd.c                                              |    3 
 drivers/block/rnbd/rnbd-clt.c                                    |   12 
 drivers/block/rnbd/rnbd-clt.h                                    |    2 
 drivers/bluetooth/btusb.c                                        |    4 
 drivers/char/tpm/tpm2-cmd.c                                      |    1 
 drivers/char/tpm/tpm_tis_core.c                                  |   22 
 drivers/clk/samsung/clk-exynos7.c                                |    7 
 drivers/clocksource/timer-ti-dm-systimer.c                       |  144 ++
 drivers/cpufreq/acpi-cpufreq.c                                   |    6 
 drivers/cpufreq/intel_pstate.c                                   |   14 
 drivers/crypto/ccp/sev-dev.c                                     |    4 
 drivers/dma/idxd/cdev.c                                          |  129 --
 drivers/dma/idxd/device.c                                        |   25 
 drivers/dma/idxd/dma.c                                           |   77 +
 drivers/dma/idxd/idxd.h                                          |   89 +
 drivers/dma/idxd/init.c                                          |  350 ++++---
 drivers/dma/idxd/irq.c                                           |   10 
 drivers/dma/idxd/sysfs.c                                         |  324 ++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c                           |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c           |    1 
 drivers/gpu/drm/amd/display/dc/core/dc.c                         |    4 
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c                |   15 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c              |    2 
 drivers/gpu/drm/i915/display/intel_overlay.c                     |    2 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                         |    2 
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c                             |    1 
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c                     |    4 
 drivers/gpu/drm/i915/i915_active.c                               |    3 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                            |    9 
 drivers/gpu/drm/msm/dp/dp_audio.c                                |    1 
 drivers/gpu/drm/msm/dp/dp_display.c                              |   26 
 drivers/gpu/drm/msm/dp/dp_display.h                              |    1 
 drivers/gpu/drm/radeon/radeon.h                                  |    1 
 drivers/gpu/drm/radeon/radeon_atombios.c                         |   26 
 drivers/gpu/drm/radeon/radeon_pm.c                               |    8 
 drivers/gpu/drm/radeon/si_dpm.c                                  |    3 
 drivers/hwmon/ltc2992.c                                          |    8 
 drivers/hwmon/occ/common.c                                       |    5 
 drivers/hwmon/occ/common.h                                       |    2 
 drivers/hwtracing/coresight/coresight-platform.c                 |    6 
 drivers/i2c/busses/i2c-imx.c                                     |    2 
 drivers/i2c/busses/i2c-mt65xx.c                                  |    9 
 drivers/i2c/i2c-dev.c                                            |    9 
 drivers/iio/accel/Kconfig                                        |    1 
 drivers/iio/common/hid-sensors/Kconfig                           |    1 
 drivers/iio/gyro/Kconfig                                         |    1 
 drivers/iio/gyro/mpu3050-core.c                                  |   13 
 drivers/iio/humidity/Kconfig                                     |    1 
 drivers/iio/industrialio-core.c                                  |    9 
 drivers/iio/light/Kconfig                                        |    2 
 drivers/iio/light/gp2ap002.c                                     |    5 
 drivers/iio/light/tsl2583.c                                      |    8 
 drivers/iio/magnetometer/Kconfig                                 |    1 
 drivers/iio/orientation/Kconfig                                  |    2 
 drivers/iio/pressure/Kconfig                                     |    1 
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c                |    1 
 drivers/iio/temperature/Kconfig                                  |    1 
 drivers/infiniband/hw/hfi1/ipoib.h                               |    3 
 drivers/infiniband/hw/hfi1/ipoib_tx.c                            |   14 
 drivers/iommu/amd/init.c                                         |   49 
 drivers/net/can/m_can/m_can.c                                    |    3 
 drivers/net/can/spi/mcp251x.c                                    |   35 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                   |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |   19 
 drivers/net/ethernet/cisco/enic/enic_main.c                      |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                  |  127 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                  |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c               |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c           |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h           |    3 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c          |   27 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c           |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c          |    2 
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h                |    6 
 drivers/net/ethernet/intel/i40e/i40e_client.c                    |    1 
 drivers/net/ethernet/intel/i40e/i40e_common.c                    |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                   |    7 
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                      |    8 
 drivers/net/ethernet/intel/i40e/i40e_type.h                      |    7 
 drivers/net/ethernet/intel/iavf/iavf_main.c                      |    2 
 drivers/net/ethernet/intel/ice/ice_lib.c                         |  123 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h                        |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                      |    2 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h                      |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                  |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c              |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                |    1 
 drivers/net/ipa/gsi.c                                            |    4 
 drivers/net/ipa/gsi_reg.h                                        |   18 
 drivers/net/wireless/ath/ath11k/wmi.c                            |   53 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                    |   35 
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c             |    4 
 drivers/net/wireless/intel/iwlwifi/queue/tx.c                    |   30 
 drivers/net/wireless/intel/iwlwifi/queue/tx.h                    |    3 
 drivers/net/wireless/mediatek/mt76/mt76.h                        |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c               |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                  |   97 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c                 |   18 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                  |   12 
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c                |    4 
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c               |   19 
 drivers/net/wireless/mediatek/mt76/mt7915/init.c                 |   58 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c                 |   25 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                  |   27 
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h                 |   13 
 drivers/net/wireless/microchip/wilc1000/netdev.c                 |   25 
 drivers/net/wireless/quantenna/qtnfmac/event.c                   |    6 
 drivers/net/wireless/realtek/rtw88/main.h                        |    2 
 drivers/net/wireless/realtek/rtw88/phy.c                         |   14 
 drivers/net/wireless/realtek/rtw88/phy.h                         |    1 
 drivers/net/wireless/realtek/rtw88/reg.h                         |    5 
 drivers/net/wireless/realtek/rtw88/rtw8822c.c                    |   27 
 drivers/net/wireless/wl3501.h                                    |   47 
 drivers/net/wireless/wl3501_cs.c                                 |   54 -
 drivers/nvme/host/core.c                                         |    3 
 drivers/nvme/target/io-cmd-bdev.c                                |   10 
 drivers/nvme/target/nvmet.h                                      |   16 
 drivers/nvme/target/passthru.c                                   |    2 
 drivers/nvme/target/rdma.c                                       |    4 
 drivers/pci/controller/pcie-brcmstb.c                            |   19 
 drivers/pci/controller/pcie-iproc-msi.c                          |    2 
 drivers/pci/endpoint/functions/pci-epf-test.c                    |   18 
 drivers/pci/endpoint/pci-epc-core.c                              |   42 
 drivers/pci/pcie/rcec.c                                          |    2 
 drivers/pci/probe.c                                              |    1 
 drivers/pinctrl/samsung/pinctrl-exynos.c                         |   10 
 drivers/pwm/pwm-atmel.c                                          |    2 
 drivers/remoteproc/pru_rproc.c                                   |   41 
 drivers/remoteproc/qcom_q6v5_mss.c                               |   18 
 drivers/rpmsg/qcom_glink_native.c                                |    1 
 drivers/rtc/rtc-ds1307.c                                         |   12 
 drivers/rtc/rtc-fsl-ftm-alarm.c                                  |    1 
 drivers/scsi/qla2xxx/qla_init.c                                  |    3 
 drivers/scsi/ufs/ufshcd.c                                        |    7 
 drivers/soc/mediatek/mt8173-pm-domains.h                         |   10 
 drivers/soc/mediatek/mt8183-pm-domains.h                         |   15 
 drivers/soc/mediatek/mt8192-pm-domains.h                         |   21 
 drivers/soc/mediatek/mtk-pm-domains.c                            |    6 
 drivers/soc/mediatek/mtk-pm-domains.h                            |    2 
 drivers/staging/media/rkvdec/rkvdec.c                            |    2 
 drivers/thermal/qcom/tsens.c                                     |    6 
 drivers/thermal/thermal_of.c                                     |    7 
 drivers/usb/class/cdc-wdm.c                                      |   30 
 drivers/usb/core/hub.c                                           |    6 
 drivers/usb/dwc2/core.h                                          |    2 
 drivers/usb/dwc2/gadget.c                                        |    3 
 drivers/usb/dwc3/dwc3-omap.c                                     |    5 
 drivers/usb/dwc3/dwc3-pci.c                                      |    1 
 drivers/usb/dwc3/gadget.c                                        |   11 
 drivers/usb/host/fotg210-hcd.c                                   |    4 
 drivers/usb/host/xhci-ext-caps.h                                 |    5 
 drivers/usb/host/xhci-pci.c                                      |    8 
 drivers/usb/host/xhci.c                                          |    6 
 drivers/usb/musb/mediatek.c                                      |    2 
 drivers/usb/typec/tcpm/tcpm.c                                    |    6 
 drivers/usb/typec/ucsi/ucsi.c                                    |   46 
 drivers/usb/typec/ucsi/ucsi.h                                    |    6 
 drivers/xen/gntdev.c                                             |    4 
 drivers/xen/unpopulated-alloc.c                                  |    4 
 fs/9p/vfs_file.c                                                 |    4 
 fs/btrfs/ctree.h                                                 |    2 
 fs/btrfs/file.c                                                  |   36 
 fs/btrfs/inode.c                                                 |    4 
 fs/btrfs/ioctl.c                                                 |    2 
 fs/btrfs/qgroup.c                                                |    2 
 fs/btrfs/send.c                                                  |    4 
 fs/btrfs/tree-log.c                                              |    3 
 fs/ceph/export.c                                                 |    4 
 fs/dax.c                                                         |   35 
 fs/debugfs/inode.c                                               |    2 
 fs/dlm/config.c                                                  |   86 +
 fs/dlm/config.h                                                  |    1 
 fs/dlm/debug_fs.c                                                |    1 
 fs/dlm/lockspace.c                                               |   20 
 fs/dlm/lowcomms.c                                                |  104 +-
 fs/dlm/lowcomms.h                                                |    5 
 fs/dlm/midcomms.c                                                |    7 
 fs/ext4/fast_commit.c                                            |    2 
 fs/f2fs/compress.c                                               |   55 -
 fs/f2fs/data.c                                                   |    6 
 fs/f2fs/f2fs.h                                                   |    7 
 fs/f2fs/file.c                                                   |   42 
 fs/f2fs/gc.c                                                     |   62 -
 fs/f2fs/inline.c                                                 |    3 
 fs/f2fs/segment.c                                                |   86 +
 fs/f2fs/segment.h                                                |   14 
 fs/f2fs/super.c                                                  |    2 
 fs/fuse/cuse.c                                                   |    2 
 fs/fuse/file.c                                                   |    9 
 fs/fuse/virtio_fs.c                                              |    3 
 fs/hfsplus/extents.c                                             |    7 
 fs/hugetlbfs/inode.c                                             |    5 
 fs/jbd2/recovery.c                                               |    5 
 fs/nfs/callback_proc.c                                           |   17 
 fs/nfs/dir.c                                                     |   22 
 fs/nfs/flexfilelayout/flexfilelayout.c                           |    2 
 fs/nfs/inode.c                                                   |    8 
 fs/nfs/nfs42proc.c                                               |   31 
 fs/nfs/nfs4proc.c                                                |   56 -
 fs/nfsd/nfs4state.c                                              |   24 
 fs/proc/generic.c                                                |    2 
 fs/squashfs/file.c                                               |    6 
 include/linux/cpuhotplug.h                                       |    1 
 include/linux/elevator.h                                         |    2 
 include/linux/i2c.h                                              |    2 
 include/linux/mm.h                                               |   32 
 include/linux/mm_types.h                                         |    4 
 include/linux/nfs_xdr.h                                          |   11 
 include/linux/pci-epc.h                                          |    6 
 include/linux/pci-epf.h                                          |    1 
 include/linux/pm.h                                               |    1 
 include/net/page_pool.h                                          |   12 
 include/trace/events/sunrpc.h                                    |    1 
 include/uapi/linux/netfilter/xt_SECMARK.h                        |    6 
 kernel/dma/swiotlb.c                                             |    3 
 kernel/kexec_file.c                                              |    4 
 kernel/resource.c                                                |    4 
 kernel/sched/core.c                                              |    2 
 kernel/sched/fair.c                                              |   12 
 kernel/watchdog.c                                                |   40 
 lib/kobject_uevent.c                                             |    9 
 lib/nlattr.c                                                     |    2 
 lib/test_kasan.c                                                 |   29 
 mm/gup.c                                                         |   94 -
 mm/hugetlb.c                                                     |   11 
 mm/khugepaged.c                                                  |   18 
 mm/ksm.c                                                         |    1 
 mm/migrate.c                                                     |    7 
 mm/shmem.c                                                       |   34 
 net/bluetooth/hci_event.c                                        |    2 
 net/bluetooth/l2cap_core.c                                       |    4 
 net/bluetooth/l2cap_sock.c                                       |    8 
 net/bluetooth/mgmt.c                                             |    1 
 net/bridge/br_arp_nd_proxy.c                                     |    4 
 net/core/flow_dissector.c                                        |    6 
 net/core/page_pool.c                                             |   12 
 net/ethtool/ioctl.c                                              |    2 
 net/ethtool/netlink.c                                            |    3 
 net/ipv6/ip6_vti.c                                               |    2 
 net/mac80211/mlme.c                                              |   12 
 net/mac80211/tx.c                                                |   20 
 net/mptcp/subflow.c                                              |    3 
 net/netfilter/nf_tables_api.c                                    |    4 
 net/netfilter/nfnetlink_osf.c                                    |    2 
 net/netfilter/nft_set_hash.c                                     |   10 
 net/netfilter/xt_SECMARK.c                                       |   88 +
 net/sched/cls_flower.c                                           |   36 
 net/sched/sch_taprio.c                                           |    6 
 net/sctp/sm_make_chunk.c                                         |    2 
 net/sctp/sm_statefuns.c                                          |   28 
 net/smc/af_smc.c                                                 |    4 
 net/sunrpc/clnt.c                                                |   12 
 net/sunrpc/svc.c                                                 |    3 
 net/sunrpc/svcsock.c                                             |    2 
 net/sunrpc/xprt.c                                                |   12 
 net/sunrpc/xprtrdma/frwr_ops.c                                   |    2 
 net/sunrpc/xprtrdma/rpc_rdma.c                                   |    3 
 net/sunrpc/xprtrdma/transport.c                                  |    6 
 net/sunrpc/xprtrdma/verbs.c                                      |   10 
 net/sunrpc/xprtrdma/xprt_rdma.h                                  |    2 
 net/tipc/netlink_compat.c                                        |    2 
 net/xdp/xsk_queue.h                                              |    7 
 samples/bpf/tracex1_kern.c                                       |    4 
 scripts/Makefile.modpost                                         |   15 
 scripts/kconfig/nconf.c                                          |    2 
 scripts/mod/modpost.c                                            |   15 
 security/keys/trusted-keys/trusted_tpm1.c                        |    8 
 sound/firewire/bebob/bebob_stream.c                              |   12 
 sound/pci/hda/ideapad_s740_helper.c                              |  492 ++++++++++
 sound/pci/hda/patch_hdmi.c                                       |    4 
 sound/pci/hda/patch_realtek.c                                    |   11 
 sound/pci/rme9652/hdsp.c                                         |    3 
 sound/pci/rme9652/hdspm.c                                        |    3 
 sound/pci/rme9652/rme9652.c                                      |    3 
 sound/soc/codecs/rt286.c                                         |   23 
 sound/soc/codecs/rt5670.c                                        |   12 
 sound/soc/intel/boards/bytcr_rt5640.c                            |   20 
 sound/soc/intel/boards/sof_sdw.c                                 |   11 
 sound/soc/sh/rcar/core.c                                         |   69 +
 sound/soc/sh/rcar/ssi.c                                          |   16 
 sound/soc/soc-compress.c                                         |    4 
 sound/usb/quirks-table.h                                         |   63 +
 tools/lib/bpf/ringbuf.c                                          |   30 
 tools/perf/Makefile.config                                       |    1 
 tools/perf/util/Build                                            |    7 
 tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh    |    3 
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh        |    4 
 tools/testing/selftests/lib.mk                                   |    4 
 tools/testing/selftests/net/forwarding/mirror_lib.sh             |   19 
 tools/testing/selftests/net/mptcp/diag.sh                        |   55 -
 tools/testing/selftests/net/mptcp/mptcp_connect.sh               |   15 
 tools/testing/selftests/net/mptcp/mptcp_join.sh                  |   22 
 tools/testing/selftests/net/mptcp/simult_flows.sh                |   13 
 tools/testing/selftests/powerpc/security/entry_flush.c           |    2 
 tools/testing/selftests/powerpc/security/flush_utils.h           |    4 
 tools/testing/selftests/powerpc/security/rfi_flush.c             |    2 
 virt/kvm/kvm_main.c                                              |    7 
 361 files changed, 4207 insertions(+), 1966 deletions(-)

Abhijeet Rao (1):
      xhci-pci: Allow host runtime PM as default for Intel Alder Lake xHCI

Alex Elder (1):
      net: ipa: fix inter-EE IRQ register definitions

Alexander Aring (8):
      fs: dlm: fix debugfs dump
      fs: dlm: fix mark setting deadlock
      fs: dlm: add errno handling to check callback
      fs: dlm: add check if dlm is currently running
      fs: dlm: change allocation limits
      fs: dlm: check on minimum msglen size
      fs: dlm: flush swork on shutdown
      fs: dlm: add shutdown hook

Alexandru Ardelean (2):
      iio: hid-sensors: select IIO_TRIGGERED_BUFFER under HID_SENSOR_IIO_TRIGGER
      iio: core: return ENODEV if ioctl is unknown

Alexey Kardashevskiy (1):
      powerpc/iommu: Annotate nested lock for lockdep

Anastasia Kovaleva (1):
      scsi: qla2xxx: Prevent PRLI in target mode

Andy Shevchenko (2):
      hwmon: (ltc2992) Put fwnode in error case during ->probe()
      usb: typec: ucsi: Put fwnode in any case during ->probe()

Anthony Wang (1):
      drm/amd/display: Force vsync flip when reconfiguring MPCC

Anup Patel (1):
      RISC-V: Fix error code returned by riscv_hartid_to_cpuid()

Archie Pusaka (2):
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
      Bluetooth: check for zapped sk before connecting

Arnd Bergmann (1):
      ext4: fix debug format string warning

Axel Rasmussen (1):
      userfaultfd: release page in error path to avoid BUG_ON

Ayush Garg (1):
      Bluetooth: Fix incorrect status handling in LE PHY UPDATE event

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Fix error while calculating PPS out values

Baptiste Lepers (1):
      sunrpc: Fix misplaced barrier in call_decode

Bart Van Assche (1):
      blk-mq: Swap two calls in blk_mq_exit_queue()

Bence Csókás (1):
      i2c: Add I2C_AQ_NO_REP_START adapter quirk

Benjamin Segall (1):
      kvm: exit halt polling on need_resched() as well

Bjorn Andersson (1):
      remoteproc: qcom_q6v5_mss: Validate p_filesz in ELF loader

Brendan Jackman (1):
      libbpf: Fix signed overflow in ringbuf_process_ring

Can Guo (3):
      scsi: ufs: core: Do not put UFS power into LPM if link is broken
      scsi: ufs: core: Cancel rpm_dev_flush_recheck_work during system suspend
      scsi: ufs: core: Narrow down fast path in system suspend path

Catalin Marinas (1):
      arm64: Fix race condition on PG_dcache_clean in __sync_icache_dcache()

Chaitanya Kulkarni (3):
      nvmet: add lba to sect conversion helpers
      nvmet: fix inline bio check for bdev-ns
      nvmet: fix inline bio check for passthru

Chao Yu (10):
      f2fs: fix to allow migrating fully valid segment
      f2fs: fix panic during f2fs_resize_fs()
      f2fs: fix to align to section for fallocate() on pinned file
      f2fs: fix to update last i_size if fallocate partially succeeds
      f2fs: fix to avoid touching checkpointed data in get_victim()
      f2fs: fix to cover __allocate_new_section() with curseg_lock
      f2fs: fix to avoid accessing invalid fio in f2fs_allocate_data_block()
      f2fs: compress: fix to free compress page correctly
      f2fs: compress: fix race condition of overwrite vs truncate
      f2fs: compress: fix to assign cc.cluster_idx correctly

Chris Dion (1):
      SUNRPC: Handle major timeout in xprt_adjust_timeout()

Christoph Hellwig (1):
      nvme: do not try to reconfigure APST when the controller is not live

Christophe JAILLET (4):
      usb: fotg210-hcd: Fix an error message
      usb: musb: Fix an error message
      ACPI: scan: Fix a memory leak in an error handling path
      xhci: Do not use GFP_KERNEL in (potentially) atomic context

Christophe Leroy (1):
      powerpc/32: Statically initialise first emergency context

Chuck Lever (5):
      SUNRPC: Move fault injection call sites
      SUNRPC: Remove trace_xprt_transmit_queued
      xprtrdma: Avoid Receive Queue wrapping
      xprtrdma: Fix cwnd update ordering
      xprtrdma: rpcrdma_mr_pop() already does list_del_init()

Chunfeng Yun (1):
      usb: core: hub: fix race condition about TRSMRCY of resume

Claire Chang (1):
      swiotlb: Fix the type of index

Colin Ian King (5):
      KEYS: trusted: Fix memory leak on object td
      f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
      dmaengine: idxd: Fix potential null dereference on pointer status
      fs/proc/generic.c: fix incorrect pde_is_permanent check
      iio: tsl2583: Fix division by a zero lux_val

Cong Wang (1):
      smc: disallow TCP_ULP in smc_setsockopt()

Cédric Le Goater (1):
      powerpc/xive: Use the "ibm, chip-id" property only under PowerNV

Dan Carpenter (1):
      SUNRPC: fix ternary sign expansion bug in tracing

Daniel Winkler (1):
      Bluetooth: Do not set cur_adv_instance in adv param MGMT request

Dave Jiang (9):
      dmaengine: idxd: fix dma device lifetime
      dmaengine: idxd: cleanup pci interrupt vector allocation management
      dmaengine: idxd: removal of pcim managed mmio mapping
      dmaengine: idxd: use ida for device instance enumeration
      dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime
      dmaengine: idxd: fix wq conf_dev 'struct device' lifetime
      dmaengine: idxd: fix engine conf_dev lifetime
      dmaengine: idxd: fix group conf_dev lifetime
      dmaengine: idxd: fix cdev setup and free device lifetime issues

David Bauer (1):
      mt76: mt76x0: disable GTK offloading

David Hildenbrand (2):
      kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources
      kernel/resource: make walk_mem_res() find all busy IORESOURCE_MEM resources

David Matlack (1):
      kvm: Cap halt polling at kvm->max_halt_poll_ns

David Mosberger-Tang (1):
      wilc1000: Bring MAC address setting in line with typical Linux behavior

David Ward (3):
      ASoC: rt286: Generalize support for ALC3263 codec
      ASoC: rt286: Make RT286_SET_GPIO_* readable and writable
      drm/amd/display: Initialize attribute for hdcp_srm sysfs file

Dingchen (David) Zhang (1):
      drm/amd/display: add handling for hdcp2 rx id list validation

Dinghao Liu (2):
      iio: light: gp2ap002: Fix rumtime PM imbalance on error
      iio: proximity: pulsedlight: Fix rumtime PM imbalance on error

Dmitry Baryshkov (1):
      PCI: Release OF node in pci_scan_device()'s error path

Dmitry Osipenko (1):
      iio: gyro: mpu3050: Fix reported temperature value

Du Cheng (1):
      net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule

Eddie James (1):
      hwmon: (occ) Fix poll rate limiting

Emmanuel Grumbach (2):
      mac80211: clear the beacon's CRC after channel switch
      mac80211: properly drop the connection in case of invalid CSA IE

Enric Balletbo i Serra (3):
      soc: mediatek: pm-domains: Add a meaningful power domain name
      soc: mediatek: pm-domains: Add a power domain names for mt8183
      soc: mediatek: pm-domains: Add a power domain names for mt8192

Eric Dumazet (3):
      ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
      netfilter: nftables: avoid overflows in nft_hash_buckets()
      sh: Remove unused variable

Fabio Estevam (1):
      media: rkvdec: Remove of_match_ptr()

Felix Fietkau (4):
      mt76: mt7615: fix key set/delete issues
      mt76: mt7915: fix key set/delete issue
      mt76: mt7615: fix entering driver-own state on mt7663
      net: ethernet: mtk_eth_soc: fix RX VLAN offload

Fernando Fernandez Mancera (1):
      ethtool: fix missing NLM_F_MULTI flag when dumping

Ferry Toth (1):
      usb: dwc3: pci: Enable usb2-gadget-lpm-disable for Intel Merrifield

Filipe Manana (2):
      btrfs: fix deadlock when cloning inline extents and using qgroups
      btrfs: fix race leading to unpersisted data and metadata on fsync

Frieder Schrempf (1):
      can: mcp251x: fix resume from sleep before interface was brought up

Geert Uytterhoeven (2):
      dt-bindings: media: renesas,vin: Make resets optional on R-Car Gen1
      dt-bindings: PCI: rcar-pci-host: Document missing R-Car H1 support

Greg Kroah-Hartman (2):
      kobject_uevent: remove warning in init_uevent_argv()
      Linux 5.11.22

Guangbin Huang (1):
      net: hns3: remediate a potential overflow risk of bd_num_list

Guangqing Zhu (1):
      thermal/drivers/tsens: Fix missing put_device error

Gustavo A. R. Silva (5):
      sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
      flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
      ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Gyeongtaek Lee (1):
      ASoC: soc-compress: lock pcm_mutex to resolve lockdep error

Hans de Goede (3):
      ASoC: Intel: bytcr_rt5640: Enable jack-detect support on Asus T100TAF
      ASoC: Intel: bytcr_rt5640: Add quirk for the Chuwi Hi8 tablet
      ASoC: rt5670: Add a quirk for the Dell Venue 10 Pro 5055

Hao Chen (1):
      net: hns3: fix for vxlan gpe tx checksum bug

Hoang Le (1):
      tipc: convert dest node's address to network order

Huang Rui (1):
      x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen generations

J. Bruce Fields (1):
      nfsd: ensure new clients break delegations

Jack Pham (3):
      usb: dwc3: gadget: Free gadget structure only after freeing endpoints
      usb: dwc3: gadget: Enable suspend events
      usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4

Jarkko Sakkinen (2):
      tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()
      tpm, tpm_tis: Reserve locality in tpm_tis_resume()

Jaroslaw Gawin (1):
      i40e: fix the restart auto-negotiation after FEC modified

Jeff Layton (1):
      ceph: fix inode leak on getattr error in __fh_to_dentry

Jia-Ju Bai (3):
      thermal: thermal_of: Fix error return code of thermal_of_populate_bind_params()
      rpmsg: qcom_glink_native: fix error return code of qcom_glink_rx_data()
      kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

Jian Shen (1):
      net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()

Jim Quinlan (2):
      ata: ahci_brcm: Fix use of BCM7216 reset controller
      PCI: brcmstb: Use reset/rearm instead of deassert/assert

Jinzhou Su (1):
      drm/amdgpu: Add mem sync flag for IB allocated by SA

Jiri Olsa (1):
      perf tools: Fix dynamic libbpf link

Johan Almbladh (1):
      mac80211: Set priority and queue mapping for injected frames

Johannes Berg (1):
      iwlwifi: pcie: make cfg vs. trans_cfg more robust

Jonathan Marek (1):
      drm/msm: fix LLC not being enabled for mmu500 targets

Jonathan McDowell (1):
      net: stmmac: Set FIFO sizes for ipq806x

Jouni Roivas (1):
      hfsplus: prevent corruption in shrinking truncate

Juergen Gross (1):
      xen/gntdev: fix gntdev_mmap() error exit path

Kai Vehmanen (1):
      ALSA: hda/hdmi: fix race in handling acomp ELD notification at resume

Kai-Heng Feng (1):
      drm/radeon/dpm: Disable sclk switching on Oland when two 4K 60Hz monitors are connected

Kees Cook (3):
      drm/radeon: Fix off-by-one power_state index heap overwrite
      drm/radeon: Avoid power table parsing memory leaks
      debugfs: Make debugfs_allow RO after init

Kishon Vijay Abraham I (3):
      PCI: endpoint: Make *_get_first_free_bar() take into account 64 bit BAR
      PCI: endpoint: Add helper API to get the 'next' unreserved BAR
      PCI: endpoint: Make *_free_bar() to return error codes on failure

Krzysztof Kozlowski (1):
      pinctrl: samsung: use 'int' for register masks in Exynos

Kuninori Morimoto (2):
      ASoC: rsnd: call rsnd_ssi_master_clk_start() from rsnd_ssi_init()
      ASoC: rsnd: check all BUSIF status when error

Kuogee Hsieh (2):
      drm/msm/dp: initialize audio_comp when audio starts
      drm/msm/dp: check sink_count before update is_connected status

Lai Jiangshan (1):
      KVM/VMX: Invoke NMI non-IST entry instead of IST entry

Lee Gibson (1):
      qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

Lorenzo Bianconi (1):
      mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req

Lv Yunlong (2):
      ethernet:enic: Fix a use after free bug in enic_hard_start_xmit
      drm/i915/gt: Fix a double free in gen8_preallocate_top_level_pdp

Maciej W. Rozycki (3):
      MIPS: Reinstate platform `__div64_32' handler
      MIPS: Avoid DIVU in `__div64_32' is result would be zero
      MIPS: Avoid handcoded DIVU in `__div64_32' altogether

Maciej Żenczykowski (1):
      net: fix nla_strcmp to handle more then one trailing null character

Magnus Karlsson (1):
      i40e: fix broken XDP support

Marc Kleine-Budde (2):
      can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
      can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

Marc Zyngier (1):
      arm64: entry: factor irq triage logic into macros

Marcel Hamer (1):
      usb: dwc3: omap: improve extcon initialization

Mark Rutland (1):
      arm64: entry: always set GIC_PRIO_PSR_I_SET during entry

Masahiro Yamada (1):
      kbuild: generate Module.symvers only when vmlinux exists

Mateusz Palczewski (1):
      i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Matthew Wilcox (Oracle) (1):
      mm: fix struct page layout on 32-bit systems

Matthieu Baerts (1):
      selftests: mptcp: launch mptcp_connect with timeout

Maxim Mikityanskiy (1):
      net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath

Maximilian Luz (1):
      usb: xhci: Increase timeout for HC halt

Md Haris Iqbal (2):
      block/rnbd-clt: Change queue_depth type in rnbd_clt_session to size_t
      block/rnbd-clt: Check the return value of the function rtrs_clt_query

Miaohe Lin (4):
      khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
      mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
      mm/migrate.c: fix potential indeterminate pte entry in migrate_vma_insert_page()
      ksm: fix potential missing rmap_item for stable_node

Michael Chan (1):
      bnxt_en: Add PCI IDs for Hyper-V VF devices.

Michael Ellerman (3):
      powerpc/pseries: Stop calling printk in rtas_stop_self()
      powerpc/64s: Fix crashes when toggling stf barrier
      powerpc/64s: Fix crashes when toggling entry flush barrier

Michael Walle (1):
      rtc: fsl-ftm-alarm: add MODULE_TABLE()

Michal Kalderon (1):
      nvmet-rdma: Fix NULL deref when SEND is completed with error

Mihai Moldovan (1):
      kconfig: nconf: stop endless search loops

Mike Marciniszyn (1):
      IB/hfi1: Correct oversized ring allocation

Mikhail Durnev (1):
      ASoC: rsnd: core: Check convert rate in rsnd_hw_params

Miklos Szeredi (2):
      virtiofs: fix userns
      cuse: prevent clone

Ming Lei (1):
      blk-mq: plug request for shared sbitmap

Mordechay Goodstein (1):
      iwlwifi: queue: avoid memory leak in reset flow

Nagendra S Tomar (1):
      nfs: Subsequent READDIR calls should carry non-zero cookieverifier

Nicolas MURE (1):
      ALSA: usb-audio: Add Pioneer DJM-850 to quirks-table

Niklas Söderlund (1):
      dt-bindings: thermal: rcar-gen3-thermal: Support five TSC nodes on r8a779a0

Nikola Livic (1):
      pNFS/flexfiles: fix incorrect size check in decode_nfs_fh()

Nikolay Aleksandrov (1):
      net: bridge: when suppression is enabled exclude RARP packets

Nobuhiro Iwamatsu (1):
      rtc: ds1307: Fix wday settings for rx8130

Odin Ugedal (1):
      sched/fair: Fix unfairness caused by missing load decay

Olga Kornievskaia (1):
      NFSv4.2 fix handling of sr_eof in SEEK's reply

Oliver Neukum (1):
      cdc-wdm: untangle a circular dependency between callback and softint

Omar Sandoval (1):
      kyber: fix out of bounds access when preempted

Pablo Neira Ayuso (3):
      netfilter: xt_SECMARK: add new revision to fix structure layout
      netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
      netfilter: nftables: Fix a memleak from userdata error path in new objects

Pali Rohár (1):
      PCI: iproc: Fix return value of iproc_msi_irq_domain_alloc()

Paolo Abeni (1):
      mptcp: fix splat when closing unaccepted socket

Paul M Stillwell Jr (1):
      ice: handle increasing Tx or Rx ring sizes

Paul Menzel (1):
      Revert "iommu/amd: Fix performance counter initialization"

Pavel Tatashin (3):
      mm/gup: check every subpage of a compound page during isolation
      mm/gup: return an error on migration failure
      mm/gup: check for isolation errors

Paweł Chmiel (1):
      clk: exynos7: Mark aclk_fsys1_200 as critical

Peng Li (1):
      net: hns3: use netif_tx_disable to stop the transmit queue

Peter Collingbourne (2):
      kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
      arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup

Peter Xu (1):
      mm/hugetlb: fix F_SEAL_FUTURE_WRITE

Petr Machata (2):
      selftests: mlxsw: Increase the tolerance of backlog buildup
      selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test

Petr Mladek (4):
      watchdog: rename __touch_watchdog() to a better descriptive name
      watchdog: explicitly update timestamp when reporting softlockup
      watchdog/softlockup: remove logic that tried to prevent repeated reports
      watchdog: fix barriers when printing backtraces from all CPUs

Phil Elwell (1):
      usb: dwc2: Fix gadget DMA unmap direction

Phillip Lougher (1):
      squashfs: fix divide error in calculate_skip()

Po-Hao Huang (1):
      rtw88: 8822c: add LC calibration for RTL8822C

Pradeep Kumar Chitrapu (1):
      ath11k: fix thermal temperature read

Qii Wang (1):
      i2c: mediatek: Fix send master code at more than 1MHz

Qiuxu Zhuo (1):
      PCI/RCEC: Fix RCiEP device to RCEC association

Quentin Perret (1):
      sched: Fix out-of-bound access in uclamp

Rafael J. Wysocki (1):
      cpufreq: intel_pstate: Use HWP if enabled by platform firmware

Ramesh Babu B (1):
      net: stmmac: Clear receive all(RA) bit when promiscuous mode is off

Robin Singh (1):
      drm/amd/display: fixed divide by zero kernel crash during dsc enablement

Russell Currey (1):
      selftests/powerpc: Fix L1D flushing tests for Power10

Ryder Lee (1):
      mt76: mt7915: add wifi subsystem reset

Sandeep Singh (1):
      xhci: Add reset resume quirk for AMD xhci controller.

Sander Vanheule (1):
      mt76: mt7615: support loading EEPROM for MT7613BE

Sean Christopherson (6):
      KVM: x86/mmu: Remove the defunct update_pte() paging hook
      crypto: ccp: Free SEV device if SEV init fails
      KVM: x86: Emulate RDPID only if RDTSCP is supported
      KVM: x86: Move RDPID emulation intercept to its own enum
      KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is unsupported
      KVM: VMX: Disable preemption when probing user return MSRs

Sergei Trofimovich (1):
      ia64: module: fix symbolizer crash on fdescr

Shayne Chen (1):
      mt76: mt7915: fix txpower init for TSSI off chips

Shradha Todi (1):
      PCI: endpoint: Fix NULL pointer dereference for ->get_features()

Srikar Dronamraju (1):
      powerpc/smp: Set numa node before updating mask

Stefan Assmann (1):
      iavf: remove duplicate free resources calls

Stéphane Marchesin (1):
      drm/i915: Fix crash in auto_retire

Suman Anna (3):
      remoteproc: pru: Fixup interrupt-parent logic for fw events
      remoteproc: pru: Fix wrong success return value for fw events
      remoteproc: pru: Fix and cleanup firmware interrupt mapping logic

Sumeet Pawnikar (1):
      ACPI: PM: Add ACPI ID of Alder Lake Fan

Sun Ke (1):
      nbd: Fix NULL pointer in flush_workqueue

Suravee Suthikulpanit (1):
      iommu/amd: Remove performance counter pre-initialization test

Suzuki K Poulose (1):
      coresight: Do not scan for graph if none is present

Takashi Iwai (1):
      ALSA: hda/realtek: Add quirk for Lenovo Ideapad S740

Takashi Sakamoto (1):
      ALSA: bebob: enable to deliver MIDI messages for multiple ports

Tejun Heo (1):
      blk-iocost: fix weight updates of inner active iocgs

Tetsuo Handa (1):
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Thomas Gleixner (2):
      KVM: x86: Cancel pvclock_gtod_work on module removal
      KVM: x86: Prevent deadlock against tk_core.seq

Tiezhu Yang (1):
      MIPS: Loongson64: Use _CACHE_UNCACHED instead of _CACHE_UNCACHED_ACCELERATED

Tom Lendacky (1):
      KVM: SVM: Make sure GHCB is mapped before updating

Tomasz Duszynski (1):
      iio: core: fix ioctl handlers removal

Tong Zhang (3):
      ALSA: hdsp: don't disable if not enabled
      ALSA: hdspm: don't disable if not enabled
      ALSA: rme9652: don't disable if not enabled

Tony Lindgren (3):
      PM: runtime: Fix unpaired parent child_count for force_resume
      clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
      clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940

Trond Myklebust (7):
      NFS: Fix handling of cookie verifier in uncached_readdir()
      NFS: Only change the cookie verifier if the directory page cache is empty
      NFS: nfs4_bitmask_adjust() must not change the server global bitmasks
      NFS: Fix attribute bitmask in _nfs42_proc_fallocate()
      NFSv4.2: Always flush out writes in nfs42_proc_fallocate()
      NFS: Deal correctly with attribute generation counter overflow
      NFSv4.x: Don't return NFS4ERR_NOMATCHING_LAYOUT if we're unmounting

Tvrtko Ursulin (1):
      drm/i915/overlay: Fix active retire callback alignment

Uwe Kleine-König (1):
      pwm: atmel: Fix duty cycle calculation in .get_state()

Vaibhav Jain (1):
      powerpc/mm: Add cond_resched() while removing hpte mappings

Vamshi Krishna Gopal (1):
      ASoC: Intel: sof_sdw: add quirk for new ADL-P Rvp

Ville Syrjälä (2):
      drm/i915: Avoid div-by-zero on gen2
      drm/i915: Read C0DRB3/C1DRB3 as 16 bits again

Vineet Gupta (1):
      ARC: entry: fix off-by-one error in syscall number validation

Vitaly Kuznetsov (1):
      KVM: nVMX: Always make an attempt to map eVMCS after migration

Vivek Goyal (4):
      fuse: invalidate attrs when page writeback completes
      dax: Add an enum for specifying dax wakup mode
      dax: Add a wakeup mode parameter to put_unlocked_entry()
      dax: Wake up all waiters after invalidating dax entry

Vladimir Isaev (2):
      ARC: mm: PAE: use 40-bit physical page mask
      ARC: mm: Use max_high_pfn as a HIGHMEM zone border

Vladimir Oltean (1):
      net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports

Wanpeng Li (1):
      KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer

Wesley Cheng (1):
      usb: dwc3: gadget: Return success always for kick transfer in ep queue

Wolfram Sang (1):
      i2c: bail out early when RDWR parameters are wrong

Xin Long (2):
      sctp: do asoc update earlier in sctp_sf_do_dupcook_a
      sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

Xuan Zhuo (1):
      xsk: Fix for xp_aligned_validate_desc() when len == chunk_size

Yang Yingliang (2):
      fs: 9p: fix v9fs_file_open writeback fid error check
      PCI: endpoint: Fix missing destroy_workqueue()

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Ye Weihua (1):
      i2c: imx: Fix PM reference leak in i2c_imx_reg_slave()

Yi Zhuang (1):
      f2fs: Fix a hungtask problem in atomic write

Yonghong Song (1):
      selftests: Set CC to clang in lib.mk if LLVM is set

Yufeng Mo (3):
      net: hns3: fix incorrect configuration for igu_egu_hw_err
      net: hns3: initialize the message content in hclge_get_link_mode()
      net: hns3: disable phy loopback setting in hclge_mac_start_phy

Yunjian Wang (2):
      SUNRPC: Fix null pointer dereference in svc_rqst_free()
      i40e: Fix use-after-free in i40e_client_subtask()

Yunsheng Lin (1):
      net: hns3: add handling for xmit skb with recursive fraglist

Zhen Lei (4):
      tpm: fix error return code in tpm2_get_cc_attrs_tbl()
      ARM: 9064/1: hw_breakpoint: Do not directly check the event's overflow_handler hook
      xen/unpopulated-alloc: fix error return code in fill_list()
      dt-bindings: serial: 8250: Remove duplicated compatible strings

Zheng Yongjun (1):
      dma: idxd: use DEFINE_MUTEX() for mutex lock

mark-yw.chen (1):
      Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.

