Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5711812B4B
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 12:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfECKJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 06:09:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56406 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727485AbfECKJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 06:09:39 -0400
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hMV7z-0000Et-43; Fri, 03 May 2019 11:09:34 +0100
Date:   Fri, 3 May 2019 11:09:15 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Message-ID: <lsq.1556878112.329017354@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e3b2p4nv2qz7a3oz"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        shadbolt.decadent.org.uk
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=NO_RELAYS,
        T_FILL_THIS_FORM_SHORT autolearn=disabled version=3.4.2
Subject: Linux 3.16.66
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--e3b2p4nv2qz7a3oz
Content-Type: multipart/mixed; boundary="p355lqk3xfcokp2m"
Content-Disposition: inline


--p355lqk3xfcokp2m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.66 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.16.65 is attached to this message.

Ben.

------------

 Makefile                                           |   2 +-
 arch/alpha/mm/fault.c                              |   2 +-
 arch/arc/kernel/head.S                             |   4 +-
 arch/arc/kernel/setup.c                            |  88 ++++++++++----
 arch/arc/kernel/signal.c                           |  39 +++---
 arch/arc/kernel/troubleshoot.c                     |  27 ++---
 arch/arc/mm/fault.c                                |  13 +-
 arch/arm/boot/dts/kirkwood-dnskw.dtsi              |   4 +-
 arch/arm/mach-iop32x/n2100.c                       |   3 +-
 arch/arm/plat-pxa/ssp.c                            |   3 -
 arch/arm64/include/asm/signal32.h                  |  11 +-
 arch/arm64/kernel/signal.c                         |  48 ++++----
 arch/arm64/kernel/signal32.c                       |  14 +--
 arch/avr32/kernel/signal.c                         |  43 +++----
 arch/blackfin/kernel/signal.c                      |  39 +++---
 arch/c6x/kernel/signal.c                           |  43 +++----
 arch/cris/arch-v10/kernel/signal.c                 |  79 +++++-------
 arch/cris/arch-v32/kernel/signal.c                 |  77 +++++-------
 arch/frv/kernel/signal.c                           |  99 +++++++--------
 arch/hexagon/kernel/signal.c                       |  45 +++----
 arch/ia64/kernel/signal.c                          |  46 ++++---
 arch/m32r/kernel/signal.c                          |  47 ++++----
 arch/m68k/kernel/signal.c                          |  63 ++++------
 arch/microblaze/kernel/signal.c                    |  48 +++-----
 arch/mips/include/asm/abi.h                        |  10 +-
 arch/mips/kernel/process.c                         |   7 +-
 arch/mips/kernel/signal-common.h                   |   2 +-
 arch/mips/kernel/signal.c                          |  72 +++++------
 arch/mips/kernel/signal32.c                        |  39 +++---
 arch/mips/kernel/signal_n32.c                      |  20 ++--
 arch/mips/pci/msi-octeon.c                         |   4 +-
 arch/mips/pci/pci-octeon.c                         |  10 +-
 arch/mn10300/kernel/signal.c                       |  89 ++++++--------
 arch/parisc/kernel/signal.c                        |  58 ++++-----
 arch/powerpc/kernel/signal.c                       |  41 ++-----
 arch/powerpc/kernel/signal.h                       |  14 +--
 arch/powerpc/kernel/signal_32.c                    |  36 +++---
 arch/powerpc/kernel/signal_64.c                    |  28 ++---
 arch/s390/include/asm/mmu_context.h                |  12 +-
 arch/s390/kernel/compat_signal.c                   |  79 ++++++------
 arch/s390/kernel/early.c                           |   4 +-
 arch/s390/kernel/entry.h                           |   4 +-
 arch/s390/kernel/setup.c                           |   2 +
 arch/s390/kernel/signal.c                          |  78 +++++-------
 arch/s390/kernel/smp.c                             |   4 +
 arch/score/kernel/signal.c                         |  43 +++----
 arch/sh/kernel/signal_32.c                         |  79 +++++-------
 arch/sh/kernel/signal_64.c                         |  82 +++++--------
 arch/tile/include/asm/compat.h                     |   3 +-
 arch/tile/kernel/compat_signal.c                   |  29 ++---
 arch/tile/kernel/signal.c                          |  54 ++++-----
 arch/um/include/shared/frame_kern.h                |  12 +-
 arch/um/kernel/signal.c                            |  27 ++---
 arch/unicore32/kernel/signal.c                     |  51 ++++----
 arch/x86/boot/compressed/aslr.c                    |   4 +-
 arch/x86/ia32/ia32_aout.c                          |   6 +-
 arch/x86/include/asm/uaccess.h                     |   7 +-
 arch/x86/kernel/cpu/perf_event.c                   |   9 ++
 arch/x86/kernel/cpu/perf_event.h                   |  21 ++++
 arch/x86/kernel/cpu/perf_event_intel.c             |   9 ++
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   4 +-
 arch/x86/kvm/vmx.c                                 |   7 +-
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/um/signal.c                               |  45 ++++---
 arch/xtensa/kernel/signal.c                        |  43 +++----
 crypto/authenc.c                                   |  14 ++-
 drivers/acpi/power.c                               |  22 ++++
 drivers/ata/libata-core.c                          |   1 +
 drivers/block/rbd.c                                |   9 +-
 drivers/char/Kconfig                               |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   6 +
 drivers/char/mwave/mwavedd.c                       |   7 ++
 drivers/dma/bcm2835-dma.c                          | 124 +++++++++++------=
--
 drivers/dma/dmatest.c                              |  30 ++---
 drivers/dma/imx-dma.c                              |   8 +-
 drivers/gpu/drm/drm_fb_helper.c                    | 133 ++++++++++++-----=
----
 drivers/gpu/drm/drm_modes.c                        |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   2 +-
 drivers/hv/hyperv_vmbus.h                          |   5 +-
 drivers/hv/ring_buffer.c                           |  31 +++--
 drivers/hv/vmbus_drv.c                             |  91 +++++++++-----
 drivers/i2c/busses/i2c-cadence.c                   |   9 +-
 drivers/i2c/i2c-dev.c                              |   6 +
 drivers/infiniband/ulp/ipoib/ipoib.h               |   1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   3 +-
 drivers/input/misc/bma150.c                        |   9 +-
 drivers/input/mouse/elantech.c                     |  23 ++++
 drivers/iommu/amd_iommu.c                          |  15 ++-
 drivers/md/dm-thin.c                               |  55 ++++++++-
 drivers/media/usb/em28xx/em28xx-dvb.c              |  20 +---
 drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +-
 drivers/mfd/ab8500-core.c                          |   2 +-
 drivers/mfd/tps6586x.c                             |  24 ++++
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/tmio_mmc_pio.c                    |   8 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |  13 +-
 drivers/net/can/dev.c                              |  27 ++---
 drivers/net/ethernet/marvell/skge.c                |   6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  68 +++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  22 ++--
 drivers/net/phy/mdio_bus.c                         |   1 -
 drivers/net/phy/micrel.c                           |  41 ++++++-
 drivers/net/team/team.c                            |  27 +----
 drivers/net/vxlan.c                                |  13 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |  29 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   4 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  76 +++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  32 +++--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  16 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  11 +-
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |  18 ++-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   2 +
 drivers/s390/block/dasd_eckd.c                     |   8 ++
 drivers/s390/char/sclp_config.c                    |   2 +
 drivers/s390/net/qeth_core.h                       |   3 +-
 drivers/s390/net/qeth_core_main.c                  |  35 ++++--
 drivers/s390/net/qeth_l2_main.c                    |   7 +-
 drivers/s390/net/qeth_l3_main.c                    |   3 +
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   4 +-
 drivers/scsi/isci/init.c                           |  14 +--
 drivers/scsi/libsas/sas_expander.c                 |   2 +
 drivers/scsi/sd.c                                  |   7 ++
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/tty/n_hdlc.c                               |   1 +
 drivers/tty/serial/serial_core.c                   |  12 +-
 drivers/tty/tty_io.c                               |   3 +-
 drivers/tty/vt/vt.c                                |   3 +-
 drivers/usb/class/cdc-acm.c                        |   7 ++
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/gadget/net2272.c                       |   2 +-
 drivers/usb/musb/musb_gadget.c                     |  13 +-
 drivers/usb/musb/musbhsdma.c                       |  21 ++--
 drivers/usb/phy/phy-am335x.c                       |   5 +-
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   2 +
 drivers/usb/serial/usb-serial-simple.c             |   3 +-
 drivers/usb/storage/scsiglue.c                     |   8 +-
 drivers/usb/storage/unusual_devs.h                 |  12 ++
 drivers/vfio/vfio_iommu_type1.c                    |  15 +++
 drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c    |   2 +
 fs/binfmt_elf.c                                    |   3 +-
 fs/ceph/snap.c                                     |   3 +-
 fs/cifs/file.c                                     |   8 +-
 fs/cifs/smb2file.c                                 |   4 +-
 fs/cifs/smb2pdu.c                                  |   6 +-
 fs/cifs/transport.c                                |   2 +-
 fs/dcache.c                                        |   6 +-
 fs/debugfs/inode.c                                 |   7 ++
 fs/fuse/dev.c                                      |   4 +-
 fs/fuse/file.c                                     |   2 +-
 fs/proc/task_mmu.c                                 |  22 +++-
 include/keys/user-type.h                           |   2 +-
 include/linux/perf_event.h                         |   5 +
 include/linux/sched.h                              |  21 ++++
 include/linux/signal.h                             |  15 +--
 include/linux/tracehook.h                          |   8 +-
 include/sound/compress_driver.h                    |   6 +-
 ipc/shm.c                                          |   4 +-
 kernel/events/core.c                               |  70 ++++++++---
 kernel/events/ring_buffer.c                        |   3 +
 kernel/signal.c                                    | 105 ++++++++++++----
 lib/assoc_array.c                                  |   8 +-
 mm/memory-failure.c                                |   3 +-
 mm/migrate.c                                       |   8 +-
 mm/mmap.c                                          |  24 ++--
 mm/oom_kill.c                                      |   8 ++
 mm/shmem.c                                         |  12 +-
 net/batman-adv/hard-interface.c                    |   4 +-
 net/batman-adv/soft-interface.c                    |   4 +
 net/bluetooth/l2cap_core.c                         |  83 ++++++++-----
 net/bridge/br_forward.c                            |  26 ++--
 net/can/bcm.c                                      |  27 +++++
 net/dsa/slave.c                                    |  13 +-
 net/ipv4/cipso_ipv4.c                              |   6 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/sit.c                                     |   3 +-
 net/l2tp/l2tp_core.c                               |   5 +-
 net/mac80211/tx.c                                  |   9 +-
 net/netfilter/nf_tables_api.c                      |   3 +
 net/netfilter/nft_compat.c                         | 120 +++++++++++------=
--
 net/nfc/llcp_commands.c                            |  20 ++++
 net/nfc/llcp_core.c                                |  24 +++-
 net/packet/af_packet.c                             |  12 +-
 net/sched/sch_netem.c                              |  10 +-
 net/vmw_vsock/vmci_transport.c                     |   4 +
 net/x25/af_x25.c                                   |  13 +-
 scripts/kallsyms.c                                 |   4 +-
 security/apparmor/apparmorfs.c                     |   1 +
 security/keys/key.c                                |   4 +-
 security/keys/keyring.c                            |   4 +-
 security/keys/proc.c                               |  11 +-
 security/keys/request_key.c                        |   1 +
 security/keys/request_key_auth.c                   |   2 +-
 security/yama/yama_lsm.c                           |   4 +-
 sound/pci/cs46xx/dsp_spos.c                        |   3 +
 sound/soc/codecs/tlv320aic32x4.c                   |   4 +
 sound/soc/intel/sst-mfld-platform-pcm.c            |   8 +-
 sound/usb/card.c                                   |   5 +
 sound/usb/mixer.c                                  |  10 +-
 sound/usb/pcm.c                                    |   9 +-
 sound/usb/quirks-table.h                           |   6 +
 sound/usb/stream.c                                 |  31 +++--
 tools/perf/tests/evsel-tp-sched.c                  |   8 +-
 206 files changed, 2363 insertions(+), 1833 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: don't set octeon_dma_bar_type if PCI is disabled

Alex Williamson (1):
      vfio/type1: Limit DMA mappings per container

Alexander Popov (1):
      KVM: x86: Fix single-step debugging

Alexandru Ardelean (1):
      dmaengine: dmatest: unmap data on a single code-path when xfer done

Andrea Arcangeli (1):
      coredump: fix race condition between mmget_not_zero()/get_task_mm() a=
nd core dumping

Andy Lutomirski (1):
      x86/uaccess: Don't leak the AC flag into __put_user() value evaluation

Andy Shevchenko (1):
      dmaengine: dmatest: Abort test in case of mapping error

Arend van Spriel (5):
      brcmfmac: assure SSID length from firmware is limited
      brcmfmac: consolidate ifp lookup in driver core
      brcmfmac: make brcmf_proto_hdrpull() return struct brcmf_if instance
      brcmfmac: revise handling events in receive path
      brcmfmac: add subtype check for event handling in data path

Aya Levin (1):
      net/mlx4_core: Add masking for a few queries on HCA caps

Ben Hutchings (2):
      binfmt_elf: Fix missing SIGKILL for empty PIE
      Linux 3.16.66

Bin Liu (1):
      usb: phy: am335x: fix race condition in _probe

Borislav Petkov (1):
      x86/a.out: Clear the dump structure initially

Charles Keepax (1):
      ALSA: compress: Fix stop handling on compressed capture streams

Charles Yeh (1):
      USB: serial: pl2303: add new PID to support PL2303TB

Christian Borntraeger (1):
      s390/early: improve machine detection

Christoph Paasch (1):
      net/packet: Set __GFP_NOWARN upon allocation in alloc_pg_vec

Cong Wang (1):
      team: avoid complex list operations in team_nl_cmd_options_set()

Dan Carpenter (4):
      mfd: ab8500-core: Return zero in get_register_interruptible()
      ALSA: cs46xx: Potential NULL dereference in probe
      scsi: bnx2fc: Fix error handling in probe()
      skge: potential memory corruption in skge_get_regs()

Daniel Drake (1):
      x86/kaslr: Fix incorrect i8254 outb() parameters

Daniele Palmas (1):
      usb: cdc-acm: send ZLP for Telit 3G Intel based modems

Darrick J. Wong (2):
      tmpfs: fix link accounting when a tmpfile is linked in
      tmpfs: fix uninitialized return value in shmem_link

David Hildenbrand (1):
      mm: migrate: don't rely on __PageMovable() of newpage after unlocking=
 it

David Howells (1):
      assoc_array: Fix shortcut creation

Davidlohr Bueso (1):
      arc: do not export symbols in troubleshoot.c

Dexuan Cui (1):
      Drivers: hv: vmbus: Check for ring when getting debug info

Eric Biggers (5):
      crypto: authenc - fix parsing key with misaligned rta_len
      KEYS: allow reaching the keys quotas exactly
      KEYS: user: Align the payload buffer
      KEYS: restrict /proc/keys by credentials at open time
      KEYS: always initialize keyring_index_key::desc_len

Eric Dumazet (3):
      vxlan: test dev->flags & IFF_UP before calling netif_rx()
      batman-adv: fix uninit-value in batadv_interface_tx()
      net/x25: fix a race in x25_bind()

Eric W. Biederman (4):
      signal: Always notice exiting tasks
      signal: Better detection of synchronous signals
      signal: Restore the stop PTRACE_EVENT_EXIT
      ipc/shm: Fix pid freeing.

Eugene Loh (1):
      kallsyms: Handle too long symbols in kallsyms.c

Eugeniy Paltsev (1):
      ARC: U-boot: check arguments paranoidly

Felix Fietkau (1):
      mac80211: ensure that mgmt tx skbs have tailroom for encryption

Feras Daoud (1):
      IB/ipoib: Fix for use-after-free in ipoib_cm_tx_start

Florian Westphal (1):
      netfilter: nf_tables: nft_compat: fix refcount leak on xt module

Franky Lin (1):
      brcmfmac: screening firmware event packet

Gabriel Krisman Bertazi (1):
      sd: Clear PS bit before Mode Select.

Gavin Li (1):
      brcmfmac: fix incorrect event channel deduction

Gerald Schaefer (1):
      s390/smp: fix CPU hotplug deadlock with CPU rescan

Greg Kroah-Hartman (3):
      tty: Handle problem if line discipline does not have receive_buf
      debugfs: fix debugfs_rename parameter checking
      tty: mark Siemens R3964 line discipline as BROKEN

Grygorii Strashko (1):
      net: phy: micrel: ksz9031: reconfigure autoneg after phy autoneg work=
around

Guenter Roeck (1):
      unicore32: Fix build error

Gustavo A. R. Silva (4):
      char/mwave: fix potential Spectre v1 vulnerability
      ipmi: msghandler: Fix potential Spectre v1 vulnerabilities
      usb: gadget: udc: net2272: Fix bitwise and boolean operations
      perf tests evsel-tp-sched: Fix bitwise operator

Hangbin Liu (1):
      sit: check if IPv6 enabled before calling ip6_err_gen_icmpv6_unreach()

Hans de Goede (2):
      ACPI: power: Skip duplicate power resource references in _PRx
      libata: Add NOLPM quirk for SAMSUNG MZ7TE512HMHP-000L1 SSD

Heiner Kallweit (1):
      net: phy: micrel: set soft_reset callback to genphy_soft_reset for KS=
Z9031

Hui Peng (1):
      ALSA: usb-audio: Fix an out-of-bound read in create_composite_quirks

Icenowy Zheng (2):
      USB: storage: don't insert sane sense for SPC3+ when bad sense specif=
ied
      USB: storage: add quirk for SMI SM3350

Ilya Dryomov (1):
      rbd: don't return 0 on unmap if RBD_DEV_FLAG_REMOVING is set

Ingo Molnar (1):
      perf/core: Fix impossible ring-buffer sizes warning

Ivan Mironov (3):
      scsi: sd: Fix cache_type_store()
      drm/fb-helper: Partially bring back workaround for bugs of SDL 1.2
      drm/fb-helper: Ignore the value of fb_var_screeninfo.pixclock

Jack Stocker (1):
      USB: Add USB_QUIRK_DELAY_CTRL_MSG quirk for Corsair K70 RGB

Jacob Wen (1):
      l2tp: copy 4 more bytes to linear part if necessary

Jann Horn (2):
      fuse: call pipe_buf_release() under pipe lock
      mm: enforce min addr even if capable() in expand_downwards()

Jason Gunthorpe (1):
      packet: Do not leak dev refcounts on error exit

Jiri Olsa (1):
      perf/x86: Add check_period PMU callback

John Garry (1):
      scsi: libsas: Fix rphy phy_identifier for PHYs with end devices attac=
hed

John Johansen (1):
      apparmor: provide userspace flag indicating binfmt_elf_mmap change

Jonathan Bakker (1):
      Input: bma150 - register input device after setting private data

Jonathan Hunter (1):
      mfd: tps6586x: Handle interrupts on suspend

Jonathan Neusch=E4fer (1):
      mmc: spi: Fix card detection during probe

Jose Abreu (1):
      net: stmmac: Fix a race in EEE enable callback

Julian Wiedmann (3):
      s390/qeth: fix use-after-free in error path
      s390/qeth: cancel close_dev work before removing a card
      s390/qeth: conclude all event processing before offlining a card

Jun-Ru Chang (1):
      MIPS: Remove function size check in get_frame_info()

Kal Conley (1):
      net/packet: fix 4gb buffer limit due to overflow check

Kan Liang (1):
      perf/x86/intel/uncore: Add Node ID mask

Kangjie Lu (1):
      ASoC: atom: fix a missing check of snd_pcm_lib_malloc_pages

Kees Cook (1):
      Yama: Check for pid death before checking ancestry

Leonid Iziumtsev (1):
      dmaengine: imx-dma: fix wrong callback invoke

Linus Torvalds (1):
      binfmt_elf: switch to new creds when switching to new mm

Linus Walleij (1):
      ARM: dts: kirkwood: Fix polarity of GPIO fan lines

Liping Zhang (1):
      netfilter: nft_compat: fix crash when related match/target module is =
removed

Logan Gunthorpe (1):
      scsi: isci: initialize shost fully before calling scsi_add_host()

Lukas Wunner (2):
      dmaengine: bcm2835: Fix interrupt race on RT
      dmaengine: bcm2835: Fix abort of transactions

Manfred Schlaegl (1):
      can: dev: __can_get_echo_skb(): fix bogous check for non-existing skb=
 by removing it

Manuel Reinhardt (1):
      ALSA: usb-audio: Fix implicit fb endpoint setup by quirk

Marcel Holtmann (2):
      Bluetooth: Verify that l2cap_get_conf_opt provides large enough buffer
      Bluetooth: Check L2CAP option sizes returned from l2cap_get_conf_opt

Mark Rutland (1):
      perf/core: Don't WARN() for impossible ring-buffer sizes

Martin Kepplinger (1):
      mtd: rawnand: gpmi: fix MX28 bus master lockup problem

Martin Schwidefsky (1):
      s390/mm: always force a load of the primary ASCE on context switch

Martin Sperl (1):
      dmaengine: bcm2835: add additional defines for DMA-registers

Matthias Schwarzott (1):
      media: em28xx: Fix use-after-free when disconnecting

Matti Kurkela (2):
      Input: elantech - force needed quirks on Fujitsu H760
      Input: elantech - enable 3rd button support on Fujitsu CELSIUS H780

Max Schulze (1):
      USB: serial: simple: add Motorola Tetra TPG2200 device id

Michael Straube (1):
      staging: rtl8188eu: Add device code for D-Link DWA-121 rev B1

Miklos Szeredi (2):
      fuse: handle zero sized retrieve correctly
      fuse: decrement NR_WRITEBACK_TEMP on the right page

Naoya Horiguchi (1):
      mm: hwpoison: use do_send_sig_info() instead of force_sig()

Nathan Sullivan (1):
      net/phy: micrel: Add workaround for bad autoneg

Naveen N. Rao (1):
      powerpc/signal: Properly handle return value from uprobe_deny_signal()

Nicolas Pitre (2):
      vt: always call notifier with the console lock held
      vt: invoke notifier on screen size change

Nikos Tsironis (1):
      dm thin: fix bug where bio that overwrites thin block ignores FUA

Oleg Nesterov (1):
      mm/mmap.c: expand_downwards: don't require the gap if !vm_prev

Oliver Hartkopp (1):
      can: bcm: check timer values before ktime conversion

Pablo Neira Ayuso (2):
      netfilter: nft_compat: use-after-free when deleting targets
      netfilter: nf_tables: fix flush after rule deletion in the same batch

Paolo Abeni (1):
      vsock: cope with memory allocation failure at socket creation time

Paul Elder (1):
      usb: gadget: musb: fix short isoc packets with inventra dma

Paul Fulghum (1):
      tty/n_hdlc: fix __might_sleep warning

Paul Moore (1):
      netlabel: fix out-of-bounds memory accesses

Pavel Shilovsky (3):
      CIFS: Do not hide EINTR after sending network packets
      CIFS: Do not count -ENODATA as failure for query directory
      CIFS: Do not consider -ENODATA as stat failure for reads

Peng Hao (1):
      ARM: pxa: ssp: unneeded to free devm_ allocated data

Peter Zijlstra (1):
      perf/core: Fix perf_event_open() vs. execve() race

Rajasingh Thavamani (1):
      net: phy: Micrel KSZ8061: link failure after cable connect

Richard Weinberger (28):
      arc: Use get_signal() signal_setup_done()
      arm64: Use get_signal() signal_setup_done()
      avr32: Use get_signal() signal_setup_done()
      blackfin: Use get_signal() signal_setup_done()
      c6x: Use get_signal() signal_setup_done()
      cris: Use get_signal() signal_setup_done()
      frv: Use get_signal() signal_setup_done()
      hexagon: Use get_signal() signal_setup_done()
      ia64: Use get_signal() signal_setup_done()
      m32r: Use get_signal() signal_setup_done()
      m68k: Use get_signal() signal_setup_done()
      microblaze: Use get_signal() signal_setup_done()
      mips: Use get_signal() signal_setup_done()
      mips: Use sigsp()
      mn10300: Use get_signal() signal_setup_done()
      parisc: Use get_signal() signal_setup_done()
      powerpc: Use get_signal() signal_setup_done()
      powerpc: Use sigsp()
      s390: Use get_signal() signal_setup_done()
      score: Use get_signal() signal_setup_done()
      sh: Use get_signal() signal_setup_done()
      tile: Use get_signal() signal_setup_done()
      um: Use get_signal() signal_setup_done()
      unicore32: Use get_signal() signal_setup_done()
      xtensa: Use get_signal() signal_setup_done()
      tracehook_signal_handler: Remove sig, info, ka and regs
      Clean up signal_delivered()
      Rip out get_signal_to_deliver()

Ross Lagerwall (1):
      cifs: Fix potential OOB access of lock element array

Rundong Ge (1):
      net: dsa: slave: Don't propagate flag changes on down slave interfaces

Russell King (1):
      ARM: iop32x/n2100: fix PCI IRQ mapping

Sakari Ailus (1):
      media: v4l: ioctl: Validate num_planes for debug messages

Samir Virmani (1):
      uart: Fix crash in uart_write and uart_put_char

Sergei Shtylyov (1):
      mmc: tmio_mmc_core: don't claim spurious interrupts

Sergei Trofimovich (1):
      alpha: fix page fault handling for r16-r18 targets

Shakeel Butt (1):
      mm, oom: fix use-after-free in oom_kill_process

Sheng Lan (1):
      net: netem: fix skb length BUG_ON in __skb_to_sgvec

Shuah Khan (1):
      media: em28xx-dvb - fix em28xx_dvb_resume() to not unregister i2c and=
 dvb

Shubhrajyoti Datta (1):
      i2c: cadence: Fix the hold bit setting

Stefan Haberland (1):
      s390/dasd: fix using offset into zero size array error

Suravee Suthikulpanit (1):
      iommu/amd: Fix IOMMU page flush when detach device from a domain

Sven Eckelmann (2):
      batman-adv: Avoid WARN on net_device without parent in netns
      batman-adv: Force mac header to start of data on xmit

Takashi Iwai (2):
      ALSA: usb-audio: Avoid access before bLength check in build_audio_pro=
cunit()
      ALSA: usb-audio: Always check descriptor sizes in parser code

Thomas Hellstrom (2):
      drm/vmwgfx: Return error code from vmw_execbuf_copy_fence_user
      drm/vmwgfx: Fix setting of dma masks

Thomas Richter (1):
      perf test: Fix failure of 'evsel-tp-sched' test on s390

Tina Zhang (1):
      drm/modes: Prevent division by zero htotal

Vineet Gupta (2):
      ARC: show_regs: lockdep: avoid page allocator...
      ARC: mm: do_page_fault fixes #1: relinquish mmap_sem if signal arrive=
s while handle_mm_fault

Vitaly Kuznetsov (1):
      x86/kvm/nVMX: read from MSR_IA32_VMX_PROCBASED_CTLS2 only when it is =
available

Vlad Tsyrklevich (1):
      omap2fb: Fix stack memory disclosure

Waiman Long (1):
      fs/dcache: Fix incorrect nr_dentry_unused accounting in shrink_dcache=
_sb()

Willem de Bruijn (2):
      packet: validate address length
      packet: validate address length if non-zero

Yan, Zheng (1):
      ceph: avoid repeatedly adding inode to mdsc->snap_flush_list

Yi Zeng (1):
      i2c: dev: prevent adapter retries and timeout being set as minus value

YueHaibing (2):
      mdio_bus: Fix use-after-free on device_register fails
      net: nfc: Fix NULL dereference on nfc_llcp_build_tlv fails

YunQiang Su (1):
      Disable MSI also when pcie-octeon.pcie_disable on

Yunjian Wang (1):
      net: bridge: Fix ethernet header pointer before check skb forwardable

Zach Brown (1):
      net/phy: micrel: configure intterupts after autoneg workaround

Zhiqiang Liu (1):
      net: fix IPv6 prefix route residue

b-ak (1):
      ASoC: tlv320aic32x4: Kernel OOPS while entering DAPM standby mode


--p355lqk3xfcokp2m
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.66.patch"
Content-Disposition: attachment; filename="linux-3.16.66.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 293d65674b4d..7387b85870f2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 65
+SUBLEVEL =3D 66
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index 9d0ac091a52a..174d3cbf8a7a 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -78,7 +78,7 @@ __load_new_mm_context(struct mm_struct *next_mm)
 /* Macro for exception fixup code to access integer registers.  */
 #define dpf_reg(r)							\
 	(((unsigned long *)regs)[(r) <=3D 8 ? (r) : (r) <=3D 15 ? (r)-16 :	\
-				 (r) <=3D 18 ? (r)+8 : (r)-10])
+				 (r) <=3D 18 ? (r)+10 : (r)-10])
=20
 asmlinkage void
 do_page_fault(unsigned long address, unsigned long mmcsr,
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 4d2481bd8b98..76c8a2047d97 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -85,9 +85,9 @@
=20
 	; Uboot - kernel ABI
 	;    r0 =3D [0] No uboot interaction, [1] cmdline in r2, [2] DTB in r2
-	;    r1 =3D magic number (board identity, unused as of now
+	;    r1 =3D magic number (always zero as of now)
 	;    r2 =3D pointer to uboot provided cmdline or external DTB in mem
-	; These are handled later in setup_arch()
+	; These are handled later in handle_uboot_args()
 	st	r0, [@uboot_tag]
 	st	r2, [@uboot_arg]
=20
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index cfae438520af..8e36b6474b31 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -314,40 +314,78 @@ void setup_processor(void)
 	arc_chk_fpu();
 }
=20
-static inline int is_kernel(unsigned long addr)
+static inline bool uboot_arg_invalid(unsigned long addr)
 {
-	if (addr >=3D (unsigned long)_stext && addr <=3D (unsigned long)_end)
-		return 1;
-	return 0;
+	/*
+	 * Check that it is a untranslated address (although MMU is not enabled
+	 * yet, it being a high address ensures this is not by fluke)
+	 */
+	if (addr < PAGE_OFFSET)
+		return true;
+
+	/* Check that address doesn't clobber resident kernel image */
+	return addr >=3D (unsigned long)_stext && addr <=3D (unsigned long)_end;
 }
=20
-void __init setup_arch(char **cmdline_p)
+#define IGNORE_ARGS		"Ignore U-boot args: "
+
+/* uboot_tag values for U-boot - kernel ABI revision 0; see head.S */
+#define UBOOT_TAG_NONE		0
+#define UBOOT_TAG_CMDLINE	1
+#define UBOOT_TAG_DTB		2
+
+void __init handle_uboot_args(void)
 {
-	/* make sure that uboot passed pointer to cmdline/dtb is valid */
-	if (uboot_tag && is_kernel((unsigned long)uboot_arg))
-		panic("Invalid uboot arg\n");
-
-	/* See if u-boot passed an external Device Tree blob */
-	machine_desc =3D setup_machine_fdt(uboot_arg);	/* uboot_tag =3D=3D 2 */
-	if (!machine_desc) {
-		/* No, so try the embedded one */
+	bool use_embedded_dtb =3D true;
+	bool append_cmdline =3D false;
+
+	/* check that we know this tag */
+	if (uboot_tag !=3D UBOOT_TAG_NONE &&
+	    uboot_tag !=3D UBOOT_TAG_CMDLINE &&
+	    uboot_tag !=3D UBOOT_TAG_DTB) {
+		pr_warn(IGNORE_ARGS "invalid uboot tag: '%08x'\n", uboot_tag);
+		goto ignore_uboot_args;
+	}
+
+	if (uboot_tag !=3D UBOOT_TAG_NONE &&
+            uboot_arg_invalid((unsigned long)uboot_arg)) {
+		pr_warn(IGNORE_ARGS "invalid uboot arg: '%px'\n", uboot_arg);
+		goto ignore_uboot_args;
+	}
+
+	/* see if U-boot passed an external Device Tree blob */
+	if (uboot_tag =3D=3D UBOOT_TAG_DTB) {
+		machine_desc =3D setup_machine_fdt((void *)uboot_arg);
+
+		/* external Device Tree blob is invalid - use embedded one */
+		use_embedded_dtb =3D !machine_desc;
+	}
+
+	if (uboot_tag =3D=3D UBOOT_TAG_CMDLINE)
+		append_cmdline =3D true;
+
+ignore_uboot_args:
+
+	if (use_embedded_dtb) {
 		machine_desc =3D setup_machine_fdt(__dtb_start);
 		if (!machine_desc)
 			panic("Embedded DT invalid\n");
+	}
=20
-		/*
-		 * If we are here, it is established that @uboot_arg didn't
-		 * point to DT blob. Instead if u-boot says it is cmdline,
-		 * Appent to embedded DT cmdline.
-		 * setup_machine_fdt() would have populated @boot_command_line
-		 */
-		if (uboot_tag =3D=3D 1) {
-			/* Ensure a whitespace between the 2 cmdlines */
-			strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
-			strlcat(boot_command_line, uboot_arg,
-				COMMAND_LINE_SIZE);
-		}
+	/*
+	 * NOTE: @boot_command_line is populated by setup_machine_fdt() so this
+	 * append processing can only happen after.
+	 */
+	if (append_cmdline) {
+		/* Ensure a whitespace between the 2 cmdlines */
+		strlcat(boot_command_line, " ", COMMAND_LINE_SIZE);
+		strlcat(boot_command_line, uboot_arg, COMMAND_LINE_SIZE);
 	}
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+	handle_uboot_args();
=20
 	/* Save unparsed command line copy for /proc/cmdline */
 	*cmdline_p =3D boot_command_line;
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 0943ff84f28f..0f458ee7399b 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -189,14 +189,13 @@ static inline int map_sig(int sig)
 }
=20
 static int
-setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *sf;
 	unsigned int magic =3D 0;
 	int err =3D 0;
=20
-	sf =3D get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+	sf =3D get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
 	if (!sf)
 		return 1;
=20
@@ -215,8 +214,8 @@ setup_rt_frame(int signo, struct k_sigaction *ka, sigin=
fo_t *info,
 	 *  #2: struct siginfo
 	 *  #3: struct ucontext (completely populated)
 	 */
-	if (unlikely(ka->sa.sa_flags & SA_SIGINFO)) {
-		err |=3D copy_siginfo_to_user(&sf->info, info);
+	if (unlikely(ksig->ka.sa.sa_flags & SA_SIGINFO)) {
+		err |=3D copy_siginfo_to_user(&sf->info, &ksig->info);
 		err |=3D __put_user(0, &sf->uc.uc_flags);
 		err |=3D __put_user(NULL, &sf->uc.uc_link);
 		err |=3D __save_altstack(&sf->uc.uc_stack, regs->sp);
@@ -237,19 +236,19 @@ setup_rt_frame(int signo, struct k_sigaction *ka, sig=
info_t *info,
 		return err;
=20
 	/* #1 arg to the user Signal handler */
-	regs->r0 =3D map_sig(signo);
+	regs->r0 =3D map_sig(ksig->sig);
=20
 	/* setup PC of user space signal handler */
-	regs->ret =3D (unsigned long)ka->sa.sa_handler;
+	regs->ret =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 	/*
 	 * handler returns using sigreturn stub provided already by userpsace
 	 * If not, nuke the process right away
 	 */
-	if(!(ka->sa.sa_flags & SA_RESTORER))
+	if(!(ksig->ka.sa.sa_flags & SA_RESTORER))
 		return 1;
=20
-	regs->blink =3D (unsigned long)ka->sa.sa_restorer;
+	regs->blink =3D (unsigned long)ksig->ka.sa.sa_restorer;
=20
 	/* User Stack for signal handler will be above the frame just carved */
 	regs->sp =3D (unsigned long)sf;
@@ -311,38 +310,30 @@ static void arc_restart_syscall(struct k_sigaction *k=
a, struct pt_regs *regs)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int failed;
=20
 	/* Set up the stack frame */
-	failed =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	failed =3D setup_rt_frame(ksig, oldset, regs);
=20
-	if (failed)
-		force_sigsegv(sig, current);
-	else
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(failed, ksig, 0);
 }
=20
 void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 	int restart_scall;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-
 	restart_scall =3D in_syscall(regs) && syscall_restartable(regs);
=20
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		if (restart_scall) {
-			arc_restart_syscall(&ka, regs);
+			arc_restart_syscall(&ksig.ka, regs);
 			syscall_wont_restart(regs);	/* No more restarts */
 		}
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 1badf9b84b51..46d39e9dbcd6 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -15,6 +15,8 @@
 #include <linux/file.h>
 #include <asm/arcregs.h>
=20
+#define ARC_PATH_MAX	256
+
 /*
  * Common routine to print scratch regs (r0-r12) or callee regs (r13-r25)
  *   -Prints 3 regs per line and a CR.
@@ -52,12 +54,13 @@ static void show_callee_regs(struct callee_regs *cregs)
 	print_reg_file(&(cregs->r13), 13);
 }
=20
-void print_task_path_n_nm(struct task_struct *tsk, char *buf)
+static void print_task_path_n_nm(struct task_struct *tsk)
 {
 	struct path path;
 	char *path_nm =3D NULL;
 	struct mm_struct *mm;
 	struct file *exe_file;
+	char buf[ARC_PATH_MAX];
=20
 	mm =3D get_task_mm(tsk);
 	if (!mm)
@@ -70,22 +73,20 @@ void print_task_path_n_nm(struct task_struct *tsk, char=
 *buf)
 		path =3D exe_file->f_path;
 		path_get(&exe_file->f_path);
 		fput(exe_file);
-		path_nm =3D d_path(&path, buf, 255);
+		path_nm =3D d_path(&path, buf, ARC_PATH_MAX-1);
 		path_put(&path);
 	}
=20
 done:
 	pr_info("Path: %s\n", path_nm);
 }
-EXPORT_SYMBOL(print_task_path_n_nm);
=20
-static void show_faulting_vma(unsigned long address, char *buf)
+static void show_faulting_vma(unsigned long address)
 {
 	struct vm_area_struct *vma;
 	struct inode *inode;
 	unsigned long ino =3D 0;
 	dev_t dev =3D 0;
-	char *nm =3D buf;
 	struct mm_struct *active_mm =3D current->active_mm;
=20
 	/* can't use print_vma_addr() yet as it doesn't check for
@@ -99,9 +100,12 @@ static void show_faulting_vma(unsigned long address, ch=
ar *buf)
 	 */
 	if (vma && (vma->vm_start <=3D address)) {
 		struct file *file =3D vma->vm_file;
+		char buf[ARC_PATH_MAX];
+		char *nm =3D "?";
+
 		if (file) {
 			struct path *path =3D &file->f_path;
-			nm =3D d_path(path, buf, PAGE_SIZE - 1);
+			nm =3D d_path(path, buf, ARC_PATH_MAX-1);
 			inode =3D file_inode(vma->vm_file);
 			dev =3D inode->i_sb->s_dev;
 			ino =3D inode->i_ino;
@@ -166,13 +170,8 @@ void show_regs(struct pt_regs *regs)
 {
 	struct task_struct *tsk =3D current;
 	struct callee_regs *cregs;
-	char *buf;
=20
-	buf =3D (char *)__get_free_page(GFP_TEMPORARY);
-	if (!buf)
-		return;
-
-	print_task_path_n_nm(tsk, buf);
+	print_task_path_n_nm(tsk);
 	show_regs_print_info(KERN_INFO);
=20
 	show_ecr_verbose(regs);
@@ -182,7 +181,7 @@ void show_regs(struct pt_regs *regs)
 		(void *)regs->blink, (void *)regs->ret);
=20
 	if (user_mode(regs))
-		show_faulting_vma(regs->ret, buf); /* faulting code, not data */
+		show_faulting_vma(regs->ret); /* faulting code, not data */
=20
 	pr_info("[STAT32]: 0x%08lx", regs->status32);
=20
@@ -206,8 +205,6 @@ void show_regs(struct pt_regs *regs)
 	cregs =3D (struct callee_regs *)current->thread.callee_reg;
 	if (cregs)
 		show_callee_regs(cregs);
-
-	free_page((unsigned long)buf);
 }
=20
 void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index 01e18b58dfa4..caa01cf06a5b 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -131,12 +131,17 @@ void do_page_fault(unsigned long address, struct pt_r=
egs *regs)
 	 */
 	fault =3D handle_mm_fault(mm, vma, address, flags);
=20
-	/* If Pagefault was interrupted by SIGKILL, exit page fault "early" */
 	if (unlikely(fatal_signal_pending(current))) {
-		if ((fault & VM_FAULT_ERROR) && !(fault & VM_FAULT_RETRY))
-			up_read(&mm->mmap_sem);
-		if (user_mode(regs))
+
+		/*
+		 * if fault retry, mmap_sem already relinquished by core mm
+		 * so OK to return to user mode (with signal handled first)
+		 */
+		if (fault & VM_FAULT_RETRY) {
+			if (!user_mode(regs))
+				goto no_context;
 			return;
+		}
 	}
=20
 	if (likely(!(fault & VM_FAULT_ERROR))) {
diff --git a/arch/arm/boot/dts/kirkwood-dnskw.dtsi b/arch/arm/boot/dts/kirk=
wood-dnskw.dtsi
index 113dcf056dcf..1b2dacfa6132 100644
--- a/arch/arm/boot/dts/kirkwood-dnskw.dtsi
+++ b/arch/arm/boot/dts/kirkwood-dnskw.dtsi
@@ -35,8 +35,8 @@
 		compatible =3D "gpio-fan";
 		pinctrl-0 =3D <&pmx_fan_high_speed &pmx_fan_low_speed>;
 		pinctrl-names =3D "default";
-		gpios =3D <&gpio1 14 GPIO_ACTIVE_LOW
-			 &gpio1 13 GPIO_ACTIVE_LOW>;
+		gpios =3D <&gpio1 14 GPIO_ACTIVE_HIGH
+			 &gpio1 13 GPIO_ACTIVE_HIGH>;
 		gpio-fan,speed-map =3D <0    0
 				      3000 1
 				      6000 2>;
diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index c1cd80ecc219..a904244264ce 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -75,8 +75,7 @@ void __init n2100_map_io(void)
 /*
  * N2100 PCI.
  */
-static int __init
-n2100_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int n2100_pci_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	int irq;
=20
diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index 3ea02903d75a..cde15e6ebad3 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -239,8 +239,6 @@ static int pxa_ssp_remove(struct platform_device *pdev)
 	if (ssp =3D=3D NULL)
 		return -ENODEV;
=20
-	iounmap(ssp->mmio_base);
-
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
=20
@@ -250,7 +248,6 @@ static int pxa_ssp_remove(struct platform_device *pdev)
 	list_del(&ssp->node);
 	mutex_unlock(&ssp_lock);
=20
-	kfree(ssp);
 	return 0;
 }
=20
diff --git a/arch/arm64/include/asm/signal32.h b/arch/arm64/include/asm/sig=
nal32.h
index 7c275e3b640f..eeaa97559bab 100644
--- a/arch/arm64/include/asm/signal32.h
+++ b/arch/arm64/include/asm/signal32.h
@@ -24,22 +24,21 @@
=20
 extern const compat_ulong_t aarch32_sigret_code[6];
=20
-int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
+int compat_setup_frame(int usig, struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs);
-int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *inf=
o,
-			  sigset_t *set, struct pt_regs *regs);
+int compat_setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs);
=20
 void compat_setup_restart_syscall(struct pt_regs *regs);
 #else
=20
-static inline int compat_setup_frame(int usid, struct k_sigaction *ka,
+static inline int compat_setup_frame(int usid, struct ksignal *ksig,
 				     sigset_t *set, struct pt_regs *regs)
 {
 	return -ENOSYS;
 }
=20
-static inline int compat_setup_rt_frame(int usig, struct k_sigaction *ka,
-					siginfo_t *info, sigset_t *set,
+static inline int compat_setup_rt_frame(int usig, struct ksignal *ksig, si=
gset_t *set,
 					struct pt_regs *regs)
 {
 	return -ENOSYS;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index d1ae7c217ba9..4ba51e6efc52 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -253,13 +253,13 @@ static void setup_return(struct pt_regs *regs, struct=
 k_sigaction *ka,
 	regs->regs[30] =3D (unsigned long)sigtramp;
 }
=20
-static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *inf=
o,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs);
+	frame =3D get_sigframe(&ksig->ka, regs);
 	if (!frame)
 		return 1;
=20
@@ -269,9 +269,9 @@ static int setup_rt_frame(int usig, struct k_sigaction =
*ka, siginfo_t *info,
 	err |=3D __save_altstack(&frame->uc.uc_stack, regs->sp);
 	err |=3D setup_sigframe(frame, regs, set);
 	if (err =3D=3D 0) {
-		setup_return(regs, ka, frame, usig);
-		if (ka->sa.sa_flags & SA_SIGINFO) {
-			err |=3D copy_siginfo_to_user(&frame->info, info);
+		setup_return(regs, &ksig->ka, frame, usig);
+		if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+			err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 			regs->regs[1] =3D (unsigned long)&frame->info;
 			regs->regs[2] =3D (unsigned long)&frame->uc;
 		}
@@ -291,13 +291,12 @@ static void setup_restart_syscall(struct pt_regs *reg=
s)
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-			  siginfo_t *info, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	struct thread_info *thread =3D current_thread_info();
 	struct task_struct *tsk =3D current;
 	sigset_t *oldset =3D sigmask_to_save();
-	int usig =3D sig;
+	int usig =3D ksig->sig;
 	int ret;
=20
 	/*
@@ -310,13 +309,12 @@ static void handle_signal(unsigned long sig, struct k=
_sigaction *ka,
 	 * Set up the stack frame
 	 */
 	if (is_compat_task()) {
-		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret =3D compat_setup_rt_frame(usig, ka, info, oldset,
-						    regs);
+		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+			ret =3D compat_setup_rt_frame(usig, ksig, oldset, regs);
 		else
-			ret =3D compat_setup_frame(usig, ka, oldset, regs);
+			ret =3D compat_setup_frame(usig, ksig, oldset, regs);
 	} else {
-		ret =3D setup_rt_frame(usig, ka, info, oldset, regs);
+		ret =3D setup_rt_frame(usig, ksig, oldset, regs);
 	}
=20
 	/*
@@ -324,18 +322,14 @@ static void handle_signal(unsigned long sig, struct k=
_sigaction *ka,
 	 */
 	ret |=3D !valid_user_regs(&regs->user_regs, current);
=20
-	if (ret !=3D 0) {
-		force_sigsegv(sig, tsk);
-		return;
-	}
-
 	/*
 	 * Fast forward the stepping logic so we step into the signal
 	 * handler.
 	 */
-	user_fastforward_single_step(tsk);
+	if (!ret)
+		user_fastforward_single_step(tsk);
=20
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -350,10 +344,9 @@ static void handle_signal(unsigned long sig, struct k_=
sigaction *ka,
 static void do_signal(struct pt_regs *regs)
 {
 	unsigned long continue_addr =3D 0, restart_addr =3D 0;
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr, retval =3D 0;
+	int retval =3D 0;
 	int syscall =3D (int)regs->syscallno;
+	struct ksignal ksig;
=20
 	/*
 	 * If we were from a system call, check for system call restarting...
@@ -387,8 +380,7 @@ static void do_signal(struct pt_regs *regs)
 	 * Get the signal to deliver. When running under ptrace, at this point
 	 * the debugger may change all of our registers.
 	 */
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/*
 		 * Depending on the signal settings, we may need to revert the
 		 * decision to restart the system call, but skip this if a
@@ -398,12 +390,12 @@ static void do_signal(struct pt_regs *regs)
 		    (retval =3D=3D -ERESTARTNOHAND ||
 		     retval =3D=3D -ERESTART_RESTARTBLOCK ||
 		     (retval =3D=3D -ERESTARTSYS &&
-		      !(ka.sa.sa_flags & SA_RESTART)))) {
+		      !(ksig.ka.sa.sa_flags & SA_RESTART)))) {
 			regs->regs[0] =3D -EINTR;
 			regs->pc =3D continue_addr;
 		}
=20
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 03520c650701..dc34d5ee88ca 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -543,18 +543,18 @@ static int compat_setup_sigframe(struct compat_sigfra=
me __user *sf,
 /*
  * 32-bit signal handling routines called from signal.c
  */
-int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *inf=
o,
+int compat_setup_rt_frame(int usig, struct ksignal *ksig,
 			  sigset_t *set, struct pt_regs *regs)
 {
 	struct compat_rt_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D compat_get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!frame)
 		return 1;
=20
-	err |=3D copy_siginfo_to_user32(&frame->info, info);
+	err |=3D copy_siginfo_to_user32(&frame->info, &ksig->info);
=20
 	__put_user_error(0, &frame->sig.uc.uc_flags, err);
 	__put_user_error(0, &frame->sig.uc.uc_link, err);
@@ -564,7 +564,7 @@ int compat_setup_rt_frame(int usig, struct k_sigaction =
*ka, siginfo_t *info,
 	err |=3D compat_setup_sigframe(&frame->sig, regs, set);
=20
 	if (err =3D=3D 0) {
-		compat_setup_return(regs, ka, frame->sig.retcode, frame, usig);
+		compat_setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
 		regs->regs[1] =3D (compat_ulong_t)(unsigned long)&frame->info;
 		regs->regs[2] =3D (compat_ulong_t)(unsigned long)&frame->sig.uc;
 	}
@@ -572,13 +572,13 @@ int compat_setup_rt_frame(int usig, struct k_sigactio=
n *ka, siginfo_t *info,
 	return err;
 }
=20
-int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
+int compat_setup_frame(int usig, struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs)
 {
 	struct compat_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D compat_get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!frame)
 		return 1;
@@ -587,7 +587,7 @@ int compat_setup_frame(int usig, struct k_sigaction *ka=
, sigset_t *set,
=20
 	err |=3D compat_setup_sigframe(frame, regs, set);
 	if (err =3D=3D 0)
-		compat_setup_return(regs, ka, frame->retcode, frame, usig);
+		compat_setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
=20
 	return err;
 }
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index b80c0b3d2bab..dda150fe73bb 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -138,13 +138,12 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *=
regs, int framesize)
 }
=20
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	err =3D -EFAULT;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		goto out;
@@ -164,7 +163,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	err =3D __put_user(0x3008d733 | (__NR_rt_sigreturn << 20),
 			 &frame->retcode);
=20
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Set up the ucontext */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -176,12 +175,12 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 	if (err)
 		goto out;
=20
-	regs->r12 =3D sig;
+	regs->r12 =3D ksig->sig;
 	regs->r11 =3D (unsigned long) &frame->info;
 	regs->r10 =3D (unsigned long) &frame->uc;
 	regs->sp =3D (unsigned long) frame;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		regs->lr =3D (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		regs->lr =3D (unsigned long)ksig->ka.sa.sa_restorer;
 	else {
 		printk(KERN_NOTICE "[%s:%d] did not set SA_RESTORER\n",
 		       current->comm, current->pid);
@@ -189,10 +188,10 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 	}
=20
 	pr_debug("SIG deliver [%s:%d]: sig=3D%d sp=3D0x%lx pc=3D0x%lx->0x%p lr=3D=
0x%lx\n",
-		 current->comm, current->pid, sig, regs->sp,
-		 regs->pc, ka->sa.sa_handler, regs->lr);
+		 current->comm, current->pid, ksig->sig, regs->sp,
+		 regs->pc, ksig->ka.sa.sa_handler, regs->lr);
=20
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 out:
 	return err;
@@ -208,15 +207,14 @@ static inline void setup_syscall_restart(struct pt_re=
gs *regs)
 }
=20
 static inline void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs, int syscall)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, int syscall)
 {
 	int ret;
=20
 	/*
 	 * Set up the stack frame
 	 */
-	ret =3D setup_rt_frame(sig, ka, info, sigmask_to_save(), regs);
+	ret =3D setup_rt_frame(ksig, sigmask_to_save(), regs);
=20
 	/*
 	 * Check that the resulting registers are sane
@@ -226,10 +224,7 @@ handle_signal(unsigned long sig, struct k_sigaction *k=
a, siginfo_t *info,
 	/*
 	 * Block the signal if we were successful.
 	 */
-	if (ret !=3D 0)
-		force_sigsegv(sig, current);
-	else
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -239,9 +234,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka=
, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which is why we may in
@@ -251,18 +244,18 @@ static void do_signal(struct pt_regs *regs, int sysca=
ll)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
 	if (syscall) {
 		switch (regs->r12) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
-			if (signr > 0) {
+			if (ksig.sig > 0) {
 				regs->r12 =3D -EINTR;
 				break;
 			}
 			/* fall through */
 		case -ERESTARTSYS:
-			if (signr > 0 && !(ka.sa.sa_flags & SA_RESTART)) {
+			if (ksig.sig > 0 && !(ksig.ka.sa.sa_flags & SA_RESTART)) {
 				regs->r12 =3D -EINTR;
 				break;
 			}
@@ -272,13 +265,13 @@ static void do_signal(struct pt_regs *regs, int sysca=
ll)
 		}
 	}
=20
-	if (signr =3D=3D 0) {
+	if (!ksig.sig) {
 		/* No signal to deliver -- put the saved sigmask back */
 		restore_saved_sigmask();
 		return;
 	}
=20
-	handle_signal(signr, &ka, &info, regs, syscall);
+	handle_signal(&ksig, regs, syscall);
 }
=20
 asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info =
*ti)
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index b022af6c48f8..1389cd3b74e3 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -152,23 +152,22 @@ static inline void *get_sigframe(struct k_sigaction *=
ka, struct pt_regs *regs,
 }
=20
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
-	       sigset_t * set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	err |=3D __put_user((current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
-			   && sig < 32
+			   && ksig->sig < 32
 			   ? current_thread_info()->exec_domain->
-			   signal_invmap[sig] : sig), &frame->sig);
+			   signal_invmap[ksig->sig] : ksig->sig), &frame->sig);
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -183,7 +182,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t * info,
 	/* Set up registers for signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =3D
-			(struct fdpic_func_descriptor *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor *) ksig->ka.sa.sa_handler;
 		u32 pc, p3;
 		err |=3D __get_user(pc, &funcptr->text);
 		err |=3D __get_user(p3, &funcptr->GOT);
@@ -192,7 +191,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t * info,
 		regs->pc =3D pc;
 		regs->p3 =3D p3;
 	} else
-		regs->pc =3D (unsigned long)ka->sa.sa_handler;
+		regs->pc =3D (unsigned long)ksig->ka.sa.sa_handler;
 	wrusp((unsigned long)frame);
 	regs->rets =3D SIGRETURN_STUB;
=20
@@ -237,20 +236,19 @@ handle_restart(struct pt_regs *regs, struct k_sigacti=
on *ka, int has_handler)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/* are we from a system call? to see pt_regs->orig_p0 */
 	if (regs->orig_p0 >=3D 0)
 		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
+		handle_restart(regs, &ksig->ka, 1);
=20
 	/* set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		force_sigsegv(sig, current);
-	else=20
-		signal_delivered(sig, info, ka, regs,
-				test_thread_flag(TIF_SINGLESTEP));
+	ret =3D setup_rt_frame(ksig, sigmask_to_save(), regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 /*
@@ -264,16 +262,13 @@ handle_signal(int sig, siginfo_t *info, struct k_siga=
ction *ka,
  */
 asmlinkage void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	current->thread.esp0 =3D (unsigned long)regs;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index 3998b24e26f2..8bf9aad67cee 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -146,21 +146,21 @@ static inline void __user *get_sigframe(struct k_siga=
ction *ka,
 	return (void __user *)((sp - framesize) & ~7);
 }
=20
-static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *in=
fo,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long __user *retcode;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto segv_and_exit;
+		return -EFAULT;
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Clear all the bits of the ucontext we don't use.  */
 	err |=3D __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
@@ -188,7 +188,7 @@ static int setup_rt_frame(int signr, struct k_sigaction=
 *ka, siginfo_t *info,
 #undef COPY
=20
 	if (err)
-		goto segv_and_exit;
+		return -EFAULT;
=20
 	flush_icache_range((unsigned long) &frame->retcode,
 			   (unsigned long) &frame->retcode + RETCODE_SIZE);
@@ -198,10 +198,10 @@ static int setup_rt_frame(int signr, struct k_sigacti=
on *ka, siginfo_t *info,
 	/* Change user context to branch to signal handler */
 	regs->sp =3D (unsigned long) frame - 8;
 	regs->b3 =3D (unsigned long) retcode;
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
=20
 	/* Give the signal number to the handler */
-	regs->a4 =3D signr;
+	regs->a4 =3D ksig->sig;
=20
 	/*
 	 * For realtime signals we must also set the second and third
@@ -212,10 +212,6 @@ static int setup_rt_frame(int signr, struct k_sigactio=
n *ka, siginfo_t *info,
 	regs->a6 =3D (unsigned long)&frame->uc;
=20
 	return 0;
-
-segv_and_exit:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
 static inline void
@@ -245,10 +241,11 @@ handle_restart(struct pt_regs *regs, struct k_sigacti=
on *ka, int has_handler)
 /*
  * handle the actual delivery of a signal to userspace
  */
-static void handle_signal(int sig,
-			 siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs, int syscall)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
+			  int syscall)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (syscall) {
 		/* If so, check system call restarting.. */
@@ -259,7 +256,7 @@ static void handle_signal(int sig,
 			break;
=20
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->a4 =3D -EINTR;
 				break;
 			}
@@ -272,9 +269,8 @@ static void handle_signal(int sig,
 	}
=20
 	/* Set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		return;
-	signal_delivered(sig, info, ka, regs, 0);
+	ret =3D setup_rt_frame(ksig, sigmask_to_save(), regs);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -282,18 +278,15 @@ static void handle_signal(int sig,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
=20
 	/* we want the common case to go fast, which is why we may in certain
 	 * cases get here from kernel mode */
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &info, &ka, regs, syscall);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs, syscall);
 		return;
 	}
=20
diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel=
/signal.c
index 61ce6273a895..12aac1fb48df 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -228,33 +228,33 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *=
regs, size_t frame_size)
  * user-mode trampoline.
  */
=20
-static int setup_frame(int sig, struct k_sigaction *ka,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long return_ip;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D setup_sigcontext(&frame->sc, regs, set->sig[0]);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (_NSIG_WORDS > 1) {
 		err |=3D __copy_to_user(frame->extramask, &set->sig[1],
 				      sizeof(frame->extramask));
 	}
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip =3D (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip =3D (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip =3D (unsigned long)&frame->retcode;
@@ -265,42 +265,38 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
=20
-	regs->irp =3D (unsigned long) ka->sa.sa_handler;  /* what we enter NOW   =
*/
+	regs->irp =3D (unsigned long) ksig->ka.sa.sa_handler;  /* what we enter N=
OW   */
 	regs->srp =3D return_ip;                          /* what we enter LATER =
*/
-	regs->r10 =3D sig;                                /* first argument is si=
gno */
+	regs->r10 =3D ksig->sig;                                /* first argument=
 is signo */
=20
 	/* actually move the usp to reflect the stacked frame */
=20
 	wrusp((unsigned long)frame);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long return_ip;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Clear all the bits of the ucontext we don't use.  */
         err |=3D __clear_user(&frame->uc, offsetof(struct ucontext, uc_mco=
ntext));
@@ -312,12 +308,12 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	err |=3D __save_altstack(&frame->uc.uc_stack, rdusp());
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip =3D (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip =3D (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip =3D (unsigned long)&frame->retcode;
@@ -329,18 +325,18 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* TODO what is the current->exec_domain stuff and invmap ? */
=20
 	/* Set up registers for signal handler */
=20
 	/* What we enter NOW   */
-	regs->irp =3D (unsigned long) ka->sa.sa_handler;
+	regs->irp =3D (unsigned long) ksig->ka.sa.sa_handler;
 	/* What we enter LATER */
 	regs->srp =3D return_ip;
 	/* First argument is signo */
-	regs->r10 =3D sig;
+	regs->r10 =3D ksig->sig;
 	/* Second argument is (siginfo_t *) */
 	regs->r11 =3D (unsigned long)&frame->info;
 	/* Third argument is unused */
@@ -350,19 +346,14 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	wrusp((unsigned long)frame);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /*
  * OK, we're invoking a handler
  */
=20
-static inline void handle_signal(int canrestart, unsigned long sig,
-	siginfo_t *info, struct k_sigaction *ka,
-	struct pt_regs *regs)
+static inline void handle_signal(int canrestart, struct ksignal *ksig,
+				 struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -383,7 +374,7 @@ static inline void handle_signal(int canrestart, unsign=
ed long sig,
 			/* ERESTARTSYS means to restart the syscall if
 			 * there is no handler or the handler was
 			 * registered with SA_RESTART */
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->r10 =3D -EINTR;
 				break;
 			}
@@ -396,13 +387,12 @@ static inline void handle_signal(int canrestart, unsi=
gned long sig,
 	}
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
+		ret =3D setup_frame(ksig, oldset, regs);
=20
-	if (ret =3D=3D 0)
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -419,9 +409,7 @@ static inline void handle_signal(int canrestart, unsign=
ed long sig,
=20
 void do_signal(int canrestart, struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-        struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which
@@ -432,10 +420,9 @@ void do_signal(int canrestart, struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, regs);
+		handle_signal(canrestart, &ksig, regs);
 		return;
 	}
=20
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel=
/signal.c
index 01d1375c9004..cc7a39a74aec 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -215,23 +215,22 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *=
 regs, size_t frame_size)
  * trampoline.
   */
 static int
-setup_frame(int sig, struct k_sigaction *ka,  sigset_t *set,
-	    struct pt_regs * regs)
+setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	int err;
 	unsigned long return_ip;
 	struct signal_frame __user *frame;
=20
 	err =3D 0;
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D setup_sigcontext(&frame->sc, regs, set->sig[0]);
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (_NSIG_WORDS > 1) {
 		err |=3D __copy_to_user(frame->extramask, &set->sig[1],
@@ -239,14 +238,14 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_=
t *set,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Set up to return from user-space. If provided, use a stub
 	 * already located in user-space.
 	 */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip =3D (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip =3D (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* Trampoline - the desired return ip is in the signal return page. */
 		return_ip =3D cris_signal_return_page;
@@ -264,7 +263,7 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_t =
*set,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Set up registers for signal handler.
@@ -273,42 +272,37 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_=
t *set,
 	 * Where the code enter later.
 	 * First argument, signo.
 	 */
-	regs->erp =3D (unsigned long) ka->sa.sa_handler;
+	regs->erp =3D (unsigned long) ksig->ka.sa.sa_handler;
 	regs->srp =3D return_ip;
-	regs->r10 =3D sig;
+	regs->r10 =3D ksig->sig;
=20
 	/* Actually move the USP to reflect the stacked frame. */
 	wrusp((unsigned long)frame);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs * regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	int err;
 	unsigned long return_ip;
 	struct rt_signal_frame __user *frame;
=20
 	err =3D 0;
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* TODO: what is the current->exec_domain stuff and invmap ? */
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Clear all the bits of the ucontext we don't use.  */
 	err |=3D __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
@@ -317,14 +311,14 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 	err |=3D __save_altstack(&frame->uc.uc_stack, rdusp());
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Set up to return from user-space. If provided, use a stub
 	 * already located in user-space.
 	 */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip =3D (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip =3D (unsigned long) ksig->ka.sa.sa_restorer;
 	} else {
 		/* Trampoline - the desired return ip is in the signal return page. */
 		return_ip =3D cris_signal_return_page + 6;
@@ -345,7 +339,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Set up registers for signal handler.
@@ -356,9 +350,9 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	 * Second argument is (siginfo_t *).
 	 * Third argument is unused.
 	 */
-	regs->erp =3D (unsigned long) ka->sa.sa_handler;
+	regs->erp =3D (unsigned long) ksig->ka.sa.sa_handler;
 	regs->srp =3D return_ip;
-	regs->r10 =3D sig;
+	regs->r10 =3D ksig->sig;
 	regs->r11 =3D (unsigned long) &frame->info;
 	regs->r12 =3D 0;
=20
@@ -366,17 +360,11 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 	wrusp((unsigned long)frame);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /* Invoke a signal handler to, well, handle the signal. */
 static inline void
-handle_signal(int canrestart, unsigned long sig,
-	      siginfo_t *info, struct k_sigaction *ka,
-              struct pt_regs * regs)
+handle_signal(int canrestart, struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -404,7 +392,7 @@ handle_signal(int canrestart, unsigned long sig,
                                  * there is no handler, or the handler
                                  * was registered with SA_RESTART.
 				 */
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
+				if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 					regs->r10 =3D -EINTR;
 					break;
 				}
@@ -423,13 +411,12 @@ handle_signal(int canrestart, unsigned long sig,
         }
=20
 	/* Set up the stack frame. */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
+		ret =3D setup_frame(ksig, oldset, regs);
=20
-	if (ret =3D=3D 0)
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -446,9 +433,7 @@ handle_signal(int canrestart, unsigned long sig,
 void
 do_signal(int canrestart, struct pt_regs *regs)
 {
-	int signr;
-	siginfo_t info;
-        struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * The common case should go fast, which is why this point is
@@ -458,11 +443,9 @@ do_signal(int canrestart, struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, regs);
+		handle_signal(canrestart, &ksig, regs);
 		return;
 	}
=20
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index d822700d4f15..8e37cf237e6d 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -180,17 +180,17 @@ static inline void __user *get_sigframe(struct k_siga=
ction *ka,
 /*
  *
  */
-static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
+static int setup_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct sigframe __user *frame;
-	int rsig;
+	int rsig, sig =3D ksig->sig;
=20
 	set_fs(USER_DS);
=20
-	frame =3D get_sigframe(ka, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	rsig =3D sig;
 	if (sig < 32 &&
@@ -199,22 +199,22 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, sigset_t *set)
 		rsig =3D __current_thread_info->exec_domain->signal_invmap[sig];
=20
 	if (__put_user(rsig, &frame->sig) < 0)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (setup_sigcontext(&frame->sc, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (_NSIG_WORDS > 1) {
 		if (__copy_to_user(frame->extramask, &set->sig[1],
 				   sizeof(frame->extramask)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	 * already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode) < 0)
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode) < 0)
+			return -EFAULT;
 	}
 	else {
 		/* Set up the following code on the stack:
@@ -224,7 +224,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 sigset_t *set)
 		if (__put_user((__sigrestore_t)frame->retcode, &frame->pretcode) ||
 		    __put_user(0x8efc0000|__NR_sigreturn, &frame->retcode[0]) ||
 		    __put_user(0xc0700000, &frame->retcode[1]))
-			goto give_sigsegv;
+			return -EFAULT;
=20
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) (frame->retcode + 2));
@@ -233,14 +233,14 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, sigset_t *set)
 	/* Set up registers for the signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =3D
-			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *) ksig->ka.sa.sa_handler;
 		struct fdpic_func_descriptor desc;
 		if (copy_from_user(&desc, funcptr, sizeof(desc)))
-			goto give_sigsegv;
+			return -EFAULT;
 		__frame->pc =3D desc.text;
 		__frame->gr15 =3D desc.GOT;
 	} else {
-		__frame->pc   =3D (unsigned long) ka->sa.sa_handler;
+		__frame->pc   =3D (unsigned long) ksig->ka.sa.sa_handler;
 		__frame->gr15 =3D 0;
 	}
=20
@@ -255,29 +255,23 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, sigset_t *set)
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
-
 } /* end setup_frame() */
=20
 /*************************************************************************=
****/
 /*
  *
  */
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int rsig;
+	int rsig, sig =3D ksig->sig;
=20
 	set_fs(USER_DS);
=20
-	frame =3D get_sigframe(ka, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	rsig =3D sig;
 	if (sig < 32 &&
@@ -288,28 +282,28 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	if (__put_user(rsig,		&frame->sig) ||
 	    __put_user(&frame->info,	&frame->pinfo) ||
 	    __put_user(&frame->uc,	&frame->puc))
-		goto give_sigsegv;
+		return -EFAULT;
=20
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
=20
 	/* Create the ucontext.  */
 	if (__put_user(0, &frame->uc.uc_flags) ||
 	    __put_user(NULL, &frame->uc.uc_link) ||
 	    __save_altstack(&frame->uc.uc_stack, __frame->sp))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (setup_sigcontext(&frame->uc.uc_mcontext, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (__copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	 * already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
 	}
 	else {
 		/* Set up the following code on the stack:
@@ -319,7 +313,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 		if (__put_user((__sigrestore_t)frame->retcode, &frame->pretcode) ||
 		    __put_user(0x8efc0000|__NR_rt_sigreturn, &frame->retcode[0]) ||
 		    __put_user(0xc0700000, &frame->retcode[1]))
-			goto give_sigsegv;
+			return -EFAULT;
=20
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) (frame->retcode + 2));
@@ -328,14 +322,14 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	/* Set up registers for signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =3D
-			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *) ksig->ka.sa.sa_handler;
 		struct fdpic_func_descriptor desc;
 		if (copy_from_user(&desc, funcptr, sizeof(desc)))
-			goto give_sigsegv;
+			return -EFAULT;
 		__frame->pc =3D desc.text;
 		__frame->gr15 =3D desc.GOT;
 	} else {
-		__frame->pc   =3D (unsigned long) ka->sa.sa_handler;
+		__frame->pc   =3D (unsigned long) ksig->ka.sa.sa_handler;
 		__frame->gr15 =3D 0;
 	}
=20
@@ -349,21 +343,15 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	       sig, current->comm, current->pid, frame, __frame->pc,
 	       frame->pretcode);
 #endif
-
 	return 0;
=20
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
-
 } /* end setup_rt_frame() */
=20
 /*************************************************************************=
****/
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, siginfo_t *info,
-			 struct k_sigaction *ka)
+static void handle_signal(struct ksignal *ksig)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -378,7 +366,7 @@ static void handle_signal(unsigned long sig, siginfo_t =
*info,
 			break;
=20
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				__frame->gr8 =3D -EINTR;
 				break;
 			}
@@ -392,16 +380,12 @@ static void handle_signal(unsigned long sig, siginfo_=
t *info,
 	}
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset);
 	else
-		ret =3D setup_frame(sig, ka, oldset);
-
-	if (ret)
-		return;
+		ret =3D setup_frame(ksig, oldset);
=20
-	signal_delivered(sig, info, ka, __frame,
-				 test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 } /* end handle_signal() */
=20
 /*************************************************************************=
****/
@@ -412,13 +396,10 @@ static void handle_signal(unsigned long sig, siginfo_=
t *info,
  */
 static void do_signal(void)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, __frame, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &info, &ka);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig);
 		return;
 	}
=20
diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index d7c73874b515..6525358630d4 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -112,20 +112,20 @@ static int restore_sigcontext(struct pt_regs *regs,
 /*
  * Setup signal stack frame with siginfo structure
  */
-static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *in=
fo,
-			  sigset_t *set,  struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	int err =3D 0;
 	struct rt_sigframe __user *frame;
 	struct hexagon_vdso *vdso =3D current->mm->context.vdso;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(struct rt_sigframe)))
-		goto	sigsegv;
+		return -EFAULT;
=20
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto	sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
=20
 	/* The on-stack signal trampoline is no longer executed;
 	 * however, the libgcc signal frame unwinding code checks for
@@ -137,29 +137,26 @@ static int setup_rt_frame(int signr, struct k_sigacti=
on *ka, siginfo_t *info,
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	err |=3D __save_altstack(&frame->uc.uc_stack, user_stack_pointer(regs));
 	if (err)
-		goto sigsegv;
+		return -EFAULT;
=20
 	/* Load r0/r1 pair with signumber/siginfo pointer... */
 	regs->r0100 =3D ((unsigned long long)((unsigned long)&frame->info) << 32)
-		| (unsigned long long)signr;
+		| (unsigned long long)ksig->sig;
 	regs->r02 =3D (unsigned long) &frame->uc;
 	regs->r31 =3D (unsigned long) vdso->rt_signal_trampoline;
 	pt_psp(regs) =3D (unsigned long) frame;
-	pt_set_elr(regs, (unsigned long)ka->sa.sa_handler);
+	pt_set_elr(regs, (unsigned long)ksig->ka.sa.sa_handler);
=20
 	return 0;
-
-sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
 /*
  * Setup invocation of signal handler
  */
-static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/*
 	 * If we're handling a signal that aborted a system call,
 	 * set up the error return value before adding the signal
@@ -173,7 +170,7 @@ static void handle_signal(int sig, siginfo_t *info, str=
uct k_sigaction *ka,
 			regs->r00 =3D -EINTR;
 			break;
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->r00 =3D -EINTR;
 				break;
 			}
@@ -193,11 +190,9 @@ static void handle_signal(int sig, siginfo_t *info, st=
ruct k_sigaction *ka,
 	 * only set up the rt_frame flavor.
 	 */
 	/* If there was an error on setup, no signal was delivered. */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		return;
+	ret =3D setup_rt_frame(ksig, sigmask_to_save(), regs);
=20
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 /*
@@ -205,17 +200,13 @@ static void handle_signal(int sig, siginfo_t *info, s=
truct k_sigaction *ka,
  */
 void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction sigact;
-	siginfo_t info;
-	int signo;
+	struct ksignal ksig;
=20
 	if (!user_mode(regs))
 		return;
=20
-	signo =3D get_signal_to_deliver(&info, &sigact, regs, NULL);
-
-	if (signo > 0) {
-		handle_signal(signo, &info, &sigact, regs);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 33cab9a8adff..6d92170be457 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -309,12 +309,11 @@ force_sigsegv_info (int sig, void __user *addr)
 	si.si_uid =3D from_kuid_munged(current_user_ns(), current_uid());
 	si.si_addr =3D addr;
 	force_sig_info(SIGSEGV, &si, current);
-	return 0;
+	return 1;
 }
=20
 static long
-setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *s=
et,
-	     struct sigscratch *scr)
+setup_frame(struct ksignal *ksig, sigset_t *set, struct sigscratch *scr)
 {
 	extern char __kernel_sigtramp[];
 	unsigned long tramp_addr, new_rbs =3D 0, new_sp;
@@ -323,7 +322,7 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo_t=
 *info, sigset_t *set,
=20
 	new_sp =3D scr->pt.r12;
 	tramp_addr =3D (unsigned long) __kernel_sigtramp;
-	if (ka->sa.sa_flags & SA_ONSTACK) {
+	if (ksig->ka.sa.sa_flags & SA_ONSTACK) {
 		int onstack =3D sas_ss_flags(new_sp);
=20
 		if (onstack =3D=3D 0) {
@@ -347,29 +346,29 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo=
_t *info, sigset_t *set,
 			 */
 			check_sp =3D (new_sp - sizeof(*frame)) & -STACK_ALIGN;
 			if (!likely(on_sig_stack(check_sp)))
-				return force_sigsegv_info(sig, (void __user *)
+				return force_sigsegv_info(ksig->sig, (void __user *)
 							  check_sp);
 		}
 	}
 	frame =3D (void __user *) ((new_sp - sizeof(*frame)) & -STACK_ALIGN);
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		return force_sigsegv_info(sig, frame);
+		return force_sigsegv_info(ksig->sig, frame);
=20
-	err  =3D __put_user(sig, &frame->arg0);
+	err  =3D __put_user(ksig->sig, &frame->arg0);
 	err |=3D __put_user(&frame->info, &frame->arg1);
 	err |=3D __put_user(&frame->sc, &frame->arg2);
 	err |=3D __put_user(new_rbs, &frame->sc.sc_rbs_base);
 	err |=3D __put_user(0, &frame->sc.sc_loadrs);	/* initialize to zero */
-	err |=3D __put_user(ka->sa.sa_handler, &frame->handler);
+	err |=3D __put_user(ksig->ka.sa.sa_handler, &frame->handler);
=20
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	err |=3D __save_altstack(&frame->sc.sc_stack, scr->pt.r12);
 	err |=3D setup_sigcontext(&frame->sc, set, scr);
=20
 	if (unlikely(err))
-		return force_sigsegv_info(sig, frame);
+		return force_sigsegv_info(ksig->sig, frame);
=20
 	scr->pt.r12 =3D (unsigned long) frame - 16;	/* new stack pointer */
 	scr->pt.ar_fpsr =3D FPSR_DEFAULT;			/* reset fpsr for signal handler */
@@ -394,22 +393,20 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo=
_t *info, sigset_t *set,
=20
 #if DEBUG_SIG
 	printk("SIG deliver (%s:%d): sig=3D%d sp=3D%lx ip=3D%lx handler=3D%p\n",
-	       current->comm, current->pid, sig, scr->pt.r12, frame->sc.sc_ip, fr=
ame->handler);
+	       current->comm, current->pid, ksig->sig, scr->pt.r12, frame->sc.sc_=
ip, frame->handler);
 #endif
-	return 1;
+	return 0;
 }
=20
 static long
-handle_signal (unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	       struct sigscratch *scr)
+handle_signal (struct ksignal *ksig, struct sigscratch *scr)
 {
-	if (!setup_frame(sig, ka, info, sigmask_to_save(), scr))
-		return 0;
+	int ret =3D setup_frame(ksig, sigmask_to_save(), scr);
=20
-	signal_delivered(sig, info, ka, &scr->pt,
-				 test_thread_flag(TIF_SINGLESTEP));
+	if (!ret)
+		signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
=20
-	return 1;
+	return ret;
 }
=20
 /*
@@ -419,17 +416,16 @@ handle_signal (unsigned long sig, struct k_sigaction =
*ka, siginfo_t *info,
 void
 ia64_do_signal (struct sigscratch *scr, long in_syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
 	long restart =3D in_syscall;
 	long errno =3D scr->pt.r8;
+	struct ksignal ksig;
=20
 	/*
 	 * This only loops in the rare cases of handle_signal() failing, in which=
 case we
 	 * need to push through a forced SIGSEGV.
 	 */
 	while (1) {
-		int signr =3D get_signal_to_deliver(&info, &ka, &scr->pt, NULL);
+		get_signal(&ksig);
=20
 		/*
 		 * get_signal_to_deliver() may have run a debugger (via notify_parent())
@@ -446,7 +442,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 			 */
 			restart =3D 0;
=20
-		if (signr <=3D 0)
+		if (ksig.sig <=3D 0)
 			break;
=20
 		if (unlikely(restart)) {
@@ -458,7 +454,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 				break;
=20
 			      case ERESTARTSYS:
-				if ((ka.sa.sa_flags & SA_RESTART) =3D=3D 0) {
+				if ((ksig.ka.sa.sa_flags & SA_RESTART) =3D=3D 0) {
 					scr->pt.r8 =3D EINTR;
 					/* note: scr->pt.r10 is already -1 */
 					break;
@@ -473,7 +469,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 		 * Whee!  Actually deliver the signal.  If the delivery failed, we need =
to
 		 * continue to iterate in this loop so we can deliver the SIGSEGV...
 		 */
-		if (handle_signal(signr, &ka, &info, scr))
+		if (handle_signal(&ksig, scr))
 			return;
 	}
=20
diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index d503568cb753..cce3fd3ae923 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -173,17 +173,17 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp=
, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8ul);
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err =3D 0;
-	int signal;
+	int signal, sig =3D ksig->sig;
=20
-	frame =3D get_sigframe(ka, regs->spu, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs->spu, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -193,13 +193,13 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
=20
 	err |=3D __put_user(signal, &frame->sig);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -208,17 +208,17 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0]);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  */
-	regs->lr =3D (unsigned long)ka->sa.sa_restorer;
+	regs->lr =3D (unsigned long)ksig->ka.sa.sa_restorer;
=20
 	/* Set up registers for signal handler */
 	regs->spu =3D (unsigned long)frame;
 	regs->r0 =3D signal;	/* Arg for signal handler */
 	regs->r1 =3D (unsigned long)&frame->info;
 	regs->r2 =3D (unsigned long)&frame->uc;
-	regs->bpc =3D (unsigned long)ka->sa.sa_handler;
+	regs->bpc =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 	set_fs(USER_DS);
=20
@@ -228,10 +228,6 @@ static int setup_rt_frame(int sig, struct k_sigaction =
*ka, siginfo_t *info,
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 static int prev_insn(struct pt_regs *regs)
@@ -252,9 +248,10 @@ static int prev_insn(struct pt_regs *regs)
  */
=20
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (regs->syscall_nr >=3D 0) {
 		/* If so, check system call restarting.. */
@@ -265,7 +262,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka=
, siginfo_t *info,
 				break;
=20
 			case -ERESTARTSYS:
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
+				if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 					regs->r0 =3D -EINTR;
 					break;
 				}
@@ -278,10 +275,9 @@ handle_signal(unsigned long sig, struct k_sigaction *k=
a, siginfo_t *info,
 	}
=20
 	/* Set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs))
-		return;
+	ret =3D setup_rt_frame(ksig, sigmask_to_save(), regs);
=20
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -291,9 +287,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka=
, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which
@@ -304,8 +298,7 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
@@ -313,7 +306,7 @@ static void do_signal(struct pt_regs *regs)
 		 */
=20
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
=20
 		return;
 	}
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 57fd286e4b0b..c8e6fa865996 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -850,23 +850,23 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *=
regs, size_t frame_size)
 	return (void __user *)((usp - frame_size) & -8UL);
 }
=20
-static int setup_frame (int sig, struct k_sigaction *ka,
-			 sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+			struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	int fsize =3D frame_extra_sizes(regs->format);
 	struct sigcontext context;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
=20
 	if (fsize < 0) {
 #ifdef DEBUG
 		printk ("setup_frame: Unknown frame format %#x\n",
 			regs->format);
 #endif
-		goto give_sigsegv;
+		return -EFAULT;
 	}
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame) + fsize);
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame) + fsize);
=20
 	if (fsize)
 		err |=3D copy_to_user (frame + 1, regs + 1, fsize);
@@ -899,7 +899,7 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 #endif
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	push_cache ((unsigned long) &frame->retcode);
=20
@@ -908,7 +908,7 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 	 * to destroy is successfully copied to sigframe.
 	 */
 	wrusp ((unsigned long) frame);
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
 	adjustformat(regs);
=20
 	/*
@@ -934,28 +934,24 @@ static int setup_frame (int sig, struct k_sigaction *=
ka,
 		tregs->sr =3D regs->sr;
 	}
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return err;
 }
=20
-static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *inf=
o,
-			    sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			   struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int fsize =3D frame_extra_sizes(regs->format);
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
=20
 	if (fsize < 0) {
 #ifdef DEBUG
 		printk ("setup_frame: Unknown frame format %#x\n",
 			regs->format);
 #endif
-		goto give_sigsegv;
+		return -EFAULT;
 	}
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (fsize)
 		err |=3D copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);
@@ -968,7 +964,7 @@ static int setup_rt_frame (int sig, struct k_sigaction =
*ka, siginfo_t *info,
 			  &frame->sig);
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -996,7 +992,7 @@ static int setup_rt_frame (int sig, struct k_sigaction =
*ka, siginfo_t *info,
 #endif /* CONFIG_MMU */
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	push_cache ((unsigned long) &frame->retcode);
=20
@@ -1005,7 +1001,7 @@ static int setup_rt_frame (int sig, struct k_sigactio=
n *ka, siginfo_t *info,
 	 * to destroy is successfully copied to sigframe.
 	 */
 	wrusp ((unsigned long) frame);
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
 	adjustformat(regs);
=20
 	/*
@@ -1031,10 +1027,6 @@ static int setup_rt_frame (int sig, struct k_sigacti=
on *ka, siginfo_t *info,
 		tregs->sr =3D regs->sr;
 	}
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return err;
 }
=20
 static inline void
@@ -1074,26 +1066,22 @@ handle_restart(struct pt_regs *regs, struct k_sigac=
tion *ka, int has_handler)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int err;
 	/* are we from a system call? */
 	if (regs->orig_d0 >=3D 0)
 		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
+		handle_restart(regs, &ksig->ka, 1);
=20
 	/* set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		err =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		err =3D setup_frame(sig, ka, oldset, regs);
-
-	if (err)
-		return;
+		err =3D setup_frame(ksig, oldset, regs);
=20
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(err, ksig, 0);
=20
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &=3D ~0x8000;
@@ -1108,16 +1096,13 @@ handle_signal(int sig, struct k_sigaction *ka, sigi=
nfo_t *info,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	struct k_sigaction ka;
-	int signr;
+	struct ksignal ksig;
=20
 	current->thread.esp0 =3D (unsigned long) regs;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signa=
l.c
index 49a07a4d76d0..83137e868e19 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -156,11 +156,11 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *=
regs, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8UL);
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
 	unsigned long address =3D 0;
 #ifdef CONFIG_MMU
@@ -168,10 +168,10 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	pte_t *ptep;
 #endif
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -179,8 +179,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
=20
-	if (info)
-		err |=3D copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Create the ucontext. */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -227,7 +227,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	flush_dcache_range(address, address + 8);
 #endif
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->r1 =3D (unsigned long) frame;
@@ -237,7 +237,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	regs->r6 =3D (unsigned long) &frame->info; /* arg 1: siginfo */
 	regs->r7 =3D (unsigned long) &frame->uc; /* arg2: ucontext */
 	/* Offset to handle microblaze rtid r14, 0 */
-	regs->pc =3D (unsigned long)ka->sa.sa_handler;
+	regs->pc =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 	set_fs(USER_DS);
=20
@@ -247,10 +247,6 @@ static int setup_rt_frame(int sig, struct k_sigaction =
*ka, siginfo_t *info,
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /* Handle restarting system calls */
@@ -283,23 +279,15 @@ handle_restart(struct pt_regs *regs, struct k_sigacti=
on *ka, int has_handler)
  */
=20
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka,
-		siginfo_t *info, struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
-	else
-		ret =3D setup_rt_frame(sig, ka, NULL, oldset, regs);
+	ret =3D setup_rt_frame(ksig, oldset, regs);
=20
-	if (ret)
-		return;
-
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 /*
@@ -313,21 +301,19 @@ handle_signal(unsigned long sig, struct k_sigaction *=
ka,
  */
 static void do_signal(struct pt_regs *regs, int in_syscall)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
+
 #ifdef DEBUG_SIG
 	pr_info("do signal: %p %d\n", regs, in_syscall);
 	pr_info("do signal2: %lx %lx %ld [%lx]\n", regs->pc, regs->r1,
 			regs->r12, current_thread_info()->flags);
 #endif
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
-			handle_restart(regs, &ka, 1);
-		handle_signal(signr, &ka, &info, regs);
+			handle_restart(regs, &ksig.ka, 1);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/mips/include/asm/abi.h b/arch/mips/include/asm/abi.h
index 909bb6984866..7186bb51b89b 100644
--- a/arch/mips/include/asm/abi.h
+++ b/arch/mips/include/asm/abi.h
@@ -13,13 +13,11 @@
 #include <asm/siginfo.h>
=20
 struct mips_abi {
-	int (* const setup_frame)(void *sig_return, struct k_sigaction *ka,
-				  struct pt_regs *regs, int signr,
-				  sigset_t *set);
+	int (* const setup_frame)(void *sig_return, struct ksignal *ksig,
+				  struct pt_regs *regs, sigset_t *set);
 	const unsigned long	signal_return_offset;
-	int (* const setup_rt_frame)(void *sig_return, struct k_sigaction *ka,
-			       struct pt_regs *regs, int signr,
-			       sigset_t *set, siginfo_t *info);
+	int (* const setup_rt_frame)(void *sig_return, struct ksignal *ksig,
+				     struct pt_regs *regs, sigset_t *set);
 	const unsigned long	rt_signal_return_offset;
 	const unsigned long	restart;
 };
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index dae2b8f9cd37..1e024e2edb88 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -373,7 +373,7 @@ static inline int is_sp_move_ins(union mips_instruction=
 *ip)
 static int get_frame_info(struct mips_frame_info *info)
 {
 	bool is_mmips =3D IS_ENABLED(CONFIG_CPU_MICROMIPS);
-	union mips_instruction insn, *ip, *ip_end;
+	union mips_instruction insn, *ip;
 	const unsigned int max_insns =3D 128;
 	unsigned int last_insn_size =3D 0;
 	unsigned int i;
@@ -385,10 +385,9 @@ static int get_frame_info(struct mips_frame_info *info)
 	if (!ip)
 		goto err;
=20
-	ip_end =3D (void *)ip + info->func_size;
-
-	for (i =3D 0; i < max_insns && ip < ip_end; i++) {
+	for (i =3D 0; i < max_insns; i++) {
 		ip =3D (void *)ip + last_insn_size;
+
 		if (is_mmips && mm_insn_16bit(ip->halfword[0])) {
 			insn.word =3D ip->halfword[0] << 16;
 			last_insn_size =3D 2;
diff --git a/arch/mips/kernel/signal-common.h b/arch/mips/kernel/signal-com=
mon.h
index 9c60d09e62a7..06805e09bcd3 100644
--- a/arch/mips/kernel/signal-common.h
+++ b/arch/mips/kernel/signal-common.h
@@ -22,7 +22,7 @@
 /*
  * Determine which stack to use..
  */
-extern void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *r=
egs,
+extern void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *reg=
s,
 				 size_t frame_size);
 /* Check and clear pending FPU exceptions in saved CSR */
 extern int fpcsr_pending(unsigned int __user *fpcsr);
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 394e2b12a3ba..16f1e4f2bf3c 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -280,7 +280,7 @@ int restore_sigcontext(struct pt_regs *regs, struct sig=
context __user *sc)
 	return err;
 }
=20
-void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
+void __user *get_sigframe(struct ksignal *ksig, struct pt_regs *regs,
 			  size_t frame_size)
 {
 	unsigned long sp;
@@ -295,9 +295,7 @@ void __user *get_sigframe(struct k_sigaction *ka, struc=
t pt_regs *regs,
 	 */
 	sp -=3D 32;
=20
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags (sp) =3D=3D 0))
-		sp =3D current->sas_ss_sp + current->sas_ss_size;
+	sp =3D sigsp(sp, ksig);
=20
 	return (void __user *)((sp - frame_size) & (ICACHE_REFILLS_WORKAROUND_WAR=
 ? ~(cpu_icache_line_size()-1) : ALMASK));
 }
@@ -428,20 +426,20 @@ asmlinkage void sys_rt_sigreturn(nabi_no_regargs stru=
ct pt_regs regs)
 }
=20
 #ifdef CONFIG_TRAD_SIGNALS
-static int setup_frame(void *sig_return, struct k_sigaction *ka,
-		       struct pt_regs *regs, int signr, sigset_t *set)
+static int setup_frame(void *sig_return, struct ksignal *ksig,
+		       struct pt_regs *regs, sigset_t *set)
 {
 	struct sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D setup_sigcontext(regs, &frame->sf_sc);
 	err |=3D __copy_to_user(&frame->sf_mask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Arguments to signal handler:
@@ -453,37 +451,32 @@ static int setup_frame(void *sig_return, struct k_sig=
action *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to the
 	 * struct sigframe.
 	 */
-	regs->regs[ 4] =3D signr;
+	regs->regs[ 4] =3D ksig->sig;
 	regs->regs[ 5] =3D 0;
 	regs->regs[ 6] =3D (unsigned long) &frame->sf_sc;
 	regs->regs[29] =3D (unsigned long) frame;
 	regs->regs[31] =3D (unsigned long) sig_return;
-	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ksig->ka.sa.sa_handl=
er;
=20
 	DEBUGP("SIG deliver (%s:%d): sp=3D0x%p pc=3D0x%lx ra=3D0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 #endif
=20
-static int setup_rt_frame(void *sig_return, struct k_sigaction *ka,
-			  struct pt_regs *regs, int signr, sigset_t *set,
-			  siginfo_t *info)
+static int setup_rt_frame(void *sig_return, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Create siginfo.  */
-	err |=3D copy_siginfo_to_user(&frame->rs_info, info);
+	err |=3D copy_siginfo_to_user(&frame->rs_info, &ksig->info);
=20
 	/* Create the ucontext.	 */
 	err |=3D __put_user(0, &frame->rs_uc.uc_flags);
@@ -493,7 +486,7 @@ static int setup_rt_frame(void *sig_return, struct k_si=
gaction *ka,
 	err |=3D __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Arguments to signal handler:
@@ -505,22 +498,18 @@ static int setup_rt_frame(void *sig_return, struct k_=
sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe.
 	 */
-	regs->regs[ 4] =3D signr;
+	regs->regs[ 4] =3D ksig->sig;
 	regs->regs[ 5] =3D (unsigned long) &frame->rs_info;
 	regs->regs[ 6] =3D (unsigned long) &frame->rs_uc;
 	regs->regs[29] =3D (unsigned long) frame;
 	regs->regs[31] =3D (unsigned long) sig_return;
-	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ksig->ka.sa.sa_handl=
er;
=20
 	DEBUGP("SIG deliver (%s:%d): sp=3D0x%p pc=3D0x%lx ra=3D0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
 struct mips_abi mips_abi =3D {
@@ -534,8 +523,7 @@ struct mips_abi mips_abi =3D {
 	.restart	=3D __NR_restart_syscall
 };
=20
-static void handle_signal(unsigned long sig, siginfo_t *info,
-	struct k_sigaction *ka, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -557,7 +545,7 @@ static void handle_signal(unsigned long sig, siginfo_t =
*info,
 			regs->regs[2] =3D EINTR;
 			break;
 		case ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->regs[2] =3D EINTR;
 				break;
 			}
@@ -571,29 +559,23 @@ static void handle_signal(unsigned long sig, siginfo_=
t *info,
 		regs->regs[0] =3D 0;		/* Don't deal with this again.	*/
 	}
=20
-	if (sig_uses_siginfo(ka))
+	if (sig_uses_siginfo(&ksig->ka))
 		ret =3D abi->setup_rt_frame(vdso + abi->rt_signal_return_offset,
-					  ka, regs, sig, oldset, info);
+					  ksig, regs, oldset);
 	else
-		ret =3D abi->setup_frame(vdso + abi->signal_return_offset,
-				       ka, regs, sig, oldset);
-
-	if (ret)
-		return;
+		ret =3D abi->setup_frame(vdso + abi->signal_return_offset, ksig,
+				       regs, oldset);
=20
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 static void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.	*/
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 6999c461d844..f019f100a4bd 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -488,21 +488,21 @@ asmlinkage void sys32_rt_sigreturn(nabi_no_regargs st=
ruct pt_regs regs)
 	force_sig(SIGSEGV, current);
 }
=20
-static int setup_frame_32(void *sig_return, struct k_sigaction *ka,
-			  struct pt_regs *regs, int signr, sigset_t *set)
+static int setup_frame_32(void *sig_return, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct sigframe32 __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	err |=3D setup_sigcontext32(regs, &frame->sf_sc);
 	err |=3D __copy_conv_sigset_to_user(&frame->sf_mask, set);
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Arguments to signal handler:
@@ -514,37 +514,32 @@ static int setup_frame_32(void *sig_return, struct k_=
sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to the
 	 * struct sigframe.
 	 */
-	regs->regs[ 4] =3D signr;
+	regs->regs[ 4] =3D ksig->sig;
 	regs->regs[ 5] =3D 0;
 	regs->regs[ 6] =3D (unsigned long) &frame->sf_sc;
 	regs->regs[29] =3D (unsigned long) frame;
 	regs->regs[31] =3D (unsigned long) sig_return;
-	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ksig->ka.sa.sa_handl=
er;
=20
 	DEBUGP("SIG deliver (%s:%d): sp=3D0x%p pc=3D0x%lx ra=3D0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame_32(void *sig_return, struct k_sigaction *ka,
-			     struct pt_regs *regs, int signr, sigset_t *set,
-			     siginfo_t *info)
+static int setup_rt_frame_32(void *sig_return, struct ksignal *ksig,
+			     struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe32 __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Convert (siginfo_t -> compat_siginfo_t) and copy to user. */
-	err |=3D copy_siginfo_to_user32(&frame->rs_info, info);
+	err |=3D copy_siginfo_to_user32(&frame->rs_info, &ksig->info);
=20
 	/* Create the ucontext.	 */
 	err |=3D __put_user(0, &frame->rs_uc.uc_flags);
@@ -554,7 +549,7 @@ static int setup_rt_frame_32(void *sig_return, struct k=
_sigaction *ka,
 	err |=3D __copy_conv_sigset_to_user(&frame->rs_uc.uc_sigmask, set);
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Arguments to signal handler:
@@ -566,22 +561,18 @@ static int setup_rt_frame_32(void *sig_return, struct=
 k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe32.
 	 */
-	regs->regs[ 4] =3D signr;
+	regs->regs[ 4] =3D ksig->sig;
 	regs->regs[ 5] =3D (unsigned long) &frame->rs_info;
 	regs->regs[ 6] =3D (unsigned long) &frame->rs_uc;
 	regs->regs[29] =3D (unsigned long) frame;
 	regs->regs[31] =3D (unsigned long) sig_return;
-	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ksig->ka.sa.sa_handl=
er;
=20
 	DEBUGP("SIG deliver (%s:%d): sp=3D0x%p pc=3D0x%lx ra=3D0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
 /*
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index b2241bb9cac1..f1d4751eead0 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -102,18 +102,18 @@ asmlinkage void sysn32_rt_sigreturn(nabi_no_regargs s=
truct pt_regs regs)
 	force_sig(SIGSEGV, current);
 }
=20
-static int setup_rt_frame_n32(void *sig_return, struct k_sigaction *ka,
-	struct pt_regs *regs, int signr, sigset_t *set, siginfo_t *info)
+static int setup_rt_frame_n32(void *sig_return, struct ksignal *ksig,
+			      struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe_n32 __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Create siginfo.  */
-	err |=3D copy_siginfo_to_user32(&frame->rs_info, info);
+	err |=3D copy_siginfo_to_user32(&frame->rs_info, &ksig->info);
=20
 	/* Create the ucontext.	 */
 	err |=3D __put_user(0, &frame->rs_uc.uc_flags);
@@ -123,7 +123,7 @@ static int setup_rt_frame_n32(void *sig_return, struct =
k_sigaction *ka,
 	err |=3D __copy_conv_sigset_to_user(&frame->rs_uc.uc_sigmask, set);
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Arguments to signal handler:
@@ -135,22 +135,18 @@ static int setup_rt_frame_n32(void *sig_return, struc=
t k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe.
 	 */
-	regs->regs[ 4] =3D signr;
+	regs->regs[ 4] =3D ksig->sig;
 	regs->regs[ 5] =3D (unsigned long) &frame->rs_info;
 	regs->regs[ 6] =3D (unsigned long) &frame->rs_uc;
 	regs->regs[29] =3D (unsigned long) frame;
 	regs->regs[31] =3D (unsigned long) sig_return;
-	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc =3D regs->regs[25] =3D (unsigned long) ksig->ka.sa.sa_handl=
er;
=20
 	DEBUGP("SIG deliver (%s:%d): sp=3D0x%p pc=3D0x%lx ra=3D0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
 struct mips_abi mips_abi_n32 =3D {
diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index ab0c5d14c6f7..35b0818dec15 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -371,7 +371,9 @@ int __init octeon_msi_initialize(void)
 	int irq;
 	struct irq_chip *msi;
=20
-	if (octeon_dma_bar_type =3D=3D OCTEON_DMA_BAR_TYPE_PCIE) {
+	if (octeon_dma_bar_type =3D=3D OCTEON_DMA_BAR_TYPE_INVALID) {
+		return 0;
+	} else if (octeon_dma_bar_type =3D=3D OCTEON_DMA_BAR_TYPE_PCIE) {
 		msi_rcv_reg[0] =3D CVMX_PEXP_NPEI_MSI_RCV0;
 		msi_rcv_reg[1] =3D CVMX_PEXP_NPEI_MSI_RCV1;
 		msi_rcv_reg[2] =3D CVMX_PEXP_NPEI_MSI_RCV2;
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index 59cccd95688b..fdd0c29bc276 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -575,6 +575,11 @@ static int __init octeon_pci_setup(void)
 	if (octeon_has_feature(OCTEON_FEATURE_PCIE))
 		return 0;
=20
+	if (!octeon_is_pci_host()) {
+		pr_notice("Not in host mode, PCI Controller not initialized\n");
+		return 0;
+	}
+
 	/* Point pcibios_map_irq() to the PCI version of it */
 	octeon_pcibios_map_irq =3D octeon_pci_pcibios_map_irq;
=20
@@ -586,11 +591,6 @@ static int __init octeon_pci_setup(void)
 	else
 		octeon_dma_bar_type =3D OCTEON_DMA_BAR_TYPE_BIG;
=20
-	if (!octeon_is_pci_host()) {
-		pr_notice("Not in host mode, PCI Controller not initialized\n");
-		return 0;
-	}
-
 	/* PCI I/O and PCI MEM values */
 	set_io_port_base(OCTEON_PCI_IOSPACE_BASE);
 	ioport_resource.start =3D 0;
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 9dfac5cd16e6..0c97202764ce 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -207,16 +207,16 @@ static inline void __user *get_sigframe(struct k_siga=
ction *ka,
 /*
  * set up a normal signal frame
  */
-static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int rsig;
+	int rsig, sig =3D ksig->sig;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	rsig =3D sig;
 	if (sig < 32 &&
@@ -226,40 +226,40 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, sigset_t *set,
=20
 	if (__put_user(rsig, &frame->sig) < 0 ||
 	    __put_user(&frame->sc, &frame->psc) < 0)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (setup_sigcontext(&frame->sc, &frame->fpuctx, regs, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (_NSIG_WORDS > 1) {
 		if (__copy_to_user(frame->extramask, &set->sig[1],
 				   sizeof(frame->extramask)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
=20
 	/* set up to return from userspace.  If provided, use a stub already in
 	 * userspace */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
 	} else {
 		if (__put_user((void (*)(void))frame->retcode,
 			       &frame->pretcode))
-			goto give_sigsegv;
+			return -EFAULT;
 		/* this is mov $,d0; syscall 0 */
 		if (__put_user(0x2c, (char *)(frame->retcode + 0)) ||
 		    __put_user(__NR_sigreturn, (char *)(frame->retcode + 1)) ||
 		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
 		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
 		    __put_user(0xe0, (char *)(frame->retcode + 4)))
-			goto give_sigsegv;
+			return -EFAULT;
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) frame->retcode + 5);
 	}
=20
 	/* set up registers for signal handler */
 	regs->sp =3D (unsigned long) frame;
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
 	regs->d0 =3D sig;
 	regs->d1 =3D (unsigned long) &frame->sc;
=20
@@ -270,25 +270,21 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, sigset_t *set,
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /*
  * set up a realtime signal frame
  */
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int rsig;
+	int rsig, sig =3D ksig->sig;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	rsig =3D sig;
 	if (sig < 32 &&
@@ -299,8 +295,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	if (__put_user(rsig, &frame->sig) ||
 	    __put_user(&frame->info, &frame->pinfo) ||
 	    __put_user(&frame->uc, &frame->puc) ||
-	    copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	    copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
=20
 	/* create the ucontext.  */
 	if (__put_user(0, &frame->uc.uc_flags) ||
@@ -309,13 +305,14 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	    setup_sigcontext(&frame->uc.uc_mcontext,
 			     &frame->fpuctx, regs, set->sig[0]) ||
 	    __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* set up to return from userspace.  If provided, use a stub already in
 	 * userspace */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
+
 	} else {
 		if (__put_user((void(*)(void))frame->retcode,
 			       &frame->pretcode) ||
@@ -326,7 +323,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
 		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
 		    __put_user(0xe0, (char *)(frame->retcode + 4)))
-			goto give_sigsegv;
+			return -EFAULT;
=20
 		flush_icache_range((u_long) frame->retcode,
 				   (u_long) frame->retcode + 5);
@@ -334,7 +331,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
=20
 	/* Set up registers for signal handler */
 	regs->sp =3D (unsigned long) frame;
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
 	regs->d0 =3D sig;
 	regs->d1 =3D (long) &frame->info;
=20
@@ -345,10 +342,6 @@ static int setup_rt_frame(int sig, struct k_sigaction =
*ka, siginfo_t *info,
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 static inline void stepback(struct pt_regs *regs)
@@ -360,9 +353,7 @@ static inline void stepback(struct pt_regs *regs)
 /*
  * handle the actual delivery of a signal to userspace
  */
-static int handle_signal(int sig,
-			 siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static int handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -377,7 +368,7 @@ static int handle_signal(int sig,
 			break;
=20
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->d0 =3D -EINTR;
 				break;
 			}
@@ -390,15 +381,12 @@ static int handle_signal(int sig,
 	}
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
-	if (ret)
-		return ret;
+		ret =3D setup_frame(ksig, oldset, regs);
=20
-	signal_delivered(sig, info, ka, regs,
-			 test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 	return 0;
 }
=20
@@ -407,15 +395,10 @@ static int handle_signal(int sig,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
-
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		if (handle_signal(signr, &info, &ka, regs) =3D=3D 0) {
-		}
+	struct ksignal ksig;
=20
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 78bb6dd88e03..343b538d1450 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -227,8 +227,8 @@ setup_sigcontext(struct sigcontext __user *sc, struct p=
t_regs *regs, int in_sysc
 }
=20
 static long
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs, int in_syscall)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs,
+	       int in_syscall)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long rp, usp;
@@ -241,10 +241,10 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 =09
 	usp =3D (regs->gr[30] & ~(0x01UL));
 	/*FIXME: frame_size parameter is unused, remove it. */
-	frame =3D get_sigframe(ka, usp, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, usp, sizeof(*frame));
=20
 	DBG(1,"SETUP_RT_FRAME: START\n");
-	DBG(1,"setup_rt_frame: frame %p info %p\n", frame, info);
+	DBG(1,"setup_rt_frame: frame %p info %p\n", frame, ksig->info);
=20
 =09
 #ifdef CONFIG_64BIT
@@ -253,7 +253,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 =09
 	if (is_compat_task()) {
 		DBG(1,"setup_rt_frame: frame->info =3D 0x%p\n", &compat_frame->info);
-		err |=3D copy_siginfo_to_user32(&compat_frame->info, info);
+		err |=3D copy_siginfo_to_user32(&compat_frame->info, &ksig->info);
 		err |=3D __compat_save_altstack( &compat_frame->uc.uc_stack, regs->gr[30=
]);
 		DBG(1,"setup_rt_frame: frame->uc =3D 0x%p\n", &compat_frame->uc);
 		DBG(1,"setup_rt_frame: frame->uc.uc_mcontext =3D 0x%p\n", &compat_frame-=
>uc.uc_mcontext);
@@ -265,7 +265,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 #endif
 	{=09
 		DBG(1,"setup_rt_frame: frame->info =3D 0x%p\n", &frame->info);
-		err |=3D copy_siginfo_to_user(&frame->info, info);
+		err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 		err |=3D __save_altstack(&frame->uc.uc_stack, regs->gr[30]);
 		DBG(1,"setup_rt_frame: frame->uc =3D 0x%p\n", &frame->uc);
 		DBG(1,"setup_rt_frame: frame->uc.uc_mcontext =3D 0x%p\n", &frame->uc.uc_=
mcontext);
@@ -275,7 +275,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	}
 =09
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace. The first words of tramp are used to
@@ -312,9 +312,9 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	rp =3D (unsigned long) &frame->tramp[SIGRESTARTBLOCK_TRAMP];
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
-	haddr =3D A(ka->sa.sa_handler);
+	haddr =3D A(ksig->ka.sa.sa_handler);
 	/* The sa_handler may be a pointer to a function descriptor */
 #ifdef CONFIG_64BIT
 	if (is_compat_task()) {
@@ -326,7 +326,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 			err =3D __copy_from_user(&fdesc, ufdesc, sizeof(fdesc));
=20
 			if (err)
-				goto give_sigsegv;
+				return -EFAULT;
=20
 			haddr =3D fdesc.addr;
 			regs->gr[19] =3D fdesc.gp;
@@ -339,7 +339,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 		err =3D __copy_from_user(&fdesc, ufdesc, sizeof(fdesc));
 	=09
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 	=09
 		haddr =3D fdesc.addr;
 		regs->gr[19] =3D fdesc.gp;
@@ -386,7 +386,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo=
_t *info,
 	}
=20
 	regs->gr[2]  =3D rp;                /* userland return pointer */
-	regs->gr[26] =3D sig;               /* signal number */
+	regs->gr[26] =3D ksig->sig;               /* signal number */
 =09
 #ifdef CONFIG_64BIT
 	if (is_compat_task()) {
@@ -410,11 +410,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginf=
o_t *info,
 	       current->comm, current->pid, frame, regs->gr[30],
 	       regs->iaoq[0], regs->iaoq[1], rp);
=20
-	return 1;
-
-give_sigsegv:
-	DBG(1,"setup_rt_frame: sending SIGSEGV\n");
-	force_sigsegv(sig, current);
 	return 0;
 }
=20
@@ -423,20 +418,19 @@ setup_rt_frame(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
  */=09
=20
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs *regs, int in_syscall)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, int in_syscall)
 {
+	int ret;
 	sigset_t *oldset =3D sigmask_to_save();
+
 	DBG(1,"handle_signal: sig=3D%ld, ka=3D%p, info=3D%p, oldset=3D%p, regs=3D=
%p\n",
-	       sig, ka, info, oldset, regs);
+	       ksig->sig, ksig->ka, ksig->info, oldset, regs);
 =09
 	/* Set up the stack frame */
-	if (!setup_rt_frame(sig, ka, info, oldset, regs, in_syscall))
-		return;
+	ret =3D setup_rt_frame(ksig, oldset, regs, in_syscall);
=20
-	signal_delivered(sig, info, ka, regs,=20
-		test_thread_flag(TIF_SINGLESTEP) ||
-		test_thread_flag(TIF_BLOCKSTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP) ||
+			  test_thread_flag(TIF_BLOCKSTEP));
=20
 	DBG(1,KERN_DEBUG "do_signal: Exit (success), regs->gr[28] =3D %ld\n",
 		regs->gr[28]);
@@ -584,22 +578,18 @@ insert_restart_trampoline(struct pt_regs *regs)
 asmlinkage void
 do_signal(struct pt_regs *regs, long in_syscall)
 {
-	siginfo_t info;
-	struct k_sigaction ka;
-	int signr;
+	struct ksignal ksig;
=20
 	DBG(1,"\ndo_signal: regs=3D0x%p, sr7 %#lx, in_syscall=3D%d\n",
 	       regs, regs->sr[7], in_syscall);
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	DBG(3,"do_signal: signr =3D %d, regs->gr[28] =3D %ld\n", signr, regs->gr[=
28]);=20
-=09
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
+		DBG(3,"do_signal: signr =3D %d, regs->gr[28] =3D %ld\n", signr, regs->gr=
[28]);
 		/* Restart a system call if necessary. */
 		if (in_syscall)
-			syscall_restart(regs, &ka);
+			syscall_restart(regs, &ksig.ka);
=20
-		handle_signal(signr, &info, &ka, regs, in_syscall);
+		handle_signal(&ksig, regs, in_syscall);
 		return;
 	}
=20
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 1c794cef2883..984a54c85952 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -31,20 +31,14 @@ int show_unhandled_signals =3D 1;
 /*
  * Allocate space for the signal frame
  */
-void __user * get_sigframe(struct k_sigaction *ka, unsigned long sp,
+void __user *get_sigframe(struct ksignal *ksig, unsigned long sp,
 			   size_t frame_size, int is_32)
 {
         unsigned long oldsp, newsp;
=20
         /* Default to using normal stack */
         oldsp =3D get_clean_sp(sp, is_32);
-
-	/* Check for alt stack */
-	if ((ka->sa.sa_flags & SA_ONSTACK) &&
-	    current->sas_ss_size && !on_sig_stack(oldsp))
-		oldsp =3D (current->sas_ss_sp + current->sas_ss_size);
-
-	/* Get aligned frame */
+	oldsp =3D sigsp(oldsp, ksig);
 	newsp =3D (oldsp - frame_size) & ~0xFUL;
=20
 	/* Check access */
@@ -105,25 +99,23 @@ static void check_syscall_restart(struct pt_regs *regs=
, struct k_sigaction *ka,
 	}
 }
=20
-static int do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig =3D { .sig =3D 0 };
 	int ret;
 	int is32 =3D is_32bit_task();
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
=20
 	/* Is there any syscall restart business here ? */
-	check_syscall_restart(regs, &ka, signr > 0);
+	check_syscall_restart(regs, &ksig.ka, ksig.sig > 0);
=20
-	if (signr <=3D 0) {
+	if (ksig.sig <=3D 0) {
 		/* No signal to deliver -- put the saved sigmask back */
 		restore_saved_sigmask();
 		regs->trap =3D 0;
-		return 0;               /* no signals delivered */
+		return;               /* no signals delivered */
 	}
=20
 #ifndef CONFIG_PPC_ADV_DEBUG_REGS
@@ -140,23 +132,16 @@ static int do_signal(struct pt_regs *regs)
 	thread_change_pc(current, regs);
=20
 	if (is32) {
-        	if (ka.sa.sa_flags & SA_SIGINFO)
-			ret =3D handle_rt_signal32(signr, &ka, &info, oldset,
-					regs);
+        	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
+			ret =3D handle_rt_signal32(&ksig, oldset, regs);
 		else
-			ret =3D handle_signal32(signr, &ka, &info, oldset,
-					regs);
+			ret =3D handle_signal32(&ksig, oldset, regs);
 	} else {
-		ret =3D handle_rt_signal64(signr, &ka, &info, oldset, regs);
+		ret =3D handle_rt_signal64(&ksig, oldset, regs);
 	}
=20
 	regs->trap =3D 0;
-	if (ret) {
-		signal_delivered(signr, &info, &ka, regs,
-					 test_thread_flag(TIF_SINGLESTEP));
-	}
-
-	return ret;
+	signal_setup_done(ret, &ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flag=
s)
diff --git a/arch/powerpc/kernel/signal.h b/arch/powerpc/kernel/signal.h
index c69b9aeb9f23..51b274199dd9 100644
--- a/arch/powerpc/kernel/signal.h
+++ b/arch/powerpc/kernel/signal.h
@@ -12,15 +12,13 @@
=20
 extern void do_notify_resume(struct pt_regs *regs, unsigned long thread_in=
fo_flags);
=20
-extern void __user * get_sigframe(struct k_sigaction *ka, unsigned long sp,
+extern void __user *get_sigframe(struct ksignal *ksig, unsigned long sp,
 				  size_t frame_size, int is_32);
=20
-extern int handle_signal32(unsigned long sig, struct k_sigaction *ka,
-			   siginfo_t *info, sigset_t *oldset,
+extern int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 			   struct pt_regs *regs);
=20
-extern int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
-			      siginfo_t *info, sigset_t *oldset,
+extern int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 			      struct pt_regs *regs);
=20
 extern unsigned long copy_fpr_to_user(void __user *to,
@@ -44,14 +42,12 @@ extern unsigned long copy_transact_vsx_from_user(struct=
 task_struct *task,
=20
 #ifdef CONFIG_PPC64
=20
-extern int handle_rt_signal64(int signr, struct k_sigaction *ka,
-			      siginfo_t *info, sigset_t *set,
+extern int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 			      struct pt_regs *regs);
=20
 #else /* CONFIG_PPC64 */
=20
-static inline int handle_rt_signal64(int signr, struct k_sigaction *ka,
-				     siginfo_t *info, sigset_t *set,
+static inline int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 				     struct pt_regs *regs)
 {
 	return -EFAULT;
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_3=
2.c
index 90ec6856239b..e7e8c4db2651 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1001,9 +1001,8 @@ int copy_siginfo_from_user32(siginfo_t *to, struct co=
mpat_siginfo __user *from)
  * Set up a signal frame for a "real-time" signal handler
  * (one which gets siginfo).
  */
-int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
-		siginfo_t *info, sigset_t *oldset,
-		struct pt_regs *regs)
+int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
+		       struct pt_regs *regs)
 {
 	struct rt_sigframe __user *rt_sf;
 	struct mcontext __user *frame;
@@ -1015,13 +1014,13 @@ int handle_rt_signal32(unsigned long sig, struct k_=
sigaction *ka,
=20
 	/* Set up Signal Frame */
 	/* Put a Real Time Context onto stack */
-	rt_sf =3D get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*rt_sf), 1);
+	rt_sf =3D get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*rt_sf), 1=
);
 	addr =3D rt_sf;
 	if (unlikely(rt_sf =3D=3D NULL))
 		goto badframe;
=20
 	/* Put the siginfo & fill in most of the ucontext */
-	if (copy_siginfo_to_user(&rt_sf->info, info)
+	if (copy_siginfo_to_user(&rt_sf->info, &ksig->info)
 	    || __put_user(0, &rt_sf->uc.uc_flags)
 	    || __save_altstack(&rt_sf->uc.uc_stack, regs->gpr[1])
 	    || __put_user(to_user_ptr(&rt_sf->uc.uc_mcontext),
@@ -1071,15 +1070,15 @@ int handle_rt_signal32(unsigned long sig, struct k_=
sigaction *ka,
=20
 	/* Fill registers for signal handler */
 	regs->gpr[1] =3D newsp;
-	regs->gpr[3] =3D sig;
+	regs->gpr[3] =3D ksig->sig;
 	regs->gpr[4] =3D (unsigned long) &rt_sf->info;
 	regs->gpr[5] =3D (unsigned long) &rt_sf->uc;
 	regs->gpr[6] =3D (unsigned long) rt_sf;
-	regs->nip =3D (unsigned long) ka->sa.sa_handler;
+	regs->nip =3D (unsigned long) ksig->ka.sa.sa_handler;
 	/* enter the signal handler in native-endian mode */
 	regs->msr &=3D ~MSR_LE;
 	regs->msr |=3D (MSR_KERNEL & MSR_LE);
-	return 1;
+	return 0;
=20
 badframe:
 	if (show_unhandled_signals)
@@ -1089,8 +1088,7 @@ int handle_rt_signal32(unsigned long sig, struct k_si=
gaction *ka,
 				   current->comm, current->pid,
 				   addr, regs->nip, regs->link);
=20
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
=20
 static int do_setcontext(struct ucontext __user *ucp, struct pt_regs *regs=
, int sig)
@@ -1437,8 +1435,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 /*
  * OK, we're invoking a handler
  */
-int handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+int handle_signal32(struct ksignal *ksig, sigset_t *oldset, struct pt_regs=
 *regs)
 {
 	struct sigcontext __user *sc;
 	struct sigframe __user *frame;
@@ -1448,7 +1445,7 @@ int handle_signal32(unsigned long sig, struct k_sigac=
tion *ka,
 	unsigned long tramp;
=20
 	/* Set up Signal Frame */
-	frame =3D get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
+	frame =3D get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*frame), 1=
);
 	if (unlikely(frame =3D=3D NULL))
 		goto badframe;
 	sc =3D (struct sigcontext __user *) &frame->sctx;
@@ -1456,7 +1453,7 @@ int handle_signal32(unsigned long sig, struct k_sigac=
tion *ka,
 #if _NSIG !=3D 64
 #error "Please adjust handle_signal()"
 #endif
-	if (__put_user(to_user_ptr(ka->sa.sa_handler), &sc->handler)
+	if (__put_user(to_user_ptr(ksig->ka.sa.sa_handler), &sc->handler)
 	    || __put_user(oldset->sig[0], &sc->oldmask)
 #ifdef CONFIG_PPC64
 	    || __put_user((oldset->sig[0] >> 32), &sc->_unused[3])
@@ -1464,7 +1461,7 @@ int handle_signal32(unsigned long sig, struct k_sigac=
tion *ka,
 	    || __put_user(oldset->sig[1], &sc->_unused[3])
 #endif
 	    || __put_user(to_user_ptr(&frame->mctx), &sc->regs)
-	    || __put_user(sig, &sc->signal))
+	    || __put_user(ksig->sig, &sc->signal))
 		goto badframe;
=20
 	if (vdso32_sigtramp && current->mm->context.vdso_base) {
@@ -1499,12 +1496,12 @@ int handle_signal32(unsigned long sig, struct k_sig=
action *ka,
 		goto badframe;
=20
 	regs->gpr[1] =3D newsp;
-	regs->gpr[3] =3D sig;
+	regs->gpr[3] =3D ksig->sig;
 	regs->gpr[4] =3D (unsigned long) sc;
-	regs->nip =3D (unsigned long) ka->sa.sa_handler;
+	regs->nip =3D (unsigned long) (unsigned long)ksig->ka.sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &=3D ~MSR_LE;
-	return 1;
+	return 0;
=20
 badframe:
 	if (show_unhandled_signals)
@@ -1514,8 +1511,7 @@ int handle_signal32(unsigned long sig, struct k_sigac=
tion *ka,
 				   current->comm, current->pid,
 				   frame, regs->nip, regs->link);
=20
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
=20
 /*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_6=
4.c
index bfacb8290441..0bcae29336c0 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -743,20 +743,19 @@ int sys_rt_sigreturn(unsigned long r3, unsigned long =
r4, unsigned long r5,
 	return 0;
 }
=20
-int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs)
+int handle_rt_signal64(struct ksignal *ksig, sigset_t *set, struct pt_regs=
 *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long newsp =3D 0;
 	long err =3D 0;
=20
-	frame =3D get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*frame), 0);
+	frame =3D get_sigframe(ksig, get_tm_stackpointer(regs), sizeof(*frame), 0=
);
 	if (unlikely(frame =3D=3D NULL))
 		goto badframe;
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
 		goto badframe;
=20
@@ -771,15 +770,15 @@ int handle_rt_signal64(int signr, struct k_sigaction =
*ka, siginfo_t *info,
 		err |=3D __put_user(&frame->uc_transact, &frame->uc.uc_link);
 		err |=3D setup_tm_sigcontexts(&frame->uc.uc_mcontext,
 					    &frame->uc_transact.uc_mcontext,
-					    regs, signr,
+					    regs, ksig->sig,
 					    NULL,
-					    (unsigned long)ka->sa.sa_handler);
+					    (unsigned long)ksig->ka.sa.sa_handler);
 	} else
 #endif
 	{
 		err |=3D __put_user(0, &frame->uc.uc_link);
-		err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs, signr,
-					NULL, (unsigned long)ka->sa.sa_handler,
+		err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs, ksig->sig,
+					NULL, (unsigned long)ksig->ka.sa.sa_handler,
 					1);
 	}
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
@@ -805,7 +804,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *k=
a, siginfo_t *info,
=20
 	/* Set up "regs" so we "return" to the signal handler. */
 	if (is_elf2_task()) {
-		regs->nip =3D (unsigned long) ka->sa.sa_handler;
+		regs->nip =3D (unsigned long) ksig->ka.sa.sa_handler;
 		regs->gpr[12] =3D regs->nip;
 	} else {
 		/* Handler is *really* a pointer to the function descriptor for
@@ -814,7 +813,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *k=
a, siginfo_t *info,
 		 * entry is the TOC value we need to use.
 		 */
 		func_descr_t __user *funct_desc_ptr =3D
-			(func_descr_t __user *) ka->sa.sa_handler;
+			(func_descr_t __user *) ksig->ka.sa.sa_handler;
=20
 		err |=3D get_user(regs->nip, &funct_desc_ptr->entry);
 		err |=3D get_user(regs->gpr[2], &funct_desc_ptr->toc);
@@ -824,9 +823,9 @@ int handle_rt_signal64(int signr, struct k_sigaction *k=
a, siginfo_t *info,
 	regs->msr &=3D ~MSR_LE;
 	regs->msr |=3D (MSR_KERNEL & MSR_LE);
 	regs->gpr[1] =3D newsp;
-	regs->gpr[3] =3D signr;
+	regs->gpr[3] =3D ksig->sig;
 	regs->result =3D 0;
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		err |=3D get_user(regs->gpr[4], (unsigned long __user *)&frame->pinfo);
 		err |=3D get_user(regs->gpr[5], (unsigned long __user *)&frame->puc);
 		regs->gpr[6] =3D (unsigned long) frame;
@@ -836,7 +835,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *k=
a, siginfo_t *info,
 	if (err)
 		goto badframe;
=20
-	return 1;
+	return 0;
=20
 badframe:
 	if (show_unhandled_signals)
@@ -844,6 +843,5 @@ int handle_rt_signal64(int signr, struct k_sigaction *k=
a, siginfo_t *info,
 				   current->comm, current->pid, "setup_rt_frame",
 				   (long)frame, regs->nip, regs->link);
=20
-	force_sigsegv(signr, current);
-	return 0;
+	return 1;
 }
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mm=
u_context.h
index db9bdd8f3223..96ee7a6a3aaf 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -69,17 +69,17 @@ static inline void switch_mm(struct mm_struct *prev, st=
ruct mm_struct *next,
 {
 	int cpu =3D smp_processor_id();
=20
-	if (prev =3D=3D next)
-		return;
 	if (MACHINE_HAS_TLB_LC)
 		cpumask_set_cpu(cpu, &next->context.cpu_attach_mask);
 	/* Clear old ASCE by loading the kernel ASCE. */
 	__ctl_load(S390_lowcore.kernel_asce, 1, 1);
 	__ctl_load(S390_lowcore.kernel_asce, 7, 7);
-	atomic_inc(&next->context.attach_count);
-	atomic_dec(&prev->context.attach_count);
-	if (MACHINE_HAS_TLB_LC)
-		cpumask_clear_cpu(cpu, &prev->context.cpu_attach_mask);
+	if (prev !=3D next) {
+		atomic_inc(&next->context.attach_count);
+		atomic_dec(&prev->context.attach_count);
+		if (MACHINE_HAS_TLB_LC)
+			cpumask_clear_cpu(cpu, &prev->context.cpu_attach_mask);
+	}
 	S390_lowcore.user_asce =3D next->context.asce_bits | __pa(next->pgd);
 }
=20
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_sig=
nal.c
index f204d6920368..598b0b42668b 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -320,38 +320,39 @@ static inline int map_signal(int sig)
 		return sig;
 }
=20
-static int setup_frame32(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs * regs)
+static int setup_frame32(struct ksignal *ksig, sigset_t *set,
+			 struct pt_regs *regs)
 {
-	sigframe32 __user *frame =3D get_sigframe(ka, regs, sizeof(sigframe32));
+	int sig =3D ksig->sig;
+	sigframe32 __user *frame =3D get_sigframe(&ksig->ka, regs, sizeof(sigfram=
e32));
=20
 	if (frame =3D=3D (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (__copy_to_user(&frame->sc.oldmask, &set->sig, _SIGMASK_COPY_SIZE32))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (save_sigregs32(regs, &frame->sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (save_sigregs_gprs_high(regs, frame->gprs_high))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (__put_user((unsigned long) &frame->sregs, &frame->sc.sregs))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->gprs[14] =3D (__u64 __force) ka->sa.sa_restorer | PSW32_ADDR_AMODE;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->gprs[14] =3D (__u64 __force) ksig->ka.sa.sa_restorer | PSW32_ADDR_=
AMODE;
 	} else {
 		regs->gprs[14] =3D (__u64 __force) frame->retcode | PSW32_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn,
 			       (u16 __force __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
         }
=20
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (unsigned int __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (__force __u64) frame;
@@ -359,7 +360,7 @@ static int setup_frame32(int sig, struct k_sigaction *k=
a,
 	regs->psw.mask =3D PSW_MASK_BA |
 		(PSW_USER_BITS & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr =3D (__force __u64) ka->sa.sa_handler;
+	regs->psw.addr =3D (__force __u64) ksig->ka.sa.sa_handler;
=20
 	regs->gprs[2] =3D map_signal(sig);
 	regs->gprs[3] =3D (__force __u64) &frame->sc;
@@ -376,25 +377,21 @@ static int setup_frame32(int sig, struct k_sigaction =
*ka,
=20
 	/* Place signal number on stack to allow backtrace from handler.  */
 	if (__put_user(regs->gprs[2], (int __force __user *) &frame->signo))
-		goto give_sigsegv;
+		return -EFAULT;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *in=
fo,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame32(struct ksignal *ksig, sigset_t *set,
+			    struct pt_regs *regs)
 {
 	int err =3D 0;
-	rt_sigframe32 __user *frame =3D get_sigframe(ka, regs, sizeof(rt_sigframe=
32));
+	rt_sigframe32 __user *frame =3D get_sigframe(&ksig->ka, regs, sizeof(rt_s=
igframe32));
=20
 	if (frame =3D=3D (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
=20
-	if (copy_siginfo_to_user32(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user32(&frame->info, &ksig->info))
+		return -EFAULT;
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(UC_EXTENDED, &frame->uc.uc_flags);
@@ -404,22 +401,22 @@ static int setup_rt_frame32(int sig, struct k_sigacti=
on *ka, siginfo_t *info,
 	err |=3D save_sigregs_gprs_high(regs, frame->gprs_high);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->gprs[14] =3D (__u64 __force) ka->sa.sa_restorer | PSW32_ADDR_AMODE;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->gprs[14] =3D (__u64 __force) ksig->ka.sa.sa_restorer | PSW32_ADDR_=
AMODE;
 	} else {
 		regs->gprs[14] =3D (__u64 __force) frame->retcode | PSW32_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn,
 			       (u16 __force __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
=20
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (unsigned int __force __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (__force __u64) frame;
@@ -427,36 +424,30 @@ static int setup_rt_frame32(int sig, struct k_sigacti=
on *ka, siginfo_t *info,
 	regs->psw.mask =3D PSW_MASK_BA |
 		(PSW_USER_BITS & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr =3D (__u64 __force) ka->sa.sa_handler;
+	regs->psw.addr =3D (__u64 __force) ksig->ka.sa.sa_handler;
=20
-	regs->gprs[2] =3D map_signal(sig);
+	regs->gprs[2] =3D map_signal(ksig->sig);
 	regs->gprs[3] =3D (__force __u64) &frame->info;
 	regs->gprs[4] =3D (__force __u64) &frame->uc;
 	regs->gprs[5] =3D task_thread_info(current)->last_break;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /*
  * OK, we're invoking a handler
  */=09
=20
-void handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+void handle_signal32(struct ksignal *ksig, sigset_t *oldset,
+		     struct pt_regs *regs)
 {
 	int ret;
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame32(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame32(ksig, oldset, regs);
 	else
-		ret =3D setup_frame32(sig, ka, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLE_STEP));
+		ret =3D setup_frame32(ksig, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLE_STEP));
 }
=20
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index ec372dd54c7f..94aab1c8d0ef 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -232,10 +232,10 @@ static noinline __init void detect_machine_type(void)
 	if (stsi(vmms, 3, 2, 2) || !vmms->count)
 		return;
=20
-	/* Running under KVM? If not we assume z/VM */
+	/* Detect known hypervisors */
 	if (!memcmp(vmms->vm[0].cpi, "\xd2\xe5\xd4", 3))
 		S390_lowcore.machine_flags |=3D MACHINE_FLAG_KVM;
-	else
+	else if (!memcmp(vmms->vm[0].cpi, "\xa9\x61\xe5\xd4", 4))
 		S390_lowcore.machine_flags |=3D MACHINE_FLAG_VM;
 }
=20
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 6ac78192455f..1aad48398d06 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -48,8 +48,8 @@ void do_per_trap(struct pt_regs *regs);
 void syscall_trace(struct pt_regs *regs, int entryexit);
 void kernel_stack_overflow(struct pt_regs * regs);
 void do_signal(struct pt_regs *regs);
-void handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs);
+void handle_signal32(struct ksignal *ksig, sigset_t *oldset,
+		     struct pt_regs *regs);
 void do_notify_resume(struct pt_regs *regs);
=20
 void __init init_IRQ(void);
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 1e2264b46e4c..9539c86684c1 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -831,6 +831,8 @@ void __init setup_arch(char **cmdline_p)
 		pr_info("Linux is running under KVM in 64-bit mode\n");
 	else if (MACHINE_IS_LPAR)
 		pr_info("Linux is running natively in 64-bit mode\n");
+	else
+		pr_info("Linux is running as a guest in 64-bit mode\n");
 #endif /* CONFIG_64BIT */
=20
 	/* Have one command line that is parsed and saved in /proc/cmdline */
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 42b49f9e19bf..469c4c6d9182 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -200,15 +200,15 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
 	frame =3D get_sigframe(ka, regs, sizeof(sigframe));
=20
 	if (frame =3D=3D (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (__copy_to_user(&frame->sc.oldmask, &set->sig, _SIGMASK_COPY_SIZE))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (save_sigregs(regs, &frame->sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (__put_user(&frame->sregs, &frame->sc.sregs))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
@@ -220,12 +220,12 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
 			frame->retcode | PSW_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn,
 	                       (u16 __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
=20
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (addr_t __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (unsigned long) frame;
@@ -250,27 +250,23 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
=20
 	/* Place signal number on stack to allow backtrace from handler.  */
 	if (__put_user(regs->gprs[2], (int __user *) &frame->signo))
-		goto give_sigsegv;
+		return -EFAULT;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	int err =3D 0;
 	rt_sigframe __user *frame;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(rt_sigframe));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(rt_sigframe));
=20
 	if (frame =3D=3D (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
=20
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -279,24 +275,24 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	err |=3D save_sigregs(regs, &frame->uc.uc_mcontext);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
                 regs->gprs[14] =3D (unsigned long)
-			ka->sa.sa_restorer | PSW_ADDR_AMODE;
+			ksig->ka.sa.sa_restorer | PSW_ADDR_AMODE;
 	} else {
                 regs->gprs[14] =3D (unsigned long)
 			frame->retcode | PSW_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn,
 			       (u16 __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
=20
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (addr_t __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->gprs[15] =3D (unsigned long) frame;
@@ -304,34 +300,27 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	regs->psw.mask =3D PSW_MASK_EA | PSW_MASK_BA |
 		(PSW_USER_BITS & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr =3D (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
+	regs->psw.addr =3D (unsigned long) ksig->ka.sa.sa_handler | PSW_ADDR_AMOD=
E;
=20
-	regs->gprs[2] =3D map_signal(sig);
+	regs->gprs[2] =3D map_signal(ksig->sig);
 	regs->gprs[3] =3D (unsigned long) &frame->info;
 	regs->gprs[4] =3D (unsigned long) &frame->uc;
 	regs->gprs[5] =3D task_thread_info(current)->last_break;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-			 siginfo_t *info, sigset_t *oldset,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, sigset_t *oldset,
+			  struct pt_regs *regs)
 {
 	int ret;
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLE_STEP));
+		ret =3D setup_frame(ksig->sig, &ksig->ka, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLE_STEP));
 }
=20
 /*
@@ -345,9 +334,7 @@ static void handle_signal(unsigned long sig, struct k_s=
igaction *ka,
  */
 void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 	sigset_t *oldset =3D sigmask_to_save();
=20
 	/*
@@ -357,9 +344,8 @@ void do_signal(struct pt_regs *regs)
 	 */
 	current_thread_info()->system_call =3D
 		test_pt_regs_flag(regs, PIF_SYSCALL) ? regs->int_code : 0;
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
=20
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
 		if (current_thread_info()->system_call) {
 			regs->int_code =3D current_thread_info()->system_call;
@@ -370,7 +356,7 @@ void do_signal(struct pt_regs *regs)
 				regs->gprs[2] =3D -EINTR;
 				break;
 			case -ERESTARTSYS:
-				if (!(ka.sa.sa_flags & SA_RESTART)) {
+				if (!(ksig.ka.sa.sa_flags & SA_RESTART)) {
 					regs->gprs[2] =3D -EINTR;
 					break;
 				}
@@ -387,9 +373,9 @@ void do_signal(struct pt_regs *regs)
 		clear_pt_regs_flag(regs, PIF_SYSCALL);
=20
 		if (is_compat_task())
-			handle_signal32(signr, &ka, &info, oldset, regs);
+			handle_signal32(&ksig, oldset, regs);
 		else
-			handle_signal(signr, &ka, &info, oldset, regs);
+			handle_signal(&ksig, oldset, regs);
 		return;
 	}
=20
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 243c7e512600..925c26d78eee 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1032,7 +1032,11 @@ static ssize_t __ref rescan_store(struct device *dev,
 {
 	int rc;
=20
+	rc =3D lock_device_hotplug_sysfs();
+	if (rc)
+		return rc;
 	rc =3D smp_rescan_cpus();
+	unlock_device_hotplug();
 	return rc ? rc : count;
 }
 static DEVICE_ATTR(rescan, 0200, NULL, rescan_store);
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index a00fba32b0eb..1651807774ad 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -173,15 +173,15 @@ score_rt_sigreturn(struct pt_regs *regs)
 	return 0;
 }
=20
-static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
-		int signr, sigset_t *set, siginfo_t *info)
+static int setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs,
+			  sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
 	int err =3D 0;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/*
 	 * Set up the return code ...
@@ -194,7 +194,7 @@ static int setup_rt_frame(struct k_sigaction *ka, struc=
t pt_regs *regs,
 	err |=3D __put_user(0x80008002, frame->rs_code + 1);
 	flush_cache_sigtramp((unsigned long) frame->rs_code);
=20
-	err |=3D copy_siginfo_to_user(&frame->rs_info, info);
+	err |=3D copy_siginfo_to_user(&frame->rs_info, &ksig->info);
 	err |=3D __put_user(0, &frame->rs_uc.uc_flags);
 	err |=3D __put_user(NULL, &frame->rs_uc.uc_link);
 	err |=3D __save_altstack(&frame->rs_uc.uc_stack, regs->regs[0]);
@@ -202,26 +202,23 @@ static int setup_rt_frame(struct k_sigaction *ka, str=
uct pt_regs *regs,
 	err |=3D __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	regs->regs[0] =3D (unsigned long) frame;
 	regs->regs[3] =3D (unsigned long) frame->rs_code;
-	regs->regs[4] =3D signr;
+	regs->regs[4] =3D ksig->sig;
 	regs->regs[5] =3D (unsigned long) &frame->rs_info;
 	regs->regs[6] =3D (unsigned long) &frame->rs_uc;
-	regs->regs[29] =3D (unsigned long) ka->sa.sa_handler;
-	regs->cp0_epc =3D (unsigned long) ka->sa.sa_handler;
+	regs->regs[29] =3D (unsigned long) ksig->ka.sa.sa_handler;
+	regs->cp0_epc =3D (unsigned long) ksig->ka.sa.sa_handler;
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
=20
-static void handle_signal(unsigned long sig, siginfo_t *info,
-	struct k_sigaction *ka, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	if (regs->is_syscall) {
 		switch (regs->regs[4]) {
 		case ERESTART_RESTARTBLOCK:
@@ -229,7 +226,7 @@ static void handle_signal(unsigned long sig, siginfo_t =
*info,
 			regs->regs[4] =3D EINTR;
 			break;
 		case ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->regs[4] =3D EINTR;
 				break;
 			}
@@ -245,17 +242,14 @@ static void handle_signal(unsigned long sig, siginfo_=
t *info,
 	/*
 	 * Set up the stack frame
 	 */
-	if (setup_rt_frame(ka, regs, sig, sigmask_to_save(), info) < 0)
-		return;
+	ret =3D setup_rt_frame(ksig, regs, sigmask_to_save());
=20
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 static void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -265,10 +259,9 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 594cd371aa28..2f002b24fb92 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -262,17 +262,17 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp=
, size_t frame_size)
 extern void __kernel_sigreturn(void);
 extern void __kernel_rt_sigreturn(void);
=20
-static int setup_frame(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
=20
-	frame =3D get_sigframe(ka, regs->regs[15], sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -288,8 +288,8 @@ static int setup_frame(int sig, struct k_sigaction *ka,
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->pr =3D (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->pr =3D (unsigned long) ksig->ka.sa.sa_restorer;
 #ifdef CONFIG_VSYSCALL
 	} else if (likely(current->mm->context.vdso)) {
 		regs->pr =3D VDSO_SYM(&__kernel_sigreturn);
@@ -309,7 +309,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->regs[15] =3D (unsigned long) frame;
@@ -319,15 +319,15 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
=20
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =3D
-			(struct fdpic_func_descriptor __user *)ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *)ksig->ka.sa.sa_handler;
=20
 		err |=3D __get_user(regs->pc, &funcptr->text);
 		err |=3D __get_user(regs->regs[12], &funcptr->GOT);
 	} else
-		regs->pc =3D (unsigned long)ka->sa.sa_handler;
+		regs->pc =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	set_fs(USER_DS);
=20
@@ -335,23 +335,19 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
 		 current->comm, task_pid_nr(current), frame, regs->pc, regs->pr);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
=20
-	frame =3D get_sigframe(ka, regs->regs[15], sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -359,7 +355,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
=20
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -371,8 +367,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->pr =3D (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->pr =3D (unsigned long) ksig->ka.sa.sa_restorer;
 #ifdef CONFIG_VSYSCALL
 	} else if (likely(current->mm->context.vdso)) {
 		regs->pr =3D VDSO_SYM(&__kernel_rt_sigreturn);
@@ -392,7 +388,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	}
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up registers for signal handler */
 	regs->regs[15] =3D (unsigned long) frame;
@@ -402,15 +398,15 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
=20
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =3D
-			(struct fdpic_func_descriptor __user *)ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *)ksig->ka.sa.sa_handler;
=20
 		err |=3D __get_user(regs->pc, &funcptr->text);
 		err |=3D __get_user(regs->regs[12], &funcptr->GOT);
 	} else
-		regs->pc =3D (unsigned long)ka->sa.sa_handler;
+		regs->pc =3D (unsigned long)ksig->ka.sa.sa_handler;
=20
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	set_fs(USER_DS);
=20
@@ -418,10 +414,6 @@ static int setup_rt_frame(int sig, struct k_sigaction =
*ka, siginfo_t *info,
 		 current->comm, task_pid_nr(current), frame, regs->pc, regs->pr);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 static inline void
@@ -455,22 +447,18 @@ handle_syscall_restart(unsigned long save_r0, struct =
pt_regs *regs,
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs, unsigned int save_r0)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, unsigned int sav=
e_r0)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
+		ret =3D setup_frame(ksig, oldset, regs);
=20
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 /*
@@ -484,9 +472,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka=
, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs, unsigned int save_r0)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which
@@ -497,12 +483,11 @@ static void do_signal(struct pt_regs *regs, unsigned =
int save_r0)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_syscall_restart(save_r0, regs, &ka.sa);
+	if (get_signal(&ksig)) {
+		handle_syscall_restart(save_r0, regs, &ksig.ka.sa);
=20
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs, save_r0);
+		handle_signal(&ksig, regs, save_r0);
 		return;
 	}
=20
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 23d4c71c91af..897abe7b871e 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -41,8 +41,7 @@
 #define DEBUG_SIG 0
=20
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs * regs);
+handle_signal(struct ksignal *ksig, struct pt_regs *regs);
=20
 static inline void
 handle_syscall_restart(struct pt_regs *regs, struct sigaction *sa)
@@ -82,9 +81,7 @@ handle_syscall_restart(struct pt_regs *regs, struct sigac=
tion *sa)
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which
@@ -95,12 +92,11 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, 0);
-	if (signr > 0) {
-		handle_syscall_restart(regs, &ka.sa);
+	if (get_signal(&ksig)) {
+		handle_syscall_restart(regs, &ksig.ka.sa);
=20
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
=20
@@ -378,17 +374,16 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp=
, size_t frame_size)
 void sa_default_restorer(void);		/* See comments below */
 void sa_default_rt_restorer(void);	/* See comments below */
=20
-static int setup_frame(int sig, struct k_sigaction *ka,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs=
 *regs)
 {
 	struct sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
=20
-	frame =3D get_sigframe(ka, regs->regs[REG_SP], sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -400,7 +395,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
=20
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	if (_NSIG_WORDS > 1) {
 		err |=3D __copy_to_user(frame->extramask, &set->sig[1],
@@ -408,16 +403,16 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
=20
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 		/*
 		 * On SH5 all edited pointers are subject to NEFF
 		 */
 		DEREF_REG_PR =3D neff_sign_extend((unsigned long)
-			ka->sa.sa_restorer | 0x1);
+			ksig->ka->sa.sa_restorer | 0x1);
 	} else {
 		/*
 		 * Different approach on SH5.
@@ -435,7 +430,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
=20
 		if (__copy_to_user(frame->retcode,
 			(void *)((unsigned long)sa_default_restorer & (~1)), 16) !=3D 0)
-			goto give_sigsegv;
+			return -EFAULT;
=20
 		/* Cohere the trampoline with the I-cache. */
 		flush_cache_sigtramp(DEREF_REG_PR-1);
@@ -460,7 +455,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	regs->regs[REG_ARG2] =3D (unsigned long long)(unsigned long)(signed long)=
&frame->sc;
 	regs->regs[REG_ARG3] =3D (unsigned long long)(unsigned long)(signed long)=
&frame->sc;
=20
-	regs->pc =3D neff_sign_extend((unsigned long)ka->sa.sa_handler);
+	regs->pc =3D neff_sign_extend((unsigned long)ksig->ka.sa.sa_handler);
=20
 	set_fs(USER_DS);
=20
@@ -471,23 +466,19 @@ static int setup_frame(int sig, struct k_sigaction *k=
a,
 		 DEREF_REG_PR >> 32, DEREF_REG_PR & 0xffffffff);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *kig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
=20
-	frame =3D get_sigframe(ka, regs->regs[REG_SP], sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	signal =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -497,11 +488,11 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
=20
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Create the ucontext.  */
 	err |=3D __put_user(0, &frame->uc.uc_flags);
@@ -513,16 +504,16 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
=20
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
=20
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 		/*
 		 * On SH5 all edited pointers are subject to NEFF
 		 */
 		DEREF_REG_PR =3D neff_sign_extend((unsigned long)
-			ka->sa.sa_restorer | 0x1);
+			ksig->ka.sa.sa_restorer | 0x1);
 	} else {
 		/*
 		 * Different approach on SH5.
@@ -540,7 +531,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
=20
 		if (__copy_to_user(frame->retcode,
 			(void *)((unsigned long)sa_default_rt_restorer & (~1)), 16) !=3D 0)
-			goto give_sigsegv;
+			return -EFAULT;
=20
 		/* Cohere the trampoline with the I-cache. */
 		flush_icache_range(DEREF_REG_PR-1, DEREF_REG_PR-1+15);
@@ -554,7 +545,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	regs->regs[REG_ARG1] =3D signal; /* Arg for signal handler */
 	regs->regs[REG_ARG2] =3D (unsigned long long)(unsigned long)(signed long)=
&frame->info;
 	regs->regs[REG_ARG3] =3D (unsigned long long)(unsigned long)(signed long)=
&frame->uc.uc_mcontext;
-	regs->pc =3D neff_sign_extend((unsigned long)ka->sa.sa_handler);
+	regs->pc =3D neff_sign_extend((unsigned long)ksig->ka.sa.sa_handler);
=20
 	set_fs(USER_DS);
=20
@@ -564,33 +555,24 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 		 DEREF_REG_PR >> 32, DEREF_REG_PR & 0xffffffff);
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /*
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs * regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
=20
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(sig, ka, oldset, regs);
-
-	if (ret)
-		return;
+		ret =3D setup_frame(ksig, oldset, regs);
=20
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned long threa=
d_info_flags)
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index ffd4493efc78..c14e36f008c8 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -267,8 +267,7 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
=20
-extern int compat_setup_rt_frame(int sig, struct k_sigaction *ka,
-				 siginfo_t *info, sigset_t *set,
+extern int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 				 struct pt_regs *regs);
=20
 /* Compat syscalls. */
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_sig=
nal.c
index 19c04b5ce408..8c5abf2e4794 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -190,18 +190,18 @@ static inline void __user *compat_get_sigframe(struct=
 k_sigaction *ka,
 	return (void __user *) sp;
 }
=20
-int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	unsigned long restorer;
 	struct compat_rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int usig;
=20
-	frame =3D compat_get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		goto err;
=20
 	usig =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -210,12 +210,12 @@ int compat_setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 		: sig;
=20
 	/* Always write at least the signal number for the stack backtracer. */
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
-		err |=3D copy_siginfo_to_user32(&frame->info, info);
+		err |=3D copy_siginfo_to_user32(&frame->info, &ksig->info);
 		regs->flags |=3D PT_FLAGS_RESTORE_REGS;
 	} else {
-		err |=3D __put_user(info->si_signo, &frame->info.si_signo);
+		err |=3D __put_user(ksig->info.si_signo, &frame->info.si_signo);
 	}
=20
 	/* Create the ucontext.  */
@@ -226,11 +226,11 @@ int compat_setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		goto err;
=20
 	restorer =3D VDSO_SYM(&__vdso_rt_sigreturn);
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer =3D ptr_to_compat_reg(ka->sa.sa_restorer);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer =3D ptr_to_compat_reg(ksig->ka.sa.sa_restorer);
=20
 	/*
 	 * Set up registers for signal handler.
@@ -239,7 +239,7 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
 	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
-	regs->pc =3D ptr_to_compat_reg(ka->sa.sa_handler);
+	regs->pc =3D ptr_to_compat_reg(ksig->ka.sa.sa_handler);
 	regs->ex1 =3D PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp =3D ptr_to_compat_reg(frame);
 	regs->lr =3D restorer;
@@ -249,7 +249,8 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	regs->flags |=3D PT_FLAGS_CALLER_SAVES;
 	return 0;
=20
-give_sigsegv:
-	signal_fault("bad setup frame", regs, frame, sig);
+err:
+	trace_unhandled_signal("bad sigreturn frame", regs,
+			      (unsigned long)frame, SIGSEGV);
 	return -EFAULT;
 }
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index d1d026f01267..7c2fecc52177 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -153,18 +153,18 @@ static inline void __user *get_sigframe(struct k_siga=
ction *ka,
 	return (void __user *) sp;
 }
=20
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	unsigned long restorer;
 	struct rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int usig;
=20
-	frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		goto err;
=20
 	usig =3D current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -173,12 +173,12 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 		: sig;
=20
 	/* Always write at least the signal number for the stack backtracer. */
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
-		err |=3D copy_siginfo_to_user(&frame->info, info);
+		err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 		regs->flags |=3D PT_FLAGS_RESTORE_REGS;
 	} else {
-		err |=3D __put_user(info->si_signo, &frame->info.si_signo);
+		err |=3D __put_user(ksig->info.si_signo, &frame->info.si_signo);
 	}
=20
 	/* Create the ucontext.  */
@@ -189,11 +189,11 @@ static int setup_rt_frame(int sig, struct k_sigaction=
 *ka, siginfo_t *info,
 	err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		goto err;
=20
 	restorer =3D VDSO_SYM(&__vdso_rt_sigreturn);
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer =3D (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer =3D (unsigned long) ksig->ka.sa.sa_restorer;
=20
 	/*
 	 * Set up registers for signal handler.
@@ -202,7 +202,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
 	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
-	regs->pc =3D (unsigned long) ka->sa.sa_handler;
+	regs->pc =3D (unsigned long) ksig->ka.sa.sa_handler;
 	regs->ex1 =3D PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp =3D (unsigned long) frame;
 	regs->lr =3D restorer;
@@ -212,8 +212,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
 	regs->flags |=3D PT_FLAGS_CALLER_SAVES;
 	return 0;
=20
-give_sigsegv:
-	signal_fault("bad setup frame", regs, frame, sig);
+err:
+	trace_unhandled_signal("bad sigreturn frame", regs,
+			      (unsigned long)frame, SIGSEGV);
 	return -EFAULT;
 }
=20
@@ -221,9 +222,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *=
ka, siginfo_t *info,
  * OK, we're invoking a handler
  */
=20
-static void handle_signal(unsigned long sig, siginfo_t *info,
-			 struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int ret;
@@ -238,7 +237,7 @@ static void handle_signal(unsigned long sig, siginfo_t =
*info,
 			break;
=20
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->regs[0] =3D -EINTR;
 				break;
 			}
@@ -254,14 +253,12 @@ static void handle_signal(unsigned long sig, siginfo_=
t *info,
 	/* Set up the stack frame */
 #ifdef CONFIG_COMPAT
 	if (is_compat_task())
-		ret =3D compat_setup_rt_frame(sig, ka, info, oldset, regs);
+		ret =3D compat_setup_rt_frame(ksig, oldset, regs);
 	else
 #endif
-		ret =3D setup_rt_frame(sig, ka, info, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+		ret =3D setup_rt_frame(ksig, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
=20
 /*
@@ -271,9 +268,7 @@ static void handle_signal(unsigned long sig, siginfo_t =
*info,
  */
 void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	/*
 	 * i386 will check if we're coming from kernel mode and bail out
@@ -282,10 +277,9 @@ void do_signal(struct pt_regs *regs)
 	 * helpful, we can reinstate the check on "!user_mode(regs)".
 	 */
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		goto done;
 	}
=20
diff --git a/arch/um/include/shared/frame_kern.h b/arch/um/include/shared/f=
rame_kern.h
index f2ca5702a4e2..a5cde5c433b4 100644
--- a/arch/um/include/shared/frame_kern.h
+++ b/arch/um/include/shared/frame_kern.h
@@ -6,14 +6,10 @@
 #ifndef __FRAME_KERN_H_
 #define __FRAME_KERN_H_
=20
-extern int setup_signal_stack_sc(unsigned long stack_top, int sig,
-				 struct k_sigaction *ka,
-				 struct pt_regs *regs,
-				 sigset_t *mask);
-extern int setup_signal_stack_si(unsigned long stack_top, int sig,
-				 struct k_sigaction *ka,
-				 struct pt_regs *regs, struct siginfo *info,
-				 sigset_t *mask);
+extern int setup_signal_stack_sc(unsigned long stack_top, struct ksignal *=
ksig,
+				 struct pt_regs *regs, sigset_t *mask);
+extern int setup_signal_stack_si(unsigned long stack_top, struct ksignal *=
ksig,
+				 struct pt_regs *regs, sigset_t *mask);
=20
 #endif
=20
diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index f57e02e7910f..4f60e4aad790 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -18,8 +18,7 @@ EXPORT_SYMBOL(unblock_signals);
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(struct pt_regs *regs, unsigned long signr,
-			 struct k_sigaction *ka, struct siginfo *info)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset =3D sigmask_to_save();
 	int singlestep =3D 0;
@@ -39,7 +38,7 @@ static void handle_signal(struct pt_regs *regs, unsigned =
long signr,
 			break;
=20
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				PT_REGS_SYSCALL_RET(regs) =3D -EINTR;
 				break;
 			}
@@ -52,32 +51,28 @@ static void handle_signal(struct pt_regs *regs, unsigne=
d long signr,
 	}
=20
 	sp =3D PT_REGS_SP(regs);
-	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) =3D=3D 0))
+	if ((ksig->ka.sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) =3D=3D 0))
 		sp =3D current->sas_ss_sp + current->sas_ss_size;
=20
 #ifdef CONFIG_ARCH_HAS_SC_SIGNALS
-	if (!(ka->sa.sa_flags & SA_SIGINFO))
-		err =3D setup_signal_stack_sc(sp, signr, ka, regs, oldset);
+	if (!(ksig->ka.sa.sa_flags & SA_SIGINFO))
+		err =3D setup_signal_stack_sc(sp, ksig, regs, oldset);
 	else
 #endif
-		err =3D setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
+		err =3D setup_signal_stack_si(sp, ksig, regs, oldset);
=20
-	if (err)
-		force_sigsegv(signr, current);
-	else
-		signal_delivered(signr, info, ka, regs, singlestep);
+	signal_setup_done(err, ksig, singlestep);
 }
=20
 static int kern_do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka_copy;
-	struct siginfo info;
-	int sig, handled_sig =3D 0;
+	struct ksignal ksig;
+	int handled_sig =3D 0;
=20
-	while ((sig =3D get_signal_to_deliver(&info, &ka_copy, regs, NULL)) > 0) {
+	while (get_signal(&ksig)) {
 		handled_sig =3D 1;
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(regs, sig, &ka_copy, &info);
+		handle_signal(&ksig, regs);
 	}
=20
 	/* Did we come from a system call? */
diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 6905f0ebdc77..7c8fb7018dc6 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -238,10 +238,10 @@ static int setup_return(struct pt_regs *regs, struct =
k_sigaction *ka,
 	return 0;
 }
=20
-static int setup_frame(int usig, struct k_sigaction *ka,
-		sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
-	struct sigframe __user *frame =3D get_sigframe(ka, regs, sizeof(*frame));
+	struct sigframe __user *frame =3D get_sigframe(&ksig->ka, regs, sizeof(*f=
rame));
 	int err =3D 0;
=20
 	if (!frame)
@@ -254,29 +254,31 @@ static int setup_frame(int usig, struct k_sigaction *=
ka,
=20
 	err |=3D setup_sigframe(frame, regs, set);
 	if (err =3D=3D 0)
-		err |=3D setup_return(regs, ka, frame->retcode, frame, usig);
+		err |=3D setup_return(regs, &ksig->ka, frame->retcode, frame,
+				    ksig->sig);
=20
 	return err;
 }
=20
-static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *inf=
o,
-	       sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame =3D
-			get_sigframe(ka, regs, sizeof(*frame));
+			get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	int err =3D 0;
=20
 	if (!frame)
 		return 1;
=20
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
=20
 	err |=3D __put_user(0, &frame->sig.uc.uc_flags);
 	err |=3D __put_user(NULL, &frame->sig.uc.uc_link);
 	err |=3D __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
 	err |=3D setup_sigframe(&frame->sig, regs, set);
 	if (err =3D=3D 0)
-		err |=3D setup_return(regs, ka, frame->sig.retcode, frame, usig);
+		err |=3D setup_return(regs, &ksig->ka, frame->sig.retcode, frame,
+				    ksig->sig);
=20
 	if (err =3D=3D 0) {
 		/*
@@ -299,13 +301,12 @@ static inline void setup_syscall_restart(struct pt_re=
gs *regs)
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-	      siginfo_t *info, struct pt_regs *regs, int syscall)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
+			  int syscall)
 {
 	struct thread_info *thread =3D current_thread_info();
-	struct task_struct *tsk =3D current;
 	sigset_t *oldset =3D sigmask_to_save();
-	int usig =3D sig;
+	int usig =3D ksig->sig;
 	int ret;
=20
 	/*
@@ -318,7 +319,7 @@ static void handle_signal(unsigned long sig, struct k_s=
igaction *ka,
 			regs->UCreg_00 =3D -EINTR;
 			break;
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->UCreg_00 =3D -EINTR;
 				break;
 			}
@@ -338,22 +339,17 @@ static void handle_signal(unsigned long sig, struct k=
_sigaction *ka,
 	/*
 	 * Set up the stack frame
 	 */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret =3D setup_rt_frame(usig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret =3D setup_rt_frame(ksig, oldset, regs);
 	else
-		ret =3D setup_frame(usig, ka, oldset, regs);
+		ret =3D setup_frame(ksig, oldset, regs);
=20
 	/*
 	 * Check that the resulting registers are actually sane.
 	 */
 	ret |=3D !valid_user_regs(regs);
=20
-	if (ret !=3D 0) {
-		force_sigsegv(sig, tsk);
-		return;
-	}
-
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
=20
 /*
@@ -367,9 +363,7 @@ static void handle_signal(unsigned long sig, struct k_s=
igaction *ka,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
=20
 	/*
 	 * We want the common case to go fast, which
@@ -380,9 +374,8 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (!user_mode(regs))
 		return;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &ka, &info, regs, syscall);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs, syscall);
 		return;
 	}
=20
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/asl=
r.c
index d39189ba7f8e..8ebb149a482e 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -25,8 +25,8 @@ static inline u16 i8254(void)
 	u16 status, timer;
=20
 	do {
-		outb(I8254_PORT_CONTROL,
-		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
+		outb(I8254_CMD_READBACK | I8254_SELECT_COUNTER0,
+		     I8254_PORT_CONTROL);
 		status =3D inb(I8254_PORT_COUNTER0);
 		timer  =3D inb(I8254_PORT_COUNTER0);
 		timer |=3D inb(I8254_PORT_COUNTER0) << 8;
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index d21ff89207cd..7e56abcc39eb 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -50,7 +50,7 @@ static unsigned long get_dr(int n)
 /*
  * fill in the user structure for a core dump..
  */
-static void dump_thread32(struct pt_regs *regs, struct user32 *dump)
+static void fill_dump(struct pt_regs *regs, struct user32 *dump)
 {
 	u32 fs, gs;
 	memset(dump, 0, sizeof(*dump));
@@ -156,10 +156,12 @@ static int aout_core_dump(struct coredump_params *cpr=
m)
 	fs =3D get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped =3D 1;
+
+	fill_dump(cprm->regs, &dump);
+
 	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
 	dump.u_ar0 =3D offsetof(struct user32, regs);
 	dump.signal =3D cprm->siginfo->si_signo;
-	dump_thread32(cprm->regs, &dump);
=20
 	/*
 	 * If the size of the dump file exceeds the rlimit, then see
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 16eff1e17e96..6778b4e078ce 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -311,8 +311,7 @@ do {									\
 		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
 		break;							\
 	case 8:								\
-		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval,	\
-				   errret);				\
+		__put_user_asm_u64(x, ptr, retval, errret);		\
 		break;							\
 	default:							\
 		__put_user_bad();					\
@@ -423,8 +422,10 @@ do {									\
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	int __pu_err;						\
+	__typeof__(*(ptr)) __pu_val;				\
+	__pu_val =3D x;						\
 	__uaccess_begin();					\
-	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
+	__put_user_size(__pu_val, (ptr), (size), __pu_err, -EFAULT); \
 	__uaccess_end();					\
 	__pu_err;						\
 })
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_ev=
ent.c
index 8b969708cb5d..c9ee4cec4991 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1920,6 +1920,14 @@ void perf_check_microcode(void)
 }
 EXPORT_SYMBOL_GPL(perf_check_microcode);
=20
+static int x86_pmu_check_period(struct perf_event *event, u64 value)
+{
+	if (x86_pmu.check_period && x86_pmu.check_period(event, value))
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct pmu pmu =3D {
 	.pmu_enable		=3D x86_pmu_enable,
 	.pmu_disable		=3D x86_pmu_disable,
@@ -1940,6 +1948,7 @@ static struct pmu pmu =3D {
=20
 	.event_idx		=3D x86_pmu_event_idx,
 	.flush_branch_stack	=3D x86_pmu_flush_branch_stack,
+	.check_period		=3D x86_pmu_check_period,
 };
=20
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 no=
w)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_ev=
ent.h
index a4fac2889e89..653ae5b55257 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -473,6 +473,11 @@ struct x86_pmu {
 	 * Intel host/guest support (KVM)
 	 */
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+
+	/*
+	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
+	 */
+	int (*check_period) (struct perf_event *event, u64 period);
 };
=20
 #define x86_add_quirk(func_)						\
@@ -634,6 +639,22 @@ static inline int amd_pmu_init(void)
=20
 #ifdef CONFIG_CPU_SUP_INTEL
=20
+static inline bool intel_pmu_has_bts_period(struct perf_event *event, u64 =
period)
+{
+	if (event->attr.config =3D=3D PERF_COUNT_HW_BRANCH_INSTRUCTIONS &&
+	    !event->attr.freq && period =3D=3D 1)
+		return true;
+
+	return false;
+}
+
+static inline bool intel_pmu_has_bts(struct perf_event *event)
+{
+	struct hw_perf_event *hwc =3D &event->hw;
+
+	return intel_pmu_has_bts_period(event, hwc->sample_period);
+}
+
 int intel_pmu_save_and_restart(struct perf_event *event);
=20
 struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/p=
erf_event_intel.c
index 73112b9023cd..6cb22df3a92e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1969,6 +1969,11 @@ ssize_t intel_event_sysfs_show(char *page, u64 confi=
g)
 	return x86_event_sysfs_show(page, config, event);
 }
=20
+static int intel_pmu_check_period(struct perf_event *event, u64 value)
+{
+	return intel_pmu_has_bts_period(event, value) ? -EINVAL : 0;
+}
+
 static __initconst const struct x86_pmu core_pmu =3D {
 	.name			=3D "core",
 	.handle_irq		=3D x86_pmu_handle_irq,
@@ -1995,6 +2000,8 @@ static __initconst const struct x86_pmu core_pmu =3D {
 	.guest_get_msrs		=3D core_guest_get_msrs,
 	.format_attrs		=3D intel_arch_formats_attr,
 	.events_sysfs_show	=3D intel_event_sysfs_show,
+
+	.check_period		=3D intel_pmu_check_period,
 };
=20
 struct intel_shared_regs *allocate_shared_regs(int cpu)
@@ -2145,6 +2152,8 @@ static __initconst const struct x86_pmu intel_pmu =3D=
 {
 	.cpu_dying		=3D intel_pmu_cpu_dying,
 	.guest_get_msrs		=3D intel_guest_get_msrs,
 	.flush_branch_stack	=3D intel_pmu_flush_branch_stack,
+
+	.check_period		=3D intel_pmu_check_period,
 };
=20
 static __init void intel_clovertown_quirk(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kerne=
l/cpu/perf_event_intel_uncore.c
index a4c37cb40519..746fc35a5101 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1004,6 +1004,8 @@ static struct pci_driver snbep_uncore_pci_driver =3D {
 	.id_table	=3D snbep_uncore_pci_ids,
 };
=20
+#define NODE_ID_MASK	0x7
+
 /*
  * build pci bus to socket mapping
  */
@@ -1024,7 +1026,7 @@ static int snbep_pci2phy_map_init(int devid)
 		err =3D pci_read_config_dword(ubox_dev, 0x40, &config);
 		if (err)
 			break;
-		nodeid =3D config;
+		nodeid =3D config & NODE_ID_MASK;
 		/* get the Node ID mapping */
 		err =3D pci_read_config_dword(ubox_dev, 0x54, &config);
 		if (err)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f7a9c127e30d..bc3dc38fa486 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2320,8 +2320,11 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 	nested_vmx_procbased_ctls_high |=3D CPU_BASED_USE_MSR_BITMAPS;
=20
 	/* secondary cpu-based controls */
-	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
-		nested_vmx_secondary_ctls_low, nested_vmx_secondary_ctls_high);
+	if (nested_vmx_procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROL=
S)
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      nested_vmx_secondary_ctls_low,
+		      nested_vmx_secondary_ctls_high);
+
 	nested_vmx_secondary_ctls_low =3D 0;
 	nested_vmx_secondary_ctls_high &=3D
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6babfe32e04b..cab3ca9d3f03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5400,8 +5400,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu =3D false;
 		kvm_rip_write(vcpu, ctxt->eip);
-		if (r =3D=3D EMULATE_DONE &&
-		    (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
+		if (r =3D=3D EMULATE_DONE && ctxt->tf)
 			kvm_vcpu_do_singlestep(vcpu, &r);
 		kvm_set_rflags(vcpu, ctxt->eflags);
 	} else
diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 5e04a1c899fa..79d824551c1a 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -370,13 +370,12 @@ struct rt_sigframe
 	char retcode[8];
 };
=20
-int setup_signal_stack_sc(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs *regs,
-			  sigset_t *mask)
+int setup_signal_stack_sc(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *mask)
 {
 	struct sigframe __user *frame;
 	void __user *restorer;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
=20
 	/* This is the same calculation as i386 - ((sp + 4) & 15) =3D=3D 0 */
 	stack_top =3D ((stack_top + 4) & -16UL) - 4;
@@ -385,8 +384,8 @@ int setup_signal_stack_sc(unsigned long stack_top, int =
sig,
 		return 1;
=20
 	restorer =3D frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer =3D ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer =3D ksig->ka.sa.sa_restorer;
=20
 	err |=3D __put_user(restorer, &frame->pretcode);
 	err |=3D __put_user(sig, &frame->sig);
@@ -410,20 +409,19 @@ int setup_signal_stack_sc(unsigned long stack_top, in=
t sig,
 		return err;
=20
 	PT_REGS_SP(regs) =3D (unsigned long) frame;
-	PT_REGS_IP(regs) =3D (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) =3D (unsigned long) ksig->ka.sa.sa_handler;
 	PT_REGS_AX(regs) =3D (unsigned long) sig;
 	PT_REGS_DX(regs) =3D (unsigned long) 0;
 	PT_REGS_CX(regs) =3D (unsigned long) 0;
 	return 0;
 }
=20
-int setup_signal_stack_si(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs *regs,
-			  siginfo_t *info, sigset_t *mask)
+int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *mask)
 {
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
=20
 	stack_top &=3D -8UL;
 	frame =3D (struct rt_sigframe __user *) stack_top - 1;
@@ -431,14 +429,14 @@ int setup_signal_stack_si(unsigned long stack_top, in=
t sig,
 		return 1;
=20
 	restorer =3D frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer =3D ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer =3D ksig->ka.sa.sa_restorer;
=20
 	err |=3D __put_user(restorer, &frame->pretcode);
 	err |=3D __put_user(sig, &frame->sig);
 	err |=3D __put_user(&frame->info, &frame->pinfo);
 	err |=3D __put_user(&frame->uc, &frame->puc);
-	err |=3D copy_siginfo_to_user(&frame->info, info);
+	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 	err |=3D copy_ucontext_to_user(&frame->uc, &frame->fpstate, mask,
 					PT_REGS_SP(regs));
=20
@@ -457,7 +455,7 @@ int setup_signal_stack_si(unsigned long stack_top, int =
sig,
 		return err;
=20
 	PT_REGS_SP(regs) =3D (unsigned long) frame;
-	PT_REGS_IP(regs) =3D (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) =3D (unsigned long) ksig->ka.sa.sa_handler;
 	PT_REGS_AX(regs) =3D (unsigned long) sig;
 	PT_REGS_DX(regs) =3D (unsigned long) &frame->info;
 	PT_REGS_CX(regs) =3D (unsigned long) &frame->uc;
@@ -502,12 +500,11 @@ struct rt_sigframe
 	struct _fpstate fpstate;
 };
=20
-int setup_signal_stack_si(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs * regs,
-			  siginfo_t *info, sigset_t *set)
+int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
=20
 	frame =3D (struct rt_sigframe __user *)
 		round_down(stack_top - sizeof(struct rt_sigframe), 16);
@@ -517,8 +514,8 @@ int setup_signal_stack_si(unsigned long stack_top, int =
sig,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto out;
=20
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |=3D copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+		err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 		if (err)
 			goto out;
 	}
@@ -543,8 +540,8 @@ int setup_signal_stack_si(unsigned long stack_top, int =
sig,
 	 * already in userspace.
 	 */
 	/* x86-64 should always use SA_RESTORER. */
-	if (ka->sa.sa_flags & SA_RESTORER)
-		err |=3D __put_user(ka->sa.sa_restorer, &frame->pretcode);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		err |=3D __put_user(ksig->ka.sa.sa_restorer, &frame->pretcode);
 	else
 		/* could use a vstub here */
 		return err;
@@ -570,7 +567,7 @@ int setup_signal_stack_si(unsigned long stack_top, int =
sig,
 	 */
 	PT_REGS_SI(regs) =3D (unsigned long) &frame->info;
 	PT_REGS_DX(regs) =3D (unsigned long) &frame->uc;
-	PT_REGS_IP(regs) =3D (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) =3D (unsigned long) ksig->ka.sa.sa_handler;
  out:
 	return err;
 }
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 98b67d5f1514..4612321c73cc 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -331,17 +331,17 @@ gen_return_code(unsigned char *codemem)
 }
=20
=20
-static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
-	int err =3D 0;
+	int err =3D 0, sig =3D ksig->sig;
 	int signal;
 	unsigned long sp, ra, tp;
=20
 	sp =3D regs->areg[1];
=20
-	if ((ka->sa.sa_flags & SA_ONSTACK) !=3D 0 && sas_ss_flags(sp) =3D=3D 0) {
+	if ((ksig->ka.sa.sa_flags & SA_ONSTACK) !=3D 0 && sas_ss_flags(sp) =3D=3D=
 0) {
 		sp =3D current->sas_ss_sp + current->sas_ss_size;
 	}
=20
@@ -351,7 +351,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 siginfo_t *info,
 		panic ("Double exception sys_sigreturn\n");
=20
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame))) {
-		goto give_sigsegv;
+		return -EFAULT;
 	}
=20
 	signal =3D current_thread_info()->exec_domain
@@ -360,8 +360,8 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
=20
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |=3D copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+		err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
 	}
=20
 	/* Create the user context.  */
@@ -372,8 +372,8 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 siginfo_t *info,
 	err |=3D setup_sigcontext(frame, regs);
 	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
=20
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		ra =3D (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		ra =3D (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
=20
 		/* Create sys_rt_sigreturn syscall in stack frame */
@@ -381,7 +381,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 siginfo_t *info,
 		err |=3D gen_return_code(frame->retcode);
=20
 		if (err) {
-			goto give_sigsegv;
+			return -EFAULT;
 		}
 		ra =3D (unsigned long) frame->retcode;
 	}
@@ -393,7 +393,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,=
 siginfo_t *info,
=20
 	/* Set up registers for signal handler; preserve the threadptr */
 	tp =3D regs->threadptr;
-	start_thread(regs, (unsigned long) ka->sa.sa_handler,
+	start_thread(regs, (unsigned long) ksig->ka.sa.sa_handler,
 		     (unsigned long) frame);
=20
 	/* Set up a stack frame for a call4
@@ -416,10 +416,6 @@ static int setup_frame(int sig, struct k_sigaction *ka=
, siginfo_t *info,
 #endif
=20
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
=20
 /*
@@ -433,15 +429,11 @@ static int setup_frame(int sig, struct k_sigaction *k=
a, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
=20
 	task_pt_regs(current)->icountlevel =3D 0;
=20
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
-
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		int ret;
=20
 		/* Are we from a system call? */
@@ -457,7 +449,7 @@ static void do_signal(struct pt_regs *regs)
 					break;
=20
 				case -ERESTARTSYS:
-					if (!(ka.sa.sa_flags & SA_RESTART)) {
+					if (!(ksig.ka.sa.sa_flags & SA_RESTART)) {
 						regs->areg[2] =3D -EINTR;
 						break;
 					}
@@ -476,11 +468,8 @@ static void do_signal(struct pt_regs *regs)
=20
 		/* Whee!  Actually deliver the signal.  */
 		/* Set up the stack frame */
-		ret =3D setup_frame(signr, &ka, &info, sigmask_to_save(), regs);
-		if (ret)
-			return;
-
-		signal_delivered(signr, &info, &ka, regs, 0);
+		ret =3D setup_frame(&ksig, sigmask_to_save(), regs);
+		signal_setup_done(ret, &ksig, 0);
 		if (current->ptrace & PT_SINGLESTEP)
 			task_pt_regs(current)->icountlevel =3D 1;
=20
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 78fb16cab13f..98e7082e0390 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -62,14 +62,22 @@ int crypto_authenc_extractkeys(struct crypto_authenc_ke=
ys *keys, const u8 *key,
 		return -EINVAL;
 	if (rta->rta_type !=3D CRYPTO_AUTHENC_KEYA_PARAM)
 		return -EINVAL;
-	if (RTA_PAYLOAD(rta) < sizeof(*param))
+
+	/*
+	 * RTA_OK() didn't align the rtattr's payload when validating that it
+	 * fits in the buffer.  Yet, the keys should start on the next 4-byte
+	 * aligned boundary.  To avoid confusion, require that the rtattr
+	 * payload be exactly the param struct, which has a 4-byte aligned size.
+	 */
+	if (RTA_PAYLOAD(rta) !=3D sizeof(*param))
 		return -EINVAL;
+	BUILD_BUG_ON(sizeof(*param) % RTA_ALIGNTO);
=20
 	param =3D RTA_DATA(rta);
 	keys->enckeylen =3D be32_to_cpu(param->enckeylen);
=20
-	key +=3D RTA_ALIGN(rta->rta_len);
-	keylen -=3D RTA_ALIGN(rta->rta_len);
+	key +=3D rta->rta_len;
+	keylen -=3D rta->rta_len;
=20
 	if (keylen < keys->enckeylen)
 		return -EINVAL;
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 39b18f74a539..27b4ceb9276c 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -132,6 +132,23 @@ void acpi_power_resources_list_free(struct list_head *=
list)
 	}
 }
=20
+static bool acpi_power_resource_is_dup(union acpi_object *package,
+				       unsigned int start, unsigned int i)
+{
+	acpi_handle rhandle, dup;
+	unsigned int j;
+
+	/* The caller is expected to check the package element types */
+	rhandle =3D package->package.elements[i].reference.handle;
+	for (j =3D start; j < i; j++) {
+		dup =3D package->package.elements[j].reference.handle;
+		if (dup =3D=3D rhandle)
+			return true;
+	}
+
+	return false;
+}
+
 int acpi_extract_power_resources(union acpi_object *package, unsigned int =
start,
 				 struct list_head *list)
 {
@@ -151,6 +168,11 @@ int acpi_extract_power_resources(union acpi_object *pa=
ckage, unsigned int start,
 			err =3D -ENODEV;
 			break;
 		}
+
+		/* Some ACPI tables contain duplicate power resource references */
+		if (acpi_power_resource_is_dup(package, start, i))
+			continue;
+
 		err =3D acpi_add_power_resource(rhandle);
 		if (err)
 			break;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 48ef233d1f02..dddba3bb56fa 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4250,6 +4250,7 @@ static const struct ata_blacklist_entry ata_device_bl=
acklist [] =3D {
 	{ "SAMSUNG MZMPC128HBFU-000MV", "CXM14M1Q", ATA_HORKAGE_NOLPM, },
 	{ "SAMSUNG SSD PM830 mSATA *",  "CXM13D1Q", ATA_HORKAGE_NOLPM, },
 	{ "SAMSUNG MZ7TD256HAFV-000L9", NULL,       ATA_HORKAGE_NOLPM, },
+	{ "SAMSUNG MZ7TE512HMHP-000L1", "EXT06L0Q", ATA_HORKAGE_NOLPM, },
=20
 	/* devices that don't properly handle queued TRIM commands */
 	{ "Micron_M500IT_*",		"MU01",	ATA_HORKAGE_NO_NCQ_TRIM, },
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index cebc758da98f..c8a363f7b926 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5422,7 +5422,6 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 	struct list_head *tmp;
 	int dev_id;
 	unsigned long ul;
-	bool already =3D false;
 	int ret;
=20
 	ret =3D kstrtoul(buf, 10, &ul);
@@ -5447,13 +5446,13 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 		spin_lock_irq(&rbd_dev->lock);
 		if (rbd_dev->open_count)
 			ret =3D -EBUSY;
-		else
-			already =3D test_and_set_bit(RBD_DEV_FLAG_REMOVING,
-							&rbd_dev->flags);
+		else if (test_and_set_bit(RBD_DEV_FLAG_REMOVING,
+					  &rbd_dev->flags))
+			ret =3D -EINPROGRESS;
 		spin_unlock_irq(&rbd_dev->lock);
 	}
 	spin_unlock(&rbd_dev_list_lock);
-	if (ret < 0 || already)
+	if (ret)
 		return ret;
=20
 	rbd_dev_header_unwatch_sync(rbd_dev);
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index f3a46b956abe..43026fa47209 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -380,7 +380,7 @@ config XILINX_HWICAP
=20
 config R3964
 	tristate "Siemens R3964 line discipline"
-	depends on TTY
+	depends on TTY && BROKEN
 	---help---
 	  This driver allows synchronous communication with devices using the
 	  Siemens R3964 packet protocol. Unless you are dealing with special
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_m=
sghandler.c
index edeadbf962d7..258a8dbafb0f 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -46,6 +46,7 @@
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
+#include <linux/nospec.h>
=20
 #define PFX "IPMI message handler: "
=20
@@ -1116,6 +1117,7 @@ int ipmi_set_my_address(ipmi_user_t   user,
 {
 	if (channel >=3D IPMI_MAX_CHANNELS)
 		return -EINVAL;
+	channel =3D array_index_nospec(channel, IPMI_MAX_CHANNELS);
 	user->intf->channels[channel].address =3D address;
 	return 0;
 }
@@ -1127,6 +1129,7 @@ int ipmi_get_my_address(ipmi_user_t   user,
 {
 	if (channel >=3D IPMI_MAX_CHANNELS)
 		return -EINVAL;
+	channel =3D array_index_nospec(channel, IPMI_MAX_CHANNELS);
 	*address =3D user->intf->channels[channel].address;
 	return 0;
 }
@@ -1138,6 +1141,7 @@ int ipmi_set_my_LUN(ipmi_user_t   user,
 {
 	if (channel >=3D IPMI_MAX_CHANNELS)
 		return -EINVAL;
+	channel =3D array_index_nospec(channel, IPMI_MAX_CHANNELS);
 	user->intf->channels[channel].lun =3D LUN & 0x3;
 	return 0;
 }
@@ -1149,6 +1153,7 @@ int ipmi_get_my_LUN(ipmi_user_t   user,
 {
 	if (channel >=3D IPMI_MAX_CHANNELS)
 		return -EINVAL;
+	channel =3D array_index_nospec(channel, IPMI_MAX_CHANNELS);
 	*address =3D user->intf->channels[channel].lun;
 	return 0;
 }
@@ -1875,6 +1880,7 @@ static int check_addr(ipmi_smi_t       intf,
 {
 	if (addr->channel >=3D IPMI_MAX_CHANNELS)
 		return -EINVAL;
+	addr->channel =3D array_index_nospec(addr->channel, IPMI_MAX_CHANNELS);
 	*lun =3D intf->channels[addr->channel].lun;
 	*saddr =3D intf->channels[addr->channel].address;
 	return 0;
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 164544afd680..618f3df6c3b9 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -59,6 +59,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/serial_8250.h>
+#include <linux/nospec.h>
 #include "smapi.h"
 #include "mwavedd.h"
 #include "3780i.h"
@@ -289,6 +290,8 @@ static long mwave_ioctl(struct file *file, unsigned int=
 iocmd,
 						ipcnum);
 				return -EINVAL;
 			}
+			ipcnum =3D array_index_nospec(ipcnum,
+						    ARRAY_SIZE(pDrvData->IPCs));
 			PRINTK_3(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl IOCTL_MW_REGISTER_IPC"
 				" ipcnum %x entry usIntCount %x\n",
@@ -317,6 +320,8 @@ static long mwave_ioctl(struct file *file, unsigned int=
 iocmd,
 						" Invalid ipcnum %x\n", ipcnum);
 				return -EINVAL;
 			}
+			ipcnum =3D array_index_nospec(ipcnum,
+						    ARRAY_SIZE(pDrvData->IPCs));
 			PRINTK_3(TRACE_MWAVE,
 				"mwavedd::mwave_ioctl IOCTL_MW_GET_IPC"
 				" ipcnum %x, usIntCount %x\n",
@@ -383,6 +388,8 @@ static long mwave_ioctl(struct file *file, unsigned int=
 iocmd,
 						ipcnum);
 				return -EINVAL;
 			}
+			ipcnum =3D array_index_nospec(ipcnum,
+						    ARRAY_SIZE(pDrvData->IPCs));
 			mutex_lock(&mwave_mutex);
 			if (pDrvData->IPCs[ipcnum].bIsEnabled =3D=3D TRUE) {
 				pDrvData->IPCs[ipcnum].bIsEnabled =3D FALSE;
diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index a03602164e3e..a68395828152 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -91,26 +91,67 @@ struct bcm2835_desc {
=20
 #define BCM2835_DMA_CS		0x00
 #define BCM2835_DMA_ADDR	0x04
+#define BCM2835_DMA_TI		0x08
 #define BCM2835_DMA_SOURCE_AD	0x0c
 #define BCM2835_DMA_DEST_AD	0x10
-#define BCM2835_DMA_NEXTCB	0x1C
+#define BCM2835_DMA_LEN		0x14
+#define BCM2835_DMA_STRIDE	0x18
+#define BCM2835_DMA_NEXTCB	0x1c
+#define BCM2835_DMA_DEBUG	0x20
=20
 /* DMA CS Control and Status bits */
-#define BCM2835_DMA_ACTIVE	BIT(0)
-#define BCM2835_DMA_INT	BIT(2)
+#define BCM2835_DMA_ACTIVE	BIT(0)  /* activate the DMA */
+#define BCM2835_DMA_END		BIT(1)  /* current CB has ended */
+#define BCM2835_DMA_INT		BIT(2)  /* interrupt status */
+#define BCM2835_DMA_DREQ	BIT(3)  /* DREQ state */
 #define BCM2835_DMA_ISPAUSED	BIT(4)  /* Pause requested or not active */
 #define BCM2835_DMA_ISHELD	BIT(5)  /* Is held by DREQ flow control */
-#define BCM2835_DMA_ERR	BIT(8)
+#define BCM2835_DMA_WAITING_FOR_WRITES BIT(6) /* waiting for last
+					       * AXI-write to ack
+					       */
+#define BCM2835_DMA_ERR		BIT(8)
+#define BCM2835_DMA_PRIORITY(x) ((x & 15) << 16) /* AXI priority */
+#define BCM2835_DMA_PANIC_PRIORITY(x) ((x & 15) << 20) /* panic priority */
+/* current value of TI.BCM2835_DMA_WAIT_RESP */
+#define BCM2835_DMA_WAIT_FOR_WRITES BIT(28)
+#define BCM2835_DMA_DIS_DEBUG	BIT(29) /* disable debug pause signal */
 #define BCM2835_DMA_ABORT	BIT(30) /* Stop current CB, go to next, WO */
 #define BCM2835_DMA_RESET	BIT(31) /* WO, self clearing */
=20
+/* Transfer information bits - also bcm2835_cb.info field */
 #define BCM2835_DMA_INT_EN	BIT(0)
+#define BCM2835_DMA_TDMODE	BIT(1) /* 2D-Mode */
+#define BCM2835_DMA_WAIT_RESP	BIT(3) /* wait for AXI-write to be acked */
 #define BCM2835_DMA_D_INC	BIT(4)
-#define BCM2835_DMA_D_DREQ	BIT(6)
+#define BCM2835_DMA_D_WIDTH	BIT(5) /* 128bit writes if set */
+#define BCM2835_DMA_D_DREQ	BIT(6) /* enable DREQ for destination */
+#define BCM2835_DMA_D_IGNORE	BIT(7) /* ignore destination writes */
 #define BCM2835_DMA_S_INC	BIT(8)
-#define BCM2835_DMA_S_DREQ	BIT(10)
-
-#define BCM2835_DMA_PER_MAP(x)	((x) << 16)
+#define BCM2835_DMA_S_WIDTH	BIT(9) /* 128bit writes if set */
+#define BCM2835_DMA_S_DREQ	BIT(10) /* enable SREQ for source */
+#define BCM2835_DMA_S_IGNORE	BIT(11) /* ignore source reads - read 0 */
+#define BCM2835_DMA_BURST_LENGTH(x) ((x & 15) << 12)
+#define BCM2835_DMA_PER_MAP(x)	((x & 31) << 16) /* REQ source */
+#define BCM2835_DMA_WAIT(x)	((x & 31) << 21) /* add DMA-wait cycles */
+#define BCM2835_DMA_NO_WIDE_BURSTS BIT(26) /* no 2 beat write bursts */
+
+/* debug register bits */
+#define BCM2835_DMA_DEBUG_LAST_NOT_SET_ERR	BIT(0)
+#define BCM2835_DMA_DEBUG_FIFO_ERR		BIT(1)
+#define BCM2835_DMA_DEBUG_READ_ERR		BIT(2)
+#define BCM2835_DMA_DEBUG_OUTSTANDING_WRITES_SHIFT 4
+#define BCM2835_DMA_DEBUG_OUTSTANDING_WRITES_BITS 4
+#define BCM2835_DMA_DEBUG_ID_SHIFT		16
+#define BCM2835_DMA_DEBUG_ID_BITS		9
+#define BCM2835_DMA_DEBUG_STATE_SHIFT		16
+#define BCM2835_DMA_DEBUG_STATE_BITS		9
+#define BCM2835_DMA_DEBUG_VERSION_SHIFT		25
+#define BCM2835_DMA_DEBUG_VERSION_BITS		3
+#define BCM2835_DMA_DEBUG_LITE			BIT(28)
+
+/* shared registers for all dma channels */
+#define BCM2835_DMA_INT_STATUS         0xfe0
+#define BCM2835_DMA_ENABLE             0xff0
=20
 #define BCM2835_DMA_DATA_TYPE_S8	1
 #define BCM2835_DMA_DATA_TYPE_S16	2
@@ -150,38 +191,32 @@ static void bcm2835_dma_desc_free(struct virt_dma_des=
c *vd)
 	kfree(desc);
 }
=20
-static int bcm2835_dma_abort(void __iomem *chan_base)
+static int bcm2835_dma_abort(struct bcm2835_chan *c)
 {
-	unsigned long cs;
+	void __iomem *chan_base =3D c->chan_base;
 	long int timeout =3D 10000;
=20
-	cs =3D readl(chan_base + BCM2835_DMA_CS);
-	if (!(cs & BCM2835_DMA_ACTIVE))
+	/*
+	 * A zero control block address means the channel is idle.
+	 * (The ACTIVE flag in the CS register is not a reliable indicator.)
+	 */
+	if (!readl(chan_base + BCM2835_DMA_ADDR))
 		return 0;
=20
 	/* Write 0 to the active bit - Pause the DMA */
 	writel(0, chan_base + BCM2835_DMA_CS);
=20
 	/* Wait for any current AXI transfer to complete */
-	while ((cs & BCM2835_DMA_ISPAUSED) && --timeout) {
+	while ((readl(chan_base + BCM2835_DMA_CS) &
+		BCM2835_DMA_WAITING_FOR_WRITES) && --timeout)
 		cpu_relax();
-		cs =3D readl(chan_base + BCM2835_DMA_CS);
-	}
=20
-	/* We'll un-pause when we set of our next DMA */
+	/* Peripheral might be stuck and fail to signal AXI write responses */
 	if (!timeout)
-		return -ETIMEDOUT;
-
-	if (!(cs & BCM2835_DMA_ACTIVE))
-		return 0;
-
-	/* Terminate the control block chain */
-	writel(0, chan_base + BCM2835_DMA_NEXTCB);
-
-	/* Abort the whole DMA */
-	writel(BCM2835_DMA_ABORT | BCM2835_DMA_ACTIVE,
-	       chan_base + BCM2835_DMA_CS);
+		dev_err(c->vc.chan.device->dev,
+			"failed to complete outstanding writes\n");
=20
+	writel(BCM2835_DMA_RESET, chan_base + BCM2835_DMA_CS);
 	return 0;
 }
=20
@@ -211,8 +246,15 @@ static irqreturn_t bcm2835_dma_callback(int irq, void =
*data)
=20
 	spin_lock_irqsave(&c->vc.lock, flags);
=20
-	/* Acknowledge interrupt */
-	writel(BCM2835_DMA_INT, c->chan_base + BCM2835_DMA_CS);
+	/*
+	 * Clear the INT flag to receive further interrupts. Keep the channel
+	 * active in case the descriptor is cyclic or in case the client has
+	 * already terminated the descriptor and issued a new one. (May happen
+	 * if this IRQ handler is threaded.) If the channel is finished, it
+	 * will remain idle despite the ACTIVE flag being set.
+	 */
+	writel(BCM2835_DMA_INT | BCM2835_DMA_ACTIVE,
+	       c->chan_base + BCM2835_DMA_CS);
=20
 	d =3D c->desc;
=20
@@ -221,9 +263,6 @@ static irqreturn_t bcm2835_dma_callback(int irq, void *=
data)
 		vchan_cyclic_callback(&d->vd);
 	}
=20
-	/* Keep the DMA engine running */
-	writel(BCM2835_DMA_ACTIVE, c->chan_base + BCM2835_DMA_CS);
-
 	spin_unlock_irqrestore(&c->vc.lock, flags);
=20
 	return IRQ_HANDLED;
@@ -456,7 +495,6 @@ static int bcm2835_dma_terminate_all(struct bcm2835_cha=
n *c)
 {
 	struct bcm2835_dmadev *d =3D to_bcm2835_dma_dev(c->vc.chan.device);
 	unsigned long flags;
-	int timeout =3D 10000;
 	LIST_HEAD(head);
=20
 	spin_lock_irqsave(&c->vc.lock, flags);
@@ -466,26 +504,10 @@ static int bcm2835_dma_terminate_all(struct bcm2835_c=
han *c)
 	list_del_init(&c->node);
 	spin_unlock(&d->lock);
=20
-	/*
-	 * Stop DMA activity: we assume the callback will not be called
-	 * after bcm_dma_abort() returns (even if it does, it will see
-	 * c->desc is NULL and exit.)
-	 */
+	/* stop DMA activity */
 	if (c->desc) {
 		c->desc =3D NULL;
-		bcm2835_dma_abort(c->chan_base);
-
-		/* Wait for stopping */
-		while (--timeout) {
-			if (!(readl(c->chan_base + BCM2835_DMA_CS) &
-						BCM2835_DMA_ACTIVE))
-				break;
-
-			cpu_relax();
-		}
-
-		if (!timeout)
-			dev_err(d->ddev.dev, "DMA transfer could not be terminated\n");
+		bcm2835_dma_abort(c);
 	}
=20
 	vchan_get_all_descriptors(&c->vc, &head);
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 7699bf1487c2..485ecabac805 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -562,11 +562,9 @@ static int dmatest_func(void *data)
 			srcs[i] =3D um->addr[i] + src_off;
 			ret =3D dma_mapping_error(dev->dev, um->addr[i]);
 			if (ret) {
-				dmaengine_unmap_put(um);
 				result("src mapping error", total_tests,
 				       src_off, dst_off, len, ret);
-				failed_tests++;
-				continue;
+				goto error_unmap_continue;
 			}
 			um->to_cnt++;
 		}
@@ -581,11 +579,9 @@ static int dmatest_func(void *data)
 					       DMA_BIDIRECTIONAL);
 			ret =3D dma_mapping_error(dev->dev, dsts[i]);
 			if (ret) {
-				dmaengine_unmap_put(um);
 				result("dst mapping error", total_tests,
 				       src_off, dst_off, len, ret);
-				failed_tests++;
-				continue;
+				goto error_unmap_continue;
 			}
 			um->bidi_cnt++;
 		}
@@ -610,12 +606,10 @@ static int dmatest_func(void *data)
 		}
=20
 		if (!tx) {
-			dmaengine_unmap_put(um);
 			result("prep error", total_tests, src_off,
 			       dst_off, len, ret);
 			msleep(100);
-			failed_tests++;
-			continue;
+			goto error_unmap_continue;
 		}
=20
 		done->done =3D false;
@@ -624,12 +618,10 @@ static int dmatest_func(void *data)
 		cookie =3D tx->tx_submit(tx);
=20
 		if (dma_submit_error(cookie)) {
-			dmaengine_unmap_put(um);
 			result("submit error", total_tests, src_off,
 			       dst_off, len, ret);
 			msleep(100);
-			failed_tests++;
-			continue;
+			goto error_unmap_continue;
 		}
 		dma_async_issue_pending(chan);
=20
@@ -639,19 +631,15 @@ static int dmatest_func(void *data)
 		status =3D dma_async_is_tx_complete(chan, cookie, NULL, NULL);
=20
 		if (!done->done) {
-			dmaengine_unmap_put(um);
 			result("test timed out", total_tests, src_off, dst_off,
 			       len, 0);
-			failed_tests++;
-			continue;
+			goto error_unmap_continue;
 		} else if (status !=3D DMA_COMPLETE) {
-			dmaengine_unmap_put(um);
 			result(status =3D=3D DMA_ERROR ?
 			       "completion error status" :
 			       "completion busy status", total_tests, src_off,
 			       dst_off, len, ret);
-			failed_tests++;
-			continue;
+			goto error_unmap_continue;
 		}
=20
 		dmaengine_unmap_put(um);
@@ -690,6 +678,12 @@ static int dmatest_func(void *data)
 			verbose_result("test passed", total_tests, src_off,
 				       dst_off, len, 0);
 		}
+
+		continue;
+
+error_unmap_continue:
+		dmaengine_unmap_put(um);
+		failed_tests++;
 	}
 	runtime =3D ktime_us_delta(ktime_get(), ktime);
=20
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 286660a12cc6..175cb9f22353 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -624,7 +624,7 @@ static void imxdma_tasklet(unsigned long data)
 {
 	struct imxdma_channel *imxdmac =3D (void *)data;
 	struct imxdma_engine *imxdma =3D imxdmac->imxdma;
-	struct imxdma_desc *desc;
+	struct imxdma_desc *desc, *next_desc;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&imxdma->lock, flags);
@@ -654,10 +654,10 @@ static void imxdma_tasklet(unsigned long data)
 	list_move_tail(imxdmac->ld_active.next, &imxdmac->ld_free);
=20
 	if (!list_empty(&imxdmac->ld_queue)) {
-		desc =3D list_first_entry(&imxdmac->ld_queue, struct imxdma_desc,
-					node);
+		next_desc =3D list_first_entry(&imxdmac->ld_queue,
+					     struct imxdma_desc, node);
 		list_move_tail(imxdmac->ld_queue.next, &imxdmac->ld_active);
-		if (imxdma_xfer_desc(desc) < 0)
+		if (imxdma_xfer_desc(next_desc) < 0)
 			dev_warn(imxdma->dev, "%s: channel: %d couldn't xfer desc\n",
 				 __func__, imxdmac->channel);
 	}
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helpe=
r.c
index 9b12e0aae3fe..ad0e612c5b57 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -769,6 +769,64 @@ static bool drm_fb_pixel_format_equal(const struct fb_=
var_screeninfo *var_1,
 	       var_1->transp.msb_right =3D=3D var_2->transp.msb_right;
 }
=20
+static void drm_fb_helper_fill_pixel_fmt(struct fb_var_screeninfo *var,
+					 u8 depth)
+{
+	switch (depth) {
+	case 8:
+		var->red.offset =3D 0;
+		var->green.offset =3D 0;
+		var->blue.offset =3D 0;
+		var->red.length =3D 8; /* 8bit DAC */
+		var->green.length =3D 8;
+		var->blue.length =3D 8;
+		var->transp.offset =3D 0;
+		var->transp.length =3D 0;
+		break;
+	case 15:
+		var->red.offset =3D 10;
+		var->green.offset =3D 5;
+		var->blue.offset =3D 0;
+		var->red.length =3D 5;
+		var->green.length =3D 5;
+		var->blue.length =3D 5;
+		var->transp.offset =3D 15;
+		var->transp.length =3D 1;
+		break;
+	case 16:
+		var->red.offset =3D 11;
+		var->green.offset =3D 5;
+		var->blue.offset =3D 0;
+		var->red.length =3D 5;
+		var->green.length =3D 6;
+		var->blue.length =3D 5;
+		var->transp.offset =3D 0;
+		break;
+	case 24:
+		var->red.offset =3D 16;
+		var->green.offset =3D 8;
+		var->blue.offset =3D 0;
+		var->red.length =3D 8;
+		var->green.length =3D 8;
+		var->blue.length =3D 8;
+		var->transp.offset =3D 0;
+		var->transp.length =3D 0;
+		break;
+	case 32:
+		var->red.offset =3D 16;
+		var->green.offset =3D 8;
+		var->blue.offset =3D 0;
+		var->red.length =3D 8;
+		var->green.length =3D 8;
+		var->blue.length =3D 8;
+		var->transp.offset =3D 24;
+		var->transp.length =3D 8;
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * drm_fb_helper_check_var - implementation for ->fb_check_var
  * @var: screeninfo to check
@@ -780,9 +838,14 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *=
var,
 	struct drm_fb_helper *fb_helper =3D info->par;
 	struct drm_framebuffer *fb =3D fb_helper->fb;
=20
-	if (var->pixclock !=3D 0 || in_dbg_master())
+	if (in_dbg_master())
 		return -EINVAL;
=20
+	if (var->pixclock !=3D 0) {
+		DRM_DEBUG("fbdev emulation doesn't support changing the pixel clock, val=
ue of pixclock is ignored\n");
+		var->pixclock =3D 0;
+	}
+
 	/* Need to resize the fb object !!! */
 	if (var->bits_per_pixel > fb->bits_per_pixel ||
 	    var->xres > fb->width || var->yres > fb->height ||
@@ -795,6 +858,20 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *=
var,
 		return -EINVAL;
 	}
=20
+	/*
+	 * Workaround for SDL 1.2, which is known to be setting all pixel format
+	 * fields values to zero in some cases. We treat this situation as a
+	 * kind of "use some reasonable autodetected values".
+	 */
+	if (!var->red.offset     && !var->green.offset    &&
+	    !var->blue.offset    && !var->transp.offset   &&
+	    !var->red.length     && !var->green.length    &&
+	    !var->blue.length    && !var->transp.length   &&
+	    !var->red.msb_right  && !var->green.msb_right &&
+	    !var->blue.msb_right && !var->transp.msb_right) {
+		drm_fb_helper_fill_pixel_fmt(var, fb->depth);
+	}
+
 	/*
 	 * drm fbdev emulation doesn't support changing the pixel format at all,
 	 * so reject all pixel format changing requests.
@@ -1058,59 +1135,7 @@ void drm_fb_helper_fill_var(struct fb_info *info, st=
ruct drm_fb_helper *fb_helpe
 	info->var.height =3D -1;
 	info->var.width =3D -1;
=20
-	switch (fb->depth) {
-	case 8:
-		info->var.red.offset =3D 0;
-		info->var.green.offset =3D 0;
-		info->var.blue.offset =3D 0;
-		info->var.red.length =3D 8; /* 8bit DAC */
-		info->var.green.length =3D 8;
-		info->var.blue.length =3D 8;
-		info->var.transp.offset =3D 0;
-		info->var.transp.length =3D 0;
-		break;
-	case 15:
-		info->var.red.offset =3D 10;
-		info->var.green.offset =3D 5;
-		info->var.blue.offset =3D 0;
-		info->var.red.length =3D 5;
-		info->var.green.length =3D 5;
-		info->var.blue.length =3D 5;
-		info->var.transp.offset =3D 15;
-		info->var.transp.length =3D 1;
-		break;
-	case 16:
-		info->var.red.offset =3D 11;
-		info->var.green.offset =3D 5;
-		info->var.blue.offset =3D 0;
-		info->var.red.length =3D 5;
-		info->var.green.length =3D 6;
-		info->var.blue.length =3D 5;
-		info->var.transp.offset =3D 0;
-		break;
-	case 24:
-		info->var.red.offset =3D 16;
-		info->var.green.offset =3D 8;
-		info->var.blue.offset =3D 0;
-		info->var.red.length =3D 8;
-		info->var.green.length =3D 8;
-		info->var.blue.length =3D 8;
-		info->var.transp.offset =3D 0;
-		info->var.transp.length =3D 0;
-		break;
-	case 32:
-		info->var.red.offset =3D 16;
-		info->var.green.offset =3D 8;
-		info->var.blue.offset =3D 0;
-		info->var.red.length =3D 8;
-		info->var.green.length =3D 8;
-		info->var.blue.length =3D 8;
-		info->var.transp.offset =3D 24;
-		info->var.transp.length =3D 8;
-		break;
-	default:
-		break;
-	}
+	drm_fb_helper_fill_pixel_fmt(&info->var, fb->depth);
=20
 	info->var.xres =3D fb_width;
 	info->var.yres =3D fb_height;
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index bedf1894e17e..7840d8f81027 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -682,7 +682,7 @@ int drm_mode_hsync(const struct drm_display_mode *mode)
 	if (mode->hsync)
 		return mode->hsync;
=20
-	if (mode->htotal < 0)
+	if (mode->htotal <=3D 0)
 		return 0;
=20
 	calc_val =3D (mode->clock * 1000) / mode->htotal; /* hsync in Hz */
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_drv.c
index cda0c1106c7c..bdb93a73d865 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -567,13 +567,16 @@ static int vmw_dma_select_mode(struct vmw_private *de=
v_priv)
 static int vmw_dma_masks(struct vmw_private *dev_priv)
 {
 	struct drm_device *dev =3D dev_priv->dev;
+	int ret =3D 0;
=20
-	if (intel_iommu_enabled &&
+	ret =3D dma_set_mask_and_coherent(dev->dev, DMA_BIT_MASK(64));
+	if (dev_priv->map_mode !=3D vmw_dma_phys &&
 	    (sizeof(unsigned long) =3D=3D 4 || vmw_restrict_dma_mask)) {
 		DRM_INFO("Restricting DMA addresses to 44 bits.\n");
-		return dma_set_mask(dev->dev, DMA_BIT_MASK(44));
+		return dma_set_mask_and_coherent(dev->dev, DMA_BIT_MASK(44));
 	}
-	return 0;
+
+	return ret;
 }
 #else
 static int vmw_dma_masks(struct vmw_private *dev_priv)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwg=
fx/vmwgfx_execbuf.c
index 129751121684..a938e05dba21 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2326,7 +2326,7 @@ int vmw_execbuf_fence_commands(struct drm_file *file_=
priv,
 		*p_fence =3D NULL;
 	}
=20
-	return 0;
+	return ret;
 }
=20
 /**
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 97f3ad011c61..8cf7c076e529 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -580,8 +580,9 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *ring=
_info,
 		   u32 offset, bool *signal);
=20
=20
-void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
-			    struct hv_ring_buffer_debug_info *debug_info);
+
+int hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
+				struct hv_ring_buffer_debug_info *debug_info);
=20
 void hv_begin_read(struct hv_ring_buffer_info *rbi);
=20
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 5648add68e51..716b2703d95a 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -329,26 +329,25 @@ static u32 hv_copyto_ringbuffer(
  * Get various debug metrics for the specified ring buffer
  *
  */
-void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
-			    struct hv_ring_buffer_debug_info *debug_info)
+int hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
+				struct hv_ring_buffer_debug_info *debug_info)
 {
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
=20
-	if (ring_info->ring_buffer) {
-		hv_get_ringbuffer_availbytes(ring_info,
-					&bytes_avail_toread,
-					&bytes_avail_towrite);
-
-		debug_info->bytes_avail_toread =3D bytes_avail_toread;
-		debug_info->bytes_avail_towrite =3D bytes_avail_towrite;
-		debug_info->current_read_index =3D
-			ring_info->ring_buffer->read_index;
-		debug_info->current_write_index =3D
-			ring_info->ring_buffer->write_index;
-		debug_info->current_interrupt_mask =3D
-			ring_info->ring_buffer->interrupt_mask;
-	}
+	if (!ring_info->ring_buffer)
+		return -EINVAL;
+
+	hv_get_ringbuffer_availbytes(ring_info,
+				     &bytes_avail_toread,
+				     &bytes_avail_towrite);
+	debug_info->bytes_avail_toread =3D bytes_avail_toread;
+	debug_info->bytes_avail_towrite =3D bytes_avail_towrite;
+	debug_info->current_read_index =3D ring_info->ring_buffer->read_index;
+	debug_info->current_write_index =3D ring_info->ring_buffer->write_index;
+	debug_info->current_interrupt_mask
+		=3D ring_info->ring_buffer->interrupt_mask;
+	return 0;
 }
=20
 /*
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 68523636410b..92bdedec8ceb 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -257,12 +257,16 @@ static ssize_t out_intr_mask_show(struct device *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info outbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound, &outbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound,
+					  &outbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", outbound.current_interrupt_mask);
 }
 static DEVICE_ATTR_RO(out_intr_mask);
@@ -272,12 +276,15 @@ static ssize_t out_read_index_show(struct device *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info outbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound, &outbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound,
+					  &outbound);
+	if (ret < 0)
+		return ret;
 	return sprintf(buf, "%d\n", outbound.current_read_index);
 }
 static DEVICE_ATTR_RO(out_read_index);
@@ -288,12 +295,15 @@ static ssize_t out_write_index_show(struct device *de=
v,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info outbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound, &outbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound,
+					  &outbound);
+	if (ret < 0)
+		return ret;
 	return sprintf(buf, "%d\n", outbound.current_write_index);
 }
 static DEVICE_ATTR_RO(out_write_index);
@@ -304,12 +314,15 @@ static ssize_t out_read_bytes_avail_show(struct devic=
e *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info outbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound, &outbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound,
+					  &outbound);
+	if (ret < 0)
+		return ret;
 	return sprintf(buf, "%d\n", outbound.bytes_avail_toread);
 }
 static DEVICE_ATTR_RO(out_read_bytes_avail);
@@ -320,12 +333,15 @@ static ssize_t out_write_bytes_avail_show(struct devi=
ce *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info outbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound, &outbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->outbound,
+					  &outbound);
+	if (ret < 0)
+		return ret;
 	return sprintf(buf, "%d\n", outbound.bytes_avail_towrite);
 }
 static DEVICE_ATTR_RO(out_write_bytes_avail);
@@ -335,12 +351,15 @@ static ssize_t in_intr_mask_show(struct device *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info inbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", inbound.current_interrupt_mask);
 }
 static DEVICE_ATTR_RO(in_intr_mask);
@@ -350,12 +369,15 @@ static ssize_t in_read_index_show(struct device *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info inbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", inbound.current_read_index);
 }
 static DEVICE_ATTR_RO(in_read_index);
@@ -365,12 +387,15 @@ static ssize_t in_write_index_show(struct device *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info inbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", inbound.current_write_index);
 }
 static DEVICE_ATTR_RO(in_write_index);
@@ -381,12 +406,15 @@ static ssize_t in_read_bytes_avail_show(struct device=
 *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info inbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", inbound.bytes_avail_toread);
 }
 static DEVICE_ATTR_RO(in_read_bytes_avail);
@@ -397,12 +425,15 @@ static ssize_t in_write_bytes_avail_show(struct devic=
e *dev,
 {
 	struct hv_device *hv_dev =3D device_to_hv_device(dev);
 	struct hv_ring_buffer_debug_info inbound;
+	int ret;
=20
 	if (!hv_dev->channel)
 		return -ENODEV;
-	if (hv_dev->channel->state !=3D CHANNEL_OPENED_STATE)
-		return -EINVAL;
-	hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+
+	ret =3D hv_ringbuffer_get_debuginfo(&hv_dev->channel->inbound, &inbound);
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%d\n", inbound.bytes_avail_towrite);
 }
 static DEVICE_ATTR_RO(in_write_bytes_avail);
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cade=
nce.c
index 4c4aee58c741..b30ef22adf1a 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -320,8 +320,10 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
 	 */
-	if (id->recv_count > CDNS_I2C_FIFO_DEPTH)
+	if ((id->recv_count > CDNS_I2C_FIFO_DEPTH)  || id->bus_hold_flag)
 		ctrl_reg |=3D CDNS_I2C_CR_HOLD;
+	else
+		ctrl_reg =3D ctrl_reg & ~CDNS_I2C_CR_HOLD;
=20
 	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
=20
@@ -375,8 +377,11 @@ static void cdns_i2c_msend(struct cdns_i2c *id)
 	 * Check for the message size against FIFO depth and set the
 	 * 'hold bus' bit if it is greater than FIFO depth.
 	 */
-	if (id->send_count > CDNS_I2C_FIFO_DEPTH)
+	if ((id->send_count > CDNS_I2C_FIFO_DEPTH) || id->bus_hold_flag)
 		ctrl_reg |=3D CDNS_I2C_CR_HOLD;
+	else
+		ctrl_reg =3D ctrl_reg & ~CDNS_I2C_CR_HOLD;
+
 	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
=20
 	/* Clear the interrupts in interrupt status register. */
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 3baf4af1413a..69640fa51cb8 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -467,9 +467,15 @@ static long i2cdev_ioctl(struct file *file, unsigned i=
nt cmd, unsigned long arg)
 		return i2cdev_ioctl_smbus(client, arg);
=20
 	case I2C_RETRIES:
+		if (arg > INT_MAX)
+			return -EINVAL;
+
 		client->adapter->retries =3D arg;
 		break;
 	case I2C_TIMEOUT:
+		if (arg > INT_MAX)
+			return -EINVAL;
+
 		/* For historical reasons, user-space sets the timeout
 		 * value in units of 10 ms.
 		 */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/=
ipoib/ipoib.h
index be5738271af5..5e797770fe4f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -228,7 +228,6 @@ struct ipoib_cm_tx {
 	struct list_head     list;
 	struct net_device   *dev;
 	struct ipoib_neigh  *neigh;
-	struct ipoib_path   *path;
 	struct ipoib_cm_tx_buf *tx_ring;
 	unsigned	     tx_head;
 	unsigned	     tx_tail;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/u=
lp/ipoib/ipoib_cm.c
index 43d648332e63..2e6b63b8ec45 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1279,7 +1279,6 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_dev=
ice *dev, struct ipoib_path
=20
 	neigh->cm =3D tx;
 	tx->neigh =3D neigh;
-	tx->path =3D path;
 	tx->dev =3D dev;
 	list_add(&tx->list, &priv->cm.start_list);
 	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
@@ -1338,7 +1337,7 @@ static void ipoib_cm_tx_start(struct work_struct *wor=
k)
 				neigh->daddr + QPN_AND_OPTIONS_OFFSET);
 			goto free_neigh;
 		}
-		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
+		memcpy(&pathrec, &path->pathrec, sizeof(pathrec));
=20
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
index b36831c828d3..8beaef2af58e 100644
--- a/drivers/input/misc/bma150.c
+++ b/drivers/input/misc/bma150.c
@@ -483,13 +483,14 @@ static int bma150_register_input_device(struct bma150=
_data *bma150)
 	idev->close =3D bma150_irq_close;
 	input_set_drvdata(idev, bma150);
=20
+	bma150->input =3D idev;
+
 	error =3D input_register_device(idev);
 	if (error) {
 		input_free_device(idev);
 		return error;
 	}
=20
-	bma150->input =3D idev;
 	return 0;
 }
=20
@@ -512,15 +513,15 @@ static int bma150_register_polled_device(struct bma15=
0_data *bma150)
=20
 	bma150_init_input_device(bma150, ipoll_dev->input);
=20
+	bma150->input_polled =3D ipoll_dev;
+	bma150->input =3D ipoll_dev->input;
+
 	error =3D input_register_polled_device(ipoll_dev);
 	if (error) {
 		input_free_polled_device(ipoll_dev);
 		return error;
 	}
=20
-	bma150->input_polled =3D ipoll_dev;
-	bma150->input =3D ipoll_dev->input;
-
 	return 0;
 }
=20
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 049aada5e8d9..ae57650848c8 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1036,6 +1036,8 @@ static int elantech_get_resolution_v4(struct psmouse =
*psmouse,
  * Asus UX31               0x361f00        20, 15, 0e      clickpad
  * Asus UX32VD             0x361f02        00, 15, 0e      clickpad
  * Avatar AVIU-145A2       0x361f00        ?               clickpad
+ * Fujitsu CELSIUS H760    0x570f02        40, 14, 0c      3 hw buttons (*=
*)
+ * Fujitsu CELSIUS H780    0x5d0f02        41, 16, 0d      3 hw buttons (*=
*)
  * Fujitsu LIFEBOOK E544   0x470f00        d0, 12, 09      2 hw buttons
  * Fujitsu LIFEBOOK E546   0x470f00        50, 12, 09      2 hw buttons
  * Fujitsu LIFEBOOK E547   0x470f00        50, 12, 09      2 hw buttons
@@ -1076,6 +1078,20 @@ static const struct dmi_system_id elantech_dmi_has_m=
iddle_button[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS H730"),
 		},
 	},
+	{
+		/* Fujitsu H760 also has a middle button */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS H760"),
+		},
+	},
+	{
+		/* Fujitsu H780 also has a middle button */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS H780"),
+		},
+	},
 #endif
 	{ }
 };
@@ -1419,6 +1435,13 @@ static const struct dmi_system_id elantech_dmi_force=
_crc_enabled[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS H730"),
 		},
 	},
+	{
+		/* Fujitsu H760 does not work with crc_enabled =3D=3D 0 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS H760"),
+		},
+	},
 	{
 		/* Fujitsu LIFEBOOK E544  does not work with crc_enabled =3D=3D 0 */
 		.matches =3D {
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 353417c95502..9eacb0b1a1ef 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2185,14 +2185,11 @@ static void do_attach(struct iommu_dev_data *dev_da=
ta,
=20
 static void do_detach(struct iommu_dev_data *dev_data)
 {
+	struct protection_domain *domain =3D dev_data->domain;
 	struct amd_iommu *iommu;
=20
 	iommu =3D amd_iommu_rlookup_table[dev_data->devid];
=20
-	/* decrease reference counters */
-	dev_data->domain->dev_iommu[iommu->index] -=3D 1;
-	dev_data->domain->dev_cnt                 -=3D 1;
-
 	/* Update data structures */
 	dev_data->domain =3D NULL;
 	list_del(&dev_data->list);
@@ -2200,6 +2197,16 @@ static void do_detach(struct iommu_dev_data *dev_dat=
a)
=20
 	/* Flush the DTE entry */
 	device_flush_dte(dev_data);
+
+	/* Flush IOTLB */
+	domain_flush_tlb_pde(domain);
+
+	/* Wait for the flushes to finish */
+	domain_flush_complete(domain);
+
+	/* decrease reference counters - needs to happen after the flushes */
+	domain->dev_iommu[iommu->index] -=3D 1;
+	domain->dev_cnt                 -=3D 1;
 }
=20
 /*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 9c6f5a66b21c..0229770915ee 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -185,6 +185,7 @@ struct pool {
=20
 	spinlock_t lock;
 	struct bio_list deferred_flush_bios;
+	struct bio_list deferred_flush_completions;
 	struct list_head prepared_mappings;
 	struct list_head prepared_discards;
 	struct list_head active_thins;
@@ -665,6 +666,39 @@ static void process_prepared_mapping_fail(struct dm_th=
in_new_mapping *m)
 	mempool_free(m, m->tc->pool->mapping_pool);
 }
=20
+static void complete_overwrite_bio(struct thin_c *tc, struct bio *bio)
+{
+	struct pool *pool =3D tc->pool;
+	unsigned long flags;
+
+	/*
+	 * If the bio has the REQ_FUA flag set we must commit the metadata
+	 * before signaling its completion.
+	 */
+	if (!bio_triggers_commit(tc, bio)) {
+		bio_endio(bio, 0);
+		return;
+	}
+
+	/*
+	 * Complete bio with an error if earlier I/O caused changes to the
+	 * metadata that can't be committed, e.g, due to I/O errors on the
+	 * metadata device.
+	 */
+	if (dm_thin_aborted_changes(tc->td)) {
+		bio_io_error(bio);
+		return;
+	}
+
+	/*
+	 * Batch together any bios that trigger commits and then issue a
+	 * single commit for them in process_deferred_bios().
+	 */
+	spin_lock_irqsave(&pool->lock, flags);
+	bio_list_add(&pool->deferred_flush_completions, bio);
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
 static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc =3D m->tc;
@@ -703,7 +737,7 @@ static void process_prepared_mapping(struct dm_thin_new=
_mapping *m)
 	 */
 	if (bio) {
 		cell_defer_no_holder(tc, m->cell);
-		bio_endio(bio, 0);
+		complete_overwrite_bio(tc, bio);
 	} else
 		cell_defer(tc, m->cell);
=20
@@ -1575,7 +1609,7 @@ static void process_deferred_bios(struct pool *pool)
 {
 	unsigned long flags;
 	struct bio *bio;
-	struct bio_list bios;
+	struct bio_list bios, bio_completions;
 	struct thin_c *tc;
=20
 	tc =3D get_first_thin(pool);
@@ -1585,26 +1619,36 @@ static void process_deferred_bios(struct pool *pool)
 	}
=20
 	/*
-	 * If there are any deferred flush bios, we must commit
-	 * the metadata before issuing them.
+	 * If there are any deferred flush bios, we must commit the metadata
+	 * before issuing them or signaling their completion.
 	 */
 	bio_list_init(&bios);
+	bio_list_init(&bio_completions);
+
 	spin_lock_irqsave(&pool->lock, flags);
 	bio_list_merge(&bios, &pool->deferred_flush_bios);
 	bio_list_init(&pool->deferred_flush_bios);
+
+	bio_list_merge(&bio_completions, &pool->deferred_flush_completions);
+	bio_list_init(&pool->deferred_flush_completions);
 	spin_unlock_irqrestore(&pool->lock, flags);
=20
-	if (bio_list_empty(&bios) &&
+	if (bio_list_empty(&bios) && bio_list_empty(&bio_completions) &&
 	    !(dm_pool_changed_this_transaction(pool->pmd) && need_commit_due_to_t=
ime(pool)))
 		return;
=20
 	if (commit(pool)) {
+		bio_list_merge(&bios, &bio_completions);
+
 		while ((bio =3D bio_list_pop(&bios)))
 			bio_io_error(bio);
 		return;
 	}
 	pool->last_commit_jiffies =3D jiffies;
=20
+	while ((bio =3D bio_list_pop(&bio_completions)))
+		bio_endio(bio, 0);
+
 	while ((bio =3D bio_list_pop(&bios)))
 		generic_make_request(bio);
 }
@@ -2174,6 +2218,7 @@ static struct pool *pool_create(struct mapped_device =
*pool_md,
 	INIT_DELAYED_WORK(&pool->no_space_timeout, do_no_space_timeout);
 	spin_lock_init(&pool->lock);
 	bio_list_init(&pool->deferred_flush_bios);
+	bio_list_init(&pool->deferred_flush_completions);
 	INIT_LIST_HEAD(&pool->prepared_mappings);
 	INIT_LIST_HEAD(&pool->prepared_discards);
 	INIT_LIST_HEAD(&pool->active_thins);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28=
xx/em28xx-dvb.c
index 26ada1ae166e..bbeb101ccbfd 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1651,6 +1651,8 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 			prevent_sleep(&dvb->fe[1]->ops);
 	}
=20
+	em28xx_unregister_dvb(dvb);
+
 	/* remove I2C tuner */
 	if (client) {
 		module_put(client->dev.driver->owner);
@@ -1664,7 +1666,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 		i2c_unregister_device(client);
 	}
=20
-	em28xx_unregister_dvb(dvb);
 	kfree(dvb);
 	dev->dvb =3D NULL;
 	kref_put(&dev->ref, em28xx_free_device);
@@ -1712,7 +1713,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	em28xx_info("Resuming DVB extension\n");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb =3D dev->dvb;
-		struct i2c_client *client =3D dvb->i2c_client_tuner;
=20
 		if (dvb->fe[0]) {
 			ret =3D dvb_frontend_resume(dvb->fe[0]);
@@ -1723,22 +1723,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 			ret =3D dvb_frontend_resume(dvb->fe[1]);
 			em28xx_info("fe1 resume %d\n", ret);
 		}
-		/* remove I2C tuner */
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
-
-		/* remove I2C demod */
-		client =3D dvb->i2c_client_demod;
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
-
-		em28xx_unregister_dvb(dvb);
-		kfree(dvb);
-		dev->dvb =3D NULL;
 	}
=20
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core=
/v4l2-ioctl.c
index e2f71def945a..2c2b7fcdb5bc 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -247,6 +247,7 @@ static void v4l_print_format(const void *arg, bool writ=
e_only)
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
 	const struct v4l2_sdr_format *sdr;
+	u32 planes;
 	unsigned i;
=20
 	pr_cont("type=3D%s", prt_names(p->type, v4l2_type_names));
@@ -279,7 +280,8 @@ static void v4l_print_format(const void *arg, bool writ=
e_only)
 			(mp->pixelformat >> 24) & 0xff,
 			prt_names(mp->field, v4l2_field_names),
 			mp->colorspace, mp->num_planes);
-		for (i =3D 0; i < mp->num_planes; i++)
+		planes =3D min_t(u32, mp->num_planes, VIDEO_MAX_PLANES);
+		for (i =3D 0; i < planes; i++)
 			printk(KERN_DEBUG "plane %u: bytesperline=3D%u sizeimage=3D%u\n", i,
 					mp->plane_fmt[i].bytesperline,
 					mp->plane_fmt[i].sizeimage);
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index cf2e6a198c6b..798d5a1c2119 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -259,7 +259,7 @@ static int get_register_interruptible(struct ab8500 *ab=
8500, u8 bank,
 	mutex_unlock(&ab8500->lock);
 	dev_vdbg(ab8500->dev, "rd: addr %#x =3D> data %#x\n", addr, ret);
=20
-	return ret;
+	return (ret < 0) ? ret : 0;
 }
=20
 static int ab8500_get_register(struct device *dev, u8 bank,
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 8e1dbc469580..e3ad71c494f1 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -601,6 +601,29 @@ static int tps6586x_i2c_remove(struct i2c_client *clie=
nt)
 	return 0;
 }
=20
+static int __maybe_unused tps6586x_i2c_suspend(struct device *dev)
+{
+	struct tps6586x *tps6586x =3D dev_get_drvdata(dev);
+
+	if (tps6586x->client->irq)
+		disable_irq(tps6586x->client->irq);
+
+	return 0;
+}
+
+static int __maybe_unused tps6586x_i2c_resume(struct device *dev)
+{
+	struct tps6586x *tps6586x =3D dev_get_drvdata(dev);
+
+	if (tps6586x->client->irq)
+		enable_irq(tps6586x->client->irq);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(tps6586x_pm_ops, tps6586x_i2c_suspend,
+			 tps6586x_i2c_resume);
+
 static const struct i2c_device_id tps6586x_id_table[] =3D {
 	{ "tps6586x", 0 },
 	{ },
@@ -612,6 +635,7 @@ static struct i2c_driver tps6586x_driver =3D {
 		.name	=3D "tps6586x",
 		.owner	=3D THIS_MODULE,
 		.of_match_table =3D of_match_ptr(tps6586x_of_match),
+		.pm	=3D &tps6586x_pm_ops,
 	},
 	.probe		=3D tps6586x_i2c_probe,
 	.remove		=3D tps6586x_i2c_remove,
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index e4a07546f8b6..a55c4fb42b00 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1438,6 +1438,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 			goto fail_add_host;
 		mmc_gpiod_request_cd_irq(mmc);
 	}
+	mmc_detect_change(mmc, 0);
=20
 	if (host->pdata && host->pdata->flags & MMC_SPI_USE_RO_GPIO) {
 		has_ro =3D true;
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pi=
o.c
index 59d9a7249b2e..0c742cf362ca 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -639,7 +639,7 @@ irqreturn_t tmio_mmc_sdio_irq(int irq, void *devid)
 	unsigned int ireg, status;
=20
 	if (!(pdata->flags & TMIO_MMC_SDIO_IRQ))
-		return IRQ_HANDLED;
+		return IRQ_NONE;
=20
 	status =3D sd_ctrl_read16(host, CTL_SDIO_STATUS);
 	ireg =3D status & TMIO_SDIO_MASK_ALL & ~host->sdcard_irq_mask;
@@ -649,7 +649,7 @@ irqreturn_t tmio_mmc_sdio_irq(int irq, void *devid)
 	if (mmc->caps & MMC_CAP_SDIO_IRQ && ireg & TMIO_SDIO_STAT_IOIRQ)
 		mmc_signal_sdio_irq(mmc);
=20
-	return IRQ_HANDLED;
+	return ireg ? IRQ_HANDLED : IRQ_NONE;
 }
 EXPORT_SYMBOL(tmio_mmc_sdio_irq);
=20
@@ -666,9 +666,7 @@ irqreturn_t tmio_mmc_irq(int irq, void *devid)
 	if (__tmio_mmc_sdcard_irq(host, ireg, status))
 		return IRQ_HANDLED;
=20
-	tmio_mmc_sdio_irq(irq, devid);
-
-	return IRQ_HANDLED;
+	return tmio_mmc_sdio_irq(irq, devid);
 }
 EXPORT_SYMBOL(tmio_mmc_irq);
=20
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-=
nand/gpmi-lib.c
index 87e658ce23ef..43ee8b57a59f 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -168,9 +168,10 @@ int gpmi_init(struct gpmi_nand_data *this)
=20
 	/*
 	 * Reset BCH here, too. We got failures otherwise :(
-	 * See later BCH reset for explanation of MX23 handling
+	 * See later BCH reset for explanation of MX23 and MX28 handling
 	 */
-	ret =3D gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
+	ret =3D gpmi_reset_block(r->bch_regs,
+			       GPMI_IS_MX23(this) || GPMI_IS_MX28(this));
 	if (ret)
 		goto err_out;
=20
@@ -275,12 +276,10 @@ int bch_set_geometry(struct gpmi_nand_data *this)
 	/*
 	* Due to erratum #2847 of the MX23, the BCH cannot be soft reset on this
 	* chip, otherwise it will lock up. So we skip resetting BCH on the MX23.
-	* On the other hand, the MX28 needs the reset, because one case has been
-	* seen where the BCH produced ECC errors constantly after 10000
-	* consecutive reboots. The latter case has not been seen on the MX23
-	* yet, still we don't know if it could happen there as well.
+	* and MX28.
 	*/
-	ret =3D gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
+	ret =3D gpmi_reset_block(r->bch_regs,
+			       GPMI_IS_MX23(this) || GPMI_IS_MX28(this));
 	if (ret)
 		goto err_out;
=20
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index fbb67db07c57..5af6370ea208 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -425,8 +425,6 @@ EXPORT_SYMBOL_GPL(can_put_echo_skb);
 struct sk_buff *__can_get_echo_skb(struct net_device *dev, unsigned int id=
x, u8 *len_ptr)
 {
 	struct can_priv *priv =3D netdev_priv(dev);
-	struct sk_buff *skb =3D priv->echo_skb[idx];
-	struct canfd_frame *cf;
=20
 	if (idx >=3D priv->echo_skb_max) {
 		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bou=
nds (%u/max %u)\n",
@@ -434,20 +432,21 @@ struct sk_buff *__can_get_echo_skb(struct net_device =
*dev, unsigned int idx, u8
 		return NULL;
 	}
=20
-	if (!skb) {
-		netdev_err(dev, "%s: BUG! Trying to echo non existing skb: can_priv::ech=
o_skb[%u]\n",
-			   __func__, idx);
-		return NULL;
-	}
+	if (priv->echo_skb[idx]) {
+		/* Using "struct canfd_frame::len" for the frame
+		 * length is supported on both CAN and CANFD frames.
+		 */
+		struct sk_buff *skb =3D priv->echo_skb[idx];
+		struct canfd_frame *cf =3D (struct canfd_frame *)skb->data;
+		u8 len =3D cf->len;
+
+		*len_ptr =3D len;
+		priv->echo_skb[idx] =3D NULL;
=20
-	/* Using "struct canfd_frame::len" for the frame
-	 * length is supported on both CAN and CANFD frames.
-	 */
-	cf =3D (struct canfd_frame *)skb->data;
-	*len_ptr =3D cf->len;
-	priv->echo_skb[idx] =3D NULL;
+		return skb;
+	}
=20
-	return skb;
+	return NULL;
 }
=20
 /*
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/mar=
vell/skge.c
index e912b6887d40..b23c3f684bde 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -152,8 +152,10 @@ static void skge_get_regs(struct net_device *dev, stru=
ct ethtool_regs *regs,
 	memset(p, 0, regs->len);
 	memcpy_fromio(p, io, B3_RAM_ADDR);
=20
-	memcpy_fromio(p + B3_RI_WTO_R1, io + B3_RI_WTO_R1,
-		      regs->len - B3_RI_WTO_R1);
+	if (regs->len > B3_RI_WTO_R1) {
+		memcpy_fromio(p + B3_RI_WTO_R1, io + B3_RI_WTO_R1,
+			      regs->len - B3_RI_WTO_R1);
+	}
 }
=20
 /* Wake on Lan only supported on Yukon chips with rev 1 or above */
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet=
/mellanox/mlx4/fw.c
index 2a462664ed41..a4fa574ceb1c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1542,9 +1542,10 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	__be32 *outbox;
+	u64 qword_field;
 	u32 dword_field;
-	int err;
 	u8 byte_field;
+	int err;
=20
 #define QUERY_HCA_GLOBAL_CAPS_OFFSET	0x04
 #define QUERY_HCA_CORE_CLOCK_OFFSET	0x0c
@@ -1566,18 +1567,30 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
=20
 	/* QPC/EEC/CQC/EQC/RDMARC attributes */
=20
-	MLX4_GET(param->qpc_base,      outbox, INIT_HCA_QPC_BASE_OFFSET);
-	MLX4_GET(param->log_num_qps,   outbox, INIT_HCA_LOG_QP_OFFSET);
-	MLX4_GET(param->srqc_base,     outbox, INIT_HCA_SRQC_BASE_OFFSET);
-	MLX4_GET(param->log_num_srqs,  outbox, INIT_HCA_LOG_SRQ_OFFSET);
-	MLX4_GET(param->cqc_base,      outbox, INIT_HCA_CQC_BASE_OFFSET);
-	MLX4_GET(param->log_num_cqs,   outbox, INIT_HCA_LOG_CQ_OFFSET);
-	MLX4_GET(param->altc_base,     outbox, INIT_HCA_ALTC_BASE_OFFSET);
-	MLX4_GET(param->auxc_base,     outbox, INIT_HCA_AUXC_BASE_OFFSET);
-	MLX4_GET(param->eqc_base,      outbox, INIT_HCA_EQC_BASE_OFFSET);
-	MLX4_GET(param->log_num_eqs,   outbox, INIT_HCA_LOG_EQ_OFFSET);
-	MLX4_GET(param->rdmarc_base,   outbox, INIT_HCA_RDMARC_BASE_OFFSET);
-	MLX4_GET(param->log_rd_per_qp, outbox, INIT_HCA_LOG_RD_OFFSET);
+	MLX4_GET(qword_field, outbox, INIT_HCA_QPC_BASE_OFFSET);
+	param->qpc_base =3D qword_field & ~((u64)0x1f);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_QP_OFFSET);
+	param->log_num_qps =3D byte_field & 0x1f;
+	MLX4_GET(qword_field, outbox, INIT_HCA_SRQC_BASE_OFFSET);
+	param->srqc_base =3D qword_field & ~((u64)0x1f);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_SRQ_OFFSET);
+	param->log_num_srqs =3D byte_field & 0x1f;
+	MLX4_GET(qword_field, outbox, INIT_HCA_CQC_BASE_OFFSET);
+	param->cqc_base =3D qword_field & ~((u64)0x1f);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_CQ_OFFSET);
+	param->log_num_cqs =3D byte_field & 0x1f;
+	MLX4_GET(qword_field, outbox, INIT_HCA_ALTC_BASE_OFFSET);
+	param->altc_base =3D qword_field;
+	MLX4_GET(qword_field, outbox, INIT_HCA_AUXC_BASE_OFFSET);
+	param->auxc_base =3D qword_field;
+	MLX4_GET(qword_field, outbox, INIT_HCA_EQC_BASE_OFFSET);
+	param->eqc_base =3D qword_field & ~((u64)0x1f);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_EQ_OFFSET);
+	param->log_num_eqs =3D byte_field & 0x1f;
+	MLX4_GET(qword_field, outbox, INIT_HCA_RDMARC_BASE_OFFSET);
+	param->rdmarc_base =3D qword_field & ~((u64)0x1f);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_RD_OFFSET);
+	param->log_rd_per_qp =3D byte_field & 0x7;
=20
 	MLX4_GET(dword_field, outbox, INIT_HCA_FLAGS_OFFSET);
 	if (dword_field & (1 << INIT_HCA_DEVICE_MANAGED_FLOW_STEERING_EN)) {
@@ -1592,18 +1605,18 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 	/* steering attributes */
 	if (param->steering_mode =3D=3D MLX4_STEERING_MODE_DEVICE_MANAGED) {
 		MLX4_GET(param->mc_base, outbox, INIT_HCA_FS_BASE_OFFSET);
-		MLX4_GET(param->log_mc_entry_sz, outbox,
-			 INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET);
-		MLX4_GET(param->log_mc_table_sz, outbox,
-			 INIT_HCA_FS_LOG_TABLE_SZ_OFFSET);
+		MLX4_GET(byte_field, outbox, INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET);
+		param->log_mc_entry_sz =3D byte_field & 0x1f;
+		MLX4_GET(byte_field, outbox, INIT_HCA_FS_LOG_TABLE_SZ_OFFSET);
+		param->log_mc_table_sz =3D byte_field & 0x1f;
 	} else {
 		MLX4_GET(param->mc_base, outbox, INIT_HCA_MC_BASE_OFFSET);
-		MLX4_GET(param->log_mc_entry_sz, outbox,
-			 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET);
-		MLX4_GET(param->log_mc_hash_sz,  outbox,
-			 INIT_HCA_LOG_MC_HASH_SZ_OFFSET);
-		MLX4_GET(param->log_mc_table_sz, outbox,
-			 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET);
+		MLX4_GET(byte_field, outbox, INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET);
+		param->log_mc_entry_sz =3D byte_field & 0x1f;
+		MLX4_GET(byte_field,  outbox, INIT_HCA_LOG_MC_HASH_SZ_OFFSET);
+		param->log_mc_hash_sz =3D byte_field & 0x1f;
+		MLX4_GET(byte_field, outbox, INIT_HCA_LOG_MC_TABLE_SZ_OFFSET);
+		param->log_mc_table_sz =3D byte_field & 0x1f;
 	}
=20
 	/* CX3 is capable of extending CQEs/EQEs from 32 to 64 bytes */
@@ -1616,15 +1629,18 @@ int mlx4_QUERY_HCA(struct mlx4_dev *dev,
 	/* TPT attributes */
=20
 	MLX4_GET(param->dmpt_base,  outbox, INIT_HCA_DMPT_BASE_OFFSET);
-	MLX4_GET(param->mw_enabled, outbox, INIT_HCA_TPT_MW_OFFSET);
-	MLX4_GET(param->log_mpt_sz, outbox, INIT_HCA_LOG_MPT_SZ_OFFSET);
+	MLX4_GET(byte_field, outbox, INIT_HCA_TPT_MW_OFFSET);
+	param->mw_enabled =3D byte_field >> 7;
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_MPT_SZ_OFFSET);
+	param->log_mpt_sz =3D byte_field & 0x3f;
 	MLX4_GET(param->mtt_base,   outbox, INIT_HCA_MTT_BASE_OFFSET);
 	MLX4_GET(param->cmpt_base,  outbox, INIT_HCA_CMPT_BASE_OFFSET);
=20
 	/* UAR attributes */
=20
 	MLX4_GET(param->uar_page_sz, outbox, INIT_HCA_UAR_PAGE_SZ_OFFSET);
-	MLX4_GET(param->log_uar_sz, outbox, INIT_HCA_LOG_UAR_SZ_OFFSET);
+	MLX4_GET(byte_field, outbox, INIT_HCA_LOG_UAR_SZ_OFFSET);
+	param->log_uar_sz =3D byte_field & 0xf;
=20
 out:
 	mlx4_free_cmd_mailbox(dev, mailbox);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers=
/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index aa0480402c97..1aa16b5f816b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -616,25 +616,27 @@ static int stmmac_ethtool_op_set_eee(struct net_devic=
e *dev,
 				     struct ethtool_eee *edata)
 {
 	struct stmmac_priv *priv =3D netdev_priv(dev);
+	int ret;
=20
-	priv->eee_enabled =3D edata->eee_enabled;
-
-	if (!priv->eee_enabled)
+	if (!edata->eee_enabled) {
 		stmmac_disable_eee_mode(priv);
-	else {
+	} else {
 		/* We are asking for enabling the EEE but it is safe
 		 * to verify all by invoking the eee_init function.
 		 * In case of failure it will return an error.
 		 */
-		priv->eee_enabled =3D stmmac_eee_init(priv);
-		if (!priv->eee_enabled)
+		edata->eee_enabled =3D stmmac_eee_init(priv);
+		if (!edata->eee_enabled)
 			return -EOPNOTSUPP;
-
-		/* Do not change tx_lpi_timer in case of failure */
-		priv->tx_lpi_timer =3D edata->tx_lpi_timer;
 	}
=20
-	return phy_ethtool_set_eee(priv->phydev, edata);
+	ret =3D phy_ethtool_set_eee(priv->phydev, edata);
+	if (ret)
+		return ret;
+
+	priv->eee_enabled =3D edata->eee_enabled;
+	priv->tx_lpi_timer =3D edata->tx_lpi_timer;
+	return 0;
 }
=20
 static u32 stmmac_usec2riwt(u32 usec, struct stmmac_priv *priv)
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 4eaadcfcb0fe..2f5520984bfd 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -261,7 +261,6 @@ int mdiobus_register(struct mii_bus *bus)
 	err =3D device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
-		put_device(&bus->dev);
 		return -EINVAL;
 	}
=20
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index bc7c7d2f75f2..618e312b846a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -26,6 +26,7 @@
 #include <linux/phy.h>
 #include <linux/micrel_phy.h>
 #include <linux/of.h>
+#include <linux/mdio.h>
=20
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -211,6 +212,17 @@ static int ks8051_config_init(struct phy_device *phyde=
v)
 	return rc < 0 ? rc : 0;
 }
=20
+static int ksz8061_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	ret =3D phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_DEVID1, 0xB61A);
+	if (ret)
+		return ret;
+
+	return kszphy_config_init(phydev);
+}
+
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
 				       struct device_node *of_node, u16 reg,
 				       char *field1, char *field2,
@@ -415,6 +427,30 @@ static int ksz8873mll_read_status(struct phy_device *p=
hydev)
 	return 0;
 }
=20
+static int ksz9031_read_status(struct phy_device *phydev)
+{
+	int err;
+	int regval;
+
+	err =3D genphy_read_status(phydev);
+	if (err)
+		return err;
+
+	/* Make sure the PHY is not broken. Read idle error count,
+	 * and reset the PHY if it is maxed out.
+	 */
+	regval =3D phy_read(phydev, MII_STAT1000);
+	if ((regval & 0xFF) =3D=3D 0xFF) {
+		phy_init_hw(phydev);
+		phydev->link =3D 0;
+		if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
+			phydev->drv->config_intr(phydev);
+		return genphy_config_aneg(phydev);
+	}
+
+	return 0;
+}
+
 static int ksz8873mll_config_aneg(struct phy_device *phydev)
 {
 	return 0;
@@ -544,7 +580,7 @@ static struct phy_driver ksphy_driver[] =3D {
 	.phy_id_mask	=3D 0x00fffff0,
 	.features	=3D (PHY_BASIC_FEATURES | SUPPORTED_Pause),
 	.flags		=3D PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
-	.config_init	=3D kszphy_config_init,
+	.config_init	=3D ksz8061_config_init,
 	.config_aneg	=3D genphy_config_aneg,
 	.read_status	=3D genphy_read_status,
 	.ack_interrupt	=3D kszphy_ack_interrupt,
@@ -575,7 +611,8 @@ static struct phy_driver ksphy_driver[] =3D {
 	.flags		=3D PHY_HAS_MAGICANEG | PHY_HAS_INTERRUPT,
 	.config_init	=3D ksz9031_config_init,
 	.config_aneg	=3D genphy_config_aneg,
-	.read_status	=3D genphy_read_status,
+	.soft_reset	=3D genphy_soft_reset,
+	.read_status	=3D ksz9031_read_status,
 	.ack_interrupt	=3D kszphy_ack_interrupt,
 	.config_intr	=3D ksz9021_config_intr,
 	.suspend	=3D genphy_suspend,
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 6e98f32fdf5e..d6511041c766 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -253,17 +253,6 @@ static void __team_option_inst_mark_removed_port(struc=
t team *team,
 	}
 }
=20
-static bool __team_option_inst_tmp_find(const struct list_head *opts,
-					const struct team_option_inst *needle)
-{
-	struct team_option_inst *opt_inst;
-
-	list_for_each_entry(opt_inst, opts, tmp_list)
-		if (opt_inst =3D=3D needle)
-			return true;
-	return false;
-}
-
 static int __team_options_register(struct team *team,
 				   const struct team_option *option,
 				   size_t option_count)
@@ -2420,7 +2409,6 @@ static int team_nl_cmd_options_set(struct sk_buff *sk=
b, struct genl_info *info)
 	int err =3D 0;
 	int i;
 	struct nlattr *nl_option;
-	LIST_HEAD(opt_inst_list);
=20
 	team =3D team_nl_team_get(info);
 	if (!team)
@@ -2436,6 +2424,7 @@ static int team_nl_cmd_options_set(struct sk_buff *sk=
b, struct genl_info *info)
 		struct nlattr *opt_attrs[TEAM_ATTR_OPTION_MAX + 1];
 		struct nlattr *attr;
 		struct nlattr *attr_data;
+		LIST_HEAD(opt_inst_list);
 		enum team_option_type opt_type;
 		int opt_port_ifindex =3D 0; /* !=3D 0 for per-port options */
 		u32 opt_array_index =3D 0;
@@ -2539,23 +2528,17 @@ static int team_nl_cmd_options_set(struct sk_buff *=
skb, struct genl_info *info)
 			if (err)
 				goto team_put;
 			opt_inst->changed =3D true;
-
-			/* dumb/evil user-space can send us duplicate opt,
-			 * keep only the last one
-			 */
-			if (__team_option_inst_tmp_find(&opt_inst_list,
-							opt_inst))
-				continue;
-
 			list_add(&opt_inst->tmp_list, &opt_inst_list);
 		}
 		if (!opt_found) {
 			err =3D -ENOENT;
 			goto team_put;
 		}
-	}
=20
-	err =3D team_nl_send_event_options_get(team, &opt_inst_list);
+		err =3D team_nl_send_event_options_get(team, &opt_inst_list);
+		if (err)
+			break;
+	}
=20
 team_put:
 	team_nl_team_put(team);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 941d73b9baff..31abf2e7b199 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1772,7 +1772,7 @@ static void vxlan_encap_bypass(struct sk_buff *skb, s=
truct vxlan_dev *src_vxlan,
 	struct pcpu_sw_netstats *tx_stats, *rx_stats;
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip =3D &dst_vxlan->default_dst.remote_ip;
-	struct net_device *dev =3D skb->dev;
+	struct net_device *dev;
 	int len =3D skb->len;
=20
 	tx_stats =3D this_cpu_ptr(src_vxlan->dev->tstats);
@@ -1792,8 +1792,15 @@ static void vxlan_encap_bypass(struct sk_buff *skb, =
struct vxlan_dev *src_vxlan,
 #endif
 	}
=20
+	rcu_read_lock();
+	dev =3D skb->dev;
+	if (unlikely(!(dev->flags & IFF_UP))) {
+		kfree_skb(skb);
+		goto drop;
+	}
+
 	if (dst_vxlan->flags & VXLAN_F_LEARN)
-		vxlan_snoop(skb->dev, &loopback, eth_hdr(skb)->h_source);
+		vxlan_snoop(dev, &loopback, eth_hdr(skb)->h_source);
=20
 	u64_stats_update_begin(&tx_stats->syncp);
 	tx_stats->tx_packets++;
@@ -1806,8 +1813,10 @@ static void vxlan_encap_bypass(struct sk_buff *skb, =
struct vxlan_dev *src_vxlan,
 		rx_stats->rx_bytes +=3D len;
 		u64_stats_update_end(&rx_stats->syncp);
 	} else {
+drop:
 		dev->stats.rx_dropped++;
 	}
+	rcu_read_unlock();
 }
=20
 static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/w=
ireless/brcm80211/brcmfmac/bcdc.c
index c229210d50ba..234b72894bc2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -272,10 +272,11 @@ brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int =
ifidx, u8 offset,
 }
=20
 static int
-brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-			 struct sk_buff *pktbuf)
+brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
+			 struct sk_buff *pktbuf, struct brcmf_if **ifp)
 {
 	struct brcmf_proto_bcdc_header *h;
+	struct brcmf_if *tmp_if;
=20
 	brcmf_dbg(BCDC, "Enter\n");
=20
@@ -289,30 +290,21 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool=
 do_fws, u8 *ifidx,
 	trace_brcmf_bcdchdr(pktbuf->data);
 	h =3D (struct brcmf_proto_bcdc_header *)(pktbuf->data);
=20
-	*ifidx =3D BCDC_GET_IF_IDX(h);
-	if (*ifidx >=3D BRCMF_MAX_IFS) {
-		brcmf_err("rx data ifnum out of range (%d)\n", *ifidx);
+	tmp_if =3D brcmf_get_ifp(drvr, BCDC_GET_IF_IDX(h));
+	if (!tmp_if) {
+		brcmf_dbg(INFO, "no matching ifp found\n");
 		return -EBADE;
 	}
-	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
-	 * events this is easy because it contains the bssidx which maps
-	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
-	 * bssidx 1 is used for p2p0 and no data can be received or
-	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
-	 */
-	if (*ifidx)
-		(*ifidx)++;
-
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=3D
 	    BCDC_PROTO_VER) {
 		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
-			  brcmf_ifname(drvr, *ifidx), h->flags);
+			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
 		return -EBADE;
 	}
=20
 	if (h->flags & BCDC_FLAG_SUM_GOOD) {
 		brcmf_dbg(BCDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
-			  brcmf_ifname(drvr, *ifidx), h->flags);
+			  brcmf_ifname(drvr, tmp_if->ifidx), h->flags);
 		pktbuf->ip_summed =3D CHECKSUM_UNNECESSARY;
 	}
=20
@@ -320,12 +312,15 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool=
 do_fws, u8 *ifidx,
=20
 	skb_pull(pktbuf, BCDC_HEADER_LEN);
 	if (do_fws)
-		brcmf_fws_hdrpull(drvr, *ifidx, h->data_offset << 2, pktbuf);
+		brcmf_fws_hdrpull(drvr, tmp_if->ifidx, h->data_offset << 2,
+				  pktbuf);
 	else
 		skb_pull(pktbuf, h->data_offset << 2);
=20
 	if (pktbuf->len =3D=3D 0)
 		return -ENODATA;
+
+	*ifp =3D tmp_if;
 	return 0;
 }
=20
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wi=
reless/brcm80211/brcmfmac/dhd.h
index 16f9ab2568a8..4f26e09e8fc7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -178,7 +178,7 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev=
);
=20
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
-
+struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifid=
x,
 			      char *name, u8 *mac_addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/ne=
t/wireless/brcm80211/brcmfmac/dhd_bus.h
index 7735328fff21..1436ae2249d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -168,7 +168,9 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *=
q, struct sk_buff *pkt,
 		      int prec);
=20
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_e=
vent);
+/* Receive async event packet from firmware. Callee disposes of rxp. */
+void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
=20
 /* Indication from bus module regarding presence/insertion of dongle. */
 int brcmf_attach(struct device *dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/=
net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 09dd8c13d844..6bc5fcc2508e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -81,6 +81,25 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 	return "<if_none>";
 }
=20
+struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
+{
+	if (ifidx < 0 || ifidx >=3D BRCMF_MAX_IFS) {
+		brcmf_err("ifidx %d out of range\n", ifidx);
+		return NULL;
+	}
+
+	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
+	 * events this is easy because it contains the bssidx which maps
+	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
+	 * bssidx 1 is used for p2p0 and no data can be received or
+	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
+	 */
+	if (ifidx)
+		ifidx++;
+
+	return drvr->iflist[ifidx];
+}
+
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
@@ -289,15 +308,9 @@ void brcmf_txflowblock(struct device *dev, bool state)
=20
 static void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	skb->dev =3D ifp->ndev;
-	skb->protocol =3D eth_type_trans(skb, skb->dev);
-
 	if (skb->pkt_type =3D=3D PACKET_MULTICAST)
 		ifp->stats.multicast++;
=20
-	/* Process special event packets */
-	brcmf_fweh_process_skb(ifp->drvr, skb);
-
 	if (!(ifp->ndev->flags & IFF_UP)) {
 		brcmu_pkt_buf_free_skb(skb);
 		return;
@@ -512,33 +525,64 @@ static void brcmf_rxreorder_process_info(struct brcmf=
_if *ifp, u8 *reorder_data,
 	}
 }
=20
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_e=
vent)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if =3D dev_get_drvdata(dev);
 	struct brcmf_pub *drvr =3D bus_if->drvr;
 	struct brcmf_skb_reorder_data *rd;
-	u8 ifidx;
 	int ret;
=20
 	brcmf_dbg(DATA, "Enter: %s: rxp=3D%p\n", dev_name(dev), skb);
=20
 	/* process and remove protocol-specific header */
-	ret =3D brcmf_proto_hdrpull(drvr, true, &ifidx, skb);
-	ifp =3D drvr->iflist[ifidx];
+	ret =3D brcmf_proto_hdrpull(drvr, true, skb, &ifp);
=20
 	if (ret || !ifp || !ifp->ndev) {
-		if ((ret !=3D -ENODATA) && ifp)
+		if (ret !=3D -ENODATA && ifp)
 			ifp->stats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
=20
+	skb->protocol =3D eth_type_trans(skb, ifp->ndev);
+
 	rd =3D (struct brcmf_skb_reorder_data *)skb->cb;
-	if (rd->reorder)
+	if (rd->reorder) {
 		brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
-	else
+	} else {
+		/* Process special event packets */
+		if (handle_event)
+			brcmf_fweh_process_skb(ifp->drvr, skb,
+					       BCMILCP_SUBTYPE_VENDOR_LONG);
+
 		brcmf_netif_rx(ifp, skb);
+	}
+}
+
+void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
+{
+	struct brcmf_if *ifp;
+	struct brcmf_bus *bus_if =3D dev_get_drvdata(dev);
+	struct brcmf_pub *drvr =3D bus_if->drvr;
+	int ret;
+
+	brcmf_dbg(EVENT, "Enter: %s: rxp=3D%p\n", dev_name(dev), skb);
+
+	/* process and remove protocol-specific header */
+	ret =3D brcmf_proto_hdrpull(drvr, true, skb, &ifp);
+
+	if (ret || !ifp || !ifp->ndev) {
+		if (ret !=3D -ENODATA && ifp)
+			ifp->stats.rx_errors++;
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	skb->protocol =3D eth_type_trans(skb, ifp->ndev);
+
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
+	brcmu_pkt_buf_free_skb(skb);
 }
=20
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifid=
x,
@@ -571,17 +615,17 @@ void brcmf_txcomplete(struct device *dev, struct sk_b=
uff *txp, bool success)
 {
 	struct brcmf_bus *bus_if =3D dev_get_drvdata(dev);
 	struct brcmf_pub *drvr =3D bus_if->drvr;
-	u8 ifidx;
+	struct brcmf_if *ifp;
=20
 	/* await txstatus signal for firmware if active */
 	if (brcmf_fws_fc_active(drvr->fws)) {
 		if (!success)
 			brcmf_fws_bustxfail(drvr->fws, txp);
 	} else {
-		if (brcmf_proto_hdrpull(drvr, false, &ifidx, txp))
+		if (brcmf_proto_hdrpull(drvr, false, txp, &ifp))
 			brcmu_pkt_buf_free_skb(txp);
 		else
-			brcmf_txfinalize(drvr, txp, ifidx, success);
+			brcmf_txfinalize(drvr, txp, ifp->ifidx, success);
 	}
 }
=20
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/n=
et/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 8fa0dbbbda72..f93bdba6901c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1339,6 +1339,17 @@ static inline u8 brcmf_sdio_getdatoffset(u8 *swheade=
r)
 	return (u8)((hdrvalue & SDPCM_DOFFSET_MASK) >> SDPCM_DOFFSET_SHIFT);
 }
=20
+static inline bool brcmf_sdio_fromevntchan(u8 *swheader)
+{
+	u32 hdrvalue;
+	u8 ret;
+
+	hdrvalue =3D *(u32 *)swheader;
+	ret =3D (u8)((hdrvalue & SDPCM_CHANNEL_MASK) >> SDPCM_CHANNEL_SHIFT);
+
+	return (ret =3D=3D SDPCM_EVENT_CHANNEL);
+}
+
 static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 			      struct brcmf_sdio_hdrinfo *rd,
 			      enum brcmf_sdio_frmtype type)
@@ -1699,7 +1710,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, =
u8 rxseq)
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
-			brcmf_rx_frame(bus->sdiodev->dev, pfirst);
+			if (brcmf_sdio_fromevntchan(&dptr[SDPCM_HWHDR_LEN]))
+				brcmf_rx_event(bus->sdiodev->dev, pfirst);
+			else
+				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
+					       false);
 			bus->sdcnt.rxglompkts++;
 		}
=20
@@ -2026,18 +2041,19 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio=
 *bus, uint maxframes)
 		__skb_trim(pkt, rd->len);
 		skb_pull(pkt, rd->dat_offset);
=20
+		if (pkt->len =3D=3D 0)
+			brcmu_pkt_buf_free_skb(pkt);
+		else if (rd->channel =3D=3D SDPCM_EVENT_CHANNEL)
+			brcmf_rx_event(bus->sdiodev->dev, pkt);
+		else
+			brcmf_rx_frame(bus->sdiodev->dev, pkt,
+				       false);
+
 		/* prepare the descriptor for the next read */
 		rd->len =3D rd->len_nxtfrm << 4;
 		rd->len_nxtfrm =3D 0;
 		/* treat all packet as event if we don't know */
 		rd->channel =3D SDPCM_EVENT_CHANNEL;
-
-		if (pkt->len =3D=3D 0) {
-			brcmu_pkt_buf_free_skb(pkt);
-			continue;
-		}
-
-		brcmf_rx_frame(bus->sdiodev->dev, pkt);
 	}
=20
 	rxcount =3D maxframes - rxleft;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/w=
ireless/brcm80211/brcmfmac/fweh.h
index 9b5416193bf6..8b0afca0c656 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -174,7 +174,7 @@ enum brcmf_fweh_event_code {
  */
 #define BRCM_OUI				"\x00\x10\x18"
 #define BCMILCP_BCM_SUBTYPE_EVENT		1
-
+#define BCMILCP_SUBTYPE_VENDOR_LONG		32769
=20
 /**
  * struct brcm_ethhdr - broadcom specific ether header.
@@ -292,10 +292,10 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 			      u32 packet_len);
=20
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb, u16 stype)
 {
 	struct brcmf_event *event_packet;
-	u16 usr_stype;
+	u16 subtype, usr_stype;
=20
 	/* only process events when protocol matches */
 	if (skb->protocol !=3D cpu_to_be16(ETH_P_LINK_CTL))
@@ -304,8 +304,16 @@ static inline void brcmf_fweh_process_skb(struct brcmf=
_pub *drvr,
 	if ((skb->len + ETH_HLEN) < sizeof(*event_packet))
 		return;
=20
-	/* check for BRCM oui match */
 	event_packet =3D (struct brcmf_event *)skb_mac_header(skb);
+
+	/* check subtype if needed */
+	if (unlikely(stype)) {
+		subtype =3D get_unaligned_be16(&event_packet->hdr.subtype);
+		if (subtype !=3D stype)
+			return;
+	}
+
+	/* check for BRCM oui match */
 	if (memcmp(BRCM_OUI, &event_packet->hdr.oui[0],
 		   sizeof(event_packet->hdr.oui)))
 		return;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/n=
et/wireless/brcm80211/brcmfmac/fwsignal.c
index c9b0586d7b58..a6a958258b75 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1420,7 +1420,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 =
flags, u32 hslot,
 	struct sk_buff *skb;
 	struct brcmf_skbuff_cb *skcb;
 	struct brcmf_fws_mac_descriptor *entry =3D NULL;
-	u8 ifidx;
+	struct brcmf_if *ifp;
=20
 	brcmf_dbg(DATA, "flags %d\n", flags);
=20
@@ -1469,15 +1469,16 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u=
8 flags, u32 hslot,
 	}
 	brcmf_fws_macdesc_return_req_credit(skb);
=20
-	if (brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb)) {
+	ret =3D brcmf_proto_hdrpull(fws->drvr, false, skb, &ifp);
+	if (ret) {
 		brcmu_pkt_buf_free_skb(skb);
 		return -EINVAL;
 	}
 	if (!remove_from_hanger)
-		ret =3D brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifidx,
+		ret =3D brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifp->ifidx,
 						    genbit, seq);
 	if (remove_from_hanger || ret)
-		brcmf_txfinalize(fws->drvr, skb, ifidx, true);
+		brcmf_txfinalize(fws->drvr, skb, ifp->ifidx, true);
=20
 	return 0;
 }
@@ -1820,7 +1821,7 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info=
 *fws, int fifo,
 		entry->transit_count--;
 		if (entry->suppressed)
 			entry->suppr_transit_count--;
-		brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
+		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
=20
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/=
wireless/brcm80211/brcmfmac/proto.h
index 482fb0ba4a30..882bd87cf79f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -17,8 +17,8 @@
 #define BRCMFMAC_PROTO_H
=20
 struct brcmf_proto {
-	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-		       struct sk_buff *skb);
+	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
+		       struct sk_buff *skb, struct brcmf_if **ifp);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
 			  void *buf, uint len);
 	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
@@ -33,9 +33,19 @@ int brcmf_proto_attach(struct brcmf_pub *drvr);
 void brcmf_proto_detach(struct brcmf_pub *drvr);
=20
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
-				      u8 *ifidx, struct sk_buff *skb)
+				      struct sk_buff *skb,
+				      struct brcmf_if **ifp)
 {
-	return drvr->proto->hdrpull(drvr, do_fws, ifidx, skb);
+	struct brcmf_if *tmp =3D NULL;
+
+	/* assure protocol is always called with
+	 * non-null initialized pointer.
+	 */
+	if (ifp)
+		*ifp =3D NULL;
+	else
+		ifp =3D &tmp;
+	return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
 }
 static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 					 uint cmd, void *buf, uint len)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wi=
reless/brcm80211/brcmfmac/usb.c
index d06fcb05adf2..f245a39f612c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -441,7 +441,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
=20
 	if (devinfo->bus_pub.state =3D=3D BRCMFMAC_USB_STATE_UP) {
 		skb_put(skb, urb->actual_length);
-		brcmf_rx_frame(devinfo->dev, skb);
+		brcmf_rx_frame(devinfo->dev, skb, true);
 		brcmf_usb_rx_refill(devinfo, req);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/driver=
s/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5898cf0700f5..e6e2c5afec06 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3082,6 +3082,8 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
=20
 			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
 				  netinfo->SSID, netinfo->channel);
+			if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
+				netinfo->SSID_len =3D IEEE80211_MAX_SSID_LEN;
 			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
 			ssid[i].ssid_len =3D netinfo->SSID_len;
 			request->n_ssids++;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 2e8e0755070b..f5ceba59fb27 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3945,6 +3945,14 @@ static int dasd_symm_io(struct dasd_device *device, =
void __user *argp)
 		usrparm.psf_data &=3D 0x7fffffffULL;
 		usrparm.rssd_result &=3D 0x7fffffffULL;
 	}
+	/* at least 2 bytes are accessed and should be allocated */
+	if (usrparm.psf_data_len < 2) {
+		DBF_DEV_EVENT(DBF_WARNING, device,
+			      "Symmetrix ioctl invalid data length %d",
+			      usrparm.psf_data_len);
+		rc =3D -EINVAL;
+		goto out;
+	}
 	/* alloc I/O data area */
 	psf_data =3D kzalloc(usrparm.psf_data_len, GFP_KERNEL | GFP_DMA);
 	rssd_result =3D kzalloc(usrparm.rssd_result_len, GFP_KERNEL | GFP_DMA);
diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_confi=
g.c
index 944156207477..dcb949dcfa66 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -43,7 +43,9 @@ static void sclp_cpu_capability_notify(struct work_struct=
 *work)
=20
 static void __ref sclp_cpu_change_notify(struct work_struct *work)
 {
+	lock_device_hotplug();
 	smp_rescan_cpus();
+	unlock_device_hotplug();
 }
=20
 static void sclp_conf_receiver_fn(struct evbuf_header *evbuf)
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 3afbe838ffac..7c7a9303585c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/seq_file.h>
 #include <linux/ethtool.h>
+#include <linux/workqueue.h>
=20
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
@@ -792,6 +793,7 @@ struct qeth_card {
 	struct qeth_seqno seqno;
 	struct qeth_card_options options;
=20
+	struct workqueue_struct *event_wq;
 	wait_queue_head_t wait_q;
 	spinlock_t vlanlock;
 	spinlock_t mclock;
@@ -902,7 +904,6 @@ extern const struct attribute_group *qeth_osn_attr_grou=
ps[];
 extern const struct attribute_group qeth_device_attr_group;
 extern const struct attribute_group qeth_device_blkt_group;
 extern const struct device_type qeth_generic_devtype;
-extern struct workqueue_struct *qeth_wq;
=20
 const char *qeth_get_cardname_short(struct qeth_card *);
 int qeth_realloc_buffer_pool(struct qeth_card *, int);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core=
_main.c
index 40fec0c463ea..6dcac1be6025 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -67,8 +67,7 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *queu=
e,
 static void qeth_release_skbs(struct qeth_qdio_out_buffer *buf);
 static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *, int);
=20
-struct workqueue_struct *qeth_wq;
-EXPORT_SYMBOL_GPL(qeth_wq);
+static struct workqueue_struct *qeth_wq;
=20
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -1288,6 +1287,15 @@ static void qeth_free_buffer_pool(struct qeth_card *=
card)
 	}
 }
=20
+static void qeth_free_output_queue(struct qeth_qdio_out_q *q)
+{
+	if (!q)
+		return;
+
+	qeth_clear_outq_buffers(q, 1);
+	kfree(q);
+}
+
 static void qeth_free_qdio_buffers(struct qeth_card *card)
 {
 	int i, j;
@@ -1308,10 +1316,8 @@ static void qeth_free_qdio_buffers(struct qeth_card =
*card)
 	qeth_free_buffer_pool(card);
 	/* free outbound qdio_qs */
 	if (card->qdio.out_qs) {
-		for (i =3D 0; i < card->qdio.no_out_queues; ++i) {
-			qeth_clear_outq_buffers(card->qdio.out_qs[i], 1);
-			kfree(card->qdio.out_qs[i]);
-		}
+		for (i =3D 0; i < card->qdio.no_out_queues; i++)
+			qeth_free_output_queue(card->qdio.out_qs[i]);
 		kfree(card->qdio.out_qs);
 		card->qdio.out_qs =3D NULL;
 	}
@@ -1490,7 +1496,7 @@ static void qeth_core_sl_print(struct seq_file *m, st=
ruct service_level *slr)
 			CARD_BUS_ID(card), card->info.mcl_level);
 }
=20
-static struct qeth_card *qeth_alloc_card(void)
+static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card;
=20
@@ -1504,6 +1510,10 @@ static struct qeth_card *qeth_alloc_card(void)
 		QETH_DBF_TEXT(SETUP, 0, "iptbdnom");
 		goto out_card;
 	}
+
+	card->event_wq =3D alloc_ordered_workqueue("%s", 0, dev_name(&gdev->dev));
+	if (!card->event_wq)
+		goto out_wq;
 	if (qeth_setup_channel(&card->read))
 		goto out_ip;
 	if (qeth_setup_channel(&card->write))
@@ -1516,6 +1526,8 @@ static struct qeth_card *qeth_alloc_card(void)
 out_channel:
 	qeth_clean_channel(&card->read);
 out_ip:
+	destroy_workqueue(card->event_wq);
+out_wq:
 	kfree(card->ip_tbd_list);
 out_card:
 	kfree(card);
@@ -2483,10 +2495,8 @@ static int qeth_alloc_qdio_buffers(struct qeth_card =
*card)
 		card->qdio.out_qs[i]->bufs[j] =3D NULL;
 	}
 out_freeoutq:
-	while (i > 0) {
-		kfree(card->qdio.out_qs[--i]);
-		qeth_clear_outq_buffers(card->qdio.out_qs[i], 1);
-	}
+	while (i > 0)
+		qeth_free_output_queue(card->qdio.out_qs[--i]);
 	kfree(card->qdio.out_qs);
 	card->qdio.out_qs =3D NULL;
 out_freepool:
@@ -4864,6 +4874,7 @@ static void qeth_core_free_card(struct qeth_card *car=
d)
 	QETH_DBF_HEX(SETUP, 2, &card, sizeof(void *));
 	qeth_clean_channel(&card->read);
 	qeth_clean_channel(&card->write);
+	destroy_workqueue(card->event_wq);
 	kfree(card->ip_tbd_list);
 	qeth_free_qdio_buffers(card);
 	unregister_service_level(&card->qeth_service_level);
@@ -5327,7 +5338,7 @@ static int qeth_core_probe_device(struct ccwgroup_dev=
ice *gdev)
=20
 	QETH_DBF_TEXT_(SETUP, 2, "%s", dev_name(&gdev->dev));
=20
-	card =3D qeth_alloc_card();
+	card =3D qeth_alloc_card(gdev);
 	if (!card) {
 		QETH_DBF_TEXT_(SETUP, 2, "1err%d", -ENOMEM);
 		rc =3D -ENOMEM;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_mai=
n.c
index ac58a8132402..7d589cebfc7f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -407,6 +407,8 @@ static int qeth_l2_stop_card(struct qeth_card *card, in=
t recovery_mode)
 		qeth_clear_cmd_buffers(&card->read);
 		qeth_clear_cmd_buffers(&card->write);
 	}
+
+	flush_workqueue(card->event_wq);
 	return rc;
 }
=20
@@ -924,6 +926,7 @@ static void qeth_l2_remove_device(struct ccwgroup_devic=
e *cgdev)
 	if (cgdev->state =3D=3D CCWGROUP_ONLINE)
 		qeth_l2_set_offline(cgdev);
=20
+	cancel_work_sync(&card->close_dev_work);
 	if (card->dev) {
 		unregister_netdev(card->dev);
 		free_netdev(card->dev);
@@ -1541,7 +1544,7 @@ static void qeth_bridge_state_change(struct qeth_card=
 *card,
 	data->card =3D card;
 	memcpy(&data->qports, qports,
 			sizeof(struct qeth_sbp_state_change) + extrasize);
-	queue_work(qeth_wq, &data->worker);
+	queue_work(card->event_wq, &data->worker);
 }
=20
 struct qeth_bridge_host_data {
@@ -1613,7 +1616,7 @@ static void qeth_bridge_host_event(struct qeth_card *=
card,
 	data->card =3D card;
 	memcpy(&data->hostevs, hostevs,
 			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
-	queue_work(qeth_wq, &data->worker);
+	queue_work(card->event_wq, &data->worker);
 }
=20
 /* SETBRIDGEPORT support; sending commands */
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_mai=
n.c
index 4276369d3da1..5afe2e7dd3d7 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2180,6 +2180,8 @@ static int qeth_l3_stop_card(struct qeth_card *card, =
int recovery_mode)
 		qeth_clear_cmd_buffers(&card->read);
 		qeth_clear_cmd_buffers(&card->write);
 	}
+
+	flush_workqueue(card->event_wq);
 	return rc;
 }
=20
@@ -3342,6 +3344,7 @@ static void qeth_l3_remove_device(struct ccwgroup_dev=
ice *cgdev)
 	if (cgdev->state =3D=3D CCWGROUP_ONLINE)
 		qeth_l3_set_offline(cgdev);
=20
+	cancel_work_sync(&card->close_dev_work);
 	if (card->dev) {
 		unregister_netdev(card->dev);
 		free_netdev(card->dev);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_i=
o.c
index 7bc47fc7c686..0694057e8529 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -271,6 +271,7 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2=
fc_hba *hba)
 		return NULL;
 	}
=20
+	cmgr->hba =3D hba;
 	cmgr->free_list =3D kzalloc(sizeof(*cmgr->free_list) *
 				  arr_sz, GFP_KERNEL);
 	if (!cmgr->free_list) {
@@ -287,7 +288,6 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2=
fc_hba *hba)
 		goto mem_err;
 	}
=20
-	cmgr->hba =3D hba;
 	cmgr->cmds =3D (struct bnx2fc_cmd **)(cmgr + 1);
=20
 	for (i =3D 0; i < arr_sz; i++)  {
@@ -326,7 +326,7 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2=
fc_hba *hba)
=20
 	/* Allocate pool of io_bdts - one for each bnx2fc_cmd */
 	mem_size =3D num_ios * sizeof(struct io_bdt *);
-	cmgr->io_bdt_pool =3D kmalloc(mem_size, GFP_KERNEL);
+	cmgr->io_bdt_pool =3D kzalloc(mem_size, GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		printk(KERN_ERR PFX "failed to alloc io_bdt_pool\n");
 		goto mem_err;
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 695b34e9154e..e8a43a609d9d 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -598,6 +598,13 @@ static struct isci_host *isci_host_alloc(struct pci_de=
v *pdev, int id)
 	shost->max_lun =3D ~0;
 	shost->max_cmd_len =3D MAX_COMMAND_SIZE;
=20
+	/* turn on DIF support */
+	scsi_host_set_prot(shost,
+			   SHOST_DIF_TYPE1_PROTECTION |
+			   SHOST_DIF_TYPE2_PROTECTION |
+			   SHOST_DIF_TYPE3_PROTECTION);
+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+
 	err =3D scsi_add_host(shost, &pdev->dev);
 	if (err)
 		goto err_shost;
@@ -685,13 +692,6 @@ static int isci_pci_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 			goto err_host_alloc;
 		}
 		pci_info->hosts[i] =3D h;
-
-		/* turn on DIF support */
-		scsi_host_set_prot(to_shost(h),
-				   SHOST_DIF_TYPE1_PROTECTION |
-				   SHOST_DIF_TYPE2_PROTECTION |
-				   SHOST_DIF_TYPE3_PROTECTION);
-		scsi_host_set_guard(to_shost(h), SHOST_DIX_GUARD_CRC);
 	}
=20
 	err =3D isci_setup_interrupts(pdev);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_e=
xpander.c
index 9ee5a359248c..7d5d66edae87 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -817,6 +817,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 		rphy =3D sas_end_device_alloc(phy->port);
 		if (!rphy)
 			goto out_free;
+		rphy->identify.phy_identifier =3D phy_id;
=20
 		child->rphy =3D rphy;
 		get_device(&rphy->dev);
@@ -844,6 +845,7 @@ static struct domain_device *sas_ex_discover_end_dev(
=20
 		child->rphy =3D rphy;
 		get_device(&rphy->dev);
+		rphy->identify.phy_identifier =3D phy_id;
 		sas_fill_in_rphy(child, rphy);
=20
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 184ffbc92eba..228d8250e452 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -192,6 +192,13 @@ cache_type_store(struct device *dev, struct device_att=
ribute *attr,
 	buffer_data[2] &=3D ~0x05;
 	buffer_data[2] |=3D wce << 2 | rcd;
 	sp =3D buffer_data[0] & 0x80 ? 1 : 0;
+	buffer_data[0] &=3D ~0x80;
+
+	/*
+	 * Ensure WP, DPOFUA, and RESERVED fields are cleared in
+	 * received mode parameter buffer before doing MODE SELECT.
+	 */
+	data.device_specific =3D 0;
=20
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
 			     SD_MAX_RETRIES, &data, &sshdr)) {
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/=
rtl8188eu/os_dep/usb_intf.c
index 208c9ba4e236..1000e87faa73 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -59,6 +59,7 @@ static struct usb_device_id rtw_usb_id_tbl[] =3D {
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
+	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 6d1e2f746ab4..8d6253903f24 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -598,6 +598,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, =
struct file *file,
 				/* too large for caller's buffer */
 				ret =3D -EOVERFLOW;
 			} else {
+				__set_current_state(TASK_RUNNING);
 				if (copy_to_user(buf, rbuf->buf, rbuf->count))
 					ret =3D -EFAULT;
 				else
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index ad7e13a51b22..3c614b8c3fdf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -480,10 +480,12 @@ static inline int __uart_put_char(struct uart_port *p=
ort,
 	unsigned long flags;
 	int ret =3D 0;
=20
-	if (!circ->buf)
+	spin_lock_irqsave(&port->lock, flags);
+	if (!circ->buf) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
+	}
=20
-	spin_lock_irqsave(&port->lock, flags);
 	if (uart_circ_chars_free(circ) !=3D 0) {
 		circ->buf[circ->head] =3D c;
 		circ->head =3D (circ->head + 1) & (UART_XMIT_SIZE - 1);
@@ -524,12 +526,14 @@ static int uart_write(struct tty_struct *tty,
 	}
=20
 	port =3D state->uart_port;
+	spin_lock_irqsave(&port->lock, flags);
 	circ =3D &state->xmit;
=20
-	if (!circ->buf)
+	if (!circ->buf) {
+		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
+	}
=20
-	spin_lock_irqsave(&port->lock, flags);
 	while (1) {
 		c =3D CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
 		if (count < c)
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 5ab3e0b7d2a7..ff063656c312 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2219,7 +2219,8 @@ static int tiocsti(struct tty_struct *tty, char __use=
r *p)
 		return -EFAULT;
 	tty_audit_tiocsti(tty, ch);
 	ld =3D tty_ldisc_ref_wait(tty);
-	ld->ops->receive_buf(tty, &ch, &mbz, 1);
+	if (ld->ops->receive_buf)
+		ld->ops->receive_buf(tty, &ch, &mbz, 1);
 	tty_ldisc_deref(ld);
 	return 0;
 }
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 6b1eb4e35579..6f5d249d454d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -953,6 +953,7 @@ static int vc_do_resize(struct tty_struct *tty, struct =
vc_data *vc,
 	if (CON_IS_VISIBLE(vc))
 		update_screen(vc);
 	vt_event_post(VT_EVENT_RESIZE, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 	return err;
 }
=20
@@ -2415,8 +2416,8 @@ static int do_con_write(struct tty_struct *tty, const=
 unsigned char *buf, int co
 	}
 	FLUSH
 	console_conditional_schedule();
-	console_unlock();
 	notify_update(vc);
+	console_unlock();
 	return n;
 #undef FLUSH
 }
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 447cbe6d75b0..2e80f5a221b4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1903,6 +1903,13 @@ static const struct usb_device_id acm_ids[] =3D {
 	.driver_info =3D IGNORE_DEVICE,
 	},
=20
+	{ USB_DEVICE(0x1bc7, 0x0021), /* Telit 3G ACM only composition */
+	.driver_info =3D SEND_ZERO_PACKET,
+	},
+	{ USB_DEVICE(0x1bc7, 0x0023), /* Telit 3G ACM + ECM composition */
+	.driver_info =3D SEND_ZERO_PACKET,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index a11668825749..dd480d33fdbc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -240,7 +240,8 @@ static const struct usb_device_id usb_quirk_list[] =3D {
 	{ USB_DEVICE(0x1a40, 0x0101), .driver_info =3D USB_QUIRK_HUB_SLOW_RESET },
=20
 	/* Corsair K70 RGB */
-	{ USB_DEVICE(0x1b1c, 0x1b13), .driver_info =3D USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x1b1c, 0x1b13), .driver_info =3D USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_DELAY_CTRL_MSG },
=20
 	/* Corsair Strafe */
 	{ USB_DEVICE(0x1b1c, 0x1b15), .driver_info =3D USB_QUIRK_DELAY_INIT |
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index ca15405583e2..94dafa34393a 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -2072,7 +2072,7 @@ static irqreturn_t net2272_irq(int irq, void *_dev)
 #if defined(PLX_PCI_RDK2)
 	/* see if PCI int for us by checking irqstat */
 	intcsr =3D readl(dev->rdk2.fpga_base_addr + RDK2_IRQSTAT);
-	if (!intcsr & (1 << NET2272_PCI_IRQ)) {
+	if (!(intcsr & (1 << NET2272_PCI_IRQ))) {
 		spin_unlock(&dev->lock);
 		return IRQ_NONE;
 	}
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d4aa779339f1..4258766799e1 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -488,10 +488,8 @@ void musb_g_tx(struct musb *musb, u8 epnum)
 	}
=20
 	if (request) {
-		u8	is_dma =3D 0;
=20
 		if (dma && (csr & MUSB_TXCSR_DMAENAB)) {
-			is_dma =3D 1;
 			csr |=3D MUSB_TXCSR_P_WZC_BITS;
 			csr &=3D ~(MUSB_TXCSR_DMAENAB | MUSB_TXCSR_P_UNDERRUN |
 				 MUSB_TXCSR_TXPKTRDY | MUSB_TXCSR_AUTOSET);
@@ -507,15 +505,10 @@ void musb_g_tx(struct musb *musb, u8 epnum)
 		 * First, maybe a terminating short packet. Some DMA
 		 * engines might handle this by themselves.
 		 */
-		if ((request->zero && request->length
+		if ((request->zero && request->length)
 			&& (request->length % musb_ep->packet_sz =3D=3D 0)
-			&& (request->actual =3D=3D request->length))
-#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
-			|| (is_dma && (!dma->desired_mode ||
-				(request->actual &
-					(musb_ep->packet_sz - 1))))
-#endif
-		) {
+			&& (request->actual =3D=3D request->length)) {
+
 			/*
 			 * On DMA completion, FIFO may not be
 			 * available yet...
diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index e8e9f9aab203..d006f54d5e15 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -319,12 +319,10 @@ static irqreturn_t dma_controller_irq(int irq, void *=
private_data)
 				channel->status =3D MUSB_DMA_STATUS_FREE;
=20
 				/* completed */
-				if ((devctl & MUSB_DEVCTL_HM)
-					&& (musb_channel->transmit)
-					&& ((channel->desired_mode =3D=3D 0)
-					    || (channel->actual_len &
-					    (musb_channel->max_packet_sz - 1)))
-				    ) {
+				if (musb_channel->transmit &&
+					(!channel->desired_mode ||
+					(channel->actual_len %
+					    musb_channel->max_packet_sz))) {
 					u8  epnum  =3D musb_channel->epnum;
 					int offset =3D MUSB_EP_OFFSET(epnum,
 								    MUSB_TXCSR);
@@ -336,11 +334,14 @@ static irqreturn_t dma_controller_irq(int irq, void *=
private_data)
 					 */
 					musb_ep_select(mbase, epnum);
 					txcsr =3D musb_readw(mbase, offset);
-					txcsr &=3D ~(MUSB_TXCSR_DMAENAB
+					if (channel->desired_mode =3D=3D 1) {
+						txcsr &=3D ~(MUSB_TXCSR_DMAENAB
 							| MUSB_TXCSR_AUTOSET);
-					musb_writew(mbase, offset, txcsr);
-					/* Send out the packet */
-					txcsr &=3D ~MUSB_TXCSR_DMAMODE;
+						musb_writew(mbase, offset, txcsr);
+						/* Send out the packet */
+						txcsr &=3D ~MUSB_TXCSR_DMAMODE;
+						txcsr |=3D MUSB_TXCSR_DMAENAB;
+					}
 					txcsr |=3D  MUSB_TXCSR_TXPKTRDY;
 					musb_writew(mbase, offset, txcsr);
 				}
diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 585e50cb1980..b6a5c2aef23e 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -56,9 +56,6 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
=20
-	ret =3D usb_add_phy_dev(&am_phy->usb_phy_gen.phy);
-	if (ret)
-		return ret;
 	am_phy->usb_phy_gen.phy.init =3D am335x_init;
 	am_phy->usb_phy_gen.phy.shutdown =3D am335x_shutdown;
=20
@@ -77,7 +74,7 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	device_set_wakeup_enable(dev, false);
 	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
=20
-	return 0;
+	return usb_add_phy_dev(&am_phy->usb_phy_gen.phy);
 }
=20
 static int am335x_phy_remove(struct platform_device *pdev)
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6028d9c98bb7..a2809d51a308 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -47,6 +47,7 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_HCR331) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_ZTEK) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_TB) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 715d0ecd4eea..c5f519a91177 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -13,6 +13,7 @@
=20
 #define PL2303_VENDOR_ID	0x067b
 #define PL2303_PRODUCT_ID	0x2303
+#define PL2303_PRODUCT_ID_TB		0x2304
 #define PL2303_PRODUCT_ID_RSAQ2		0x04bb
 #define PL2303_PRODUCT_ID_DCU11		0x1234
 #define PL2303_PRODUCT_ID_PHAROS	0xaaa0
@@ -25,6 +26,7 @@
 #define PL2303_PRODUCT_ID_MOTOROLA	0x0307
 #define PL2303_PRODUCT_ID_ZTEK		0xe1f1
=20
+
 #define ATEN_VENDOR_ID		0x0557
 #define ATEN_VENDOR_ID2		0x0547
 #define ATEN_PRODUCT_ID		0x2008
diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/us=
b-serial-simple.c
index ba00eb4c9972..235733c69272 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -88,7 +88,8 @@ DEVICE(moto_modem, MOTO_IDS);
 /* Motorola Tetra driver */
 #define MOTOROLA_TETRA_IDS()			\
 	{ USB_DEVICE(0x0cad, 0x9011) },	/* Motorola Solutions TETRA PEI */ \
-	{ USB_DEVICE(0x0cad, 0x9012) }	/* MTP6550 */
+	{ USB_DEVICE(0x0cad, 0x9012) },	/* MTP6550 */ \
+	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
=20
 /* Novatel Wireless GPS driver */
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index b6124d894f83..204ba923cc96 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -223,8 +223,12 @@ static int slave_configure(struct scsi_device *sdev)
 		if (!(us->fflags & US_FL_NEEDS_CAP16))
 			sdev->try_rc_10_first =3D 1;
=20
-		/* assume SPC3 or latter devices support sense size > 18 */
-		if (sdev->scsi_level > SCSI_SPC_2)
+		/*
+		 * assume SPC3 or latter devices support sense size > 18
+		 * unless US_FL_BAD_SENSE quirk is specified.
+		 */
+		if (sdev->scsi_level > SCSI_SPC_2 &&
+		    !(us->fflags & US_FL_BAD_SENSE))
 			us->fflags |=3D US_FL_SANE_SENSE;
=20
 		/* USB-IDE bridges tend to report SK =3D 0x04 (Non-recoverable
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index c03043c6c022..2249d85bd910 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1194,6 +1194,18 @@ UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
=20
+/*
+ * Reported by Icenowy Zheng <icenowy@aosc.io>
+ * The SMI SM3350 USB-UFS bridge controller will enter a wrong state
+ * that do not process read/write command if a long sense is requested,
+ * so force to use 18-byte sense.
+ */
+UNUSUAL_DEV(  0x090c, 0x3350, 0x0000, 0xffff,
+		"SMI",
+		"SM3350 UFS-to-USB-Mass-Storage bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BAD_SENSE ),
+
 /* Reported by Paul Hartman <paul.hartman+linux@gmail.com>
  * This card reader returns "Illegal Request, Logical Block Address
  * Out of Range" for the first READ(10) after a new card is inserted.
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type=
1.c
index 94cf33846827..a4d76bf481df 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -53,10 +53,16 @@ module_param_named(disable_hugepages,
 MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
=20
+static unsigned int dma_entry_limit __read_mostly =3D U16_MAX;
+module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
+MODULE_PARM_DESC(dma_entry_limit,
+		 "Maximum number of user DMA mappings per container (65535).");
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct mutex		lock;
 	struct rb_root		dma_list;
+	unsigned int		dma_avail;
 	bool v2;
 };
=20
@@ -364,6 +370,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, s=
truct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma);
 	vfio_unlink_dma(iommu, dma);
 	kfree(dma);
+	iommu->dma_avail++;
 }
=20
 static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
@@ -549,12 +556,18 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		return -EEXIST;
 	}
=20
+	if (!iommu->dma_avail) {
+		ret =3D -ENOSPC;
+		goto out_unlock;
+	}
+
 	dma =3D kzalloc(sizeof(*dma), GFP_KERNEL);
 	if (!dma) {
 		mutex_unlock(&iommu->lock);
 		return -ENOMEM;
 	}
=20
+	iommu->dma_avail--;
 	dma->iova =3D iova;
 	dma->vaddr =3D vaddr;
 	dma->prot =3D prot;
@@ -586,6 +599,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (ret)
 		vfio_remove_dma(iommu, dma);
=20
+out_unlock:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
@@ -816,6 +830,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
=20
 	INIT_LIST_HEAD(&iommu->domain_list);
 	iommu->dma_list =3D RB_ROOT;
+	iommu->dma_avail =3D dma_entry_limit;
 	mutex_init(&iommu->lock);
 	iommu->v2 =3D (arg =3D=3D VFIO_TYPE1v2_IOMMU);
=20
diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c b/drivers/vide=
o/fbdev/omap2/omapfb/omapfb-ioctl.c
index 2dbd5687c453..2f8d875d637d 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c
@@ -606,6 +606,8 @@ int omapfb_ioctl(struct fb_info *fbi, unsigned int cmd,=
 unsigned long arg)
=20
 	int r =3D 0;
=20
+	memset(&p, 0, sizeof(p));
+
 	switch (cmd) {
 	case OMAPFB_SYNC_GFX:
 		DBG("ioctl SYNC_GFX\n");
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 972db0c5350d..2df8642c3ac1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -736,6 +736,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		current->flags |=3D PF_RANDOMIZE;
=20
 	setup_new_exec(bprm);
+	install_exec_creds(bprm);
=20
 	/* Do this so that we can load the interpreter, if need be.  We will
 	   change some of these later */
@@ -822,6 +823,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			total_size =3D total_mapping_size(elf_phdata,
 							loc->elf_ex.e_phnum);
 			if (!total_size) {
+				send_sig(SIGKILL, current, 0);
 				retval =3D -EINVAL;
 				goto out_free_dentry;
 			}
@@ -950,7 +952,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	}
 #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
=20
-	install_exec_creds(bprm);
 	retval =3D create_elf_tables(bprm, &loc->elf_ex,
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index fad6f7dfab19..62eeae2aa1f9 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -579,7 +579,8 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	     capsnap->size);
=20
 	spin_lock(&mdsc->snap_flush_lock);
-	list_add_tail(&ci->i_snap_flush_item, &mdsc->snap_flush_list);
+	if (list_empty(&ci->i_snap_flush_item))
+		list_add_tail(&ci->i_snap_flush_item, &mdsc->snap_flush_list);
 	spin_unlock(&mdsc->snap_flush_lock);
 	return 1;  /* caller may want to ceph_flush_snaps */
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 716c55ceee24..50c5e3955786 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1066,10 +1066,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfil=
e)
=20
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
-	 * and check it for zero before using.
+	 * and check it before using.
 	 */
 	max_buf =3D tcon->ses->server->maxBuf;
-	if (!max_buf) {
+	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE))) {
 		free_xid(xid);
 		return -EINVAL;
 	}
@@ -1403,10 +1403,10 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struc=
t file_lock *flock,
=20
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
-	 * and check it for zero before using.
+	 * and check it before using.
 	 */
 	max_buf =3D tcon->ses->server->maxBuf;
-	if (!max_buf)
+	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE)))
 		return -EINVAL;
=20
 	max_num =3D (max_buf - sizeof(struct smb_hdr)) /
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index cf560ca00d97..179a50218995 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -101,10 +101,10 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct =
file_lock *flock,
=20
 	/*
 	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
-	 * and check it for zero before using.
+	 * and check it before using.
 	 */
 	max_buf =3D tcon->ses->server->maxBuf;
-	if (!max_buf)
+	if (max_buf < sizeof(struct smb2_lock_element))
 		return -EINVAL;
=20
 	max_num =3D max_buf / sizeof(struct smb2_lock_element);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6a5b70240a08..9e432368485d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1861,7 +1861,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 			rdata->result =3D -EIO;
 	}
=20
-	if (rdata->result)
+	if (rdata->result && rdata->result !=3D -ENODATA)
 		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
=20
 	queue_work(cifsiod_wq, &rdata->work);
@@ -2260,8 +2260,8 @@ SMB2_query_directory(const unsigned int xid, struct c=
ifs_tcon *tcon,
 		if (rc =3D=3D -ENODATA && rsp->hdr.Status =3D=3D STATUS_NO_MORE_FILES) {
 			srch_inf->endOfSearch =3D true;
 			rc =3D 0;
-		}
-		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
+		} else
+			cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
 		goto qdir_exit;
 	}
=20
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 970bac263a5d..503e7b2eda8c 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -376,7 +376,7 @@ smb_send_rqst(struct TCP_Server_Info *server, struct sm=
b_rqst *rqst)
 	if (rc < 0 && rc !=3D -EINTR)
 		cifs_dbg(VFS, "Error %d sending data on socket to server\n",
 			 rc);
-	else
+	else if (rc > 0)
 		rc =3D 0;
=20
 	return rc;
diff --git a/fs/dcache.c b/fs/dcache.c
index c42ae8a079db..6b0ef157a48b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1063,15 +1063,11 @@ static enum lru_status dentry_lru_isolate_shrink(st=
ruct list_head *item,
  */
 void shrink_dcache_sb(struct super_block *sb)
 {
-	long freed;
-
 	do {
 		LIST_HEAD(dispose);
=20
-		freed =3D list_lru_walk(&sb->s_dentry_lru,
+		list_lru_walk(&sb->s_dentry_lru,
 			dentry_lru_isolate_shrink, &dispose, 1024);
-
-		this_cpu_sub(nr_dentry_unused, freed);
 		shrink_dentry_list(&dispose);
 		cond_resched();
 	} while (list_lru_count(&sb->s_dentry_lru) > 0);
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 79f310d80baf..4e9796728700 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -622,6 +622,13 @@ struct dentry *debugfs_rename(struct dentry *old_dir, =
struct dentry *old_dentry,
 	struct dentry *dentry =3D NULL, *trap;
 	struct name_snapshot old_name;
=20
+	if (IS_ERR(old_dir))
+		return old_dir;
+	if (IS_ERR(new_dir))
+		return new_dir;
+	if (IS_ERR_OR_NULL(old_dentry))
+		return old_dentry;
+
 	trap =3D lock_rename(new_dir, old_dir);
 	/* Source or destination directories don't exist? */
 	if (!old_dir->d_inode || !new_dir->d_inode)
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index db2963a54f16..29cbf574d2b7 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1652,7 +1652,6 @@ static int fuse_retrieve(struct fuse_conn *fc, struct=
 inode *inode,
 	req->in.h.nodeid =3D outarg->nodeid;
 	req->in.numargs =3D 2;
 	req->in.argpages =3D 1;
-	req->page_descs[0].offset =3D offset;
 	req->end =3D fuse_retrieve_end;
=20
 	index =3D outarg->offset >> PAGE_CACHE_SHIFT;
@@ -1667,6 +1666,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct=
 inode *inode,
=20
 		this_num =3D min_t(unsigned, num, PAGE_CACHE_SIZE - offset);
 		req->pages[req->num_pages] =3D page;
+		req->page_descs[req->num_pages].offset =3D offset;
 		req->page_descs[req->num_pages].length =3D this_num;
 		req->num_pages++;
=20
@@ -1978,10 +1978,12 @@ static ssize_t fuse_dev_splice_write(struct pipe_in=
ode_info *pipe,
=20
 	ret =3D fuse_dev_do_write(fc, &cs, len);
=20
+	pipe_lock(pipe);
 	for (idx =3D 0; idx < nbuf; idx++) {
 		struct pipe_buffer *buf =3D &bufs[idx];
 		buf->ops->release(pipe, buf);
 	}
+	pipe_unlock(pipe);
 out:
 	kfree(bufs);
 	return ret;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b2203c5113cf..bc8f5de48fd9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1846,7 +1846,7 @@ static bool fuse_writepage_in_flight(struct fuse_req =
*new_req,
 		spin_unlock(&fc->lock);
=20
 		dec_bdi_stat(bdi, BDI_WRITEBACK);
-		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+		dec_zone_page_state(new_req->pages[0], NR_WRITEBACK_TEMP);
 		bdi_writeout_inc(bdi);
 		fuse_writepage_free(fc, new_req);
 		fuse_request_free(new_req);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 49672801e36e..9812875189c2 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -809,8 +809,27 @@ static ssize_t clear_refs_write(struct file *file, con=
st char __user *buf,
 			.private =3D &cp,
 		};
 		down_read(&mm->mmap_sem);
-		if (type =3D=3D CLEAR_REFS_SOFT_DIRTY)
+		if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
+			/*
+			 * Avoid to modify vma->vm_flags
+			 * without locked ops while the
+			 * coredump reads the vm_flags.
+			 */
+			if (!mmget_still_valid(mm)) {
+				/*
+				 * Silently return "count"
+				 * like if get_task_mm()
+				 * failed. FIXME: should this
+				 * function have returned
+				 * -ESRCH if get_task_mm()
+				 * failed like if
+				 * get_proc_task() fails?
+				 */
+				up_read(&mm->mmap_sem);
+				goto out_mm;
+			}
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
+		}
 		for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
 			cp.vma =3D vma;
 			if (is_vm_hugetlb_page(vma))
@@ -841,6 +860,7 @@ static ssize_t clear_refs_write(struct file *file, cons=
t char __user *buf,
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
+out_mm:
 		mmput(mm);
 	}
 	put_task_struct(task);
diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index 5e452c84f1e6..9169a439413b 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -29,7 +29,7 @@
 struct user_key_payload {
 	struct rcu_head	rcu;		/* RCU destructor */
 	unsigned short	datalen;	/* length of this data */
-	char		data[0];	/* actual data */
+	char		data[0] __aligned(__alignof__(u64)); /* actual data */
 };
=20
 extern struct key_type key_type_user;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3186617e2410..fb3973615d50 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -262,6 +262,11 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
+	 */
+	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
 };
=20
 /**
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e689a930849d..9daa104bcb42 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2425,6 +2425,27 @@ static inline void mmdrop(struct mm_struct * mm)
 		__mmdrop(mm);
 }
=20
+/*
+ * This has to be called after a get_task_mm()/mmget_not_zero()
+ * followed by taking the mmap_sem for writing before modifying the
+ * vmas or anything the coredump pretends not to change from under it.
+ *
+ * NOTE: find_extend_vma() called from GUP context is the only place
+ * that can modify the "mm" (notably the vm_start/end) under mmap_sem
+ * for reading and outside the context of the process, so it is also
+ * the only case that holds the mmap_sem for reading that must call
+ * this function. Generally if the mmap_sem is hold for reading
+ * there's no need of this check after get_task_mm()/mmget_not_zero().
+ *
+ * This function can be obsoleted and the check can be removed, after
+ * the coredump code will hold the mmap_sem for writing before
+ * invoking the ->core_dump methods.
+ */
+static inline bool mmget_still_valid(struct mm_struct *mm)
+{
+	return likely(!mm->core_state);
+}
+
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
 /* Grab a reference to a task's mm, if it is not already going away */
diff --git a/include/linux/signal.h b/include/linux/signal.h
index eab3c8304543..c6eba73f32e0 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -279,9 +279,8 @@ struct ksignal {
 	int sig;
 };
=20
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *retu=
rn_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal(struct ksignal *ksig);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int steppi=
ng);
-extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction =
*ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
=20
@@ -300,18 +299,6 @@ static inline void disallow_signal(int sig)
 	kernel_sigaction(sig, SIG_IGN);
 }
=20
-/*
- * Eventually that'll replace get_signal_to_deliver(); macro for now,
- * to avoid nastiness with include order.
- */
-#define get_signal(ksig)					\
-({								\
-	struct ksignal *p =3D (ksig);				\
-	p->sig =3D get_signal_to_deliver(&p->info, &p->ka,	\
-					signal_pt_regs(), NULL);\
-	p->sig > 0;						\
-})
-
 extern struct kmem_cache *sighand_cachep;
=20
 int unhandled_signal(struct task_struct *tsk, int sig);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 6f8ab7da27c4..84d497297c5f 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -133,10 +133,6 @@ static inline void tracehook_report_syscall_exit(struc=
t pt_regs *regs, int step)
=20
 /**
  * tracehook_signal_handler - signal handler setup is complete
- * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
- * @ka:			sigaction setting that chose the handler
- * @regs:		user register state
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * Called by the arch code after a signal handler has been set up.
@@ -146,9 +142,7 @@ static inline void tracehook_report_syscall_exit(struct=
 pt_regs *regs, int step)
  * Called without locks, shortly before returning to user mode
  * (or handling more signals).
  */
-static inline void tracehook_signal_handler(int sig, siginfo_t *info,
-					    const struct k_sigaction *ka,
-					    struct pt_regs *regs, int stepping)
+static inline void tracehook_signal_handler(int stepping)
 {
 	if (stepping)
 		ptrace_notify(SIGTRAP);
diff --git a/include/sound/compress_driver.h b/include/sound/compress_drive=
r.h
index ae6c3b8ed2f5..d81bc1396142 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -176,7 +176,11 @@ static inline void snd_compr_drain_notify(struct snd_c=
ompr_stream *stream)
 	if (snd_BUG_ON(!stream))
 		return;
=20
-	stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
+	if (stream->direction =3D=3D SND_COMPRESS_PLAYBACK)
+		stream->runtime->state =3D SNDRV_PCM_STATE_SETUP;
+	else
+		stream->runtime->state =3D SNDRV_PCM_STATE_PREPARED;
+
 	wake_up(&stream->runtime->sleep);
 }
=20
diff --git a/ipc/shm.c b/ipc/shm.c
index 6d96289241a9..ceb63ac46003 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -620,12 +620,12 @@ static int newseg(struct ipc_namespace *ns, struct ip=
c_params *params)
 	return error;
=20
 no_id:
+	ipc_update_pid(&shp->shm_cprid, NULL);
+	ipc_update_pid(&shp->shm_lprid, NULL);
 	if (is_file_hugepages(file) && shp->mlock_user)
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
-	ipc_update_pid(&shp->shm_cprid, NULL);
-	ipc_update_pid(&shp->shm_lprid, NULL);
 	ipc_rcu_putref(shp, shm_rcu_free);
 	return error;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 17821c290b3b..e8be52939ed1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -936,6 +936,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
+ *    cred_guard_mutex
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event_context::lock
@@ -3231,7 +3232,6 @@ static struct task_struct *
 find_lively_task_by_vpid(pid_t vpid)
 {
 	struct task_struct *task;
-	int err;
=20
 	rcu_read_lock();
 	if (!vpid)
@@ -3245,16 +3245,7 @@ find_lively_task_by_vpid(pid_t vpid)
 	if (!task)
 		return ERR_PTR(-ESRCH);
=20
-	/* Reuse ptrace permission checks for now. */
-	err =3D -EACCES;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
-		goto errout;
-
 	return task;
-errout:
-	put_task_struct(task);
-	return ERR_PTR(err);
-
 }
=20
 /*
@@ -3805,6 +3796,11 @@ static int __perf_event_period(void *info)
 	return 0;
 }
=20
+static int perf_event_check_period(struct perf_event *event, u64 value)
+{
+	return event->pmu->check_period(event, value);
+}
+
 static int perf_event_period(struct perf_event *event, u64 __user *arg)
 {
 	struct period_event pe =3D { .event =3D event, };
@@ -3824,6 +3820,9 @@ static int perf_event_period(struct perf_event *event=
, u64 __user *arg)
 	if (event->attr.freq && value > sysctl_perf_event_sample_rate)
 		return -EINVAL;
=20
+	if (perf_event_check_period(event, value))
+		return -EINVAL;
+
 	task =3D ctx->task;
 	pe.value =3D value;
=20
@@ -6649,6 +6648,11 @@ static int perf_pmu_nop_int(struct pmu *pmu)
 	return 0;
 }
=20
+static int perf_event_nop_int(struct perf_event *event, u64 value)
+{
+	return 0;
+}
+
 static void perf_pmu_start_txn(struct pmu *pmu)
 {
 	perf_pmu_disable(pmu);
@@ -6903,6 +6907,9 @@ int perf_pmu_register(struct pmu *pmu, const char *na=
me, int type)
 		pmu->pmu_disable =3D perf_pmu_nop_void;
 	}
=20
+	if (!pmu->check_period)
+		pmu->check_period =3D perf_event_nop_int;
+
 	if (!pmu->event_idx)
 		pmu->event_idx =3D perf_event_idx_default;
=20
@@ -7475,18 +7482,36 @@ SYSCALL_DEFINE5(perf_event_open,
=20
 	get_online_cpus();
=20
+	if (task) {
+		err =3D mutex_lock_interruptible(&task->signal->cred_guard_mutex);
+		if (err)
+			goto err_cpus;
+
+		/*
+		 * Reuse ptrace permission checks for now.
+		 *
+		 * We must hold cred_guard_mutex across this and any potential
+		 * perf_install_in_context() call for this new event to
+		 * serialize against exec() altering our credentials (and the
+		 * perf_event_exit_task() that could imply).
+		 */
+		err =3D -EACCES;
+		if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+			goto err_cred;
+	}
+
 	event =3D perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
 		err =3D PTR_ERR(event);
-		goto err_cpus;
+		goto err_cred;
 	}
=20
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		err =3D perf_cgroup_connect(pid, event, &attr, group_leader);
 		if (err) {
 			__free_event(event);
-			goto err_cpus;
+			goto err_cred;
 		}
 	}
=20
@@ -7536,11 +7561,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
=20
-	if (task) {
-		put_task_struct(task);
-		task =3D NULL;
-	}
-
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
@@ -7642,6 +7662,11 @@ SYSCALL_DEFINE5(perf_event_open,
=20
 	WARN_ON_ONCE(ctx->parent_ctx);
=20
+	/*
+	 * This is the point on no return; we cannot fail hereafter. This is
+	 * where we start modifying current state.
+	 */
+
 	if (move_group) {
 		/*
 		 * Wait for everybody to stop referencing the events through
@@ -7667,6 +7692,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 	mutex_unlock(&ctx->mutex);
=20
+	if (task) {
+		mutex_unlock(&task->signal->cred_guard_mutex);
+		put_task_struct(task);
+	}
+
 	put_online_cpus();
=20
 	event->owner =3D current;
@@ -7706,6 +7736,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	 */
 	if (!event_file)
 		free_event(event);
+err_cred:
+	if (task)
+		mutex_unlock(&task->signal->cred_guard_mutex);
 err_cpus:
 	put_online_cpus();
 err_task:
@@ -7940,6 +7973,9 @@ static void perf_event_exit_task_context(struct task_=
struct *child, int ctxn)
=20
 /*
  * When a child task exits, feed back event values to parent events.
+ *
+ * Can be called with cred_guard_mutex held when called from
+ * install_exec_creds().
  */
 void perf_event_exit_task(struct task_struct *child)
 {
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1d2..fe88f61c9109 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -282,6 +282,9 @@ struct ring_buffer *rb_alloc(int nr_pages, long waterma=
rk, int cpu, int flags)
 	size =3D sizeof(struct ring_buffer);
 	size +=3D nr_pages * sizeof(void *);
=20
+	if (order_base_2(size) >=3D PAGE_SHIFT+MAX_ORDER)
+		goto fail;
+
 	rb =3D kzalloc(size, GFP_KERNEL);
 	if (!rb)
 		goto fail;
diff --git a/kernel/signal.c b/kernel/signal.c
index ce4d529e7f3c..f3d2701f37ef 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -684,6 +684,48 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *=
mask, siginfo_t *info)
 	return signr;
 }
=20
+static int dequeue_synchronous_signal(siginfo_t *info)
+{
+	struct task_struct *tsk =3D current;
+	struct sigpending *pending =3D &tsk->pending;
+	struct sigqueue *q, *sync =3D NULL;
+
+	/*
+	 * Might a synchronous signal be in the queue?
+	 */
+	if (!((pending->signal.sig[0] & ~tsk->blocked.sig[0]) & SYNCHRONOUS_MASK))
+		return 0;
+
+	/*
+	 * Return the first synchronous signal in the queue.
+	 */
+	list_for_each_entry(q, &pending->list, list) {
+		/* Synchronous signals have a postive si_code */
+		if ((q->info.si_code > SI_USER) &&
+		    (sigmask(q->info.si_signo) & SYNCHRONOUS_MASK)) {
+			sync =3D q;
+			goto next;
+		}
+	}
+	return 0;
+next:
+	/*
+	 * Check if there is another siginfo for the same signal.
+	 */
+	list_for_each_entry_continue(q, &pending->list, list) {
+		if (q->info.si_signo =3D=3D sync->info.si_signo)
+			goto still_pending;
+	}
+
+	sigdelset(&pending->signal, sync->info.si_signo);
+	recalc_sigpending();
+still_pending:
+	list_del_init(&sync->list);
+	copy_siginfo(info, &sync->info);
+	__sigqueue_free(sync);
+	return info->si_signo;
+}
+
 /*
  * Tell a process that it has a new active signal..
  *
@@ -2174,8 +2216,7 @@ static int ptrace_signal(int signr, siginfo_t *info)
 	return signr;
 }
=20
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+int get_signal(struct ksignal *ksig)
 {
 	struct sighand_struct *sighand =3D current->sighand;
 	struct signal_struct *signal =3D current->signal;
@@ -2232,6 +2273,14 @@ int get_signal_to_deliver(siginfo_t *info, struct k_=
sigaction *return_ka,
 		goto relock;
 	}
=20
+	/* Has this task already been marked for death? */
+	if (signal_group_exit(signal)) {
+		ksig->info.si_signo =3D signr =3D SIGKILL;
+		sigdelset(&current->pending.signal, SIGKILL);
+		recalc_sigpending();
+		goto fatal;
+	}
+
 	for (;;) {
 		struct k_sigaction *ka;
=20
@@ -2245,13 +2294,21 @@ int get_signal_to_deliver(siginfo_t *info, struct k=
_sigaction *return_ka,
 			goto relock;
 		}
=20
-		signr =3D dequeue_signal(current, &current->blocked, info);
+		/*
+		 * Signals generated by the execution of an instruction
+		 * need to be delivered before any other pending signals
+		 * so that the instruction pointer in the signal stack
+		 * frame points to the faulting instruction.
+		 */
+		signr =3D dequeue_synchronous_signal(&ksig->info);
+		if (!signr)
+			signr =3D dequeue_signal(current, &current->blocked, &ksig->info);
=20
 		if (!signr)
 			break; /* will return 0 */
=20
 		if (unlikely(current->ptrace) && signr !=3D SIGKILL) {
-			signr =3D ptrace_signal(signr, info);
+			signr =3D ptrace_signal(signr, &ksig->info);
 			if (!signr)
 				continue;
 		}
@@ -2259,13 +2316,13 @@ int get_signal_to_deliver(siginfo_t *info, struct k=
_sigaction *return_ka,
 		ka =3D &sighand->action[signr-1];
=20
 		/* Trace actually delivered signals. */
-		trace_signal_deliver(signr, info, ka);
+		trace_signal_deliver(signr, &ksig->info, ka);
=20
 		if (ka->sa.sa_handler =3D=3D SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler !=3D SIG_DFL) {
 			/* Run the handler.  */
-			*return_ka =3D *ka;
+			ksig->ka =3D *ka;
=20
 			if (ka->sa.sa_flags & SA_ONESHOT)
 				ka->sa.sa_handler =3D SIG_DFL;
@@ -2315,7 +2372,7 @@ int get_signal_to_deliver(siginfo_t *info, struct k_s=
igaction *return_ka,
 				spin_lock_irq(&sighand->siglock);
 			}
=20
-			if (likely(do_signal_stop(info->si_signo))) {
+			if (likely(do_signal_stop(ksig->info.si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -2327,6 +2384,7 @@ int get_signal_to_deliver(siginfo_t *info, struct k_s=
igaction *return_ka,
 			continue;
 		}
=20
+	fatal:
 		spin_unlock_irq(&sighand->siglock);
=20
 		/*
@@ -2336,7 +2394,7 @@ int get_signal_to_deliver(siginfo_t *info, struct k_s=
igaction *return_ka,
=20
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(info->si_signo);
+				print_fatal_signal(ksig->info.si_signo);
 			proc_coredump_connector(current);
 			/*
 			 * If it was able to dump core, this kills all
@@ -2346,34 +2404,32 @@ int get_signal_to_deliver(siginfo_t *info, struct k=
_sigaction *return_ka,
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump(info);
+			do_coredump(&ksig->info);
 		}
=20
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(info->si_signo);
+		do_group_exit(ksig->info.si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-	return signr;
+
+	ksig->sig =3D signr;
+	return ksig->sig > 0;
 }
=20
 /**
  * signal_delivered -=20
- * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
- * @ka:			sigaction setting that chose the handler
- * @regs:		user register state
+ * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * This function should be called when a signal has successfully been
- * delivered. It updates the blocked signals accordingly (@ka->sa.sa_mask
+ * delivered. It updates the blocked signals accordingly (@ksig->ka.sa.sa_=
mask
  * is always blocked, and the signal itself is blocked unless %SA_NODEFER
- * is set in @ka->sa.sa_flags.  Tracing is notified.
+ * is set in @ksig->ka.sa.sa_flags.  Tracing is notified.
  */
-void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
-			struct pt_regs *regs, int stepping)
+static void signal_delivered(struct ksignal *ksig, int stepping)
 {
 	sigset_t blocked;
=20
@@ -2383,11 +2439,11 @@ void signal_delivered(int sig, siginfo_t *info, str=
uct k_sigaction *ka,
 	   simply clear the restore sigmask flag.  */
 	clear_restore_sigmask();
=20
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
+	sigorsets(&blocked, &current->blocked, &ksig->ka.sa.sa_mask);
+	if (!(ksig->ka.sa.sa_flags & SA_NODEFER))
+		sigaddset(&blocked, ksig->sig);
 	set_current_blocked(&blocked);
-	tracehook_signal_handler(sig, info, ka, regs, stepping);
+	tracehook_signal_handler(stepping);
 }
=20
 void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
@@ -2395,8 +2451,7 @@ void signal_setup_done(int failed, struct ksignal *ks=
ig, int stepping)
 	if (failed)
 		force_sigsegv(ksig->sig, current);
 	else
-		signal_delivered(ksig->sig, &ksig->info, &ksig->ka,
-			signal_pt_regs(), stepping);
+		signal_delivered(ksig, stepping);
 }
=20
 /*
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 0d122543bd63..1db287fffb67 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -780,9 +780,11 @@ static bool assoc_array_insert_into_terminal_node(stru=
ct assoc_array_edit *edit,
 		new_s0->index_key[i] =3D
 			ops->get_key_chunk(index_key, i * ASSOC_ARRAY_KEY_CHUNK_SIZE);
=20
-	blank =3D ULONG_MAX << (level & ASSOC_ARRAY_KEY_CHUNK_MASK);
-	pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, level, blank);
-	new_s0->index_key[keylen - 1] &=3D ~blank;
+	if (level & ASSOC_ARRAY_KEY_CHUNK_MASK) {
+		blank =3D ULONG_MAX << (level & ASSOC_ARRAY_KEY_CHUNK_MASK);
+		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, level, blank);
+		new_s0->index_key[keylen - 1] &=3D ~blank;
+	}
=20
 	/* This now reduces to a node splitting exercise for which we'll need
 	 * to regenerate the disparity table.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index eb99a91a8434..c3d2a606f86e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -360,7 +360,8 @@ static void kill_procs(struct list_head *to_kill, int f=
orcekill, int trapno,
 				printk(KERN_ERR
 		"MCE %#lx: forcibly killing %s:%d because of failure to unmap corrupted =
page\n",
 					pfn, tk->tsk->comm, tk->tsk->pid);
-				force_sig(SIGKILL, tk->tsk);
+				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
+						 tk->tsk, PIDTYPE_PID);
 			}
=20
 			/*
diff --git a/mm/migrate.c b/mm/migrate.c
index 102bdac2622e..40b1dd8f1813 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -927,6 +927,7 @@ static int unmap_and_move(new_page_t get_new_page, free=
_page_t put_new_page,
 	int rc =3D 0;
 	int *result =3D NULL;
 	struct page *newpage =3D get_new_page(page, private, &result);
+	bool is_lru =3D !__is_movable_balloon_page(page);
=20
 	if (!newpage)
 		return -ENOMEM;
@@ -959,12 +960,15 @@ static int unmap_and_move(new_page_t get_new_page, fr=
ee_page_t put_new_page,
 	/*
 	 * If migration was not successful and there's a freeing callback, use
 	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
-	 * during isolation.
+	 * during isolation.  Use the old state of the isolated source page to
+	 * determine if we migrated a LRU page. newpage was already unlocked
+	 * and possibly modified by its owner - don't rely on the page
+	 * state.
 	 */
 	if (rc !=3D MIGRATEPAGE_SUCCESS && put_new_page) {
 		ClearPageSwapBacked(newpage);
 		put_new_page(newpage, private);
-	} else if (unlikely(__is_movable_balloon_page(newpage))) {
+	} else if (unlikely(!is_lru)) {
 		/* drop our reference, page already in the balloon */
 		put_page(newpage);
 	} else
diff --git a/mm/mmap.c b/mm/mmap.c
index f557e90fc719..1ab6127c035f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -40,6 +40,7 @@
 #include <linux/notifier.h>
 #include <linux/memory.h>
 #include <linux/printk.h>
+#include <linux/sched.h>
=20
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -2244,24 +2245,19 @@ int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
 	struct vm_area_struct *prev;
-	unsigned long gap_addr;
-	int error;
+	int error =3D 0;
=20
 	address &=3D PAGE_MASK;
-	error =3D security_mmap_addr(address);
-	if (error)
-		return error;
+	if (address < mmap_min_addr)
+		return -EPERM;
=20
 	/* Enforce stack_guard_gap */
-	gap_addr =3D address - stack_guard_gap;
-	if (gap_addr > address)
-		return -ENOMEM;
 	prev =3D vma->vm_prev;
-	if (prev && prev->vm_end > gap_addr &&
+	/* Check that both stack segments have the same anon_vma? */
+	if (prev && !(prev->vm_flags & VM_GROWSDOWN) &&
 			(prev->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
-		if (!(prev->vm_flags & VM_GROWSDOWN))
+		if (address - prev->vm_end < stack_guard_gap)
 			return -ENOMEM;
-		/* Check that both stack segments have the same anon_vma? */
 	}
=20
 	/* We must make sure the anon_vma is allocated. */
@@ -2346,7 +2342,8 @@ find_extend_vma(struct mm_struct *mm, unsigned long a=
ddr)
 	vma =3D find_vma_prev(mm, addr, &prev);
 	if (vma && (vma->vm_start <=3D addr))
 		return vma;
-	if (!prev || expand_stack(prev, addr))
+	/* don't alter vm_end if the coredump is running */
+	if (!prev || !mmget_still_valid(mm) || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
 		__mlock_vma_pages_range(prev, addr, prev->vm_end, NULL);
@@ -2372,6 +2369,9 @@ find_extend_vma(struct mm_struct * mm, unsigned long =
addr)
 		return vma;
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return NULL;
+	/* don't alter vm_start if the coredump is running */
+	if (!mmget_still_valid(mm))
+		return NULL;
 	start =3D vma->vm_start;
 	if (expand_stack(vma, addr))
 		return NULL;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 171c00f2e495..959b37ad20da 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -466,6 +466,13 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp=
_mask, int order,
 	 * still freeing memory.
 	 */
 	read_lock(&tasklist_lock);
+
+	/*
+	 * The task 'p' might have already exited before reaching here. The
+	 * put_task_struct() will free task_struct 'p' while the loop still try
+	 * to access the field of 'p', so, get an extra reference.
+	 */
+	get_task_struct(p);
 	for_each_thread(p, t) {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -485,6 +492,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_=
mask, int order,
 			}
 		}
 	}
+	put_task_struct(p);
 	read_unlock(&tasklist_lock);
=20
 	p =3D find_lock_task_mm(victim);
diff --git a/mm/shmem.c b/mm/shmem.c
index ea44e5ecad75..cc4df4c8c6a3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2007,16 +2007,20 @@ static int shmem_create(struct inode *dir, struct d=
entry *dentry, umode_t mode,
 static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct=
 dentry *dentry)
 {
 	struct inode *inode =3D old_dentry->d_inode;
-	int ret;
+	int ret =3D 0;
=20
 	/*
 	 * No ordinary (disk based) filesystem counts links as inodes;
 	 * but each new link needs a new dentry, pinning lowmem, and
 	 * tmpfs dentries cannot be pruned until they are unlinked.
+	 * But if an O_TMPFILE file is linked into the tmpfs, the
+	 * first link must skip that, to get the accounting right.
 	 */
-	ret =3D shmem_reserve_inode(inode->i_sb);
-	if (ret)
-		goto out;
+	if (inode->i_nlink) {
+		ret =3D shmem_reserve_inode(inode->i_sb);
+		if (ret)
+			goto out;
+	}
=20
 	dir->i_size +=3D BOGO_DIRENT_SIZE;
 	inode->i_ctime =3D dir->i_ctime =3D dir->i_mtime =3D CURRENT_TIME;
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interfac=
e.c
index 381935d9cad5..7086bdc4b6a7 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -89,8 +89,10 @@ static bool batadv_is_on_batman_iface(const struct net_d=
evice *net_dev)
 	/* recurse over the parent device */
 	parent_dev =3D __dev_get_by_index(&init_net, net_dev->iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
-	if (WARN(!parent_dev, "Cannot find parent device"))
+	if (!parent_dev) {
+		pr_err("Cannot find parent device\n");
 		return false;
+	}
=20
 	ret =3D batadv_is_on_batman_iface(parent_dev);
=20
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interfac=
e.c
index e4a22971aabf..2ab1212f7c4d 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -180,10 +180,14 @@ static int batadv_interface_tx(struct sk_buff *skb,
=20
 	soft_iface->trans_start =3D jiffies;
 	vid =3D batadv_get_vid(skb, 0);
+
+	skb_reset_mac_header(skb);
 	ethhdr =3D eth_hdr(skb);
=20
 	switch (ntohs(ethhdr->h_proto)) {
 	case ETH_P_8021Q:
+		if (!pskb_may_pull(skb, sizeof(*vhdr)))
+			goto dropped;
 		vhdr =3D vlan_eth_hdr(skb);
=20
 		if (vhdr->h_vlan_encapsulated_proto !=3D ethertype) {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 3be30519e741..14690f24ca99 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3322,16 +3322,22 @@ static int l2cap_parse_conf_req(struct l2cap_chan *=
chan, void *data, size_t data
=20
 	while (len >=3D L2CAP_CONF_OPT_SIZE) {
 		len -=3D l2cap_get_conf_opt(&req, &type, &olen, &val);
+		if (len < 0)
+			break;
=20
 		hint  =3D type & L2CAP_CONF_HINT;
 		type &=3D L2CAP_CONF_MASK;
=20
 		switch (type) {
 		case L2CAP_CONF_MTU:
+			if (olen !=3D 2)
+				break;
 			mtu =3D val;
 			break;
=20
 		case L2CAP_CONF_FLUSH_TO:
+			if (olen !=3D 2)
+				break;
 			chan->flush_to =3D val;
 			break;
=20
@@ -3339,26 +3345,30 @@ static int l2cap_parse_conf_req(struct l2cap_chan *=
chan, void *data, size_t data
 			break;
=20
 		case L2CAP_CONF_RFC:
-			if (olen =3D=3D sizeof(rfc))
-				memcpy(&rfc, (void *) val, olen);
+			if (olen !=3D sizeof(rfc))
+				break;
+			memcpy(&rfc, (void *) val, olen);
 			break;
=20
 		case L2CAP_CONF_FCS:
+			if (olen !=3D 1)
+				break;
 			if (val =3D=3D L2CAP_FCS_NONE)
 				set_bit(CONF_RECV_NO_FCS, &chan->conf_state);
 			break;
=20
 		case L2CAP_CONF_EFS:
-			if (olen =3D=3D sizeof(efs)) {
-				remote_efs =3D 1;
-				memcpy(&efs, (void *) val, olen);
-			}
+			if (olen !=3D sizeof(efs))
+				break;
+			remote_efs =3D 1;
+			memcpy(&efs, (void *) val, olen);
 			break;
=20
 		case L2CAP_CONF_EWS:
+			if (olen !=3D 2)
+				break;
 			if (!chan->conn->hs_enabled)
 				return -ECONNREFUSED;
-
 			set_bit(FLAG_EXT_CTRL, &chan->flags);
 			set_bit(CONF_EWS_RECV, &chan->conf_state);
 			chan->tx_win_max =3D L2CAP_DEFAULT_EXT_WINDOW;
@@ -3368,7 +3378,6 @@ static int l2cap_parse_conf_req(struct l2cap_chan *ch=
an, void *data, size_t data
 		default:
 			if (hint)
 				break;
-
 			result =3D L2CAP_CONF_UNKNOWN;
 			*((u8 *) ptr++) =3D type;
 			break;
@@ -3533,58 +3542,65 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *=
chan, void *rsp, int len,
=20
 	while (len >=3D L2CAP_CONF_OPT_SIZE) {
 		len -=3D l2cap_get_conf_opt(&rsp, &type, &olen, &val);
+		if (len < 0)
+			break;
=20
 		switch (type) {
 		case L2CAP_CONF_MTU:
+			if (olen !=3D 2)
+				break;
 			if (val < L2CAP_DEFAULT_MIN_MTU) {
 				*result =3D L2CAP_CONF_UNACCEPT;
 				chan->imtu =3D L2CAP_DEFAULT_MIN_MTU;
 			} else
 				chan->imtu =3D val;
-			l2cap_add_conf_opt(&ptr, L2CAP_CONF_MTU, 2, chan->imtu, endptr - ptr);
+			l2cap_add_conf_opt(&ptr, L2CAP_CONF_MTU, 2, chan->imtu,
+					   endptr - ptr);
 			break;
=20
 		case L2CAP_CONF_FLUSH_TO:
+			if (olen !=3D 2)
+				break;
 			chan->flush_to =3D val;
-			l2cap_add_conf_opt(&ptr, L2CAP_CONF_FLUSH_TO,
-					   2, chan->flush_to, endptr - ptr);
+			l2cap_add_conf_opt(&ptr, L2CAP_CONF_FLUSH_TO, 2,
+					   chan->flush_to, endptr - ptr);
 			break;
=20
 		case L2CAP_CONF_RFC:
-			if (olen =3D=3D sizeof(rfc))
-				memcpy(&rfc, (void *)val, olen);
-
+			if (olen !=3D sizeof(rfc))
+				break;
+			memcpy(&rfc, (void *)val, olen);
 			if (test_bit(CONF_STATE2_DEVICE, &chan->conf_state) &&
 			    rfc.mode !=3D chan->mode)
 				return -ECONNREFUSED;
-
 			chan->fcs =3D 0;
-
-			l2cap_add_conf_opt(&ptr, L2CAP_CONF_RFC,
-					   sizeof(rfc), (unsigned long) &rfc, endptr - ptr);
+			l2cap_add_conf_opt(&ptr, L2CAP_CONF_RFC, sizeof(rfc),
+					   (unsigned long) &rfc, endptr - ptr);
 			break;
=20
 		case L2CAP_CONF_EWS:
+			if (olen !=3D 2)
+				break;
 			chan->ack_win =3D min_t(u16, val, chan->ack_win);
 			l2cap_add_conf_opt(&ptr, L2CAP_CONF_EWS, 2,
 					   chan->tx_win, endptr - ptr);
 			break;
=20
 		case L2CAP_CONF_EFS:
-			if (olen =3D=3D sizeof(efs)) {
-				memcpy(&efs, (void *)val, olen);
-
-				if (chan->local_stype !=3D L2CAP_SERV_NOTRAFIC &&
-				    efs.stype !=3D L2CAP_SERV_NOTRAFIC &&
-				    efs.stype !=3D chan->local_stype)
-					return -ECONNREFUSED;
-
-				l2cap_add_conf_opt(&ptr, L2CAP_CONF_EFS, sizeof(efs),
-						   (unsigned long) &efs, endptr - ptr);
-			}
+			if (olen !=3D sizeof(efs))
+				break;
+			memcpy(&efs, (void *)val, olen);
+			if (chan->local_stype !=3D L2CAP_SERV_NOTRAFIC &&
+			    efs.stype !=3D L2CAP_SERV_NOTRAFIC &&
+			    efs.stype !=3D chan->local_stype)
+				return -ECONNREFUSED;
+			l2cap_add_conf_opt(&ptr, L2CAP_CONF_EFS, sizeof(efs),
+					   (unsigned long) &efs, endptr - ptr);
 			break;
=20
 		case L2CAP_CONF_FCS:
+			if (olen !=3D 1)
+				break;
 			if (*result =3D=3D L2CAP_CONF_PENDING)
 				if (val =3D=3D L2CAP_FCS_NONE)
 					set_bit(CONF_RECV_NO_FCS,
@@ -3713,13 +3729,18 @@ static void l2cap_conf_rfc_get(struct l2cap_chan *c=
han, void *rsp, int len)
=20
 	while (len >=3D L2CAP_CONF_OPT_SIZE) {
 		len -=3D l2cap_get_conf_opt(&rsp, &type, &olen, &val);
+		if (len < 0)
+			break;
=20
 		switch (type) {
 		case L2CAP_CONF_RFC:
-			if (olen =3D=3D sizeof(rfc))
-				memcpy(&rfc, (void *)val, olen);
+			if (olen !=3D sizeof(rfc))
+				break;
+			memcpy(&rfc, (void *)val, olen);
 			break;
 		case L2CAP_CONF_EWS:
+			if (olen !=3D 2)
+				break;
 			txwin_ext =3D val;
 			break;
 		}
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 056b67b0e277..5160ae9b07ae 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -38,16 +38,21 @@ static inline int should_deliver(const struct net_bridg=
e_port *p,
 int br_dev_queue_push_xmit(struct sk_buff *skb)
 {
 	/* ip_fragment doesn't copy the MAC header */
-	if (nf_bridge_maybe_copy_header(skb) ||
-	    !is_skb_forwardable(skb->dev, skb)) {
-		kfree_skb(skb);
-	} else {
-		skb_push(skb, ETH_HLEN);
-		br_drop_fake_rtable(skb);
-		dev_queue_xmit(skb);
-	}
+	if (nf_bridge_maybe_copy_header(skb))
+		goto drop;
+
+	skb_push(skb, ETH_HLEN);
+	if (!is_skb_forwardable(skb->dev, skb))
+		goto drop;
+
+	br_drop_fake_rtable(skb);
+	dev_queue_xmit(skb);
=20
 	return 0;
+
+drop:
+	kfree_skb(skb);
+	return 0;
 }
=20
 int br_forward_finish(struct sk_buff *skb)
@@ -66,12 +71,11 @@ static void __br_deliver(const struct net_bridge_port *=
to, struct sk_buff *skb)
 	skb->dev =3D to->dev;
=20
 	if (unlikely(netpoll_tx_running(to->br->dev))) {
+		skb_push(skb, ETH_HLEN);
 		if (!is_skb_forwardable(skb->dev, skb))
 			kfree_skb(skb);
-		else {
-			skb_push(skb, ETH_HLEN);
+		else
 			br_netpoll_send_skb(to, skb);
-		}
 		return;
 	}
=20
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 468dfa12eebe..f6bebb3ce3d5 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -67,6 +67,9 @@
  */
 #define MAX_NFRAMES 256
=20
+/* limit timers to 400 days for sending/timeouts */
+#define BCM_TIMER_SEC_MAX (400 * 24 * 60 * 60)
+
 /* use of last_frames[index].can_dlc */
 #define RX_RECV    0x40 /* received data for this element */
 #define RX_THR     0x80 /* element not been sent due to throttle feature */
@@ -133,6 +136,22 @@ static inline struct bcm_sock *bcm_sk(const struct soc=
k *sk)
 	return (struct bcm_sock *)sk;
 }
=20
+/* check limitations for timeval provided by user */
+static bool bcm_is_invalid_tv(struct bcm_msg_head *msg_head)
+{
+	if ((msg_head->ival1.tv_sec < 0) ||
+	    (msg_head->ival1.tv_sec > BCM_TIMER_SEC_MAX) ||
+	    (msg_head->ival1.tv_usec < 0) ||
+	    (msg_head->ival1.tv_usec >=3D USEC_PER_SEC) ||
+	    (msg_head->ival2.tv_sec < 0) ||
+	    (msg_head->ival2.tv_sec > BCM_TIMER_SEC_MAX) ||
+	    (msg_head->ival2.tv_usec < 0) ||
+	    (msg_head->ival2.tv_usec >=3D USEC_PER_SEC))
+		return true;
+
+	return false;
+}
+
 #define CFSIZ sizeof(struct can_frame)
 #define OPSIZ sizeof(struct bcm_op)
 #define MHSIZ sizeof(struct bcm_msg_head)
@@ -851,6 +870,10 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head,=
 struct msghdr *msg,
 	if (msg_head->nframes < 1 || msg_head->nframes > MAX_NFRAMES)
 		return -EINVAL;
=20
+	/* check timeval limitations */
+	if ((msg_head->flags & SETTIMER) && bcm_is_invalid_tv(msg_head))
+		return -EINVAL;
+
 	/* check the given can_id */
 	op =3D bcm_find_op(&bo->tx_ops, msg_head->can_id, ifindex);
=20
@@ -1018,6 +1041,10 @@ static int bcm_rx_setup(struct bcm_msg_head *msg_hea=
d, struct msghdr *msg,
 	     (!(msg_head->can_id & CAN_RTR_FLAG))))
 		return -EINVAL;
=20
+	/* check timeval limitations */
+	if ((msg_head->flags & SETTIMER) && bcm_is_invalid_tv(msg_head))
+		return -EINVAL;
+
 	/* check the given can_id */
 	op =3D bcm_find_op(&bo->rx_ops, msg_head->can_id, ifindex);
 	if (op) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 64c5af0a10dd..e77127861bf5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -117,11 +117,14 @@ static void dsa_slave_change_rx_flags(struct net_devi=
ce *dev, int change)
 {
 	struct dsa_slave_priv *p =3D netdev_priv(dev);
 	struct net_device *master =3D p->parent->dst->master_netdev;
-
-	if (change & IFF_ALLMULTI)
-		dev_set_allmulti(master, dev->flags & IFF_ALLMULTI ? 1 : -1);
-	if (change & IFF_PROMISC)
-		dev_set_promiscuity(master, dev->flags & IFF_PROMISC ? 1 : -1);
+	if (dev->flags & IFF_UP) {
+		if (change & IFF_ALLMULTI)
+			dev_set_allmulti(master,
+					 dev->flags & IFF_ALLMULTI ? 1 : -1);
+		if (change & IFF_PROMISC)
+			dev_set_promiscuity(master,
+					    dev->flags & IFF_PROMISC ? 1 : -1);
+	}
 }
=20
 static void dsa_slave_set_rx_mode(struct net_device *dev)
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 8914ccb1cb60..46a944624a6e 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -165,7 +165,8 @@ static int cipso_v4_bitmap_walk(const unsigned char *bi=
tmap,
 		    (state =3D=3D 0 && (byte & bitmask) =3D=3D 0))
 			return bit_spot;
=20
-		bit_spot++;
+		if (++bit_spot >=3D bitmap_len)
+			return -1;
 		bitmask >>=3D 1;
 		if (bitmask =3D=3D 0) {
 			byte =3D bitmap[++byte_offset];
@@ -735,7 +736,8 @@ static int cipso_v4_map_lvl_valid(const struct cipso_v4=
_doi *doi_def, u8 level)
 	case CIPSO_V4_MAP_PASS:
 		return 0;
 	case CIPSO_V4_MAP_TRANS:
-		if (doi_def->map.std->lvl.cipso[level] < CIPSO_V4_INV_LVL)
+		if ((level < doi_def->map.std->lvl.cipso_size) &&
+		    (doi_def->map.std->lvl.cipso[level] < CIPSO_V4_INV_LVL))
 			return 0;
 		break;
 	}
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1953b79f46b4..d9f4f6613a92 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -943,7 +943,8 @@ check_cleanup_prefix_route(struct inet6_ifaddr *ifp, un=
signed long *expires)
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa =3D=3D ifp)
 			continue;
-		if (!ipv6_prefix_equal(&ifa->addr, &ifp->addr,
+		if (ifa->prefix_len !=3D ifp->prefix_len ||
+		    !ipv6_prefix_equal(&ifa->addr, &ifp->addr,
 				       ifp->prefix_len))
 			continue;
 		if (ifa->flags & (IFA_F_PERMANENT | IFA_F_NOPREFIXROUTE))
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 65597cf87c47..7aebc9aabac5 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -576,7 +576,8 @@ static int ipip6_err(struct sk_buff *skb, u32 info)
 		goto out;
=20
 	err =3D 0;
-	if (!ipip6_err_gen_icmpv6_unreach(skb))
+	if (__in6_dev_get(skb->dev) &&
+	    !ipip6_err_gen_icmpv6_unreach(skb))
 		goto out;
=20
 	if (t->parms.iph.ttl =3D=3D 0 && type =3D=3D ICMP_TIME_EXCEEDED)
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 22b7bd8299ed..661252aeb7e0 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -82,8 +82,7 @@
 #define L2TP_SLFLAG_S	   0x40000000
 #define L2TP_SL_SEQ_MASK   0x00ffffff
=20
-#define L2TP_HDR_SIZE_SEQ		10
-#define L2TP_HDR_SIZE_NOSEQ		6
+#define L2TP_HDR_SIZE_MAX		14
=20
 /* Default trace flags */
 #define L2TP_DEFAULT_DEBUG_FLAGS	0
@@ -897,7 +896,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunne=
l, struct sk_buff *skb,
 	__skb_pull(skb, sizeof(struct udphdr));
=20
 	/* Short packet? */
-	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_SEQ)) {
+	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
 		l2tp_info(tunnel, L2TP_MSG_DATA,
 			  "%s: recv short packet (len=3D%d)\n",
 			  tunnel->name, skb->len);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d698d23dceed..7b057e323230 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1465,9 +1465,16 @@ static int ieee80211_skb_resize(struct ieee80211_sub=
_if_data *sdata,
 				int head_need, bool may_encrypt)
 {
 	struct ieee80211_local *local =3D sdata->local;
+	struct ieee80211_hdr *hdr;
+	bool enc_tailroom;
 	int tail_need =3D 0;
=20
-	if (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt) {
+	hdr =3D (struct ieee80211_hdr *) skb->data;
+	enc_tailroom =3D may_encrypt &&
+		       (sdata->crypto_tx_tailroom_needed_cnt ||
+			ieee80211_is_mgmt(hdr->frame_control));
+
+	if (enc_tailroom) {
 		tail_need =3D IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -=3D skb_tailroom(skb);
 		tail_need =3D max_t(int, tail_need, 0);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 92f32efde30b..b636ae55d8f0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1897,6 +1897,9 @@ static int nf_table_delrule_by_chain(struct nft_ctx *=
ctx)
 	int err;
=20
 	list_for_each_entry(rule, &ctx->chain->rules, list) {
+		if (!nft_rule_is_active_next(ctx->net, rule))
+			continue;
+
 		err =3D nf_tables_delrule_one(ctx, rule);
 		if (err < 0)
 			return err;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index cf8b3de56f63..0d2b40981c6c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -22,6 +22,30 @@
 #include <asm/uaccess.h> /* for set_fs */
 #include <net/netfilter/nf_tables.h>
=20
+struct nft_xt {
+	struct list_head	head;
+	struct nft_expr_ops	ops;
+	unsigned int		refcnt;
+
+	/* Unlike other expressions, ops doesn't have static storage duration.
+	 * nft core assumes they do.  We use kfree_rcu so that nft core can
+	 * can check expr->ops->size even after nft_compat->destroy() frees
+	 * the nft_xt struct that holds the ops structure.
+	 */
+	struct rcu_head		rcu_head;
+};
+
+static bool nft_xt_put(struct nft_xt *xt)
+{
+	if (--xt->refcnt =3D=3D 0) {
+		list_del(&xt->head);
+		kfree_rcu(xt, rcu_head);
+		return true;
+	}
+
+	return false;
+}
+
 union nft_entry {
 	struct ipt_entry e4;
 	struct ip6t_entry e6;
@@ -163,6 +187,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct=
 nft_expr *expr,
 	struct xt_target *target =3D expr->ops->data;
 	struct xt_tgchk_param par;
 	size_t size =3D XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
+	struct nft_xt *nft_xt;
 	u8 proto =3D 0;
 	bool inv =3D false;
 	union nft_entry e =3D {};
@@ -173,25 +198,22 @@ nft_target_init(const struct nft_ctx *ctx, const stru=
ct nft_expr *expr,
 	if (ctx->nla[NFTA_RULE_COMPAT]) {
 		ret =3D nft_parse_compat(ctx->nla[NFTA_RULE_COMPAT], &proto, &inv);
 		if (ret < 0)
-			goto err;
+			return ret;
 	}
=20
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
=20
 	ret =3D xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
-		goto err;
+		return ret;
=20
 	/* The standard target cannot be used */
-	if (target->target =3D=3D NULL) {
-		ret =3D -EINVAL;
-		goto err;
-	}
+	if (!target->target)
+		return -EINVAL;
=20
+	nft_xt =3D container_of(expr->ops, struct nft_xt, ops);
+	nft_xt->refcnt++;
 	return 0;
-err:
-	module_put(target->me);
-	return ret;
 }
=20
 static void
@@ -199,6 +221,7 @@ nft_target_destroy(const struct nft_ctx *ctx, const str=
uct nft_expr *expr)
 {
 	struct xt_target *target =3D expr->ops->data;
 	void *info =3D nft_expr_priv(expr);
+	struct module *me =3D target->me;
 	struct xt_tgdtor_param par;
=20
 	par.net =3D ctx->net;
@@ -208,7 +231,8 @@ nft_target_destroy(const struct nft_ctx *ctx, const str=
uct nft_expr *expr)
 	if (par.target->destroy !=3D NULL)
 		par.target->destroy(&par);
=20
-	module_put(target->me);
+	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
+		module_put(me);
 }
=20
 static int
@@ -368,6 +392,7 @@ nft_match_init(const struct nft_ctx *ctx, const struct =
nft_expr *expr,
 	struct xt_match *match =3D expr->ops->data;
 	struct xt_mtchk_param par;
 	size_t size =3D XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
+	struct nft_xt *nft_xt;
 	u8 proto =3D 0;
 	bool inv =3D false;
 	union nft_entry e =3D {};
@@ -378,19 +403,18 @@ nft_match_init(const struct nft_ctx *ctx, const struc=
t nft_expr *expr,
 	if (ctx->nla[NFTA_RULE_COMPAT]) {
 		ret =3D nft_parse_compat(ctx->nla[NFTA_RULE_COMPAT], &proto, &inv);
 		if (ret < 0)
-			goto err;
+			return ret;
 	}
=20
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
=20
 	ret =3D xt_check_match(&par, size, proto, inv);
 	if (ret < 0)
-		goto err;
+		return ret;
=20
+	nft_xt =3D container_of(expr->ops, struct nft_xt, ops);
+	nft_xt->refcnt++;
 	return 0;
-err:
-	module_put(match->me);
-	return ret;
 }
=20
 static void
@@ -408,7 +432,8 @@ nft_match_destroy(const struct nft_ctx *ctx, const stru=
ct nft_expr *expr)
 	if (par.match->destroy !=3D NULL)
 		par.match->destroy(&par);
=20
-	module_put(me);
+	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
+		module_put(me);
 }
=20
 static int
@@ -606,11 +631,6 @@ static const struct nfnetlink_subsystem nfnl_compat_su=
bsys =3D {
=20
 static LIST_HEAD(nft_match_list);
=20
-struct nft_xt {
-	struct list_head	head;
-	struct nft_expr_ops	ops;
-};
-
 static struct nft_expr_type nft_match_type;
=20
 static bool nft_match_cmp(const struct xt_match *match,
@@ -642,12 +662,8 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	list_for_each_entry(nft_match, &nft_match_list, head) {
 		struct xt_match *match =3D nft_match->ops.data;
=20
-		if (nft_match_cmp(match, mt_name, rev, family)) {
-			if (!try_module_get(match->me))
-				return ERR_PTR(-ENOENT);
-
+		if (nft_match_cmp(match, mt_name, rev, family))
 			return &nft_match->ops;
-		}
 	}
=20
 	match =3D xt_request_find_match(family, mt_name, rev);
@@ -659,6 +675,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	if (nft_match =3D=3D NULL)
 		return ERR_PTR(-ENOMEM);
=20
+	nft_match->refcnt =3D 0;
 	nft_match->ops.type =3D &nft_match_type;
 	nft_match->ops.size =3D NFT_EXPR_SIZE(XT_ALIGN(match->matchsize) +
 					    nft_compat_match_offset(match));
@@ -674,14 +691,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	return &nft_match->ops;
 }
=20
-static void nft_match_release(void)
-{
-	struct nft_xt *nft_match, *tmp;
-
-	list_for_each_entry_safe(nft_match, tmp, &nft_match_list, head)
-		kfree(nft_match);
-}
-
 static struct nft_expr_type nft_match_type __read_mostly =3D {
 	.name		=3D "match",
 	.select_ops	=3D nft_match_select_ops,
@@ -723,12 +732,8 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target =3D nft_target->ops.data;
=20
-		if (nft_target_cmp(target, tg_name, rev, family)) {
-			if (!try_module_get(target->me))
-				return ERR_PTR(-ENOENT);
-
+		if (nft_target_cmp(target, tg_name, rev, family))
 			return &nft_target->ops;
-		}
 	}
=20
 	target =3D xt_request_find_target(family, tg_name, rev);
@@ -740,6 +745,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	if (nft_target =3D=3D NULL)
 		return ERR_PTR(-ENOMEM);
=20
+	nft_target->refcnt =3D 0;
 	nft_target->ops.type =3D &nft_target_type;
 	nft_target->ops.size =3D NFT_EXPR_SIZE(XT_ALIGN(target->targetsize) +
 					     nft_compat_target_offset(target));
@@ -755,14 +761,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	return &nft_target->ops;
 }
=20
-static void nft_target_release(void)
-{
-	struct nft_xt *nft_target, *tmp;
-
-	list_for_each_entry_safe(nft_target, tmp, &nft_target_list, head)
-		kfree(nft_target);
-}
-
 static struct nft_expr_type nft_target_type __read_mostly =3D {
 	.name		=3D "target",
 	.select_ops	=3D nft_target_select_ops,
@@ -802,11 +800,35 @@ static int __init nft_compat_module_init(void)
=20
 static void __exit nft_compat_module_exit(void)
 {
+	struct nft_xt *xt, *next;
+
+	/* list should be empty here, it can be non-empty only in case there
+	 * was an error that caused nft_xt expr to not be initialized fully
+	 * and noone else requested the same expression later.
+	 *
+	 * In this case, the lists contain 0-refcount entries that still
+	 * hold module reference.
+	 */
+	list_for_each_entry_safe(xt, next, &nft_target_list, head) {
+		struct xt_target *target =3D xt->ops.data;
+
+		if (WARN_ON_ONCE(xt->refcnt))
+			continue;
+		module_put(target->me);
+		kfree(xt);
+	}
+
+	list_for_each_entry_safe(xt, next, &nft_match_list, head) {
+		struct xt_match *match =3D xt->ops.data;
+
+		if (WARN_ON_ONCE(xt->refcnt))
+			continue;
+		module_put(match->me);
+		kfree(xt);
+	}
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
-	nft_match_release();
-	nft_target_release();
 }
=20
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 1e7245792fc0..b8fd2ec3fae0 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -418,6 +418,10 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 						      sock->service_name,
 						      sock->service_name_len,
 						      &service_name_tlv_length);
+		if (!service_name_tlv) {
+			err =3D -ENOMEM;
+			goto error_tlv;
+		}
 		size +=3D service_name_tlv_length;
 	}
=20
@@ -428,9 +432,17 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
=20
 	miux_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0,
 				      &miux_tlv_length);
+	if (!miux_tlv) {
+		err =3D -ENOMEM;
+		goto error_tlv;
+	}
 	size +=3D miux_tlv_length;
=20
 	rw_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_RW, &rw, 0, &rw_tlv_length);
+	if (!rw_tlv) {
+		err =3D -ENOMEM;
+		goto error_tlv;
+	}
 	size +=3D rw_tlv_length;
=20
 	pr_debug("SKB size %d SN length %zu\n", size, sock->service_name_len);
@@ -484,9 +496,17 @@ int nfc_llcp_send_cc(struct nfc_llcp_sock *sock)
=20
 	miux_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0,
 				      &miux_tlv_length);
+	if (!miux_tlv) {
+		err =3D -ENOMEM;
+		goto error_tlv;
+	}
 	size +=3D miux_tlv_length;
=20
 	rw_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_RW, &rw, 0, &rw_tlv_length);
+	if (!rw_tlv) {
+		err =3D -ENOMEM;
+		goto error_tlv;
+	}
 	size +=3D rw_tlv_length;
=20
 	skb =3D llcp_allocate_pdu(sock, LLCP_PDU_CC, size);
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 51e788797317..f271e38d72b7 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -531,10 +531,10 @@ static u8 nfc_llcp_reserve_sdp_ssap(struct nfc_llcp_l=
ocal *local)
=20
 static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 {
-	u8 *gb_cur, *version_tlv, version, version_length;
-	u8 *lto_tlv, lto_length;
-	u8 *wks_tlv, wks_length;
-	u8 *miux_tlv, miux_length;
+	u8 *gb_cur, version, version_length;
+	u8 lto_length, wks_length, miux_length;
+	u8 *version_tlv =3D NULL, *lto_tlv =3D NULL,
+	   *wks_tlv =3D NULL, *miux_tlv =3D NULL;
 	__be16 wks =3D cpu_to_be16(local->local_wks);
 	u8 gb_len =3D 0;
 	int ret =3D 0;
@@ -542,17 +542,33 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *l=
ocal)
 	version =3D LLCP_VERSION_11;
 	version_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_VERSION, &version,
 					 1, &version_length);
+	if (!version_tlv) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
 	gb_len +=3D version_length;
=20
 	lto_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_LTO, &local->lto, 1, &lto_length);
+	if (!lto_tlv) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
 	gb_len +=3D lto_length;
=20
 	pr_debug("Local wks 0x%lx\n", local->local_wks);
 	wks_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_WKS, (u8 *)&wks, 2, &wks_length);
+	if (!wks_tlv) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
 	gb_len +=3D wks_length;
=20
 	miux_tlv =3D nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&local->miux, 0,
 				      &miux_length);
+	if (!miux_tlv) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
 	gb_len +=3D miux_length;
=20
 	gb_len +=3D ARRAY_SIZE(llcp_magic);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f9a1f459f6b2..20a844788443 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2299,8 +2299,10 @@ static int tpacket_snd(struct packet_sock *po, struc=
t msghdr *msg)
 						sll_addr)))
 			goto out;
 		proto	=3D saddr->sll_protocol;
-		addr	=3D saddr->sll_addr;
+		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev =3D dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
+		if (addr && dev && saddr->sll_halen < dev->addr_len)
+			goto out_put;
 	}
=20
 	err =3D -ENXIO;
@@ -2459,8 +2461,10 @@ static int packet_snd(struct socket *sock, struct ms=
ghdr *msg, size_t len)
 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, =
sll_addr)))
 			goto out;
 		proto	=3D saddr->sll_protocol;
-		addr	=3D saddr->sll_addr;
+		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev =3D dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
+		if (addr && dev && saddr->sll_halen < dev->addr_len)
+			goto out_unlock;
 	}
=20
 	err =3D -ENXIO;
@@ -3824,7 +3828,7 @@ static struct pgv *alloc_pg_vec(struct tpacket_req *r=
eq, int order)
 	struct pgv *pg_vec;
 	int i;
=20
-	pg_vec =3D kcalloc(block_nr, sizeof(struct pgv), GFP_KERNEL);
+	pg_vec =3D kcalloc(block_nr, sizeof(struct pgv), GFP_KERNEL | __GFP_NOWAR=
N);
 	if (unlikely(!pg_vec))
 		goto out;
=20
@@ -3911,7 +3915,7 @@ static int packet_set_ring(struct sock *sk, union tpa=
cket_req_u *req_u,
 		rb->frames_per_block =3D req->tp_block_size/req->tp_frame_size;
 		if (unlikely(rb->frames_per_block <=3D 0))
 			goto out;
-		if (unlikely(req->tp_block_size > UINT_MAX / req->tp_block_nr))
+		if (unlikely(rb->frames_per_block > UINT_MAX / req->tp_block_nr))
 			goto out;
 		if (unlikely((rb->frames_per_block * req->tp_block_nr) !=3D
 					req->tp_frame_nr))
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index afdd343ad826..fdfa47401464 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -444,6 +444,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 	int nb =3D 0;
 	int count =3D 1;
 	int rc =3D NET_XMIT_SUCCESS;
+	int rc_drop =3D NET_XMIT_DROP;
=20
 	/* Random duplication */
 	if (q->duplicate && q->duplicate >=3D get_crandom(&q->dup_cor))
@@ -480,6 +481,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
=20
 		qdisc_enqueue_root(skb2, rootq);
 		q->duplicate =3D dupsave;
+		rc_drop =3D NET_XMIT_SUCCESS;
 	}
=20
 	/*
@@ -492,7 +494,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch)
 		if (skb_is_gso(skb)) {
 			segs =3D netem_segment(skb, sch);
 			if (!segs)
-				return NET_XMIT_DROP;
+				return rc_drop;
 		} else {
 			segs =3D skb;
 		}
@@ -514,8 +516,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch)
 	if (unlikely(skb_queue_len(&sch->q) >=3D sch->limit)) {
 		/* qdisc_reshape_fail() can't handle segmented skb */
 		if (segs)
-			return qdisc_drop_all(skb, sch);
-		return qdisc_reshape_fail(skb, sch);
+			qdisc_drop_all(skb, sch);
+		else if (qdisc_reshape_fail(skb, sch) =3D=3D NET_XMIT_SUCCESS)
+			return NET_XMIT_SUCCESS;
+		return rc_drop;
 	}
=20
 	sch->qstats.backlog +=3D qdisc_pkt_len(skb);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 28a8e0b924db..186c559a2c0b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1658,6 +1658,10 @@ static void vmci_transport_cleanup(struct work_struc=
t *work)
=20
 static void vmci_transport_destruct(struct vsock_sock *vsk)
 {
+	/* transport can be NULL if we hit a failure at init() time */
+	if (!vmci_trans(vsk))
+		return;
+
 	/* Ensure that the detach callback doesn't use the sk/vsk
 	 * we are about to destruct.
 	 */
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 5ad4418ef093..ca057b32c548 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -680,8 +680,7 @@ static int x25_bind(struct socket *sock, struct sockadd=
r *uaddr, int addr_len)
 	struct sockaddr_x25 *addr =3D (struct sockaddr_x25 *)uaddr;
 	int len, i, rc =3D 0;
=20
-	if (!sock_flag(sk, SOCK_ZAPPED) ||
-	    addr_len !=3D sizeof(struct sockaddr_x25) ||
+	if (addr_len !=3D sizeof(struct sockaddr_x25) ||
 	    addr->sx25_family !=3D AF_X25) {
 		rc =3D -EINVAL;
 		goto out;
@@ -696,9 +695,13 @@ static int x25_bind(struct socket *sock, struct sockad=
dr *uaddr, int addr_len)
 	}
=20
 	lock_sock(sk);
-	x25_sk(sk)->source_addr =3D addr->sx25_addr;
-	x25_insert_socket(sk);
-	sock_reset_flag(sk, SOCK_ZAPPED);
+	if (sock_flag(sk, SOCK_ZAPPED)) {
+		x25_sk(sk)->source_addr =3D addr->sx25_addr;
+		x25_insert_socket(sk);
+		sock_reset_flag(sk, SOCK_ZAPPED);
+	} else {
+		rc =3D -EINVAL;
+	}
 	release_sock(sk);
 	SOCK_DEBUG(sk, "x25_bind: socket is bound\n");
 out:
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index dc7aa45e80ce..49fae20e61e0 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -121,8 +121,8 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 			fprintf(stderr, "Read error or end of file.\n");
 		return -1;
 	}
-	if (strlen(str) > KSYM_NAME_LEN) {
-		fprintf(stderr, "Symbol %s too long for kallsyms (%zu vs %d).\n"
+	if (strlen(str) >=3D KSYM_NAME_LEN) {
+		fprintf(stderr, "Symbol %s too long for kallsyms (%zu >=3D %d).\n"
 				"Please increase KSYM_NAME_LEN both in kernel and kallsyms.c\n",
 			str, strlen(str), KSYM_NAME_LEN);
 		return -1;
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 7db9954f1af2..885804062795 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -794,6 +794,7 @@ static struct aa_fs_entry aa_fs_entry_domain[] =3D {
 	AA_FS_FILE_BOOLEAN("change_hatv",	1),
 	AA_FS_FILE_BOOLEAN("change_onexec",	1),
 	AA_FS_FILE_BOOLEAN("change_profile",	1),
+	AA_FS_FILE_BOOLEAN("fix_binfmt_elf_mmap",	1),
 	{ }
 };
=20
diff --git a/security/keys/key.c b/security/keys/key.c
index c55a01471ea2..e766e3511111 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -260,8 +260,8 @@ struct key *key_alloc(struct key_type *type, const char=
 *desc,
=20
 		spin_lock(&user->lock);
 		if (!(flags & KEY_ALLOC_QUOTA_OVERRUN)) {
-			if (user->qnkeys + 1 >=3D maxkeys ||
-			    user->qnbytes + quotalen >=3D maxbytes ||
+			if (user->qnkeys + 1 > maxkeys ||
+			    user->qnbytes + quotalen > maxbytes ||
 			    user->qnbytes + quotalen < user->qnbytes)
 				goto no_quota;
 		}
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 0fa27abd3777..f906d73c2596 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -604,9 +604,6 @@ static bool search_nested_keyrings(struct key *keyring,
 	       ctx->index_key.type->name,
 	       ctx->index_key.description);
=20
-	if (ctx->index_key.description)
-		ctx->index_key.desc_len =3D strlen(ctx->index_key.description);
-
 	/* Check to see if this top-level keyring is what we are looking for
 	 * and whether it is valid or not.
 	 */
@@ -870,6 +867,7 @@ key_ref_t keyring_search(key_ref_t keyring,
 	struct keyring_search_context ctx =3D {
 		.index_key.type		=3D type,
 		.index_key.description	=3D description,
+		.index_key.desc_len	=3D strlen(description),
 		.cred			=3D current_cred(),
 		.match			=3D type->match,
 		.match_data		=3D description,
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 62a86e8cb907..35a9e3bef76f 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -191,9 +191,8 @@ static int proc_keys_show(struct seq_file *m, void *v)
 	int rc;
=20
 	struct keyring_search_context ctx =3D {
-		.index_key.type		=3D key->type,
-		.index_key.description	=3D key->description,
-		.cred			=3D current_cred(),
+		.index_key		=3D key->index_key,
+		.cred			=3D m->file->f_cred,
 		.match			=3D lookup_user_key_possessed,
 		.match_data		=3D key,
 		.flags			=3D (KEYRING_SEARCH_NO_STATE_CHECK |
@@ -213,11 +212,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 		}
 	}
=20
-	/* check whether the current task is allowed to view the key (assuming
-	 * non-possession)
-	 * - the caller holds a spinlock, and thus the RCU read lock, making our
-	 *   access to __current_cred() safe
-	 */
+	/* check whether the current task is allowed to view the key */
 	rc =3D key_task_permission(key_ref, ctx.cred, KEY_NEED_VIEW);
 	if (rc < 0)
 		return 0;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index c120a393ff2d..55ca39acb49e 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -561,6 +561,7 @@ struct key *request_key_and_link(struct key_type *type,
 	struct keyring_search_context ctx =3D {
 		.index_key.type		=3D type,
 		.index_key.description	=3D description,
+		.index_key.desc_len	=3D strlen(description),
 		.cred			=3D current_cred(),
 		.match			=3D type->match,
 		.match_data		=3D description,
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_a=
uth.c
index 74e3fe9b47be..ac4a90b494e6 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -233,7 +233,7 @@ struct key *key_get_instantiation_authkey(key_serial_t =
target_id)
 	struct key *authkey;
 	key_ref_t authkey_ref;
=20
-	sprintf(description, "%x", target_id);
+	ctx.index_key.desc_len =3D sprintf(description, "%x", target_id);
=20
 	authkey_ref =3D search_process_keyrings(&ctx);
=20
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 0038834b558e..6da531603614 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -299,7 +299,9 @@ int yama_ptrace_access_check(struct task_struct *child,
 			break;
 		case YAMA_SCOPE_RELATIONAL:
 			rcu_read_lock();
-			if (!task_is_descendant(current, child) &&
+			if (!pid_alive(child))
+				rc =3D -EPERM;
+			if (!rc && !task_is_descendant(current, child) &&
 			    !ptracer_exception_found(current, child) &&
 			    !ns_capable(__task_cred(child)->user_ns, CAP_SYS_PTRACE))
 				rc =3D -EPERM;
diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 1c4a0fb3ffef..c3f908de083f 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -899,6 +899,9 @@ int cs46xx_dsp_proc_done (struct snd_cs46xx *chip)
 	struct dsp_spos_instance * ins =3D chip->dsp_spos_instance;
 	int i;
=20
+	if (!ins)
+		return 0;
+
 	snd_info_free_entry(ins->proc_sym_info_entry);
 	ins->proc_sym_info_entry =3D NULL;
=20
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic3=
2x4.c
index 1d9b117345a3..4b3f7504e0b2 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -534,6 +534,10 @@ static int aic32x4_set_bias_level(struct snd_soc_codec=
 *codec,
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
+		/* Initial cold start */
+		if (codec->dapm.bias_level =3D=3D SND_SOC_BIAS_OFF)
+			break;
+
 		/* Switch off BCLK_N Divider */
 		snd_soc_update_bits(codec, AIC32X4_BCLKN,
 				    AIC32X4_BCLKEN, 0);
diff --git a/sound/soc/intel/sst-mfld-platform-pcm.c b/sound/soc/intel/sst-=
mfld-platform-pcm.c
index 7c790f51d259..47a2c3f5fa45 100644
--- a/sound/soc/intel/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/sst-mfld-platform-pcm.c
@@ -383,7 +383,13 @@ static snd_pcm_uframes_t sst_platform_pcm_pointer
 static int sst_platform_pcm_hw_params(struct snd_pcm_substream *substream,
 		struct snd_pcm_hw_params *params)
 {
-	snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(params));
+	int ret;
+
+	ret =3D
+		snd_pcm_lib_malloc_pages(substream,
+				params_buffer_bytes(params));
+	if (ret)
+		return ret;
 	memset(substream->runtime->dma_area, 0, params_buffer_bytes(params));
=20
 	return 0;
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 7b56673170c0..cbb98d63585c 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -258,6 +258,11 @@ static int snd_usb_create_streams(struct snd_usb_audio=
 *chip, int ctrlif)
 			return -EINVAL;
 		}
=20
+		if (h1->bLength < sizeof(*h1)) {
+			dev_err(&dev->dev, "cannot find UAC_HEADER\n");
+			return -EINVAL;
+		}
+
 		if (!h1->bInCollection) {
 			dev_info(&dev->dev, "skipping empty audio interface (v1)\n");
 			return -EINVAL;
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index caf392f2aea0..538df481fe5e 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1787,7 +1787,7 @@ static int build_audio_procunit(struct mixer_build *s=
tate, int unitid,
 				char *name)
 {
 	struct uac_processing_unit_descriptor *desc =3D raw_desc;
-	int num_ins =3D desc->bNrInPins;
+	int num_ins;
 	struct usb_mixer_elem_info *cval;
 	struct snd_kcontrol *kctl;
 	int i, err, nameid, type, len;
@@ -1802,7 +1802,13 @@ static int build_audio_procunit(struct mixer_build *=
state, int unitid,
 		0, NULL, default_value_info
 	};
=20
-	if (desc->bLength < 13 || desc->bLength < 13 + num_ins ||
+	if (desc->bLength < 13) {
+		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unit=
id);
+		return -EINVAL;
+	}
+
+	num_ins =3D desc->bNrInPins;
+	if (desc->bLength < 13 + num_ins ||
 	    desc->bLength < num_ins + uac_processing_unit_bControlSize(desc, stat=
e->mixer->protocol)) {
 		usb_audio_err(state->chip, "invalid %s descriptor (id %d)\n", name, unit=
id);
 		return -EINVAL;
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index e4e4a7e3a96c..63d5303cc868 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -313,6 +313,9 @@ static int search_roland_implicit_fb(struct usb_device =
*dev, int ifnum,
 	return 0;
 }
=20
+/* Setup an implicit feedback endpoint from a quirk. Returns 0 if no quirk
+ * applies. Returns 1 if a quirk was found.
+ */
 static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 					 struct usb_device *dev,
 					 struct usb_interface_descriptor *altsd,
@@ -381,7 +384,7 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb=
_substream *subs,
=20
 	subs->data_endpoint->sync_master =3D subs->sync_endpoint;
=20
-	return 0;
+	return 1;
 }
=20
 static int set_sync_endpoint(struct snd_usb_substream *subs,
@@ -406,6 +409,10 @@ static int set_sync_endpoint(struct snd_usb_substream =
*subs,
 	if (err < 0)
 		return err;
=20
+	/* endpoint set by quirk */
+	if (err > 0)
+		return 0;
+
 	if (altsd->bNumEndpoints < 2)
 		return 0;
=20
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 53c171f26b7b..d279c4c71aad 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3304,6 +3304,12 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q=
"),
 					}
 				}
 			},
+			{
+				.ifnum =3D -1
+			},
+			{
+				.ifnum =3D -1
+			},
 		}
 	}
 },
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 25e8075f9ea3..a4e798c9f3ed 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -412,12 +412,8 @@ static int parse_uac_endpoint_attributes(struct snd_us=
b_audio *chip,
 		csep =3D snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_=
ENDPOINT);
=20
 	if (!csep || csep->bLength < 7 ||
-	    csep->bDescriptorSubtype !=3D UAC_EP_GENERAL) {
-		usb_audio_warn(chip,
-			       "%u:%d : no or invalid class specific endpoint descriptor\n",
-			       iface_no, altsd->bAlternateSetting);
-		return 0;
-	}
+	    csep->bDescriptorSubtype !=3D UAC_EP_GENERAL)
+		goto error;
=20
 	if (protocol =3D=3D UAC_VERSION_1) {
 		attributes =3D csep->bmAttributes;
@@ -425,6 +421,8 @@ static int parse_uac_endpoint_attributes(struct snd_usb=
_audio *chip,
 		struct uac2_iso_endpoint_descriptor *csep2 =3D
 			(struct uac2_iso_endpoint_descriptor *) csep;
=20
+		if (csep2->bLength < sizeof(*csep2))
+			goto error;
 		attributes =3D csep->bmAttributes & UAC_EP_CS_ATTR_FILL_MAX;
=20
 		/* emulate the endpoint attributes of a v1 device */
@@ -433,6 +431,12 @@ static int parse_uac_endpoint_attributes(struct snd_us=
b_audio *chip,
 	}
=20
 	return attributes;
+
+ error:
+	usb_audio_warn(chip,
+		       "%u:%d : no or invalid class specific endpoint descriptor\n",
+		       iface_no, altsd->bAlternateSetting);
+	return 0;
 }
=20
 /* find an input terminal descriptor (either UAC1 or UAC2) with the given
@@ -440,13 +444,17 @@ static int parse_uac_endpoint_attributes(struct snd_u=
sb_audio *chip,
  */
 static void *
 snd_usb_find_input_terminal_descriptor(struct usb_host_interface *ctrl_ifa=
ce,
-					       int terminal_id)
+				       int terminal_id, bool uac2)
 {
 	struct uac2_input_terminal_descriptor *term =3D NULL;
+	size_t minlen =3D uac2 ? sizeof(struct uac2_input_terminal_descriptor) :
+		sizeof(struct uac_input_terminal_descriptor);
=20
 	while ((term =3D snd_usb_find_csint_desc(ctrl_iface->extra,
 					       ctrl_iface->extralen,
 					       term, UAC_INPUT_TERMINAL))) {
+		if (term->bLength < minlen)
+			continue;
 		if (term->bTerminalID =3D=3D terminal_id)
 			return term;
 	}
@@ -463,7 +471,8 @@ static struct uac2_output_terminal_descriptor *
 	while ((term =3D snd_usb_find_csint_desc(ctrl_iface->extra,
 					       ctrl_iface->extralen,
 					       term, UAC_OUTPUT_TERMINAL))) {
-		if (term->bTerminalID =3D=3D terminal_id)
+		if (term->bLength >=3D sizeof(*term) &&
+		    term->bTerminalID =3D=3D terminal_id)
 			return term;
 	}
=20
@@ -561,7 +570,8 @@ int snd_usb_parse_audio_interface(struct snd_usb_audio =
*chip, int iface_no)
 			format =3D le16_to_cpu(as->wFormatTag); /* remember the format value */
=20
 			iterm =3D snd_usb_find_input_terminal_descriptor(chip->ctrl_intf,
-								       as->bTerminalLink);
+								       as->bTerminalLink,
+								       false);
 			if (iterm) {
 				num_channels =3D iterm->bNrChannels;
 				chconfig =3D le16_to_cpu(iterm->wChannelConfig);
@@ -597,7 +607,8 @@ int snd_usb_parse_audio_interface(struct snd_usb_audio =
*chip, int iface_no)
 			/* lookup the terminal associated to this interface
 			 * to extract the clock */
 			input_term =3D snd_usb_find_input_terminal_descriptor(chip->ctrl_intf,
-									    as->bTerminalLink);
+									    as->bTerminalLink,
+									    true);
 			if (input_term) {
 				clock =3D input_term->bCSourceID;
 				if (!chconfig && (num_channels =3D=3D input_term->bNrChannels))
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-=
sched.c
index 35d7fdb2328d..c81bd9a31db7 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -14,7 +14,7 @@ static int perf_evsel__test_field(struct perf_evsel *evse=
l, const char *name,
 		return -1;
 	}
=20
-	is_signed =3D !!(field->flags | FIELD_IS_SIGNED);
+	is_signed =3D !!(field->flags & FIELD_IS_SIGNED);
 	if (should_be_signed && !is_signed) {
 		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
 			 evsel->name, name, is_signed, should_be_signed);
@@ -40,7 +40,7 @@ int test__perf_evsel__tp_sched_test(void)
 		return -1;
 	}
=20
-	if (perf_evsel__test_field(evsel, "prev_comm", 16, true))
+	if (perf_evsel__test_field(evsel, "prev_comm", 16, false))
 		ret =3D -1;
=20
 	if (perf_evsel__test_field(evsel, "prev_pid", 4, true))
@@ -52,7 +52,7 @@ int test__perf_evsel__tp_sched_test(void)
 	if (perf_evsel__test_field(evsel, "prev_state", sizeof(long), true))
 		ret =3D -1;
=20
-	if (perf_evsel__test_field(evsel, "next_comm", 16, true))
+	if (perf_evsel__test_field(evsel, "next_comm", 16, false))
 		ret =3D -1;
=20
 	if (perf_evsel__test_field(evsel, "next_pid", 4, true))
@@ -65,7 +65,7 @@ int test__perf_evsel__tp_sched_test(void)
=20
 	evsel =3D perf_evsel__newtp("sched", "sched_wakeup");
=20
-	if (perf_evsel__test_field(evsel, "comm", 16, true))
+	if (perf_evsel__test_field(evsel, "comm", 16, false))
 		ret =3D -1;
=20
 	if (perf_evsel__test_field(evsel, "pid", 4, true))

--p355lqk3xfcokp2m--

--e3b2p4nv2qz7a3oz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzME0EACgkQ57/I7JWG
EQlAqhAAmaea9I3leY6kpVcnidRM20EN+JIg1Js9mBb6TZt2A/7V9IW1TeN5owwV
UlJ8BiJJN18xucoMrEAxnCF7EYtSHjxyC7uddhMxH+WujE7MuhrL0yLzElEtP3jy
ymnpmdPOxaTX46WsaknPuF1fmIu3hw5s8OH+WlBzDIXuNqJQCWg5JhyeJT+mFlCc
UiijRajMxSUgsLQpnB3FJ5FId1QRbzh/wIRsSsYUU+NEx1XAq6v48FhNgEt7MQg4
kz2qI/gzf4EiV4Q0yhJb4Zv8aQhUjHFNJfhS6yLK+XXBngmn9WQqRy4XYJjSjsbn
P5mSRDHOCXn9JHurE1sx30JZPIxPNAxzh66H/XAXIElYjWKAlwNN6hkU0IIvaRC2
gBPurdVoOhym1qTd6qr+hzoBor7mg4+rQmd5WGKs1s/xotR3s8TUc5onh4Sl/rM3
zDMwcYWFQrn7A2nxiiRvHIhr1O0eCtAp6OawtUw/zxOXwbA9VLgzSjXMd6TZM2gf
iiIk3ZVBQ45sQ/l3kcxVd2jkEDN3tv9oRZuOkuL/s0rczGfZqc4GS/Q6HAXMawLa
BGKk3jnR3aZ2CbZ3fKrOFoUbZoQYqdmwsQBpkCXtSMTMI22t2AVDDUBRovbBMzAY
mH/ewUruoclwKcYra50SWLar4Rz0Piq+Tred7fmcIj+d5PZMjqs=
=OaGH
-----END PGP SIGNATURE-----

--e3b2p4nv2qz7a3oz--
