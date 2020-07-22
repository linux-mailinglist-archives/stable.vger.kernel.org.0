Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4252D22989D
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgGVMxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732290AbgGVMxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:53:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0102B205CB;
        Wed, 22 Jul 2020 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422384;
        bh=thUyRQOGkShe2sbJLb9QrClhpmST/pWVKJN0gZ9+ztM=;
        h=From:To:Cc:Subject:Date:From;
        b=11PhL798pfHV6TfbYVAUh5jmJoxXcqOY2mEBPXFIclD50EmJRxD69NaQ1kmnEvIia
         u0GG4fe6PixRWWCxKYoobyWc5G6e56/ai5jazh+oc8AgK2Stz/5jcDsaysblMOEXTg
         lnzc+uq5gK5zDx/ZjYKATCwodZbo0LmAdvX+KOGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.231
Date:   Wed, 22 Jul 2020 14:53:09 +0200
Message-Id: <159542238839135@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.231 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arc/include/asm/elf.h                      |    2 
 arch/arc/kernel/entry.S                         |   16 ++-----
 arch/arm/boot/dts/socfpga.dtsi                  |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi          |    2 
 arch/arm/mach-imx/pm-imx6.c                     |   10 ++--
 arch/arm64/include/asm/debug-monitors.h         |    2 
 arch/arm64/include/asm/pgtable-prot.h           |    2 
 arch/arm64/kernel/debug-monitors.c              |   20 +++++++--
 arch/arm64/kernel/kgdb.c                        |    2 
 arch/arm64/kernel/ptrace.c                      |    4 -
 arch/mips/kernel/time.c                         |   13 +-----
 arch/s390/include/asm/kvm_host.h                |    8 +--
 arch/s390/kernel/early.c                        |    2 
 arch/s390/mm/hugetlbpage.c                      |    2 
 arch/x86/kernel/cpu/common.c                    |    2 
 arch/x86/kvm/mmu.c                              |    2 
 drivers/char/virtio_console.c                   |    3 -
 drivers/dma/fsl-edma.c                          |    7 +++
 drivers/gpu/drm/radeon/ci_dpm.c                 |    7 +--
 drivers/gpu/host1x/bus.c                        |    9 ++++
 drivers/hid/hid-magicmouse.c                    |    6 ++
 drivers/hwmon/emc2103.c                         |    2 
 drivers/i2c/busses/i2c-eg20t.c                  |    1 
 drivers/iio/accel/mma8452.c                     |    5 +-
 drivers/iio/health/afe4403.c                    |   13 +++---
 drivers/iio/health/afe4404.c                    |    8 ++-
 drivers/iio/magnetometer/ak8974.c               |   29 +++++++------
 drivers/iio/pressure/ms5611_core.c              |   11 +++--
 drivers/iio/pressure/zpa2326.c                  |    4 +
 drivers/input/serio/i8042-x86ia64io.h           |    7 +++
 drivers/irqchip/irq-gic.c                       |   13 +-----
 drivers/message/fusion/mptscsih.c               |    4 -
 drivers/misc/atmel-ssc.c                        |   24 +++++------
 drivers/misc/mei/bus.c                          |    3 -
 drivers/mtd/nand/brcmnand/brcmnand.c            |    5 +-
 drivers/net/dsa/bcm_sf2.c                       |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |    2 
 drivers/net/ethernet/cadence/macb.c             |    2 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |    8 +--
 drivers/net/usb/qmi_wwan.c                      |    1 
 drivers/net/usb/smsc95xx.c                      |    9 +++-
 drivers/net/wireless/ath/ath9k/hif_usb.c        |   48 +++++-----------------
 drivers/net/wireless/ath/ath9k/hif_usb.h        |    5 --
 drivers/spi/spi-fsl-dspi.c                      |    2 
 drivers/spi/spi-sun6i.c                         |   14 ++----
 drivers/spi/spidev.c                            |   24 +++++------
 drivers/staging/comedi/drivers/addi_apci_1500.c |   10 +++-
 drivers/thermal/mtk_thermal.c                   |    6 --
 drivers/uio/uio_pdrv_genirq.c                   |    2 
 drivers/usb/c67x00/c67x00-sched.c               |    2 
 drivers/usb/chipidea/core.c                     |   24 +++++++++++
 drivers/usb/core/urb.c                          |   30 ++++++++++++-
 drivers/usb/dwc2/platform.c                     |    3 -
 drivers/usb/gadget/function/f_uac1.c            |    2 
 drivers/usb/gadget/udc/atmel_usba_udc.c         |    2 
 drivers/usb/host/ehci-platform.c                |    5 --
 drivers/usb/host/ohci-platform.c                |    5 --
 drivers/usb/host/xhci-plat.c                    |   11 -----
 drivers/usb/serial/ch341.c                      |    1 
 drivers/usb/serial/cypress_m8.c                 |    2 
 drivers/usb/serial/cypress_m8.h                 |    3 +
 drivers/usb/serial/iuu_phoenix.c                |    8 ++-
 drivers/usb/serial/option.c                     |    6 ++
 fs/btrfs/extent_io.c                            |   40 +++++++++++-------
 fs/cifs/inode.c                                 |    9 ++++
 fs/fuse/file.c                                  |   12 +++++
 include/linux/cgroup-defs.h                     |    8 ++-
 include/linux/cgroup.h                          |    4 +
 include/linux/usb.h                             |    2 
 include/net/dst.h                               |   10 ++++
 include/net/genetlink.h                         |    8 ---
 include/sound/compress_driver.h                 |   10 ++++
 kernel/cgroup.c                                 |   24 ++++++++---
 kernel/sched/fair.c                             |   10 ++++
 kernel/time/timer.c                             |    4 -
 net/core/sock.c                                 |    2 
 net/ipv4/ping.c                                 |    3 +
 net/ipv4/tcp.c                                  |   15 ++++--
 net/ipv4/tcp_cong.c                             |    2 
 net/ipv4/tcp_ipv4.c                             |   15 +++++-
 net/ipv4/tcp_output.c                           |   10 ++--
 net/l2tp/l2tp_core.c                            |    5 --
 net/llc/af_llc.c                                |   10 +++-
 net/netlink/genetlink.c                         |   52 ------------------------
 sound/core/compress_offload.c                   |    4 +
 sound/drivers/opl3/opl3_synth.c                 |    2 
 sound/pci/hda/hda_auto_parser.c                 |    6 ++
 sound/usb/line6/capture.c                       |    2 
 sound/usb/line6/playback.c                      |    2 
 sound/usb/midi.c                                |   17 +++++--
 sound/usb/quirks-table.h                        |   52 ++++++++++++++++++++++++
 tools/perf/util/stat.c                          |    6 +-
 93 files changed, 508 insertions(+), 331 deletions(-)

AceLan Kao (2):
      net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
      USB: serial: option: add Quectel EG95 LTE modem

Alexander Lobakin (1):
      virtio: virtio_console: add missing MODULE_DEVICE_TABLE() for rproc serial

Alexander Usyskin (1):
      mei: bus: don't clean driver pointer

Andre Edich (2):
      smsc95xx: check return value of smsc95xx_reset
      smsc95xx: avoid memory leak in smsc95xx_bind

Andy Shevchenko (1):
      i2c: eg20t: Load module automatically if ID matches

Angelo Dureghello (1):
      spi: fix initial SPI_SR value in spi-fsl-dspi

Boris Burkov (1):
      btrfs: fix fatal extent_buffer readahead vs releasepage race

Chirantan Ekbote (1):
      fuse: Fix parameter for FS_IOC_{GET,SET}FLAGS

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Christoph Paasch (1):
      tcp: make sure listeners don't initialize congestion-control state

Chuhong Yuan (1):
      iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()

Cong Wang (2):
      cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
      cgroup: Fix sock_cgroup_data on big-endian.

Dan Carpenter (1):
      staging: comedi: verify array index is correct before using it

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
      tcp: md5: do not send silly options in SYNCOOKIES
      tcp: md5: allow changing MD5 keys in all socket states

Esben Haabendal (1):
      uio_pdrv_genirq: fix use without device tree and no interrupt

Florian Fainelli (1):
      net: dsa: bcm_sf2: Fix node reference count

Frederic Weisbecker (1):
      timer: Fix wheel index calculation on last level

Greg Kroah-Hartman (2):
      Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
      Linux 4.9.231

Hector Martin (1):
      ALSA: usb-audio: add quirk for MacroSilicon MS2109

Huacai Chen (1):
      MIPS: Fix build for LTS kernel caused by backporting lpj adjustment

Hui Wang (1):
      ALSA: hda - let hs_mic be picked ahead of hp_mic

Igor Moura (1):
      USB: serial: ch341: add new Product ID for CH340

James Hilliard (1):
      USB: serial: cypress_m8: enable Simply Automated UPB PIM

Janosch Frank (1):
      s390/mm: fix huge pte soft dirty copying

Jin Yao (1):
      perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode

Johan Hovold (1):
      USB: serial: iuu_phoenix: fix memory corruption

Jonathan Cameron (4):
      iio:magnetometer:ak8974: Fix alignment and data leak issues
      iio:pressure:ms5611 Fix buffer element alignment
      iio:health:afe4403 Fix timestamp alignment and prevent data leak.
      iio:health:afe4404 Fix timestamp alignment and prevent data leak.

Jörgen Storvist (1):
      USB: serial: option: add GosunCn GM500 series

Krzysztof Kozlowski (2):
      ARM: dts: socfpga: Align L2 cache-controller nodename with dtschema
      dmaengine: fsl-edma: Fix NULL pointer exception in fsl_edma_tx_handler

Li Heng (1):
      net: cxgb4: fix return error value in t4_prep_fw

Marc Kleine-Budde (1):
      spi: spi-sun6i: sun6i_spi_transfer_one(): fix setting of clock rate

Marc Zyngier (1):
      irqchip/gic: Atomically update affinity

Martin Varghese (1):
      net: Added pointer check for dst->ops->neigh_lookup in dst_neigh_lookup_skb

Michał Mirosław (2):
      usb: gadget: udc: atmel: fix uninitialized read in debug printk
      misc: atmel-ssc: lock with mutex instead of spinlock

Minas Harutyunyan (1):
      usb: dwc2: Fix shutdown callback in platform

Navid Emamdoost (1):
      iio: pressure: zpa2326: handle pm_runtime_get_sync failure

Nicolas Ferre (1):
      net: macb: mark device wake capable when "magic-packet" property present

Paolo Bonzini (1):
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Peter Chen (1):
      usb: chipidea: core: add wakeup support for extcon

Sabrina Dubroca (1):
      ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg

Sasha Levin (3):
      Revert "usb/ehci-platform: Set PM runtime as active on resume"
      Revert "usb/xhci-plat: Set PM runtime as active on resume"
      Revert "usb/ohci-platform: Fix a warning when hibernating"

Sean Tranchetti (1):
      genetlink: remove genl_bind

Suraj Jitindar Singh (1):
      x86/cpu: Move x86_cache_bits settings

Takashi Iwai (3):
      usb: core: Add a helper function to check the validity of EP type in URB
      ALSA: line6: Perform sanity check for each URB creation
      ALSA: usb-audio: Fix race against the error recovery URB submission

Thierry Reding (1):
      gpu: host1x: Detach driver on unregister

Tom Rix (2):
      drm/radeon: fix double free
      USB: c67x00: fix use after free in c67x00_giveback_urb

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

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

Zhenzhong Duan (2):
      spi: spidev: fix a race between spidev_release and spidev_remove
      spi: spidev: fix a potential use-after-free in spidev_release()

xidongwang (1):
      ALSA: opl3: fix infoleak in opl3

yu kuai (1):
      ARM: imx6: add missing put_device() call in imx6q_suspend_init()

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix CS0 layout

