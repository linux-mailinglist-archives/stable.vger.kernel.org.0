Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3664692
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfGJM65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:58:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfGJM65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 08:58:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BD620651;
        Wed, 10 Jul 2019 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562763535;
        bh=6AtewLWlddcCOm1pOq55eOsfQ/Nnad0nGoSygHP/nNo=;
        h=Date:From:To:Cc:Subject:From;
        b=pQ/GqDjU0IgoIlQ1AJPU+PGN6jukXjcSU7790u5vK2NKspUMD+6TdP09bguLoxphi
         QtwwxqV9PgcK7s7IKdet8S/u5vGVITquhKNctGYUuDaMXgzocXA9FZESu7MtAPXKZt
         fOZ5p3d/3ftjbuPZ3CMPphNV/kFXhr7WCKTeT5rY=
Date:   Wed, 10 Jul 2019 14:58:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.185
Message-ID: <20190710125852.GA10050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.185 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    4 +-
 arch/arc/Kconfig                                 |    8 -----
 arch/arc/Makefile                                |    4 --
 arch/arc/include/asm/bug.h                       |    3 +
 arch/arc/include/asm/elf.h                       |    2 -
 arch/arc/kernel/setup.c                          |    2 -
 arch/arc/kernel/traps.c                          |    8 +++++
 arch/arm/mach-imx/cpuidle-imx6sx.c               |    3 +
 arch/arm64/kernel/vdso.c                         |   10 +++---
 arch/ia64/include/asm/bug.h                      |    6 +++
 arch/m68k/include/asm/bug.h                      |    3 +
 arch/mips/Kconfig                                |    1 
 arch/mips/include/asm/compiler.h                 |   35 +++++++++++++++++++++++
 arch/mips/kernel/uprobes.c                       |    3 -
 arch/mips/math-emu/cp1emu.c                      |    4 +-
 arch/parisc/math-emu/cnv_float.h                 |    8 ++---
 arch/sparc/include/asm/bug.h                     |    6 +++
 arch/sparc/kernel/perf_event.c                   |    4 ++
 arch/um/os-Linux/file.c                          |    1 
 arch/um/os-Linux/signal.c                        |    2 +
 arch/x86/kernel/cpu/bugs.c                       |   11 ++++++-
 arch/x86/kvm/x86.c                               |    9 +++--
 arch/x86/um/stub_segv.c                          |    1 
 crypto/crypto_user.c                             |    3 +
 drivers/dma/imx-sdma.c                           |    4 +-
 drivers/hwmon/pmbus/pmbus_core.c                 |   34 +++++++++++++++++++---
 drivers/input/misc/uinput.c                      |   22 +++++++++++++-
 drivers/mfd/omap-usb-tll.c                       |    4 +-
 drivers/net/bonding/bond_main.c                  |    2 -
 drivers/net/can/flexcan.c                        |    2 -
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |    4 ++
 drivers/net/team/team.c                          |    2 -
 drivers/parport/share.c                          |    2 +
 drivers/s390/net/qeth_l2_main.c                  |    2 -
 drivers/scsi/hpsa.c                              |    7 +++-
 drivers/scsi/hpsa_cmd.h                          |    1 
 drivers/scsi/ufs/ufshcd.c                        |    3 +
 drivers/scsi/vmw_pvscsi.c                        |    6 ++-
 drivers/spi/spi-bitbang.c                        |    2 -
 drivers/staging/rdma/hfi1/chip.c                 |    1 
 drivers/tty/rocket.c                             |    2 -
 drivers/usb/chipidea/udc.c                       |   20 +++++++++++++
 drivers/usb/gadget/udc/fusb300_udc.c             |    5 +++
 drivers/usb/gadget/udc/lpc32xx_udc.c             |    3 -
 fs/9p/acl.c                                      |    2 -
 fs/binfmt_flat.c                                 |   24 ++++-----------
 fs/btrfs/dev-replace.c                           |   29 ++++++++++++-------
 fs/btrfs/reada.c                                 |    7 ++++
 fs/btrfs/volumes.c                               |    2 +
 fs/btrfs/volumes.h                               |    5 +++
 fs/cifs/smb2maperror.c                           |    2 -
 fs/overlayfs/inode.c                             |   13 ++++++++
 include/asm-generic/bug.h                        |    1 
 include/linux/compiler-gcc.h                     |   15 +++++++++
 include/linux/compiler.h                         |    5 +++
 include/linux/swiotlb.h                          |    3 +
 include/net/bluetooth/hci_core.h                 |    3 +
 include/net/busy_poll.h                          |    2 -
 kernel/cpu.c                                     |    3 +
 kernel/ptrace.c                                  |    4 --
 kernel/trace/trace.c                             |    6 ---
 kernel/trace/trace.h                             |   18 +++++++++++
 kernel/trace/trace_kdb.c                         |    6 ---
 lib/mpi/mpi-pow.c                                |    6 +--
 mm/page_idle.c                                   |    4 +-
 net/9p/protocol.c                                |   12 +++++--
 net/9p/trans_common.c                            |    1 
 net/9p/trans_rdma.c                              |    7 +---
 net/bluetooth/hci_conn.c                         |   10 +++++-
 net/bluetooth/l2cap_core.c                       |   33 ++++++++++++++++++---
 net/can/af_can.c                                 |    1 
 net/ipv4/raw.c                                   |    2 -
 net/mac80211/rx.c                                |    2 +
 net/sctp/endpointola.c                           |    8 ++---
 net/tipc/core.c                                  |   12 +++----
 net/tipc/netlink_compat.c                        |   18 +++++++++--
 net/wireless/core.c                              |    2 -
 scripts/checkstack.pl                            |    2 -
 security/apparmor/policy_unpack.c                |    2 -
 sound/core/seq/oss/seq_oss_ioctl.c               |    2 -
 sound/core/seq/oss/seq_oss_rw.c                  |    2 -
 sound/firewire/amdtp-am824.c                     |    2 -
 sound/soc/codecs/cs4265.c                        |    2 -
 sound/soc/codecs/max98090.c                      |   16 ++++++++++
 sound/usb/mixer_quirks.c                         |    4 +-
 tools/perf/builtin-help.c                        |    2 -
 tools/perf/ui/tui/helpline.c                     |    2 -
 87 files changed, 423 insertions(+), 150 deletions(-)

Adeodato Simó (1):
      net/9p: include trans_common.h to fix missing prototype warning.

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Alexandre Belloni (1):
      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Arnaldo Carvalho de Melo (2):
      perf ui helpline: Use strlcpy() as a shorter form of strncpy() + explicit set nul
      perf help: Remove needless use of strncpy()

Arnd Bergmann (2):
      mfd: omap-usb-tll: Fix register offsets
      bug.h: work around GCC PR82365 in BUG()

Avri Altman (1):
      scsi: ufs: Check that space was properly alloced in copy_query_response

Colin Ian King (3):
      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
      ALSA: usb-audio: fix sign unintended sign extension on left shifts

Dominique Martinet (4):
      9p/rdma: do not disconnect on down_interruptible EAGAIN
      9p: acl: fix uninitialized iattr access
      9p/rdma: remove useless check in cm_event_handler
      9p: p9dirent_read: check network-provided name length

Don Brace (1):
      scsi: hpsa: correct ioaccel2 chaining

Eric Biggers (2):
      cfg80211: fix memory leak of wiphy device name
      crypto: user - prevent operating on larval algorithms

Fabio Estevam (1):
      ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Filipe Manana (1):
      Btrfs: fix race between readahead and device replace/removal

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations= parameter

George G. Davis (1):
      scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Greg Kroah-Hartman (1):
      Linux 4.4.185

Helge Deller (1):
      parisc: Fix compiler warnings in float emulation code

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jann Horn (3):
      fs/binfmt_flat.c: make load_flat_shared_library() work
      apparmor: enforce nullbyte at end of tag string
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Jason A. Donenfeld (1):
      um: Compile with modern headers

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA

Josh Elsasser (1):
      net: check before dereferencing netdev_ops during busy poll

Kees Cook (1):
      arm64, vdso: Define vdso_{start,end} as array

Linus Torvalds (2):
      gcc-9: silence 'address-of-packed-member' warning
      tty: rocket: fix incorrect forward declaration of 'rp_init()'

Manuel Lauss (1):
      MIPS: math-emu: do not use bools for arithmetic

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connections
      Bluetooth: Fix regression with minimum encryption key size alignment

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check

Matt Flax (1):
      ASoC : cs4265 : readable register too low

Miguel Ojeda (1):
      tracing: Silence GCC 9 array bounds warning

Mike Marciniszyn (1):
      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

Nikolay Borisov (1):
      btrfs: Ensure replaced device doesn't have pending chunk allocation

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Paul Burton (1):
      MIPS: Workaround GCC __builtin_unreachable reordering bug

Peter Chen (1):
      usb: chipidea: udc: workaround for endpoint conflict issue

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Robin Gong (1):
      dmaengine: imx-sdma: remove BD_INTR for channel0

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop

Steve French (1):
      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

Takashi Sakamoto (1):
      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages

Thierry Reding (1):
      swiotlb: Make linux/swiotlb.h standalone includible

Vineet Gupta (3):
      ARC: Assume multiplier is always present
      ARC: fix build warning in elf.h
      ARC: handle gcc generated __builtin_trap for older compiler

Vivek Goyal (1):
      ovl: modify ovl_permission() to do checks on two inodes

Wanpeng Li (1):
      KVM: X86: Fix scan ioapic use-before-initialization

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

Xin Long (3):
      sctp: change to hold sk after auth shkey is created successfully
      tipc: change to use register_pernet_device
      tipc: check msg->req data len in tipc_nl_compat_bearer_disable

Yonglong Liu (1):
      net: hns: Fix loopback test failed at copper ports

Young Xiao (2):
      sparc: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD
      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu (1):
      ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing (5):
      parport: Fix mem leak in parport_register_dev_model
      MIPS: uprobes: remove set but not used variable 'epc'
      team: Always enable vlan tx offload
      bonding: Always enable vlan tx offload
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

