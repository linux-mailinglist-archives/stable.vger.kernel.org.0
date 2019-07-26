Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0776121
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 10:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGZIqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 04:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfGZIqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 04:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329992086D;
        Fri, 26 Jul 2019 08:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564130787;
        bh=G9GDyw2A21/Vwo19mWwqN1x3t6FEPvN6dLFsnCLOS6o=;
        h=Date:From:To:Cc:Subject:From;
        b=yBm5n9m3omt7ySSOO+2OPgzcN6eJF1juiszG9j2q1EXYlUwIBpsLyemS+OlTQgZUf
         y7yMJJ7ohuXl+GLIuvN5HLlzlROz07qJCLmlIMm4LE603zbGkVxUBrQtkdpgiTQHC+
         fVjsGHYQWLTCgUCk0CIEcmzCMtRW6Zys3WjAkDlY=
Date:   Fri, 26 Jul 2019 10:46:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.20
Message-ID: <20190726084625.GA29704@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.20 kernel.

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

 Documentation/atomic_t.txt                                   |    3=20
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |    2=20
 Documentation/scheduler/sched-pelt.c                         |    3=20
 Makefile                                                     |    2=20
 arch/arm/boot/dts/gemini-dlink-dir-685.dts                   |    2=20
 arch/arm64/Kconfig                                           |    3=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi               |    3=20
 arch/arm64/boot/dts/nvidia/tegra210.dtsi                     |    2=20
 arch/arm64/crypto/sha1-ce-glue.c                             |    2=20
 arch/arm64/crypto/sha2-ce-glue.c                             |    2=20
 arch/arm64/include/asm/irqflags.h                            |    4=20
 arch/arm64/kernel/acpi.c                                     |   10=20
 arch/arm64/kernel/entry.S                                    |   48=20
 arch/arm64/kernel/image.h                                    |    6=20
 arch/arm64/kernel/irq.c                                      |   17=20
 arch/arm64/mm/init.c                                         |    5=20
 arch/mips/boot/compressed/Makefile                           |    2=20
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c           |    2=20
 arch/mips/include/asm/mach-ath79/ar933x_uart.h               |    4=20
 arch/parisc/kernel/ptrace.c                                  |   31=20
 arch/powerpc/include/asm/pgtable.h                           |   14=20
 arch/powerpc/kernel/exceptions-64s.S                         |    9=20
 arch/powerpc/kernel/swsusp_32.S                              |   73=20
 arch/powerpc/kvm/book3s_hv.c                                 |   13=20
 arch/powerpc/kvm/book3s_hv_tm.c                              |    6=20
 arch/powerpc/mm/pgtable_32.c                                 |    2=20
 arch/powerpc/platforms/powermac/sleep.S                      |   68=20
 arch/powerpc/platforms/powernv/npu-dma.c                     |   15=20
 arch/powerpc/platforms/powernv/pci-ioda.c                    |   10=20
 arch/powerpc/platforms/pseries/hotplug-memory.c              |    3=20
 arch/x86/events/amd/uncore.c                                 |   15=20
 arch/x86/events/intel/core.c                                 |   16=20
 arch/x86/events/intel/uncore.h                               |   10=20
 arch/x86/events/intel/uncore_snbep.c                         |    1=20
 arch/x86/include/asm/atomic.h                                |    8=20
 arch/x86/include/asm/atomic64_64.h                           |    8=20
 arch/x86/include/asm/barrier.h                               |    4=20
 arch/x86/include/asm/cpufeatures.h                           |    2=20
 arch/x86/include/asm/intel-family.h                          |    1=20
 arch/x86/kernel/cpu/cacheinfo.c                              |    3=20
 arch/x86/kernel/cpu/mkcapflags.sh                            |    2=20
 arch/x86/kernel/mpparse.c                                    |   10=20
 arch/x86/kvm/pmu.c                                           |    4=20
 arch/x86/kvm/vmx/nested.c                                    |   16=20
 arch/x86/kvm/vmx/vmx.c                                       |   30=20
 block/bio.c                                                  |   28=20
 block/blk-cgroup.c                                           |    8=20
 block/blk-iolatency.c                                        |   51=20
 block/blk-throttle.c                                         |    9=20
 block/blk-zoned.c                                            |    2=20
 crypto/asymmetric_keys/Kconfig                               |    3=20
 crypto/chacha20poly1305.c                                    |   30=20
 crypto/ghash-generic.c                                       |    8=20
 crypto/serpent_generic.c                                     |    8=20
 crypto/testmgr.c                                             |    6=20
 drivers/acpi/acpica/acevents.h                               |    3=20
 drivers/acpi/acpica/evgpe.c                                  |    8=20
 drivers/acpi/acpica/evgpeblk.c                               |    2=20
 drivers/acpi/acpica/evxface.c                                |    2=20
 drivers/acpi/acpica/evxfgpe.c                                |    2=20
 drivers/ata/libata-eh.c                                      |    8=20
 drivers/base/regmap/regmap-debugfs.c                         |    2=20
 drivers/base/regmap/regmap.c                                 |    2=20
 drivers/block/floppy.c                                       |   34=20
 drivers/block/null_blk_main.c                                |   11=20
 drivers/bluetooth/btusb.c                                    |    2=20
 drivers/bluetooth/hci_bcsp.c                                 |    5=20
 drivers/clk/imx/clk-imx8mm.c                                 |    6=20
 drivers/clocksource/exynos_mct.c                             |    4=20
 drivers/clocksource/timer-tegra20.c                          |    7=20
 drivers/crypto/amcc/crypto4xx_alg.c                          |   36=20
 drivers/crypto/amcc/crypto4xx_core.c                         |   24=20
 drivers/crypto/amcc/crypto4xx_core.h                         |   10=20
 drivers/crypto/amcc/crypto4xx_trng.c                         |    1=20
 drivers/crypto/caam/caamalg.c                                |   10=20
 drivers/crypto/caam/caamalg_qi.c                             |    2=20
 drivers/crypto/caam/caamalg_qi2.c                            |    9=20
 drivers/crypto/caam/qi.c                                     |    3=20
 drivers/crypto/ccp/ccp-dev.c                                 |   96=20
 drivers/crypto/ccp/ccp-dev.h                                 |    2=20
 drivers/crypto/ccp/ccp-ops.c                                 |   15=20
 drivers/crypto/inside-secure/safexcel_cipher.c               |   24=20
 drivers/crypto/talitos.c                                     |   35=20
 drivers/dma/imx-sdma.c                                       |   48=20
 drivers/edac/edac_mc_sysfs.c                                 |   34=20
 drivers/edac/edac_module.h                                   |    2=20
 drivers/gpio/gpio-omap.c                                     |   29=20
 drivers/gpio/gpiolib.c                                       |   13=20
 drivers/gpu/drm/drm_edid.c                                   |   81=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c               |   20=20
 drivers/gpu/ipu-v3/ipu-ic.c                                  |    2=20
 drivers/hid/wacom_sys.c                                      |    3=20
 drivers/hid/wacom_wac.c                                      |   19=20
 drivers/hid/wacom_wac.h                                      |    1=20
 drivers/hwtracing/intel_th/msu.c                             |    2=20
 drivers/hwtracing/intel_th/pci.c                             |    5=20
 drivers/i3c/master.c                                         |   51=20
 drivers/infiniband/hw/mlx5/main.c                            |    8=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c                    |    1=20
 drivers/infiniband/ulp/srp/ib_srp.c                          |   21=20
 drivers/input/mouse/alps.c                                   |   32=20
 drivers/input/mouse/synaptics.c                              |    1=20
 drivers/input/tablet/gtco.c                                  |   20=20
 drivers/iommu/iommu.c                                        |    8=20
 drivers/irqchip/irq-gic-v3.c                                 |    7=20
 drivers/irqchip/irq-meson-gpio.c                             |    1=20
 drivers/lightnvm/pblk-core.c                                 |   18=20
 drivers/md/bcache/alloc.c                                    |    9=20
 drivers/md/bcache/bcache.h                                   |    2=20
 drivers/md/bcache/io.c                                       |   12=20
 drivers/md/bcache/journal.c                                  |   52=20
 drivers/md/bcache/super.c                                    |   25=20
 drivers/md/bcache/sysfs.c                                    |    4=20
 drivers/md/bcache/util.h                                     |    2=20
 drivers/md/bcache/writeback.c                                |    5=20
 drivers/md/dm-bufio.c                                        |    4=20
 drivers/md/dm-zoned-metadata.c                               |   24=20
 drivers/md/dm-zoned.h                                        |   28=20
 drivers/md/raid5.c                                           |   11=20
 drivers/media/common/videobuf2/videobuf2-core.c              |    4=20
 drivers/media/common/videobuf2/videobuf2-dma-sg.c            |    2=20
 drivers/media/dvb-frontends/tua6100.c                        |   22=20
 drivers/media/i2c/Makefile                                   |    2=20
 drivers/media/i2c/adv7511-v4l2.c                             | 1997 ++++++=
+++++
 drivers/media/i2c/adv7511.c                                  | 1992 ------=
----
 drivers/media/i2c/mt9m111.c                                  |    8=20
 drivers/media/i2c/ov7740.c                                   |    6=20
 drivers/media/media-device.c                                 |   10=20
 drivers/media/pci/saa7164/saa7164-core.c                     |   33=20
 drivers/media/platform/aspeed-video.c                        |    5=20
 drivers/media/platform/coda/coda-bit.c                       |    9=20
 drivers/media/platform/coda/coda-common.c                    |    2=20
 drivers/media/platform/davinci/vpif_capture.c                |   16=20
 drivers/media/platform/davinci/vpss.c                        |    5=20
 drivers/media/platform/marvell-ccic/mcam-core.c              |    5=20
 drivers/media/platform/qcom/venus/firmware.c                 |    6=20
 drivers/media/platform/rcar_fdp1.c                           |    8=20
 drivers/media/platform/s5p-mfc/s5p_mfc.c                     |    3=20
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                  |    5=20
 drivers/media/platform/vim2m.c                               |    6=20
 drivers/media/platform/vimc/vimc-capture.c                   |    5=20
 drivers/media/radio/wl128x/fmdrv_v4l2.c                      |    3=20
 drivers/media/rc/ir-spi.c                                    |    1=20
 drivers/media/usb/dvb-usb/dvb-usb-init.c                     |    7=20
 drivers/media/usb/hdpvr/hdpvr-video.c                        |   17=20
 drivers/media/usb/uvc/uvc_ctrl.c                             |    4=20
 drivers/media/usb/zr364xx/zr364xx.c                          |    3=20
 drivers/media/v4l2-core/v4l2-ctrls.c                         |   27=20
 drivers/mmc/host/sdhci-msm.c                                 |    9=20
 drivers/mtd/nand/raw/mtk_nand.c                              |   24=20
 drivers/mtd/nand/spi/core.c                                  |    2=20
 drivers/net/bonding/bond_main.c                              |   37=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c          |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             |   33=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h            |    3=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                    |   20=20
 drivers/net/ethernet/freescale/fec_main.c                    |    6=20
 drivers/net/ethernet/hisilicon/hns3/hnae3.c                  |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c              |  146=20
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c           |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c      |    4=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c      |    7=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c        |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c    |   14=20
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                  |   27=20
 drivers/net/ethernet/intel/igb/igb_main.c                    |    1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c             |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c               |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                 |    1=20
 drivers/net/ethernet/marvell/mvmdio.c                        |    7=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c               |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c            |    4=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                    |   29=20
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                  |    2=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                   |    2=20
 drivers/net/ethernet/socionext/netsec.c                      |   32=20
 drivers/net/ethernet/stmicro/stmmac/common.h                 |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c            |    5=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c         |    6=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c            |   18=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            |    3=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |   20=20
 drivers/net/gtp.c                                            |   36=20
 drivers/net/phy/phy_device.c                                 |    6=20
 drivers/net/phy/sfp.c                                        |    6=20
 drivers/net/usb/asix_devices.c                               |    6=20
 drivers/net/vxlan.c                                          |   37=20
 drivers/net/wireless/ath/ath10k/debugfs_sta.c                |    7=20
 drivers/net/wireless/ath/ath10k/htt_rx.c                     |    4=20
 drivers/net/wireless/ath/ath10k/hw.c                         |    2=20
 drivers/net/wireless/ath/ath10k/mac.c                        |   14=20
 drivers/net/wireless/ath/ath10k/pci.c                        |    9=20
 drivers/net/wireless/ath/ath10k/qmi.c                        |    1=20
 drivers/net/wireless/ath/ath10k/sdio.c                       |    7=20
 drivers/net/wireless/ath/ath10k/txrx.c                       |    3=20
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                    |    4=20
 drivers/net/wireless/ath/ath10k/wmi.h                        |    7=20
 drivers/net/wireless/ath/ath6kl/wmi.c                        |   10=20
 drivers/net/wireless/ath/ath9k/hw.c                          |   32=20
 drivers/net/wireless/ath/ath9k/recv.c                        |    6=20
 drivers/net/wireless/ath/ath9k/xmit.c                        |    7=20
 drivers/net/wireless/ath/dfs_pattern_detector.c              |    2=20
 drivers/net/wireless/ath/wil6210/interrupt.c                 |   67=20
 drivers/net/wireless/ath/wil6210/txrx.c                      |    1=20
 drivers/net/wireless/ath/wil6210/wmi.c                       |   13=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                  |    2=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h                  |    6=20
 drivers/net/wireless/intel/iwlwifi/fw/smem.c                 |   12=20
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                 |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                  |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c            |   53=20
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                 |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                  |    3=20
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c     |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c          |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h           |   27=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                 |   66=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c         |    9=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c              |    8=20
 drivers/net/wireless/mediatek/mt7601u/dma.c                  |   54=20
 drivers/net/wireless/mediatek/mt7601u/tx.c                   |    4=20
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c               |   12=20
 drivers/net/wireless/realtek/rtlwifi/usb.c                   |    5=20
 drivers/nvdimm/dax_devs.c                                    |    2=20
 drivers/nvdimm/pfn.h                                         |    1=20
 drivers/nvdimm/pfn_devs.c                                    |   18=20
 drivers/nvme/host/core.c                                     |   14=20
 drivers/nvme/host/pci.c                                      |   14=20
 drivers/opp/core.c                                           |    2=20
 drivers/pci/controller/dwc/pcie-qcom.c                       |    2=20
 drivers/pci/controller/pci-hyperv.c                          |   15=20
 drivers/pci/pci.c                                            |   36=20
 drivers/pci/pci.h                                            |    1=20
 drivers/pci/pcie/portdrv_core.c                              |   66=20
 drivers/ras/cec.c                                            |    4=20
 drivers/regulator/da9211-regulator.c                         |    2=20
 drivers/regulator/s2mps11.c                                  |    9=20
 drivers/regulator/s5m8767.c                                  |    4=20
 drivers/regulator/tps65090-regulator.c                       |    7=20
 drivers/s390/cio/qdio_main.c                                 |    1=20
 drivers/s390/scsi/zfcp_fsf.c                                 |   55=20
 drivers/scsi/NCR5380.c                                       |   18=20
 drivers/scsi/NCR5380.h                                       |    2=20
 drivers/scsi/mac_scsi.c                                      |  375 +-
 drivers/scsi/megaraid/megaraid_sas_base.c                    |    3=20
 drivers/scsi/scsi_lib.c                                      |    6=20
 drivers/scsi/sd_zbc.c                                        |    2=20
 drivers/spi/spi-rockchip.c                                   |    4=20
 drivers/spi/spi.c                                            |   12=20
 drivers/staging/media/davinci_vpfe/vpfe_video.c              |    3=20
 drivers/staging/media/imx/imx7-mipi-csis.c                   |   14=20
 drivers/target/iscsi/iscsi_target_auth.c                     |   16=20
 drivers/usb/core/devio.c                                     |   48=20
 drivers/usb/core/hub.c                                       |    7=20
 drivers/vhost/net.c                                          |    2=20
 drivers/xen/balloon.c                                        |   16=20
 drivers/xen/events/events_base.c                             |   12=20
 drivers/xen/evtchn.c                                         |    2=20
 fs/btrfs/file.c                                              |    5=20
 fs/btrfs/tree-log.c                                          |   40=20
 fs/ceph/file.c                                               |    2=20
 fs/cifs/cifs_fs_sb.h                                         |    5=20
 fs/cifs/connect.c                                            |   10=20
 fs/cifs/inode.c                                              |   16=20
 fs/cifs/misc.c                                               |    1=20
 fs/cifs/smb2inode.c                                          |   12=20
 fs/cifs/smb2ops.c                                            |   57=20
 fs/coda/file.c                                               |   70=20
 fs/crypto/crypto.c                                           |   15=20
 fs/dax.c                                                     |   53=20
 fs/ecryptfs/crypto.c                                         |   12=20
 fs/fs-writeback.c                                            |    8=20
 fs/nfs/dir.c                                                 |   90=20
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                    |    2=20
 fs/nfs/inode.c                                               |    1=20
 fs/nfs/internal.h                                            |    3=20
 fs/nfs/nfs4file.c                                            |    2=20
 fs/nfs/pnfs.c                                                |    2=20
 fs/proc/proc_sysctl.c                                        |    4=20
 fs/pstore/inode.c                                            |   13=20
 fs/xfs/xfs_file.c                                            |    6=20
 include/asm-generic/bug.h                                    |    6=20
 include/drm/drm_displayid.h                                  |   10=20
 include/linux/blkdev.h                                       |    4=20
 include/linux/cpuhotplug.h                                   |    2=20
 include/linux/mm.h                                           |    5=20
 include/linux/rcupdate.h                                     |    2=20
 include/linux/sched/signal.h                                 |    2=20
 include/net/ip_vs.h                                          |    6=20
 include/net/xdp_sock.h                                       |    2=20
 include/rdma/ib_verbs.h                                      |    4=20
 include/sound/hda_codec.h                                    |    2=20
 include/trace/events/rxrpc.h                                 |    2=20
 include/uapi/linux/bpf.h                                     |    1=20
 include/xen/events.h                                         |    3=20
 kernel/bpf/Makefile                                          |    1=20
 kernel/bpf/core.c                                            |    4=20
 kernel/bpf/verifier.c                                        |   11=20
 kernel/iomem.c                                               |    2=20
 kernel/irq/chip.c                                            |    4=20
 kernel/irq/irqdesc.c                                         |   16=20
 kernel/locking/lockdep.c                                     |   59=20
 kernel/padata.c                                              |   12=20
 kernel/pid_namespace.c                                       |    2=20
 kernel/resource.c                                            |   20=20
 kernel/sched/core.c                                          |    2=20
 kernel/sched/sched-pelt.h                                    |    2=20
 kernel/signal.c                                              |  136=20
 kernel/time/ntp.c                                            |    4=20
 kernel/time/timer_list.c                                     |   36=20
 lib/reed_solomon/decode_rs.c                                 |   18=20
 lib/scatterlist.c                                            |    9=20
 net/9p/trans_virtio.c                                        |    8=20
 net/9p/trans_xen.c                                           |    8=20
 net/batman-adv/bat_iv_ogm.c                                  |    4=20
 net/batman-adv/hard-interface.c                              |    3=20
 net/batman-adv/translation-table.c                           |    2=20
 net/batman-adv/types.h                                       |    3=20
 net/bluetooth/6lowpan.c                                      |   14=20
 net/bluetooth/hci_event.c                                    |    5=20
 net/bluetooth/hidp/core.c                                    |    2=20
 net/bluetooth/hidp/sock.c                                    |    1=20
 net/bluetooth/l2cap_core.c                                   |   15=20
 net/bluetooth/smp.c                                          |   13=20
 net/key/af_key.c                                             |    8=20
 net/netfilter/ipset/ip_set_hash_gen.h                        |    2=20
 net/netfilter/ipvs/ip_vs_core.c                              |   21=20
 net/netfilter/ipvs/ip_vs_ctl.c                               |    4=20
 net/netfilter/ipvs/ip_vs_sync.c                              |  134=20
 net/netfilter/nf_conntrack_netlink.c                         |    7=20
 net/netfilter/nf_conntrack_proto_icmp.c                      |    2=20
 net/netfilter/nf_nat_proto.c                                 |    2=20
 net/netfilter/utils.c                                        |    5=20
 net/sunrpc/clnt.c                                            |    3=20
 net/sunrpc/xprt.c                                            |    2=20
 net/sunrpc/xprtsock.c                                        |    1=20
 net/xdp/xsk.c                                                |   31=20
 net/xdp/xsk_queue.h                                          |    2=20
 net/xfrm/Kconfig                                             |    2=20
 net/xfrm/xfrm_user.c                                         |   19=20
 scripts/kconfig/confdata.c                                   |    7=20
 scripts/kconfig/expr.h                                       |    1=20
 security/integrity/digsig.c                                  |    5=20
 security/selinux/hooks.c                                     |   11=20
 sound/core/seq/seq_clientmgr.c                               |   11=20
 sound/hda/hdac_controller.c                                  |    5=20
 sound/pci/hda/hda_codec.c                                    |    8=20
 sound/pci/hda/patch_hdmi.c                                   |   31=20
 sound/pci/hda/patch_realtek.c                                |   10=20
 sound/soc/codecs/hdac_hdmi.c                                 |    6=20
 sound/soc/generic/audio-graph-card.c                         |    6=20
 sound/soc/meson/axg-tdm.h                                    |    2=20
 sound/soc/sh/rcar/ctu.c                                      |    2=20
 sound/soc/soc-core.c                                         |   20=20
 sound/soc/soc-dapm.c                                         |   18=20
 tools/bpf/bpftool/jit_disasm.c                               |   11=20
 tools/include/uapi/linux/bpf.h                               |    1=20
 tools/lib/bpf/libbpf.c                                       |    8=20
 tools/lib/bpf/xsk.c                                          |    6=20
 tools/perf/arch/arm/util/cs-etm.c                            |  127=20
 tools/perf/jvmti/libjvmti.c                                  |    4=20
 tools/perf/perf.h                                            |    2=20
 tools/perf/tests/parse-events.c                              |   27=20
 tools/perf/tests/shell/record+probe_libc_inet_pton.sh        |    2=20
 tools/perf/ui/browsers/annotate.c                            |    5=20
 tools/perf/util/annotate.c                                   |    5=20
 tools/perf/util/evsel.c                                      |    8=20
 tools/perf/util/header.c                                     |    2=20
 tools/perf/util/metricgroup.c                                |   47=20
 tools/perf/util/stat-display.c                               |    3=20
 tools/perf/util/stat-shadow.c                                |   23=20
 tools/power/cpupower/utils/cpufreq-set.c                     |    2=20
 tools/testing/selftests/bpf/progs/test_lwt_seg6local.c       |   12=20
 374 files changed, 5677 insertions(+), 3589 deletions(-)

Aaron Armstrong Skomra (3):
      HID: wacom: generic: only switch the mode on devices with LEDs
      HID: wacom: generic: Correct pad syncing
      HID: wacom: correct touch resolution x/y typo

Aaron Lewis (1):
      x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS

Abhishek Goel (1):
      cpupower : frequency-set -r option misses the last cpu in related cpu=
 list

Ahmad Masri (1):
      wil6210: drop old event after wmi_call timeout

Akinobu Mita (1):
      media: ov7740: avoid invalid framesize setting

Alagu Sankar (1):
      ath10k: htt: don't use txdone_fifo with SDIO

Alexander Shishkin (2):
      intel_th: pci: Add Ice Lake NNPI support
      intel_th: msu: Fix single mode with disabled IOMMU

Alexei Starovoitov (1):
      bpf: fix callees pruning callers

Alexey Kardashevskiy (1):
      powerpc/powernv: Fix stale iommu table base after VFIO

Amadeusz S=C5=82awi=C5=84ski (1):
      ASoC: Intel: hdac_hdmi: Set ops to NULL on remove

Anders Roxell (1):
      media: i2c: fix warning same module names

Andi Kleen (4):
      perf stat: Make metric event lookup more robust
      perf stat: Fix metrics with --no-merge
      perf stat: Don't merge events in the same PMU
      perf stat: Fix group lookup for metric group

Andreas Schwab (1):
      powerpc/mm/32s: fix condition that is always true

Andrei Otcheretianski (1):
      iwlwifi: mvm: Drop large non sta frames

Andres Rodriguez (1):
      drm/edid: parse CEA blocks embedded in DisplayID

Andrii Nakryiko (2):
      libbpf: fix GCC8 warning for strncpy
      libbpf: fix another GCC8 warning for strncpy

Andr=C3=A9 Almeida (1):
      media: vimc: cap: check v4l2_fill_pixfmt return value

Aneesh Kumar K.V (1):
      mm/nvdimm: add is_ioremap_addr and use that to check ioremap address

Anilkumar Kolli (1):
      ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Antoine Tenart (1):
      crypto: inside-secure - do not rely on the hardware last bit for resu=
lt descriptors

Anton Eidelman (1):
      nvme: fix possible io failures when removing multipathed ns

Ard Biesheuvel (2):
      acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
      crypto: caam - limit output IV to CBC to work around CTR mode DMA iss=
ue

Arnaldo Carvalho de Melo (2):
      perf annotate TUI browser: Do not use member from variable within its=
 own initialization
      perf evsel: Make perf_evsel__name() accept a NULL argument

Arnd Bergmann (3):
      ipsec: select crypto ciphers for xfrm_algo
      crypto: serpent - mark __serpent_setkey_sbox noinline
      crypto: asymmetric_keys - select CRYPTO_HASH where needed

Aurelien Aptel (1):
      CIFS: fix deadlock in cached root handling

Bart Van Assche (1):
      RDMA/srp: Accept again source addresses that do not have a port number

Baruch Siach (1):
      bpf: fix uapi bpf_prog_info fields alignment

Benjamin Block (2):
      scsi: zfcp: fix request object use-after-free in send path causing se=
qno errors
      scsi: zfcp: fix request object use-after-free in send path causing wr=
ong traces

Biao Huang (2):
      net: stmmac: dwmac4: fix flow control issue
      net: stmmac: modify default value of tx-frames

Bob Liu (1):
      block: null_blk: fix race condition for null_del_dev

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Borislav Petkov (1):
      RAS/CEC: Fix pfn insertion

Cfir Cohen (1):
      crypto: ccp/gcm - use const time tag comparison.

Chaitanya Kulkarni (1):
      nvme-pci: set the errno on ctrl state change error

Christian Lamparter (3):
      crypto: crypto4xx - fix AES CTR blocksize value
      crypto: crypto4xx - fix blocksize for cfb and ofb
      crypto: crypto4xx - block ciphers should only accept complete blocks

Christophe Leroy (5):
      crypto: talitos - fix skcipher failure due to wrong output IV
      crypto: talitos - properly handle split ICV.
      crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than=
 PAGE_SIZE
      powerpc/32s: fix suspend/resume when IBATs 4-7 are used

Claire Chang (1):
      ath10k: add missing error handling

Colin Ian King (1):
      iavf: fix dereference of null rx_buffer pointer

Coly Li (11):
      bcache: check CACHE_SET_IO_DISABLE in allocator code
      bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
      bcache: acquire bch_register_lock later in cached_dev_free()
      bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()
      bcache: fix potential deadlock in cached_def_free()
      Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
      bcache: Revert "bcache: fix high CPU occupancy during journal"
      bcache: Revert "bcache: free heap cache_set->flush_btree in bch_journ=
al_free"
      bcache: ignore read-ahead request failure on backing device
      bcache: fix mistaken sysfs entry for io_error counter
      bcache: destroy dc->writeback_write_wq if failed to create dc->writeb=
ack_thread

Cong Wang (1):
      bonding: validate ip header before check IPPROTO_IGMP

Damien Le Moal (4):
      scsi: sd_zbc: Fix compilation warning
      dm zoned: fix zone state management race
      block: Allow mapping of vmalloc-ed buffers
      block: Fix potential overflow in blk_report_zones()

Dan Carpenter (3):
      ath6kl: add some bounds checking
      Bluetooth: hidp: NUL terminate a string in the compat ioctl
      eCryptfs: fix a couple type promotion bugs

Dan Williams (1):
      libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Daniel Baluta (1):
      regmap: debugfs: Fix memory leak in regmap_debugfs_init

Daniel Gomez (1):
      media: spi: IR LED: add missing of table registration

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

Danit Goldberg (1):
      IB/mlx5: Report correctly tag matching rendezvous capability

Dann Frazier (1):
      ixgbe: Avoid NULL pointer dereference with VF on non-IPsec hw

Darrick J. Wong (1):
      xfs: abort unaligned nowait directio early

David Howells (1):
      rxrpc: Fix oops in tracepoint

David Rientjes (1):
      x86/boot: Fix memory leak in default_get_smp_config()

David S. Miller (1):
      tua6100: Avoid build warnings.

Denis Efremov (4):
      floppy: fix div-by-zero in setup_format_params
      floppy: fix out-of-bounds read in next_valid_format
      floppy: fix invalid pointer dereference in drive_name
      floppy: fix out-of-bounds read in copy_buffer

Denis Kirjanov (1):
      ipoib: correcly show a VF hardware address

Dennis Zhou (2):
      blk-iolatency: only account submitted bios
      blk-iolatency: fix STS_AGAIN handling

Dexuan Cui (1):
      PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Dmitry Osipenko (3):
      clocksource/drivers/tegra: Release all IRQ's on request_irq() error
      clocksource/drivers/tegra: Restore base address before cleanup
      opp: Don't use IS_ERR on invalid supplies

Drew Davenport (1):
      include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAIN=
T architectures

Dundi Raviteja (1):
      ath10k: Fix memory leak in qmi

Eiichi Tsukata (1):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Emil Renner Berthing (1):
      spi: rockchip: turn down tx dma bursts

Emmanuel Grumbach (5):
      iwlwifi: pcie: don't service an interrupt that was masked
      iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X
      iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill
      iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices
      iwlwifi: mvm: clear rfkill_safe_init_done when we start the firmware

Eric Auger (1):
      iommu: Fix a leak in iommu_insert_resv_region

Eric Biggers (4):
      fscrypt: clean up some BUG_ON()s in block encryption/decryption
      crypto: testmgr - add some more preemption points
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Eric W. Biederman (3):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig
      signal/usb: Replace kill_pid_info_as_cred with kill_pid_usb_asyncio
      signal: Correct namespace fixups of si_pid and si_uid

Ezequiel Garcia (1):
      media: coda: Remove unbalanced and unneeded mutex unlock

Fabio Estevam (2):
      media: imx7-mipi-csis: Propagate the error if clock enabling fails
      net: fec: Do not use netdev messages too early

Felix Kaechele (1):
      netfilter: ctnetlink: Fix regression in conntrack entry deletion

Ferdinand Blomqvist (2):
      rslib: Fix decoding of shortened codes
      rslib: Fix handling of of caller provided syndrome

Filipe Manana (3):
      Btrfs: fix data loss after inode eviction, renaming it, and fsync it
      Btrfs: fix fsync not persisting dentry deletions due to inode evictio=
ns
      Btrfs: add missing inode version, ctime and mtime updates when punchi=
ng hole

Finn Thain (5):
      scsi: NCR5380: Always re-enable reselection interrupt
      scsi: NCR5380: Handle PDMA failure reliably
      Revert "scsi: ncr5380: Increase register polling limit"
      scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
      scsi: mac_scsi: Fix pseudo DMA implementation, take 2

Gao Xiang (1):
      sched/core: Add __sched tag for io_schedule()

Geert Uytterhoeven (2):
      integrity: Fix __integrity_init_keyring() section mismatch
      gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level

Greg KH (1):
      EDAC/sysfs: Drop device references properly

Greg Kroah-Hartman (1):
      Linux 5.1.20

Greg Kurz (1):
      powerpc/powernv/npu: Fix reference leak

Guilherme G. Piccoli (1):
      bnx2x: Prevent ptp_task to be rescheduled indefinitely

Gustavo A. R. Silva (1):
      wil6210: fix potential out-of-bounds read

Hans Verkuil (2):
      media: mc-device.c: don't memset __user pointer contents
      media: hdpvr: fix locking and a missing msleep

He Zhe (1):
      netfilter: Fix remainder of pseudo-header protocol 0

Heiner Litz (1):
      lightnvm: pblk: fix freeing of merged pages

Helge Deller (2):
      parisc: Ensure userspace privilege for ptraced processes in regset fu=
nctions
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Hook, Gary (2):
      crypto: ccp - Validate the the error value used to index error messag=
es
      crypto: ccp - memset structure fields to zero before reuse

Horia Geant=C4=83 (1):
      crypto: caam - avoid S/G table fetching for AEAD zero-length output

Huazhong Tan (1):
      net: hns3: fix __QUEUE_STATE_STACK_XOFF not cleared issue

Hui Wang (3):
      Input: alps - don't handle ALPS cs19 trackpoint-only device
      Input: alps - fix a mismatch between a condition check and its comment
      ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine

Icenowy Zheng (1):
      net: stmmac: sun8i: force select external PHY when no internal one

Ilias Apalodimas (1):
      net: netsec: initialize tx ring on ndo_open

Ilya Maximets (1):
      xdp: fix race on generic receive path

Imre Deak (2):
      locking/lockdep: Fix OOO unlock when hlocks need merging
      locking/lockdep: Fix merging of hlocks with non-zero references

Ioana Ciornei (1):
      net: phy: Check against net_device being NULL

Jae Hyun Yoo (1):
      media: aspeed: change irq to threaded irq

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap

Jason Wang (1):
      vhost_net: disable zerocopy by default

Jeremy Sowden (2):
      batman-adv: fix for leaked TVLV handler.
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Jerome Brunet (1):
      ASoC: meson: axg-tdm: fix sample clock inversion

Jian Shen (2):
      net: hns3: initialize CPU reverse mapping
      net: hns3: enable broadcast promisc mode when initializing VF

Jianbo Liu (1):
      net/mlx5: Get vport ACL namespace by vport index

Jiong Wang (1):
      bpf: fix BPF_ALU32 | BPF_ARSH on BE arches

Jiri Benc (1):
      selftests: bpf: fix inlines in test_lwt_seg6local

Jiri Olsa (3):
      perf jvmti: Address gcc string overflow warning for strncpy()
      perf/x86/intel: Disable check_msr for real HW
      tools: bpftool: Fix json dump crash on powerpc

Johannes Berg (1):
      iwlwifi: mvm: delay GTK setting in FW in AP mode

Jon Hunter (2):
      arm64: tegra: Update Jetson TX1 GPU regulator timings
      arm64: tegra: Fix AGIC register range

Jorge Ramirez-Ortiz (1):
      mmc: sdhci-msm: fix mutex while in spinlock

Jose Abreu (3):
      net: stmmac: dwmac1000: Clear unused address entries
      net: stmmac: dwmac4/5: Clear unused address entries
      net: stmmac: Prevent missing interrupts when running NAPI

Josua Mayer (4):
      Bluetooth: 6lowpan: search for destination address in all peers
      net: mvmdio: defer probe of orion-mdio if a clock is not ready
      net: mvmdio: allow up to four clocks to be specified for orion-mdio
      dt-bindings: allow up to four clocks for orion-mdio

Jo=C3=A3o Paulo Rechi Vita (2):
      Bluetooth: Add new 13d3:3491 QCA_ROME device
      Bluetooth: Add new 13d3:3501 QCA_ROME device

Juergen Gross (2):
      xen: let alloc_xenballooned_pages() fail if not enough memory free
      xen/events: fix binding user event channels to cpus

Julian Anastasov (2):
      ipvs: defer hook registration to avoid leaks
      ipvs: fix tinfo memory leak in start_sync_thread

Julian Wiedmann (1):
      s390/qdio: handle PENDING state for QEBSM devices

Julien Thierry (3):
      arm64: Do not enable IRQs for ct_user_exit
      arm64: Fix interrupt tracing in the presence of NMIs
      arm64: irqflags: Add condition flags to inline asm clobber list

Jungo Lin (1):
      media: media_device_enum_links32: clean a reserved field

Junxiao Bi (1):
      dm bufio: fix deadlock with loop device

Kailang Yang (1):
      ALSA: hda/realtek - Fixed Headphone Mic can't record on Dell platform

Kan Liang (2):
      perf/x86/intel/uncore: Handle invalid event coding for free-running c=
ounter
      perf/x86/intel: Fix spurious NMI on fixed counter

Kangjie Lu (1):
      media: vpss: fix a potential NULL pointer dereference

Kefeng Wang (3):
      media: vim2m: fix two double-free issues
      media: saa7164: fix remove_proc_entry warning
      media: wl128x: Fix some error handling in fm_v4l2_init_video_device()

Kevin Darbyshire-Bryant (1):
      MIPS: fix build on non-linux hosts

Kieran Bingham (1):
      media: fdp1: Support M3N and E3 platforms

Kim Phillips (2):
      perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-=
L3 PMCs
      perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Konstantin Khlebnikov (1):
      blk-throttle: fix zero wait time for iops throttled group

Krzysztof Kozlowski (2):
      regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure
      regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Kuninori Morimoto (1):
      ASoC: soc-core: call snd_soc_unbind_card() under mutex_lock;

Kyle Meyer (1):
      perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Lee, Chiasheng (1):
      usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Leo Yan (1):
      bpf, libbpf, smatch: Fix potential NULL pointer dereference

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Linus Walleij (1):
      ARM: dts: gemini: Set DIR-685 SPI CS as active low

Lorenzo Bianconi (2):
      mt7601u: do not schedule rx_tasklet when the device has been disconne=
cted
      mt7601u: fix possible memory leak when the device is disconnected

Lubomir Rintel (1):
      media: marvell-ccic: fix DMA s/g desc number calculation

Luis Henriques (1):
      ceph: fix end offset in truncate_inode_pages_range call

Lyude Paul (1):
      drm/nouveau/i2c: Enable i2c pads & busses during preinit

Marco Felsch (1):
      media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP

Marek Szyprowski (3):
      media: s5p-mfc: fix reading min scratch buffer size on MFC v6/v7
      media: s5p-mfc: Make additional clocks optional
      clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Mark Brown (2):
      ASoC: dapm: Adapt for debugfs API change
      ASoC: core: Adapt for debugfs API change

Masahiro Yamada (2):
      x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c
      kconfig: fix missing choice values in auto.conf

Mathieu Poirier (1):
      perf cs-etm: Properly set the value of 'old' and 'head' in snapshot m=
ode

Matias Karhumaa (1):
      Bluetooth: Check state in l2cap_disconnect_rsp

Matthew Wilcox (Oracle) (1):
      dax: Fix missed wakeup with PMD faults

Maurizio Lombardi (1):
      scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not su=
pported

Mauro S. M. Rodrigues (1):
      ixgbe: Check DDM existence in transceiver before access

Max Kellermann (1):
      Revert "NFS: readdirplus optimization by cache mechanism" (memleak)

Maxime Chevallier (1):
      net: mvpp2: prs: Don't override the sign bit in SRAM parser shift

Maya Erez (2):
      wil6210: fix missed MISC mbox interrupt
      wil6210: fix spurious interrupts in 3-msi

Miaoqing Pan (2):
      ath10k: fix fw crash by moving chip reset after napi disabled
      ath10k: fix PCIE device wake up failed

Michael Chan (2):
      bnxt_en: Disable bus master during PCI shutdown and driver unload.
      bnxt_en: Fix statistics context reservation logic for RDMA driver.

Michael Neuling (1):
      KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation

Michal Kalderon (2):
      qed: Set the doorbell address correctly
      qed: iWARP - Fix tc for MPA ll2 connection

Mika Westerberg (2):
      PCI: Add missing link delays required by the PCIe spec
      PCI: Do not poll for PME if the device is in D3cold

Miles Chen (1):
      arm64: mm: make CONFIG_ZONE_DMA32 configurable

Ming Lei (1):
      scsi: core: Fix race on creating sense cache

Minwoo Im (2):
      nvme-pci: properly report state change failure in nvme_reset_work
      nvme-pci: adjust irq max_vector using num_possible_cpus()

Miroslav Lichvar (1):
      ntp: Limit TAI-UTC offset

Mitch Williams (1):
      iavf: allow null RX descriptors

Nadav Amit (1):
      resource: fix locking in find_next_iomem_res()

Nathan Chancellor (2):
      arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicit=
ly
      xsk: Properly terminate assignment in xskq_produce_flush_desc

Nathan Huckleberry (1):
      timer_list: Guard procfs specific code

Nathan Lynch (1):
      powerpc/pseries: Fix oops in hotplug memory notifier

Nick Black (1):
      Input: synaptics - whitelist Lenovo T580 SMBus intertouch

Nicolas Dichtel (1):
      xfrm: fix sa selector validation

Niklas Cassel (1):
      PCI: qcom: Ensure that PERST is asserted for at least 100 ms

Nilkanth Ahirrao (1):
      ASoC: rsnd: fixup mod ID calculation in rsnd_ctu_probe_

Norbert Manthey (1):
      pstore: Fix double-free in pstore_mkfile() failure path

Oliver Neukum (2):
      media: dvb: usb: fix use after free in dvb_usb_device_exit
      media: uvcvideo: Fix access to uninitialized fields on probe error

Ondrej Mosnacek (1):
      selinux: fix empty write to keycreate file

Oren Givon (1):
      iwlwifi: add support for hr1 RF ID

Pan Bian (1):
      EDAC/sysfs: Fix memory leak when creating a csrow object

Paulo Alcantara (SUSE) (1):
      cifs: Properly handle auto disabling of serverino option

Peng Fan (1):
      clk: imx: imx8mm: correct audio_pll2_clk to audio_pll2_out

Peter Zijlstra (1):
      x86/atomic: Fix smp_mb__{before,after}_atomic()

Philipp Zabel (2):
      media: coda: fix mpeg2 sequence number handling
      media: coda: increment sequence offset for the last returned frame

Phong Tran (1):
      net: usb: asix: init MAC address buffers

Ping-Ke Shih (1):
      rtlwifi: rtl8192cu: fix error handle when usb probe failed

Pradeep kumar Chitrapu (1):
      ath10k: fix incorrect multicast/broadcast rate setting

Qian Cai (2):
      sched/fair: Fix "runnable_avg_yN_inv" not used warnings
      x86/cacheinfo: Fix a -Wtype-limits warning

Radoslaw Burny (1):
      fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc=
/sys inodes.

Rafael J. Wysocki (1):
      ACPICA: Clear status of GPEs on first direct enable

Rajneesh Bhardwaj (1):
      x86/cpu: Add Ice Lake NNPI to Intel family

Rakesh Pillai (1):
      ath10k: Fix encoding for protected management frames

Rander Wang (1):
      ALSA: hda: Fix a headphone detection issue when using SOF

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception

Robert Hancock (2):
      net: axienet: Fix race condition causing TX hang
      net: sfp: add mutex to prevent concurrent state checks

Robert Jarzmik (1):
      media: mt9m111: fix fw-node refactoring

Ronnie Sahlberg (3):
      cifs: always add credits back for unsolicited PDUs
      cifs: fix crash in smb2_compound_op()/smb2_set_next_command()
      cifs: flush before set-info if we have writeable handles

Russell King (2):
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4
      gpio: omap: ensure irq is enabled before wakeup

Sakari Ailus (2):
      media: videobuf2-core: Prevent size alignment wrapping buffer size to=
 0
      media: videobuf2-dma-sg: Prevent size from overflowing

Sean Christopherson (3):
      KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
      KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
      KVM: VMX: Fix handling of #MC that occurs during VM-Entry

Seeteena Thoufeek (1):
      perf tests: Fix record+probe_libc_inet_pton.sh for powerpc64

Shahar S Matityahu (1):
      iwlwifi: dbg: fix debug monitor stop and restart delays

Shailendra Verma (1):
      media: staging: media: davinci_vpfe: - Fix for memory leak if decoder=
 initialization fails.

Shijith Thotton (1):
      genirq: Update irq stats from NMI handlers

Shivasharan S (1):
      scsi: megaraid_sas: Fix calculation of target ID

Soeren Moch (1):
      rt2x00usb: fix rx queue hang

Srinivas Kandagatla (1):
      regmap: fix bulk writes on paged registers

Stefan Hellermann (1):
      MIPS: ath79: fix ar933x uart parity mode

Stefano Brivio (1):
      ipset: Fix memory accounting for hash types on resize

Steve Longerbeam (1):
      gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Surabhi Vishnoi (2):
      ath10k: Do not send probe response template for mesh
      ath10k: Fix the wrong value of enums for wmi tlv stats id

Suraj Jitindar Singh (2):
      KVM: PPC: Book3S HV: Signed extend decrementer value if not using lar=
ge decrementer
      KVM: PPC: Book3S HV: Clear pending decrementer exceptions on nested g=
uest entry

Sven Eckelmann (1):
      batman-adv: Fix duplicated OGMs on NETDEV_UP

Sven Van Asbroeck (1):
      dmaengine: imx-sdma: fix use-after-free on probe error path

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Taehee Yoo (6):
      vxlan: do not destroy fdb if register_netdevice() is failed
      gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
      gtp: fix suspicious RCU usage
      gtp: fix Illegal context switch in RCU read-side critical section.
      gtp: fix use-after-free in gtp_encap_destroy()
      gtp: fix use-after-free in gtp_newlink()

Takashi Iwai (4):
      ALSA: seq: Break too long mutex context in the write loop
      ALSA: hda - Don't resume forcibly i915 HDMI/DP codec
      ALSA: hda/hdmi - Remove duplicated define
      ALSA: hda/hdmi - Fix i915 reverse port/pin mapping

Tejun Heo (4):
      blkcg, writeback: dead memcgs shouldn't contribute to writeback owner=
ship arbitration
      libata: don't request sense data on !ZAC ATA devices
      blk-iolatency: clear use_delay when io.latency is set to zero
      blkcg: update blkcg_print_stat() to handle larger outputs

Thomas Richter (2):
      perf test 6: Fix missing kvm module load for s390
      perf report: Fix OOM error in TUI mode on s390

Tim Schumacher (1):
      ath9k: Check for errors when reading SREV register

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      ath9k: Don't trust TX status TID number when reporting airtime

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Tony Lindgren (1):
      gpio: omap: Fix lost edge wake-up interrupts

Trond Myklebust (4):
      NFSv4: Handle the special Linux file open access mode
      pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error
      pnfs: Fix a problem where we gratuitously start doing I/O through the=
 MDS
      SUNRPC: Ensure the bvecs are reset when we re-encode the RPC request

Tudor Ambarus (1):
      spi: fix ctrl->num_chipselect constraint

Valdis Kletnieks (1):
      bpf: silence warning messages in core

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_qu=
erycap

Vedang Patel (1):
      igb: clear out skb->tstamp after reading the txtime

Vitor Soares (1):
      i3c: fix i2c and i3c scl rate by bus mode

Waibel Georg (1):
      gpio: Fix return value mismatch of function gpiod_get_from_of_node()

Waiman Long (1):
      rcu: Force inlining of rcu_read_lock()

Wanpeng Li (1):
      KVM: VMX: check CPUID before allowing read/write of IA32_XSS

Weihang Li (2):
      net: hns3: add a check to pointer in error_detected and slot_reset
      net: hns3: set ops to null when unregister ad_dev

Wen Gong (2):
      ath10k: add peer id check in ath10k_peer_find_by_id
      ath10k: destroy sdio workqueue while remove sdio module

Wen Yang (3):
      media: venus: firmware: fix leaked of_node references
      ASoC: audio-graph-card: fix use-after-free in graph_for_each_link
      crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

Xiao Ni (1):
      raid5-cache: Need to do start() part job after adding journal device

Xiaolei Li (1):
      mtd: rawnand: mtk: Correct low level time calculation of r/w cycle

Xingyu Chen (1):
      irqchip/meson-gpio: Add support for Meson-G12A SoC

Yingying Tang (1):
      ath10k: Check tx_stats before use it

Yonglong Liu (2):
      net: hns3: fix a -Wformat-nonliteral compile warning
      net: hns3: add Asym Pause support to fix autoneg problem

Young Xiao (1):
      media: davinci: vpif_capture: fix memory leak in vpif_probe()

YueHaibing (2):
      9p/xen: Add cleanup path in p9_trans_xen_init
      9p/virtio: Add cleanup path in p9_virtio_init

Yunsheng Lin (4):
      net: hns3: fix for dereferencing before null checking
      net: hns3: fix for skb leak when doing selftest
      net: hns3: delay ring buffer clearing during reset
      net: hns3: add some error checking in hclge_tm module

Zefir Kurtisi (1):
      ath9k: correctly handle short radar pulses

csonsino (1):
      Bluetooth: validate BLE connection interval updates

liaoweixiong (1):
      mtd: spinand: read returns badly if the last page has bitflips

sumitg (1):
      media: v4l2-core: fix use-after-free error


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl06veEACgkQONu9yGCS
aT4D7w//SlxE2J6pc1Ia8QidzFdfNg45Uh7O8lEqArMan+RFXKHbu0gckltrRu3m
FcCf8LpHJOH1yX2i64ztOefJjofiVyM63a0XUqFchj4aJ9eUULdinStrHPFXlFgK
w5viau742YM1yfDRDQV36ah14mMbfdj6erndbHcEYhHe9UmKIPM8dYRFOkS3QY91
fayeqwCpg2TcABbdZ2/KysRGvLQWeXJ5NxkI0419BLqvoIHkZwJhY2gc7FYzlQHz
aNnY/FeD1Ymp8KvITgDJn6ucwUdBJcHIkx0UOWUntWi8Aqhlw1+WKnm+4lId7JGt
YrTWRPPJEJpPfNg/OM4LOFwlQ8yt+KsoU7qHuId8G6KsX81TGnqVYyE1fSHDeiRd
NzjL0YPMok78axY5gsOI/PPvPGckoXDcMYZREJTMvH2/739h5S2o+lsP+h+CNKZc
fUXI2Yc0xjpEz/YXrdj+tzEiuTJ1uVB0u6bVOClzFR9xETSr3k6R2K+XTXtk899s
0wPyHs8xsh3mybekWL8gcZ4xIjsepQV4E8ty6P6TFmg80+mudNNe9iQuAW4Xk6Td
exjRUr9TVka3lEWOD2FGvqIrACqmAcnqOgoyk4qIo4cUBywhjC9vHmzK6g7UhVMa
Gwgxx6oSvDILRCeQuLyvTXC6g2Kp5FhteVrdNR4V0P1vWFzipyI=
=EFLm
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
