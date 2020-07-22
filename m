Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458492298A2
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732429AbgGVMx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732335AbgGVMx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:53:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 849DC20771;
        Wed, 22 Jul 2020 12:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422405;
        bh=T1VrypLnzSWJx7IRMHZpG0hVru5+3ygYdpFVwR2rqrg=;
        h=From:To:Cc:Subject:Date:From;
        b=yuCfk9HeKtwunlOjCmAEIeg4Pe7cJ5RpkdWMk7bVlOikaRsAa//MXBaeOuDhBCNBt
         baiIsnq0J6HMLV37mCKjIf9uR0MvqHHhFqCfb2fEY5MXQ9iMmTRbgWTNBrP4Prv30k
         D3SMXcgDBbWDx4MrJFglr8VOP9yzHayhVTHWmqy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.134
Date:   Wed, 22 Jul 2020 14:53:30 +0200
Message-Id: <1595422410171148@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.134 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/usb/dwc3.txt     |    2 
 Makefile                                           |    2 
 arch/alpha/defconfig                               |    1 
 arch/arm/boot/dts/socfpga.dtsi                     |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi             |    2 
 arch/arm/configs/rpc_defconfig                     |    1 
 arch/arm/configs/s3c2410_defconfig                 |    1 
 arch/arm/mach-at91/pm_suspend.S                    |    4 
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |    5 +
 arch/arm64/include/asm/alternative.h               |   16 +--
 arch/arm64/include/asm/debug-monitors.h            |    2 
 arch/arm64/include/asm/syscall.h                   |   12 ++
 arch/arm64/include/asm/thread_info.h               |    1 
 arch/arm64/kernel/alternative.c                    |   16 ---
 arch/arm64/kernel/debug-monitors.c                 |   20 +++-
 arch/arm64/kernel/ptrace.c                         |   29 ++++--
 arch/arm64/kernel/signal.c                         |   11 --
 arch/arm64/kernel/syscall.c                        |    5 -
 arch/arm64/kernel/vmlinux.lds.S                    |    3 
 arch/ia64/configs/zx1_defconfig                    |    1 
 arch/m68k/configs/amiga_defconfig                  |    1 
 arch/m68k/configs/apollo_defconfig                 |    1 
 arch/m68k/configs/atari_defconfig                  |    1 
 arch/m68k/configs/bvme6000_defconfig               |    1 
 arch/m68k/configs/hp300_defconfig                  |    1 
 arch/m68k/configs/mac_defconfig                    |    1 
 arch/m68k/configs/multi_defconfig                  |    1 
 arch/m68k/configs/mvme147_defconfig                |    1 
 arch/m68k/configs/mvme16x_defconfig                |    1 
 arch/m68k/configs/q40_defconfig                    |    1 
 arch/m68k/configs/sun3_defconfig                   |    1 
 arch/m68k/configs/sun3x_defconfig                  |    1 
 arch/m68k/kernel/setup_no.c                        |    3 
 arch/m68k/mm/mcfmmu.c                              |    2 
 arch/mips/configs/bigsur_defconfig                 |    1 
 arch/mips/configs/fuloong2e_defconfig              |    1 
 arch/mips/configs/ip27_defconfig                   |    1 
 arch/mips/configs/ip32_defconfig                   |    1 
 arch/mips/configs/jazz_defconfig                   |    1 
 arch/mips/configs/malta_defconfig                  |    1 
 arch/mips/configs/malta_kvm_defconfig              |    1 
 arch/mips/configs/malta_kvm_guest_defconfig        |    1 
 arch/mips/configs/maltaup_xpa_defconfig            |    1 
 arch/mips/configs/rm200_defconfig                  |    1 
 arch/mips/kernel/time.c                            |   13 --
 arch/powerpc/configs/85xx-hw.config                |    1 
 arch/powerpc/configs/amigaone_defconfig            |    1 
 arch/powerpc/configs/chrp32_defconfig              |    1 
 arch/powerpc/configs/g5_defconfig                  |    1 
 arch/powerpc/configs/maple_defconfig               |    1 
 arch/powerpc/configs/pasemi_defconfig              |    1 
 arch/powerpc/configs/pmac32_defconfig              |    1 
 arch/powerpc/configs/powernv_defconfig             |    1 
 arch/powerpc/configs/ppc64_defconfig               |    1 
 arch/powerpc/configs/ppc64e_defconfig              |    1 
 arch/powerpc/configs/ppc6xx_defconfig              |    1 
 arch/powerpc/configs/pseries_defconfig             |    1 
 arch/powerpc/configs/skiroot_defconfig             |    1 
 arch/powerpc/mm/pkeys.c                            |   12 +-
 arch/riscv/include/asm/thread_info.h               |    4 
 arch/sh/configs/sh03_defconfig                     |    1 
 arch/sparc/configs/sparc64_defconfig               |    1 
 arch/x86/configs/i386_defconfig                    |    1 
 arch/x86/configs/x86_64_defconfig                  |    1 
 arch/x86/kernel/apic/vector.c                      |   22 +---
 arch/x86/kernel/fpu/xstate.c                       |    2 
 drivers/acpi/video_detect.c                        |   19 ++++
 drivers/base/regmap/regmap-debugfs.c               |   52 ++++++-----
 drivers/block/zram/zram_drv.c                      |    3 
 drivers/char/tpm/tpm_tis_core.c                    |    2 
 drivers/char/virtio_console.c                      |    3 
 drivers/dma/fsl-edma.c                             |    7 +
 drivers/gpu/drm/exynos/exynos_drm_mic.c            |    4 
 drivers/gpu/drm/msm/msm_submitqueue.c              |    4 
 drivers/hid/hid-ids.h                              |    3 
 drivers/hid/hid-magicmouse.c                       |    6 +
 drivers/hid/hid-quirks.c                           |    5 -
 drivers/hwmon/emc2103.c                            |    2 
 drivers/hwtracing/intel_th/core.c                  |   21 +++-
 drivers/hwtracing/intel_th/pci.c                   |   15 +++
 drivers/hwtracing/intel_th/sth.c                   |    4 
 drivers/i2c/busses/i2c-eg20t.c                     |    1 
 drivers/iio/accel/mma8452.c                        |    5 -
 drivers/iio/health/afe4403.c                       |   13 +-
 drivers/iio/health/afe4404.c                       |    8 +
 drivers/iio/humidity/hdc100x.c                     |   10 +-
 drivers/iio/humidity/hts221.h                      |    7 +
 drivers/iio/humidity/hts221_buffer.c               |    9 +
 drivers/iio/magnetometer/ak8974.c                  |   29 +++---
 drivers/iio/pressure/ms5611_core.c                 |   11 +-
 drivers/iio/pressure/zpa2326.c                     |    4 
 drivers/input/serio/i8042-x86ia64io.h              |    7 +
 drivers/input/touchscreen/mms114.c                 |   17 +++
 drivers/misc/atmel-ssc.c                           |   24 ++---
 drivers/misc/mei/bus.c                             |    3 
 drivers/mmc/host/sdhci.c                           |    2 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |    5 -
 drivers/mtd/nand/raw/marvell_nand.c                |   25 +++--
 drivers/mtd/nand/raw/nand_timings.c                |    5 -
 drivers/mtd/nand/raw/oxnas_nand.c                  |   24 +++--
 drivers/net/dsa/bcm_sf2.c                          |    2 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   19 ++--
 drivers/net/phy/sfp-bus.c                          |   79 ++++++++++++++++
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/of/of_mdio.c                               |    9 +
 drivers/phy/allwinner/phy-sun4i-usb.c              |    5 -
 drivers/scsi/Kconfig                               |    9 -
 drivers/scsi/sr_vendor.c                           |    8 -
 drivers/slimbus/core.c                             |    1 
 drivers/soc/qcom/rpmh-rsc.c                        |   98 +++++++++++++--------
 drivers/soc/qcom/rpmh.c                            |   56 +++++-------
 drivers/spi/spi-fsl-dspi.c                         |   17 ---
 drivers/spi/spi-sprd-adi.c                         |    2 
 drivers/spi/spi-sun6i.c                            |   14 +--
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   10 +-
 drivers/thermal/cpu_cooling.c                      |    6 -
 drivers/thermal/mtk_thermal.c                      |    6 -
 drivers/tty/serial/mxs-auart.c                     |   12 +-
 drivers/uio/uio_pdrv_genirq.c                      |    2 
 drivers/usb/c67x00/c67x00-sched.c                  |    2 
 drivers/usb/chipidea/core.c                        |   24 +++++
 drivers/usb/dwc2/platform.c                        |    3 
 drivers/usb/gadget/function/f_uac1_legacy.c        |    2 
 drivers/usb/gadget/udc/atmel_usba_udc.c            |    2 
 drivers/usb/host/ehci-platform.c                   |    4 
 drivers/usb/host/ohci-platform.c                   |    5 -
 drivers/usb/host/xhci-plat.c                       |   10 --
 drivers/usb/serial/ch341.c                         |    1 
 drivers/usb/serial/cypress_m8.c                    |    2 
 drivers/usb/serial/cypress_m8.h                    |    3 
 drivers/usb/serial/iuu_phoenix.c                   |    8 +
 drivers/usb/serial/option.c                        |    6 +
 drivers/virt/vboxguest/vboxguest_core.c            |    6 -
 drivers/virt/vboxguest/vboxguest_core.h            |   15 +++
 drivers/virt/vboxguest/vboxguest_linux.c           |    3 
 drivers/virt/vboxguest/vmmdev.h                    |    2 
 fs/fuse/file.c                                     |   12 ++
 fs/gfs2/ops_fstype.c                               |   12 ++
 fs/overlayfs/export.c                              |    2 
 fs/overlayfs/file.c                                |   10 +-
 fs/overlayfs/super.c                               |   11 ++
 include/linux/cgroup-defs.h                        |    8 +
 include/linux/cgroup.h                             |    4 
 include/linux/if_vlan.h                            |   29 ++++--
 include/linux/printk.h                             |    5 -
 include/net/dst.h                                  |   10 +-
 include/net/genetlink.h                            |    8 -
 include/net/inet_ecn.h                             |   23 +++-
 include/net/pkt_sched.h                            |   11 --
 include/trace/events/rxrpc.h                       |    2 
 include/uapi/linux/vboxguest.h                     |    4 
 init/main.c                                        |    1 
 kernel/cgroup/cgroup.c                             |   29 +++---
 kernel/irq/manage.c                                |   37 +++++++
 kernel/printk/internal.h                           |    5 +
 kernel/printk/printk.c                             |   34 +++++++
 kernel/printk/printk_safe.c                        |   11 --
 kernel/sched/core.c                                |    2 
 kernel/sched/fair.c                                |   10 +-
 kernel/time/timer.c                                |   21 +++-
 net/ceph/osd_client.c                              |    1 
 net/core/filter.c                                  |    8 -
 net/core/sock.c                                    |    2 
 net/ipv4/ping.c                                    |    3 
 net/ipv4/tcp.c                                     |   15 +--
 net/ipv4/tcp_cong.c                                |    2 
 net/ipv4/tcp_input.c                               |    2 
 net/ipv4/tcp_ipv4.c                                |   15 ++-
 net/ipv4/tcp_output.c                              |    8 +
 net/l2tp/l2tp_core.c                               |    5 -
 net/llc/af_llc.c                                   |   10 +-
 net/netlink/genetlink.c                            |   49 ----------
 net/sched/act_connmark.c                           |    9 +
 net/sched/act_csum.c                               |    2 
 net/sched/act_skbedit.c                            |    2 
 net/sched/cls_api.c                                |    2 
 net/sched/cls_flow.c                               |    8 -
 net/sched/cls_flower.c                             |    2 
 net/sched/em_ipset.c                               |    2 
 net/sched/em_meta.c                                |    2 
 net/sched/sch_atm.c                                |    8 -
 net/sched/sch_cake.c                               |    4 
 net/sched/sch_dsmark.c                             |    6 -
 net/sched/sch_teql.c                               |    2 
 security/apparmor/match.c                          |    5 +
 sound/pci/hda/patch_realtek.c                      |    6 -
 sound/usb/card.c                                   |   12 +-
 sound/usb/line6/capture.c                          |    2 
 sound/usb/line6/driver.c                           |    2 
 sound/usb/line6/playback.c                         |    2 
 sound/usb/midi.c                                   |   17 ++-
 sound/usb/quirks.c                                 |   36 +++++++
 sound/usb/quirks.h                                 |    2 
 tools/perf/util/srcline.c                          |   16 +++
 tools/perf/util/stat.c                             |    6 -
 195 files changed, 1032 insertions(+), 590 deletions(-)

AceLan Kao (2):
      net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
      USB: serial: option: add Quectel EG95 LTE modem

Alexander Lobakin (1):
      virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Alexander Shishkin (4):
      intel_th: pci: Add Jasper Lake CPU support
      intel_th: pci: Add Tiger Lake PCH-H support
      intel_th: pci: Add Emmitsburg PCH support
      intel_th: Fix a NULL dereference when hub driver is not loaded

Alexander Usyskin (1):
      mei: bus: don't clean driver pointer

Amir Goldstein (2):
      ovl: relax WARN_ON() when decoding lower directory file handle
      ovl: fix unneeded call to ovl_change_flags()

Andreas Schwab (1):
      riscv: use 16KB kernel stack on 64-bit

Andy Shevchenko (1):
      i2c: eg20t: Load module automatically if ID matches

Aneesh Kumar K.V (1):
      powerpc/book3s64/pkeys: Fix pkey_access_permitted() for execute disable pkey

Angelo Dureghello (2):
      m68k: mm: fix node memblock init
      spi: fix initial SPI_SR value in spi-fsl-dspi

Ard Biesheuvel (2):
      arm64/alternatives: use subsections for replacement sequences
      arm64/alternatives: don't patch up internal branches

Bernard Zhao (1):
      drm/msm: fix potential memleak in error branch

Bob Peterson (1):
      gfs2: read-only mounts should grab the sd_freeze_gl glock

Changbin Du (1):
      perf: Make perf able to build with latest libbfd

Chirantan Ekbote (1):
      fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Chris Wulff (1):
      ALSA: usb-audio: Create a registration quirk for Kingston HyperX Amp (0951:16d8)

Christoffer Nielsen (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Flight S

Christoph Paasch (1):
      tcp: make sure listeners don't initialize congestion-control state

Chuhong Yuan (2):
      iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()
      serial: mxs-auart: add missed iounmap() in probe failure and remove

Claudiu Beznea (1):
      ARM: at91: pm: add quirk for sam9x60's ulp1

Colin Ian King (1):
      phy: sun4i-usb: fix dereference of pointer phy0 before it is null checked

Cong Wang (3):
      net_sched: fix a memory leak in atm_tc_init()
      cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
      cgroup: Fix sock_cgroup_data on big-endian.

Dan Carpenter (1):
      staging: comedi: verify array index is correct before using it

David Howells (1):
      rxrpc: Fix trace string

David Pedersen (1):
      Input: i8042 - add Lenovo XiaoXin Air 12 to i8042 nomux list

Diego Elio Pettenò (1):
      scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled

Dinghao Liu (1):
      iio: magnetometer: ak8974: Fix runtime PM imbalance on error

Dmitry Torokhov (1):
      HID: magicmouse: do not set up autorepeat

Douglas Anderson (1):
      regmap: debugfs: Don't sleep while atomic for fast_io regmaps

Emmanuel Pescosta (1):
      ALSA: usb-audio: Add registration quirk for Kingston HyperX Cloud Alpha S

Enric Balletbo i Serra (1):
      Revert "thermal: mediatek: fix register index error"

Eric Dumazet (6):
      llc: make sure applications use ARPHRD_ETHER
      tcp: fix SO_RCVLOWAT possible hangs under high mem pressure
      tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
      tcp: md5: do not send silly options in SYNCOOKIES
      tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
      tcp: md5: allow changing MD5 keys in all socket states

Esben Haabendal (1):
      uio_pdrv_genirq: fix use without device tree and no interrupt

Finley Xiao (1):
      thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix node reference count
      of: of_mdio: Correct loop scanning logic

Frederic Weisbecker (2):
      timer: Prevent base->clk from moving backward
      timer: Fix wheel index calculation on last level

Greg Kroah-Hartman (1):
      Linux 4.19.134

Haibo Chen (1):
      mmc: sdhci: do not enable card detect interrupt for gpio cd type

Hans de Goede (4):
      HID: quirks: Remove ITE 8595 entry from hid_have_special_driver
      ACPI: video: Use native backlight on Acer Aspire 5783z
      virt: vbox: Fix VBGL_IOCTL_VMMDEV_REQUEST_BIG and _LOG req numbers to match upstream
      virt: vbox: Fix guest capabilities mask check

Huacai Chen (1):
      MIPS: Fix build for LTS kernel caused by backporting lpj adjustment

Igor Moura (1):
      USB: serial: ch341: add new Product ID for CH340

Ilya Dryomov (1):
      libceph: don't omit recovery_deletes in target_copy()

James Hilliard (2):
      HID: quirks: Ignore Simply Automated UPB PIM
      USB: serial: cypress_m8: enable Simply Automated UPB PIM

Jerome Brunet (1):
      arm64: dts: meson: add missing gxl rng clock

Jin Yao (1):
      perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Johan Hovold (1):
      USB: serial: iuu_phoenix: fix memory corruption

John Johansen (1):
      apparmor: ensure that dfa state tables have entries

Jonathan Cameron (6):
      iio:magnetometer:ak8974: Fix alignment and data leak issues
      iio:humidity:hdc100x Fix alignment and data leak issues
      iio:humidity:hts221 Fix alignment and data leak issues
      iio:pressure:ms5611 Fix buffer element alignment
      iio:health:afe4403 Fix timestamp alignment and prevent data leak.
      iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Jörgen Storvist (1):
      USB: serial: option: add GosunCn GM500 series

Kailang Yang (2):
      ALSA: hda/realtek - change to suitable link model for ASUS platform
      ALSA: hda/realtek - Enable Speaker for ASUS UX533 and UX534

Kevin Buettner (1):
      copy_xstate_to_kernel: Fix typo which caused GDB regression

Krzysztof Kozlowski (3):
      spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
      ARM: dts: socfpga: Align L2 cache-controller nodename with dtschema
      dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler

Lingling Xu (1):
      spi: sprd: switch the sequence of setting WDG_LOAD_LOW and _HIGH

Marc Kleine-Budde (1):
      spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Martin Varghese (1):
      net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Mathieu Desnoyers (1):
      sched: Fix unreliable rseq cpu_id for new tasks

Maulik Shah (3):
      soc: qcom: rpmh: Update dirty flag only when data changes
      soc: qcom: rpmh: Invalidate SLEEP and WAKE TCSes before flushing new data
      soc: qcom: rpmh-rsc: Allow using free WAKE TCS for active request

Michał Mirosław (2):
      usb: gadget: udc: atmel: fix uninitialized read in debug printk
      misc: atmel-ssc: lock with mutex instead of spinlock

Mike Rapoport (1):
      m68k: nommu: register start of the memory with memblock

Minas Harutyunyan (1):
      usb: dwc2: Fix shutdown callback in platform

Miquel Raynal (6):
      mtd: rawnand: marvell: Use nand_cleanup() when the device is not yet registered
      mtd: rawnand: marvell: Fix probe error path
      mtd: rawnand: timings: Fix default tR_max and tCCS_min timings
      mtd: rawnand: oxnas: Keep track of registered devices
      mtd: rawnand: oxnas: Unregister all devices on error
      mtd: rawnand: oxnas: Release all devices in the _remove() path

Navid Emamdoost (2):
      drm/exynos: fix ref count leak in mic_pre_enable
      iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Neil Armstrong (1):
      doc: dt: bindings: usb: dwc3: Update entries for disabling SS instances in park mode

Paul Menzel (1):
      ACPI: video: Use native backlight on Acer TravelMate 5735Z

Peter Chen (1):
      usb: chipidea: core: add wakeup support for extcon

Raju P.L.S.S.S.N (1):
      soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS

Russell King (2):
      net: sfp: add support for module quirks
      net: sfp: add some quirks for GPON modules

Sabrina Dubroca (1):
      ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Saravana Kannan (1):
      slimbus: core: Fix mismatch in of_node_get/put

Sasha Levin (3):
      Revert "usb/ohci-platform: Fix a warning when hibernating"
      Revert "usb/xhci-plat: Set PM runtime as active on resume"
      Revert "usb/ehci-platform: Set PM runtime as active on resume"

Sean Tranchetti (1):
      genetlink: remove genl_bind

Sebastian Parschauer (1):
      HID: quirks: Always poll Obins Anne Pro 2 keyboard

Sergey Senozhatsky (1):
      printk: queue wake_up_klogd irq_work only if per-CPU areas are ready

Stephan Gerhold (1):
      Input: mms114 - add extra compatible for mms345l

Taehee Yoo (1):
      net: rmnet: fix lower interface leak

Takashi Iwai (4):
      ALSA: usb-audio: Rewrite registration quirk handling
      ALSA: line6: Perform sanity check for each URB creation
      ALSA: line6: Sync the pending work cancel at disconnection
      ALSA: usb-audio: Fix race against the error recovery URB submission

Thomas Gleixner (1):
      genirq/affinity: Handle affinity setting on inactive interrupts correctly

Toke Høiland-Jørgensen (2):
      sched: consistently handle layer3 header accesses in the presence of VLANs
      vlan: consolidate VLAN parsing code and limit max parsing depth

Tom Rix (1):
      USB: c67x00: fix use after free in c67x00_giveback_urb

Vasily Averin (1):
      tpm_tis: extra chip->ops check on error path in tpm_tis_core_init

Vincent Guittot (1):
      sched/fair: handle case of task_h_load() returning 0

Vishwas M (1):
      hwmon: (emc2103) fix unable to change fan pwm1_enable attribute

Wade Mealing (1):
      Revert "zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()"

Will Deacon (3):
      arm64: ptrace: Override SPSR.SS when single-stepping is enabled
      arm64: ptrace: Consistently use pseudo-singlestep exceptions
      arm64: compat: Ensure upper 32 bits of x0 are zero on syscall return

Xin Long (1):
      l2tp: remove skb_dst_set() from l2tp_xmit_skb()

Zhang Qiang (1):
      usb: gadget: function: fix missing spinlock in f_uac1_legacy

youngjun (1):
      ovl: inode reference leak in ovl_is_inuse true case.

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix CS0 layout

