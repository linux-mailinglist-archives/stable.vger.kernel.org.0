Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A0C2D795B
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388254AbgLKPat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733185AbgLKPaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:30:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.83
Date:   Fri, 11 Dec 2020 15:13:05 +0100
Message-Id: <160769598511141@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.83 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/powerpc/platforms/powernv/setup.c            |    9 
 arch/powerpc/platforms/pseries/msi.c              |    3 
 arch/x86/include/asm/insn.h                       |   15 +
 arch/x86/kernel/uprobes.c                         |   10 -
 arch/x86/lib/insn-eval.c                          |    5 
 drivers/gpu/drm/i915/gt/intel_mocs.c              |   14 +
 drivers/i2c/busses/i2c-imx.c                      |   42 +++-
 drivers/i2c/busses/i2c-qup.c                      |    3 
 drivers/input/serio/i8042.c                       |    3 
 drivers/iommu/amd_iommu_types.h                   |    2 
 drivers/md/dm-writecache.c                        |    4 
 drivers/md/dm.c                                   |    8 
 drivers/net/geneve.c                              |   20 --
 drivers/net/wireless/realtek/rtw88/debug.c        |    2 
 drivers/pinctrl/intel/pinctrl-baytrail.c          |   67 +++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                |    2 
 drivers/spi/spi-bcm2835.c                         |    7 
 drivers/staging/speakup/spk_ttyio.c               |   37 ++-
 drivers/thunderbolt/icm.c                         |   10 -
 drivers/tty/tty_io.c                              |    7 
 drivers/tty/tty_jobctrl.c                         |   44 +++-
 drivers/usb/gadget/function/f_fs.c                |    6 
 drivers/usb/serial/ch341.c                        |    5 
 drivers/usb/serial/kl5kusb105.c                   |   10 -
 drivers/usb/serial/option.c                       |   10 -
 fs/cifs/connect.c                                 |    2 
 fs/cifs/transport.c                               |    4 
 fs/coredump.c                                     |    3 
 fs/gfs2/rgrp.c                                    |    4 
 include/linux/irqdomain.h                         |   12 +
 include/linux/tty.h                               |    4 
 include/net/netfilter/nf_tables_offload.h         |    4 
 kernel/irq/irqdomain.c                            |   13 -
 kernel/trace/ftrace.c                             |   22 ++
 kernel/trace/trace.c                              |   13 -
 lib/syscall.c                                     |   11 -
 mm/list_lru.c                                     |   10 -
 mm/swapfile.c                                     |    4 
 net/can/af_can.c                                  |    7 
 net/netfilter/ipset/ip_set_core.c                 |    3 
 net/netfilter/nf_tables_api.c                     |    3 
 net/netfilter/nf_tables_offload.c                 |   17 +
 net/netfilter/nft_payload.c                       |    4 
 net/tipc/core.c                                   |    9 
 net/tipc/core.h                                   |    9 
 net/tipc/net.c                                    |   20 --
 net/tipc/net.h                                    |    1 
 sound/pci/hda/hda_generic.c                       |   12 -
 sound/pci/hda/hda_generic.h                       |    1 
 sound/pci/hda/patch_realtek.c                     |   32 ++-
 sound/soc/codecs/wm_adsp.c                        |    1 
 tools/arch/x86/include/asm/insn.h                 |   15 +
 tools/testing/selftests/bpf/prog_tests/map_init.c |  214 ----------------------
 tools/testing/selftests/bpf/progs/test_map_init.c |   33 ---
 55 files changed, 423 insertions(+), 411 deletions(-)

Bjørn Mork (1):
      USB: serial: option: fix Quectel BG96 matching

Bob Peterson (1):
      gfs2: check for empty rgrp tree in gfs2_ri_update

Chris Wilson (1):
      drm/i915/gt: Program mocs:63 for cache eviction on gen9

Christian Eggers (3):
      i2c: imx: Don't generate STOP condition if arbitration has been lost
      i2c: imx: Fix reset of I2SR_IAL flag
      i2c: imx: Check for I2SR_IAL after every byte

Dan Carpenter (1):
      rtw88: debug: Fix uninitialized memory in debugfs code

Eric Dumazet (1):
      netfilter: ipset: prevent uninit-value in hash_ip6_add

Florian Westphal (1):
      netfilter: nf_tables: avoid false-postive lockdep splat

Giacinto Cifelli (1):
      USB: serial: option: add support for Thales Cinterion EXS82

Greg Kroah-Hartman (1):
      Linux 5.4.83

Hans de Goede (2):
      pinctrl: baytrail: Replace WARN with dev_info_once when setting direct-irq pin to output
      pinctrl: baytrail: Fix pin being driven low for a while on gpiod_get(..., GPIOD_OUT_HIGH)

Hoang Huu Le (1):
      tipc: fix a deadlock when flushing scheduled work

Jakub Kicinski (1):
      Revert "geneve: pull IP header before ECN decapsulation"

Jan-Niklas Burfeind (1):
      USB: serial: ch341: add new Product ID for CH341A

Jann Horn (2):
      tty: Fix ->pgrp locking in tiocspgrp()
      tty: Fix ->session locking

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable headset of ASUS UX482EG & B9400CEA with ALC294

Johan Hovold (2):
      USB: serial: kl5kusb105: fix memleak on open
      USB: serial: ch341: sort device-id entries

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC897

Laurent Vivier (2):
      genirq/irqdomain: Add an irq_create_mapping_affinity() function
      powerpc/pseries: Pass MSI affinity to irq_create_mapping()

Luo Meng (2):
      ASoC: wm_adsp: fix error return code in wm_adsp_load()
      Input: i8042 - fix error return code in i8042_setup_aux()

Masami Hiramatsu (2):
      x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes
      x86/insn-eval: Use new for_each_insn_prefix() macro to loop over prefixes bytes

Menglong Dong (1):
      coredump: fix core_pattern parse error

Mika Westerberg (1):
      thunderbolt: Fix use-after-free in remove_unplugged_switch()

Mike Snitzer (2):
      dm: remove invalid sparse __acquires and __releases annotations
      dm writecache: remove BUG() and fail gracefully instead

Mikulas Patocka (1):
      dm writecache: fix the maximum number of arguments

Naveen N. Rao (1):
      ftrace: Fix updating FTRACE_FL_TRAMP

Nicholas Piggin (1):
      powerpc/64s/powernv: Fix memory corruption when saving SLB entries on MCE

Oliver Hartkopp (1):
      can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check

Pablo Neira Ayuso (1):
      netfilter: nftables_offload: set address type in control dissector

Paulo Alcantara (2):
      cifs: allow syscalls to be restarted in __smb_send_rqst()
      cifs: fix potential use-after-free in cifs_echo_request()

Peter Ujfalusi (1):
      spi: bcm2835: Release the DMA channel if probe fails after dma_init

Qian Cai (1):
      mm/swapfile: do not sleep with a spin lock held

Samuel Thibault (1):
      speakup: Reject setting the speakup line discipline outside of speakup

Sasha Levin (1):
      Partially revert bpf: Zero-fill re-used per-cpu map element

Sergei Shtepa (1):
      dm: fix bug with RCU locking in dm_blk_report_zones

Steven Rostedt (VMware) (1):
      tracing: Fix userstacktrace option for instances

Suganath Prabu S (1):
      scsi: mpt3sas: Fix ioctl timeout

Suravee Suthikulpanit (1):
      iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs

Takashi Iwai (3):
      ALSA: hda/realtek: Fix bass speaker DAC assignment on Asus Zephyrus G14
      ALSA: hda/realtek: Add mute LED quirk to yet another HP x360 model
      ALSA: hda/generic: Add option to enforce preferred_dacs pairs

Vamsi Krishna Samavedam (1):
      usb: gadget: f_fs: Use local copy of descriptors for userspace copy

Vincent Palatin (1):
      USB: serial: option: add Fibocom NL668 variants

Willy Tarreau (1):
      lib/syscall: fix syscall registers retrieval on 32-bit platforms

Yang Shi (1):
      mm: list_lru: set shrinker map bit when child nr_items is not zero

Zhihao Cheng (1):
      i2c: qup: Fix error return code in qup_i2c_bam_schedule_desc()

