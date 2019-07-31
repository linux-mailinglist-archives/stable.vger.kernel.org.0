Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191CB7BCD2
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGaJUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbfGaJUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:20:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD83A2067D;
        Wed, 31 Jul 2019 09:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564564851;
        bh=KpFKcJyGso3r9YKxpy1X0zqC8ZyH5BhXGEROI3O9P0Q=;
        h=Date:From:To:Cc:Subject:From;
        b=P2Bhm7fh/GclBEK7Fp7Q+MnlnzWaP4MQTQshCmNaiqC5+XZadgyKgyBgobBEKeJuh
         qsVBi9uVJ6QfbAT1hPVfDW1krQsux76fvbCXyF/UDaye1pzuDnduaCckYCVTJ9cAtB
         wfb5Ua1UBzIFzpXQl3hUb5aL0dXo8B5kY1jE1HfM=
Date:   Wed, 31 Jul 2019 11:20:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.135
Message-ID: <20190731092048.GA11747@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.135 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/atomic_t.txt                                   |    3=20
 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |    2=20
 Makefile                                                     |    3=20
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi               |    3=20
 arch/arm64/boot/dts/nvidia/tegra210.dtsi                     |    2=20
 arch/arm64/crypto/sha1-ce-glue.c                             |    2=20
 arch/arm64/crypto/sha2-ce-glue.c                             |    2=20
 arch/arm64/kernel/acpi.c                                     |   10=20
 arch/arm64/kernel/image.h                                    |    6=20
 arch/mips/boot/compressed/Makefile                           |    2=20
 arch/mips/boot/compressed/calc_vmlinuz_load_addr.c           |    2=20
 arch/mips/include/asm/mach-ath79/ar933x_uart.h               |    4=20
 arch/mips/jz4740/board-qi_lb60.c                             |   16=20
 arch/parisc/kernel/ptrace.c                                  |   31=20
 arch/powerpc/boot/xz_config.h                                |   20=20
 arch/powerpc/kernel/eeh.c                                    |   15=20
 arch/powerpc/kernel/exceptions-64s.S                         |    9=20
 arch/powerpc/kernel/pci_of_scan.c                            |    2=20
 arch/powerpc/kernel/signal_32.c                              |    3=20
 arch/powerpc/kernel/signal_64.c                              |    5=20
 arch/powerpc/kernel/swsusp_32.S                              |   73=20
 arch/powerpc/platforms/4xx/uic.c                             |    1=20
 arch/powerpc/platforms/powermac/sleep.S                      |   68=20
 arch/powerpc/platforms/pseries/mobility.c                    |    9=20
 arch/powerpc/sysdev/xive/common.c                            |    7=20
 arch/powerpc/xmon/xmon.c                                     |    6=20
 arch/sh/include/asm/io.h                                     |    6=20
 arch/um/include/asm/mmu_context.h                            |    2=20
 arch/x86/events/amd/uncore.c                                 |   36=20
 arch/x86/include/asm/atomic.h                                |    8=20
 arch/x86/include/asm/atomic64_64.h                           |    8=20
 arch/x86/include/asm/barrier.h                               |    4=20
 arch/x86/include/asm/cpufeatures.h                           |    2=20
 arch/x86/kernel/cpu/bugs.c                                   |    2=20
 arch/x86/kernel/cpu/mkcapflags.sh                            |    2=20
 arch/x86/kernel/mpparse.c                                    |   10=20
 arch/x86/kernel/sysfb_efi.c                                  |   46=20
 arch/x86/kvm/pmu.c                                           |    4=20
 arch/x86/kvm/vmx.c                                           |    8=20
 block/bio-integrity.c                                        |    8=20
 crypto/asymmetric_keys/Kconfig                               |    3=20
 crypto/chacha20poly1305.c                                    |   30=20
 crypto/ghash-generic.c                                       |    8=20
 crypto/serpent_generic.c                                     |    8=20
 drivers/android/binder.c                                     |    2=20
 drivers/ata/libata-eh.c                                      |    8=20
 drivers/base/regmap/regmap.c                                 |    2=20
 drivers/block/floppy.c                                       |   34=20
 drivers/bluetooth/hci_bcsp.c                                 |    5=20
 drivers/char/hpet.c                                          |    3=20
 drivers/clocksource/exynos_mct.c                             |    4=20
 drivers/crypto/amcc/crypto4xx_trng.c                         |    1=20
 drivers/crypto/caam/caamalg.c                                |   15=20
 drivers/crypto/ccp/ccp-dev.c                                 |   96=20
 drivers/crypto/ccp/ccp-dev.h                                 |    2=20
 drivers/crypto/ccp/ccp-ops.c                                 |   15=20
 drivers/crypto/talitos.c                                     |   35=20
 drivers/dma-buf/dma-buf.c                                    |    1=20
 drivers/dma-buf/reservation.c                                |    4=20
 drivers/dma/imx-sdma.c                                       |   48=20
 drivers/edac/edac_mc_sysfs.c                                 |   24=20
 drivers/edac/edac_module.h                                   |    2=20
 drivers/fpga/Kconfig                                         |    1=20
 drivers/gpio/gpio-omap.c                                     |   17=20
 drivers/gpio/gpiolib.c                                       |    6=20
 drivers/gpu/drm/bridge/sii902x.c                             |    5=20
 drivers/gpu/drm/bridge/tc358767.c                            |    7=20
 drivers/gpu/drm/drm_debugfs_crc.c                            |   18=20
 drivers/gpu/drm/drm_edid_load.c                              |    2=20
 drivers/gpu/drm/msm/msm_drv.c                                |   14=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c               |   20=20
 drivers/gpu/drm/panel/panel-simple.c                         |    9=20
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                  |    3=20
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                       |    3=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                          |    2=20
 drivers/gpu/ipu-v3/ipu-ic.c                                  |    2=20
 drivers/hid/wacom_sys.c                                      |    3=20
 drivers/hid/wacom_wac.c                                      |    4=20
 drivers/hid/wacom_wac.h                                      |    1=20
 drivers/hwtracing/intel_th/msu.c                             |    2=20
 drivers/hwtracing/intel_th/pci.c                             |    5=20
 drivers/infiniband/hw/i40iw/i40iw_verbs.c                    |    2=20
 drivers/infiniband/sw/rxe/rxe_resp.c                         |    5=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                        |    1=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c                    |    1=20
 drivers/input/mouse/alps.c                                   |   32=20
 drivers/input/mouse/synaptics.c                              |    1=20
 drivers/input/tablet/gtco.c                                  |   20=20
 drivers/iommu/iommu.c                                        |    8=20
 drivers/mailbox/mailbox.c                                    |    6=20
 drivers/md/bcache/super.c                                    |    2=20
 drivers/md/dm-bufio.c                                        |    4=20
 drivers/md/dm-zoned-metadata.c                               |   24=20
 drivers/md/dm-zoned.h                                        |   28=20
 drivers/media/dvb-frontends/tua6100.c                        |   22=20
 drivers/media/i2c/Makefile                                   |    2=20
 drivers/media/i2c/adv7511-v4l2.c                             | 2008 ++++++=
+++++
 drivers/media/i2c/adv7511.c                                  | 2003 ------=
----
 drivers/media/media-device.c                                 |   10=20
 drivers/media/platform/coda/coda-bit.c                       |    9=20
 drivers/media/platform/coda/coda-common.c                    |    2=20
 drivers/media/platform/davinci/vpss.c                        |    5=20
 drivers/media/platform/marvell-ccic/mcam-core.c              |    5=20
 drivers/media/platform/rcar_fdp1.c                           |    8=20
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c                  |    5=20
 drivers/media/platform/vimc/vimc-capture.c                   |    5=20
 drivers/media/radio/wl128x/fmdrv_v4l2.c                      |    3=20
 drivers/media/rc/ir-spi.c                                    |    1=20
 drivers/media/usb/dvb-usb/dvb-usb-init.c                     |    7=20
 drivers/media/usb/hdpvr/hdpvr-video.c                        |   17=20
 drivers/media/v4l2-core/v4l2-ctrls.c                         |    9=20
 drivers/memstick/core/memstick.c                             |   13=20
 drivers/mfd/arizona-core.c                                   |    2=20
 drivers/mfd/hi655x-pmic.c                                    |    2=20
 drivers/mfd/mfd-core.c                                       |    1=20
 drivers/net/bonding/bond_main.c                              |   37=20
 drivers/net/caif/caif_hsi.c                                  |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                             |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c              |    8=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c          |    4=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c             |   33=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h            |    3=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c               |   57=20
 drivers/net/ethernet/freescale/fec_main.c                    |    6=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c      |    3=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c        |    6=20
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                |    6=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c             |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h                 |    1=20
 drivers/net/ethernet/marvell/mvmdio.c                        |    7=20
 drivers/net/ethernet/marvell/sky2.c                          |    7=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c                    |   29=20
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                   |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c         |    6=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c            |   18=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |   20=20
 drivers/net/gtp.c                                            |   36=20
 drivers/net/macsec.c                                         |    6=20
 drivers/net/phy/phy_device.c                                 |    6=20
 drivers/net/phy/sfp.c                                        |    6=20
 drivers/net/usb/asix_devices.c                               |    6=20
 drivers/net/vrf.c                                            |   58=20
 drivers/net/wireless/ath/ath10k/hw.c                         |    2=20
 drivers/net/wireless/ath/ath10k/mac.c                        |    4=20
 drivers/net/wireless/ath/ath10k/sdio.c                       |    7=20
 drivers/net/wireless/ath/ath6kl/wmi.c                        |   10=20
 drivers/net/wireless/ath/ath9k/hw.c                          |   32=20
 drivers/net/wireless/ath/dfs_pattern_detector.c              |    2=20
 drivers/net/wireless/ath/wil6210/txrx.c                      |    1=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                  |    3=20
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                 |   61=20
 drivers/net/wireless/mediatek/mt7601u/dma.c                  |   54=20
 drivers/net/wireless/mediatek/mt7601u/tx.c                   |    4=20
 drivers/net/wireless/realtek/rtlwifi/usb.c                   |    5=20
 drivers/nvdimm/dax_devs.c                                    |    2=20
 drivers/nvdimm/pfn.h                                         |    1=20
 drivers/nvdimm/pfn_devs.c                                    |   18=20
 drivers/pci/dwc/pci-dra7xx.c                                 |    1=20
 drivers/pci/host/pci-hyperv.c                                |   15=20
 drivers/pci/host/pcie-xilinx-nwl.c                           |   11=20
 drivers/pci/pci-driver.c                                     |   13=20
 drivers/pci/pci-sysfs.c                                      |    2=20
 drivers/pci/pci.c                                            |    7=20
 drivers/phy/renesas/phy-rcar-gen2.c                          |    2=20
 drivers/pinctrl/pinctrl-rockchip.c                           |    1=20
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
 drivers/tty/serial/8250/8250_port.c                          |    3=20
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                  |   17=20
 drivers/tty/serial/digicolor-usart.c                         |    6=20
 drivers/tty/serial/max310x.c                                 |   51=20
 drivers/tty/serial/msm_serial.c                              |    4=20
 drivers/tty/serial/serial_core.c                             |    7=20
 drivers/tty/serial/serial_mctrl_gpio.c                       |   14=20
 drivers/tty/serial/sh-sci.c                                  |   33=20
 drivers/usb/core/hub.c                                       |   35=20
 drivers/usb/gadget/function/f_fs.c                           |    6=20
 drivers/usb/host/hwa-hc.c                                    |    2=20
 drivers/usb/host/pci-quirks.c                                |   31=20
 drivers/vhost/net.c                                          |    2=20
 drivers/xen/balloon.c                                        |   16=20
 drivers/xen/events/events_base.c                             |   12=20
 drivers/xen/evtchn.c                                         |    2=20
 fs/9p/vfs_addr.c                                             |    6=20
 fs/btrfs/file.c                                              |    5=20
 fs/btrfs/inode.c                                             |   24=20
 fs/btrfs/tree-log.c                                          |   40=20
 fs/coda/file.c                                               |   70=20
 fs/crypto/crypto.c                                           |   15=20
 fs/ecryptfs/crypto.c                                         |   12=20
 fs/ext4/dir.c                                                |   19=20
 fs/ext4/ext4_jbd2.h                                          |   12=20
 fs/ext4/file.c                                               |    4=20
 fs/ext4/inode.c                                              |   24=20
 fs/ext4/ioctl.c                                              |   46=20
 fs/ext4/move_extent.c                                        |    3=20
 fs/ext4/namei.c                                              |   45=20
 fs/f2fs/segment.c                                            |    5=20
 fs/fs-writeback.c                                            |    8=20
 fs/jbd2/commit.c                                             |   23=20
 fs/jbd2/journal.c                                            |    4=20
 fs/jbd2/transaction.c                                        |   49=20
 fs/nfs/flexfilelayout/flexfilelayoutdev.c                    |    2=20
 fs/nfs/inode.c                                               |    1=20
 fs/nfs/nfs4file.c                                            |    2=20
 fs/nfs/nfs4proc.c                                            |   41=20
 fs/nfsd/nfs4state.c                                          |   11=20
 fs/nfsd/nfssvc.c                                             |    2=20
 fs/open.c                                                    |   19=20
 fs/proc/proc_sysctl.c                                        |    4=20
 include/drm/drm_debugfs_crc.h                                |    3=20
 include/linux/compiler.h                                     |   22=20
 include/linux/cpuhotplug.h                                   |    2=20
 include/linux/cred.h                                         |    7=20
 include/linux/fs.h                                           |    2=20
 include/linux/jbd2.h                                         |   22=20
 include/linux/rcupdate.h                                     |    2=20
 include/net/dst.h                                            |    5=20
 include/net/ip_vs.h                                          |    6=20
 include/net/tcp.h                                            |    3=20
 include/xen/events.h                                         |    3=20
 kernel/bpf/Makefile                                          |    1=20
 kernel/cred.c                                                |   21=20
 kernel/locking/lockdep.c                                     |   18=20
 kernel/locking/lockdep_proc.c                                |    8=20
 kernel/padata.c                                              |   12=20
 kernel/pid_namespace.c                                       |    2=20
 kernel/sched/core.c                                          |    2=20
 kernel/time/ntp.c                                            |    4=20
 kernel/time/timer_list.c                                     |   36=20
 lib/reed_solomon/decode_rs.c                                 |   18=20
 lib/scatterlist.c                                            |    9=20
 lib/string.c                                                 |    2=20
 mm/filemap.c                                                 |   22=20
 mm/gup.c                                                     |   12=20
 mm/kmemleak.c                                                |    2=20
 mm/mmu_notifier.c                                            |    2=20
 mm/vmscan.c                                                  |    6=20
 net/9p/trans_virtio.c                                        |    8=20
 net/9p/trans_xen.c                                           |    8=20
 net/batman-adv/translation-table.c                           |    2=20
 net/bluetooth/6lowpan.c                                      |   14=20
 net/bluetooth/hci_event.c                                    |    5=20
 net/bluetooth/l2cap_core.c                                   |   15=20
 net/bluetooth/smp.c                                          |   13=20
 net/bridge/br_multicast.c                                    |   32=20
 net/bridge/br_stp_bpdu.c                                     |    3=20
 net/core/filter.c                                            |    3=20
 net/core/neighbour.c                                         |    2=20
 net/ipv4/devinet.c                                           |    8=20
 net/ipv4/igmp.c                                              |    8=20
 net/ipv4/tcp.c                                               |    6=20
 net/ipv4/tcp_cong.c                                          |    6=20
 net/key/af_key.c                                             |    8=20
 net/netfilter/ipset/ip_set_hash_gen.h                        |    2=20
 net/netfilter/ipvs/ip_vs_core.c                              |   21=20
 net/netfilter/ipvs/ip_vs_ctl.c                               |    4=20
 net/netfilter/ipvs/ip_vs_sync.c                              |  134=20
 net/netfilter/nf_queue.c                                     |    6=20
 net/netrom/af_netrom.c                                       |    4=20
 net/nfc/nci/data.c                                           |    2=20
 net/openvswitch/actions.c                                    |    6=20
 net/rxrpc/af_rxrpc.c                                         |    4=20
 net/vmw_vsock/hyperv_transport.c                             |   44=20
 net/xfrm/Kconfig                                             |    2=20
 net/xfrm/xfrm_user.c                                         |   19=20
 scripts/kallsyms.c                                           |    3=20
 scripts/recordmcount.h                                       |    3=20
 sound/core/seq/seq_clientmgr.c                               |   11=20
 sound/pci/hda/patch_conexant.c                               |    1=20
 sound/pci/hda/patch_realtek.c                                |    5=20
 sound/soc/soc-dapm.c                                         |   18=20
 sound/usb/line6/podhd.c                                      |    2=20
 tools/iio/iio_utils.c                                        |    4=20
 tools/perf/arch/arm/util/cs-etm.c                            |  127=20
 tools/perf/perf.h                                            |    2=20
 tools/perf/tests/mmap-thread-lookup.c                        |    2=20
 tools/perf/tests/parse-events.c                              |   27=20
 tools/perf/util/annotate.c                                   |    6=20
 tools/perf/util/evsel.c                                      |    8=20
 tools/perf/util/header.c                                     |    2=20
 tools/perf/util/session.c                                    |    3=20
 tools/perf/util/stat-shadow.c                                |    5=20
 tools/power/cpupower/utils/cpufreq-set.c                     |    2=20
 292 files changed, 4748 insertions(+), 3145 deletions(-)

Aaron Armstrong Skomra (2):
      HID: wacom: generic: only switch the mode on devices with LEDs
      HID: wacom: correct touch resolution x/y typo

Aaron Lewis (1):
      x86/cpufeatures: Add FDP_EXCPTN_ONLY and ZERO_FCS_FDS

Abhishek Goel (1):
      cpupower : frequency-set -r option misses the last cpu in related cpu=
 list

Alex Williamson (1):
      PCI: Return error if cannot probe VF

Alexander Shishkin (2):
      intel_th: pci: Add Ice Lake NNPI support
      intel_th: msu: Fix single mode with disabled IOMMU

Alexey Kardashevskiy (1):
      powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Anders Roxell (1):
      media: i2c: fix warning same module names

Andi Kleen (1):
      perf stat: Make metric event lookup more robust

Andreas Steinmetz (2):
      macsec: fix use-after-free of skb during RX
      macsec: fix checksumming after decryption

Andrei Otcheretianski (1):
      iwlwifi: mvm: Drop large non sta frames

Andrey Ryabinin (3):
      compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
      compiler.h: Add read_word_at_a_time() function.
      lib/strscpy: Shut up KASAN false-positives in strscpy()

Andrzej Pietrasiewicz (1):
      usb: gadget: Zero ffs_io_data

Andr=E9 Almeida (1):
      media: vimc: cap: check v4l2_fill_pixfmt return value

Andy Lutomirski (1):
      mm/gup.c: remove some BUG_ONs from get_gate_page()

Anilkumar Kolli (1):
      ath: DFS JP domain W56 fixed pulse type 3 RADAR detection

Anirudh Gupta (1):
      xfrm: Fix xfrm sel prefix length validation

Ard Biesheuvel (2):
      acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
      crypto: caam - limit output IV to CBC to work around CTR mode DMA iss=
ue

Arnaldo Carvalho de Melo (1):
      perf evsel: Make perf_evsel__name() accept a NULL argument

Arnd Bergmann (5):
      ipsec: select crypto ciphers for xfrm_algo
      crypto: serpent - mark __serpent_setkey_sbox noinline
      crypto: asymmetric_keys - select CRYPTO_HASH where needed
      mfd: arizona: Fix undefined behavior
      locking/lockdep: Hide unused 'class' variable

Axel Lin (1):
      mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init=
_mmio_clk

Baruch Siach (1):
      net: dsa: mv88e6xxx: wait after reset deactivation

Bastien Nocera (1):
      iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada (1):
      PCI: xilinx-nwl: Fix Multi MSI data programming

Biao Huang (1):
      net: stmmac: dwmac4: fix flow control issue

Boris Brezillon (1):
      media: v4l2: Test type instead of cfg->type in v4l2_ctrl_new_custom()

Borislav Petkov (1):
      RAS/CEC: Fix pfn insertion

Brian King (1):
      bnx2x: Prevent load reordering in tx completion processing

Cfir Cohen (1):
      crypto: ccp/gcm - use const time tag comparison.

Chris Wilson (1):
      dma-buf: Discard old fence_excl on retrying get_fences_rcu for realloc

Christian Lamparter (1):
      powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Christoph Hellwig (1):
      9p: pass the correct prototype to read_cache_page

Christoph Paasch (1):
      tcp: Reset bytes_acked and bytes_received when disconnecting

Christophe Leroy (6):
      crypto: talitos - fix skcipher failure due to wrong output IV
      crypto: talitos - properly handle split ICV.
      crypto: talitos - Align SEC1 accesses to 32 bits boundaries.
      lib/scatterlist: Fix mapping iterator when sg->offset is greater than=
 PAGE_SIZE
      powerpc/32s: fix suspend/resume when IBATs 4-7 are used
      tty: serial: cpm_uart - fix init when SMC is relocated

Claire Chang (1):
      ath10k: add missing error handling

Colin Ian King (1):
      iavf: fix dereference of null rx_buffer pointer

Coly Li (1):
      bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()

Cong Wang (3):
      netrom: fix a memory leak in nr_rx_frame()
      netrom: hold sock when setting skb->destructor
      bonding: validate ip header before check IPPROTO_IGMP

Damien Le Moal (1):
      dm zoned: fix zone state management race

Dan Carpenter (2):
      ath6kl: add some bounds checking
      eCryptfs: fix a couple type promotion bugs

Dan Williams (1):
      libnvdimm/pfn: fix fsdax-mode namespace info-block zero-fields

Daniel Gomez (1):
      media: spi: IR LED: add missing of table registration

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

Daniel Vetter (2):
      drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry
      drm/crc-debugfs: Also sprinkle irqrestore over early exits

Darrick J. Wong (1):
      ext4: don't allow any modifications to an immutable file

David Howells (1):
      rxrpc: Fix send on a connected, but unbound socket

David Rientjes (1):
      x86/boot: Fix memory leak in default_get_smp_config()

David Riley (1):
      drm/virtio: Add memory barriers for capset cache.

David S. Miller (1):
      tua6100: Avoid build warnings.

Denis Efremov (4):
      floppy: fix div-by-zero in setup_format_params
      floppy: fix out-of-bounds read in next_valid_format
      floppy: fix invalid pointer dereference in drive_name
      floppy: fix out-of-bounds read in copy_buffer

Denis Kirjanov (1):
      ipoib: correcly show a VF hardware address

Dexuan Cui (1):
      PCI: hv: Fix a use-after-free bug in hv_eject_device_work()

Dmitry Vyukov (1):
      mm/kmemleak.c: fix check for softirq context

Douglas Anderson (1):
      drm/rockchip: Properly adjust to a true clock in adjusted_mode

Eiichi Tsukata (1):
      EDAC: Fix global-out-of-bounds write when setting edac_mc_poll_msec

Elena Petrova (2):
      crypto: arm64/sha1-ce - correct digest for empty data in finup
      crypto: arm64/sha2-ce - correct digest for empty data in finup

Emmanuel Grumbach (2):
      iwlwifi: pcie: don't service an interrupt that was masked
      iwlwifi: pcie: fix ALIVE interrupt handling for gen2 devices w/o MSI-X

Eric Auger (1):
      iommu: Fix a leak in iommu_insert_resv_region

Eric Biggers (3):
      fscrypt: clean up some BUG_ON()s in block encryption/decryption
      crypto: ghash - fix unaligned memory access in ghash_setkey()
      crypto: chacha20poly1305 - fix atomic sleep when using async algorithm

Eric Dumazet (2):
      igmp: fix memory leak in igmpv3_del_delrec()
      tcp: fix tcp_set_congestion_control() use from bpf hook

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

Florian Westphal (1):
      net: make skb_dst_force return true when dst is refcounted

Gao Xiang (1):
      sched/core: Add __sched tag for io_schedule()

Gautham R. Shenoy (1):
      powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()

Geert Uytterhoeven (3):
      gpiolib: Fix references to gpiod_[gs]et_*value_cansleep() variants
      serial: sh-sci: Terminate TX DMA during buffer flushing
      serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Gen Zhang (1):
      drm/edid: Fix a missing-check bug in drm_load_edid_firmware()

Grant Hernandez (1):
      Input: gtco - bounds check collection indent level

Greg Kroah-Hartman (1):
      Linux 4.14.135

Guenter Roeck (1):
      mm/gup.c: mark undo_dev_pagemap as __maybe_unused

Guilherme G. Piccoli (1):
      bnx2x: Prevent ptp_task to be rescheduled indefinitely

Gustavo A. R. Silva (1):
      wil6210: fix potential out-of-bounds read

Hans Verkuil (2):
      media: mc-device.c: don't memset __user pointer contents
      media: hdpvr: fix locking and a missing msleep

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and hei=
ght

Helge Deller (2):
      parisc: Ensure userspace privilege for ptraced processes in regset fu=
nctions
      parisc: Fix kernel panic due invalid values in IAOQ0 or IAOQ1

Hook, Gary (2):
      crypto: ccp - Validate the the error value used to index error messag=
es
      crypto: ccp - memset structure fields to zero before reuse

Hridya Valsaraju (1):
      binder: prevent transactions to context manager from its own process.

Hui Wang (4):
      Input: alps - don't handle ALPS cs19 trackpoint-only device
      Input: alps - fix a mismatch between a condition check and its comment
      ALSA: hda/realtek: apply ALC891 headset fixup to one Dell machine
      ALSA: hda - Add a conexant codec entry to let mute led work

Imre Deak (1):
      locking/lockdep: Fix merging of hlocks with non-zero references

Ioana Ciornei (1):
      net: phy: Check against net_device being NULL

J. Bruce Fields (3):
      nfsd: increase DRC cache limit
      nfsd: give out fewer session slots as limit approaches
      nfsd: fix performance-limiting session calculation

Jan Harkes (1):
      coda: pass the host file in vma->vm_file on mmap

Jason Wang (1):
      vhost_net: disable zerocopy by default

Jean-Philippe Brucker (1):
      mm/mmu_notifier: use hlist_add_head_rcu()

Jeremy Sowden (2):
      batman-adv: fix for leaked TVLV handler.
      af_key: fix leaks in key_pol_get_resp and dump_sp.

Johannes Berg (1):
      um: Silence lockdep complaint about mmap_sem

John Hurley (1):
      net: openvswitch: fix csum updates for MPLS actions

Jon Hunter (2):
      arm64: tegra: Update Jetson TX1 GPU regulator timings
      arm64: tegra: Fix AGIC register range

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: avoid system lockup condition

Jose Abreu (2):
      net: stmmac: dwmac1000: Clear unused address entries
      net: stmmac: dwmac4/5: Clear unused address entries

Josua Mayer (4):
      Bluetooth: 6lowpan: search for destination address in all peers
      net: mvmdio: defer probe of orion-mdio if a clock is not ready
      net: mvmdio: allow up to four clocks to be specified for orion-mdio
      dt-bindings: allow up to four clocks for orion-mdio

Juergen Gross (2):
      xen: let alloc_xenballooned_pages() fail if not enough memory free
      xen/events: fix binding user event channels to cpus

Julian Anastasov (2):
      ipvs: defer hook registration to avoid leaks
      ipvs: fix tinfo memory leak in start_sync_thread

Julian Wiedmann (1):
      s390/qdio: handle PENDING state for QEBSM devices

Jungo Lin (1):
      media: media_device_enum_links32: clean a reserved field

Junxiao Bi (1):
      dm bufio: fix deadlock with loop device

Justin Chen (1):
      net: bcmgenet: use promisc for unsupported filters

Jyri Sarha (1):
      drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

J=E9r=F4me Glisse (1):
      dma-buf: balance refcount inbalance

Kai-Heng Feng (1):
      ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Kangjie Lu (1):
      media: vpss: fix a potential NULL pointer dereference

Kefeng Wang (3):
      media: wl128x: Fix some error handling in fm_v4l2_init_video_device()
      tty/serial: digicolor: Fix digicolor-usart already registered warning
      hpet: Fix division by zero in hpet_time_div()

Kevin Darbyshire-Bryant (1):
      MIPS: fix build on non-linux hosts

Kieran Bingham (1):
      media: fdp1: Support M3N and E3 platforms

Kim Phillips (2):
      perf/x86/amd/uncore: Do not set 'ThreadMask' and 'SliceMask' for non-=
L3 PMCs
      perf/x86/amd/uncore: Set the thread mask for F17h L3 PMCs

Konstantin Taranov (1):
      RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix buck7 and buck8 wrong voltages

Kuo-Hsin Yang (1):
      mm: vmscan: scan anonymous pages on file refaults

Kyle Meyer (1):
      perf tools: Increase MAX_NR_CPUS and MAX_CACHES

Lee, Chiasheng (1):
      usb: Handle USB3 remote wakeup for LPM enabled devices correctly

Leo Yan (2):
      perf session: Fix potential NULL pointer dereference found by the sma=
tch tool
      perf annotate: Fix dereferencing freed memory found by the smatch tool

Like Xu (1):
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Linus Torvalds (1):
      access: avoid the RCU grace period for the temporary subjective crede=
ntials

Liu, Changcheng (1):
      RDMA/i40iw: Set queue pair state when being queried

Lorenzo Bianconi (3):
      mt7601u: do not schedule rx_tasklet when the device has been disconne=
cted
      mt7601u: fix possible memory leak when the device is disconnected
      net: neigh: fix multiple neigh timer scheduling

Lubomir Rintel (1):
      media: marvell-ccic: fix DMA s/g desc number calculation

Lyude Paul (1):
      drm/nouveau/i2c: Enable i2c pads & busses during preinit

Maarten Lankhorst (1):
      drm/crc: Only report a single overflow when a CRC fd is opened

Marco Felsch (1):
      media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP

Marek Szyprowski (2):
      media: s5p-mfc: Make additional clocks optional
      clocksource/drivers/exynos_mct: Increase priority over ARM arch timer

Marek Vasut (1):
      PCI: sysfs: Ignore lockdep for remove attribute

Mark Brown (1):
      ASoC: dapm: Adapt for debugfs API change

Masahiro Yamada (2):
      x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c
      powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

Mathieu Poirier (1):
      perf cs-etm: Properly set the value of 'old' and 'head' in snapshot m=
ode

Matias Karhumaa (1):
      Bluetooth: Check state in l2cap_disconnect_rsp

Matteo Croce (1):
      ipv4: don't set IPv6 only flags to IPv4 addresses

Maurizio Lombardi (1):
      scsi: iscsi: set auth_protocol back to NULL if CHAP_A value is not su=
pported

Mauro S. M. Rodrigues (1):
      ixgbe: Check DDM existence in transceiver before access

Miaoqing Pan (1):
      ath10k: fix PCIE device wake up failed

Michael Neuling (1):
      powerpc/tm: Fix oops on sigreturn on systems without TM

Michal Kalderon (1):
      qed: Set the doorbell address correctly

Mika Westerberg (1):
      PCI: Do not poll for PME if the device is in D3cold

Ming Lei (1):
      scsi: core: Fix race on creating sense cache

Miroslav Lichvar (1):
      ntp: Limit TAI-UTC offset

Nathan Chancellor (2):
      arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicit=
ly
      kbuild: Add -Werror=3Dunknown-warning-option to CLANG_FLAGS

Nathan Huckleberry (1):
      timer_list: Guard procfs specific code

Nathan Lynch (1):
      powerpc/pseries/mobility: prevent cpu hotplug during DT update

Naveen N. Rao (2):
      powerpc/xmon: Fix disabling tracing while in xmon
      recordmcount: Fix spurious mcount entries on powerpc

Nick Black (1):
      Input: synaptics - whitelist Lenovo T580 SMBus intertouch

Nicolas Dichtel (1):
      xfrm: fix sa selector validation

Nikolay Aleksandrov (3):
      net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report hand=
ling
      net: bridge: mcast: fix stale ipv6 hdr pointer when handling v6 query
      net: bridge: stp: don't cache eth dest pointer before skb pull

Numfor Mbiziwo-Tiapo (1):
      perf test mmap-thread-lookup: Initialize variable to suppress memory =
sanitizer warning

Ocean Chen (1):
      f2fs: avoid out-of-range memory access

Oliver Neukum (1):
      media: dvb: usb: fix use after free in dvb_usb_device_exit

Oliver O'Halloran (1):
      powerpc/eeh: Handle hugepages in ioremap space

Pan Bian (1):
      EDAC/sysfs: Fix memory leak when creating a csrow object

Paolo Bonzini (1):
      KVM: nVMX: do not use dangling shadow VMCS after guest reset

Paul Cercueil (1):
      MIPS: lb60: Fix pin mappings

Paul Menzel (1):
      nfsd: Fix overflow causing non-working mounts on 1 TB machines

Peter Kosyh (1):
      vrf: make sure skb->data contains ip header to make routing

Peter Ujfalusi (1):
      drm/panel: simple: Fix panel_simple_dsi_probe

Peter Zijlstra (1):
      x86/atomic: Fix smp_mb__{before,after}_atomic()

Philipp Zabel (2):
      media: coda: fix mpeg2 sequence number handling
      media: coda: increment sequence offset for the last returned frame

Phong Tran (2):
      net: usb: asix: init MAC address buffers
      usb: wusbcore: fix unbalanced get/put cluster_id

Ping-Ke Shih (1):
      rtlwifi: rtl8192cu: fix error handle when usb probe failed

Qu Wenruo (1):
      btrfs: inode: Don't compress if NODATASUM or NODATACOW set

Radoslaw Burny (1):
      fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc=
/sys inodes.

Rautkoski Kimmo EXT (1):
      serial: 8250: Fix TX interrupt handling condition

Ravi Bangoria (1):
      powerpc/watchpoint: Restore NV GPRs while returning from exception

Robert Hancock (3):
      net: axienet: Fix race condition causing TX hang
      net: sfp: add mutex to prevent concurrent state checks
      mfd: core: Set fwnode for created devices

Ross Zwisler (3):
      mm: add filemap_fdatawait_range_keep_errors()
      jbd2: introduce jbd2_inode dirty range scoping
      ext4: use jbd2_inode dirty range scoping

Russell King (2):
      gpio: omap: fix lack of irqstatus_raw0 for OMAP4
      gpio: omap: ensure irq is enabled before wakeup

Ryan Kennedy (1):
      usb: pci-quirks: Correct AMD PLL quirk detection

Sam Ravnborg (1):
      sh: prevent warnings when using iounmap

Sean Paul (1):
      drm/msm: Depopulate platform on probe failure

Serge Semin (2):
      tty: max310x: Fix invalid baudrate divisors calculator
      tty: serial_core: Set port active bit in uart_port_activate

Shailendra Verma (1):
      media: staging: media: davinci_vpfe: - Fix for memory leak if decoder=
 initialization fails.

Shivasharan S (1):
      scsi: megaraid_sas: Fix calculation of target ID

Srinivas Kandagatla (1):
      regmap: fix bulk writes on paged registers

Stefan Hellermann (1):
      MIPS: ath79: fix ar933x uart parity mode

Stefan Roese (1):
      serial: mctrl_gpio: Check if GPIO property exisits before requesting =
it

Stefano Brivio (1):
      ipset: Fix memory accounting for hash types on resize

Steve Longerbeam (1):
      gpu: ipu-v3: ipu-ic: Fix saturation bit offset in TPMEM

Sunil Muthuswamy (1):
      hvsock: fix epollout hang from race condition

Surabhi Vishnoi (1):
      ath10k: Do not send probe response template for mesh

Suravee Suthikulpanit (1):
      perf/events/amd/uncore: Fix amd_uncore_llc ID to use pre-defined cpu_=
llc_id

Sven Van Asbroeck (1):
      dmaengine: imx-sdma: fix use-after-free on probe error path

Szymon Janc (1):
      Bluetooth: Add SMP workaround Microsoft Surface Precision Mouse bug

Taehee Yoo (6):
      gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
      gtp: fix suspicious RCU usage
      gtp: fix Illegal context switch in RCU read-side critical section.
      gtp: fix use-after-free in gtp_encap_destroy()
      gtp: fix use-after-free in gtp_newlink()
      caif-hsi: fix possible deadlock in cfhsi_exit_module()

Takashi Iwai (2):
      ALSA: seq: Break too long mutex context in the write loop
      sky2: Disable MSI on ASUS P6T

Tejun Heo (2):
      blkcg, writeback: dead memcgs shouldn't contribute to writeback owner=
ship arbitration
      libata: don't request sense data on !ZAC ATA devices

Theodore Ts'o (2):
      ext4: enforce the immutable flag on open files
      ext4: allow directory holes

Thinh Nguyen (1):
      usb: core: hub: Disable hub-initiated U1/U2

Thomas Richter (1):
      perf test 6: Fix missing kvm module load for s390

Tim Schumacher (1):
      ath9k: Check for errors when reading SREV register

Tomas Bortoli (1):
      Bluetooth: hci_bcsp: Fix memory leak in rx_skb

Tomi Valkeinen (1):
      drm/bridge: tc358767: read display_props in get_modes()

Trond Myklebust (3):
      NFSv4: Handle the special Linux file open access mode
      pnfs/flexfiles: Fix PTR_ERR() dereferences in ff_layout_track_ds_error
      NFSv4: Fix open create exclusive when the server reboots

Valdis Kletnieks (1):
      bpf: silence warning messages in core

Vasily Gorbik (1):
      kallsyms: exclude kasan local symbols on s390

Waiman Long (1):
      rcu: Force inlining of rcu_read_lock()

Wang Hai (1):
      memstick: Fix error cleanup path of memstick_init

Wen Gong (1):
      ath10k: destroy sdio workqueue while remove sdio module

Wen Yang (2):
      crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe
      pinctrl: rockchip: fix leaked of_node references

Wenwen Wang (1):
      block/bio-integrity: fix a memory leak bug

Yang Wei (1):
      nfc: fix potential illegal memory access

Yonglong Liu (1):
      net: hns3: fix a -Wformat-nonliteral compile warning

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen2: Fix memory leak at error paths

YueHaibing (4):
      9p/xen: Add cleanup path in p9_trans_xen_init
      9p/virtio: Add cleanup path in p9_virtio_init
      PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB
      fpga-manager: altera-ps-spi: Fix build error

Yunsheng Lin (1):
      net: hns3: add some error checking in hclge_tm module

Yuyang Du (1):
      locking/lockdep: Fix lock used or unused stats error

Zhenzhong Duan (1):
      x86/speculation/mds: Apply more accurate check on hypervisor platform

csonsino (1):
      Bluetooth: validate BLE connection interval updates

morten petersen (1):
      mailbox: handle failed named mailbox channel request


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1BXW0ACgkQONu9yGCS
aT7vgg/9Fmyt/bYOK0DNRvQDtPsS+r1+rZr2cwdtMfeAgHsIROCHt+1qhati4NS5
wRxz2LdnDEFCzNfAfn9cMCbiie0Z4ozDLIjCzqNdKoVJBgGU7W5odwz7+P0ByOIY
xD0zfaB5f/emASG2oCnD557ogBLNNCkgLJ0OydO+q7MsurURLo5/R2PIQxPUIuO1
6wnUH+EwoqKIH0buHHDiP575RORCEpVCHTSNQP3Zvfh8I9p3KU0QJaiiJRHza6aY
Fjm30ESDE4ZjcZrzY9bbb0HIXgtyMEz+B+4uxm+US/AScu/ug+O5CfJRFWziXIhJ
I8DYBtXxfzRWrkEg9LhnDRpsMcUfTwebK4nj4MkK/R83A1GLEjlzuOoJei3XcYtJ
g3JI8v+IYi9oSEG1UPDcd1tzUK3TXomJkiCDhlIUF4242h+4gVMB9R2xinNCL9A/
kVmV72YGX6PG7YPDtux2zEXI5lp6qKMKHjdaM+trY4l7q18NiV/CkLgdKAVwpRPi
kylmhg3JJwc0HDd8/EBt+JaOlciaxNfoVkxG5Z7kMJ1cnnYPqV+0bsXafoSL2zMm
1e2J3cOGyREhFawfEUTvTfOfzEijnwZMD1cDT2e0WRLEgIxOJrYtTVQ1YbwOErD1
piEeVr5uk+eX7ZGpTWQp7EYDeFieG6+BCdGTiiWbtTrl8GDRiMY=
=RQtE
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
