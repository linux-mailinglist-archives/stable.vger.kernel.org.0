Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9481A414783
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbhIVLPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235585AbhIVLOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD536120E;
        Wed, 22 Sep 2021 11:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309198;
        bh=TfjrntZDlrJ9bWosNH8JkjCYiPXEGhV63miTSICADiI=;
        h=From:To:Cc:Subject:Date:From;
        b=igTvF/Gj5rMUwNFhF9KzJBrUC1CXCPICQt0hjCvNjd8svFT5HFIGgmAeWGgHHeiBM
         8/6wz+0QtHKoV2EvRrAtpmsI7T+oy62bewIpyHfHH+mQedzHu4riJ+eANynlPr3eik
         qy9eH9kubsa/odbpHA8PBP+T7K4NXKhFApUQgC/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.207
Date:   Wed, 22 Sep 2021 13:12:56 +0200
Message-Id: <1632309176251100@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.207 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/devices.txt                      |    6 
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt        |    2 
 Makefile                                                   |    2 
 arch/arc/mm/cache.c                                        |    2 
 arch/arm/boot/compressed/Makefile                          |    2 
 arch/arm/boot/dts/imx53-ppd.dts                            |   23 
 arch/arm/boot/dts/qcom-apq8064.dtsi                        |    6 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                    |   14 
 arch/arm/kernel/Makefile                                   |    6 
 arch/arm/kernel/return_address.c                           |    4 
 arch/arm/mach-imx/mmdc.c                                   |   14 
 arch/arm/net/bpf_jit_32.c                                  |    3 
 arch/arm64/boot/dts/exynos/exynos7.dtsi                    |    2 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                  |    2 
 arch/arm64/include/asm/kernel-pgtable.h                    |    4 
 arch/arm64/kernel/fpsimd.c                                 |    2 
 arch/arm64/kernel/head.S                                   |   11 
 arch/arm64/net/bpf_jit_comp.c                              |   13 
 arch/m68k/emu/nfeth.c                                      |    4 
 arch/mips/mti-malta/malta-dtshim.c                         |    2 
 arch/mips/net/ebpf_jit.c                                   |    3 
 arch/openrisc/kernel/entry.S                               |    2 
 arch/parisc/kernel/signal.c                                |    6 
 arch/powerpc/boot/crt0.S                                   |    3 
 arch/powerpc/kernel/module_64.c                            |    2 
 arch/powerpc/kernel/stacktrace.c                           |    1 
 arch/powerpc/net/bpf_jit_comp64.c                          |    6 
 arch/powerpc/perf/hv-gpci.c                                |    2 
 arch/s390/kernel/jump_label.c                              |    2 
 arch/s390/kvm/interrupt.c                                  |    4 
 arch/s390/kvm/kvm-s390.h                                   |    2 
 arch/s390/net/bpf_jit_comp.c                               |   14 
 arch/sparc/net/bpf_jit_comp_64.c                           |    3 
 arch/x86/events/amd/ibs.c                                  |    8 
 arch/x86/events/intel/pt.c                                 |    2 
 arch/x86/kernel/cpu/intel_rdt_monitor.c                    |    6 
 arch/x86/kernel/reboot.c                                   |    3 
 arch/x86/kvm/x86.c                                         |    4 
 arch/x86/mm/init_64.c                                      |    6 
 arch/x86/net/bpf_jit_comp.c                                |    7 
 arch/x86/net/bpf_jit_comp32.c                              |    6 
 arch/x86/xen/enlighten_pv.c                                |    7 
 arch/x86/xen/p2m.c                                         |    4 
 arch/xtensa/Kconfig                                        |    2 
 arch/xtensa/platforms/iss/console.c                        |   17 
 block/bfq-iosched.c                                        |   18 
 block/blk-zoned.c                                          |    6 
 certs/Makefile                                             |    8 
 drivers/ata/libata-core.c                                  |    6 
 drivers/ata/sata_dwc_460ex.c                               |   12 
 drivers/base/power/trace.c                                 |   10 
 drivers/base/regmap/regmap.c                               |    2 
 drivers/bcma/main.c                                        |    6 
 drivers/block/Kconfig                                      |    4 
 drivers/block/cryptoloop.c                                 |    2 
 drivers/clk/clk.c                                          |   10 
 drivers/clk/mvebu/kirkwood.c                               |    1 
 drivers/clocksource/sh_cmt.c                               |   30 
 drivers/cpufreq/powernv-cpufreq.c                          |   16 
 drivers/crypto/mxs-dcp.c                                   |   81 +-
 drivers/crypto/omap-sham.c                                 |    2 
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       |    4 
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         |    4 
 drivers/crypto/qat/qat_common/adf_common_drv.h             |    8 
 drivers/crypto/qat/qat_common/adf_init.c                   |    5 
 drivers/crypto/qat/qat_common/adf_isr.c                    |    7 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c              |    3 
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c              |   12 
 drivers/crypto/qat/qat_common/adf_vf_isr.c                 |    7 
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c |    4 
 drivers/crypto/talitos.c                                   |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c                    |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                 |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   16 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c                 |   10 
 drivers/gpu/drm/msm/dsi/dsi.c                              |    6 
 drivers/gpu/ipu-v3/ipu-cpmem.c                             |   30 
 drivers/hid/hid-input.c                                    |    2 
 drivers/i2c/busses/i2c-highlander.c                        |    2 
 drivers/i2c/busses/i2c-iop3xx.c                            |    6 
 drivers/i2c/busses/i2c-mt65xx.c                            |    2 
 drivers/i2c/busses/i2c-s3c2410.c                           |    2 
 drivers/iio/dac/ad5624r_spi.c                              |   18 
 drivers/infiniband/core/iwcm.c                             |   19 
 drivers/md/bcache/super.c                                  |   16 
 drivers/md/dm-crypt.c                                      |    7 
 drivers/md/dm-thin-metadata.c                              |    2 
 drivers/md/persistent-data/dm-block-manager.c              |   14 
 drivers/media/dvb-frontends/dib8000.c                      |   58 +
 drivers/media/i2c/imx258.c                                 |    4 
 drivers/media/i2c/tda1997x.c                               |    6 
 drivers/media/platform/qcom/venus/venc.c                   |    2 
 drivers/media/platform/tegra-cec/tegra_cec.c               |   10 
 drivers/media/rc/rc-loopback.c                             |    2 
 drivers/media/usb/dvb-usb/nova-t-usb2.c                    |    6 
 drivers/media/usb/dvb-usb/vp702x.c                         |   12 
 drivers/media/usb/em28xx/em28xx-input.c                    |    1 
 drivers/media/usb/go7007/go7007-driver.c                   |   26 
 drivers/media/usb/stkwebcam/stk-webcam.c                   |    6 
 drivers/media/usb/uvc/uvc_v4l2.c                           |   34 
 drivers/media/v4l2-core/v4l2-dv-timings.c                  |    4 
 drivers/mfd/ab8500-core.c                                  |    2 
 drivers/mfd/axp20x.c                                       |    3 
 drivers/mfd/stmpe.c                                        |    4 
 drivers/mfd/tc3589x.c                                      |    2 
 drivers/mfd/wm8994-irq.c                                   |    2 
 drivers/misc/aspeed-lpc-ctrl.c                             |    2 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                    |    6 
 drivers/mmc/core/block.c                                   |    3 
 drivers/mmc/host/dw_mmc.c                                  |    1 
 drivers/mmc/host/moxart-mmc.c                              |    1 
 drivers/mmc/host/rtsx_pci_sdmmc.c                          |   36 
 drivers/mmc/host/sdhci-of-arasan.c                         |   18 
 drivers/mtd/nand/raw/cafe_nand.c                           |    4 
 drivers/net/bonding/bond_main.c                            |    3 
 drivers/net/dsa/b53/b53_common.c                           |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c          |    2 
 drivers/net/ethernet/cadence/macb_ptp.c                    |   11 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                  |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            |    9 
 drivers/net/ethernet/ibm/ibmvnic.c                         |    8 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |    5 
 drivers/net/ethernet/qlogic/qed/qed_main.c                 |    7 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                  |    6 
 drivers/net/ethernet/qlogic/qede/qede_main.c               |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c           |    1 
 drivers/net/ethernet/qualcomm/qca_spi.c                    |    2 
 drivers/net/ethernet/qualcomm/qca_uart.c                   |    2 
 drivers/net/ethernet/rdc/r6040.c                           |    9 
 drivers/net/ethernet/renesas/sh_eth.c                      |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c        |   18 
 drivers/net/ethernet/wiznet/w5100.c                        |    2 
 drivers/net/ethernet/xilinx/ll_temac_main.c                |    4 
 drivers/net/phy/dp83640_reg.h                              |    2 
 drivers/net/usb/cdc_mbim.c                                 |    5 
 drivers/net/wireless/ath/ath6kl/wmi.c                      |    4 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c             |    3 
 drivers/net/wireless/ath/ath9k/hw.c                        |   12 
 drivers/ntb/test/ntb_perf.c                                |    1 
 drivers/nvme/host/rdma.c                                   |    4 
 drivers/of/kobj.c                                          |    2 
 drivers/parport/ieee1284_ops.c                             |    2 
 drivers/pci/controller/pci-aardvark.c                      |   11 
 drivers/pci/controller/pcie-xilinx-nwl.c                   |   12 
 drivers/pci/msi.c                                          |    3 
 drivers/pci/pci.c                                          |   33 
 drivers/pci/quirks.c                                       |   26 
 drivers/pci/syscall.c                                      |    4 
 drivers/pinctrl/pinctrl-single.c                           |    1 
 drivers/pinctrl/samsung/pinctrl-samsung.c                  |    2 
 drivers/platform/chrome/cros_ec_proto.c                    |    9 
 drivers/platform/x86/dell-smbios-wmi.c                     |    1 
 drivers/power/supply/axp288_fuel_gauge.c                   |    4 
 drivers/power/supply/max17042_battery.c                    |    8 
 drivers/rtc/rtc-tps65910.c                                 |    2 
 drivers/s390/cio/css.c                                     |   17 
 drivers/scsi/BusLogic.c                                    |    4 
 drivers/scsi/qedi/qedi_main.c                              |   14 
 drivers/scsi/qla2xxx/qla_nvme.c                            |    5 
 drivers/soc/qcom/smsm.c                                    |   11 
 drivers/soc/rockchip/Kconfig                               |    4 
 drivers/spi/spi-fsl-dspi.c                                 |    1 
 drivers/spi/spi-pic32.c                                    |    1 
 drivers/spi/spi-sprd-adi.c                                 |    2 
 drivers/staging/board/board.c                              |    7 
 drivers/staging/ks7010/ks7010_sdio.c                       |    2 
 drivers/staging/rts5208/rtsx_scsi.c                        |   10 
 drivers/tty/hvc/hvsi.c                                     |   19 
 drivers/tty/serial/8250/8250_pci.c                         |    2 
 drivers/tty/serial/8250/8250_port.c                        |    3 
 drivers/tty/serial/fsl_lpuart.c                            |    2 
 drivers/tty/serial/jsm/jsm_neo.c                           |    2 
 drivers/tty/serial/jsm/jsm_tty.c                           |    3 
 drivers/tty/serial/sh-sci.c                                |    7 
 drivers/tty/tty_io.c                                       |    4 
 drivers/usb/gadget/composite.c                             |    8 
 drivers/usb/gadget/function/u_ether.c                      |    5 
 drivers/usb/gadget/udc/at91_udc.c                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_core.c                      |    3 
 drivers/usb/gadget/udc/mv_u3d_core.c                       |   19 
 drivers/usb/host/ehci-orion.c                              |    8 
 drivers/usb/host/fotg210-hcd.c                             |   41 -
 drivers/usb/host/fotg210.h                                 |    5 
 drivers/usb/host/ohci-tmio.c                               |    3 
 drivers/usb/host/xhci-rcar.c                               |    7 
 drivers/usb/host/xhci.c                                    |   24 
 drivers/usb/mtu3/mtu3_gadget.c                             |    6 
 drivers/usb/musb/musb_dsps.c                               |   13 
 drivers/usb/phy/phy-fsl-usb.c                              |    2 
 drivers/usb/phy/phy-tahvo.c                                |    4 
 drivers/usb/phy/phy-twl6030-usb.c                          |    5 
 drivers/usb/serial/mos7720.c                               |    4 
 drivers/usb/usbip/vhci_hcd.c                               |   32 
 drivers/vfio/Kconfig                                       |    2 
 drivers/video/backlight/pwm_bl.c                           |   54 -
 drivers/video/fbdev/asiliantfb.c                           |    3 
 drivers/video/fbdev/core/fbmem.c                           |    6 
 drivers/video/fbdev/kyro/fbdev.c                           |    8 
 drivers/video/fbdev/riva/fbdev.c                           |    3 
 fs/btrfs/inode.c                                           |    2 
 fs/btrfs/volumes.c                                         |    3 
 fs/cifs/cifs_unicode.c                                     |    9 
 fs/cifs/sess.c                                             |    2 
 fs/crypto/hooks.c                                          |   44 +
 fs/ext4/inline.c                                           |    6 
 fs/ext4/symlink.c                                          |   11 
 fs/f2fs/file.c                                             |    4 
 fs/f2fs/gc.c                                               |    4 
 fs/f2fs/namei.c                                            |   11 
 fs/fcntl.c                                                 |    5 
 fs/fscache/cookie.c                                        |   14 
 fs/fscache/internal.h                                      |    2 
 fs/fscache/main.c                                          |   39 +
 fs/gfs2/lock_dlm.c                                         |    5 
 fs/isofs/inode.c                                           |   27 
 fs/isofs/isofs.h                                           |    1 
 fs/isofs/joliet.c                                          |    4 
 fs/nfs/callback_xdr.c                                      |    2 
 fs/overlayfs/dir.c                                         |    6 
 fs/ubifs/file.c                                            |   12 
 fs/udf/misc.c                                              |   13 
 fs/udf/super.c                                             |   25 
 fs/userfaultfd.c                                           |   93 +-
 include/crypto/public_key.h                                |    4 
 include/linux/bpf_verifier.h                               |   19 
 include/linux/filter.h                                     |   15 
 include/linux/fscrypt_notsupp.h                            |    6 
 include/linux/fscrypt_supp.h                               |    1 
 include/linux/hugetlb.h                                    |    9 
 include/linux/list.h                                       |   29 
 include/linux/memory_hotplug.h                             |    4 
 include/linux/pci.h                                        |    5 
 include/linux/power/max17042_battery.h                     |    2 
 include/linux/skbuff.h                                     |    2 
 include/linux/sunrpc/svc.h                                 |    2 
 include/uapi/linux/pkt_sched.h                             |    2 
 include/uapi/linux/serial_reg.h                            |    1 
 kernel/bpf/core.c                                          |   18 
 kernel/bpf/disasm.c                                        |   16 
 kernel/bpf/verifier.c                                      |  498 ++++++-------
 kernel/events/core.c                                       |    2 
 kernel/fork.c                                              |    1 
 kernel/locking/mutex.c                                     |   15 
 kernel/pid_namespace.c                                     |    3 
 kernel/sched/deadline.c                                    |    8 
 kernel/sched/sched.h                                       |    2 
 kernel/time/hrtimer.c                                      |   60 +
 lib/mpi/mpiutil.c                                          |    2 
 lib/test_bpf.c                                             |   13 
 mm/memory_hotplug.c                                        |    4 
 mm/page_alloc.c                                            |    8 
 net/9p/trans_xen.c                                         |    4 
 net/bluetooth/cmtp/cmtp.h                                  |    2 
 net/bluetooth/hci_core.c                                   |   14 
 net/bluetooth/hci_event.c                                  |  108 ++
 net/bluetooth/sco.c                                        |   85 +-
 net/caif/chnl_net.c                                        |   19 
 net/core/flow_dissector.c                                  |   12 
 net/core/net_namespace.c                                   |   18 
 net/dccp/minisocks.c                                       |    2 
 net/dsa/slave.c                                            |   12 
 net/ipv4/icmp.c                                            |   23 
 net/ipv4/igmp.c                                            |    2 
 net/ipv4/ip_gre.c                                          |    9 
 net/ipv4/ip_output.c                                       |    5 
 net/ipv4/route.c                                           |   48 -
 net/ipv4/tcp_fastopen.c                                    |    3 
 net/ipv4/tcp_input.c                                       |    2 
 net/ipv4/tcp_ipv4.c                                        |    5 
 net/ipv6/netfilter/nf_socket_ipv6.c                        |    4 
 net/l2tp/l2tp_core.c                                       |    4 
 net/mac80211/tx.c                                          |    4 
 net/netlabel/netlabel_cipso_v4.c                           |   12 
 net/netlink/af_netlink.c                                   |    4 
 net/sched/sch_cbq.c                                        |    2 
 net/sched/sch_fq_codel.c                                   |   12 
 net/sunrpc/auth_gss/svcauth_gss.c                          |    2 
 net/sunrpc/svc.c                                           |   27 
 net/tipc/socket.c                                          |   36 
 net/unix/af_unix.c                                         |    2 
 samples/bpf/test_override_return.sh                        |    1 
 samples/bpf/tracex7_user.c                                 |    5 
 security/integrity/ima/Kconfig                             |    1 
 security/integrity/ima/ima_mok.c                           |    2 
 security/smack/smack_access.c                              |   17 
 sound/core/pcm_lib.c                                       |    2 
 sound/soc/intel/boards/bytcr_rt5640.c                      |    9 
 sound/soc/rockchip/rockchip_i2s.c                          |   35 
 sound/usb/quirks.c                                         |    1 
 tools/perf/util/machine.c                                  |    1 
 tools/testing/selftests/bpf/test_maps.c                    |    2 
 tools/testing/selftests/bpf/test_verifier.c                |  144 +++
 tools/thermal/tmon/Makefile                                |    2 
 virt/kvm/arm/arm.c                                         |    8 
 294 files changed, 2188 insertions(+), 1184 deletions(-)

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Alexei Starovoitov (2):
      bpf: track spill/fill of constants
      selftests/bpf: fix tests due to const spill/fill

Andreas Obergschwandtner (1):
      ARM: tegra: tamonten: Fix UART pad setting

Andrey Grodzovsky (1):
      drm/amdgpu: Fix BUG_ON assert

Andrey Ignatov (5):
      bpf: Support variable offset stack access from helpers
      bpf: Reject indirect var_off stack access in raw mode
      bpf: Reject indirect var_off stack access in unpriv mode
      bpf: Sanity check max value for var_off stack access
      selftests/bpf: Test variable offset stack access

Andy Duan (1):
      tty: serial: fsl_lpuart: fix the wrong mapbase value

Andy Shevchenko (3):
      include/linux/list.h: add a macro to test if entry is pointing to the head
      ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()
      PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Anirudh Rayabharam (1):
      usbip: give back URBs for unsent unlink requests during cleanup

Anson Jacob (1):
      drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

Arne Welzel (1):
      dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Austin Kim (1):
      IMA: remove -Wmissing-prototypes warning

Babu Moger (1):
      x86/resctrl: Fix a maybe-uninitialized build warning treated as error

Baptiste Lepers (1):
      events: Reuse value read using READ_ONCE instead of re-reading it

Ben Dooks (1):
      ARM: 8918/2: only build return_address() if needed

Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Bob Peterson (1):
      gfs2: Don't call dlm after protocol is unmounted

Chao Yu (2):
      f2fs: fix to account missing .skipped_gc_rwsem
      f2fs: fix to unmap pages from userspace process in punch_hole()

Chih-Kang Chang (1):
      mac80211: Fix insufficient headroom issue for AMSDU

Christoph Hellwig (2):
      cryptoloop: add a deprecation warning
      bcache: add proper error unwinding in bcache_device_init

Christophe JAILLET (4):
      drm/msm/dsi: Fix some reference counted resource leaks
      usb: bdc: Fix an error handling path in 'bdc_probe()' when no suitable DMA config is available
      staging: ks7010: Fix the initialization of the 'sleep_status' structure
      mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Christophe Leroy (1):
      crypto: talitos - reduce max key size for SEC1

Chunfeng Yun (2):
      usb: mtu3: use @mult for HS isoc or intr
      usb: mtu3: fix the wrong HS mult value

Chunyan Zhang (1):
      spi: sprd: Fix the wrong WDG_LOAD_VAL

Colin Ian King (4):
      ARM: imx: fix missing 3rd argument in macro imx_mmdc_perf_init
      media: venus: venc: Fix potential null pointer dereference on pointer fmt
      Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow
      parport: remove non-zero check on count

Damien Le Moal (2):
      libata: fix ata_host_start()
      block: bfq: fix bfq_set_next_ioprio_data()

Dan Carpenter (4):
      Bluetooth: sco: prevent information leak in sco_conn_defer_accept()
      ath6kl: wmi: fix an error code in ath6kl_wmi_sync_point()
      scsi: qedi: Fix error codes in qedi_alloc_global_queues()
      PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Daniel Borkmann (3):
      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
      bpf: Fix leakage due to insufficient speculative store bypass mitigation
      bpf: Fix pointer arithmetic mask tightening under state pruning

Daniel Thompson (1):
      backlight: pwm_bl: Improve bootloader/kernel device handover

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

David Heidelberg (2):
      ARM: 9105/1: atags_to_fdt: don't warn about stack size
      ARM: dts: qcom: apq8064: correct clock names

David Hildenbrand (1):
      mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

David Howells (1):
      fscache: Fix cookie key hashing

Desmond Cheong Zhi Xi (6):
      fcntl: fix potential deadlock for &fasync_struct.fa_lock
      Bluetooth: fix repeated calls to sco_sock_kill
      btrfs: reset replace target device to allocation state on close
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: avoid circular locks in sco_sock_connect

Dietmar Eggemann (1):
      sched/deadline: Fix missing clock update in migrate_task_rq_dl()

Ding Hui (1):
      cifs: fix wrong release in sess_alloc_buffer() failed path

Dinghao Liu (1):
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Dmitry Baryshkov (1):
      drm/msm/dpu: make dpu_hw_ctl_clear_all_blendstages clear necessary LMs

Dmitry Osipenko (1):
      rtc: tps65910: Correct driver module alias

Dmitry Torokhov (1):
      HID: input: do not report stylus battery state as "full"

Dongliang Mu (3):
      media: dvb-usb: fix uninit-value in dvb_usb_adapter_dvb_init
      media: dvb-usb: fix uninit-value in vp702x_read_mac_addr
      media: em28xx-input: fix refcount bug in em28xx_usb_disconnect

Edward Cree (1):
      bpf/verifier: per-register parent pointers

Eric Biggers (4):
      fscrypt: add fscrypt_symlink_getattr() for computing st_size
      ext4: report correct st_size for encrypted symlinks
      f2fs: report correct st_size for encrypted symlinks
      ubifs: report correct st_size for encrypted symlinks

Eric Dumazet (5):
      ipv4: make exception cache less predictible
      ipv4: fix endianness issue in inet_rtm_getroute_build_skb()
      net-caif: avoid user-triggerable WARN_ON(1)
      net/af_unix: fix a data-race in unix_dgram_poll
      fq_codel: reject silly quantum parameters

Esben Haabendal (1):
      net: ll_temac: Remove left-over debug message

Evan Quan (1):
      PCI: Add AMD GPU multi-function power dependencies

Evgeny Novikov (2):
      usb: ehci-orion: Handle errors of clk_prepare_enable() in probe
      media: tegra-cec: Handle errors of clk_prepare_enable()

Fangrui Song (1):
      powerpc/boot: Delete unneeded .globl _zimage_start

Florian Fainelli (1):
      r6040: Restore MDIO clock frequency after MAC reset

Geert Uytterhoeven (2):
      soc: rockchip: ROCKCHIP_GRF should not default to y, unconditionally
      staging: board: Fix uninitialized spinlock when attaching genpd

George Cherian (1):
      PCI: Add ACS quirks for Cavium multi-function devices

Giovanni Cabiddu (4):
      crypto: qat - do not ignore errors from enable_vf2pf_comms()
      crypto: qat - handle both source of interrupt in VF ISR
      crypto: qat - do not export adf_iov_putmsg()
      crypto: qat - use proper type for vf_mask

Greg Kroah-Hartman (3):
      clk: fix build warning for orphan_list
      serial: 8250_pci: make setup_port() parameters explicitly unsigned
      Linux 4.19.207

Guillaume Nault (1):
      netns: protect netns ID lookups with RCU

Gustavo A. R. Silva (2):
      ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
      flow_dissector: Fix out-of-bounds warnings

Halil Pasic (1):
      KVM: s390: index kvm->arch.idle_mask by vcpu_idx

Hans Verkuil (1):
      media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Hans de Goede (5):
      power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
      libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
      platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
      ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output
      mfd: axp20x: Update AXP288 volatile ranges

Harini Katakam (1):
      net: macb: Add a NULL check on desc_ptp

Harshvardhan Jha (1):
      9p/xen: Fix end of loop tests for list_for_each_entry

Heiko Carstens (1):
      s390/jump_label: print real address in a case of a jump label bug

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Hongbo Li (1):
      lib/mpi: use kcalloc in mpi_resize

Hyun Kwon (1):
      PCI: xilinx-nwl: Enable the clock through CCF

Ilya Leoshkevich (1):
      s390/bpf: Fix 64-bit subtraction of the -0x80000000 constant

Iwona Winiarska (1):
      soc: aspeed: lpc-ctrl: Fix boundary check for mmap

J. Bruce Fields (1):
      rpc: fix gss_svc_init cleanup on failure

Jack Pham (1):
      usb: gadget: composite: Allow bMaxPower=0 if self-powered

Jaehyoung Choi (1):
      pinctrl: samsung: Fix pinctrl bank pin count

Jan Kara (1):
      udf: Check LVID earlier

Jason Gunthorpe (1):
      vfio: Use config not menuconfig for VFIO_NOIOMMU

Jeongtae Park (1):
      regmap: fix the offset of register error log

Jiong Wang (1):
      bpf: correct slot_type marking logic to allow more stack slot sharing

Jiri Slaby (2):
      xtensa: ISS: don't panic in rs_init
      hvsi: don't panic on tty_register_driver failure

Johan Almbladh (2):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result

Jonathan Cameron (1):
      iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Juergen Gross (3):
      xen: fix setting of max_pfn in shared_info
      xen: reset legacy rtc flag for PV domU
      PM: base: power: don't try to use non-existing RTC for storing data

Juhee Kang (1):
      samples: bpf: Fix tracex7 error raised on the missing argument

Kai-Heng Feng (1):
      Bluetooth: Move shutdown callback before flushing tx and rx queue

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix counter value parsing

Kees Cook (1):
      staging: rts5208: Fix get_ms_information() heap buffer size

Kelly Devilliv (2):
      usb: host: fotg210: fix the endpoint's transactional opportunities calculation
      usb: host: fotg210: fix the actual_length of an iso packet

Kim Phillips (1):
      perf/x86/amd/ibs: Work around erratum #1197

Krzysztof Hałasa (3):
      gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats
      media: TDA1997x: enable EDID support
      media: TDA1997x: fix tda1997x_query_dv_timings() return value

Krzysztof Kozlowski (2):
      arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7
      power: supply: max17042: handle fails of reading status register

Krzysztof Wilczyński (1):
      PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Laurent Pinchart (1):
      media: imx258: Rectify mismatch of VTS value

Len Baker (1):
      CIFS: Fix a potencially linear read overflow

Leon Romanovsky (2):
      RDMA/iwcm: Release resources if iw_cm module initialization fails
      docs: Fix infiniband uverbs minor number

Li Zhijian (1):
      selftests/bpf: Enlarge select() timeout for test_maps

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Linus Walleij (1):
      clk: kirkwood: Fix a clocking boot regression

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Liu Zixian (1):
      mm/hugetlb: initialize hugetlb_usage in mm_init

Lorenz Bauer (1):
      bpf: verifier: Allocate idmap scratch in verifier env

Luiz Augusto von Dentz (1):
      Bluetooth: Fix handling of LE Enhanced Connection Complete

Luke Hsiao (1):
      tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Maciej W. Rozycki (2):
      serial: 8250: Define RX trigger levels for OxSemi 950 devices
      scsi: BusLogic: Fix missing pr_cont() use

Maciej Żenczykowski (1):
      usb: gadget: u_ether: fix a potential null pointer dereference

Manish Narani (1):
      mmc: sdhci-of-arasan: Check return value of non-void funtions

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Marc Zyngier (2):
      of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS
      mfd: Don't use irq_create_mapping() to resolve a mapping

Marco Chiappero (2):
      crypto: qat - fix reuse of completion variable
      crypto: qat - fix naming for init/shutdown VF to PF notifications

Marek Behún (2):
      PCI: Call Max Payload Size-related fixup quirks early
      PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

Marek Marczykowski-Górecki (1):
      PCI/MSI: Skip masking MSI-X on Xen PV

Mark Brown (1):
      arm64/sve: Use correct size when reinitialising SVE state

Mark Rutland (1):
      arm64: head: avoid over-mapping in map_memory

Martin KaFai Lau (1):
      tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos

Mathias Nyman (1):
      Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Mathieu Desnoyers (1):
      ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Mauro Carvalho Chehab (2):
      media: uvc: don't do DMA on stack
      media: dib8000: rewrite the init prbs logic

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Michael Ellerman (1):
      powerpc/module64: Fix comment in R_PPC64_ENTRY handling

Michael Petlan (1):
      perf machine: Initialize srcline string member in add_location struct

Michal Suchanek (1):
      powerpc/stacktrace: Include linux/delay.h

Mike Rapoport (1):
      x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Mikulas Patocka (1):
      parisc: fix crash with signals and alloca

Miquel Raynal (1):
      dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Muchun Song (1):
      mm/page_alloc: speed up the iteration of max_order

Nadav Amit (1):
      userfaultfd: prevent concurrent API initialization

Nadezda Lutovinova (2):
      usb: gadget: mv_u3d: request_irq() after initializing UDC
      usb: musb: musb_dsps: request_irq() after initializing musb

Nathan Chancellor (1):
      net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()

Nguyen Dinh Phi (1):
      tty: Fix data race between tiocsti() and flush_to_ldisc()

Niklas Cassel (2):
      blk-zoned: allow zone management send operations without CAP_SYS_ADMIN
      blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Nishad Kamdar (1):
      mmc: core: Return correct emmc response in case of ioctl error

Oleksij Rempel (1):
      MIPS: Malta: fix alignment of the devicetree buffer

Oliver Upton (1):
      KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Pali Rohár (3):
      isofs: joliet: Fix iocharset=utf8 mount option
      PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response
      PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Paolo Valente (1):
      block, bfq: honor already-setup queue merges

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Send command again when timeout occurs

Paul Gortmaker (1):
      x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Pavel Skripkin (5):
      media: stkwebcam: fix memory leak in stk_camera_probe
      m68k: emu: Fix invalid free in nfeth_cleanup()
      media: go7007: remove redundant initialization
      net: cipso: fix warnings in netlbl_cipsov4_add_std
      Bluetooth: add timeout sanity check to hci_inquiry

Peter Zijlstra (1):
      locking/mutex: Fix HANDOFF condition

Phong Hoang (1):
      clocksource/drivers/sh_cmt: Fix wrong setting if don't request IRQ for clock source channel

Pratik R. Sampat (1):
      cpufreq: powernv: Fix init_chip_info initialization in numa=off

Qu Wenruo (1):
      Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Quentin Perret (1):
      sched/deadline: Fix reset_on_fork reporting of DL tasks

Rafael J. Wysocki (3):
      PCI: PM: Avoid forcing PCI_D0 for wakeup reasons inconsistently
      PCI: PM: Enable PME if it can be signaled from D3cold
      PCI: Use pci_update_current_state() in pci_enable_device_flags()

Rafał Miłecki (1):
      net: dsa: b53: Fix calculating number of switch ports

Randy Dunlap (4):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG
      openrisc: don't printk() unconditionally
      ptp: dp83640: don't define PAGE0
      ARC: export clear_user_page() for modules

Rolf Eike Beer (1):
      tools/thermal/tmon: Add cross compiling support

Ruozhu Li (1):
      nvme-rdma: don't update queue count when failing to set io queues

Saurav Kashyap (1):
      scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Sean Anderson (2):
      crypto: mxs-dcp - Check for DMA mapping errors
      crypto: mxs-dcp - Use sg_mapping_iter to copy data

Sean Young (1):
      media: rc-loopback: return number of emitters rather than error

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: fix typo in MAx17042_TOFF

Sebastian Reichel (1):
      ARM: dts: imx53-ppd: Fix ACHC entry

Sergey Shtylyov (9):
      i2c: highlander: add IRQ check
      usb: gadget: udc: at91: add IRQ check
      usb: phy: fsl-usb: add IRQ check
      usb: phy: twl6030: add IRQ checks
      usb: host: ohci-tmio: add IRQ check
      usb: phy: tahvo: add IRQ check
      i2c: iop3xx: fix deferred probing
      i2c: s3c2410: fix IRQ check
      i2c: mt65xx: fix IRQ check

Shai Malin (3):
      qed: Fix the VF msix vectors flow
      qede: Fix memset corruption
      qed: Handle management FW error

Shuah Khan (1):
      usbip:vhci_hcd USB port can get stuck in the disabled state

Stefan Berger (1):
      certs: Trigger creation of RSA module signing key if it's not an RSA key

Stefan Wahren (1):
      net: qualcomm: fix QCA7000 checksum handling

Stephan Gerhold (1):
      soc: qcom: smsm: Fix missed interrupts if state changes while masked

Stian Skjelstad (1):
      udf_get_extendedattr() had no boundary checks.

Sugar Zhang (1):
      ASoC: rockchip: i2s: Fix regmap_ops hang

Sukadev Bhattiprolu (1):
      ibmvnic: check failover_pending in login response

THOBY Simon (1):
      IMA: remove the dependency on CRYPTO_MD5

Tetsuo Handa (1):
      fbmem: don't allow too huge resolutions

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Thomas Gleixner (1):
      hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()

Thomas Hebb (1):
      mmc: rtsx_pci: Fix long reads when clock is prescaled

Tianjia Zhang (1):
      Smack: Fix wrong semantics in smk_access_entry()

Tom Rix (1):
      USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Tony Lindgren (5):
      crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
      spi: spi-fsl-dspi: Fix issue with uninitialized dma_slave_config
      spi: spi-pic32: Fix issue with uninitialized dma_slave_config
      mmc: dw_mmc: Fix issue with uninitialized dma_slave_config
      mmc: moxart: Fix issue with uninitialized dma_slave_config

Trond Myklebust (1):
      SUNRPC/nfs: Fix return value for nfs4_callback_compound()

Tuo Li (1):
      gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()

Ulrich Hecht (1):
      serial: sh-sci: fix break handling for sysrq

Umang Jain (1):
      media: imx258: Limit the max analogue gain to 480

Vasily Averin (1):
      memcg: enable accounting for pids in nested pid namespaces

Vineeth Vijayan (1):
      s390/cio: add dev_busid sysfs entry for each subchannel

Vinod Koul (1):
      arm64: dts: qcom: sdm660: use reg value for memory node

Vladimir Oltean (1):
      net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Wang Hai (1):
      VMCI: fix NULL pointer dereference when unmapping queue pair

Willem de Bruijn (1):
      ip_gre: validate csum_start only on pull

Xiaotan Luo (1):
      ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Xiaoyao Li (1):
      perf/x86/intel/pt: Fix mask of num_address_ranges

Xin Long (2):
      tipc: keep the skb in rcv queue until the whole data is read
      tipc: fix an use-after-free issue in tipc_recvmsg

Xiyu Yang (2):
      net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yajun Deng (1):
      netlink: Deal with ESRCH error in nlmsg_notify()

Yang Li (2):
      ethtool: Fix an error code in cxgb2.c
      NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Yingliang (2):
      ARM: imx: add missing clk_disable_unprepare()
      net: w5100: check return value after calling platform_get_resource()

Ye Bin (1):
      dm thin metadata: Fix use-after-free in dm_bm_set_read_only

Yoshihiro Shimoda (2):
      usb: host: xhci-rcar: Don't reload firmware after the completion
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Yufeng Mo (2):
      bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
      net: hns3: pad the short tunnel frame before sending to hardware

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zelin Deng (1):
      KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted

Zenghui Yu (1):
      bcma: Fix memory leak for internally-handled cores

Zhen Lei (1):
      pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()

Zheyu Ma (5):
      video: fbdev: kyro: fix a DoS bug by restricting user input
      tty: serial: jsm: hold port lock when reporting modem line changes
      video: fbdev: asiliantfb: Error out if 'pixclock' equals zero
      video: fbdev: kyro: Error out if 'pixclock' equals zero
      video: fbdev: riva: Error out if 'pixclock' equals zero

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

chenying (1):
      ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

zhenwei pi (1):
      crypto: public_key: fix overflow during implicit conversion

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

