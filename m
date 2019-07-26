Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485827611C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 10:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfGZIqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 04:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfGZIqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 04:46:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AA62166E;
        Fri, 26 Jul 2019 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564130761;
        bh=/HBfdUI9upoiarReaAWWYfWK4DBevM0Kl8c9qp2BBmQ=;
        h=Date:From:To:Cc:Subject:From;
        b=H0yEIHN5tRvPI4gBiEvH7zpBqj6AlhAC3pLE0ZxQRD1aYiTjAQ2Yw2k2b87c2vOCK
         ukSsFR3FQdSc61B4s5Yqw/uXP7owZ0v5MMi04aLtL4NFP+JxF9ObefS4LywcWb2PXt
         /wHzfYsniZ5GAgMST/xVs5plM2Sy2H2T4YeofQkE=
Date:   Fri, 26 Jul 2019 10:45:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.61
Message-ID: <20190726084558.GA29604@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.61 kernel.

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

 Documentation/atomic_t.txt                                   |    3=20
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |    2=20
 Documentation/scheduler/sched-pelt.c                         |    3=20
 Makefile                                                     |    2=20
 arch/arm64/Kconfig                                           |    3=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi               |    3=20
 arch/arm64/boot/dts/nvidia/tegra210.dtsi                     |    2=20
 arch/arm64/crypto/sha1-ce-glue.c                             |    2=20
 arch/arm64/crypto/sha2-ce-glue.c                             |    2=20
 arch/arm64/kernel/acpi.c                                     |   10=20
 arch/arm64/kernel/entry.S                                    |    4=20
 arch/arm64/kernel/image.h                                    |    6=20
 arch/arm64/mm/init.c                                         |    5=20
 arch/mips/boot/compressed/Makefile                           |    2=20
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c           |    2=20
 arch/mips/include/asm/mach-ath79/ar933x_uart.h               |    4=20
 arch/parisc/kernel/ptrace.c                                  |   31=20
 arch/powerpc/kernel/exceptions-64s.S                         |    9=20
 arch/powerpc/kernel/swsusp_32.S                              |   73=20
 arch/powerpc/platforms/powermac/sleep.S                      |   68=20
 arch/powerpc/platforms/powernv/npu-dma.c                     |   15=20
 arch/powerpc/platforms/pseries/hotplug-memory.c              |    3=20
 arch/x86/events/amd/uncore.c                                 |   15=20
 arch/x86/events/intel/core.c                                 |    8=20
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
 block/blk-cgroup.c                                           |    8=20
 block/blk-iolatency.c                                        |    8=20
 block/blk-throttle.c                                         |    9=20
 crypto/asymmetric_keys/Kconfig                               |    3=20
 crypto/chacha20poly1305.c                                    |   30=20
 crypto/ghash-generic.c                                       |    8=20
 crypto/serpent_generic.c                                     |    8=20
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
 drivers/clocksource/exynos_mct.c                             |    4=20
 drivers/crypto/amcc/crypto4xx_alg.c                          |   36=20
 drivers/crypto/amcc/crypto4xx_core.c                         |   24=20
 drivers/crypto/amcc/crypto4xx_core.h                         |   10=20
 drivers/crypto/amcc/crypto4xx_trng.c                         |    1=20
 drivers/crypto/caam/caamalg.c                                |   15=20
 drivers/crypto/ccp/ccp-dev.c                                 |   96=20
 drivers/crypto/ccp/ccp-dev.h                                 |    2=20
 drivers/crypto/ccp/ccp-ops.c                                 |   15=20
 drivers/crypto/inside-secure/safexcel_cipher.c               |   24=20
 drivers/crypto/talitos.c                                     |   35=20
 drivers/dma/imx-sdma.c                                       |   48=20
 drivers/edac/edac_mc_sysfs.c                                 |   24=20
 drivers/edac/edac_module.h                                   |    2=20
 drivers/gpio/gpio-omap.c                                     |   17=20
 drivers/gpio/gpiolib.c                                       |    7=20
 drivers/gpu/drm/drm_edid.c                                   |   81=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c               |   20=20
 drivers/gpu/ipu-v3/ipu-ic.c                                  |    2=20
 drivers/hid/wacom_sys.c                                      |    3=20
 drivers/hid/wacom_wac.c                                      |   19=20
 drivers/hid/wacom_wac.h                                      |    1=20
 drivers/hwtracing/intel_th/msu.c                             |    2=20
 drivers/hwtracing/intel_th/pci.c                             |    5=20
 drivers/infiniband/hw/mlx5/main.c                            |    8=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c                    |    1=20
 drivers/input/mouse/alps.c                                   |   32=20
 drivers/input/mouse/synaptics.c                              |    1=20
 drivers/input/tablet/gtco.c                                  |   20=20
 drivers/iommu/iommu.c                                        |    8=20
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
 drivers/media/i2c/ov7740.c                                   |    6=20
 drivers/media/media-device.c                                 |   10=20
 drivers/media/pci/saa7164/saa7164-core.c                     |   33=20
 drivers/media/platform/coda/coda-bit.c                       |    9=20
 drivers/media/platform/coda/coda-common.c                    |    2=20
 drivers/media/platform/davinci/vpss.c                        |    5=20
 drivers/media/platform/marvell-ccic/mcam-core.c              |    5=20
 drivers/media/platform/rcar_fdp1.c                           |    8=20
 drivers/media/platform/s5p-mfc/s5p_mfc.c                     |    3=20
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                  |    5=20
 drivers/media/platform/vimc/vimc-capture.c                   |    5=20
 drivers/media/radio/wl128x/fmdrv_v4l2.c                      |    3=20
 drivers/media/rc/ir-spi.c                                    |    1=20
 drivers/media/usb/dvb-usb/dvb-usb-init.c                     |    7=20
 drivers/media/usb/hdpvr/hdpvr-video.c                        |   17=20
 drivers/media/usb/uvc/uvc_ctrl.c                             |    4=20
 drivers/media/v4l2-core/v4l2-ctrls.c                         |    9=20
 drivers/mmc/host/sdhci-msm.c                                 |    9=20
 drivers/mtd/nand/raw/mtk_nand.c                              |   24=20
 drivers/mtd/nand/spi/core.c                                  |    2=20
 drivers/net/bonding/bond_main.c                              |   37=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c          |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             |   33=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h            |    3=20
 drivers/net/ethernet/freescale/fec_main.c                    |    6=20
 drivers/net/ethernet/hisilicon/hns3/hnae3.c                  |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c           |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c      |    3=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c        |    6=20
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                |    6=20
 drivers/net/ethernet/intel/igb/igb_main.c                    |    1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c             |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                 |    1=20
 drivers/net/ethernet/marvell/mvmdio.c                        |    7=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c               |    3=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                    |   29=20
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                  |    2=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                   |    2=20
 drivers/net/ethernet/stmicro/stmmac/common.h                 |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c            |    5=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c         |    6=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c            |   18=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |   20=20
 drivers/net/gtp.c                                            |   36=20
 drivers/net/phy/phy_device.c                                 |    6=20
 drivers/net/phy/sfp.c                                        |    6=20
 drivers/net/usb/asix_devices.c                               |    6=20
 drivers/net/wireless/ath/ath10k/hw.c                         |    2=20
 drivers/net/wireless/ath/ath10k/mac.c                        |    4=20
 drivers/net/wireless/ath/ath10k/sdio.c                       |    7=20
 drivers/net/wireless/ath/ath10k/txrx.c                       |    3=20
 drivers/net/wireless/ath/ath6kl/wmi.c                        |   10=20
 drivers/net/wireless/ath/ath9k/hw.c                          |   32=20
 drivers/net/wireless/ath/dfs_pattern_detector.c              |    2=20
 drivers/net/wireless/ath/wil6210/interrupt.c                 |   65=20
 drivers/net/wireless/ath/wil6210/txrx.c                      |    1=20
 drivers/net/wireless/ath/wil6210/wmi.c                       |   13=20
 drivers/net/wireless/intel/iwlwifi/fw/smem.c                 |   12=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                  |    3=20
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c     |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c          |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h           |   27=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                 |   66=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c         |    9=20
 drivers/net/wireless/mediatek/mt7601u/dma.c                  |   54=20
 drivers/net/wireless/mediatek/mt7601u/tx.c                   |    4=20
 drivers/net/wireless/realtek/rtlwifi/usb.c                   |    5=20
 drivers/nvdimm/dax_devs.c                                    |    2=20
 drivers/nvdimm/pfn.h                                         |    1=20
 drivers/nvdimm/pfn_devs.c                                    |   18=20
 drivers/nvme/host/core.c                                     |   14=20
 drivers/nvme/host/pci.c                                      |    8=20
 drivers/pci/controller/dwc/pcie-qcom.c                       |    2=20
 drivers/pci/controller/pci-hyperv.c                          |   15=20
 drivers/pci/pci.c                                            |    7=20
 drivers/ras/cec.c                                            |    4=20
 drivers/regulator/s2mps11.c                                  |    4=20
 drivers/s390/cio/qdio_main.c                                 |    1=20
 drivers/scsi/NCR5380.c                                       |   33=20
 drivers/scsi/NCR5380.h                                       |    2=20
 drivers/scsi/mac_scsi.c                                      |  375 +-
 drivers/scsi/megaraid/megaraid_sas_base.c                    |    3=20
 drivers/scsi/scsi_lib.c                                      |    6=20
 drivers/staging/media/davinci_vpfe/vpfe_video.c              |    3=20
 drivers/target/iscsi/iscsi_target_auth.c                     |   16=20
 drivers/usb/core/hub.c                                       |    7=20
 drivers/vhost/net.c                                          |    2=20
 drivers/xen/balloon.c                                        |   16=20
 drivers/xen/events/events_base.c                             |   12=20
 drivers/xen/evtchn.c                                         |    2=20
 fs/btrfs/file.c                                              |    5=20
 fs/btrfs/tree-log.c                                          |   40=20
 fs/coda/file.c                                               |   70=20
 fs/crypto/crypto.c                                           |   15=20
 fs/ecryptfs/crypto.c                                         |   12=20
 fs/fs-writeback.c                                            |    8=20
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                    |    2=20
 fs/nfs/inode.c                                               |    1=20
 fs/nfs/nfs4file.c                                            |    2=20
 fs/nfs/pnfs.c                                                |    4=20
 fs/proc/proc_sysctl.c                                        |    4=20
 fs/xfs/libxfs/xfs_ag_resv.c                                  |    2=20
 fs/xfs/libxfs/xfs_ialloc_btree.c                             |    4=20
 fs/xfs/xfs_attr_list.c                                       |    1=20
 fs/xfs/xfs_bmap_util.c                                       |    2=20
 fs/xfs/xfs_bmap_util.h                                       |    2=20
 fs/xfs/xfs_file.c                                            |   27=20
 fs/xfs/xfs_fsops.c                                           |    1=20
 fs/xfs/xfs_inode.c                                           |   18=20
 fs/xfs/xfs_iops.c                                            |   21=20
 fs/xfs/xfs_mount.h                                           |    2=20
 fs/xfs/xfs_reflink.c                                         |   16=20
 fs/xfs/xfs_super.c                                           |    7=20
 fs/xfs/xfs_xattr.c                                           |    3=20
 include/asm-generic/bug.h                                    |    6=20
 include/drm/drm_displayid.h                                  |   10=20
 include/linux/cpuhotplug.h                                   |    2=20
 include/linux/rcupdate.h                                     |    2=20
 include/net/ip_vs.h                                          |    6=20
 include/rdma/ib_verbs.h                                      |    4=20
 include/trace/events/rxrpc.h                                 |    2=20
 include/uapi/linux/bpf.h                                     |    1=20
 include/xen/events.h                                         |    3=20
 kernel/bpf/Makefile                                          |    1=20
 kernel/locking/lockdep.c                                     |   18=20
 kernel/padata.c                                              |   12=20
 kernel/pid_namespace.c                                       |    2=20
 kernel/sched/core.c                                          |    2=20
 kernel/sched/sched-pelt.h                                    |    2=20
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
 net/bluetooth/l2cap_core.c                                   |   15=20
 net/bluetooth/smp.c                                          |   13=20
 net/key/af_key.c                                             |    8=20
 net/netfilter/ipset/ip_set_hash_gen.h                        |    2=20
 net/netfilter/ipvs/ip_vs_core.c                              |   21=20
 net/netfilter/ipvs/ip_vs_ctl.c                               |    4=20
 net/netfilter/ipvs/ip_vs_sync.c                              |  134=20
 net/xdp/xsk_queue.h                                          |    2=20
 net/xfrm/Kconfig                                             |    2=20
 net/xfrm/xfrm_user.c                                         |   19=20
 scripts/kconfig/confdata.c                                   |    7=20
 scripts/kconfig/expr.h                                       |    1=20
 security/selinux/hooks.c                                     |   11=20
 sound/core/seq/seq_clientmgr.c                               |   11=20
 sound/pci/hda/patch_realtek.c                                |   10=20
 sound/soc/codecs/hdac_hdmi.c                                 |    6=20
 sound/soc/meson/axg-tdm.h                                    |    2=20
 sound/soc/soc-dapm.c                                         |   18=20
 tools/bpf/bpftool/jit_disasm.c                               |   11=20
 tools/include/uapi/linux/bpf.h                               |    1=20
 tools/lib/bpf/libbpf.c                                       |    8=20
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
 tools/perf/util/stat-shadow.c                                |    5=20
 tools/power/cpupower/utils/cpufreq-set.c                     |    2=20
 tools/testing/selftests/bpf/test_lwt_seg6local.c             |   12=20
 280 files changed, 4523 insertions(+), 3058 deletions(-)

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

Alexander Shishkin (2):
      intel_th: pci: Add Ice Lake NNPI support
      intel_th: msu: Fix single mode with disabled IOMMU

Amadeusz S=C5=82awi=C5=84ski (1):
      ASoC: Intel: hdac_hdmi: Set ops to NULL on remove

Anders Roxell (1):
      media: i2c: fix warning same module names

Andi Kleen (2):
      perf stat: Make metric event lookup more robust
      perf stat: Fix group lookup for metric group

Andrei Otcheretianski (1):
      iwlwifi: mvm: Drop large non sta frames

Andres Rodriguez (1):
      drm/edid: parse CEA blocks embedded in DisplayID

Andr=C3=A9 Almeida (1):
      media: vimc: cap: check v4l2_fill_pixfmt return value

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

Baruch Siach (1):
      bpf: fix uapi bpf_prog_info fields alignment

Biao Huang (2):
      net: stmmac: dwmac4: fix flow control issue
      net: stmmac: modify default value of tx-frames

Bob Liu (1):
      block: null_blk: fix race condition for null_del_dev

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Borislav Petkov (1):
      RAS/CEC: Fix pfn insertion

Brian Foster (1):
      xfs: serialize unaligned dio writes against all other dio writes

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

Damien Le Moal (1):
      dm zoned: fix zone state management race

Dan Carpenter (2):
      ath6kl: add some bounds checking
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

Darrick J. Wong (6):
      xfs: fix pagecache truncation prior to reflink
      xfs: don't overflow xattr listent buffer
      xfs: rename m_inotbt_nores to m_finobt_nores
      xfs: don't ever put nlink > 0 inodes on the unlinked list
      xfs: reserve blocks for ifree transaction during log recovery
      xfs: abort unaligned nowait directio early

Dave Chinner (1):
      xfs: flush removing page cache in xfs_reflink_remap_prep

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

Dennis Zhou (1):
      blk-iolatency: only account submitted bios

Dexuan Cui (1):
      PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Drew Davenport (1):
      include/asm-generic/bug.h: fix "cut here" for WARN_ON for __WARN_TAIN=
T architectures

Eiichi Tsukata (1):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Emmanuel Grumbach (4):
      iwlwifi: pcie: don't service an interrupt that was masked
      iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X
      iwlwifi: don't WARN when calling iwl_get_shared_mem_conf with RF-Kill
      iwlwifi: fix RF-Kill interrupt while FW load for gen2 devices

Eric Auger (1):
      iommu: Fix a leak in iommu_insert_resv_region

Eric Biggers (3):
      fscrypt: clean up some BUG_ON()s in block encryption/decryption
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Eric W. Biederman (1):
      signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig

Ezequiel Garcia (1):
      media: coda: Remove unbalanced and unneeded mutex unlock

Fabio Estevam (1):
      net: fec: Do not use netdev messages too early

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
      scsi: NCR5380: Reduce goto statements in NCR5380_select()
      scsi: NCR5380: Always re-enable reselection interrupt
      Revert "scsi: ncr5380: Increase register polling limit"
      scsi: mac_scsi: Increase PIO/PDMA transfer length threshold
      scsi: mac_scsi: Fix pseudo DMA implementation, take 2

Gao Xiang (1):
      sched/core: Add __sched tag for io_schedule()

Geert Uytterhoeven (1):
      gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level

Greg Kroah-Hartman (1):
      Linux 4.19.61

Greg Kurz (1):
      powerpc/powernv/npu: Fix reference leak

Guilherme G. Piccoli (1):
      bnx2x: Prevent ptp_task to be rescheduled indefinitely

Gustavo A. R. Silva (1):
      wil6210: fix potential out-of-bounds read

Hans Verkuil (2):
      media: mc-device.c: don't memset __user pointer contents
      media: hdpvr: fix locking and a missing msleep

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

Hui Wang (3):
      Input: alps - don't handle ALPS cs19 trackpoint-only device
      Input: alps - fix a mismatch between a condition check and its comment
      ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine

Icenowy Zheng (1):
      net: stmmac: sun8i: force select external PHY when no internal one

Imre Deak (1):
      locking/lockdep: Fix merging of hlocks with non-zero references

Ioana Ciornei (1):
      net: phy: Check against net_device being NULL

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap

Jason Wang (1):
      vhost_net: disable zerocopy by default

Jeremy Sowden (2):
      batman-adv: fix for leaked TVLV handler.
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Jerome Brunet (1):
      ASoC: meson: axg-tdm: fix sample clock inversion

Jiri Benc (1):
      selftests: bpf: fix inlines in test_lwt_seg6local

Jiri Olsa (2):
      perf jvmti: Address gcc string overflow warning for strncpy()
      tools: bpftool: Fix json dump crash on powerpc

Jon Hunter (2):
      arm64: tegra: Update Jetson TX1 GPU regulator timings
      arm64: tegra: Fix AGIC register range

Jorge Ramirez-Ortiz (1):
      mmc: sdhci-msm: fix mutex while in spinlock

Jose Abreu (2):
      net: stmmac: dwmac1000: Clear unused address entries
      net: stmmac: dwmac4/5: Clear unused address entries

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

Julien Thierry (1):
      arm64: Do not enable IRQs for ct_user_exit

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

Kefeng Wang (2):
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

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Kyle Meyer (1):
      perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Lee, Chiasheng (1):
      usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Leo Yan (1):
      bpf, libbpf, smatch: Fix potential NULL pointer dereference

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Lorenzo Bianconi (2):
      mt7601u: do not schedule rx_tasklet when the device has been disconne=
cted
      mt7601u: fix possible memory leak when the device is disconnected

Lubomir Rintel (1):
      media: marvell-ccic: fix DMA s/g desc number calculation

Luis R. Rodriguez (1):
      xfs: fix reporting supported extra file attributes for statx()

Lyude Paul (1):
      drm/nouveau/i2c: Enable i2c pads & busses during preinit

Marco Felsch (1):
      media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP

Marek Szyprowski (3):
      media: s5p-mfc: fix reading min scratch buffer size on MFC v6/v7
      media: s5p-mfc: Make additional clocks optional
      clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Mark Brown (1):
      ASoC: dapm: Adapt for debugfs API change

Masahiro Yamada (2):
      x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c
      kconfig: fix missing choice values in auto.conf

Mathieu Poirier (1):
      perf cs-etm: Properly set the value of 'old' and 'head' in snapshot m=
ode

Matias Karhumaa (1):
      Bluetooth: Check state in l2cap_disconnect_rsp

Maurizio Lombardi (1):
      scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not su=
pported

Mauro S. M. Rodrigues (1):
      ixgbe: Check DDM existence in transceiver before access

Maxime Chevallier (1):
      net: mvpp2: prs: Don't override the sign bit in SRAM parser shift

Maya Erez (1):
      wil6210: fix spurious interrupts in 3-msi

Miaoqing Pan (1):
      ath10k: fix PCIE device wake up failed

Michal Kalderon (2):
      qed: Set the doorbell address correctly
      qed: iWARP - Fix tc for MPA ll2 connection

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold

Miles Chen (1):
      arm64: mm: make CONFIG_ZONE_DMA32 configurable

Ming Lei (1):
      scsi: core: Fix race on creating sense cache

Minwoo Im (1):
      nvme-pci: properly report state change failure in nvme_reset_work

Miroslav Lichvar (1):
      ntp: Limit TAI-UTC offset

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

Oliver Neukum (2):
      media: dvb: usb: fix use after free in dvb_usb_device_exit
      media: uvcvideo: Fix access to uninitialized fields on probe error

Ondrej Mosnacek (1):
      selinux: fix empty write to keycreate file

Pan Bian (1):
      EDAC/sysfs: Fix memory leak when creating a csrow object

Peter Zijlstra (1):
      x86/atomic: Fix smp_mb__{before,after}_atomic()

Philipp Zabel (2):
      media: coda: fix mpeg2 sequence number handling
      media: coda: increment sequence offset for the last returned frame

Phong Tran (1):
      net: usb: asix: init MAC address buffers

Ping-Ke Shih (1):
      rtlwifi: rtl8192cu: fix error handle when usb probe failed

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

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception

Robert Hancock (2):
      net: axienet: Fix race condition causing TX hang
      net: sfp: add mutex to prevent concurrent state checks

Russell King (2):
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4
      gpio: omap: ensure irq is enabled before wakeup

Sakari Ailus (2):
      media: videobuf2-core: Prevent size alignment wrapping buffer size to=
 0
      media: videobuf2-dma-sg: Prevent size from overflowing

Seeteena Thoufeek (1):
      perf tests: Fix record+probe_libc_inet_pton.sh for powerpc64

Shailendra Verma (1):
      media: staging: media: davinci_vpfe: - Fix for memory leak if decoder=
 initialization fails.

Shivasharan S (1):
      scsi: megaraid_sas: Fix calculation of target ID

Srinivas Kandagatla (1):
      regmap: fix bulk writes on paged registers

Stefan Hellermann (1):
      MIPS: ath79: fix ar933x uart parity mode

Stefano Brivio (1):
      ipset: Fix memory accounting for hash types on resize

Steve Longerbeam (1):
      gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Surabhi Vishnoi (1):
      ath10k: Do not send probe response template for mesh

Sven Eckelmann (1):
      batman-adv: Fix duplicated OGMs on NETDEV_UP

Sven Van Asbroeck (1):
      dmaengine: imx-sdma: fix use-after-free on probe error path

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Taehee Yoo (5):
      gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
      gtp: fix suspicious RCU usage
      gtp: fix Illegal context switch in RCU read-side critical section.
      gtp: fix use-after-free in gtp_encap_destroy()
      gtp: fix use-after-free in gtp_newlink()

Takashi Iwai (1):
      ALSA: seq: Break too long mutex context in the write loop

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

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Trond Myklebust (4):
      NFSv4: Handle the special Linux file open access mode
      pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error
      pNFS: Fix a typo in pnfs_update_layout
      pnfs: Fix a problem where we gratuitously start doing I/O through the=
 MDS

Valdis Kletnieks (1):
      bpf: silence warning messages in core

Vedang Patel (1):
      igb: clear out skb->tstamp after reading the txtime

Waiman Long (1):
      rcu: Force inlining of rcu_read_lock()

Weihang Li (1):
      net: hns3: set ops to null when unregister ad_dev

Wen Gong (2):
      ath10k: add peer id check in ath10k_peer_find_by_id
      ath10k: destroy sdio workqueue while remove sdio module

Wen Yang (1):
      crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

Xiao Ni (1):
      raid5-cache: Need to do start() part job after adding journal device

Xiaolei Li (1):
      mtd: rawnand: mtk: Correct low level time calculation of r/w cycle

Xingyu Chen (1):
      irqchip/meson-gpio: Add support for Meson-G12A SoC

Yonglong Liu (1):
      net: hns3: fix a -Wformat-nonliteral compile warning

YueHaibing (2):
      9p/xen: Add cleanup path in p9_trans_xen_init
      9p/virtio: Add cleanup path in p9_virtio_init

Yunsheng Lin (2):
      net: hns3: fix for skb leak when doing selftest
      net: hns3: add some error checking in hclge_tm module

csonsino (1):
      Bluetooth: validate BLE connection interval updates

liaoweixiong (1):
      mtd: spinand: read returns badly if the last page has bitflips


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl06vcMACgkQONu9yGCS
aT6Oxg/8D2v4A6gL0xT50GhHrbC//Ni/A9exx1VnCmX3ttleAKDWI7l6p1pK6gF2
b59hZhRLVjUkB4jA+Nqrykj9x/vu5kzmNItBW4sbNhUV9uvqVmOWapMiy3LPcgED
fZec+wdfxv88LYTlFLuPpFDIADKkRmZyDkKRhyaA/Jn8xQfd2PhIP8gOhprjQqza
cRIgZTD0ekgkiVZ8STWIqAQyIoDHnRFIsNu8r4yiLYogf6H4KY3dVKmREXy7H90G
o833ZP04nQAmwXbhutKvUUY7N1gNhzbml7wDLdznZcn5RPuYMUvpit8//oXVFBQf
0Yis0+PCNrYh7qurhKMe37sRy/8HzR0urvVmj+p5BbLmzW8WkilSw5a7gqft6e1Z
eqzNKgs0ksDGLPLKO2R585dvQx6wq4LpUYAa5mcddQXWtwygKO+RyEkhykALnVuO
Vy1EUeaTgmZYovSKRxX6w6wZsrdvxcM7ZHTXDrFVU7+qci0xS2E3XAysrV/3bMwz
7YZT+RP8Lains3zlQP1534gXRmNY94gNRwrcEH+1wnOLIWE2Pp4Ih4mZCC3mwMri
dCNzad7kNEgc/GrW8ZKeHiorwM1dbs8a60Ik3+LYjygNUqnvBROAzrLkfp5ViVBr
/X3FNjcEz+f/S9FSgsKkPZWxT/ohRT1kzOOW+8xaTT+gtjeftlU=
=8RA2
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
