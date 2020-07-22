Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F02A22989F
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgGVMxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732340AbgGVMxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:53:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601BA20771;
        Wed, 22 Jul 2020 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422397;
        bh=DjXFZHaw5KEK1aNfhNUDDWt0C4hAcXnBqQtjl+V7dXA=;
        h=From:To:Cc:Subject:Date:From;
        b=CZcbWzS4omlwp6AmI1aA6eXcKmjFYHEVvz8A3zZHqab3j5Hbso5Gq8v0fYoDMjpcb
         vVezF6CmsbKjSH04mYSEOFNTnFt6inESRycrpchpK/9moHZO8VzDrwcClFEsSVKwAI
         Z6yQrPsiUqpaoPmTKPRi+SUbembV8Y1M62QY90Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.189
Date:   Wed, 22 Jul 2020 14:53:21 +0200
Message-Id: <159542240176160@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.189 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/usb/dwc3.txt        |    2 
 Makefile                                              |    2 
 arch/arc/include/asm/elf.h                            |    2 
 arch/arc/kernel/entry.S                               |   16 +----
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi        |    4 +
 arch/arm/boot/dts/socfpga.dtsi                        |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi                |    2 
 arch/arm/mach-imx/pm-imx6.c                           |   10 ++-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi            |    5 +
 arch/arm64/include/asm/alternative.h                  |   16 ++---
 arch/arm64/include/asm/debug-monitors.h               |    2 
 arch/arm64/include/asm/pgtable-prot.h                 |    2 
 arch/arm64/kernel/alternative.c                       |   16 -----
 arch/arm64/kernel/debug-monitors.c                    |   20 +++++-
 arch/arm64/kernel/kgdb.c                              |    2 
 arch/arm64/kernel/ptrace.c                            |    4 -
 arch/arm64/kernel/vmlinux.lds.S                       |    3 -
 arch/arm64/kvm/hyp-init.S                             |   11 ++-
 arch/mips/kernel/time.c                               |   13 +---
 arch/s390/include/asm/kvm_host.h                      |    8 +-
 arch/s390/kernel/early.c                              |    2 
 arch/s390/mm/hugetlbpage.c                            |    2 
 arch/x86/include/asm/processor.h                      |    2 
 arch/x86/kernel/cpu/common.c                          |    2 
 arch/x86/kernel/fpu/xstate.c                          |    2 
 arch/x86/kvm/kvm_cache_regs.h                         |    2 
 arch/x86/kvm/mmu.c                                    |    2 
 arch/x86/kvm/vmx.c                                    |    2 
 arch/x86/kvm/x86.c                                    |    2 
 drivers/acpi/video_detect.c                           |   19 ++++++
 drivers/block/nbd.c                                   |   25 +++++---
 drivers/block/zram/zram_drv.c                         |    3 -
 drivers/char/tpm/tpm_tis_core.c                       |    2 
 drivers/char/virtio_console.c                         |    3 -
 drivers/dma/fsl-edma.c                                |    7 ++
 drivers/gpu/drm/exynos/exynos_drm_mic.c               |    4 +
 drivers/gpu/drm/radeon/ci_dpm.c                       |    7 +-
 drivers/gpu/host1x/bus.c                              |    9 +++
 drivers/hid/hid-magicmouse.c                          |    6 ++
 drivers/hwmon/emc2103.c                               |    2 
 drivers/hwtracing/intel_th/pci.c                      |   15 +++++
 drivers/i2c/busses/i2c-eg20t.c                        |    1 
 drivers/iio/accel/mma8452.c                           |    5 +
 drivers/iio/health/afe4403.c                          |   13 ++--
 drivers/iio/health/afe4404.c                          |    8 +-
 drivers/iio/humidity/hdc100x.c                        |   10 ++-
 drivers/iio/magnetometer/ak8974.c                     |   29 +++++-----
 drivers/iio/pressure/ms5611_core.c                    |   11 ++-
 drivers/iio/pressure/zpa2326.c                        |    4 +
 drivers/input/serio/i8042-x86ia64io.h                 |    7 ++
 drivers/md/dm.c                                       |   15 ++++-
 drivers/message/fusion/mptscsih.c                     |    4 -
 drivers/misc/atmel-ssc.c                              |   24 ++++----
 drivers/misc/mei/bus.c                                |    3 -
 drivers/mmc/host/sdhci.c                              |    2 
 drivers/mtd/nand/brcmnand/brcmnand.c                  |    5 +
 drivers/mtd/nand/oxnas_nand.c                         |   24 ++++++--
 drivers/net/dsa/bcm_sf2.c                             |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c       |    2 
 drivers/net/ethernet/cadence/macb_main.c              |    2 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c            |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c          |   12 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |   14 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 
 drivers/net/usb/qmi_wwan.c                            |    1 
 drivers/net/usb/smsc95xx.c                            |    9 ++-
 drivers/net/wireless/ath/ath9k/hif_usb.c              |   48 +++-------------
 drivers/net/wireless/ath/ath9k/hif_usb.h              |    5 -
 drivers/nvme/host/rdma.c                              |    2 
 drivers/of/of_mdio.c                                  |    9 ++-
 drivers/phy/allwinner/phy-sun4i-usb.c                 |    5 +
 drivers/spi/spi-fsl-dspi.c                            |   39 +++++++++++--
 drivers/spi/spi-sun6i.c                               |   14 ++--
 drivers/spi/spidev.c                                  |   24 ++++----
 drivers/staging/comedi/drivers/addi_apci_1500.c       |   10 ++-
 drivers/thermal/cpu_cooling.c                         |    6 +-
 drivers/thermal/mtk_thermal.c                         |    6 --
 drivers/uio/uio_pdrv_genirq.c                         |    2 
 drivers/usb/c67x00/c67x00-sched.c                     |    2 
 drivers/usb/chipidea/core.c                           |   24 ++++++++
 drivers/usb/dwc2/platform.c                           |    3 -
 drivers/usb/gadget/function/f_uac1_legacy.c           |    2 
 drivers/usb/gadget/udc/atmel_usba_udc.c               |    2 
 drivers/usb/host/ehci-platform.c                      |    5 -
 drivers/usb/host/ohci-platform.c                      |    5 -
 drivers/usb/host/xhci-plat.c                          |   10 ---
 drivers/usb/serial/ch341.c                            |    1 
 drivers/usb/serial/cypress_m8.c                       |    2 
 drivers/usb/serial/cypress_m8.h                       |    3 +
 drivers/usb/serial/iuu_phoenix.c                      |    8 +-
 drivers/usb/serial/option.c                           |    6 ++
 fs/btrfs/extent_io.c                                  |   40 ++++++++-----
 fs/cifs/inode.c                                       |    9 +++
 fs/fuse/file.c                                        |   12 +++-
 fs/gfs2/ops_fstype.c                                  |   12 +++-
 include/linux/cgroup-defs.h                           |    8 ++
 include/linux/cgroup.h                                |    4 +
 include/net/dst.h                                     |   10 +++
 include/net/genetlink.h                               |    8 --
 include/sound/compress_driver.h                       |   10 +++
 include/trace/events/rxrpc.h                          |    2 
 kernel/cgroup/cgroup.c                                |   29 ++++++----
 kernel/sched/fair.c                                   |   10 +++
 kernel/time/timer.c                                   |    4 -
 net/ceph/osd_client.c                                 |    1 
 net/core/sock.c                                       |    2 
 net/ipv4/ping.c                                       |    3 +
 net/ipv4/tcp.c                                        |   15 +++--
 net/ipv4/tcp_cong.c                                   |    2 
 net/ipv4/tcp_ipv4.c                                   |   15 ++++-
 net/ipv4/tcp_output.c                                 |   10 ++-
 net/l2tp/l2tp_core.c                                  |    5 -
 net/llc/af_llc.c                                      |   10 ++-
 net/netlink/genetlink.c                               |   49 ----------------
 net/sched/sch_atm.c                                   |    8 +-
 sound/core/compress_offload.c                         |    4 +
 sound/drivers/opl3/opl3_synth.c                       |    2 
 sound/pci/hda/hda_auto_parser.c                       |    6 ++
 sound/usb/line6/capture.c                             |    2 
 sound/usb/line6/playback.c                            |    2 
 sound/usb/midi.c                                      |   17 ++++-
 sound/usb/quirks-table.h                              |   52 ++++++++++++++++++
 tools/perf/util/stat.c                                |    6 +-
 123 files changed, 685 insertions(+), 406 deletions(-)

AceLan Kao (2):
      net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
      USB: serial: option: add Quectel EG95 LTE modem

Alexander Lobakin (1):
      virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Alexander Shishkin (3):
      intel_th: pci: Add Jasper Lake CPU support
      intel_th: pci: Add Tiger Lake PCH-H support
      intel_th: pci: Add Emmitsburg PCH support

Alexander Usyskin (1):
      mei: bus: don't clean driver pointer

Andre Edich (2):
      smsc95xx: check return value of smsc95xx_reset
      smsc95xx: avoid memory leak in smsc95xx_bind

Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Andy Shevchenko (1):
      i2c: eg20t: Load module automatically if ID matches

Angelo Dureghello (1):
      spi: fix initial SPI_SR value in spi-fsl-dspi

Ard Biesheuvel (2):
      arm64/alternatives: use subsections for replacement sequences
      arm64/alternatives: don't patch up internal branches

Bob Peterson (1):
      gfs2: read-only mounts should grab the sd_freeze_gl glock

Boris Burkov (1):
      btrfs: fix fatal extent_buffer readahead vs releasepage race

Chirantan Ekbote (1):
      fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Christoph Paasch (1):
      tcp: make sure listeners don't initialize congestion-control state

Chuanhua Han (1):
      spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ

Chuhong Yuan (1):
      iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()

Ciara Loftus (1):
      ixgbe: protect ring accesses with READ- and WRITE_ONCE

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

Davide Caratti (1):
      bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Dinghao Liu (1):
      iio: magnetometer: ak8974: Fix runtime PM imbalance on error

Dmitry Torokhov (1):
      HID: magicmouse: do not set up autorepeat

Enric Balletbo i Serra (1):
      Revert "thermal: mediatek: fix register index error"

Eric Dumazet (5):
      llc: make sure applications use ARPHRD_ETHER
      tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
      tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
      tcp: md5: allow changing MD5 keys in all socket states
      tcp: md5: do not send silly options in SYNCOOKIES

Esben Haabendal (1):
      uio_pdrv_genirq: fix use without device tree and no interrupt

Finley Xiao (1):
      thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix node reference count
      of: of_mdio: Correct loop scanning logic

Frederic Weisbecker (1):
      timer: Fix wheel index calculation on last level

Greg Kroah-Hartman (2):
      Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
      Linux 4.14.189

Gustavo A. R. Silva (1):
      arm64: alternative: Use true and false for boolean values

Haibo Chen (1):
      mmc: sdhci: do not enable card detect interrupt for gpio cd type

Hans de Goede (1):
      ACPI: video: Use native backlight on Acer Aspire 5783z

Hector Martin (1):
      ALSA: usb-audio: add quirk for MacroSilicon MS2109

Huacai Chen (1):
      MIPS: Fix build for LTS kernel caused by backporting lpj adjustment

Hui Wang (1):
      ALSA: hda - let hs_mic be picked ahead of hp_mic

Ido Schimmel (1):
      mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()

Igor Moura (1):
      USB: serial: ch341: add new Product ID for CH340

Ilya Dryomov (1):
      libceph: don't omit recovery_deletes in target_copy()

James Hilliard (1):
      USB: serial: cypress_m8: enable Simply Automated UPB PIM

Janosch Frank (1):
      s390/mm: fix huge pte soft dirty copying

Jerome Brunet (1):
      arm64: dts: meson: add missing gxl rng clock

Jin Yao (1):
      perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Johan Hovold (1):
      USB: serial: iuu_phoenix: fix memory corruption

Jonathan Cameron (5):
      iio:magnetometer:ak8974: Fix alignment and data leak issues
      iio:humidity:hdc100x Fix alignment and data leak issues
      iio:pressure:ms5611 Fix buffer element alignment
      iio:health:afe4403 Fix timestamp alignment and prevent data leak.
      iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Jörgen Storvist (1):
      USB: serial: option: add GosunCn GM500 series

Kevin Buettner (1):
      copy_xstate_to_kernel: Fix typo which caused GDB regression

Krzysztof Kozlowski (5):
      spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
      spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths
      spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
      ARM: dts: socfpga: Align L2 cache-controller nodename with dtschema
      dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler

Li Heng (1):
      net: cxgb4: fix return error value in t4_prep_fw

Marc Kleine-Budde (1):
      spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Martin Varghese (1):
      net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Max Gurtovoy (1):
      nvme-rdma: assign completion vector correctly

Michał Mirosław (2):
      usb: gadget: udc: atmel: fix uninitialized read in debug printk
      misc: atmel-ssc: lock with mutex instead of spinlock

Mikulas Patocka (1):
      dm: use noio when sending kobject event

Minas Harutyunyan (1):
      usb: dwc2: Fix shutdown callback in platform

Miquel Raynal (3):
      mtd: rawnand: oxnas: Keep track of registered devices
      mtd: rawnand: oxnas: Unregister all devices on error
      mtd: rawnand: oxnas: Release all devices in the _remove() path

Navid Emamdoost (2):
      drm/exynos: fix ref count leak in mic_pre_enable
      iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Neil Armstrong (1):
      doc: dt: bindings: usb: dwc3: Update entries for disabling SS instances in park mode

Nicolas Ferre (1):
      net: macb: mark device wake capable when "magic-packet" property present

Paolo Bonzini (1):
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Paul Menzel (1):
      ACPI: video: Use native backlight on Acer TravelMate 5735Z

Peng Ma (1):
      spi: spi-fsl-dspi: Adding shutdown hook

Peter Chen (1):
      usb: chipidea: core: add wakeup support for extcon

Peter Zijlstra (1):
      x86/entry: Increase entry_stack size to a full page

Sabrina Dubroca (1):
      ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Sasha Levin (3):
      Revert "usb/ohci-platform: Fix a warning when hibernating"
      Revert "usb/ehci-platform: Set PM runtime as active on resume"
      Revert "usb/xhci-plat: Set PM runtime as active on resume"

Sean Christopherson (2):
      KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
      KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Sean Tranchetti (1):
      genetlink: remove genl_bind

Suraj Jitindar Singh (1):
      x86/cpu: Move x86_cache_bits settings

Takashi Iwai (2):
      ALSA: line6: Perform sanity check for each URB creation
      ALSA: usb-audio: Fix race against the error recovery URB submission

Thierry Reding (1):
      gpu: host1x: Detach driver on unregister

Tom Rix (2):
      drm/radeon: fix double free
      USB: c67x00: fix use after free in c67x00_giveback_urb

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

Tony Lindgren (1):
      ARM: dts: omap4-droid4: Fix spi configuration and increase rate

Vasily Averin (1):
      tpm_tis: extra chip->ops check on error path in tpm_tis_core_init

Vasily Gorbik (1):
      s390/kasan: fix early pgm check handler execution

Vincent Guittot (1):
      sched/fair: handle case of task_h_load() returning 0

Vineet Gupta (2):
      ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE
      ARC: elf: use right ELF_ARCH

Vinod Koul (1):
      ALSA: compress: fix partial_drain completion state

Vishwas M (1):
      hwmon: (emc2103) fix unable to change fan pwm1_enable attribute

Wade Mealing (1):
      Revert "zram: convert remaining CLASS_ATTR() to CLASS_ATTR_RO()"

Wei Li (1):
      arm64: kgdb: Fix single-step exception handling oops

Will Deacon (2):
      KVM: arm64: Fix definition of PAGE_HYP_DEVICE
      arm64: ptrace: Override SPSR.SS when single-stepping is enabled

Xin Long (1):
      l2tp: remove skb_dst_set() from l2tp_xmit_skb()

Zhang Qiang (1):
      usb: gadget: function: fix missing spinlock in f_uac1_legacy

Zhang Xiaoxu (1):
      cifs: update ctime and mtime during truncate

Zheng Bin (1):
      nbd: Fix memory leak in nbd_add_socket

Zhenzhong Duan (2):
      spi: spidev: fix a race between spidev_release and spidev_remove
      spi: spidev: fix a potential use-after-free in spidev_release()

xidongwang (1):
      ALSA: opl3: fix infoleak in opl3

yu kuai (1):
      ARM: imx6: add missing put_device() call in imx6q_suspend_init()

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix CS0 layout

