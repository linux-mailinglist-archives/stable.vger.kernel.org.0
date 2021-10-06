Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A024239EF
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 10:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhJFIsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 04:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237420AbhJFIsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 04:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3417360F5C;
        Wed,  6 Oct 2021 08:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633510010;
        bh=KuIGFIKJzqltuGdBQ2mksNIwBlmqWmCyDyVMC4ARi3U=;
        h=From:To:Cc:Subject:Date:From;
        b=Kpb0byJNLsWTz0HNNPU63rzitF3CgVSAs/zpb2mIQP561aKPZgd+Op2urrYBEy9k8
         j9OdTVaBcVErV09KYvdjNwrti9L+QMDjvYf3T02JZ7Dadc6gQjG3kz+pbgcbpPc2X2
         zc8Z3KgVk6nYeLdP8KXs7uZBVMoFuWl+mBJJFfuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.286
Date:   Wed,  6 Oct 2021 10:46:47 +0200
Message-Id: <163351000713258@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.286 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/alpha/include/asm/io.h                    |    6 +-
 arch/arm64/Kconfig                             |    2 
 arch/arm64/kernel/process.c                    |    2 
 arch/arm64/mm/proc.S                           |    4 -
 arch/m68k/include/asm/raw_io.h                 |   20 +++----
 arch/parisc/include/asm/page.h                 |    2 
 arch/sparc/kernel/mdesc.c                      |    3 -
 arch/x86/xen/enlighten.c                       |   15 +++--
 drivers/edac/synopsys_edac.c                   |    2 
 drivers/hid/hid-betopff.c                      |   13 +++-
 drivers/hid/usbhid/hid-core.c                  |   13 ++++
 drivers/ipack/devices/ipoctal.c                |   63 +++++++++++++++++-----
 drivers/net/ethernet/i825xx/82596.c            |    2 
 drivers/net/ethernet/intel/e100.c              |   22 +++++--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    3 +
 drivers/net/hamradio/6pack.c                   |    4 -
 drivers/net/usb/hso.c                          |   12 +---
 drivers/scsi/scsi_transport_iscsi.c            |    8 +-
 drivers/spi/spi-tegra20-slink.c                |    4 -
 drivers/tty/vt/vt.c                            |   21 ++++++-
 drivers/usb/gadget/udc/r8a66597-udc.c          |    2 
 drivers/usb/musb/tusb6010.c                    |    1 
 drivers/usb/serial/cp210x.c                    |    1 
 drivers/usb/serial/mos7840.c                   |    2 
 drivers/usb/serial/option.c                    |   11 +++
 fs/cifs/connect.c                              |    5 +
 fs/ext4/dir.c                                  |    6 +-
 fs/qnx4/dir.c                                  |   69 ++++++++++++++++++-------
 include/linux/compiler.h                       |    2 
 include/linux/cred.h                           |   14 +++--
 kernel/trace/blktrace.c                        |    8 ++
 net/mac80211/wpa.c                             |    6 ++
 net/netfilter/ipset/ip_set_hash_gen.h          |    4 -
 net/netfilter/ipvs/ip_vs_conn.c                |    4 +
 35 files changed, 253 insertions(+), 105 deletions(-)

Andrea Claudi (1):
      ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Anirudh Rayabharam (1):
      HID: usbhid: free raw_report buffers in usbhid_stop

Aya Levin (1):
      net/mlx4_en: Don't allow aRFS for encapsulated packets

Baokun Li (1):
      scsi: iscsi: Adjust iface sysfs attr detection

Carlo Lobrano (1):
      USB: serial: option: add Telit LN920 compositions

Dan Carpenter (2):
      usb: gadget: r8a66597: fix a loop in set_feature()
      usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()

Dan Li (1):
      arm64: Mark __stack_chk_guard as __ro_after_init

F.A.Sulaiman (1):
      HID: betop: fix slab-out-of-bounds Write in betop_probe

Greg Kroah-Hartman (1):
      Linux 4.4.286

Guenter Roeck (5):
      m68k: Double cast io functions to unsigned long
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy from fixed memory location
      alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
      net: 6pack: Fix tx timeout and slot time

Helge Deller (1):
      parisc: Use absolute_pointer() to define PAGE0

Igor Matheus Andrade Torrente (1):
      tty: Fix out-of-bound vmalloc access in imageblit

Jacob Keller (2):
      e100: fix length calculation in e100_get_regs_len
      e100: fix buffer overrun in e100_get_regs

Jan Beulich (1):
      xen/x86: fix PV trap handling on secondary processors

Johan Hovold (6):
      net: hso: fix muxed tty registration
      ipack: ipoctal: fix stack information leak
      ipack: ipoctal: fix tty registration race
      ipack: ipoctal: fix tty-registration error handling
      ipack: ipoctal: fix missing allocation-failure check
      ipack: ipoctal: fix module reference leak

Johannes Berg (1):
      mac80211: fix use-after-free in CCMP/GCMP RX

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix oversized kvmalloc() calls

Krzysztof Kozlowski (2):
      USB: serial: mos7840: remove duplicated 0xac24 device ID
      USB: serial: option: remove duplicate USB device ID

Linus Torvalds (4):
      sparc: avoid stringop-overread errors
      qnx4: avoid stringop-overread errors
      spi: Fix tegra20 build with CONFIG_PM=n
      qnx4: work around gcc false positive warning bug

NeilBrown (1):
      cred: allow get_cred() and put_cred() to be given NULL.

Sai Krishna Potthuri (1):
      EDAC/synopsys: Fix wrong value type assignment for edac_mode

Slark Xiao (1):
      USB: serial: option: add device id for Foxconn T99W265

Steve French (1):
      cifs: fix incorrect check for null pointer in header_assemble

Suzuki K Poulose (1):
      arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Uwe Brandt (1):
      USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Zhihao Cheng (1):
      blktrace: Fix uaf in blk_trace access after removing by sysfs

yangerkun (1):
      ext4: fix potential infinite loop in ext4_dx_readdir()

