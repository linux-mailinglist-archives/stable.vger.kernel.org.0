Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37272234A02
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 19:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbgGaRQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 13:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732973AbgGaRQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 13:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2582222B3F;
        Fri, 31 Jul 2020 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215768;
        bh=CE3tGb7JEEQvjxh0TbiKI6LgjN9RpNuZs3BOMUngU1M=;
        h=From:To:Cc:Subject:Date:From;
        b=SAENp8i9PSR7NNixhplEw+sRpMl4FgwaSFMfMQQvrWJuIyaLZO3cmNfMR6LiqT6Y1
         ZfiL21LmooWTJ8QXz41dUsO24rnAh0zgjWMzdxBQwh7zl6NeD77VgCQaB1POo989tS
         wrmGxLwJtEhjQt22nGXWcVxRO4Lg8AxRfjFPnA94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.232
Date:   Fri, 31 Jul 2020 19:15:53 +0200
Message-Id: <15962157532752@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.232 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    4 -
 arch/arm64/kernel/debug-monitors.c                 |    4 -
 arch/parisc/include/asm/atomic.h                   |    2 
 arch/x86/kernel/fpu/signal.c                       |    4 -
 arch/x86/math-emu/wm_sqrt.S                        |    2 
 arch/xtensa/kernel/setup.c                         |    3 -
 arch/xtensa/kernel/xtensa_ksyms.c                  |    4 -
 drivers/base/regmap/regmap-debugfs.c               |    6 ++
 drivers/base/regmap/regmap.c                       |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   |    4 -
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm204.c |    4 -
 drivers/net/ethernet/marvell/sky2.c                |    2 
 drivers/net/ethernet/smsc/smc91x.c                 |    4 -
 drivers/net/hippi/rrunner.c                        |    2 
 drivers/net/phy/dp83640.c                          |    4 +
 drivers/net/usb/ax88172a.c                         |    1 
 drivers/net/wan/lapbether.c                        |    9 +++
 drivers/net/wan/x25_asy.c                          |   21 +++++---
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   52 ++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    5 ++
 drivers/pinctrl/pinctrl-amd.h                      |    2 
 drivers/scsi/scsi_transport_spi.c                  |    2 
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   20 +++++---
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   24 +++++++--
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   20 +++++---
 drivers/staging/comedi/drivers/ni_6527.c           |    2 
 drivers/staging/wlan-ng/prism2usb.c                |   16 ++++++
 drivers/tty/serial/8250/8250_core.c                |    2 
 drivers/tty/serial/8250/8250_mtk.c                 |   18 +++++++
 drivers/usb/gadget/udc/gr_udc.c                    |    7 ++
 fs/btrfs/backref.c                                 |    1 
 fs/btrfs/volumes.c                                 |    8 +++
 fs/cifs/inode.c                                    |   10 ----
 fs/nfs/direct.c                                    |   13 +----
 fs/nfs/file.c                                      |    1 
 fs/xfs/libxfs/xfs_bmap.c                           |    2 
 include/linux/tcp.h                                |    5 +-
 kernel/events/core.c                               |    5 ++
 kernel/events/uprobes.c                            |    2 
 mm/memcontrol.c                                    |    4 -
 net/ax25/af_ax25.c                                 |   10 +++-
 net/core/net-sysfs.c                               |    2 
 net/ipv4/tcp_input.c                               |   11 ++--
 net/ipv4/tcp_output.c                              |   13 +++--
 net/ipv4/udp.c                                     |    2 
 net/ipv6/ip6_gre.c                                 |   11 ++--
 net/ipv6/udp.c                                     |    2 
 net/mac80211/rx.c                                  |   26 ++++++++++
 net/rxrpc/ar-output.c                              |    2 
 net/rxrpc/ar-recvmsg.c                             |    2 
 scripts/decode_stacktrace.sh                       |    4 -
 sound/core/info.c                                  |    4 +
 sound/soc/codecs/rt5670.h                          |    2 
 tools/perf/builtin-script.c                        |   24 ++++-----
 tools/perf/tests/attr.c                            |    4 -
 tools/perf/tests/pmu.c                             |    2 
 tools/perf/util/annotate.c                         |   14 ++++-
 tools/perf/util/cgroup.c                           |    2 
 tools/perf/util/pager.c                            |    5 +-
 tools/perf/util/parse-events.c                     |    4 -
 tools/perf/util/pmu.c                              |    2 
 tools/perf/util/probe-event.c                      |   21 ++++++--
 tools/perf/util/srcline.c                          |   16 ++++++
 63 files changed, 346 insertions(+), 142 deletions(-)

Arnaldo Carvalho de Melo (1):
      perf annotate: Use asprintf when formatting objdump command line

Arnd Bergmann (1):
      x86: math-emu: Fix up 'cmp' insn for clang ias

Ben Skeggs (1):
      drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Boris Burkov (1):
      btrfs: fix mount failure caused by race with umount

Changbin Du (1):
      perf: Make perf able to build with latest libbfd

Christophe JAILLET (1):
      hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Dan Carpenter (1):
      AX.25: Prevent integer overflows in connect and sendmsg

David Howells (1):
      rxrpc: Fix sendmsg() returning EPIPE due to recvmsg() returning ENODATA

Eric Sandeen (1):
      xfs: set format back to extents if xfs_bmap_extents_to_btree

Evgeny Novikov (1):
      usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

Fangrui Song (1):
      Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation

Filipe Manana (1):
      btrfs: fix double free on ulist after backref resolution failure

George Kennedy (1):
      ax88172a: fix ax88172a_unbind() failures

Greg Kroah-Hartman (1):
      Linux 4.4.232

Hans de Goede (1):
      ASoC: rt5670: Correct RT5670_LDO_SEL_MASK

Hugh Dickins (1):
      mm/memcg: fix refcount error while moving and swapping

Ian Abbott (4):
      staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support
      staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift
      staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Jacky Hu (1):
      pinctrl: amd: fix npins for uart0 in kerncz_groups

Jiri Olsa (2):
      perf/core: Fix locking for children siblings group read
      perf tools: Fix snprint warnings for gcc 8

John David Anglin (1):
      parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Marc Kleine-Budde (1):
      regmap: dev_get_regmap_match(): fix string comparison

Mark O'Donovan (1):
      ath9k: Fix regression with Atheros 9271

Markus Theil (1):
      mac80211: allow rx of mesh eapol frames with default rx key

Masami Hiramatsu (1):
      perf probe: Fix to check blacklist address correctly

Max Filippov (2):
      xtensa: fix __sync_fetch_and_{and,or}_4 declarations
      xtensa: update *pos in cpuinfo_op.next

Miaohe Lin (1):
      net: udp: Fix wrong clean up for IS_UDPLITE macro

Oleg Nesterov (1):
      uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Olga Kornievskaia (1):
      SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Peilin Ye (2):
      AX.25: Fix out-of-bounds read in ax25_connect()
      AX.25: Prevent out-of-bounds read in ax25_sendmsg()

Peng Fan (1):
      regmap: debugfs: check count when read regmap file

Pi-Hsun Shih (1):
      scripts/decode_stacktrace: strip basepath from all paths

Qiujun Huang (1):
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Rustam Kovhaev (1):
      staging: wlan-ng: properly check endpoint types

Sebastian Andrzej Siewior (1):
      x86/fpu: Disable bottom halves while loading FPU registers

Serge Semin (1):
      serial: 8250_mtk: Fix high-speed baud rates clamping

Sergey Organov (1):
      net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

Sergey Senozhatsky (1):
      tools/lib/subcmd/pager.c: do not alias select() params

Steve French (1):
      Revert "cifs: Fix the target file was deleted when rename failed."

Takashi Iwai (1):
      ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Tom Rix (2):
      scsi: scsi_transport_spi: Fix function pointer check
      net: sky2: initialize return of gm_phy_read

Wang Hai (1):
      net: smc91x: Fix possible memory leak in smc_drv_probe()

Wei Yongjun (1):
      ip6_gre: fix null-ptr-deref in ip6gre_init_net()

Will Deacon (1):
      arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP

Xie He (2):
      drivers/net/wan/lapbether: Fixed the value of hard_header_len
      drivers/net/wan/x25_asy: Fix to make it work

Xiongfeng Wang (1):
      net-sysfs: add a newline when printing 'tx_timeout' by sysfs

Yang Yingliang (1):
      serial: 8250: fix null-ptr-deref in serial8250_start_tx()

Yuchung Cheng (1):
      tcp: allow at most one TLP probe per flight

