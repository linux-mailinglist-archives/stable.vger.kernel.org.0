Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB94C6F373
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGUNro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfGUNro (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98DD12084C;
        Sun, 21 Jul 2019 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563716863;
        bh=YreVmbJ6EzHdMX8cy20qzOJKgVtLI3aeSes8/TW6t30=;
        h=Date:From:To:Cc:Subject:From;
        b=ybN6VnromNYa1l0rt8+g0L+QCnVdetpCPea1UOFSD/08RbkJkgZKKcPDc/Sr7xZSr
         YzxzBBqA0dLdIX2CZpyuNJUCZSKZ/3jFI3c1oDWRmS/oqcLBujWrR/PAPSL25eHTYe
         0xDafl9CNZ5hT5I3tDlN5co3XxvwU6tUdU99Lw6Y=
Date:   Sun, 21 Jul 2019 15:47:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.186
Message-ID: <20190721134739.GA22994@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.186 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt |    1 
 Makefile                                                        |    2 
 arch/arc/kernel/unwind.c                                        |    9 
 arch/arm/mach-davinci/board-da850-evm.c                         |    2 
 arch/arm/mach-davinci/devices-da8xx.c                           |    3 
 arch/arm/mach-omap2/prm3xxx.c                                   |    2 
 arch/mips/include/uapi/asm/sgidefs.h                            |    8 
 arch/s390/include/asm/facility.h                                |   21 +-
 arch/x86/kernel/ptrace.c                                        |    5 
 arch/x86/kernel/tls.c                                           |    9 
 arch/x86/kvm/i8254.c                                            |    5 
 arch/x86/kvm/x86.c                                              |    6 
 drivers/input/keyboard/imx_keypad.c                             |   18 +
 drivers/input/mouse/elantech.c                                  |    2 
 drivers/md/dm-verity.c                                          |    4 
 drivers/md/md.c                                                 |   36 ++-
 drivers/misc/vmw_vmci/vmci_context.c                            |   80 ++++----
 drivers/misc/vmw_vmci/vmci_handle_array.c                       |   38 ++--
 drivers/misc/vmw_vmci/vmci_handle_array.h                       |   29 ++-
 drivers/net/can/spi/Kconfig                                     |    5 
 drivers/net/can/spi/mcp251x.c                                   |   25 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c             |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                |    1 
 drivers/net/ethernet/emulex/benet/be_ethtool.c                  |   28 ++-
 drivers/net/ethernet/intel/e1000e/netdev.c                      |    6 
 drivers/net/ethernet/sis/sis900.c                               |   16 -
 drivers/net/ppp/ppp_mppe.c                                      |    1 
 drivers/net/wireless/ath/carl9170/usb.c                         |   39 +---
 drivers/net/wireless/mwifiex/fw.h                               |   12 -
 drivers/net/wireless/mwifiex/ie.c                               |   45 +++-
 drivers/net/wireless/mwifiex/scan.c                             |   31 ++-
 drivers/net/wireless/mwifiex/sta_ioctl.c                        |    4 
 drivers/net/wireless/mwifiex/wmm.c                              |    2 
 drivers/s390/cio/qdio_setup.c                                   |    2 
 drivers/s390/cio/qdio_thinint.c                                 |    5 
 drivers/staging/comedi/drivers/amplc_pci230.c                   |    3 
 drivers/staging/comedi/drivers/dt282x.c                         |    3 
 drivers/usb/gadget/function/u_ether.c                           |    6 
 drivers/usb/renesas_usbhs/fifo.c                                |   34 ++-
 drivers/usb/serial/ftdi_sio.c                                   |    1 
 drivers/usb/serial/ftdi_sio_ids.h                               |    6 
 drivers/usb/serial/option.c                                     |    1 
 fs/ext4/crypto_policy.c                                         |    2 
 fs/f2fs/crypto_policy.c                                         |    2 
 fs/udf/inode.c                                                  |   93 ++++++----
 include/linux/vmw_vmci_defs.h                                   |   11 +
 kernel/events/core.c                                            |    2 
 net/mac80211/mesh.c                                             |    5 
 samples/bpf/bpf_load.c                                          |    2 
 49 files changed, 437 insertions(+), 239 deletions(-)

Aaron Ma (1):
      Input: elantech - enable middle button support on 2 ThinkPads

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1

Anson Huang (1):
      Input: imx_keypad - make sure keyboard can always wake up system

Arnd Bergmann (2):
      ARM: omap2: remove incorrect __init annotation
      ARC: hide unused function unw_hdr_alloc

Bartosz Golaszewski (2):
      ARM: davinci: da850-evm: call regulator_has_full_constraints()
      ARM: davinci: da8xx: specify dma_coherent_mask for lcdc

Brian Norris (1):
      mwifiex: Don't abort on small, spec-compliant vendor IEs

Chang-Hsien Tsai (1):
      samples, bpf: fix to change the buffer size for read()

Christian Lamparter (1):
      carl9170: fix misuse of device driver API

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Greg Kroah-Hartman (1):
      Linux 4.4.186

Heiko Carstens (1):
      s390: fix stfle zero padding

Hongjie Fang (1):
      fscrypt: don't set policy for a dead directory

Ian Abbott (2):
      staging: comedi: dt282x: fix a null pointer deref on interrupt
      staging: comedi: amplc_pci230: fix null pointer deref on interrupt

Julian Wiedmann (2):
      s390/qdio: (re-)initialize tiqdio list entries
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

Jörgen Storvist (1):
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Konstantin Khlebnikov (1):
      e1000e: start network tx queue only when link is up

Mariusz Tkaczyk (1):
      md: fix for divide error in status_resync

Mauro S. M. Rodrigues (1):
      bnx2x: Check if transceiver implements DDM before access

Milan Broz (1):
      dm verity: use message limit for data block corruption message

Paolo Bonzini (2):
      kvm: x86: avoid warning on repeated KVM_SET_TSS_ADDR
      KVM: x86: protect KVM_CREATE_PIT/KVM_CREATE_PIT2 with kvm->lock

Peter Zijlstra (1):
      perf/core: Fix perf_sample_regs_user() mm check

Petr Oros (1):
      be2net: fix link failure after ethtool offline test

Sean Nyekjaer (2):
      dt-bindings: can: mcp251x: add mcp25625 support
      can: mcp251x: add support for mcp25625

Sean Young (1):
      MIPS: Remove superfluous check for __linux__

Sergej Benilov (1):
      sis900: fix TX completion

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Takashi Iwai (4):
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Abort at too short BSS descriptor element
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
      ppp: mppe: Add softdep to arc4

Thomas Pedersen (1):
      mac80211: mesh: fix RCU warning

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: add a workaround for a race condition of workqueue

