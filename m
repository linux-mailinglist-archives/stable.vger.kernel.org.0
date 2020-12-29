Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824152E71AF
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgL2PRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 10:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgL2PRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Dec 2020 10:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6657C22209;
        Tue, 29 Dec 2020 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609254978;
        bh=+utZOi550a/e/Fney/CsxIwTc1TY4ZHqi1WHYbIP+bg=;
        h=From:To:Cc:Subject:Date:From;
        b=FzM28yY+MQxHKxCzFvzxt3PEJEnuwNVhl8a+t3xjPS9d1iJgxsVdyKckXzKbzdTVb
         p/3votUW4HYtEUBvIzrYE8x+rwWthqCsVepKrR6q8PG9w8So1pIvhqImuKmnhCpoWY
         /8Cb5fvfMilqZu80NnHs2l6orqm7XfkUbxmUsRQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.249
Date:   Tue, 29 Dec 2020 16:17:37 +0100
Message-Id: <160925505721113@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.249 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arc/kernel/stacktrace.c                      |   23 +++++---
 arch/arm/boot/dts/at91-sama5d3_xplained.dts       |    7 ++
 arch/arm/boot/dts/at91-sama5d4_xplained.dts       |    7 ++
 arch/arm/kernel/head.S                            |    6 --
 arch/mips/bcm47xx/Kconfig                         |    1 
 arch/powerpc/include/asm/cputable.h               |    5 -
 arch/powerpc/perf/core-book3s.c                   |   10 +++
 arch/powerpc/platforms/pseries/suspend.c          |    1 
 arch/um/drivers/xterm.c                           |    5 +
 arch/x86/kernel/kprobes/core.c                    |    5 +
 drivers/acpi/acpi_pnp.c                           |    3 +
 drivers/acpi/resource.c                           |    2 
 drivers/block/xen-blkback/xenbus.c                |    3 -
 drivers/bus/mips_cdmm.c                           |    4 -
 drivers/clk/clk-s2mps11.c                         |    1 
 drivers/clk/ti/fapll.c                            |   11 +++
 drivers/clocksource/arm_arch_timer.c              |   23 +++++---
 drivers/cpufreq/highbank-cpufreq.c                |    7 ++
 drivers/cpufreq/ls1x-cpufreq.c                    |    1 
 drivers/cpufreq/scpi-cpufreq.c                    |    1 
 drivers/crypto/talitos.c                          |    6 +-
 drivers/extcon/extcon-max77693.c                  |    2 
 drivers/gpu/drm/gma500/cdv_intel_dp.c             |    2 
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c          |    1 
 drivers/iio/adc/rockchip_saradc.c                 |    2 
 drivers/iio/pressure/mpl3115.c                    |    9 ++-
 drivers/infiniband/core/cm.c                      |    2 
 drivers/infiniband/hw/mthca/mthca_cq.c            |    2 
 drivers/infiniband/hw/mthca/mthca_dev.h           |    1 
 drivers/input/keyboard/cros_ec_keyb.c             |    1 
 drivers/input/misc/cm109.c                        |    7 +-
 drivers/input/mouse/cyapa_gen6.c                  |    2 
 drivers/input/serio/i8042-x86ia64io.h             |   42 ++++++++++++++
 drivers/input/touchscreen/ads7846.c               |    8 +-
 drivers/input/touchscreen/goodix.c                |   12 ++++
 drivers/md/dm-ioctl.c                             |    1 
 drivers/md/dm-table.c                             |    6 --
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c |    5 +
 drivers/media/pci/saa7146/mxb.c                   |   19 +++---
 drivers/media/pci/solo6x10/solo6x10-g723.c        |    2 
 drivers/media/rc/sunxi-cir.c                      |    2 
 drivers/media/usb/gspca/gspca.c                   |    1 
 drivers/media/usb/msi2500/msi2500.c               |    2 
 drivers/memstick/core/memstick.c                  |    1 
 drivers/memstick/host/r592.c                      |   12 ++--
 drivers/mtd/cmdlinepart.c                         |   14 ++++
 drivers/net/can/softing/softing_main.c            |    9 ++-
 drivers/net/ethernet/allwinner/sun4i-emac.c       |    7 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    |    4 +
 drivers/net/ethernet/korina.c                     |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |   17 +++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |    7 ++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c  |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 +++-
 drivers/net/wireless/cw1200/main.c                |    2 
 drivers/net/wireless/orinoco/orinoco_usb.c        |   14 ++--
 drivers/net/xen-netback/xenbus.c                  |    4 +
 drivers/nfc/s3fwrn5/firmware.c                    |    4 +
 drivers/pci/slot.c                                |    6 +-
 drivers/pinctrl/pinctrl-amd.c                     |    7 --
 drivers/pinctrl/pinctrl-falcon.c                  |   14 +++-
 drivers/platform/x86/acer-wmi.c                   |    1 
 drivers/ps3/ps3stor_lib.c                         |    2 
 drivers/s390/block/dasd_alias.c                   |    3 -
 drivers/scsi/bnx2i/Kconfig                        |    1 
 drivers/scsi/fnic/fnic_main.c                     |    1 
 drivers/scsi/pm8001/pm8001_init.c                 |    3 -
 drivers/soc/tegra/fuse/speedo-tegra210.c          |    2 
 drivers/soc/ti/knav_dma.c                         |   13 +++-
 drivers/soc/ti/knav_qmss_queue.c                  |    4 +
 drivers/spi/Kconfig                               |    3 +
 drivers/spi/spi-bcm2835aux.c                      |   17 ++---
 drivers/spi/spi-img-spfi.c                        |    4 +
 drivers/spi/spi-rb4xx.c                           |    2 
 drivers/spi/spi-tegra114.c                        |    2 
 drivers/spi/spi-tegra20-sflash.c                  |    1 
 drivers/spi/spi-tegra20-slink.c                   |    2 
 drivers/spi/spi-ti-qspi.c                         |    1 
 drivers/spi/spi.c                                 |   21 ++++++-
 drivers/staging/comedi/drivers/mf6x4.c            |    3 -
 drivers/staging/speakup/speakup_dectlk.c          |    2 
 drivers/tty/serial/8250/8250_omap.c               |    5 -
 drivers/usb/chipidea/ci_hdrc_imx.c                |    3 -
 drivers/usb/core/quirks.c                         |    3 +
 drivers/usb/gadget/function/f_rndis.c             |    4 +
 drivers/usb/gadget/udc/dummy_hcd.c                |    2 
 drivers/usb/host/ehci-omap.c                      |    1 
 drivers/usb/host/oxu210hp-hcd.c                   |    4 +
 drivers/usb/host/xhci-hub.c                       |    4 +
 drivers/usb/misc/sisusbvga/Kconfig                |    2 
 drivers/usb/serial/cp210x.c                       |    2 
 drivers/usb/serial/keyspan_pda.c                  |   63 +++++++++++-----------
 drivers/usb/serial/mos7720.c                      |    2 
 drivers/usb/serial/option.c                       |   23 +++++++-
 drivers/xen/xen-pciback/xenbus.c                  |    2 
 drivers/xen/xenbus/xenbus_client.c                |    8 ++
 drivers/xen/xenbus/xenbus_probe.c                 |    1 
 drivers/xen/xenbus/xenbus_probe.h                 |    2 
 drivers/xen/xenbus/xenbus_probe_backend.c         |    7 ++
 drivers/xen/xenbus/xenbus_xs.c                    |   38 ++++++++-----
 fs/btrfs/inode.c                                  |    2 
 fs/btrfs/qgroup.c                                 |    4 +
 fs/btrfs/scrub.c                                  |   17 +++--
 fs/btrfs/tests/btrfs-tests.c                      |    8 ++
 fs/ceph/caps.c                                    |   11 +++
 fs/ext4/mballoc.c                                 |    1 
 fs/jffs2/readinode.c                              |   16 +++++
 fs/jfs/jfs_dmap.h                                 |    2 
 fs/lockd/host.c                                   |   20 +++---
 fs/nfs/inode.c                                    |    2 
 fs/nfs/nfs4proc.c                                 |   10 ++-
 fs/nfs_common/grace.c                             |    6 +-
 include/linux/seq_buf.h                           |    2 
 include/linux/trace_seq.h                         |    4 -
 include/xen/xenbus.h                              |   15 ++++-
 net/bluetooth/hci_event.c                         |   17 +++--
 net/bridge/br_vlan.c                              |    4 +
 net/ipv4/tcp_output.c                             |    9 ++-
 net/wireless/nl80211.c                            |    2 
 scripts/checkpatch.pl                             |    2 
 sound/core/oss/pcm_oss.c                          |   28 ++++++---
 sound/soc/codecs/wm_adsp.c                        |    5 +
 sound/soc/jz4740/jz4740-i2s.c                     |    4 +
 sound/soc/soc-pcm.c                               |    2 
 sound/usb/format.c                                |    2 
 sound/usb/stream.c                                |    6 +-
 tools/perf/util/parse-regs-options.c              |    2 
 128 files changed, 618 insertions(+), 252 deletions(-)

Alan Stern (1):
      media: gspca: Fix memory leak in probe

Alexander Sverdlin (1):
      serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Anton Ivanov (1):
      um: chan_xterm: Fix fd leak

Antti Palosaari (1):
      media: msi2500: assign SPI bus number dynamically

Ard Biesheuvel (1):
      ARM: p2v: fix handling of LPAE translation in BE mode

Arnd Bergmann (3):
      RDMa/mthca: Work around -Wenum-conversion warning
      seq_buf: Avoid type mismatch for seq_buf_init
      Input: cyapa_gen6 - fix out-of-bounds stack access

Athira Rajeev (1):
      powerpc/perf: Exclude kernel samples while counting events in user space.

Bongsu Jeon (1):
      nfc: s3fwrn5: Release the nfc firmware

Brant Merryman (1):
      USB: serial: cp210x: enable usb generic throttle/unthrottle

Bui Quang Minh (1):
      USB: dummy-hcd: Fix uninitialized array use in init()

Calum Mackay (1):
      lockd: don't use interval-based rebinding over TCP

Cezary Rojewski (1):
      ASoC: pcm: DRAIN support reactivation

Cheng Lin (1):
      nfs_common: need lock during iterate through the list

Chris Chiu (1):
      Input: i8042 - add Acer laptops to the i8042 reset list

Christophe JAILLET (3):
      net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
      net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
      clk: s2mps11: Fix a resource leak in error handling paths in the probe function

Christophe Leroy (2):
      crypto: talitos - Fix return type of current_desc_hdr()
      powerpc/feature: Fix CPU_FTRS_ALWAYS by removing CPU_FTRS_GENERIC_32

Chuhong Yuan (1):
      ASoC: jz4740-i2s: add missed checks for clk_get()

Chunguang Xu (1):
      ext4: fix a memory leak of ext4_free_data

Coiby Xu (1):
      pinctrl: amd: remove debounce filter setting in IRQ type setting

Cristian Birsan (2):
      ARM: dts: at91: sama5d4_xplained: add pincontrol for USB Host
      ARM: dts: at91: sama5d3_xplained: add pincontrol for USB Host

Dan Carpenter (3):
      media: saa7146: fix array overflow in vidioc_s_audio()
      ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
      qlcnic: Fix error code in probe

Daniel Scally (1):
      Revert "ACPI / resources: Use AE_CTRL_TERMINATE to terminate resources walks"

Dave Kleikamp (1):
      jfs: Fix array index bounds check in dbAdjTree

Dmitry Torokhov (3):
      Input: cm109 - do not stomp on control URB
      Input: ads7846 - fix unaligned access on 7845
      Input: cros_ec_keyb - send 'scancodes' in addition to key events

Dwaipayan Ray (1):
      checkpatch: fix unescaped left brace

Fabio Estevam (1):
      usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to imx6ul

Filipe Manana (1):
      Btrfs: fix selftests failure due to uninitialized i_mode in test inodes

Fugang Duan (1):
      net: stmmac: delete the eee_ctrl_timer after napi disabled

Greg Kroah-Hartman (1):
      Linux 4.4.249

Hui Wang (1):
      ACPI: PNP: compare the string length in the matching_id()

Ian Abbott (1):
      staging: comedi: mf6x4: Fix AI end-of-conversion detection

Jing Xiangfeng (1):
      memstick: r592: Fix error return in r592_probe()

Johan Hovold (8):
      USB: serial: option: add interface-number sanity check to flag handling
      USB: serial: mos7720: fix parallel-port state restore
      USB: serial: keyspan_pda: fix dropped unthrottle interrupts
      USB: serial: keyspan_pda: fix write deadlock
      USB: serial: keyspan_pda: fix stalled writes
      USB: serial: keyspan_pda: fix write-wakeup use-after-free
      USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
      USB: serial: keyspan_pda: fix write unthrottling

Jonathan Cameron (1):
      iio:pressure:mpl3115: Force alignment of buffer

Jubin Zhong (1):
      PCI: Fix pci_slot_release() NULL pointer dereference

Keqian Zhu (1):
      clocksource/drivers/arm_arch_timer: Correct fault programming of CNTKCTL_EL1.EVNTI

Leon Romanovsky (1):
      RDMA/cm: Fix an attempt to use non-valid pointer when cleaning timewait

Li Jun (1):
      xhci: Give USB2 ports time to enter U3 in bus suspend

Luis Henriques (1):
      ceph: fix race in concurrent __ceph_remove_cap invocations

Lukas Wunner (4):
      spi: bcm2835aux: Fix use-after-free on unbind
      spi: Prevent adding devices below an unregistering controller
      media: netup_unidvb: Don't leak SPI master in probe error path
      spi: rb4xx: Don't leak SPI master in probe error path

Marek Szyprowski (1):
      extcon: max77693: Fix modalias string

Masami Hiramatsu (1):
      x86/kprobes: Restore BTF if the single-stepping is cancelled

Moshe Shemesh (1):
      net/mlx4_en: Avoid scheduling restart task if it is already running

Nathan Chancellor (1):
      spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Nathan Lynch (1):
      powerpc/pseries/hibernation: drop pseries_suspend_begin() from suspend ops

Neal Cardwell (1):
      tcp: fix cwnd-limited bug for TSO deferral where we send nothing

Necip Fazil Yildiran (1):
      MIPS: BCM47XX: fix kconfig dependency bug for BCM47XX_BCMA

NeilBrown (1):
      NFS: switch nfsiod to be an UNBOUND workqueue.

Nicolin Chen (1):
      soc/tegra: fuse: Fix index bug in get_process_id

Oleksij Rempel (1):
      Input: ads7846 - fix integer overflow on Rt calculation

Olga Kornievskaia (1):
      NFSv4.2: condition READDIR's mask for security label based on LSM state

Oliver Neukum (1):
      USB: add RESET_RESUME quirk for Snapscan 1212

Pali Rohár (3):
      cpufreq: highbank: Add missing MODULE_DEVICE_TABLE
      cpufreq: loongson1: Add missing MODULE_ALIAS
      cpufreq: scpi: Add missing MODULE_ALIAS

Pavel Machek (1):
      btrfs: fix return value mixup in btrfs_get_extent

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Qinglang Miao (6):
      media: solo6x10: fix missing snd_card_free in error handling case
      memstick: fix a double-free bug in memstick_check
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
      mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
      dm ioctl: fix error return code in target_message
      iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume

Qu Wenruo (2):
      btrfs: quota: Set rescan progress to (u64)-1 if we hit last leaf
      btrfs: scrub: Don't use inode page cache in scrub_handle_errored_block()

Randy Dunlap (1):
      scsi: bnx2i: Requires MMU

Sara Sharon (1):
      cfg80211: initialize rekey_data

Sean Young (1):
      media: sunxi-cir: ensure IR is handled when it is continuous

Sebastian Andrzej Siewior (1):
      orinoco: Move context allocation after processing the skb

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Simon Beginn (1):
      Input: goodix - add upside-down quirk for Teclast X98 Pro tablet

Stefan Haberland (2):
      s390/dasd: fix list corruption of pavgroup group list
      s390/dasd: fix list corruption of lcu list

Sven Eckelmann (1):
      mtd: parser: cmdline: Fix parsing of part-names with colons

Takashi Iwai (4):
      ALSA: usb-audio: Fix potential out-of-bounds shift
      ALSA: usb-audio: Fix control 'access overflow' errors from chmap
      ALSA: pcm: oss: Fix potential out-of-bounds shift
      ALSA: pcm: oss: Fix a few more UBSAN fixes

Thomas Gleixner (2):
      USB: sisusbvga: Make console support depend on BROKEN
      dm table: Remove BUG_ON(in_interrupt())

Timo Witte (1):
      platform/x86: acer-wmi: add automatic keyboard background light toggle key as KEY_LIGHTS_TOGGLE

Tom Rix (1):
      drm/gma500: fix double free of gma_connector

Vincent Stehlé (2):
      powerpc/ps3: use dma_mapping_error()
      net: korina: fix return value

Vineet Gupta (1):
      ARC: stack unwinding: don't assume non-current task is sleeping

Will McVicker (1):
      USB: gadget: f_rndis: fix bitrate for SuperSpeed and above

Yang Yingliang (2):
      drm/omap: dmm_tiler: fix return error code in omap_dmm_probe()
      speakup: fix uninitialized flush_lock

Yu Kuai (1):
      pinctrl: falcon: add missing put_device() call in pinctrl_falcon_probe()

Zhang Changzhong (2):
      net: bridge: vlan: fix error return code in __vlan_add()
      scsi: fnic: Fix error return code in fnic_probe()

Zhang Qilong (12):
      can: softing: softing_netdev_open(): fix error handling
      spi: img-spfi: fix reference leak in img_spfi_resume
      spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
      spi: tegra20-slink: fix reference leak in slink ops of tegra20
      spi: tegra20-sflash: fix reference leak in tegra_sflash_resume
      spi: tegra114: fix reference leak in tegra spi ops
      soc: ti: knav_qmss: fix reference leak in knav_queue_probe
      soc: ti: Fix reference imbalance in knav_dma_probe
      scsi: pm80xx: Fix error return in pm8001_pci_probe()
      usb: ehci-omap: Fix PM disable depth umbalance in ehci_hcd_omap_probe
      usb: oxu210hp-hcd: Fix memory leak in oxu_create
      clk: ti: Fix memleak in ti_fapll_synth_setup

Zhe Li (1):
      jffs2: Fix GC exit abnormally

Zheng Zengkai (1):
      perf record: Fix memory leak when using '--user-regs=?' to list registers

Zhihao Cheng (1):
      drivers: soc: ti: knav_qmss_queue: Fix error return code in knav_queue_probe

