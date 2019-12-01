Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB64D10E13E
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLAJld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfLAJld (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:41:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB9C62073C;
        Sun,  1 Dec 2019 09:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193290;
        bh=my0ux7iAFHlPpEp9B3MXrClnSYdKo62af1GSR2rxuxU=;
        h=Date:From:To:Cc:Subject:From;
        b=Py48HyJGGJtJCdDkPYKBRGsw0fOjI1p80lOuKvfpTZPvrfo+nBiy352bnpngvMJ16
         DO3qP/UXPTfMoCELeM41v0zkaaTfE0/M7Fo351WFvWOhXApiVTxCEV3F/tBA1o81Ab
         5YLEGClNCOeNQrNMvX5emRZQ/pBLQYcRbEyAERAQ=
Date:   Sun, 1 Dec 2019 10:41:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.87
Message-ID: <20191201094128.GA3793563@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.87 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/mds.rst                          |    7=
=20
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst              |    5=
=20
 Documentation/admin-guide/kernel-parameters.txt                    |   11=
=20
 Documentation/devicetree/bindings/spi/spi-uniphier.txt             |   14=
=20
 Makefile                                                           |    2=
=20
 arch/arc/kernel/perf_event.c                                       |    4=
=20
 arch/arm/boot/dts/imx6sx-sdb.dtsi                                  |    7=
=20
 arch/arm/mm/mmu.c                                                  |    3=
=20
 arch/arm64/Makefile                                                |    2=
=20
 arch/arm64/include/asm/string.h                                    |   14=
=20
 arch/arm64/kernel/arm64ksyms.c                                     |    7=
=20
 arch/arm64/lib/memchr.S                                            |    2=
=20
 arch/arm64/lib/memcmp.S                                            |    2=
=20
 arch/arm64/lib/strchr.S                                            |    2=
=20
 arch/arm64/lib/strcmp.S                                            |    2=
=20
 arch/arm64/lib/strlen.S                                            |    2=
=20
 arch/arm64/lib/strncmp.S                                           |    2=
=20
 arch/arm64/lib/strnlen.S                                           |    2=
=20
 arch/arm64/lib/strrchr.S                                           |    2=
=20
 arch/m68k/kernel/uboot.c                                           |    2=
=20
 arch/nds32/include/asm/bitfield.h                                  |    4=
=20
 arch/powerpc/boot/Makefile                                         |    4=
=20
 arch/powerpc/boot/opal.c                                           |    8=
=20
 arch/powerpc/include/asm/asm-prototypes.h                          |    3=
=20
 arch/powerpc/include/asm/security_features.h                       |    3=
=20
 arch/powerpc/kernel/eeh_driver.c                                   |    4=
=20
 arch/powerpc/kernel/eeh_pe.c                                       |    2=
=20
 arch/powerpc/kernel/entry_64.S                                     |    6=
=20
 arch/powerpc/kernel/process.c                                      |    3=
=20
 arch/powerpc/kernel/security.c                                     |   74 =
++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                            |   28 +
 arch/powerpc/mm/pgtable-radix.c                                    |    8=
=20
 arch/powerpc/mm/tlb-radix.c                                        |    1=
=20
 arch/powerpc/platforms/powernv/memtrace.c                          |    2=
=20
 arch/powerpc/platforms/ps3/os-area.c                               |    2=
=20
 arch/powerpc/platforms/pseries/hotplug-memory.c                    |    2=
=20
 arch/powerpc/platforms/pseries/lpar.c                              |   54 =
++
 arch/powerpc/xmon/Makefile                                         |    6=
=20
 arch/riscv/mm/ioremap.c                                            |    2=
=20
 arch/s390/kernel/perf_cpum_sf.c                                    |    6=
=20
 arch/sparc/include/asm/cmpxchg_64.h                                |    7=
=20
 arch/sparc/include/asm/parport.h                                   |    2=
=20
 arch/um/drivers/line.c                                             |    4=
=20
 arch/x86/include/asm/ptrace.h                                      |   42 +
 arch/x86/kernel/cpu/bugs.c                                         |   30 +
 arch/x86/kernel/cpu/intel_rdt.c                                    |    7=
=20
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c                        |   12=
=20
 arch/x86/kernel/cpu/intel_rdt_pseudo_lock.c                        |   10=
=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                           |   38 +
 arch/x86/kvm/mmu.c                                                 |    8=
=20
 arch/x86/kvm/vmx.c                                                 |   22=
=20
 arch/x86/tools/gen-insn-attr-x86.awk                               |    4=
=20
 block/blk-core.c                                                   |    3=
=20
 block/blk-merge.c                                                  |   46 +
 block/blk-sysfs.c                                                  |    2=
=20
 crypto/testmgr.c                                                   |    6=
=20
 drivers/acpi/acpi_memhotplug.c                                     |    2=
=20
 drivers/acpi/scan.c                                                |    1=
=20
 drivers/atm/zatm.c                                                 |   42 -
 drivers/base/memory.c                                              |   22=
=20
 drivers/base/power/domain.c                                        |    6=
=20
 drivers/block/amiflop.c                                            |   84 =
+--
 drivers/block/nbd.c                                                |    6=
=20
 drivers/block/skd_main.c                                           |    4=
=20
 drivers/bluetooth/hci_bcsp.c                                       |    3=
=20
 drivers/cdrom/cdrom.c                                              |   27 -
 drivers/char/virtio_console.c                                      |   28 -
 drivers/clk/at91/clk-audio-pll.c                                   |    2=
=20
 drivers/clk/mmp/clk-of-mmp2.c                                      |    4=
=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                              |    7=
=20
 drivers/clk/tegra/clk-tegra20.c                                    |   36 +
 drivers/clk/tegra/clk-tegra210.c                                   |    6=
=20
 drivers/cpufreq/cpufreq.c                                          |    6=
=20
 drivers/crypto/ccree/cc_hw_queue_defs.h                            |    6=
=20
 drivers/devfreq/devfreq.c                                          |    2=
=20
 drivers/edac/thunderx_edac.c                                       |    4=
=20
 drivers/firmware/google/gsmi.c                                     |    5=
=20
 drivers/gpio/gpio-max77620.c                                       |    6=
=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c                   |   23=
=20
 drivers/gpu/drm/i915/i915_gem_userptr.c                            |   22=
=20
 drivers/gpu/drm/i915/i915_pmu.c                                    |    4=
=20
 drivers/i2c/busses/i2c-uniphier-f.c                                |   72 =
++
 drivers/infiniband/hw/bnxt_re/bnxt_re.h                            |    2=
=20
 drivers/infiniband/hw/bnxt_re/main.c                               |   44 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c                         |   13=
=20
 drivers/isdn/mISDN/tei.c                                           |    7=
=20
 drivers/macintosh/windfarm_smu_sat.c                               |   25 -
 drivers/md/dm-raid.c                                               |    2=
=20
 drivers/md/raid10.c                                                |    2=
=20
 drivers/media/i2c/ov13858.c                                        |    6=
=20
 drivers/media/platform/vivid/vivid-kthread-cap.c                   |    8=
=20
 drivers/media/platform/vivid/vivid-kthread-out.c                   |    8=
=20
 drivers/media/platform/vivid/vivid-sdr-cap.c                       |    8=
=20
 drivers/media/platform/vivid/vivid-vid-cap.c                       |    3=
=20
 drivers/media/platform/vivid/vivid-vid-out.c                       |    3=
=20
 drivers/media/rc/imon.c                                            |    3=
=20
 drivers/media/usb/b2c2/flexcop-usb.c                               |    3=
=20
 drivers/media/usb/dvb-usb/cxusb.c                                  |    3=
=20
 drivers/media/usb/usbvision/usbvision-video.c                      |   21=
=20
 drivers/media/usb/uvc/uvc_driver.c                                 |   28 -
 drivers/mfd/arizona-core.c                                         |    8=
=20
 drivers/mfd/intel_soc_pmic_bxtwc.c                                 |   41 +
 drivers/mfd/max8997.c                                              |    8=
=20
 drivers/mfd/mc13xxx-core.c                                         |    3=
=20
 drivers/misc/mic/scif/scif_fence.c                                 |    2=
=20
 drivers/mmc/host/mtk-sd.c                                          |   15=
=20
 drivers/net/dsa/bcm_sf2.c                                          |    4=
=20
 drivers/net/dsa/mv88e6xxx/chip.c                                   |    4=
=20
 drivers/net/dsa/mv88e6xxx/port.c                                   |   25 -
 drivers/net/dsa/mv88e6xxx/port.h                                   |    1=
=20
 drivers/net/ethernet/amazon/Kconfig                                |    2=
=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |    2=
=20
 drivers/net/ethernet/cadence/macb_main.c                           |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                    |   24=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c             |   12=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c            |    2=
=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c            |    4=
=20
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c                       |   48 +
 drivers/net/ethernet/intel/igb/igb_ptp.c                           |    8=
=20
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    9=
=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                     |    9=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c                  |    2=
=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                  |   10=
=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h                  |    1=
=20
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c                    |    2=
=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c              |   19=
=20
 drivers/net/ethernet/netronome/nfp/bpf/main.h                      |    7=
=20
 drivers/net/ethernet/netronome/nfp/bpf/offload.c                   |   18=
=20
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c                  |   58 =
++
 drivers/net/ethernet/qlogic/qed/qed.h                              |    2=
=20
 drivers/net/ethernet/qlogic/qed/qed_main.c                         |   22=
=20
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                          |   27 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.h                          |    5=
=20
 drivers/net/ethernet/qlogic/qed/qed_vf.c                           |    2=
=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c                    |    2=
=20
 drivers/net/ethernet/sfc/ptp.c                                     |    3=
=20
 drivers/net/ethernet/socionext/netsec.c                            |   19=
=20
 drivers/net/ethernet/ti/cpsw.c                                     |    1=
=20
 drivers/net/macsec.c                                               |   20=
=20
 drivers/net/ntb_netdev.c                                           |    2=
=20
 drivers/net/phy/dp83867.c                                          |   37 +
 drivers/net/vrf.c                                                  |   19=
=20
 drivers/net/wireless/ath/ath10k/mac.c                              |   14=
=20
 drivers/net/wireless/ath/ath10k/pci.c                              |   23=
=20
 drivers/net/wireless/ath/ath10k/snoc.c                             |    2=
=20
 drivers/net/wireless/ath/ath10k/usb.c                              |    8=
=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                     |    2=
=20
 drivers/net/wireless/ath/wil6210/debugfs.c                         |   15=
=20
 drivers/net/wireless/ath/wil6210/main.c                            |   11=
=20
 drivers/net/wireless/ath/wil6210/txrx_edma.c                       |   23=
=20
 drivers/net/wireless/ath/wil6210/wil6210.h                         |    1=
=20
 drivers/net/wireless/ath/wil6210/wmi.c                             |    9=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c     |   30 +
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h            |    1=
=20
 drivers/net/wireless/cisco/airo.c                                  |    2=
=20
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                    |   13=
=20
 drivers/net/wireless/marvell/mwifiex/ioctl.h                       |    1=
=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                   |   11=
=20
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c                    |    7=
=20
 drivers/net/wireless/mediatek/mt76/tx.c                            |    3=
=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c              |    1=
=20
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c                |    2=
=20
 drivers/net/wireless/ti/wlcore/vendor_cmd.c                        |    2=
=20
 drivers/nfc/port100.c                                              |    2=
=20
 drivers/ntb/hw/intel/ntb_hw_gen1.c                                 |    2=
=20
 drivers/nvme/host/core.c                                           |    2=
=20
 drivers/nvme/host/pci.c                                            |    8=
=20
 drivers/nvme/target/fcloop.c                                       |    1=
=20
 drivers/nvme/target/io-cmd-file.c                                  |    3=
=20
 drivers/of/unittest.c                                              |   58 =
+-
 drivers/pci/controller/dwc/pci-keystone.c                          |    3=
=20
 drivers/pci/controller/pcie-cadence-ep.c                           |    2=
=20
 drivers/pci/controller/pcie-mediatek.c                             |  143 =
++---
 drivers/pci/controller/vmd.c                                       |    2=
=20
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                              |    6=
=20
 drivers/pinctrl/cirrus/pinctrl-madera-core.c                       |    2=
=20
 drivers/pinctrl/pinctrl-lpc18xx.c                                  |   10=
=20
 drivers/pinctrl/pinctrl-zynq.c                                     |    9=
=20
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c                           |   21=
=20
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                              |   11=
=20
 drivers/platform/x86/intel_cht_int33fe.c                           |   24=
=20
 drivers/pwm/pwm-lpss.c                                             |   12=
=20
 drivers/rtc/rtc-s35390a.c                                          |    2=
=20
 drivers/scsi/bfa/bfa_defs_svc.h                                    |    2=
=20
 drivers/scsi/bfa/bfad_im.h                                         |    2=
=20
 drivers/scsi/dc395x.c                                              |   12=
=20
 drivers/scsi/hisi_sas/hisi_sas_main.c                              |   56 =
+-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                             |    2=
=20
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                             |    2=
=20
 drivers/scsi/ips.c                                                 |    1=
=20
 drivers/scsi/isci/host.c                                           |    8=
=20
 drivers/scsi/isci/host.h                                           |    2=
=20
 drivers/scsi/isci/request.c                                        |    4=
=20
 drivers/scsi/isci/task.c                                           |    4=
=20
 drivers/scsi/iscsi_tcp.c                                           |    3=
=20
 drivers/scsi/lpfc/lpfc.h                                           |    1=
=20
 drivers/scsi/lpfc/lpfc_els.c                                       |   95 =
+++
 drivers/scsi/lpfc/lpfc_hbadisc.c                                   |   29 +
 drivers/scsi/lpfc/lpfc_init.c                                      |    2=
=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                                 |    5=
=20
 drivers/scsi/lpfc/lpfc_sli.c                                       |   11=
=20
 drivers/scsi/lpfc/lpfc_sli4.h                                      |    1=
=20
 drivers/scsi/megaraid/megaraid_sas_base.c                          |    9=
=20
 drivers/scsi/mpt3sas/mpt3sas_base.c                                |    2=
=20
 drivers/scsi/mpt3sas/mpt3sas_config.c                              |    4=
=20
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                               |   36 +
 drivers/scsi/zorro_esp.c                                           |    8=
=20
 drivers/soc/bcm/brcmstb/pm/pm-arm.c                                |    2=
=20
 drivers/spi/spi-omap2-mcspi.c                                      |   26 -
 drivers/spi/spi-sh-msiof.c                                         |    4=
=20
 drivers/staging/comedi/drivers/usbduxfast.c                        |   21=
=20
 drivers/thermal/armada_thermal.c                                   |    4=
=20
 drivers/thermal/rcar_thermal.c                                     |    6=
=20
 drivers/tty/pty.c                                                  |   14=
=20
 drivers/tty/synclink_gt.c                                          |   16=
=20
 drivers/usb/misc/appledisplay.c                                    |   15=
=20
 drivers/usb/misc/chaoskey.c                                        |   24=
=20
 drivers/usb/serial/cp210x.c                                        |    1=
=20
 drivers/usb/serial/mos7720.c                                       |    4=
=20
 drivers/usb/serial/mos7840.c                                       |   16=
=20
 drivers/usb/serial/option.c                                        |    7=
=20
 drivers/usb/typec/tcpm.c                                           |    9=
=20
 drivers/usb/usbip/Kconfig                                          |    1=
=20
 drivers/usb/usbip/stub_rx.c                                        |   50 =
+-
 drivers/vhost/vsock.c                                              |   66 =
+-
 drivers/virtio/virtio_ring.c                                       |    2=
=20
 drivers/w1/slaves/w1_ds2438.c                                      |   66 =
++
 drivers/xen/balloon.c                                              |    3=
=20
 fs/btrfs/ctree.c                                                   |    4=
=20
 fs/btrfs/ioctl.c                                                   |    2=
=20
 fs/btrfs/super.c                                                   |    6=
=20
 fs/ceph/file.c                                                     |   45 -
 fs/ceph/inode.c                                                    |    1=
=20
 fs/cifs/smb2pdu.c                                                  |    6=
=20
 fs/dlm/member.c                                                    |    5=
=20
 fs/dlm/user.c                                                      |    2=
=20
 fs/f2fs/data.c                                                     |    8=
=20
 fs/f2fs/dir.c                                                      |    1=
=20
 fs/f2fs/f2fs.h                                                     |    2=
=20
 fs/f2fs/namei.c                                                    |    2=
=20
 fs/f2fs/segment.c                                                  |    4=
=20
 fs/f2fs/super.c                                                    |    5=
=20
 fs/gfs2/rgrp.c                                                     |   13=
=20
 fs/hfs/brec.c                                                      |    1=
=20
 fs/hfs/btree.c                                                     |   41 +
 fs/hfs/btree.h                                                     |    1=
=20
 fs/hfs/catalog.c                                                   |   16=
=20
 fs/hfs/extent.c                                                    |   10=
=20
 fs/hfs/inode.c                                                     |    2=
=20
 fs/hfsplus/attributes.c                                            |   10=
=20
 fs/hfsplus/brec.c                                                  |    1=
=20
 fs/hfsplus/btree.c                                                 |   44 +
 fs/hfsplus/catalog.c                                               |   24=
=20
 fs/hfsplus/extents.c                                               |    8=
=20
 fs/hfsplus/hfsplus_fs.h                                            |    2=
=20
 fs/hfsplus/inode.c                                                 |    1=
=20
 fs/ocfs2/buffer_head_io.c                                          |   77 =
++-
 fs/ocfs2/dlm/dlmdebug.c                                            |    2=
=20
 fs/ocfs2/dlmglue.c                                                 |    2=
=20
 fs/ocfs2/file.c                                                    |    4=
=20
 fs/ocfs2/journal.c                                                 |   51 =
+-
 fs/ocfs2/move_extents.c                                            |   17=
=20
 fs/ocfs2/stackglue.c                                               |    6=
=20
 fs/ocfs2/stackglue.h                                               |    3=
=20
 fs/ocfs2/xattr.c                                                   |   56 =
+-
 fs/read_write.c                                                    |   33 +
 fs/xfs/xfs_buf.c                                                   |   45 +
 fs/xfs/xfs_trans_ail.c                                             |   28 -
 include/linux/bitmap.h                                             |    9=
=20
 include/linux/futex.h                                              |    8=
=20
 include/linux/inetdevice.h                                         |    4=
=20
 include/linux/kvm_host.h                                           |    1=
=20
 include/linux/memory_hotplug.h                                     |    1=
=20
 include/linux/mfd/intel_soc_pmic.h                                 |    1=
=20
 include/linux/mfd/max8997.h                                        |    1=
=20
 include/linux/mfd/mc13xxx.h                                        |    1=
=20
 kernel/Makefile                                                    |    3=
=20
 kernel/auditsc.c                                                   |    2=
=20
 kernel/bpf/btf.c                                                   |   55 =
+-
 kernel/bpf/devmap.c                                                |    3=
=20
 kernel/dma/swiotlb.c                                               |   33 -
 kernel/futex.c                                                     |  247 =
+++++++++-
 kernel/futex_compat.c                                              |  202 =
--------
 kernel/irq/matrix.c                                                |    2=
=20
 kernel/panic.c                                                     |    2=
=20
 kernel/printk/printk.c                                             |   12=
=20
 kernel/sched/fair.c                                                |   13=
=20
 kernel/sched/topology.c                                            |    2=
=20
 lib/bitmap.c                                                       |   10=
=20
 mm/gup_benchmark.c                                                 |    3=
=20
 mm/ksm.c                                                           |   14=
=20
 mm/memcontrol.c                                                    |    2=
=20
 mm/memory_hotplug.c                                                |   76 =
++-
 mm/migrate.c                                                       |   25 -
 mm/page-writeback.c                                                |   33 -
 mm/page_io.c                                                       |    7=
=20
 net/core/dev.c                                                     |    2=
=20
 net/core/rtnetlink.c                                               |   23=
=20
 net/core/sock.c                                                    |    1=
=20
 net/ipv4/igmp.c                                                    |   53 =
+-
 net/ipv4/ip_sockglue.c                                             |    6=
=20
 net/ipv6/tcp_ipv6.c                                                |    3=
=20
 net/openvswitch/conntrack.c                                        |    3=
=20
 net/sched/act_pedit.c                                              |   12=
=20
 net/sched/act_tunnel_key.c                                         |    4=
=20
 net/sctp/socket.c                                                  |   38 -
 net/sunrpc/auth_gss/gss_krb5_seal.c                                |    1=
=20
 net/sunrpc/xprtsock.c                                              |   34 -
 net/unix/af_unix.c                                                 |    2=
=20
 net/vmw_vsock/virtio_transport_common.c                            |   15=
=20
 net/wireless/ap.c                                                  |    2=
=20
 net/wireless/core.h                                                |    2=
=20
 net/wireless/sme.c                                                 |    8=
=20
 sound/firewire/isight.c                                            |   10=
=20
 sound/i2c/cs8427.c                                                 |    2=
=20
 sound/soc/tegra/tegra_sgtl5000.c                                   |   17=
=20
 sound/usb/mixer.c                                                  |    3=
=20
 tools/bpf/bpftool/bash-completion/bpftool                          |    2=
=20
 tools/bpf/bpftool/common.c                                         |   15=
=20
 tools/bpf/bpftool/main.h                                           |    2=
=20
 tools/gpio/Build                                                   |    1=
=20
 tools/gpio/Makefile                                                |   10=
=20
 tools/objtool/arch/x86/tools/gen-insn-attr-x86.awk                 |    4=
=20
 tools/power/acpi/tools/acpidump/apmain.c                           |    2=
=20
 tools/power/x86/turbostat/turbostat.c                              |   93 =
++-
 tools/testing/selftests/bpf/test_libbpf.sh                         |    2=
=20
 tools/testing/selftests/bpf/trace_helpers.c                        |    1=
=20
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_syntax.tc |    3=
=20
 tools/testing/selftests/kvm/dirty_log_test.c                       |    4=
=20
 tools/testing/selftests/powerpc/cache_shape/Makefile               |    9=
=20
 tools/testing/selftests/powerpc/ptrace/Makefile                    |   13=
=20
 tools/testing/selftests/powerpc/signal/Makefile                    |   11=
=20
 tools/testing/selftests/powerpc/switch_endian/Makefile             |    1=
=20
 tools/testing/selftests/proc/fd-001-lookup.c                       |    2=
=20
 tools/testing/selftests/proc/fd-003-kthread.c                      |    2=
=20
 tools/testing/selftests/vm/gup_benchmark.c                         |    1=
=20
 tools/testing/selftests/watchdog/watchdog-test.c                   |   16=
=20
 tools/usb/usbip/libsrc/usbip_host_common.c                         |    8=
=20
 virt/kvm/kvm_main.c                                                |   26 -
 339 files changed, 3081 insertions(+), 1602 deletions(-)

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED

Ahmad Masri (1):
      wil6210: fix debugfs memory access alignment

Al Viro (2):
      pty: fix compat ioctls
      synclink_gt(): fix compat_ioctl()

Alan Douglas (1):
      PCI: cadence: Write MSI data with 32bits

Alan Stern (1):
      media: usbvision: Fix races among open, close, and disconnect

Aleksander Morgado (2):
      USB: serial: option: add support for DW5821e with eSIM support
      USB: serial: option: add support for Foxconn T77W968 LTE modules

Alexander Kapshuk (1):
      x86/insn: Fix awk regexp warnings

Alexander Popov (1):
      media: vivid: Fix wrong locking that causes race conditions on stream=
ing stop

Alexandre Belloni (1):
      clk: at91: audio-pll: fix audio pmc type

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU

Ali MJ Al-Nasrawy (2):
      brcmsmac: AP mode: update beacon when TIM changes
      brcmsmac: never log "tid x is not agg'able" by default

Andrea Arcangeli (1):
      mm: thp: fix MADV_DONTNEED vs migrate_misplaced_transhuge_page race c=
ondition

Andrea Parri (1):
      selftests: kvm: Fix -Wformat warnings

Andreas Gruenbacher (1):
      gfs2: Fix marking bitmaps non-full

Andrei Vagin (1):
      sock_diag: fix autoloading of the raw_diag module

Andrey Ryabinin (2):
      mm/ksm.c: don't WARN if page is still mapped in remove_stable_node()
      arm64: lib: use C string functions with KASAN enabled

Andy Shevchenko (1):
      mfd: intel_soc_pmic_bxtwc: Chain power button IRQs as well

Angelo Dureghello (1):
      m68k: fix command-line parsing when passed from u-boot

Anton Ivanov (1):
      um: Make line/tty semantics use true write IRQ

Aravinda Prasad (1):
      powerpc/pseries: Export raw per-CPU VPA data via debugfs

Arnd Bergmann (3):
      openvswitch: fix linking without CONFIG_NF_CONNTRACK_LABELS
      btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
      y2038: futex: Move compat implementation into futex.c

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: charge current handling for sink during hard reset

Bart Van Assche (2):
      nvmet: avoid integer overflow in the discard code
      nvmet-fcloop: suppress a compiler warning

Benjamin Herrenschmidt (1):
      macintosh/windfarm_smu_sat: Fix debug output

Bernd Porr (1):
      staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

Borislav Petkov (1):
      kernel/panic.c: do not append newline to the stack protector panic st=
ring

Brian Foster (1):
      xfs: clear ail delwri queued bufs on unmount of shutdown fs

Brian Masney (1):
      pinctrl: qcom: spmi-gpio: fix gpio-hog related boot issues

Brian Norris (1):
      ath10k: snoc: fix unbalanced clock error handling

Carl Huang (1):
      ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem

Changwei Ge (2):
      ocfs2: don't use iocb when EIOCBQUEUED returns
      ocfs2: don't put and assigning null to bh allocated outside

Chao Yu (2):
      f2fs: fix to spread clear_cold_data()
      f2fs: spread f2fs_set_inode_flags()

Chaotian Jing (2):
      mmc: mediatek: fill the actual clock for mmc debugfs
      mmc: mediatek: fix cannot receive new request when msdc_cmd_is_ready =
fail

Chester Lin (1):
      ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem bo=
undary

Chiranjeevi Rapolu (1):
      media: ov13858: Check for possible null pointer

Chris Wilson (2):
      drm/i915/pmu: "Frequency" is reported as accumulated cycles
      drm/i915/userptr: Try to acquire the page lock around set_page_dirty()

Christoph Hellwig (3):
      scsi: dc395x: fix dma API usage in srb_done
      scsi: dc395x: fix DMA API usage in sg_update_list
      swiotlb: do not panic on mapping failures

Christophe JAILLET (2):
      pinctrl: sunxi: Fix a memory leak in 'sunxi_pinctrl_build_state()'
      wlcore: Fix the return value in case of error in 'wlcore_vendor_cmd_s=
mart_config_start()'

Christopher M. Riedl (1):
      powerpc/64s: support nospectre_v2 cmdline option

Colin Ian King (3):
      usbip: tools: fix atoi() on non-null terminated string
      fs/hfs/extent.c: fix array out of bounds read of array extent
      ACPICA: Use %d for signed int print formatting instead of %u

Dan Carpenter (7):
      net: rtnetlink: prevent underflows in do_setvfinfo()
      powerpc: Fix signedness bug in update_flash_db()
      EDAC, thunderx: Fix memory leak in thunderx_l2c_threaded_isr()
      thermal: armada: fix a test in probe()
      qlcnic: fix a return in qlcnic_dcb_get_capability()
      mm/gup_benchmark.c: prevent integer overflow in ioctl
      wireless: airo: potential buffer overflow in sprintf()

Darrick J. Wong (1):
      vfs: avoid problematic remapping requests into partial EOF block

Dave Chinner (2):
      xfs: fix use-after-free race in xfs_buf_rele
      mm/page-writeback.c: fix range_cyclic writeback vs writepages deadlock

Dave Jiang (1):
      ntb: intel: fix return value for ndev_vec_mask()

David Ahern (1):
      ipv6: Fix handling of LLA with VRF and sockets bound to VRF

David Hildenbrand (4):
      mm/memory_hotplug: make add_memory() take the device_hotplug_lock
      mm/memory_hotplug: fix online/offline_pages called w.o. mem_hotplug_l=
ock
      powerpc/powernv: hold device_hotplug_lock when calling device_online()
      mm/memory_hotplug: don't access uninitialized memmaps in shrink_zone_=
span()

David S. Miller (2):
      sparc: Fix parport build warnings.
      sparc64: Rework xchg() definition to avoid warnings.

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Denis Efremov (1):
      ath9k_hw: fix uninitialized variable data

Devesh Sharma (1):
      RDMA/bnxt_re: Fix qp async event reporting

Dmitry Osipenko (1):
      clk: tegra20: Turn EMC clock gate into divider

Duncan Laurie (1):
      gsmi: Fix bug in append_to_eventlog sysfs handler

Eran Ben Elisha (1):
      net/mlxfw: Verify FSM error code translation doesn't exceed array size

Eric Dumazet (1):
      net: do not abort bulk send on BQL status

Ernesto A. Fern=E1ndez (8):
      hfsplus: fix BUG on bnode parent update
      hfs: fix BUG on bnode parent update
      hfsplus: prevent btree data loss on ENOSPC
      hfs: prevent btree data loss on ENOSPC
      hfsplus: fix return value of hfsplus_get_block()
      hfs: fix return value of hfs_get_block()
      hfsplus: update timestamps on truncate()
      hfs: update timestamp on truncate()

Evan Quan (1):
      drm/amd/powerplay: issue no PPSMC_MSG_GetCurrPkgPwr on unsupported AS=
ICs

Ezequiel Garcia (1):
      PM / devfreq: Fix kernel oops on governor module load

Fabio Estevam (1):
      mfd: mc13xxx-core: Fix PMIC shutdown when reading ADC values

Felipe Rechia (1):
      powerpc/process: Fix flush_all_to_thread for SPE

Felix Fietkau (1):
      mt76: do not store aggregation sequence number for null-data frames

Finn Thain (1):
      scsi: zorro_esp: Limit DMA transfers to 65535 bytes

Florian Fainelli (2):
      soc: bcm: brcmstb: Fix re-entry point with a THUMB2_KERNEL
      net: dsa: bcm_sf2: Turn on PHY to allow successful registration

Frank Rowand (2):
      of: unittest: allow base devicetree to have symbol metadata
      of: unittest: initialize args before calling of_*parse_*()

Gang He (1):
      ocfs2: remove ocfs2_is_o2cb_active()

Garry McNulty (1):
      fs/cifs: fix uninitialised variable warnings

Geert Uytterhoeven (1):
      thermal: rcar_thermal: Prevent hardware access during system suspend

Greg Kroah-Hartman (2):
      usb-serial: cp201x: support Mark-10 digital force gauge
      Linux 4.19.87

Guozhonghua (1):
      ocfs2: without quota support, avoid calling quota recovery

Gustavo A. R. Silva (4):
      pinctrl: madera: Fix uninitialized variable bug in madera_mux_set_mux
      scsi: ips: fix missing break in switch
      scsi: hisi_sas: Fix NULL pointer dereference
      rtl8xxxu: Fix missing break in switch

Halil Pasic (1):
      virtio_ring: fix return code on DMA mapping fails

Hangbin Liu (1):
      ipv4/igmp: fix v1/v2 switchback timeout based on rfc3376, 8.12

Hans de Goede (2):
      pwm: lpss: Only set update bit if we are actually changing the settin=
gs
      ACPI / scan: Create platform device for INT33FE ACPI nodes

Heinz Mauelshagen (1):
      dm raid: avoid bitmap with raid4/5/6 journal device

Hewenliang (1):
      usbip: tools: fix fd leakage in the function of read_attr_usbip_status

Honghui Zhang (2):
      PCI: mediatek: Fix class type for MT7622 to PCI_CLASS_BRIDGE_PCI
      PCI: mediatek: Fixup MSI enablement logic by enabling MSI before cloc=
ks

Huazhong Tan (4):
      net: hns3: bugfix for buffer not free problem during resetting
      net: hns3: bugfix for reporting unknown vector0 interrupt repeatly pr=
oblem
      net: hns3: bugfix for is_valid_csq_clean_head()
      net: hns3: bugfix for hclge_mdio_write and hclge_mdio_read

Hui Peng (1):
      ath10k: Fix a NULL-ptr-deref bug in ath10k_usb_alloc_urb_from_pipe

Icenowy Zheng (1):
      clk: sunxi-ng: enable so-said LDOs for A64 SoC's pll-mipi clock

Igor Konopko (1):
      nvme-pci: fix surprise removal

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpsw: unsync mcast entries while switch promisc mo=
de

J. Bruce Fields (1):
      sunrpc: safely reallow resvport min/max inversion

Jacob Keller (1):
      fm10k: ensure completer aborts are marked as non-fatal after a resume

Jakub Kicinski (1):
      nfp: bpf: protect against mis-initializing atomic counters

James Smart (3):
      scsi: lpfc: fcoe: Fix link down issue after 1000+ link bounces
      scsi: lpfc: Fix odd recovery in duplicate FLOGIs in point-to-point
      scsi: lpfc: Correct loss of fc4 type on remote port address change

Jens Axboe (2):
      skd: fixup usage of legacy IO API
      cdrom: don't attempt to fiddle with cdo->capability

Jerry Hoemann (1):
      selftests: watchdog: Fix error message.

Jia-Ju Bai (1):
      fs/ocfs2/dlm/dlmdebug.c: fix a sleep-in-atomic-context bug in dlm_pri=
nt_one_mle()

Jianchao Wang (1):
      block: fix the DISCARD request merge

Jithu Joseph (1):
      x86/intel_rdt: Prevent pseudo-locking from using stale pointers

Joel Stanley (5):
      powerpc/boot: Fix opal console in boot wrapper
      powerpc/boot: Disable vector instructions
      powerpc/xmon: Relax frame size for clang
      selftests/powerpc/ptrace: Fix out-of-tree build
      selftests/powerpc/signal: Fix out-of-tree build

Johan Hovold (2):
      USB: serial: mos7720: fix remote wakeup
      USB: serial: mos7840: fix remote wakeup

Johannes Berg (1):
      cfg80211: call disconnect_wk when AP stops

John Pittman (1):
      md/raid10: prevent access of uninitialized resync_pages offset

Jon Derrick (1):
      PCI: vmd: Detach resources after stopping root bus

Jon Mason (1):
      ntb_netdev: fix sleep time mismatch

Joseph Lo (1):
      clk: tegra: Fixes for MBIST work around

Joseph Qi (1):
      Revert "fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa=
_prepare_entry()"

Julien Folly (1):
      w1: IAD Register is yet readable trough iad sys file. Fix snprintf (%=
u for unsigned, count for max size).

Kai Shen (1):
      cpufreq: Add NULL checks to show() and store() methods of cpufreq

Keiji Hayashibara (1):
      spi: uniphier: fix incorrect property items

Keith Busch (3):
      nvme-pci: fix hot removal during error handling
      tools/testing/selftests/vm/gup_benchmark.c: fix 'write' flag usage
      nvme-pci: fix conflicting p2p resource adds

Kishon Vijay Abraham I (1):
      PCI: keystone: Use quirk to limit MRRS for K2G

Kyeongdon Kim (1):
      net: fix warning in af_unix

Larry Chen (1):
      ocfs2: fix clusters leak in ocfs2_defrag_extent()

Laura Abbott (1):
      tools: gpio: Correctly add make dependencies for gpio_utils

Laurent Pinchart (1):
      media: uvcvideo: Fix error path in control parsing failure

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Len Brown (1):
      tools/power turbosat: fix AMD APIC-id output

Leonard Crestez (1):
      ARM: dts: imx6sx-sdb: Fix enet phy regulator

Lior David (1):
      wil6210: fix locking in wmi_call

Lorenzo Bianconi (1):
      mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc

Lubomir Rintel (1):
      clk: mmp2: fix the clock id for sdh2_clk and sdh3_clk

Luigi Rizzo (1):
      net/mlx4_en: fix mlx4 ethtool -N insertion

Luis Henriques (1):
      ceph: only allow punch hole mode in fallocate

Luo Jiaxing (1):
      scsi: hisi_sas: Feed back linkrate(max/min) when re-attached

Maor Gottlieb (1):
      net/mlx5: Fix auto group size calculation

Marcel Ziswiler (1):
      ASoC: tegra_sgtl5000: fix device_node refcounting

Marek Beh=FAn (1):
      net: dsa: mv88e6xxx: Fix 88E6141/6341 2500mbps SERDES speed

Marek Szyprowski (1):
      mfd: max8997: Enale irq-wakeup unconditionally

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Martin Lau (1):
      bpf, btf: fix a missing check bug in btf_parse

Masahiro Yamada (4):
      i2c: uniphier-f: make driver robust against concurrency
      i2c: uniphier-f: fix occasional timeout error
      i2c: uniphier-f: fix race condition when IRQ is cleared
      i2c: uniphier-f: fix timeout error after reading 8 bytes

Masahisa Kojima (1):
      net: socionext: Stop PHY before resetting netsec

Masami Hiramatsu (1):
      selftests/ftrace: Fix to test kprobe $comm arg only if available

Mattias Jacobsson (1):
      USB: misc: appledisplay: fix backlight update_status return code

Max Uvarov (2):
      net: phy: dp83867: fix speed 10 in sgmii mode
      net: phy: dp83867: increase SGMII autoneg timer duration

Maya Erez (2):
      wil6210: fix L2 RX status handling
      wil6210: fix RGF_CAF_ICR address for Talyn-MB

Michael Ellerman (7):
      powerpc/mm/radix: Fix off-by-one in split mapping logic
      powerpc/mm/radix: Fix overuse of small pages in splitting logic
      powerpc/mm/radix: Fix small page at boundary when splitting
      selftests/powerpc/switch_endian: Fix out-of-tree build
      selftests/powerpc/cache_shape: Fix out-of-tree build
      powerpc/book3s64: Fix link stack flush on context switch
      KVM: PPC: Book3S HV: Flush link stack on guest exit to host kernel

Michael Kelley (1):
      irq/matrix: Fix memory overallocation

Michael Schupikov (1):
      crypto: testmgr - fix sizeof() on COMP_BUF_SIZE

Mike Manning (1):
      vrf: mark skb for multicast or link-local as enslaved to VRF

Ming Lei (1):
      block: call rq_qos_exit() after queue is frozen

Miroslav Lichvar (1):
      igb: shorten maximum PHC timecounter update interval

Nathan Chancellor (11):
      scsi: isci: Use proper enumerated type in atapi_d2h_reg_frame_handler
      scsi: isci: Change sci_controller_start_task's return type to sci_sta=
tus
      scsi: bfa: Avoid implicit enum conversion in bfad_im_post_vendor_event
      scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
      crypto: ccree - avoid implicit enum conversion
      atm: zatm: Fix empty body Clang warnings
      rtc: s35390a: Change buf's type to u8 in s35390a_init
      mISDN: Fix type of switch control variable in ctrl_teimanager
      pinctrl: bcm2835: Use define directive for BCM2835_PINCONF_PARAM_PULL
      pinctrl: lpc18xx: Use define directive for PIN_CONFIG_GPIO_PIN_INT
      pinctrl: zynq: Use define directive for PIN_CONFIG_IO_STANDARD

Navid Emamdoost (1):
      nbd: prevent memory leak

Netanel Belgazal (1):
      net: ena: Fix Kconfig dependency on X86

Nicholas Piggin (1):
      powerpc/64s/radix: Fix radix__flush_tlb_collapsed_pmd double flushing=
 pmd

Nickhu (1):
      nds32: Fix bug in bitfield.h

Nikolay Borisov (1):
      btrfs: handle error of get_old_root

Oliver Neukum (5):
      nfc: port100: handle command failure cleanly
      media: b2c2-flexcop-usb: add sanity checking
      USBIP: add config dependency for SGL_ALLOC
      USB: chaoskey: fix error case of a timeout
      appledisplay: fix error handling in the scheduled work

Omar Sandoval (1):
      amiflop: clean up on errors during setup

Pavel L=F6bl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210

Peng Hao (2):
      selftests/bpf: fix file resource leak in load_kallsyms
      selftests: fix warning: "_GNU_SOURCE" redefined

Peter Zijlstra (1):
      sched/topology: Fix off by one bug

Petr Machata (1):
      mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel

Philipp Klocke (1):
      ALSA: i2c/cs8427: Fix int to char conversion

Quentin Monnet (3):
      selftests/bpf: fix return value comparison for tests in test_libbpf.sh
      tools: bpftool: fix completion for "bpftool map update"
      tools: bpftool: pass an argument to silence open_obj_pinned()

Rahul Verma (1):
      qed: Align local and global PTT to propagate through the APIs.

Rakesh Pillai (1):
      ath10k: set probe request oui during driver start

Rasmus Villemoes (3):
      linux/bitmap.h: handle constant zero-size bitmaps correctly
      linux/bitmap.h: fix type of nbits in bitmap_shift_right()
      lib/bitmap.c: fix remaining space computation in bitmap_print_to_page=
buf

Richard Guy Briggs (1):
      audit: print empty EXECVE args

Roi Dayan (1):
      net/mlx5e: Fix set vf link state error flow

Roman Gushchin (1):
      mm: handle no memcg case in memcg_kmem_charge() properly

Sabrina Dubroca (2):
      macsec: update operstate when lower device changes
      macsec: let the administrator set UP state even if lowerdev is down

Sam Bobroff (2):
      powerpc/eeh: Fix null deref for devices removed during EEH
      powerpc/eeh: Fix use of EEH_PE_KEEP on wrong field

Sapthagiri Baratam (1):
      mfd: arizona: Correct calling of runtime_put_sync

Sean Christopherson (3):
      KVM: nVMX: reset cache/shadows when switching loaded VMCS
      KVM: nVMX: move check_vmentry_postreqs() call to nested_vmx_enter_non=
_root_mode()
      KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved

Sean Young (1):
      media: imon: invalid dereference in imon_touch_event

Selvin Xavier (2):
      RDMA/bnxt_re: Avoid NULL check after accessing the pointer
      RDMA/bnxt_re: Avoid resource leak in case the NQ registration fails

Sergei Shtylyov (2):
      spi: sh-msiof: fix deferred probing
      thermal: rcar_thermal: fix duplicate IRQ request

Sergey Senozhatsky (2):
      printk: lock/unlock console only for new logbuf entries
      printk: fix integer overflow in setup_log_buf()

Shaokun Zhang (1):
      rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information

Shivasharan S (2):
      scsi: megaraid_sas: Fix msleep granularity
      scsi: megaraid_sas: Fix goto labels in error handling

Shuah Khan (Samsung OSG) (1):
      selftests: watchdog: fix message when /dev/watchdog open fails

Sriram R (1):
      cfg80211: Prevent regulatory restore during STA disconnect in concurr=
ent interfaces

Stefano Garzarella (1):
      vhost/vsock: split packets to send using multiple buffers

Steven Rostedt (VMware) (1):
      kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on =
bad stack

Su Yue (1):
      btrfs: defrag: use btrfs_mod_outstanding_extents in cluster_pages_for=
_defrag

Suganath Prabu (3):
      scsi: mpt3sas: Fix Sync cache command failure during driver unload
      scsi: mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA d=
evices
      scsi: mpt3sas: Fix driver modifying persistent data in Manufacturing =
page11

Sun Ke (1):
      nbd:fix memory leak in nbd_get_socket()

Suwan Kim (1):
      usbip: Fix uninitialized symbol 'nents' in stub_recv_cmd_submit()

Taehee Yoo (2):
      bpf: devmap: fix wrong interface selection in notifier_call
      net: bpfilter: fix iptables failure if bpfilter_umh is disabled

Takashi Iwai (1):
      ALSA: usb-audio: Fix NULL dereference at parsing BADD

Takashi Sakamoto (1):
      ALSA: isight: fix leak of reference to firewire unit in error path of=
 .probe callback

Tariq Toukan (1):
      net/mlx4_en: Fix wrong limitation for number of TX rings

Thierry Reding (1):
      gpio: max77620: Fixup debounce delays

Thomas Richter (1):
      s390/perf: Return error when debug_register fails

Tomas Bortoli (1):
      Bluetooth: Fix invalid-free in bcsp_close()

Tristram Ha (1):
      net: ethernet: cadence: fix socket buffer corruption problem

Trond Myklebust (1):
      SUNRPC: Fix a compile warning for cmpxchg64()

Tycho Andersen (2):
      dlm: fix invalid free
      dlm: don't leak kernel pointer to userspace

Ulf Hansson (1):
      PM / Domains: Deal with multiple states but no governor in genpd

Uros Bizjak (1):
      KVM/x86: Fix invvpid and invept register operand size in 64-bit mode

Valentin Schneider (1):
      sched/fair: Don't increase sd->balance_interval on newidle balance

Vandana BN (1):
      media: vivid: Set vid_cap_streaming and vid_out_streaming to true

Victor Kamensky (1):
      arm64: makefile fix build of .i file in external module case

Vignesh R (2):
      spi: omap2-mcspi: Set FIFO DMA trigger level to word length
      spi: omap2-mcspi: Fix DMA and FIFO event trigger size mismatch

Vinayak Menon (1):
      mm/page_io.c: do not free shared swap slots

Vincent Chen (1):
      RISC-V: Avoid corrupting the upper 32-bit of phys_addr_t in ioremap

Vito Caputo (1):
      media: cxusb: detect cxusb_ctrl_msg error in query

Waiman Long (2):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
      x86/speculation: Fix redundant MDS mitigation message

Wenwen Wang (1):
      misc: mic: fix a DMA pool free failure

Xiang Chen (2):
      scsi: hisi_sas: Fix the race between IO completion and timeout for SM=
P/internal IO
      scsi: hisi_sas: Free slot later in slot_complete_vx_hw()

Xin Long (2):
      net: sched: ensure opts_len <=3D IP_TUNNEL_OPTS_MAX in act_tunnel_key
      sctp: use sk_wmem_queued to check for writable space

Yan, Zheng (1):
      ceph: fix dentry leak in ceph_readdir_prepopulate

Yang Tao (1):
      futex: Prevent robust futex exit race

YueHaibing (1):
      net: bcmgenet: return correct value 'ret' from bcmgenet_power_down

zhong jiang (1):
      mm/memory_hotplug: Do not unlock when fails to take the device_hotplu=
g_lock


--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3jiscACgkQONu9yGCS
aT4jdBAAsslJoKr/cqdZQYfJieacEz5xXkDnevapboN0dO+L78cyDcPqEPnb+ES0
yawTEkaBNLfTKJZKKAhNHK+dpVKtvSESMgmr1aKZLgDb1lrv/dFTq/IdrSy5E4Wt
KQUdbO+8vbTQvl8b04IZ1CB1EWuSUdjpkj/fG1trBuQ7T6ignUylWUEJtbOs30L8
wpQr7kk/v3tt9t3zkHs4UWCcZhsL4ZZ9M5B0UfXLOsL0RvlC40GjqeHvOTIjdkQW
oEDjls2CQB8DTVEemJB+2lQvZIWNB+bklenXxioQfpuvthYNJwHT+jDkc5I/LiAO
Zdis95L4+wNh0Sg6knsCcXzw7UPzQNZeFsETxb9fPXZR7/Zx5DDBJgfc2YSdEUlv
pWC/b2Sf/txR+0tTNxoim37VrQLlKs4JdBpq2KZxZrPFFFTjtt5t5Es5LKoWU5ZL
7I3lqS9LZU7+yjawlCqtAy1av3lPhW/avSkhK8tYvss9d4L9AkupUcxf7BLrizLm
3MdYYmPkBO0Y9F0GYekfAHg9S2uoGoewuYUtbL08bCJf5MyvEQ/ASy25/1H8tmsC
23a5c0vpbCrEYZGFqSyJ5ANrg3hrFbkhbhGRyL9vQqkG22FLVmMNhpOKRLcpflmR
Z4YEaPKk7jbeORI5hZ/Har331hjDcO3VanHVcgPwGz5cKpApIzA=
=AlGO
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
