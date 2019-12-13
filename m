Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE011ED39
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 22:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfLMVtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 16:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfLMVtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 16:49:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 129A82077B;
        Fri, 13 Dec 2019 21:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576273745;
        bh=vpo7YJH224URofh9ZBhYhZivoPAJhCt20WICKgSsVy4=;
        h=Date:From:To:Cc:Subject:From;
        b=z6oMmJJCSCq4tJghAeqiv+Uv2SW4/Ajo8EuojBevsniOUwzIvZv65dd/Ht1/Uv0zV
         hir6X14OEZ58UshqFp2Lfnrn69h9teB2ZdrrAzM86blsLbVnWTk/G4x0kHYI+/mR8f
         fTOlKvz5DczmJgEzGgSfDQ6k+MEOcu3uZAvcDe1c=
Date:   Fri, 13 Dec 2019 17:14:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.89
Message-ID: <20191213161431.GA2682954@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.89 kernel.

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

 Documentation/devicetree/bindings/rtc/abracon,abx80x.txt     |    2=20
 Makefile                                                     |   13 -
 arch/arc/include/asm/cache.h                                 |    2=20
 arch/arc/mm/cache.c                                          |   20 +
 arch/arm/Kconfig.debug                                       |   23 +
 arch/arm/boot/dts/am335x-pdu001.dts                          |    2=20
 arch/arm/boot/dts/arm-realview-pb1176.dts                    |    4=20
 arch/arm/boot/dts/arm-realview-pb11mp.dts                    |    4=20
 arch/arm/boot/dts/arm-realview-pbx.dtsi                      |    5=20
 arch/arm/boot/dts/exynos3250.dtsi                            |    2=20
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi                |    2=20
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi                      |    5=20
 arch/arm/boot/dts/mmp2.dtsi                                  |    2=20
 arch/arm/boot/dts/pxa27x.dtsi                                |    2=20
 arch/arm/boot/dts/pxa2xx.dtsi                                |    7=20
 arch/arm/boot/dts/pxa3xx.dtsi                                |    2=20
 arch/arm/boot/dts/r8a7790-lager.dts                          |    2=20
 arch/arm/boot/dts/r8a7791-koelsch.dts                        |    2=20
 arch/arm/boot/dts/r8a7791-porter.dts                         |    2=20
 arch/arm/boot/dts/rk3288-rock2-som.dtsi                      |    2=20
 arch/arm/boot/dts/rv1108.dtsi                                |   10=20
 arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts                 |    2=20
 arch/arm/boot/dts/sun4i-a10-pcduino.dts                      |    2=20
 arch/arm/boot/dts/sun4i-a10.dtsi                             |    2=20
 arch/arm/boot/dts/sun5i-a10s.dtsi                            |    2=20
 arch/arm/boot/dts/sun6i-a31.dtsi                             |    2=20
 arch/arm/boot/dts/sun7i-a20.dtsi                             |    4=20
 arch/arm/boot/dts/sun8i-h3.dtsi                              |    8=20
 arch/arm/boot/dts/sun8i-r16-bananapi-m2m.dts                 |    4=20
 arch/arm/boot/dts/sun8i-v3s-licheepi-zero.dts                |    4=20
 arch/arm/boot/dts/sun8i-v3s.dtsi                             |   10=20
 arch/arm/include/asm/uaccess.h                               |   18 +
 arch/arm/lib/getuser.S                                       |   11=20
 arch/arm/lib/putuser.S                                       |   20 -
 arch/arm/mach-omap1/id.c                                     |    6=20
 arch/arm/mach-omap2/id.c                                     |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts         |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts          |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts   |    4=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts |    4=20
 arch/arm64/boot/dts/exynos/exynos5433.dtsi                   |    6=20
 arch/arm64/boot/dts/exynos/exynos7.dtsi                      |    6=20
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi               |    2=20
 arch/arm64/boot/dts/xilinx/zynqmp-clk.dtsi                   |    4=20
 arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dts            |    4=20
 arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dts            |   10=20
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts            |    2=20
 arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dts            |    2=20
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi                       |    4=20
 arch/mips/Kconfig                                            |    1=20
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c           |    2=20
 arch/mips/cavium-octeon/octeon-platform.c                    |    2=20
 arch/mips/include/asm/octeon/cvmx-pko.h                      |    2=20
 arch/nds32/kernel/setup.c                                    |    3=20
 arch/powerpc/include/asm/sfp-machine.h                       |   92 ++-----
 arch/sparc/include/asm/io_64.h                               |    1=20
 arch/sparc/net/bpf_jit_comp_64.c                             |   89 +++++--
 arch/x86/kvm/cpuid.c                                         |    5=20
 arch/x86/kvm/x86.c                                           |   17 +
 arch/x86/mm/fault.c                                          |    2=20
 arch/x86/pci/fixup.c                                         |   11=20
 crypto/af_alg.c                                              |    2=20
 crypto/crypto_user.c                                         |    4=20
 crypto/ecc.c                                                 |   45 ++-
 drivers/android/binder_alloc.c                               |   30 +-
 drivers/block/rsxx/core.c                                    |    2=20
 drivers/bus/ti-sysc.c                                        |    9=20
 drivers/char/lp.c                                            |    4=20
 drivers/clk/mediatek/clk-cpumux.c                            |    8=20
 drivers/clk/mediatek/clk-mt7622.c                            |    4=20
 drivers/clk/meson/gxbb.c                                     |    8=20
 drivers/clk/meson/meson8b.c                                  |    2=20
 drivers/clk/qcom/gcc-msm8998.c                               |   44 +--
 drivers/clk/renesas/r8a77990-cpg-mssr.c                      |    4=20
 drivers/clk/renesas/r8a77995-cpg-mssr.c                      |    4=20
 drivers/clk/renesas/rcar-gen3-cpg.c                          |   16 -
 drivers/clk/rockchip/clk-rk3188.c                            |    8=20
 drivers/clk/rockchip/clk-rk3328.c                            |    2=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                        |    2=20
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                          |    2=20
 drivers/crypto/amcc/crypto4xx_core.c                         |    6=20
 drivers/crypto/atmel-aes.c                                   |   53 ++--
 drivers/crypto/bcm/cipher.c                                  |    6=20
 drivers/crypto/ccp/ccp-dmaengine.c                           |    1=20
 drivers/dma/coh901318.c                                      |    5=20
 drivers/dma/dw/core.c                                        |    2=20
 drivers/dma/dw/platform.c                                    |    6=20
 drivers/dma/dw/regs.h                                        |    4=20
 drivers/extcon/extcon-max8997.c                              |   10=20
 drivers/firmware/raspberrypi.c                               |   35 +-
 drivers/gpu/drm/i810/i810_dma.c                              |    4=20
 drivers/gpu/drm/msm/msm_debugfs.c                            |    6=20
 drivers/gpu/drm/sun4i/sun4i_tcon.c                           |    2=20
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h                   |    2=20
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c          |   21 +
 drivers/i2c/busses/i2c-imx.c                                 |    3=20
 drivers/i2c/i2c-core-of.c                                    |    4=20
 drivers/infiniband/hw/cxgb4/cm.c                             |    3=20
 drivers/infiniband/hw/hfi1/chip.c                            |   47 +++
 drivers/infiniband/hw/hfi1/vnic_sdma.c                       |   15 -
 drivers/infiniband/hw/hns/hns_roce_hem.h                     |    2=20
 drivers/infiniband/hw/mlx4/sysfs.c                           |   12 -
 drivers/infiniband/hw/qib/qib_sysfs.c                        |    6=20
 drivers/input/joystick/psxpad-spi.c                          |    2=20
 drivers/input/mouse/synaptics.c                              |    1=20
 drivers/input/rmi4/rmi_f34v7.c                               |    3=20
 drivers/input/rmi4/rmi_smbus.c                               |    2=20
 drivers/input/touchscreen/cyttsp4_core.c                     |    7=20
 drivers/input/touchscreen/goodix.c                           |    9=20
 drivers/iommu/amd_iommu.c                                    |   22 -
 drivers/md/raid0.c                                           |    2=20
 drivers/media/cec/cec-adap.c                                 |    7=20
 drivers/media/platform/coda/coda-common.c                    |   26 --
 drivers/media/platform/coda/coda.h                           |    3=20
 drivers/media/platform/vimc/vimc-common.c                    |    2=20
 drivers/media/spi/cxd2880-spi.c                              |    1=20
 drivers/media/usb/pulse8-cec/pulse8-cec.c                    |    2=20
 drivers/media/usb/stkwebcam/stk-webcam.c                     |    6=20
 drivers/media/usb/uvc/uvc_driver.c                           |   54 +++-
 drivers/misc/altera-stapl/altera.c                           |    3=20
 drivers/net/can/slcan.c                                      |    1=20
 drivers/net/can/usb/ucan.c                                   |    2=20
 drivers/net/can/xilinx_can.c                                 |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                             |   21 +
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h              |    4=20
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c              |    2=20
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c          |    6=20
 drivers/net/ethernet/cirrus/ep93xx_eth.c                     |    5=20
 drivers/net/ethernet/huawei/hinic/hinic_main.c               |    7=20
 drivers/net/ethernet/huawei/hinic/hinic_rx.c                 |    2=20
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c               |   10=20
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h              |    6=20
 drivers/net/ethernet/intel/ice/ice_switch.c                  |    3=20
 drivers/net/ethernet/intel/ice/ice_txrx.c                    |    3=20
 drivers/net/ethernet/mellanox/mlx4/main.c                    |   11=20
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                 |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c        |    5=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c           |    5=20
 drivers/net/ethernet/renesas/ravb.h                          |    1=20
 drivers/net/ethernet/renesas/ravb_main.c                     |   19 -
 drivers/net/ethernet/ti/cpts.c                               |    4=20
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c               |    1=20
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h                |    7=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c            |   15 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                 |   10=20
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c              |   34 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c            |   20 -
 drivers/net/wireless/marvell/mwifiex/main.c                  |    6=20
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                      |    1=20
 drivers/nfc/nxp-nci/i2c.c                                    |    6=20
 drivers/nvme/host/core.c                                     |    2=20
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c                     |   23 +
 drivers/rtc/rtc-max77686.c                                   |    2=20
 drivers/rtc/rtc-max8997.c                                    |    2=20
 drivers/rtc/rtc-s3c.c                                        |    6=20
 drivers/s390/scsi/zfcp_erp.c                                 |    3=20
 drivers/s390/scsi/zfcp_fsf.c                                 |    7=20
 drivers/slimbus/qcom-ngd-ctrl.c                              |    5=20
 drivers/soc/Makefile                                         |    2=20
 drivers/soc/renesas/r8a77970-sysc.c                          |    4=20
 drivers/soc/renesas/r8a77980-sysc.c                          |   10=20
 drivers/soc/renesas/r8a77990-sysc.c                          |   23 -
 drivers/spi/spi-atmel.c                                      |    6=20
 drivers/staging/iio/addac/adt7316-i2c.c                      |    2=20
 drivers/thermal/thermal_core.c                               |    4=20
 drivers/tty/n_hdlc.c                                         |    4=20
 drivers/tty/n_r3964.c                                        |    2=20
 drivers/tty/n_tty.c                                          |    8=20
 drivers/tty/serial/amba-pl011.c                              |    6=20
 drivers/tty/serial/fsl_lpuart.c                              |    4=20
 drivers/tty/serial/ifx6x60.c                                 |    3=20
 drivers/tty/serial/imx.c                                     |    2=20
 drivers/tty/serial/msm_serial.c                              |    6=20
 drivers/tty/serial/qcom_geni_serial.c                        |   56 +++-
 drivers/tty/serial/serial_core.c                             |    2=20
 drivers/tty/tty_ldisc.c                                      |    7=20
 drivers/tty/vt/keyboard.c                                    |    2=20
 drivers/tty/vt/vc_screen.c                                   |    3=20
 drivers/usb/dwc3/core.c                                      |    3=20
 drivers/usb/dwc3/debug.h                                     |   29 ++
 drivers/usb/dwc3/debugfs.c                                   |   19 +
 drivers/usb/gadget/function/u_serial.c                       |    2=20
 drivers/usb/mtu3/mtu3_qmu.c                                  |    2=20
 drivers/usb/serial/f81534.c                                  |   20 +
 drivers/watchdog/aspeed_wdt.c                                |   16 -
 fs/autofs/expire.c                                           |    5=20
 fs/cifs/file.c                                               |    7=20
 fs/cifs/smb2misc.c                                           |    7=20
 fs/dlm/lockspace.c                                           |    1=20
 fs/dlm/member.c                                              |    2=20
 fs/dlm/memory.c                                              |    9=20
 fs/dlm/user.c                                                |    3=20
 fs/exportfs/expfs.c                                          |   31 +-
 fs/f2fs/file.c                                               |    2=20
 fs/f2fs/gc.c                                                 |   10=20
 fs/f2fs/segment.c                                            |    2=20
 fs/fuse/dir.c                                                |   27 +-
 fs/fuse/fuse_i.h                                             |    2=20
 fs/iomap.c                                                   |   53 +++-
 fs/kernfs/dir.c                                              |    5=20
 fs/lockd/clnt4xdr.c                                          |   22 -
 fs/lockd/clntxdr.c                                           |   22 -
 fs/nfsd/nfs4recover.c                                        |   17 -
 fs/nfsd/vfs.c                                                |   17 +
 fs/pstore/ram.c                                              |    2=20
 fs/splice.c                                                  |    7=20
 fs/xfs/xfs_bmap_util.c                                       |    6=20
 include/dt-bindings/clock/rk3328-cru.h                       |    2=20
 include/dt-bindings/power/r8a77970-sysc.h                    |    6=20
 include/dt-bindings/power/r8a77980-sysc.h                    |    6=20
 include/linux/acpi.h                                         |    2=20
 include/linux/atalk.h                                        |    2=20
 include/linux/avf/virtchnl.h                                 |    4=20
 include/linux/dma-mapping.h                                  |    3=20
 include/linux/jbd2.h                                         |    4=20
 include/linux/kernfs.h                                       |    1=20
 include/linux/mtd/mtd.h                                      |    2=20
 include/linux/platform_data/dma-dw.h                         |    6=20
 include/linux/qcom_scm.h                                     |    3=20
 include/linux/regulator/consumer.h                           |    2=20
 include/linux/serial_core.h                                  |   37 +++
 include/linux/tty.h                                          |    7=20
 include/math-emu/soft-fp.h                                   |    2=20
 include/net/sctp/sctp.h                                      |    5=20
 include/net/tcp.h                                            |    2=20
 include/net/xfrm.h                                           |    1=20
 kernel/audit_tree.c                                          |   27 --
 kernel/audit_watch.c                                         |    2=20
 kernel/bpf/btf.c                                             |   82 ++++++
 kernel/events/core.c                                         |    2=20
 kernel/sched/core.c                                          |    3=20
 kernel/sched/fair.c                                          |   36 +--
 mm/vmstat.c                                                  |    7=20
 net/appletalk/aarp.c                                         |   15 +
 net/appletalk/ddp.c                                          |   21 +
 net/ipv4/tcp_output.c                                        |    2=20
 net/ipv4/tcp_timer.c                                         |   10=20
 net/ipv6/addrconf.c                                          |   19 +
 net/netfilter/nf_tables_api.c                                |   17 -
 net/qrtr/tun.c                                               |    5=20
 net/sctp/chunk.c                                             |    6=20
 net/sctp/output.c                                            |   22 -
 net/sctp/socket.c                                            |    3=20
 net/smc/smc_wr.c                                             |    4=20
 net/x25/af_x25.c                                             |   18 -
 net/xfrm/xfrm_input.c                                        |    3=20
 net/xfrm/xfrm_interface.c                                    |  132 +++---=
-----
 scripts/Makefile.lib                                         |    1=20
 scripts/mod/modpost.c                                        |   12 +
 sound/core/oss/linear.c                                      |    2=20
 sound/core/oss/mulaw.c                                       |    2=20
 sound/core/oss/route.c                                       |    2=20
 sound/core/pcm_lib.c                                         |    8=20
 sound/pci/hda/hda_bind.c                                     |    4=20
 sound/pci/hda/hda_intel.c                                    |    3=20
 sound/pci/hda/patch_conexant.c                               |    1=20
 sound/pci/hda/patch_realtek.c                                |   18 +
 sound/soc/codecs/max9867.c                                   |   72 +++---
 sound/soc/codecs/max9867.h                                   |    2=20
 sound/soc/codecs/nau8540.c                                   |    2=20
 sound/soc/sh/rcar/core.c                                     |   12 +
 sound/soc/sh/rcar/dvc.c                                      |    8=20
 tools/bpf/bpftool/btf_dumper.c                               |    6=20
 tools/lib/bpf/libbpf.c                                       |    2=20
 tools/lib/bpf/libbpf_errno.c                                 |    1=20
 tools/perf/builtin-script.c                                  |    2=20
 tools/testing/selftests/kvm/lib/assert.c                     |    4=20
 tools/testing/selftests/powerpc/ptrace/core-pkey.c           |    5=20
 tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c          |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c       |    4=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c   |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c   |    3=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c       |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c       |    2=20
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c       |    3=20
 virt/kvm/arm/vgic/vgic-v3.c                                  |    6=20
 277 files changed, 1570 insertions(+), 1041 deletions(-)

Aaro Koskinen (3):
      MIPS: OCTEON: octeon-platform: fix typing
      ARM: OMAP1/2: fix SoC name printing
      MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible defi=
nition

Adrian Hunter (1):
      perf script: Fix invalid LBR/binary mismatch error

Al Viro (3):
      autofs: fix a leak in autofs_expire_indirect()
      exportfs_decode_fh(): negative pinned may become positive without the=
 parent locked
      audit_get_nd(): don't unlock parent too early

Alexander Shishkin (1):
      perf/core: Consistently fail fork on allocation failures

Alexey Dobriyan (1):
      ACPI: fix acpi_find_child_device() invocation in acpi_preset_companio=
n()

Alice Michael (1):
      virtchnl: Fix off by one error

Anand Moon (1):
      ARM: dts: exynos: Fix LDO13 min values on Odroid XU3/XU4/HC1

Andreas Pape (1):
      media: stkwebcam: Bugfix for wrong return values

Andrei Otcheretianski (1):
      iwlwifi: mvm: Send non offchannel traffic via AP sta

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Work around mv886e6161 SERDES missing MII_PHYSID2

Ard Biesheuvel (1):
      crypto: ecdh - fix big endian bug in ECC library

Arjun Vynipadath (1):
      cxgb4vf: fix memleak in mac_hlist initialization

Arnd Bergmann (1):
      lp: fix sparc64 LPSETTIMEOUT ioctl

Ayush Sawal (1):
      crypto: af_alg - cast ki_complete ternary op to int

Baruch Siach (1):
      rtc: dt-binding: abx80x: fix resistance scale

Bjorn Andersson (1):
      clk: qcom: gcc-msm8998: Disable halt check of UFS clocks

Breno Leitao (2):
      selftests/powerpc: Allocate base registers
      selftests/powerpc: Skip test instead of failing

Brian Foster (1):
      xfs: add missing error check in xfs_prepare_shift()

Brian Masney (1):
      pinctrl: qcom: ssbi-gpio: fix gpio-hog related boot issues

Brian Norris (1):
      usb: dwc3: don't log probe deferrals; but do log other error codes

Bruce Allan (1):
      ice: Fix possible NULL pointer de-reference

Chao Yu (1):
      f2fs: fix to account preflush command for noflush_merge mode

Chen-Yu Tsai (1):
      clk: sunxi-ng: h3/h5: Fix CSI_MCLK parent

Christian Lamparter (2):
      dmaengine: dw-dmac: implement dma protection control setting
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (2):
      rtc: max77686: Fix the returned value in case of error in 'max77686_r=
tc_read_time()'
      rtc: max8997: Fix the returned value in case of error in 'max8997_rtc=
_read_alarm()'

Chuhong Yuan (3):
      serial: ifx6x60: add missed pm_runtime_disable
      rsxx: add missed destroy_workqueue calls in remove
      net: ep93xx_eth: fix mismatch of request_mem_region in remove

Cl=C3=A9ment P=C3=A9ron (1):
      ARM: debug: enable UART1 for socfpga Cyclone5

Colin Ian King (2):
      net: qualcomm: rmnet: move null check on dev before dereferecing it
      altera-stapl: check for a null key before strcasecmp'ing it

Dan Carpenter (2):
      drm/i810: Prevent underflow in ioctl
      md/raid0: Fix an error message in raid0_make_request()

Daniel Mack (1):
      ARM: dts: pxa: clean up USB controller nodes

Darrick J. Wong (2):
      splice: don't read more than available pipe space
      iomap: partially revert 4721a601099 (simulated directio short read on=
 EFAULT)

Dave Chinner (5):
      xfs: extent shifting doesn't fully invalidate page cache
      iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
      iomap: sub-block dio needs to zeroout beyond EOF
      iomap: dio data corruption and spurious errors when pipes fill
      iomap: readpages doesn't zero page tail beyond EOF

Dave Ertman (1):
      ice: Fix return value from NAPI poll

David Miller (2):
      sparc: Fix JIT fused branch convergance.
      sparc: Correct ctx->saw_frame_pointer logic.

David Teigland (2):
      dlm: fix missing idr_destroy for recover_idr
      dlm: fix invalid cluster name warning

Denis V. Lunev (1):
      dlm: fix possible call to kfree() for non-initialized pointer

Dmitry Bogdanov (1):
      net: aquantia: fix RSS table and key sizes

Dmitry Safonov (1):
      tty: Don't block on IO when ldisc change is pending

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Douglas Anderson (1):
      serial: core: Allow processing sysrq at port unlock time

Erez Alfasi (1):
      net/mlx4_core: Fix return codes of unsupported operations

Eric Dumazet (1):
      tcp: make tcp_space() aware of socket backlog

Eugeniy Paltsev (1):
      ARC: IOC: panic if kernel was started with previously enabled IOC

Felix Brack (1):
      ARM: dts: am335x-pdu001: Fix polarity of card detection input

Finley Xiao (1):
      clk: rockchip: fix rk3188 sclk_smc gate data

Florian Westphal (1):
      netfilter: nf_tables: don't use position attribute on rule replacement

Geert Uytterhoeven (5):
      soc: renesas: r8a77970-sysc: Correct names of A2DP/A2CN power domains
      soc: renesas: r8a77980-sysc: Correct names of A2DP[01] power domains
      soc: renesas: r8a77980-sysc: Correct A3VIP[012] power domain hierarchy
      clk: renesas: r8a77995: Correct parent clock of DU
      soc: renesas: r8a77990-sysc: Fix initialization order of 3DG-{A,B}

Greg Kroah-Hartman (1):
      Linux 4.19.89

Gregory CLEMENT (1):
      spi: atmel: Fix CS high support

Hangbin Liu (1):
      net/ipv6: re-do dad when interface has IFF_NOARP flag change

Hans Verkuil (4):
      media: pulse8-cec: return 0 when invalidating the logical address
      media: cec: report Vendor ID after initialization
      Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus
      Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Hans de Goede (1):
      Input: goodix - add upside-down quirk for Teclast X89 tablet

Heiko Stuebner (1):
      clk: rockchip: fix rk3188 sclk_mac_lbtest parameter ordering

Helen Fornazier (1):
      media: vimc: fix start stream when link is disabled

Hui Wang (1):
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpts: correct debug for expired txq skb

J. Bruce Fields (1):
      lockd: fix decoding of TEST results

Jagan Teki (1):
      clk: sunxi-ng: a64: Fix gate bit of DSI DPHY

Jakub Audykowicz (1):
      sctp: frag_point sanity check

James Hughes (1):
      firmware: raspberrypi: Fix firmware calls with large buffers

Jan Kara (3):
      audit: Embed key into chunk
      jbd2: Fix possible overflow in jbd2_log_space_left()
      iomap: Fix pipe page leakage during splicing

Jann Horn (2):
      binder: Fix race between mmap() and binder_alloc_print_pages()
      binder: Handle start=3D=3DNULL in binder_update_page_range()

Janne Huttunen (1):
      mm/vmstat.c: fix NUMA statistics updates

Jeffrey Hugo (2):
      tty: serial: msm_serial: Fix flow control
      clk: qcom: Fix MSM8998 resets

Ji-Ze Hong (Peter Hong) (1):
      USB: serial: f81534: fix reading old/new IC config

Jia-Ju Bai (1):
      dmaengine: coh901318: Fix a double-lock bug

Jian-Hong Pan (1):
      ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops

Joel Stanley (2):
      powerpc/math-emu: Update macros from GCC
      watchdog: aspeed: Fix clock behaviour for ast2600

Joerg Roedel (2):
      iommu/amd: Fix line-break in error log reporting
      x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

Johan Hovold (2):
      drm/msm: fix memleak on release
      can: ucan: fix non-atomic allocation in completion handler

Johannes Berg (1):
      iwlwifi: mvm: synchronize TID queue removal

John Keeping (1):
      ARM: dts: rockchip: Fix rk3288-rock2 vcc_flash name

Jon Hunter (1):
      arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Jonathan Marek (1):
      firmware: qcom: scm: fix compilation error when disabled

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Kai-Heng Feng (2):
      ALSA: hda - Add mute led support for HP ProBook 645 G4
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Kaike Wan (1):
      IB/hfi1: Ignore LNI errors before DC8051 transitions to Polling state

Kailang Yang (1):
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Katsuhiro Suzuki (2):
      clk: rockchip: fix I2S1 clock gate register for rk3328
      clk: rockchip: fix ID of 8ch clock of I2S1 for rk3328

Kees Cook (1):
      pstore/ram: Avoid NULL deref in ftrace merging failure path

Keith Busch (1):
      nvme: Free ctrl device name on init failure

Kieran Bingham (1):
      media: uvcvideo: Abstract streaming object lifetime

Kuninori Morimoto (2):
      ASoC: rsnd: tidyup registering method for rsnd_kctrl_new()
      ASoC: rsnd: fixup MIX kctrl registration

Ladislav Michl (1):
      ASoC: max9867: Fix power management

Laurent Pinchart (1):
      ARM: dts: r8a779[01]: Disable unconnected LVDS encoders

Lev Faerman (1):
      ice: Fix NVM mask defines

Lubomir Rintel (1):
      ARM: dts: mmp2: fix the gpio interrupt cell number

Luca Coelho (1):
      iwlwifi: fix cfg structs for 22000 with different RF modules

Lucas Stach (3):
      ARM: dts: imx6: RDU2: fix eGalax touchscreen node
      i2c: imx: don't print error message on probe defer
      Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Maciej W. Rozycki (1):
      MIPS: SiByte: Enable ZONE_DMA32 for LittleSur

Magnus Damm (1):
      ravb: Clean up duplex handling

Marek Szyprowski (4):
      extcon: max8997: Fix lack of path setting in USB device mode
      rtc: s3c-rtc: Avoid using broken ALMYEAR register
      ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module
      arm64: dts: exynos: Revert "Remove unneeded address space mapping for=
 soc node"

Mark Brown (1):
      regulator: Fix return value of _set_load() stub

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Martin Blumenstingl (1):
      clk: meson: meson8b: fix the offset of vid_pll_dco's N value

Martin Schiller (2):
      net/x25: fix called/calling length calculation in x25_parse_address_b=
lock
      net/x25: fix null_x25_address handling

Masahiro Yamada (1):
      kbuild: fix single target build for external module

Maxime Jourdan (1):
      drivers: soc: Allow building the amlogic drivers without ARCH_MESON

Maxime Ripard (6):
      ARM: dts: sun4i: Fix gpio-keys warning
      ARM: dts: sun4i: Fix HDMI output DTC warning
      ARM: dts: sun5i: a10s: Fix HDMI output DTC warning
      ARM: dts: sun7i: Fix HDMI output DTC warning
      ARM: dts: sun8i: a23/a33: Fix OPP DTC warnings
      ARM: dts: sun8i: v3s: Change pinctrl nodes to avoid warning

Michal Simek (1):
      arm64: dts: zynqmp: Fix node names which contain "_"

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Mike Leach (1):
      coresight: etm4x: Fix input validation for sysfs.

Mike Marciniszyn (1):
      IB/hfi1: Close VNIC sdma_progress sleep window

Miklos Szeredi (2):
      fuse: verify nlink
      fuse: verify attributes

Miquel Raynal (1):
      mtd: fix mtd_oobavail() incoherent returned value

Mitch Williams (1):
      i40e: don't restart nway if autoneg not supported

Moni Shoua (1):
      net/mlx5: Release resource on error flow

Mordechay Goodstein (1):
      iwlwifi: pcie: don't consider IV len in A-MSDU

Navid Emamdoost (4):
      rsi: release skb if rsi_prepare_beacon fails
      Input: Fix memory leak in psxpad_spi_probe
      crypto: user - fix memory leak in crypto_report
      net: qrtr: fix memort leak in qrtr_tun_write_iter

Neil Armstrong (6):
      clk: meson: Fix GXL HDMI PLL fractional bits width
      arm64: dts: meson-gxl-libretech-cc: fix GPIO lines names
      arm64: dts: meson-gxbb-nanopi-k2: fix GPIO lines names
      arm64: dts: meson-gxbb-odroidc2: fix GPIO lines names
      arm64: dts: meson-gxl-khadas-vim: fix GPIO lines names
      media: cxd2880-spi: fix probe when dvb_attach fails

Nicolas Dichtel (4):
      xfrm interface: fix memory leak on creation
      xfrm interface: avoid corruption on changelink
      xfrm interface: fix list corruption for x-netns
      xfrm interface: fix management of phydev

Nicolas Pitre (1):
      vcs: prevent write access to vcsu devices

Niklas S=C3=B6derlund (2):
      dma-mapping: fix return type of dma_set_max_seg_size()
      clk: renesas: rcar-gen3: Set state when registering SD clocks

Nir Dotan (1):
      mlxsw: spectrum_router: Relax GRE decap matching check

Nylon Chen (1):
      nds32: Fix the items of hwcap_str ordering issue.

Otavio Salvador (2):
      ARM: dts: rockchip: Fix the PMU interrupt number for rv1108
      ARM: dts: rockchip: Assign the proper GPIO clocks for rv1108

Pan Bian (1):
      Input: cyttsp4_core - fix use after free bug

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019=
-19332)

Paul Kocialkowski (1):
      ARM: dts: sun8i: h3: Fix the system-control register range

Paul Walmsley (1):
      modpost: skip ELF local symbols during section mismatch check

Pavel Shilovsky (2):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
      CIFS: Fix SMB2 oplock break processing

Peng Fan (1):
      tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Peter Zijlstra (1):
      sched/core: Avoid spurious lock dependencies

Philipp Zabel (1):
      media: coda: fix memory corruption in case more than 32 instances are=
 opened

Qian Cai (1):
      mlx4: Use snprintf instead of complicated strcpy

Raveendra Padasalagi (1):
      crypto: bcm - fix normal/non key hash algorithm failure

Rob Herring (4):
      kbuild: disable dtc simple_bus_reg warnings by default
      ARM: dts: realview-pbx: Fix duplicate regulator nodes
      ARM: dts: realview: Fix some more duplicate regulator nodes
      ARM: dts: sunxi: Fix PMU compatible strings

Ryan Case (1):
      tty: serial: qcom_geni_serial: Fix softlock

Sahitya Tummala (1):
      f2fs: fix to allow node segment for GC by ioctl path

Scott Mayhew (1):
      nfsd: fix a warning in __cld_pipe_upcall()

Sean Christopherson (1):
      KVM: x86: Grab KVM's srcu lock when setting nested state

Shahar S Matityahu (1):
      iwlwifi: trans: Clear persistence bit when starting the FW

Sharvari Harisangam (1):
      mwifiex: update set_mac_address logic

Shreeya Patel (1):
      Staging: iio: adt7316: Fix i2c data reading, set the data field

Sirong Wang (1):
      RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Srinivas Kandagatla (1):
      slimbus: ngd: Fix build error on x86

Stefan Agner (1):
      serial: imx: fix error handling in console_setup

Steffen Maier (2):
      scsi: zfcp: update kernel message for invalid FCP_CMND length, it's n=
ot the CDB
      scsi: zfcp: drop default switch case which might paper over missing c=
ase

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication er=
ror

Stephen Boyd (2):
      clk: mediatek: Drop __init from mtk_clk_register_cpumuxes()
      clk: mediatek: Drop more __init markings for driver probe

Steve Wise (1):
      iw_cxgb4: only reconnect with MPAv1 if the peer aborts

Takashi Iwai (2):
      ALSA: pcm: oss: Avoid potential buffer overflows
      ALSA: hda - Fix pending unsol events at shutdown

Takeshi Kihara (1):
      clk: renesas: r8a77990: Correct parent clock of DU

Tejun Heo (1):
      kernfs: fix ino wrap-around detection

Thierry Reding (1):
      gpu: host1x: Fix syncpoint ID field size on Tegra186

Thinh Nguyen (1):
      usb: dwc3: debugfs: Properly print/set link state for HS

Tony Lindgren (1):
      bus: ti-sysc: Fix getting optional clocks in clock_roles

Tudor Ambarus (1):
      crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Tuowen Zhao (1):
      sparc64: implement ioremap_uc

Ursula Braun (1):
      net/smc: use after free fix in smc_wr_tx_put_slot()

Vincent Chen (1):
      math-emu/soft-fp.h: (_FP_ROUND_ZERO) cast 0 to void to fix warning

Vincent Whitchurch (2):
      serial: pl011: Fix DMA ->flush_buffer()
      ARM: 8813/1: Make aligned 2-byte getuser()/putuser() atomic on ARMv6+

Vinod Koul (1):
      dmaengine: coh901318: Remove unused variable

Viresh Kumar (1):
      RDMA/qib: Validate ->show()/store() callbacks before calling them

Vitaly Chikunov (1):
      crypto: ecc - check for invalid values in the key verification test

Vitaly Kuznetsov (1):
      selftests: kvm: fix build with glibc >=3D 2.30

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Wen Yang (2):
      i2c: core: fix use after free in of_i2c_notify
      dlm: NULL check before kmem_cache_destroy is not needed

Xiaodong Xu (1):
      xfrm: release device reference for invalid state

Xin Long (2):
      sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit
      sctp: increase sk_wmem_alloc when head->truesize is increased

Xue Chaojing (2):
      net-next/hinic:fix a bug in set mac address
      net-next/hinic: fix a bug in rx data flow

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/per=
iod ratio precision

Yonghong Song (4):
      bpf: btf: implement btf_name_valid_identifier()
      bpf: btf: check name validity for various types
      tools: bpftool: fix a bitfield pretty print issue
      tools/bpf: make libbpf _GNU_SOURCE friendly

Young_X (1):
      ASoC: au8540: use 64-bit arithmetic instead of 32-bit

Yuchung Cheng (3):
      tcp: fix off-by-one bug on aborting window-probing socket
      tcp: fix SNMP under-estimation on failed retransmission
      tcp: fix SNMP TCP timeout under-estimation

YueHaibing (4):
      can: xilinx: fix return type of ndo_start_xmit function
      usb: mtu3: fix dbginfo in qmu_tx_zlp_error_handler
      appletalk: Fix potential NULL pointer dereference in unregister_snap_=
client
      appletalk: Set error code if register_snap_client failed

Yunhao Tian (1):
      drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.

Yunlong Song (2):
      f2fs: fix count of seg_freed to make sec_freed correct
      f2fs: change segment to section in f2fs_ioc_gc_range

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Don't rely on the wrong pending table

paulhsia (1):
      ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

zhengbin (1):
      nfsd: Return EPERM, not EACCES, in some SETATTR cases


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3zuOIACgkQONu9yGCS
aT4BTg/+OysU8m0ZK6y4EHYcll7oI03bIE8uOmLisUMY/9IrEjPi09w8YPSehVQR
mubu5nWOo6yBziEAwaBwq2IwePRnPgqKJNVLp67MRwckMGbvY2pq6BfLruM5Sznd
p9M85wQa9pB2N2QnojVBidKDIM4A+OSTVth+0KvbrSaUhmfwFqqT7Yt04L2IfjQg
AEcFoxM8THMgo3iKy2atDamikZvFOA57zqmfiM2e4oLmSG78jUUQvcCTkF2Z87f9
XwKhnBCHtpEv5J1j4PArrdXKVPp8bjGAFBnamPHRBWAjoDqmx6eH3nK/PsnTZSvO
35vWwji6PW3F0TIC7wU6Z/GSfvE5Ymj9NePOdSj/cOieGADIhnvO7tv0MrDWFd/t
+TH8HAMjLxQyYzAso2AyomeKYj/iFnEjOxY3WXLHfDh8159VVredpnRL6CSm8l0o
Hrweb+BRG/e0dlyWHqTCN2uouyLO5jPXvKsVWNF+iW4it31qudkisZfrlK8/y6Vb
I4bpgjM2PKtNMZEIIzua2xcXGMcckfPnWueW5vCjZ8Z5fIO0BsEfLLvrZmcZE1AK
o7pbLQnHqn6MTkBDnZbutDShS9bA/Ltc7lgu+6h5rPq6i4k9PQ/4Ohu+UlQ1uON3
g67JwKAhKzFS9w2J1icFXnRFvKl1nbocZKW/BEZZa9inkkKCGgk=
=7VAh
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
