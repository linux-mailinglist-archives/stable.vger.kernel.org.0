Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4B5A0D04
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbiHYJsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiHYJrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167AEAB4D5;
        Thu, 25 Aug 2022 02:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF8560A14;
        Thu, 25 Aug 2022 09:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A44C433D6;
        Thu, 25 Aug 2022 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420854;
        bh=B7f7gs/bo0R4Qih8QH8UMioeEQcyx6BWPwW2PYnYZoU=;
        h=From:To:Cc:Subject:Date:From;
        b=T76dcRWAfTR1CsIkp1GnPKHbUPP8xK94UdWH4R+Lgf4jbSYoqQ9f/zyN8Yw4CPAVI
         62ybsLofhwOjUBKixiUTFHEWfVIoavmYbKTREKxaXYGIBa7kBisR71oYlDMYnuuxHD
         K6LULVlGoECXrAg5xHRSEXMk0Q0V/zoo2xRmD82A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.256
Date:   Thu, 25 Aug 2022 11:47:16 +0200
Message-Id: <16614208377027@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.256 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/atomic_bitops.txt                     |    2 
 Makefile                                            |    5 
 arch/arm/boot/dts/aspeed-ast2500-evb.dts            |    2 
 arch/arm/boot/dts/imx6ul.dtsi                       |   29 +--
 arch/arm/boot/dts/qcom-pm8841.dtsi                  |    1 
 arch/arm/lib/findbit.S                              |   16 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                    |    1 
 arch/arm/mach-omap2/display.c                       |    1 
 arch/arm/mach-omap2/prm3xxx.c                       |    1 
 arch/arm/mach-zynq/common.c                         |    1 
 arch/arm64/boot/dts/qcom/ipq8074.dtsi               |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi               |    4 
 arch/arm64/include/asm/processor.h                  |    3 
 arch/arm64/kernel/armv8_deprecated.c                |    9 -
 arch/ia64/include/asm/processor.h                   |    2 
 arch/mips/cavium-octeon/octeon-platform.c           |    3 
 arch/mips/kernel/proc.c                             |    2 
 arch/mips/mm/tlbex.c                                |    4 
 arch/nios2/include/asm/entry.h                      |    3 
 arch/nios2/include/asm/ptrace.h                     |    2 
 arch/nios2/kernel/entry.S                           |   22 +-
 arch/nios2/kernel/signal.c                          |    3 
 arch/nios2/kernel/syscall_table.c                   |    1 
 arch/parisc/kernel/drivers.c                        |    9 -
 arch/powerpc/kernel/pci-common.c                    |   45 ++++-
 arch/powerpc/kernel/prom.c                          |    7 
 arch/powerpc/mm/Makefile                            |    7 
 arch/powerpc/mm/dump_linuxpagetables-8xx.c          |   82 ++++++++++
 arch/powerpc/mm/dump_linuxpagetables-book3s64.c     |  115 ++++++++++++++
 arch/powerpc/mm/dump_linuxpagetables-generic.c      |   82 ++++++++++
 arch/powerpc/mm/dump_linuxpagetables.c              |  155 --------------------
 arch/powerpc/mm/dump_linuxpagetables.h              |   19 ++
 arch/powerpc/platforms/Kconfig.cputype              |    4 
 arch/powerpc/platforms/cell/axon_msi.c              |    1 
 arch/powerpc/platforms/cell/spufs/inode.c           |    1 
 arch/powerpc/platforms/powernv/rng.c                |    2 
 arch/powerpc/sysdev/fsl_pci.c                       |    8 +
 arch/powerpc/sysdev/fsl_pci.h                       |    1 
 arch/powerpc/sysdev/xive/spapr.c                    |    1 
 arch/riscv/kernel/sys_riscv.c                       |    5 
 arch/riscv/kernel/traps.c                           |    4 
 arch/x86/boot/Makefile                              |    2 
 arch/x86/boot/compressed/Makefile                   |    4 
 arch/x86/entry/vdso/Makefile                        |    2 
 arch/x86/kernel/pmem.c                              |    7 
 arch/x86/kvm/emulate.c                              |   23 +-
 arch/x86/kvm/hyperv.c                               |    3 
 arch/x86/kvm/lapic.c                                |    4 
 arch/x86/kvm/svm.c                                  |    2 
 arch/x86/mm/numa.c                                  |    4 
 arch/x86/platform/olpc/olpc-xo1-sci.c               |    2 
 drivers/acpi/acpi_lpss.c                            |    3 
 drivers/acpi/cppc_acpi.c                            |   54 +++---
 drivers/acpi/ec.c                                   |    7 
 drivers/acpi/property.c                             |    8 -
 drivers/acpi/sleep.c                                |    8 +
 drivers/ata/libata-eh.c                             |    1 
 drivers/atm/idt77252.c                              |    1 
 drivers/block/null_blk_main.c                       |   14 +
 drivers/bluetooth/hci_intel.c                       |    6 
 drivers/bus/hisi_lpc.c                              |   10 -
 drivers/clk/qcom/gcc-ipq8074.c                      |   19 ++
 drivers/clk/renesas/r9a06g032-clocks.c              |    8 -
 drivers/crypto/hisilicon/sec/sec_algs.c             |   14 -
 drivers/crypto/hisilicon/sec/sec_drv.h              |    2 
 drivers/dma/sprd-dma.c                              |    5 
 drivers/firmware/arm_scpi.c                         |   61 ++++---
 drivers/fpga/altera-pr-ip-core.c                    |    2 
 drivers/gpio/gpiolib-of.c                           |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c          |    4 
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c        |   17 +-
 drivers/gpu/drm/bridge/sil-sii8620.c                |    4 
 drivers/gpu/drm/mediatek/mtk_dpi.c                  |   31 ----
 drivers/gpu/drm/mediatek/mtk_dsi.c                  |    2 
 drivers/gpu/drm/meson/meson_drv.c                   |    5 
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c           |    3 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c     |    2 
 drivers/gpu/drm/radeon/ni_dpm.c                     |    6 
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c         |    3 
 drivers/gpu/drm/vc4/vc4_dsi.c                       |    6 
 drivers/hid/hid-alps.c                              |    2 
 drivers/hid/hid-cp2112.c                            |    5 
 drivers/hid/wacom_sys.c                             |    2 
 drivers/hid/wacom_wac.c                             |   43 +++--
 drivers/hwtracing/intel_th/pci.c                    |   15 +
 drivers/i2c/busses/i2c-cadence.c                    |   10 +
 drivers/i2c/i2c-core-base.c                         |    3 
 drivers/i2c/muxes/i2c-mux-gpmux.c                   |    1 
 drivers/iio/light/isl29028.c                        |    2 
 drivers/infiniband/hw/hfi1/file_ops.c               |    4 
 drivers/infiniband/sw/rxe/rxe_qp.c                  |   12 +
 drivers/iommu/exynos-iommu.c                        |    6 
 drivers/iommu/qcom_iommu.c                          |    7 
 drivers/irqchip/irq-tegra.c                         |   10 -
 drivers/md/dm-raid.c                                |    4 
 drivers/md/dm-writecache.c                          |    2 
 drivers/md/dm.c                                     |    5 
 drivers/md/raid10.c                                 |    5 
 drivers/md/raid5.c                                  |    2 
 drivers/media/pci/tw686x/tw686x-core.c              |   18 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h        |    2 
 drivers/media/usb/hdpvr/hdpvr-video.c               |    2 
 drivers/memstick/core/ms_block.c                    |   11 -
 drivers/mfd/t7l66xb.c                               |    6 
 drivers/misc/cardreader/rtsx_pcr.c                  |    6 
 drivers/misc/cxl/irq.c                              |    1 
 drivers/mmc/host/cavium-octeon.c                    |    1 
 drivers/mmc/host/cavium-thunderx.c                  |    4 
 drivers/mmc/host/pxamci.c                           |    4 
 drivers/mmc/host/sdhci-of-at91.c                    |    9 -
 drivers/mmc/host/sdhci-of-esdhc.c                   |    1 
 drivers/mtd/devices/st_spi_fsm.c                    |    8 -
 drivers/mtd/maps/physmap_of_versatile.c             |    2 
 drivers/mtd/sm_ftl.c                                |    2 
 drivers/net/can/pch_can.c                           |    8 -
 drivers/net/can/rcar/rcar_can.c                     |    8 -
 drivers/net/can/sja1000/sja1000.c                   |    7 
 drivers/net/can/spi/hi311x.c                        |    5 
 drivers/net/can/sun4i_can.c                         |    9 -
 drivers/net/can/usb/ems_usb.c                       |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c   |   12 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c    |    6 
 drivers/net/can/usb/usb_8dev.c                      |    7 
 drivers/net/ethernet/freescale/fec_ptp.c            |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c         |    4 
 drivers/net/ethernet/intel/igb/igb.h                |    2 
 drivers/net/ethernet/intel/igb/igb_main.c           |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |    2 
 drivers/net/geneve.c                                |    3 
 drivers/net/netdevsim/bpf.c                         |    8 -
 drivers/net/usb/ax88179_178a.c                      |   16 +-
 drivers/net/usb/usbnet.c                            |    8 -
 drivers/net/wireless/ath/ath10k/snoc.c              |    5 
 drivers/net/wireless/ath/ath9k/htc.h                |   10 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c       |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c          |   18 --
 drivers/net/wireless/intel/iwlegacy/4965-rs.c       |    5 
 drivers/net/wireless/intersil/p54/main.c            |    2 
 drivers/net/wireless/intersil/p54/p54spi.c          |    3 
 drivers/net/wireless/mac80211_hwsim.c               |   14 +
 drivers/net/wireless/marvell/libertas/if_usb.c      |    1 
 drivers/net/wireless/mediatek/mt76/mac80211.c       |    1 
 drivers/net/wireless/realtek/rtlwifi/debug.c        |    8 -
 drivers/ntb/test/ntb_tool.c                         |    8 -
 drivers/pci/quirks.c                                |    3 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c           |    4 
 drivers/pinctrl/qcom/pinctrl-msm8916.c              |    4 
 drivers/platform/olpc/olpc-ec.c                     |    2 
 drivers/regulator/of_regulator.c                    |    6 
 drivers/remoteproc/qcom_wcnss.c                     |   10 +
 drivers/rpmsg/qcom_smd.c                            |    1 
 drivers/s390/char/zcore.c                           |   11 +
 drivers/s390/cio/vfio_ccw_drv.c                     |   14 -
 drivers/s390/scsi/zfcp_fc.c                         |   29 ++-
 drivers/s390/scsi/zfcp_fc.h                         |    6 
 drivers/s390/scsi/zfcp_fsf.c                        |    4 
 drivers/scsi/sg.c                                   |   57 ++++---
 drivers/scsi/smartpqi/smartpqi_init.c               |    4 
 drivers/soc/amlogic/meson-mx-socinfo.c              |    1 
 drivers/soc/fsl/guts.c                              |    2 
 drivers/soundwire/bus_type.c                        |    8 -
 drivers/staging/rtl8192u/r8192U.h                   |    2 
 drivers/staging/rtl8192u/r8192U_dm.c                |   38 ++--
 drivers/staging/rtl8192u/r8192U_dm.h                |    2 
 drivers/tee/tee_core.c                              |    4 
 drivers/thermal/thermal_sysfs.c                     |   10 -
 drivers/tty/n_gsm.c                                 |   90 ++++++++++-
 drivers/tty/serial/8250/8250_dw.c                   |    3 
 drivers/tty/serial/mvebu-uart.c                     |   11 +
 drivers/tty/serial/ucc_uart.c                       |    2 
 drivers/tty/vt/vt.c                                 |    2 
 drivers/usb/core/hcd.c                              |   26 +--
 drivers/usb/gadget/legacy/inode.c                   |    1 
 drivers/usb/gadget/udc/Kconfig                      |    2 
 drivers/usb/host/ehci-ppc-of.c                      |    1 
 drivers/usb/host/ohci-nxp.c                         |    1 
 drivers/usb/host/ohci-ppc-of.c                      |    1 
 drivers/usb/renesas_usbhs/rza.c                     |    4 
 drivers/usb/serial/sierra.c                         |    3 
 drivers/usb/serial/usb-serial.c                     |    2 
 drivers/usb/serial/usb_wwan.c                       |    3 
 drivers/vfio/vfio.c                                 |    1 
 drivers/video/fbdev/amba-clcd.c                     |   24 ++-
 drivers/video/fbdev/arkfb.c                         |    9 +
 drivers/video/fbdev/core/fbcon.c                    |    8 -
 drivers/video/fbdev/i740fb.c                        |    9 -
 drivers/video/fbdev/s3fb.c                          |    2 
 drivers/video/fbdev/sis/init.c                      |    4 
 drivers/video/fbdev/vt8623fb.c                      |    2 
 drivers/virt/vboxguest/vboxguest_linux.c            |    9 -
 drivers/xen/xenbus/xenbus_dev_frontend.c            |    4 
 fs/attr.c                                           |    2 
 fs/btrfs/disk-io.c                                  |   14 +
 fs/btrfs/raid56.c                                   |   74 +++++++--
 fs/btrfs/tree-log.c                                 |    4 
 fs/cifs/smb2ops.c                                   |    5 
 fs/ext2/super.c                                     |   12 +
 fs/ext4/inline.c                                    |    3 
 fs/ext4/inode.c                                     |   10 +
 fs/ext4/migrate.c                                   |    4 
 fs/ext4/namei.c                                     |   23 ++
 fs/ext4/resize.c                                    |   11 +
 fs/ext4/xattr.c                                     |    6 
 fs/ext4/xattr.h                                     |   13 +
 fs/f2fs/node.c                                      |    6 
 fs/fuse/inode.c                                     |    6 
 fs/jbd2/transaction.c                               |   14 +
 fs/namei.c                                          |    2 
 fs/nfs/nfs4idmap.c                                  |   46 +++--
 fs/nfs/nfs4proc.c                                   |   14 +
 fs/overlayfs/export.c                               |    2 
 fs/splice.c                                         |   10 -
 include/acpi/cppc_acpi.h                            |    2 
 include/asm-generic/bitops/atomic.h                 |    6 
 include/linux/buffer_head.h                         |   25 +++
 include/linux/kfifo.h                               |    2 
 include/linux/kvm_host.h                            |   28 +++
 include/linux/mfd/t7l66xb.h                         |    1 
 include/linux/nmi.h                                 |    2 
 include/linux/pci_ids.h                             |    2 
 include/linux/usb/hcd.h                             |    1 
 include/sound/core.h                                |    8 +
 include/trace/events/spmi.h                         |   12 -
 include/uapi/linux/can/error.h                      |    5 
 kernel/bpf/verifier.c                               |    1 
 kernel/kprobes.c                                    |    3 
 kernel/power/user.c                                 |   13 +
 kernel/profile.c                                    |    7 
 kernel/sched/rt.c                                   |   15 +
 kernel/trace/trace_events.c                         |    1 
 kernel/trace/trace_probe.c                          |    4 
 kernel/watchdog.c                                   |   21 ++
 lib/list_debug.c                                    |   12 +
 mm/mmap.c                                           |    1 
 net/9p/client.c                                     |    5 
 net/bluetooth/l2cap_core.c                          |   13 -
 net/dccp/proto.c                                    |   10 -
 net/ipv4/tcp_output.c                               |   30 ++-
 net/netfilter/nf_tables_api.c                       |    7 
 net/rds/ib_recv.c                                   |    1 
 net/rose/af_rose.c                                  |   11 +
 net/rose/rose_route.c                               |    2 
 net/sched/cls_route.c                               |   12 +
 net/sunrpc/backchannel_rqst.c                       |   14 +
 net/vmw_vsock/af_vsock.c                            |   10 +
 scripts/Makefile.gcc-plugins                        |    2 
 scripts/faddr2line                                  |    4 
 security/apparmor/apparmorfs.c                      |    2 
 security/apparmor/audit.c                           |    2 
 security/apparmor/domain.c                          |    2 
 security/apparmor/include/lib.h                     |    5 
 security/apparmor/include/policy.h                  |    2 
 security/apparmor/label.c                           |   13 -
 security/apparmor/mount.c                           |    8 -
 security/selinux/ss/policydb.h                      |    2 
 sound/core/info.c                                   |    6 
 sound/core/misc.c                                   |   94 ++++++++++++
 sound/core/timer.c                                  |   11 -
 sound/pci/hda/patch_cirrus.c                        |    1 
 sound/pci/hda/patch_conexant.c                      |   11 +
 sound/soc/codecs/da7210.c                           |    2 
 sound/soc/mediatek/mt6797/mt6797-mt6351.c           |    6 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c    |   10 -
 sound/soc/mediatek/mt8173/mt8173-rt5650.c           |    9 -
 sound/soc/qcom/qdsp6/q6adm.c                        |    2 
 sound/usb/bcd2000/bcd2000.c                         |    3 
 tools/build/feature/test-libcrypto.c                |   15 +
 tools/lib/bpf/libbpf.c                              |    9 -
 tools/perf/util/genelf.c                            |    6 
 tools/testing/selftests/timers/clocksource-switch.c |    6 
 tools/testing/selftests/timers/valid-adjtimex.c     |    2 
 tools/thermal/tmon/sysfs.c                          |   24 +--
 tools/thermal/tmon/tmon.h                           |    3 
 virt/kvm/kvm_main.c                                 |   10 -
 274 files changed, 1863 insertions(+), 873 deletions(-)

Al Viro (6):
      nios2: page fault et.al. are *not* restartable syscalls...
      nios2: don't leave NULLs in sys_call_table[]
      nios2: traced syscall does need to check the syscall number
      nios2: fix syscall restart checks
      nios2: restarts apply only to the first sigframe we build...
      nios2: add force_successful_syscall_return()

Alan Brady (1):
      i40e: Fix to stop tx_timeout recovery if GLOBR fails

Alexander Gordeev (1):
      s390/zcore: fix race when reading from hardware system area

Alexander Lobakin (2):
      ia64, processor: fix -Wincompatible-pointer-types in ia64_get_irr()
      x86/olpc: fix 'logical not is only applied to the left hand side'

Alexander Shishkin (3):
      intel_th: pci: Add Raptor Lake-S CPU support
      intel_th: pci: Add Raptor Lake-S PCH support
      intel_th: pci: Add Meteor Lake-P support

Alexander Stein (4):
      ARM: dts: imx6ul: add missing properties for sram
      ARM: dts: imx6ul: change operating-points to uint32-matrix
      ARM: dts: imx6ul: fix lcdif node compatible
      ARM: dts: imx6ul: fix qspi node compatible

Alexey Kodanev (2):
      drm/radeon: fix potential buffer overflow in ni_set_mc_special_registers()
      wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Allen Ballway (1):
      ALSA: hda/cirrus - support for iMac 12,1 model

Amadeusz Sławiński (1):
      ALSA: info: Fix llseek return value when using callback

Ammar Faizi (1):
      wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`

Andrew Donnellan (1):
      gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

AngeloGioacchino Del Regno (1):
      media: platform: mtk-mdp: Fix mdp_ipi_comm structure alignment

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Arnaldo Carvalho de Melo (1):
      genelf: Use HAVE_LIBCRYPTO_SUPPORT, not the never defined HAVE_LIBCRYPTO

Artem Borisov (1):
      HID: alps: Declare U1_UNICORN_LEGACY support

Baokun Li (4):
      ext4: add EXT4_INODE_HAS_XATTR_SPACE macro in xattr.h
      ext4: fix use-after-free in ext4_xattr_set_entry
      ext4: correct max_inline_xattr_value_size computing
      ext4: correct the misjudgment in ext4_iget_extra_inode

Bo-Chen Chen (1):
      drm/mediatek: dpi: Remove output format of YUV

Brian Norris (1):
      drm/rockchip: vop: Don't crash for invalid duplicate_state()

Celeste Liu (1):
      riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Chao Yu (1):
      f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()

Chen Zhongjin (2):
      profiling: fix shift too large makes kernel panic
      kprobes: Forbid probing on trampoline and BPF code areas

Christophe JAILLET (8):
      wifi: p54: Fix an error handling path in p54spi_probe()
      misc: rtsx: Fix an error handling path in rtsx_pci_probe()
      memstick/ms_block: Fix some incorrect memory allocation
      memstick/ms_block: Fix a memory leak
      ASoC: qcom: q6dsp: Fix an off-by-one in q6adm_alloc_copp()
      mmc: pxamci: Fix another error handling path in pxamci_probe()
      mmc: pxamci: Fix an error handling path in pxamci_probe()
      cxl: Fix a memory leak in an error handling path

Christophe Leroy (3):
      powerpc/32: Do not allow selection of e5500 or e6500 CPUs on PPC32
      powerpc/mm: Split dump_pagelinuxtables flag_array table
      powerpc/ptdump: Fix display of RW pages on FSL_BOOK3E

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Damien Le Moal (1):
      ata: libata-eh: Add missing command name

Dan Carpenter (7):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      platform/olpc: Fix uninitialized data in debugfs write
      null_blk: fix ida error handling in null_add_dev()
      kfifo: fix kfifo_to_user() return type
      NTB: ntb_tool: uninitialized heap data in tool_fn_write()
      xen/xenbus: fix return type in xenbus_file_read()

Daniel Starke (6):
      tty: n_gsm: fix non flow control frames during mux flow off
      tty: n_gsm: fix packet re-transmission without open control channel
      tty: n_gsm: fix race condition in gsmld_write()
      tty: n_gsm: fix wrong T1 retry count handling
      tty: n_gsm: fix DM command
      tty: n_gsm: fix missing corner cases in gsmld_poll()

Dave Stevenson (1):
      drm/vc4: dsi: Correct DSI divider calculations

David Collins (1):
      spmi: trace: fix stack-out-of-bound access in SPMI tracing functions

David Howells (1):
      vfs: Check the truncate maximum size in inode_newsize_ok()

Duoming Zhou (3):
      mtd: sm_ftl: Fix deadlock caused by cancel_work_sync in sm_release
      staging: rtl8192u: Fix sleep in atomic context bug in dm_fsync_timer_callback
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Eric Dumazet (2):
      net: rose: fix netdev reference changes
      tcp: fix over estimation in sk_forced_mem_schedule()

Eric Farman (1):
      vfio/ccw: Do not change FSM state in subchannel event

Eric Whitney (1):
      ext4: fix extent status tree race in writeback error recovery path

Eugen Hristev (1):
      mmc: sdhci-of-at91: fix set_uhs_signaling rewriting of MC1R

Filipe Manana (1):
      btrfs: fix lost error handling when looking up extended ref on log replay

Florian Fainelli (1):
      tools/thermal: Fix possible path truncations

Florian Westphal (1):
      netfilter: nf_tables: fix null deref due to zeroed list head

Francis Laniel (1):
      arm64: Do not forget syscall when starting a new thread.

Greg Kroah-Hartman (1):
      Linux 4.19.256

Guenter Roeck (1):
      lib/list_debug.c: Detect uninitialized lists

Hangyu Hua (3):
      drm: bridge: sii8620: fix possible off-by-one
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Hans de Goede (1):
      ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks

Harshit Mogalapalli (1):
      HID: cp2112: prevent a buffer overflow in cp2112_xfer()

Hector Martin (1):
      locking/atomic: Make test_and_*_bit() ordered on failure

Helge Deller (2):
      fbcon: Fix boundary checks for fbcon=vc:n1-n2 parameters
      parisc: Fix device names in /proc/iomem

Huacai Chen (1):
      MIPS: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK

Ilpo Järvinen (1):
      serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()

Jakub Kicinski (1):
      netdevsim: Avoid allocation warnings triggered from user space

Jamal Hadi Salim (1):
      net_sched: cls_route: disallow handle of 0

Jan Kara (1):
      ext2: Add more validity checks for inode counts

Jason A. Donenfeld (1):
      fs: check FMODE_LSEEK to control internal pipe splicing

Jens Wiklander (1):
      tee: add overflow check in register_shm_helper()

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jiachen Zhang (1):
      ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()

Jianglei Nie (1):
      RDMA/hfi1: fix potential memory leak in setup_base_ctxt()

Jiasheng Jiang (3):
      drm: bridge: adv7511: Add check for mipi_dsi_driver_register
      Bluetooth: hci_intel: Add check for platform_driver_register
      ASoC: codecs: da7210: add check for i2c_add_driver

Johan Hovold (2):
      x86/pmem: Fix platform-device leak in error path
      USB: serial: fix tty-port initialized comments

Johannes Berg (2):
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: mac80211_hwsim: use 32-bit skb cookie

John Johansen (4):
      apparmor: fix quiet_denied for file rules
      apparmor: fix absroot causing audited secids to begin with =
      apparmor: Fix failed mount permission check error message
      apparmor: fix overlapping attachment computation

Jose Alonso (1):
      Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"

Josh Poimboeuf (1):
      scripts/faddr2line: Fix vmlinux detection on arm64

Jozef Martiniak (1):
      gadgetfs: ep_io - wait until IRQ finishes

Kiselev, Oleg (1):
      ext4: avoid resizing to a partial cluster size

Krzysztof Kozlowski (3):
      ARM: dts: ast2500-evb: fix board compatible
      ARM: dts: qcom: pm8841: add required thermal-sensor-cells
      ath10k: do not enforce interrupt trigger type

Lars-Peter Clausen (1):
      i2c: cadence: Support PEC for SMBus block read

Laurent Dufour (1):
      watchdog: export lockup_detector_reconfigure

Leo Li (1):
      drm/amdgpu: Check BO's requested pinning domains against its preferred_domains

Li Lingfeng (1):
      ext4: recover csum seed of tmp_inode after migrating to extents

Liang He (14):
      ARM: OMAP2+: display: Fix refcount leak bug
      regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      i2c: mux-gpmux: Add of_node_put() when breaking out of loop
      gpio: gpiolib-of: Fix refcount bugs in of_mm_gpiochip_add_data()
      mmc: cavium-octeon: Add of_node_put() when breaking out of loop
      mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
      iommu/arm-smmu: qcom_iommu: Add of_node_put() when breaking out of loop
      video: fbdev: amba-clcd: Fix refcount leak bugs
      drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
      usb: host: ohci-ppc-of: Fix refcount leak bug
      usb: renesas: Fix refcount leak bug
      tty: serial: Fix refcount leak bug in ucc_uart.c
      mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Lin Ma (1):
      igb: Add lock to avoid data race

Luiz Augusto von Dentz (1):
      Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression

Lukas Czerner (1):
      ext4: make sure ext4_append() always allocates new block

Lukas Wunner (1):
      usbnet: Fix linkwatch use-after-free on disconnect

Maciej S. Szmigiero (1):
      KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0

Mahesh Rajashekhara (1):
      scsi: smartpqi: Fix DMA direction for RAID requests

Manyi Li (1):
      ACPI: PM: save NVS memory for Lenovo G40-45

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Marco Pagani (1):
      fpga: altera-pr-ip: fix unsigned comparison with less than zero

Markus Mayer (1):
      thermal/tools/tmon: Include pthread and time headers in tmon.h

Matthias May (1):
      geneve: do not use RT_TOS for IPv6 flowlabel

Maxim Mikityanskiy (1):
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS

Meng Tang (1):
      ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model

Miaohe Lin (1):
      mm/mmap.c: fix missing call to vm_unacct_memory in mmap_region

Miaoqian Lin (17):
      meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
      ARM: bcm: Fix refcount leak in bcm_kona_smc_init
      ARM: OMAP2+: Fix refcount leak in omap3xxx_prm_late_init
      cpufreq: zynq: Fix refcount leak in zynq_get_revision
      mtd: maps: Fix refcount leak in of_flash_probe_versatile
      mtd: maps: Fix refcount leak in ap_flash_init
      usb: host: Fix refcount leak in ehci_hcd_ppc_of_probe
      usb: ohci-nxp: Fix refcount leak in ohci_hcd_nxp_probe
      mmc: sdhci-of-esdhc: Fix refcount leak in esdhc_signal_voltage_switch
      ASoC: mediatek: mt8173: Fix refcount leak in mt8173_rt5650_rt5676_dev_probe
      ASoC: mt6797-mt6351: Fix refcount leak in mt6797_mt6351_dev_probe
      ASoC: mediatek: mt8173-rt5650: Fix refcount leak in mt8173_rt5650_dev_probe
      rpmsg: qcom_smd: Fix refcount leak in qcom_smd_parse_edge
      powerpc/spufs: Fix refcount leak in spufs_init_isolated_loader
      powerpc/xive: Fix refcount leak in xive_get_max_prio
      powerpc/cell/axon_msi: Fix refcount leak in setup_msi_msg_address
      pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map

Michael Ellerman (3):
      powerpc/powernv: Avoid crashing if rng is NULL
      powerpc/pci: Fix PHB numbering when using opal-phbid
      powerpc/pci: Fix get_phb_number() locking

Michael Walle (1):
      soc: fsl: guts: machine variable might be unset

Mike Snitzer (1):
      dm: return early from dm_pr_call() if DM device is suspended

Miklos Szeredi (1):
      fuse: limit nsec

Mikulas Patocka (6):
      add barriers to buffer_uptodate and set_buffer_uptodate
      md-raid10: fix KASAN warning
      dm raid: fix address sanitizer warning in raid_resume
      dm raid: fix address sanitizer warning in raid_status
      dm writecache: set a default MAX_WRITEBACK_JOBS
      rds: add missing barrier to release_refill

Narendra Hadke (1):
      serial: mvebu-uart: uart2 error bits clearing

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Nick Desaulniers (2):
      Makefile: link with -z noexecstack --no-warn-rwx-segments
      x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments

Nicolas Saenz Julienne (1):
      nohz/full, sched/rt: Fix missed tick-reenabling bug in dequeue_task_rt()

Niels Dossche (1):
      media: hdpvr: fix error value returns in hdpvr_read

Nikita Travkin (1):
      pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Ovidiu Panait (1):
      bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()

Pablo Neira Ayuso (1):
      netfilter: nf_tables: really skip inactive sets when allocating name

Pali Rohár (3):
      PCI: Add defines for normal and subtractive PCI bridges
      powerpc/fsl-pci: Fix Class Code of PCIe Root Port
      powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias

Pascal Terjan (1):
      vboxguest: Do not use devm for irq

Pavan Chebbi (1):
      PCI: Add ACS quirk for Broadcom BCM5750x NICs

Pavel Skripkin (1):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb

Peilin Ye (2):
      vsock: Fix memory leak in vsock_connect()
      vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Pierre-Louis Bossart (1):
      soundwire: bus_type: fix remove and shutdown support

Ping Cheng (1):
      HID: wacom: Don't register pad_input for touch switch

Qu Wenruo (3):
      btrfs: reject log replay if there is unsupported RO compat flag
      btrfs: only write the sectors in the vertical stripe which has data stripes
      btrfs: raid56: don't trust any cached sector in __raid56_parity_recover()

Rafael J. Wysocki (2):
      thermal: sysfs: Fix cooling_device_stats_setup() error code path
      ACPI: CPPC: Do not prevent CPPC from working in the future

Ralph Siemsen (1):
      clk: renesas: r9a06g032: Fix UART clkgrp bitsel

Randy Dunlap (1):
      usb: gadget: udc: amd5536 depends on HAS_DMA

Rob Clark (1):
      drm/msm/mdp5: Fix global state lock backoff

Robert Marko (4):
      arm64: dts: qcom: ipq8074: fix NAND node name
      clk: qcom: ipq8074: fix NSS port frequency tables
      clk: qcom: ipq8074: set BRANCH_HALT_DELAY flag for UBI clocks
      clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Roberto Sassu (1):
      tools build: Switch to new openssl API for test-libcrypto

Russell King (Oracle) (1):
      ARM: findbit: fix overflowing offset

Rustam Subkhankulov (2):
      wifi: p54: add missing parentheses in p54_flush()
      video: fbdev: sis: fix typos in SiS_GetModeID()

Sai Prakash Ranjan (1):
      irqchip/tegra: Fix overflow implicit truncation warnings

Sakari Ailus (1):
      ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Sam Protsenko (1):
      iommu/exynos: Handle failed IOMMU device registration properly

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Sean Christopherson (3):
      KVM: x86: Mark TSS busy during LTR emulation _after_ all fault checks
      KVM: x86: Set error code to segment selector on LLDT/LTR non-canonical #GP
      KVM: Add infrastructure and macro to mark VM as bugged

Siddh Raman Pant (1):
      x86/numa: Use cpumask_available instead of hardcoded NULL check

Sireesh Kodali (2):
      arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node
      remoteproc: qcom: wcnss: Fix handling of IRQs

Steffen Maier (1):
      scsi: zfcp: Fix missing auto port scan and thus missing target ports

Steve French (1):
      smb3: check xattr value length earlier

Steven Rostedt (Google) (2):
      tracing: Have filter accept "common_cpu" to be consistent
      tracing/probes: Have kprobes and uprobes use $COMM too

Sudeep Holla (1):
      firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails

Takashi Iwai (2):
      ALSA: core: Add async signal helpers
      ALSA: timer: Use deferred fasync helper

Tetsuo Handa (2):
      tty: vt: initialize unicode screen buffer
      PM: hibernate: defer device probing when resuming from hibernation

Thadeu Lima de Souza Cascardo (2):
      netfilter: nf_tables: do not allow SET_ID to refer to another table
      net_sched: cls_route: remove from list when handle is 0

Theodore Ts'o (1):
      ext4: update s_overhead_clusters in the superblock during an on-line resize

Timur Tabi (1):
      drm/nouveau: fix another off-by-one in nvbios_addr

Tom Rix (1):
      apparmor: fix aa_label_asxprint return check

Tony Battersby (1):
      scsi: sg: Allow waiting for commands to complete on removed device

Trond Myklebust (3):
      NFSv4: Fix races in the legacy idmapper upcall
      NFSv4/pnfs: Fix a use-after-free bug in open
      SUNRPC: Reinitialise the backchannel request buffers before reuse

Tyler Hicks (1):
      net/9p: Initialize the iounit field during fid creation

Uwe Kleine-König (3):
      mtd: st_spi_fsm: Add a clk_disable_unprepare() in .probe()'s error path
      mfd: t7l66xb: Drop platform disable callback
      dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Vincent Mailhol (10):
      can: pch_can: do not report txerr and rxerr during bus-off
      can: rcar_can: do not report txerr and rxerr during bus-off
      can: sja1000: do not report txerr and rxerr during bus-off
      can: hi311x: do not report txerr and rxerr during bus-off
      can: sun4i_can: do not report txerr and rxerr during bus-off
      can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
      can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
      can: usb_8dev: do not report txerr and rxerr during bus-off
      can: error: specify the values of data[5..7] of CAN error frames
      can: pch_can: pch_can_error(): initialize errc before using it

Vitaly Kuznetsov (2):
      KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
      KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()

Weitao Wang (1):
      USB: HCD: Fix URB giveback issue in tasklet function

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

Wolfram Sang (2):
      selftests: timers: valid-adjtimex: build fix for newer toolchains
      selftests: timers: clocksource-switch: fix passing errors from child

Xianting Tian (1):
      RISC-V: Add fast call path of crash_kexec()

Xin Xiong (1):
      apparmor: fix reference count leak in aa_pivotroot()

Xinlei Lee (1):
      drm/mediatek: Add pull-down MIPI operation in mtk_dsi_poweroff function

Xiu Jianfeng (2):
      selinux: Add boundary check in put_entry()
      apparmor: Fix memleak in aa_simple_write_to_buffer()

Xu Wang (1):
      i2c: Fix a potential use after free

Yang Xu (1):
      fs: Add missing umask strip in vfs_tmpfile

Yang Yingliang (1):
      bus: hisi_lpc: fix missing platform_device_put() in hisi_lpc_acpi_probe()

Ye Bin (1):
      ext4: avoid remove directory when directory is corrupted

Yonglong Li (1):
      tcp: make retransmitted SKB fit into the send window

Zhang Xianwei (1):
      NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Zhengchao Shao (1):
      crypto: hisilicon - Kunpeng916 crypto driver don't sleep when in softirq

Zheyu Ma (8):
      ALSA: bcd2000: Fix a UAF bug on the error path of probing
      iio: light: isl29028: Fix the warning in isl29028_remove()
      media: tw686x: Register the irq at the end of probe
      video: fbdev: arkfb: Fix a divide-by-zero bug in ark_set_pixclock()
      video: fbdev: vt8623fb: Check the size of screen before memset_io()
      video: fbdev: arkfb: Check the size of screen before memset_io()
      video: fbdev: s3fb: Check the size of screen before memset_io()
      video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhihao Cheng (1):
      jbd2: fix assertion 'jh->b_frozen_data == NULL' failure when journal aborted

Zhouyi Zhou (1):
      powerpc/64: Init jump labels before parse_early_param()

Zhu Yanjun (1):
      RDMA/rxe: Fix error unwind in rxe_create_qp()

haibinzhang (张海斌) (1):
      arm64: fix oops in concurrently setting insn_emulation sysctls

huhai (1):
      ACPI: LPSS: Fix missing check in register_device_clock()

