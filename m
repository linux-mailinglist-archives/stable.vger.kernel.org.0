Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C51D3059C7
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhA0Lbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236699AbhA0L33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 06:29:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F6A20754;
        Wed, 27 Jan 2021 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611746927;
        bh=LF3OCE/GihQMkSEFxmmoP6SAJ8rzhSRbbzxV/QT8s6o=;
        h=From:To:Cc:Subject:Date:From;
        b=MLX+niMOT+EoV9IoEYjbEHCApg4gRW+9tV8wuhblWNPErqI0El9mU2UqbiGc4vY4g
         k/D3s9hCED1G1hl6HhdNvPpE3veegp/tJULtdKKB7egRnkYtWbusm/HZs6TwBBuUku
         XPghD4QqAtLNPW9uGZKq/1QCcviJOKWB+pt116eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.93
Date:   Wed, 27 Jan 2021 12:28:43 +0100
Message-Id: <161174692378@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.93 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt       |    4 
 Makefile                                              |    2 
 arch/arm/xen/enlighten.c                              |    2 
 arch/arm64/include/asm/atomic.h                       |   10 +-
 arch/powerpc/kernel/vmlinux.lds.S                     |   25 +----
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts   |    1 
 arch/riscv/configs/defconfig                          |    2 
 arch/riscv/kernel/time.c                              |    3 
 arch/sh/drivers/dma/Kconfig                           |    3 
 arch/x86/include/asm/fpu/api.h                        |   15 ++-
 arch/x86/include/asm/topology.h                       |    4 
 arch/x86/kernel/cpu/amd.c                             |    4 
 arch/x86/kernel/cpu/topology.c                        |    2 
 arch/x86/kernel/fpu/core.c                            |    9 +-
 arch/x86/lib/mmx_32.c                                 |   20 +++-
 arch/x86/xen/enlighten_hvm.c                          |   11 ++
 drivers/acpi/scan.c                                   |    2 
 drivers/base/core.c                                   |   17 +++
 drivers/clk/tegra/clk-tegra30.c                       |    2 
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h               |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |    2 
 drivers/gpu/drm/drm_atomic_helper.c                   |    2 
 drivers/gpu/drm/drm_syncobj.c                         |    8 +
 drivers/gpu/drm/i915/gt/intel_lrc.c                   |    3 
 drivers/gpu/drm/nouveau/dispnv50/disp.c               |    4 
 drivers/gpu/drm/nouveau/dispnv50/disp.h               |    2 
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c           |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c     |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c    |    8 -
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c      |   10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c      |   10 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c        |    6 -
 drivers/hid/hid-ids.h                                 |    1 
 drivers/hid/hid-input.c                               |    2 
 drivers/hid/hid-logitech-dj.c                         |    4 
 drivers/hid/hid-multitouch.c                          |    4 
 drivers/hwtracing/intel_th/pci.c                      |    5 +
 drivers/hwtracing/stm/heartbeat.c                     |    6 -
 drivers/i2c/busses/i2c-octeon-core.c                  |    2 
 drivers/i2c/busses/i2c-tegra-bpmp.c                   |    2 
 drivers/iio/dac/ad5504.c                              |    4 
 drivers/irqchip/irq-mips-cpu.c                        |    7 +
 drivers/lightnvm/core.c                               |    3 
 drivers/md/Kconfig                                    |    1 
 drivers/md/dm-integrity.c                             |    6 +
 drivers/md/dm-table.c                                 |   15 ++-
 drivers/mmc/core/queue.c                              |    4 
 drivers/mmc/host/sdhci-xenon.c                        |    7 +
 drivers/net/can/dev.c                                 |    4 
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c            |    8 -
 drivers/net/can/vxcan.c                               |    6 -
 drivers/net/dsa/b53/b53_common.c                      |    2 
 drivers/net/dsa/mv88e6xxx/global1_vtu.c               |    4 
 drivers/net/ethernet/mscc/ocelot.c                    |    4 
 drivers/net/ethernet/renesas/sh_eth.c                 |    4 
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c            |    2 
 drivers/pinctrl/pinctrl-ingenic.c                     |   24 ++---
 drivers/platform/x86/i2c-multi-instantiate.c          |   31 +++++-
 drivers/platform/x86/ideapad-laptop.c                 |   15 +++
 drivers/platform/x86/intel-vbtn.c                     |    6 -
 drivers/scsi/megaraid/megaraid_sas_base.c             |    6 -
 drivers/scsi/qedi/qedi_main.c                         |    4 
 drivers/scsi/sd.c                                     |    4 
 drivers/scsi/ufs/ufshcd.c                             |   11 --
 drivers/tty/serial/mvebu-uart.c                       |   10 ++
 drivers/tty/serial/sifive.c                           |    1 
 drivers/usb/gadget/udc/aspeed-vhub/epn.c              |    5 -
 drivers/usb/gadget/udc/bdc/Kconfig                    |    2 
 drivers/usb/gadget/udc/core.c                         |   13 ++
 drivers/usb/host/ehci-hcd.c                           |   12 ++
 drivers/usb/host/ehci-hub.c                           |    3 
 drivers/usb/host/xhci-ring.c                          |    2 
 drivers/usb/host/xhci-tegra.c                         |    7 +
 drivers/xen/events/events_base.c                      |   10 --
 drivers/xen/platform-pci.c                            |    1 
 drivers/xen/xenbus/xenbus.h                           |    1 
 drivers/xen/xenbus/xenbus_comms.c                     |    8 -
 drivers/xen/xenbus/xenbus_probe.c                     |   81 ++++++++++++++----
 fs/btrfs/block-group.c                                |    3 
 fs/btrfs/extent-tree.c                                |   10 ++
 fs/btrfs/send.c                                       |   15 +++
 fs/btrfs/volumes.c                                    |    2 
 fs/cifs/transport.c                                   |    4 
 include/asm-generic/bitops/atomic.h                   |    6 -
 include/net/inet_connection_sock.h                    |    3 
 include/xen/xenbus.h                                  |    2 
 mm/kasan/init.c                                       |   23 ++---
 net/core/dev.c                                        |    5 +
 net/core/skbuff.c                                     |    6 +
 net/ipv4/inet_connection_sock.c                       |    1 
 net/ipv4/netfilter/ipt_rpfilter.c                     |    2 
 net/ipv4/tcp.c                                        |    1 
 net/ipv4/tcp_input.c                                  |    1 
 net/ipv4/tcp_ipv4.c                                   |   25 ++---
 net/ipv4/tcp_output.c                                 |    1 
 net/ipv4/tcp_timer.c                                  |   14 +--
 net/ipv4/udp.c                                        |    3 
 net/ipv6/addrconf.c                                   |    3 
 net/sched/cls_tcindex.c                               |    8 +
 net/sched/sch_api.c                                   |    3 
 sound/core/seq/oss/seq_oss_synth.c                    |    3 
 sound/pci/hda/patch_via.c                             |    1 
 sound/soc/intel/boards/haswell.c                      |    1 
 tools/testing/selftests/net/fib_tests.sh              |    1 
 104 files changed, 488 insertions(+), 222 deletions(-)

Alex Leibovich (1):
      mmc: sdhci-xenon: fix 1.8v regulator stabilization

Alexander Lobakin (1):
      skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Alexander Shishkin (1):
      intel_th: pci: Add Alder Lake-P support

Andy Lutomirski (2):
      x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state
      x86/mmx: Use KFPU_387 for MMX string operations

Anthony Iliopoulos (1):
      dm integrity: select CRYPTO_SKCIPHER

Ariel Marcovitch (1):
      powerpc: Fix alignment bug within the init sections

Arnd Bergmann (2):
      arm64: make atomic helpers __always_inline
      scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Ben Skeggs (5):
      drm/nouveau/bios: fix issue shadowing expansion ROMs
      drm/nouveau/privring: ack interrupts the same way as RM
      drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields
      drm/nouveau/mmu: fix vram heap sizing
      drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0

Billy Tsai (1):
      pinctrl: aspeed: g6: Fix PWMG0 pinctrl setting

Borislav Petkov (1):
      x86/topology: Make __max_die_per_package available unconditionally

Can Guo (1):
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Cezary Rojewski (1):
      ASoC: Intel: haswell: Add missing pm_ops

Chris Wilson (1):
      drm/i915/gt: Prevent use of engine->wa_ctx after error

Damien Le Moal (2):
      riscv: Fix kernel time_init()
      riscv: Fix sifive serial driver

Dan Carpenter (1):
      net: dsa: b53: fix an off by one in checking "vlan->vid"

Daniel Vetter (1):
      drm/syncobj: Fix use-after-free

David Woodhouse (2):
      xen: Fix event channel callback via INTX/GSI
      x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery

Enke Chen (1):
      tcp: fix TCP_USER_TIMEOUT with zero window

Eric Dumazet (3):
      net_sched: avoid shift-out-of-bounds in tcindex_set_parms()
      net_sched: reject silly cell_log in qdisc_get_rtab()
      tcp: do not mess with cloned skbs in tcp_add_backlog()

Eugene Korenevsky (1):
      ehci: fix EHCI host controller initialization sequence

Ewan D. Milne (1):
      scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Filipe Laíns (1):
      HID: logitech-dj: add the G602 receiver

Filipe Manana (1):
      btrfs: send: fix invalid clone operations when cloning from the same file and root

Geert Uytterhoeven (1):
      sh_eth: Fix power down vs. is_opened flag ordering

Greg Kroah-Hartman (1):
      Linux 5.4.93

Guillaume Nault (2):
      netfilter: rpfilter: mask ecn bits before fib lookup
      udp: mask TOS bits in udp_v4_early_demux()

Hangbin Liu (1):
      selftests: net: fib_tests: remove duplicate log test

Hannes Reinecke (1):
      dm: avoid filesystem lookup in dm_get_dev_t()

Hans de Goede (2):
      ACPI: scan: Make acpi_bus_get_device() clear return pointer on error
      platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list

Heikki Krogerus (1):
      platform/x86: i2c-multi-instantiate: Don't create platform device for INT3515 ACPI nodes

JC Kuo (1):
      xhci: tegra: Delay for disabling LFPS detector

Jiaxun Yang (1):
      platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634

Josef Bacik (3):
      btrfs: don't get an EINTR during drop_snapshot for reloc
      btrfs: fix lockdep splat in btrfs_recover_relocation
      btrfs: don't clear ret in btrfs_start_dirty_block_groups

Kai-Heng Feng (1):
      HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device

Lars-Peter Clausen (1):
      iio: ad5504: Fix setting power-down state

Lecopzer Chen (2):
      kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow
      kasan: fix incorrect arguments passing in kasan_add_zero_shadow

Longfang Liu (1):
      USB: ehci: fix an interrupt calltrace error

Mathias Kresin (1):
      irqchip/mips-cpu: Set IPI domain parent chip

Mathias Nyman (1):
      xhci: make sure TRB is fully written before giving it to the controller

Matteo Croce (2):
      ipv6: create multicast route with RTPROT_KERNEL
      ipv6: set multicast flag on the multicast route

Mikko Perttunen (1):
      i2c: bpmp-tegra: Ignore unknown I2C_M flags

Mikulas Patocka (1):
      dm integrity: fix a crash if "recalculate" used without "internal_hash"

Necip Fazil Yildiran (1):
      sh: dma: fix kconfig dependency for G2_DMA

Nilesh Javali (1):
      scsi: qedi: Correct max length of CHAP secret

Pali Rohár (1):
      serial: mvebu-uart: fix tx lost characters at power off

Pan Bian (2):
      drm/atomic: put state on error path
      lightnvm: fix memory leak when submit fails

Patrik Jakobsson (1):
      usb: bdc: Make bdc pci driver depend on BROKEN

Paul Cercueil (1):
      pinctrl: ingenic: Fix JZ4760 support

Peter Collingbourne (1):
      mmc: core: don't initialize block size from ext_csd if not present

Peter Geis (1):
      clk: tegra30: Add hda clock default rates to clock driver

Rafael J. Wysocki (1):
      driver core: Extend device_is_dependent()

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext

Ronnie Sahlberg (1):
      cifs: do not fail __smb_send_rqst if non-fatal signals are pending

Ryan Chen (1):
      usb: gadget: aspeed: fix stop dma register setting.

Sagar Shrikant Kadam (2):
      dts: phy: fix missing mdio device and probe failure of vsc8541-01 device
      riscv: defconfig: enable gpio support for HiFive Unleashed

Seth Miller (1):
      HID: Ignore battery for Elan touchscreen on ASUS UX550

Takashi Iwai (2):
      ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
      ALSA: hda/via: Add minimum mute flag

Tariq Toukan (1):
      net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Thinh Nguyen (1):
      usb: udc: core: Use lock when write to soft_connect

Victor Zhao (1):
      drm/amdgpu/psp: fix psp gfx ctrl cmds

Vincent Mailhol (3):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug
      can: peak_usb: fix use after free bugs

Vladimir Oltean (1):
      net: mscc: ocelot: allow offloading of bridge on top of LAG

Wang Hui (1):
      stm class: Fix module init return on allocation failure

Wayne Lin (1):
      drm/amd/display: Fix to be able to stop crc calculation

Wolfram Sang (1):
      i2c: octeon: check correct size of maximum RECV_LEN packet

Yazen Ghannam (1):
      x86/cpu/amd: Set __max_die_per_package on AMD

Youling Tang (1):
      powerpc: Use the common INIT_DATA_SECTION macro in vmlinux.lds.S

