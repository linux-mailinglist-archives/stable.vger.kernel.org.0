Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BAA45EC65
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 12:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbhKZLXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 06:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238200AbhKZLVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 06:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F265A6069B;
        Fri, 26 Nov 2021 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637925484;
        bh=Iu7nAuOfJuR8NbgEuyk4fIDJhUHqMycMb2Kl1nIBMY4=;
        h=From:To:Cc:Subject:Date:From;
        b=V8LyftIvnDZbn1aiz0RRz7toDGyXlNMUe6pUfpt0fAnLpb+diQ0BLF0w+0nahq0Oc
         xbKd+RloYH9n4AIT6tuqz1KR375mxa9E73ZGPSp/am4LT8YYgDuyZLtych4x5qayJj
         ytQ/B6EH9ZQFMAgegcgunNWZ9uclcAOdCZ5uVsDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.293
Date:   Fri, 26 Nov 2021 12:17:57 +0100
Message-Id: <163792547714292@kroah.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.293 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/arm/Makefile                                    |   22 +-
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi            |    2 
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi    |    2 
 arch/arm/kernel/stacktrace.c                         |    3 
 arch/arm/mm/Kconfig                                  |    2 
 arch/hexagon/lib/io.c                                |    4 
 arch/ia64/Kconfig.debug                              |    2 
 arch/m68k/Kconfig.machine                            |    1 
 arch/mips/Kconfig                                    |    3 
 arch/mips/bcm63xx/clk.c                              |    6 
 arch/mips/lantiq/xway/dma.c                          |   14 +
 arch/mips/sni/time.c                                 |    4 
 arch/parisc/kernel/entry.S                           |    4 
 arch/parisc/kernel/smp.c                             |   19 ++
 arch/parisc/mm/init.c                                |    4 
 arch/powerpc/boot/dts/charon.dts                     |    2 
 arch/powerpc/boot/dts/digsy_mtc.dts                  |    2 
 arch/powerpc/boot/dts/lite5200.dts                   |    2 
 arch/powerpc/boot/dts/lite5200b.dts                  |    2 
 arch/powerpc/boot/dts/media5200.dts                  |    2 
 arch/powerpc/boot/dts/mpc5200b.dtsi                  |    2 
 arch/powerpc/boot/dts/o2d.dts                        |    2 
 arch/powerpc/boot/dts/o2d.dtsi                       |    2 
 arch/powerpc/boot/dts/o2dnt2.dts                     |    2 
 arch/powerpc/boot/dts/o3dnt.dts                      |    2 
 arch/powerpc/boot/dts/pcm032.dts                     |    2 
 arch/powerpc/boot/dts/tqm5200.dts                    |    2 
 arch/powerpc/sysdev/dcr-low.S                        |    2 
 arch/sh/Kconfig.debug                                |    1 
 arch/sh/include/asm/sfp-machine.h                    |    8 +
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                   |    5 
 arch/x86/include/asm/page_64_types.h                 |    2 
 arch/x86/kernel/irq.c                                |    4 
 crypto/pcrypt.c                                      |   12 +
 drivers/acpi/acpica/acglobal.h                       |    2 
 drivers/acpi/acpica/hwesleep.c                       |    8 -
 drivers/acpi/acpica/hwsleep.c                        |   11 -
 drivers/acpi/acpica/hwxfsleep.c                      |    7 
 drivers/acpi/battery.c                               |    2 
 drivers/android/binder.c                             |   23 +--
 drivers/ata/libata-eh.c                              |    8 +
 drivers/cpuidle/sysfs.c                              |    5 
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c        |    7 
 drivers/dma/at_xdmac.c                               |    2 
 drivers/edac/sb_edac.c                               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c       |    1 
 drivers/gpu/drm/msm/msm_gem.c                        |    4 
 drivers/gpu/drm/udl/udl_connector.c                  |    2 
 drivers/hv/hyperv_vmbus.h                            |    1 
 drivers/hwmon/pmbus/lm25066.c                        |   23 +++
 drivers/iio/dac/ad5446.c                             |    9 +
 drivers/infiniband/hw/mlx4/qp.c                      |    4 
 drivers/input/mouse/elantech.c                       |   13 +
 drivers/input/serio/i8042-x86ia64io.h                |   14 +
 drivers/irqchip/irq-s3c24xx.c                        |   22 ++
 drivers/media/i2c/mt9p031.c                          |   28 +++
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c   |   27 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc.c             |    2 
 drivers/media/radio/si470x/radio-si470x-i2c.c        |    2 
 drivers/media/radio/si470x/radio-si470x-usb.c        |    2 
 drivers/media/rc/ite-cir.c                           |    2 
 drivers/media/rc/mceusb.c                            |    1 
 drivers/media/usb/dvb-usb/az6027.c                   |    1 
 drivers/media/usb/dvb-usb/dibusb-common.c            |    2 
 drivers/media/usb/uvc/uvc_v4l2.c                     |    7 
 drivers/memory/fsl_ifc.c                             |   13 -
 drivers/memstick/core/ms_block.c                     |    2 
 drivers/memstick/host/jmb38x_ms.c                    |    2 
 drivers/memstick/host/r592.c                         |    8 -
 drivers/mmc/host/Kconfig                             |    2 
 drivers/mmc/host/dw_mmc.c                            |    3 
 drivers/net/bonding/bond_sysfs_slave.c               |   36 +---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h |    4 
 drivers/net/ethernet/ti/davinci_emac.c               |   16 +-
 drivers/net/tun.c                                    |    5 
 drivers/net/vmxnet3/vmxnet3_drv.c                    |    1 
 drivers/net/wireless/ath/ath6kl/usb.c                |    7 
 drivers/net/wireless/ath/ath9k/main.c                |    4 
 drivers/net/wireless/ath/dfs_pattern_detector.c      |   10 -
 drivers/net/wireless/ath/wcn36xx/main.c              |    4 
 drivers/net/wireless/b43/phy_g.c                     |    2 
 drivers/net/wireless/b43legacy/radio.c               |    2 
 drivers/net/wireless/iwlwifi/mvm/utils.c             |    3 
 drivers/net/wireless/libertas/if_usb.c               |    2 
 drivers/net/wireless/libertas_tf/if_usb.c            |    2 
 drivers/net/wireless/mwifiex/11n.c                   |    5 
 drivers/net/wireless/mwifiex/pcie.c                  |    8 +
 drivers/net/wireless/mwifiex/usb.c                   |   16 ++
 drivers/net/wireless/mwl8k.c                         |    2 
 drivers/net/xen-netfront.c                           |    8 +
 drivers/nfc/pn533.c                                  |    6 
 drivers/pci/msi.c                                    |   24 +--
 drivers/pci/quirks.c                                 |    1 
 drivers/platform/x86/hp_accel.c                      |    2 
 drivers/platform/x86/thinkpad_acpi.c                 |    2 
 drivers/platform/x86/wmi.c                           |    9 +
 drivers/power/max17042_battery.c                     |    8 -
 drivers/power/rt5033_battery.c                       |    2 
 drivers/scsi/advansys.c                              |    4 
 drivers/scsi/csiostor/csio_lnode.c                   |    2 
 drivers/scsi/dc395x.c                                |    1 
 drivers/scsi/lpfc/lpfc_sli.c                         |    1 
 drivers/scsi/qla2xxx/qla_gbl.h                       |    2 
 drivers/scsi/qla2xxx/qla_mr.c                        |   23 ---
 drivers/scsi/qla2xxx/qla_os.c                        |   27 ---
 drivers/sh/maple/maple.c                             |    5 
 drivers/spi/spi-pl022.c                              |    5 
 drivers/target/target_core_alua.c                    |    1 
 drivers/target/target_core_device.c                  |    2 
 drivers/target/target_core_internal.h                |    1 
 drivers/target/target_core_transport.c               |   76 +++++++---
 drivers/tty/serial/8250/8250_dw.c                    |    2 
 drivers/tty/tty_buffer.c                             |    3 
 drivers/usb/chipidea/core.c                          |   21 ++
 drivers/usb/gadget/legacy/hid.c                      |    4 
 drivers/usb/host/max3421-hcd.c                       |   25 ---
 drivers/usb/host/ohci-tmio.c                         |    2 
 drivers/usb/host/xhci-hub.c                          |    3 
 drivers/usb/misc/iowarrior.c                         |    8 -
 drivers/usb/musb/tusb6010.c                          |    5 
 drivers/usb/serial/keyspan.c                         |   15 --
 drivers/video/console/sticon.c                       |   12 -
 drivers/video/fbdev/chipsfb.c                        |    2 
 drivers/watchdog/f71808e_wdt.c                       |    4 
 drivers/xen/xen-pciback/conf_space_capability.c      |    2 
 fs/btrfs/async-thread.c                              |   14 +
 fs/btrfs/tree-log.c                                  |    4 
 fs/jfs/jfs_mount.c                                   |   51 ++----
 fs/ocfs2/file.c                                      |    8 -
 fs/quota/quota_tree.c                                |   15 ++
 fs/tracefs/inode.c                                   |    3 
 include/linux/libata.h                               |    2 
 include/linux/lsm_hooks.h                            |   32 ++--
 include/linux/security.h                             |   28 +--
 include/net/llc.h                                    |    4 
 include/target/target_core_base.h                    |    6 
 include/uapi/linux/pci_regs.h                        |    6 
 kernel/power/swap.c                                  |    5 
 kernel/sched/core.c                                  |    3 
 kernel/signal.c                                      |   17 --
 lib/decompress_unxz.c                                |    2 
 lib/xz/xz_dec_lzma2.c                                |   21 ++
 lib/xz/xz_dec_stream.c                               |    6 
 mm/oom_kill.c                                        |    3 
 mm/slab.h                                            |    2 
 net/batman-adv/bat_iv_ogm.c                          |    4 
 net/batman-adv/bridge_loop_avoidance.c               |  141 +++++++++++++++----
 net/batman-adv/bridge_loop_avoidance.h               |    4 
 net/batman-adv/debugfs.c                             |    1 
 net/batman-adv/fragmentation.c                       |   41 +++--
 net/batman-adv/hard-interface.c                      |    3 
 net/batman-adv/main.c                                |   44 ++++-
 net/batman-adv/multicast.c                           |   31 ++++
 net/batman-adv/multicast.h                           |   15 ++
 net/batman-adv/network-coding.c                      |    4 
 net/batman-adv/soft-interface.c                      |   31 ++--
 net/batman-adv/translation-table.c                   |   10 -
 net/bluetooth/l2cap_sock.c                           |   10 +
 net/bluetooth/sco.c                                  |   24 ++-
 net/core/stream.c                                    |    3 
 net/netfilter/nfnetlink_queue.c                      |    2 
 net/nfc/core.c                                       |   32 ++--
 net/nfc/nci/core.c                                   |   11 -
 net/vmw_vsock/af_vsock.c                             |    2 
 net/wireless/util.c                                  |    1 
 security/security.c                                  |   14 -
 security/selinux/hooks.c                             |   31 +---
 security/smack/smackfs.c                             |   11 -
 sound/core/oss/mixer_oss.c                           |   43 ++++-
 sound/core/timer.c                                   |   17 +-
 sound/isa/gus/gus_dma.c                              |    2 
 sound/soc/soc-dapm.c                                 |   29 +++
 sound/synth/emux/emux.c                              |    2 
 sound/usb/6fire/comm.c                               |    2 
 sound/usb/6fire/firmware.c                           |    6 
 sound/usb/line6/driver.c                             |   12 -
 sound/usb/line6/driver.h                             |    2 
 sound/usb/line6/toneport.c                           |    2 
 sound/usb/misc/ua101.c                               |    4 
 180 files changed, 1121 insertions(+), 577 deletions(-)

Ahmad Fatoum (1):
      watchdog: f71808e_wdt: fix inaccurate report in WDIOC_GETTIMEOUT

Aleksander Jan Bajkowski (2):
      MIPS: lantiq: dma: add small delay after reset
      MIPS: lantiq: dma: reset correct number of channel

Anant Thazhemadam (1):
      media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()

Anatolij Gustschin (1):
      powerpc/5200: dts: fix memory node unit name

André Almeida (1):
      ACPI: battery: Accept charges over the design capacity as full

Andy Shevchenko (1):
      serial: 8250_dw: Drop wrong use of ACPI_PTR()

Anel Orazgaliyeva (1):
      cpuidle: Fix kobject memory leaks in error paths

Arnd Bergmann (4):
      hyperv/vmbus: include linux/bitops.h
      ARM: 9136/1: ARMv7-M uses BE-8, not BE-32
      memstick: avoid out-of-range warning
      ARM: 9156/1: drop cc-option fallbacks for architecture selection

Austin Kim (1):
      ALSA: synth: missing check for possible NULL after the call to kstrdup

Barnabás Pőcze (1):
      platform/x86: wmi: do not fail if disabling fails

Bart Van Assche (1):
      MIPS: sni: Fix the build

Chengfeng Ye (2):
      nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
      ALSA: gus: fix null pointer dereference on pointer block

Christian Löhle (1):
      mmc: dw_mmc: Dont wait for DRTO on Write RSP error

Christophe JAILLET (1):
      platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Christophe Leroy (1):
      video: fbdev: chipsfb: use memset_io() instead of memset()

Claudiu Beznea (1):
      dmaengine: at_xdmac: fix AT_XDMAC_CC_PERID() macro

Damien Le Moal (1):
      libata: fix read log timeout value

Dan Carpenter (6):
      b43legacy: fix a lower bounds test
      b43: fix a lower bounds test
      memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
      drm/msm: uninitialized variable in msm_gem_import()
      usb: gadget: hid: fix error code in do_config()
      scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()

Daniel Jordan (1):
      crypto: pcrypt - Delay write to padata->info

Dirk Bender (1):
      media: mt9p031: Fix corrupted frame after restarting stream

Dongli Zhang (2):
      xen/netfront: stop tx queues during live migration
      vmxnet3: do not stop tx queues after netif_device_detach()

Dongliang Mu (2):
      JFS: fix memleak in jfs_mount
      memory: fsl_ifc: fix leak of irq and nand_irq in fsl_ifc_ctrl_probe

Eiichi Tsukata (1):
      vsock: prevent unnecessary refcnt inc for nonblocking connect

Eric Badger (1):
      EDAC/sb_edac: Fix top-of-high-memory value for Broadwell/Haswell

Eric Dumazet (1):
      llc: fix out-of-bound array index in llc_sk_dev_hash()

Eric W. Biederman (1):
      signal: Remove the bogus sigkill_pending in ptrace_stop

Filipe Manana (1):
      btrfs: fix lost error handling when replaying directory deletes

Florian Westphal (1):
      netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Giovanni Cabiddu (1):
      crypto: qat - detect PFVF collision after ACK

Greg Kroah-Hartman (1):
      Linux 4.4.293

Guanghui Feng (1):
      tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Guo Zhi (1):
      scsi: advansys: Fix kernel pointer leak

Helge Deller (1):
      parisc: Fix ptrace check on syscall return

Henrik Grimler (1):
      power: supply: max17042_battery: use VFSOC for capacity when no rsns

Huang Guobin (1):
      bonding: Fix a use-after-free problem when bond_sysfs_slave_add() failed

Ingmar Klein (1):
      PCI: Mark Atheros QCA6174 to avoid bus reset

Jackie Liu (1):
      ARM: s3c: irq-s3c24xx: Fix return value check for s3c24xx_init_intc()

Jakob Hauser (1):
      power: supply: rt5033_battery: Change voltage values to µV

Jakub Kicinski (1):
      net: stream: don't purge sk_error_queue in sk_stream_kill_queues()

James Smart (1):
      scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Jan Kara (1):
      ocfs2: fix data corruption on truncate

Johan Hovold (9):
      ALSA: ua101: fix division by zero at probe
      ALSA: 6fire: fix control and bulk message timeouts
      ALSA: line6: fix control and interrupt message timeouts
      mwifiex: fix division by zero in fw download path
      ath6kl: fix division by zero in send path
      ath6kl: fix control-message timeout
      USB: iowarrior: fix control-message timeouts
      USB: chipidea: fix interrupt deadlock
      drm/udl: fix control-message timeout

Johannes Berg (1):
      iwlwifi: mvm: disable RX-diversity in powersave

Jonas Dreßler (2):
      mwifiex: Read a PCI register after writing the TX ring write pointer
      mwifiex: Send DELBA requests according to spec

Kees Cook (1):
      media: si470x: Avoid card name truncation

Lasse Collin (2):
      lib/xz: Avoid overlapping memcpy() with invalid input with in-place decompression
      lib/xz: Validate the value before assigning it to an enum variable

Leon Romanovsky (1):
      RDMA/mlx4: Return missed an error if device doesn't support steering

Lin Ma (2):
      NFC: reorganize the functions in nci_request
      NFC: reorder the logic in nfc_{un,}register_device

Linus Lüssing (5):
      ath9k: Fix potential interrupt storm on queue reset
      batman-adv: Fix multicast TT issues with bogus ROAM flags
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
      batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Loic Poulain (1):
      wcn36xx: Fix HT40 capability for 2Ghz band

Lu Wei (1):
      maple: fix wrong return value of maple_bus_init().

Masami Hiramatsu (1):
      ARM: clang: Do not rely on lr register for stacktrace

Mathias Nyman (1):
      xhci: Fix USB 3.1 enumeration issues by increasing roothub power-on-good delay

Maxim Kiselev (1):
      net: davinci_emac: Fix interrupt pacing disable

Michael Ellerman (1):
      powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Mike Christie (2):
      scsi: target: Fix ordered tag handling
      scsi: target: Fix alua_tg_pt_gps_count tracking

Nathan Chancellor (2):
      platform/x86: thinkpad_acpi: Fix bitwise vs. logical warning
      hexagon: export raw I/O routines for modules

Nguyen Dinh Phi (1):
      cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Nick Desaulniers (1):
      sh: check return code of request_irq

Nicolas Dichtel (1):
      tun: fix bonding active backup with arp monitoring

Nikolay Borisov (1):
      btrfs: fix memory ordering between normal and ordered work functions

Pali Rohár (1):
      PCI: Add PCI_EXP_DEVCTL_PAYLOAD_* macros

Pavel Skripkin (4):
      ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
      media: dvb-usb: fix ununit-value in az6027_rc_query
      net: batman-adv: fix error handling
      net: bnx2x: fix variable dereferenced before check

Pawan Gupta (1):
      smackfs: Fix use-after-free in netlbl_catmap_walk()

Pekka Korpinen (1):
      iio: dac: ad5446: Fix ad5622_write() return value

Peter Zijlstra (1):
      x86: Increase exception stack sizes

Phoenix Huang (1):
      Input: elantench - fix misreporting trackpoint coordinates

Quinn Tran (1):
      scsi: qla2xxx: Turn off target reset during issue_lip

Rafael J. Wysocki (1):
      ACPICA: Avoid evaluating methods too early during system resume

Rajat Asthana (1):
      media: mceusb: return without resubmitting URB in case of -EPROTO error.

Randy Dunlap (7):
      mmc: winbond: don't build on M68K
      ia64: don't do IA64_CMPXCHG_DEBUG without CONFIG_PRINTK
      m68k: set a default value for MEMORY_RESERVE
      sh: fix kconfig unmet dependency warning for FRAME_POINTER
      sh: define __BIG_ENDIAN for math-emu
      mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set
      mips: bcm63xx: add support for clk_get_parent()

Ricardo Ribalda (1):
      media: uvcvideo: Set capability in s_param

Roger Quadros (1):
      ARM: dts: omap: fix gpmc,mux-add-data type

Rustam Kovhaev (1):
      mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Sean Christopherson (1):
      x86/irq: Ensure PI wakeup handler is unregistered before module unload

Sean Young (1):
      media: ite-cir: IR receiver stop working after receive overflow

Sebastian Krzyszkowiak (1):
      power: supply: max17042_battery: Prevent int underflow in set_soc_threshold

Steven Rostedt (VMware) (1):
      tracefs: Have tracefs directories not set OTH permission bits by default

Sven Eckelmann (6):
      batman-adv: Keep fragments equally sized
      batman-adv: Prevent duplicated softif_vlan entry
      batman-adv: Consider fragmentation for needed_headroom
      batman-adv: Reserve needed_*room for fragments
      batman-adv: Don't always reallocate the fragmentation skb head
      batman-adv: Avoid WARN_ON timing related checks

Sven Schnelle (4):
      parisc: fix warning in flush_tlb_all
      parisc/kgdb: add kgdb_roundup() to make kgdb work with idle polling
      parisc/entry: fix trace test in syscall exit path
      parisc/sticon: fix reverse colors

Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

Takashi Iwai (5):
      Input: i8042 - Add quirk for Fujitsu Lifebook T725
      ALSA: timer: Unconditionally unlink slave instances, too
      ALSA: mixer: oss: Fix racy access to slots
      Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()
      ASoC: DAPM: Cover regression by kctl change notification fix

Tetsuo Handa (2):
      smackfs: use __GFP_NOFAIL for smk_cipso_doi()
      smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi

Thomas Gleixner (1):
      PCI/MSI: Destroy sysfs before freeing entries

Thomas Perrot (1):
      spi: spl022: fix Microwire full duplex mode

Todd Kjos (2):
      binder: use euid from cred instead of using task
      binder: use cred instead of task for selinux checks

Tong Zhang (1):
      scsi: dc395: Fix error case unwinding

Tuo Li (2):
      media: s5p-mfc: fix possible null-pointer dereference in s5p_mfc_probe()
      ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Uwe Kleine-König (1):
      usb: max-3421: Use driver data instead of maintaining a list of bound devices

Vasily Averin (1):
      mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Vincent Donnefort (1):
      sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Wang Hai (3):
      USB: serial: keyspan: fix memleak on probe errors
      libertas_tf: Fix possible memory leak in probe and disconnect
      libertas: Fix possible memory leak in probe and disconnect

Wang ShaoBo (1):
      Bluetooth: fix use-after-free error in lock_sock_nested()

Wang Wensheng (1):
      ALSA: timer: Fix use-after-free problem

Yang Yingliang (2):
      usb: musb: tusb6010: check return value after calling platform_get_resource()
      usb: host: ohci-tmio: check return value after calling platform_get_resource()

Ye Bin (1):
      PM: hibernate: Get block device exclusively in swsusp_check()

YueHaibing (1):
      xen-pciback: Fix return in pm_ctrl_init()

Zev Weiss (1):
      hwmon: (pmbus/lm25066) Add offset coefficients

Zhang Yi (2):
      quota: check block number when reading the block in quota file
      quota: correct error number in free_dqentry()

Zheyu Ma (3):
      media: netup_unidvb: handle interrupt properly according to the firmware
      memstick: r592: Fix a UAF bug when removing the driver
      mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

hongao (1):
      drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

