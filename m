Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D881414B5
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 00:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgAQXLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 18:11:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgAQXLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 18:11:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92662053B;
        Fri, 17 Jan 2020 23:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579302668;
        bh=ctg1w6RkfWrw0+Qz7X1Ev531kIRIqI5jdCNpsrZh+PQ=;
        h=Date:From:To:Cc:Subject:From;
        b=F9Iyua8vZyYAunUtxDcSvjoYHgwwzYMLZY8gZ2J1Su2cTQz5vLJAU12L2RV21ip0S
         7Q+PBVSJfS9Nz/d8lwaeErhvjqmol/jpxZ/GeuepiQBIkpEJ1816AGYzvid2xePYJU
         Tgc8Bfu6F+ANItE8pFoA758+Wfrd2+8Wid+V6xeM=
Date:   Sat, 18 Jan 2020 00:11:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.13
Message-ID: <20200117231105.GA2130102@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.13 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/stable/sysfs-driver-mlxreg-io                           =
 |   13=20
 Documentation/ABI/testing/sysfs-bus-mei                                   =
 |    2=20
 Documentation/admin-guide/device-mapper/index.rst                         =
 |    1=20
 Documentation/devicetree/bindings/reset/brcm,brcmstb-reset.txt            =
 |    2=20
 Documentation/devicetree/bindings/sound/mt8183-mt6358-ts3a227-max98357.txt=
 |    4=20
 Documentation/networking/j1939.rst                                        =
 |    2=20
 Documentation/scsi/smartpqi.txt                                           =
 |    2=20
 MAINTAINERS                                                               =
 |    1=20
 Makefile                                                                  =
 |    2=20
 arch/arm/kernel/smp.c                                                     =
 |    4=20
 arch/arm/kernel/topology.c                                                =
 |   10=20
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi                              =
 |    2=20
 arch/arm64/crypto/aes-neonbs-glue.c                                       =
 |    2=20
 arch/hexagon/include/asm/atomic.h                                         =
 |    8=20
 arch/hexagon/include/asm/bitops.h                                         =
 |    8=20
 arch/hexagon/include/asm/cmpxchg.h                                        =
 |    2=20
 arch/hexagon/include/asm/futex.h                                          =
 |    6=20
 arch/hexagon/include/asm/spinlock.h                                       =
 |   20=20
 arch/hexagon/kernel/stacktrace.c                                          =
 |    4=20
 arch/hexagon/kernel/vm_entry.S                                            =
 |    2=20
 arch/mips/boot/compressed/Makefile                                        =
 |    3=20
 arch/mips/include/asm/vdso/gettimeofday.h                                 =
 |   13=20
 arch/mips/kernel/cacheinfo.c                                              =
 |   27=20
 arch/mips/pci/pci-xtalk-bridge.c                                          =
 |    5=20
 arch/mips/sgi-ip27/ip27-irq.c                                             =
 |    4=20
 arch/mips/vdso/vgettimeofday.c                                            =
 |   20=20
 arch/nds32/include/asm/cacheflush.h                                       =
 |   11=20
 arch/powerpc/platforms/powernv/pci.c                                      =
 |   17=20
 arch/riscv/mm/cacheflush.c                                                =
 |    1=20
 arch/x86/entry/syscall_32.c                                               =
 |    8=20
 arch/x86/entry/syscall_64.c                                               =
 |   14=20
 arch/x86/entry/syscalls/syscall_32.tbl                                    =
 |    8=20
 arch/x86/ia32/ia32_signal.c                                               =
 |    5=20
 arch/x86/include/asm/syscall_wrapper.h                                    =
 |   53 +
 block/bio.c                                                               =
 |   12=20
 crypto/algif_skcipher.c                                                   =
 |    2=20
 drivers/clk/clk.c                                                         =
 |    1=20
 drivers/clk/imx/clk-pll14xx.c                                             =
 |   40=20
 drivers/clk/meson/axg-audio.c                                             =
 |    2=20
 drivers/clk/samsung/clk-exynos5420.c                                      =
 |    2=20
 drivers/crypto/cavium/nitrox/nitrox_main.c                                =
 |    9=20
 drivers/crypto/geode-aes.c                                                =
 |  440 +++-------
 drivers/crypto/geode-aes.h                                                =
 |   15=20
 drivers/crypto/hisilicon/Kconfig                                          =
 |    1=20
 drivers/crypto/virtio/virtio_crypto_algs.c                                =
 |    9=20
 drivers/devfreq/Kconfig                                                   =
 |    1=20
 drivers/dma/dw/platform.c                                                 =
 |    2=20
 drivers/dma/ioat/dma.c                                                    =
 |    3=20
 drivers/dma/k3dma.c                                                       =
 |   12=20
 drivers/gpio/gpio-mpc8xxx.c                                               =
 |    1=20
 drivers/gpio/gpio-zynq.c                                                  =
 |    8=20
 drivers/gpio/gpiolib.c                                                    =
 |    5=20
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                                       =
 |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                             =
 |    4=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h                             =
 |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                                =
 |   61 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h                                =
 |    3=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c                                   =
 |   85 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                                   =
 |   99 --
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                                     =
 |   15=20
 drivers/gpu/drm/amd/include/discovery.h                                   =
 |    1=20
 drivers/gpu/drm/arm/malidp_mw.c                                           =
 |    2=20
 drivers/gpu/drm/tegra/drm.c                                               =
 |   14=20
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                                    =
 |   28=20
 drivers/hid/hidraw.c                                                      =
 |    7=20
 drivers/hid/uhid.c                                                        =
 |    5=20
 drivers/i2c/busses/i2c-bcm2835.c                                          =
 |   17=20
 drivers/iio/imu/adis16480.c                                               =
 |    6=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c                              =
 |    7=20
 drivers/infiniband/core/counters.c                                        =
 |   12=20
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                                  =
 |    4=20
 drivers/infiniband/hw/bnxt_re/qplib_fp.c                                  =
 |   12=20
 drivers/infiniband/hw/hfi1/iowait.c                                       =
 |    4=20
 drivers/infiniband/hw/hns/Kconfig                                         =
 |   17=20
 drivers/infiniband/hw/hns/Makefile                                        =
 |    8=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                                =
 |   18=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h                                =
 |    4=20
 drivers/infiniband/hw/hns/hns_roce_qp.c                                   =
 |   10=20
 drivers/infiniband/hw/hns/hns_roce_restrack.c                             =
 |    2=20
 drivers/infiniband/hw/mlx5/mr.c                                           =
 |    2=20
 drivers/infiniband/sw/siw/siw_cm.c                                        =
 |    9=20
 drivers/infiniband/ulp/srpt/ib_srpt.c                                     =
 |   24=20
 drivers/iommu/intel-iommu.c                                               =
 |   13=20
 drivers/iommu/iommu.c                                                     =
 |    1=20
 drivers/iommu/mtk_iommu.c                                                 =
 |   25=20
 drivers/iommu/mtk_iommu.h                                                 =
 |    1=20
 drivers/media/i2c/ov6650.c                                                =
 |   79 +
 drivers/media/platform/aspeed-video.c                                     =
 |    3=20
 drivers/media/platform/cadence/cdns-csi2rx.c                              =
 |    2=20
 drivers/media/platform/coda/coda-common.c                                 =
 |    4=20
 drivers/media/platform/exynos4-is/fimc-isp-video.c                        =
 |    2=20
 drivers/media/platform/rcar-vin/rcar-v4l2.c                               =
 |    3=20
 drivers/memory/mtk-smi.c                                                  =
 |    4=20
 drivers/misc/enclosure.c                                                  =
 |    3=20
 drivers/mtd/nand/onenand/omap2.c                                          =
 |    3=20
 drivers/mtd/nand/raw/stm32_fmc2_nand.c                                    =
 |   38=20
 drivers/mtd/spi-nor/spi-nor.c                                             =
 |    4=20
 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c                     =
 |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                               =
 |   20=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                            =
 |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                               =
 |    7=20
 drivers/net/wireless/realtek/rtlwifi/regd.c                               =
 |    2=20
 drivers/net/wireless/rsi/rsi_91x_usb.c                                    =
 |    2=20
 drivers/pci/controller/dwc/pci-meson.c                                    =
 |    6=20
 drivers/pci/controller/dwc/pcie-designware-host.c                         =
 |   11=20
 drivers/pci/controller/pci-aardvark.c                                     =
 |   42=20
 drivers/pci/hotplug/pciehp_core.c                                         =
 |   25=20
 drivers/pci/pci-driver.c                                                  =
 |    3=20
 drivers/pci/pcie/ptm.c                                                    =
 |    2=20
 drivers/pci/probe.c                                                       =
 |    1=20
 drivers/phy/motorola/phy-mapphone-mdm6600.c                               =
 |   11=20
 drivers/pinctrl/cirrus/Kconfig                                            =
 |    1=20
 drivers/pinctrl/intel/pinctrl-lewisburg.c                                 =
 |  171 +--
 drivers/pinctrl/meson/pinctrl-meson.c                                     =
 |    1=20
 drivers/pinctrl/sh-pfc/core.c                                             =
 |   16=20
 drivers/pinctrl/sh-pfc/sh_pfc.h                                           =
 |    4=20
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c                                   =
 |    2=20
 drivers/platform/mellanox/mlxbf-tmfifo.c                                  =
 |   19=20
 drivers/platform/mips/cpu_hwmon.c                                         =
 |    2=20
 drivers/platform/x86/asus-wmi.c                                           =
 |    8=20
 drivers/platform/x86/gpd-pocket-fan.c                                     =
 |   25=20
 drivers/reset/reset-brcmstb.c                                             =
 |    6=20
 drivers/rtc/rtc-bd70528.c                                                 =
 |    1=20
 drivers/rtc/rtc-brcmstb-waketimer.c                                       =
 |    1=20
 drivers/rtc/rtc-msm6242.c                                                 =
 |    3=20
 drivers/rtc/rtc-mt6397.c                                                  =
 |   47 -
 drivers/s390/net/qeth_core_main.c                                         =
 |   29=20
 drivers/s390/net/qeth_l2_main.c                                           =
 |   10=20
 drivers/s390/net/qeth_l3_main.c                                           =
 |    2=20
 drivers/s390/net/qeth_l3_sys.c                                            =
 |   40=20
 drivers/scsi/cxgbi/libcxgbi.c                                             =
 |    3=20
 drivers/scsi/mpt3sas/mpt3sas_base.c                                       =
 |    1=20
 drivers/scsi/sd.c                                                         =
 |   18=20
 drivers/scsi/ufs/ufs_bsg.c                                                =
 |    2=20
 drivers/spi/spi-atmel.c                                                   =
 |   10=20
 drivers/spi/spi-fsl-lpspi.c                                               =
 |    2=20
 drivers/spi/spi-pxa2xx.c                                                  =
 |    7=20
 drivers/spi/spi-rspi.c                                                    =
 |    8=20
 drivers/spi/spi-sprd.c                                                    =
 |    2=20
 drivers/staging/media/hantro/hantro_g1_h264_dec.c                         =
 |    2=20
 drivers/staging/media/hantro/hantro_h264.c                                =
 |   73 -
 drivers/staging/media/ipu3/include/intel-ipu3.h                           =
 |    2=20
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c                          =
 |    4=20
 drivers/target/target_core_iblock.c                                       =
 |    4=20
 drivers/tty/serial/imx.c                                                  =
 |    2=20
 drivers/tty/serial/pch_uart.c                                             =
 |    5=20
 fs/affs/super.c                                                           =
 |    6=20
 fs/afs/dir.c                                                              =
 |   18=20
 fs/afs/super.c                                                            =
 |    1=20
 fs/btrfs/file.c                                                           =
 |    5=20
 fs/buffer.c                                                               =
 |    8=20
 fs/cifs/smb2file.c                                                        =
 |    2=20
 fs/f2fs/data.c                                                            =
 |    2=20
 fs/f2fs/file.c                                                            =
 |    2=20
 fs/gfs2/file.c                                                            =
 |   30=20
 fs/internal.h                                                             =
 |    2=20
 fs/mpage.c                                                                =
 |    2=20
 fs/nfs/nfs2xdr.c                                                          =
 |    2=20
 fs/nfs/nfs4proc.c                                                         =
 |   38=20
 fs/nfsd/Kconfig                                                           =
 |    2=20
 fs/nfsd/nfs4proc.c                                                        =
 |    3=20
 fs/nfsd/nfs4recover.c                                                     =
 |   12=20
 fs/ocfs2/journal.c                                                        =
 |    8=20
 fs/ubifs/journal.c                                                        =
 |    2=20
 fs/ubifs/orphan.c                                                         =
 |   17=20
 fs/ubifs/super.c                                                          =
 |    4=20
 include/asm-generic/cacheflush.h                                          =
 |   33=20
 include/crypto/internal/skcipher.h                                        =
 |   30=20
 include/crypto/skcipher.h                                                 =
 |   30=20
 include/linux/uaccess.h                                                   =
 |   12=20
 include/sound/simple_card_utils.h                                         =
 |    1=20
 include/trace/events/afs.h                                                =
 |   12=20
 include/trace/events/rpcrdma.h                                            =
 |   25=20
 include/uapi/rdma/nes-abi.h                                               =
 |  115 --
 kernel/bpf/cgroup.c                                                       =
 |   11=20
 kernel/cred.c                                                             =
 |    4=20
 kernel/trace/bpf_trace.c                                                  =
 |    6=20
 mm/maccess.c                                                              =
 |   45 -
 net/core/skmsg.c                                                          =
 |   13=20
 net/hsr/hsr_debugfs.c                                                     =
 |   36=20
 net/hsr/hsr_device.c                                                      =
 |    2=20
 net/hsr/hsr_main.c                                                        =
 |    5=20
 net/hsr/hsr_main.h                                                        =
 |   10=20
 net/hsr/hsr_netlink.c                                                     =
 |    1=20
 net/netfilter/nf_tables_offload.c                                         =
 |   26=20
 net/netfilter/nft_flow_offload.c                                          =
 |    3=20
 net/netfilter/nft_meta.c                                                  =
 |   10=20
 net/rxrpc/ar-internal.h                                                   =
 |   10=20
 net/rxrpc/call_accept.c                                                   =
 |   60 -
 net/rxrpc/conn_event.c                                                    =
 |   16=20
 net/rxrpc/conn_service.c                                                  =
 |    4=20
 net/rxrpc/input.c                                                         =
 |   18=20
 net/rxrpc/rxkad.c                                                         =
 |    5=20
 net/rxrpc/security.c                                                      =
 |   70 -
 net/sched/sch_cake.c                                                      =
 |    1=20
 net/socket.c                                                              =
 |    1=20
 net/sunrpc/xprtrdma/frwr_ops.c                                            =
 |    4=20
 net/sunrpc/xprtrdma/rpc_rdma.c                                            =
 |    1=20
 net/sunrpc/xprtrdma/transport.c                                           =
 |    3=20
 net/sunrpc/xprtrdma/verbs.c                                               =
 |  103 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                                           =
 |    3=20
 net/unix/af_unix.c                                                        =
 |   19=20
 scripts/link-vmlinux.sh                                                   =
 |    7=20
 scripts/package/mkdebian                                                  =
 |    2=20
 security/tomoyo/common.c                                                  =
 |    9=20
 security/tomoyo/domain.c                                                  =
 |   15=20
 security/tomoyo/group.c                                                   =
 |    9=20
 security/tomoyo/util.c                                                    =
 |    6=20
 sound/soc/fsl/fsl_esai.c                                                  =
 |   12=20
 sound/soc/intel/Kconfig                                                   =
 |    3=20
 sound/soc/sh/rcar/core.c                                                  =
 |   20=20
 sound/soc/soc-core.c                                                      =
 |    2=20
 sound/soc/soc-pcm.c                                                       =
 |    2=20
 sound/soc/sof/imx/imx8.c                                                  =
 |    5=20
 sound/soc/sof/intel/Kconfig                                               =
 |   10=20
 sound/soc/stm/stm32_spdifrx.c                                             =
 |   40=20
 tools/lib/bpf/Makefile                                                    =
 |    2=20
 tools/pci/pcitest.c                                                       =
 |    1=20
 tools/perf/pmu-events/arch/s390/cf_z14/extended.json                      =
 |    2=20
 tools/testing/selftests/firmware/fw_lib.sh                                =
 |    6=20
 tools/testing/selftests/net/forwarding/loopback.sh                        =
 |    8=20
 tools/testing/selftests/rseq/settings                                     =
 |    1=20
 222 files changed, 1848 insertions(+), 1422 deletions(-)

Alexander Usyskin (1):
      mei: fix modalias documentation

Alexander.Barabash@dell.com (1):
      ioat: ioat_alloc_ring() failure handling.

Alexandra Winter (3):
      s390/qeth: fix false reporting of VNIC CHAR config failure
      s390/qeth: Fix vnicc_is_in_use if rx_bcast not set
      s390/qeth: vnicc Fix init to default

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded

Andrii Nakryiko (1):
      libbpf: Fix Makefile' libbpf symbol mismatch diagnostic

Andy Lutomirski (1):
      syscalls/x86: Wire up COMPAT_SYSCALL_DEFINE0

Andy Shevchenko (3):
      MAINTAINERS: Append missed file to the database
      dmaengine: dw: platform: Mark 'hclk' clock optional
      pinctrl: lewisburg: Update pin list according to v1.1v6

Ard Biesheuvel (2):
      crypto: virtio - implement missing support for output IVs
      kbuild/deb-pkg: annotate libelf-dev dependency as :native

Arnd Bergmann (8):
      pinctrl: lochnagar: select GPIOLIB
      PM / devfreq: tegra: Add COMMON_CLK dependency
      netfilter: nft_meta: use 64-bit time arithmetic
      RDMA/hns: Fix build error again
      scsi: sd: enable compat ioctls for sed-opal
      gfs2: add compat_ioctl support
      af_unix: add compat_ioctl support
      compat_ioctl: handle SIOCOUTQNSD

Bart Van Assche (2):
      RDMA/siw: Fix port number endianness in a debug message
      RDMA/srpt: Report the SCSI residual to the initiator

Ben Dooks (Codethink) (2):
      ubifs: Fixed missed le64_to_cpu() in journal
      drm/arm/mali: make malidp_mw_connector_helper_funcs static

Bjorn Helgaas (2):
      PCI/PM: Clear PCIe PME Status even for legacy power management
      PCI/PTM: Remove spurious "d" from granularity message

Boris Brezillon (1):
      media: hantro: h264: Fix the frame_num wraparound case

Can Guo (1):
      scsi: ufs: Give an unique ID to each ufs-bsg

Chao Yu (1):
      f2fs: fix potential overflow

Christian K=C3=B6nig (1):
      drm/amdgpu: cleanup creating BOs at fixed location (v2)

Christian Lamparter (1):
      ath9k: use iowrite32 over __raw_writel

Christophe JAILLET (1):
      media: v4l: cadence: Fix how unsued lanes are handled in 'csi2rx_star=
t()'

Christophe Kerello (1):
      mtd: rawnand: stm32_fmc2: avoid to lock the CPU bus

Chuck Lever (7):
      xprtrdma: Add unique trace points for posting Local Invalidate WRs
      xprtrdma: Connection becomes unstable after a reconnect
      xprtrdma: Fix MR list handling
      xprtrdma: Close window between waking RPC senders and posting Receives
      xprtrdma: Fix create_qp crash on device unload
      xprtrdma: Fix completion wait during device removal
      xprtrdma: Fix oops in Receive handler after device removal

Chuhong Yuan (1):
      rtc: brcmstb-waketimer: add missed clk_disable_unprepare

Colin Ian King (2):
      ASoC: SOF: imx8: fix memory allocation failure check on priv->pd_dev
      pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_a=
rgs call

Dan Carpenter (1):
      scsi: mpt3sas: Fix double free in attach error handling

Daniel Baluta (3):
      ASoC: soc-core: Set dpcm_playback / dpcm_capture
      ASoC: SOF: imx8: Fix dsp_box offset
      ASoC: simple_card_utils.h: Add missing include

Daniel Borkmann (2):
      uaccess: Add non-pagefault user-space write function
      bpf: Make use of probe_user_write in probe write helper

Daniel Vetter (1):
      spi: pxa2xx: Set controller->max_transfer_size in dma mode

David Howells (7):
      afs: Fix missing cell comparison in afs_test_super()
      afs: Fix use-after-loss-of-ref
      afs: Fix afs_lookup() to not clobber the version on a new dentry
      keys: Fix request_key() cache
      rxrpc: Unlock new call in rxrpc_new_incoming_call() rather than the c=
aller
      rxrpc: Don't take call->user_mutex in rxrpc_new_incoming_call()
      rxrpc: Fix missing security check on incoming calls

Denis Efremov (1):
      rsi: fix potential null dereference in rsi_probe()

Diego Calleja (1):
      dm: add dm-clone to the documentation index

Dietmar Eggemann (1):
      ARM: 8943/1: Fix topology setup in case of CPU hotplug for CONFIG_SCH=
ED_MC

Ed Maste (1):
      perf vendor events s390: Remove name from L1D_RO_EXCL_WRITES descript=
ion

Eric Biggers (1):
      crypto: geode-aes - convert to skcipher API and make thread-safe

Florian Fainelli (2):
      dt-bindings: reset: Fix brcmstb-reset example
      reset: brcmstb: Remove resource checks

Geert Uytterhoeven (3):
      gpio: Fix error message on out-of-range GPIO in lookup table
      pinctrl: sh-pfc: Do not use platform_get_irq() to count interrupts
      spi: rspi: Use platform_get_irq_byname_optional() for optional irqs

Goldwyn Rodrigues (1):
      btrfs: simplify inode locking for RWF_NOWAIT

Greg Kroah-Hartman (2):
      Revert "drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper."
      Linux 5.4.13

Hangbin Liu (1):
      selftests: loopback.sh: skip this test if the driver does not support

Hans de Goede (1):
      platform/x86: GPD pocket fan: Use default values when wrong modparams=
 are given

Herbert Xu (1):
      crypto: algif_skcipher - Use chunksize instead of blocksize

Hewenliang (1):
      tools: PCI: Fix fd leakage

Huanpeng Xin (1):
      spi: sprd: Fix the incorrect SPI register

Israel Rukshin (1):
      scsi: target/iblock: Fix protection error with blocks greater than 51=
2B

James Bottomley (1):
      scsi: enclosure: Fix stale device oops with hot replug

Janusz Krzysztofik (4):
      media: ov6650: Fix incorrect use of JPEG colorspace
      media: ov6650: Fix some format attributes not under control
      media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support
      media: ov6650: Fix default format not applied on device probe

Jason Gunthorpe (2):
      RDMA/hns: Prevent undefined behavior in hns_roce_set_user_sq_size()
      rdma: Remove nes ABI header

Jerome Brunet (1):
      clk: meson: axg-audio: fix regmap last register

Jian-Hong Pan (1):
      platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Jiri Kosina (1):
      HID: hidraw, uhid: Always report EPOLLOUT

John Fastabend (1):
      bpf: skmsg, fix potential psock NULL pointer dereference

John Stultz (1):
      dmaengine: k3dma: Avoid null pointer traversal

Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=B3) (1):
      gpio: mpc8xxx: Add platform device to gpiochip->parent

Jon Derrick (2):
      iommu/vt-d: Unlink device if failed to add to group
      iommu: Remove device link to group on failure

Jonas Karlman (3):
      media: cedrus: Use correct H264 8x8 scaling list
      media: hantro: Do not reorder H264 scaling list
      media: hantro: Set H264 FIELDPIC_FLAG_E flag correctly

Jouni Hogander (1):
      MIPS: Prevent link failure with kcov instrumentation

Julian Wiedmann (3):
      s390/qeth: fix qdio teardown after early init error
      s390/qeth: fix initialization on old HW
      s390/qeth: lock the card while changing its hsuid

Kai Li (1):
      ocfs2: call journal flush to mark journal as empty after journal reco=
very when mount

Kaike Wan (1):
      IB/hfi1: Don't cancel unused work item

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit

Keiya Nobuta (1):
      pinctrl: sh-pfc: Fix PINMUX_IPSR_PHYS() to set GPSR

Kishon Vijay Abraham I (1):
      clk: Fix memory leak in clk_unregister()

Lang Cheng (1):
      RDMA/hns: Modify return value of restrack functions

Leon Romanovsky (1):
      RDMA/mlx5: Return proper error value

Leonard Crestez (1):
      clk: imx: pll14xx: Fix quick switch of S/K parameter

Lijun Ou (1):
      RDMA/hns: Fix to support 64K page for srq

Liming Sun (1):
      platform/mellanox: fix potential deadlock in the tmfifo driver

Loic Poulain (1):
      arm64: dts: apq8096-db820c: Increase load on l21 for SDCARD

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix gyro gain definitions for LSM9DS1

Luca Coelho (1):
      iwlwifi: mvm: fix support for single antenna diversity

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer

Marc Kleine-Budde (1):
      can: j1939: fix address claim code example

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during su=
spend/resume

Mark Zhang (1):
      RDMA/counter: Prevent QP counter manual binding in auto mode

Mathieu Desnoyers (1):
      rseq/selftests: Turn off timeout setting

Matti Vaittinen (1):
      rtc: bd70528: Add MODULE ALIAS to autoload module

Mika Westerberg (1):
      PCI: pciehp: Do not disable interrupt twice on suspend

Mike Rapoport (1):
      asm-generic/nds32: don't redefine cacheflush primitives

Ming Lei (1):
      fs: move guard_bio_eod() after bio_set_op_attrs

Mordechay Goodstein (1):
      iwlwifi: mvm: consider ieee80211 station max amsdu value

Nathan Chancellor (2):
      cifs: Adjust indentation in smb2_open_file
      rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Navid Emamdoost (3):
      affs: fix a memory leak in affs_remount
      media: aspeed-video: Fix memory leaks in aspeed_video_probe
      spi: lpspi: fix memory leak in fsl_lpspi_probe

Neil Armstrong (1):
      PCI: amlogic: Fix probed clock names

Nick Desaulniers (2):
      hexagon: parenthesize registers in asm predicates
      hexagon: work around compiler crash

Niklas Cassel (1):
      PCI: dwc: Fix find_next_bit() usage

Niklas S=C3=B6derlund (1):
      media: rcar-vin: Fix incorrect return statement in rvin_try_format()

Nilkanth Ahirrao (1):
      ASoC: rsnd: fix DALIGN register for SSIU

Olga Kornievskaia (1):
      NFSD fixing possible null pointer derefering in copy offload

Oliver O'Halloran (1):
      powerpc/powernv: Disable native PCIe port management

Olivier Moysan (3):
      ASoC: stm32: spdifrx: fix inconsistent lock state
      ASoC: stm32: spdifrx: fix race condition in irq handler
      ASoC: stm32: spdifrx: fix input pin state management

Olof Johansson (1):
      riscv: export flush_icache_all to modules

Pablo Neira Ayuso (1):
      netfilter: nf_tables_offload: release flow_rule on error from commit =
path

Paul Menzel (1):
      scsi: smartpqi: Update attribute name to `driver_version`

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
      tty: serial: pch_uart: correct usage of dma_unmap_sg

Peter Ujfalusi (1):
      mtd: onenand: omap2: Pass correct flags for prep_dma_memcpy

Phani Kiran Hemadri (1):
      crypto: cavium/nitrox - fix firmware assignment to AE cores

Philipp Zabel (1):
      media: coda: fix deadlock between decoder picture run and start comma=
nd

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: Broadwell: clarify mutual exclusion with legacy dri=
ver

Qianggui Song (1):
      pinctrl: meson: Fix wrong shift value when get drive-strength

Ran Bi (1):
      rtc: mt6397: fix alarm register overwrite

Remi Pommarel (2):
      PCI: aardvark: Use LTSSM state to build link training flag
      PCI: aardvark: Fix PCI_EXP_RTCTL register configuration

Richard Weinberger (1):
      Revert "ubifs: Fix memory leak bug in alloc_ubifs_info() error path"

Rob Herring (1):
      PCI: Fix missing bridge dma_ranges resource list cleanup

Roman Gushchin (1):
      bpf: cgroup: prevent out-of-order release of cgroup bpf

Sakari Ailus (1):
      media: intel-ipu3: Align struct ipu3_uapi_awb_fr_config_s to 32 bytes

Sami Tolvanen (3):
      syscalls/x86: Use COMPAT_SYSCALL_DEFINE0 for IA32 (rt_)sigreturn
      syscalls/x86: Use the correct function type for sys_ni_syscall
      syscalls/x86: Fix function types in COND_SYSCALL

Scott Mayhew (2):
      nfsd: Fix cld_net->cn_tfm initialization
      nfsd: v4 support requires CRYPTO_SHA256

Selvin Xavier (2):
      RDMA/bnxt_re: Avoid freeing MR resources if dereg fails
      RDMA/bnxt_re: Fix Send Work Entry state check while polling completio=
ns

Sergei Shtylyov (2):
      mtd: spi-nor: fix silent truncation in spi_nor_read()
      mtd: spi-nor: fix silent truncation in spi_nor_read_raw()

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()

Shengjiu Wang (1):
      ASoC: fsl_esai: Add spin lock to protect reset, stop and start

Shuah Khan (1):
      selftests: firmware: Fix it to do root uid check and skip

Stanislav Fomichev (1):
      bpf: Support pre-2.25-binutils objcopy for vmlinux BTF

Stefan Wahren (1):
      i2c: bcm2835: Store pointer to bus clock

Swapna Manupati (1):
      gpio: zynq: Fix for bug in zynq_gpio_restore_context API

Taehee Yoo (4):
      hsr: add hsr root debugfs directory
      hsr: rename debugfs file when interface name is changed
      hsr: reset network header when supervision frame is created
      hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename()

Takashi Iwai (1):
      ASoC: core: Fix compile warning with CONFIG_DEBUG_FS=3Dn

Tetsuo Handa (1):
      tomoyo: Suppress RCU warning at list_for_each_entry_rcu().

Thierry Reding (1):
      drm/tegra: Fix ordering of cleanup code

Thomas Bogendoerfer (2):
      MIPS: PCI: remember nasid changed by set interrupt affinity
      MIPS: SGI-IP27: Fix crash, when CPUs are disabled via nr_cpus paramet=
er

Tiezhu Yang (1):
      MIPS: Loongson: Fix return value of loongson_hwmon_init

Tony Lindgren (1):
      phy: mapphone-mdm6600: Fix uninitialized status value regression

Trond Myklebust (3):
      NFSv2: Fix a typo in encode_sattr()
      NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process=
()
      NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutre=
turn

Tzung-Bi Shih (1):
      ASoC: dt-bindings: mt8183: add missing update

Vadim Pasternak (2):
      Documentation/ABI: Fix documentation inconsistency for mlxreg-io sysf=
s interfaces
      Documentation/ABI: Add missed attribute for mlxreg-io sysfs interfaces

Varun Prakash (1):
      scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Victorien Molle (1):
      sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO

Vincenzo Frascino (1):
      mips: Fix gettimeofday() in the vdso library

Vladimir Kondratiev (1):
      mips: cacheinfo: report shared CPU map

Weihang Li (1):
      RDMA/hns: remove a redundant le16_to_cpu

Xiang Chen (1):
      scsi: sd: Clear sdkp->protection_type if disk is reformatted without =
PI

Xiaojie Yuan (1):
      drm/amdgpu/discovery: reserve discovery data at the top of VRAM

Yangyang Li (2):
      RDMA/hns: Release qp resources when failed to destroy qp
      RDMA/hns: Bugfix for qpc/cqc timer configuration

Yong Wu (3):
      iommu/mediatek: Correct the flush_iotlb_all callback
      iommu/mediatek: Add a new tlb_lock for tlb_flush
      memory: mtk-smi: Add PM suspend and resume ops

Yunfeng Ye (1):
      crypto: arm64/aes-neonbs - add return value of skcipher_walk_done() i=
n __xts_crypt()

Zhihao Cheng (1):
      ubifs: do_kill_orphans: Fix a memory leak bug

Zhou Wang (1):
      crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm Kconfig

changzhu (1):
      drm/amdgpu: enable gfxoff for raven1 refresh

wenxu (1):
      netfilter: nft_flow_offload: fix underflow in flowtable reference cou=
nter


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4iPwkACgkQONu9yGCS
aT4B5RAAshteq9jkm4d3QWP7cUsXnrKav7Z/e6dOZdYxmTe+BTg/Vdmu8H9ZIxz4
tpIbrtv2OjQary3v8XHa4ANrHfTXQdgHjNfXajfO0T/Nc4YLEN7oKQAl0fjZMdBL
7ayP52QIOBkUHmXL0+i+d4mX4HHhvkUicH1TcbvPgZ8F9aYiSOzNlj50TuWRZ8A4
Dpng4wZljs6RkEa8lPRhh6vZapWXgd4zWBqgo4L478zMtGv9P1GBiXuPfePLHOI9
pcykw5+fbmeHPLkudfGRPOPHIlHkkt8EFiBO6IQpD7jMQSrSmKZfATIFrSAvnqbD
XfM6KVjLpSpGPd+m74TdBYzAnbatbDL5K97tUFWXTGtLH2NT/B2CUMKaYoH8raRP
MWdnkrzYNjAczZDTjveTKrsZ/dxJuTrWGdklgOBYCfxUdYwDm6a05YuFi84e1Cnc
73b1BlHo56S1t799H9wlLe/IOlpjpoAOy50XFYeYFTodxZ+LX0IPshNepkFltARf
IxZWwIY/8i4ixDVRogulEEazp7hf2TfLADhdc38BiL7FJvH556usjehjjVmeBZoP
IxzSs2jdLGBZ0TdLh3z0S82sEfkEXdJ/yOUnlTHZcyC5BJTjS8y8YEedoSQD4XDb
yiVdR9Y3KcU0I2PMPmwrcBKp97/tJ9FI0fFXKl1dkGQ/Xd/6egQ=
=pCq6
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
