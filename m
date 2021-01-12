Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBB02F39F3
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406170AbhALTU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392184AbhALTU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:20:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CFBD2311F;
        Tue, 12 Jan 2021 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610479215;
        bh=AKzyO/ULeU1vwTgtBSJchhZsACM2X0lnRamhrvsgk/w=;
        h=From:To:Cc:Subject:Date:From;
        b=tKsAM1bv0vv97TXPNyQr+qCoQEojtlSDK6VCNhtaUfR7lxcziA37Z6JQk6kZgNZbZ
         lFFdbFcgTAVbw9o6TdDx3K27ftdpmqfp7XMk6i6x7UY0Tn05HbCixSSO2ZNMOV2vit
         w+GLP13CITd6G/jSKQ960EPfwV7brjLBWr5QEb4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.251
Date:   Tue, 12 Jan 2021 20:21:20 +0100
Message-Id: <1610479280164214@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.251 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    4 -
 arch/x86/kernel/cpu/mtrr/generic.c               |    6 +-
 arch/x86/mm/pgtable.c                            |    2 
 drivers/atm/idt77252.c                           |    2 
 drivers/base/core.c                              |    2 
 drivers/net/ethernet/ethoc.c                     |    3 -
 drivers/net/ethernet/freescale/ucc_geth.c        |    2 
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |    4 +
 drivers/net/usb/cdc_ncm.c                        |    3 -
 drivers/net/virtio_net.c                         |   12 ++--
 drivers/net/wan/hdlc_ppp.c                       |    7 ++
 drivers/usb/chipidea/ci_hdrc_imx.c               |    6 +-
 drivers/usb/class/cdc-acm.c                      |    4 +
 drivers/usb/class/usblp.c                        |   21 ++++++-
 drivers/usb/gadget/Kconfig                       |    2 
 drivers/usb/gadget/composite.c                   |   10 ++-
 drivers/usb/gadget/configfs.c                    |   19 ++++--
 drivers/usb/gadget/function/f_printer.c          |    1 
 drivers/usb/gadget/function/f_uac2.c             |   69 ++++++++++++++++++-----
 drivers/usb/gadget/legacy/acm_ms.c               |    4 +
 drivers/usb/host/xhci.c                          |   24 ++++----
 drivers/usb/misc/yurex.c                         |    3 +
 drivers/usb/serial/iuu_phoenix.c                 |   20 +++++-
 drivers/usb/serial/keyspan_pda.c                 |    2 
 drivers/usb/serial/option.c                      |    1 
 drivers/usb/storage/unusual_uas.h                |    7 ++
 drivers/vhost/net.c                              |    6 +-
 drivers/video/fbdev/hyperv_fb.c                  |    6 --
 include/net/red.h                                |    4 +
 kernel/workqueue.c                               |   13 +++-
 lib/genalloc.c                                   |   25 ++++----
 net/ipv4/fib_frontend.c                          |    2 
 net/ncsi/ncsi-rsp.c                              |    2 
 net/netfilter/ipset/ip_set_hash_gen.h            |   20 +-----
 net/netfilter/xt_RATEEST.c                       |    3 +
 net/sched/sch_choke.c                            |    2 
 net/sched/sch_gred.c                             |    2 
 net/sched/sch_red.c                              |    2 
 net/sched/sch_sfq.c                              |    2 
 scripts/depmod.sh                                |    2 
 scripts/gdb/linux/dmesg.py                       |   22 +++++--
 scripts/gdb/linux/proc.py                        |    2 
 sound/pci/hda/patch_conexant.c                   |    1 
 sound/usb/midi.c                                 |    4 +
 44 files changed, 246 insertions(+), 114 deletions(-)

André Draszik (1):
      scripts/gdb: make lx-dmesg command work (reliably)

Arnd Bergmann (1):
      usb: gadget: select CONFIG_CRC32

Bard Liao (1):
      Revert "device property: Keep secondary firmware node secondary by type"

Chandana Kishori Chiluveru (1):
      usb: gadget: configfs: Preserve function ordering after bind failure

Dan Carpenter (1):
      atm: idt77252: call pci_disable_device() on error path

Dan Williams (1):
      x86/mm: Fix leak of pmd ptlock

Daniel Palmer (1):
      USB: serial: option: add LongSung M5710 module support

Dexuan Cui (1):
      video: hyperv_fb: Fix the mmap() regression for v5.4.y and older

Dinghao Liu (1):
      net: ethernet: Fix memleak in ethoc_probe

Dominique Martinet (1):
      kbuild: don't hardcode depmod path

Du Changbin (1):
      scripts/gdb: fix lx-version string output

Eddie Hung (1):
      usb: gadget: configfs: Fix use-after-free issue with udc_name

Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Greg Kroah-Hartman (1):
      Linux 4.9.251

Guillaume Nault (1):
      ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Huang Shijie (1):
      lib/genalloc: fix the overflow when size is too big

Jeff Dike (1):
      virtio_net: Fix recursive call to cpus_read_lock()

Jerome Brunet (1):
      usb: gadget: f_uac2: reset wMaxPacketSize

Johan Hovold (4):
      USB: serial: iuu_phoenix: fix DMA from stack
      USB: yurex: fix control-URB timeout handling
      USB: usblp: fix DMA to stack
      USB: serial: keyspan_pda: remove unused variable

John Wang (1):
      net/ncsi: Use real net-device for response handler

Leonard Crestez (2):
      scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
      scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace

Linus Torvalds (1):
      depmod: handle the case of /sbin/depmod without /sbin in PATH

Michael Grzeschik (1):
      USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set

Randy Dunlap (1):
      net: sched: prevent invalid Scell_log shift count

Rasmus Villemoes (1):
      ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

Roland Dreier (1):
      CDC-NCM: remove "connected" log message

Sean Young (1):
      USB: cdc-acm: blacklist another IR Droid device

Sriharsha Allenki (1):
      usb: gadget: Fix spinlock lockup on usb_function_deactivate

Takashi Iwai (1):
      ALSA: usb-audio: Fix UBSAN warnings for MIDI jacks

Thinh Nguyen (1):
      usb: uas: Add PNY USB Portable SSD to unusual_uas

Vasily Averin (1):
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Xie He (1):
      net: hdlc_ppp: Fix issues when mod_timer is called while timer is running

Yang Yingliang (1):
      USB: gadget: legacy: fix return error code in acm_ms_bind()

Ying-Tsun Huang (1):
      x86/mtrr: Correct the range check before performing MTRR type lookups

Yu Kuai (1):
      usb: chipidea: ci_hdrc_imx: add missing put_device() call in usbmisc_get_init_data()

Yunfeng Ye (1):
      workqueue: Kick a worker based on the actual activation of delayed works

Yunjian Wang (2):
      net: hns: fix return value check in __lb_other_process()
      vhost_net: fix ubuf refcount incorrectly when sendmsg fails

Zqiang (1):
      usb: gadget: function: printer: Fix a memory leak for interface descriptor

bo liu (1):
      ALSA: hda/conexant: add a new hda codec CX11970

taehyun.cho (1):
      usb: gadget: enable super speed plus

