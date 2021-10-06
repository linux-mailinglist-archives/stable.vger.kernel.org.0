Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15337423F25
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhJFNa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJFNa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F0D960E9C;
        Wed,  6 Oct 2021 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633526916;
        bh=og+UrHAXzef3ErunuTsyWhZDgRBLY6IX96W558Q9rLo=;
        h=From:To:Cc:Subject:Date:From;
        b=IZJeOzTv0Bftq/Nk0bUf7jPgafO0WoSqIdObjwmM6xr1iyMhVSqyN7a8eSfcbPsK8
         ZJStRl5Ny5P1yrxJhXXFBX3jeIBOQPeemOLOq+kgghdFRoC29QHK5eF9QhfJ26Itoq
         Jv2fgHttl8wwIr3WgPI180pt59lF3UPrJrgL/zGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.249
Date:   Wed,  6 Oct 2021 15:28:33 +0200
Message-Id: <163352691317581@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.249 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/include/asm/io.h                       |    6 -
 arch/arm/include/asm/ftrace.h                     |    3 
 arch/arm/include/asm/insn.h                       |    8 +-
 arch/arm/include/asm/module.h                     |   10 +++
 arch/arm/kernel/ftrace.c                          |   50 ++++++++++++---
 arch/arm/kernel/insn.c                            |   19 +++---
 arch/arm/kernel/module-plts.c                     |   49 ++++++++++++---
 arch/arm64/Kconfig                                |    2 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi      |   11 ++-
 arch/arm64/kernel/process.c                       |    2 
 arch/arm64/mm/proc.S                              |    4 -
 arch/m68k/include/asm/raw_io.h                    |   20 +++---
 arch/parisc/include/asm/page.h                    |    2 
 arch/sparc/kernel/mdesc.c                         |    3 
 arch/x86/xen/enlighten_pv.c                       |   15 ++--
 drivers/cpufreq/cpufreq_governor_attr_set.c       |    2 
 drivers/crypto/ccp/ccp-ops.c                      |   14 ++--
 drivers/edac/synopsys_edac.c                      |    2 
 drivers/hid/hid-betopff.c                         |   13 +++-
 drivers/hid/usbhid/hid-core.c                     |   13 +++-
 drivers/hwmon/tmp421.c                            |   24 ++-----
 drivers/ipack/devices/ipoctal.c                   |   63 ++++++++++++++------
 drivers/irqchip/irq-gic-v3-its.c                  |    2 
 drivers/mcb/mcb-core.c                            |   12 +--
 drivers/md/md.c                                   |    5 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |    5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    2 
 drivers/net/ethernet/cadence/macb_pci.c           |    2 
 drivers/net/ethernet/i825xx/82596.c               |    2 
 drivers/net/ethernet/intel/e100.c                 |   22 ++++---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 
 drivers/net/hamradio/6pack.c                      |    4 -
 drivers/net/usb/hso.c                             |   45 ++++++++------
 drivers/pci/host/pci-aardvark.c                   |   64 +++++++++++++++++---
 drivers/scsi/csiostor/csio_init.c                 |    1 
 drivers/scsi/scsi_transport_iscsi.c               |    8 +-
 drivers/spi/spi-tegra20-slink.c                   |    4 -
 drivers/staging/greybus/uart.c                    |   62 ++++++++++---------
 drivers/thermal/thermal_core.c                    |    7 --
 drivers/tty/serial/mvebu-uart.c                   |    2 
 drivers/tty/vt/vt.c                               |   21 ++++++
 drivers/usb/gadget/udc/r8a66597-udc.c             |    2 
 drivers/usb/musb/tusb6010.c                       |    1 
 drivers/usb/serial/cp210x.c                       |    1 
 drivers/usb/serial/mos7840.c                      |    2 
 drivers/usb/serial/option.c                       |   11 +++
 drivers/usb/storage/unusual_devs.h                |    9 ++
 drivers/usb/storage/unusual_uas.h                 |    2 
 drivers/xen/balloon.c                             |   62 ++++++++++++++-----
 fs/cifs/connect.c                                 |    5 -
 fs/ext4/dir.c                                     |    6 -
 fs/ocfs2/dlmglue.c                                |    3 
 fs/qnx4/dir.c                                     |   69 ++++++++++++++++------
 include/linux/compiler.h                          |    2 
 include/linux/cred.h                              |   14 ++--
 include/net/sock.h                                |    2 
 kernel/sched/cpufreq_schedutil.c                  |   16 +++--
 kernel/trace/blktrace.c                           |    8 ++
 net/core/sock.c                                   |   32 ++++++++--
 net/ipv4/udp.c                                    |   10 +--
 net/ipv6/udp.c                                    |    2 
 net/mac80211/tx.c                                 |   12 +++
 net/mac80211/wpa.c                                |    6 +
 net/netfilter/ipset/ip_set_hash_gen.h             |    4 -
 net/netfilter/ipvs/ip_vs_conn.c                   |    4 +
 net/sctp/input.c                                  |    2 
 net/unix/af_unix.c                                |   34 ++++++++--
 70 files changed, 660 insertions(+), 281 deletions(-)

Alex Sverdlin (4):
      ARM: 9077/1: PLT: Move struct plt_entries definition to header
      ARM: 9078/1: Add warn suppress parameter to arm_gen_branch_link()
      ARM: 9079/1: ftrace: Add MODULE_PLTS support
      ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE

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

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Christoph Hellwig (1):
      md: fix a lock order reversal in md_alloc

Dan Carpenter (5):
      usb: gadget: r8a66597: fix a loop in set_feature()
      usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
      mcb: fix error handling in mcb_alloc_bus()
      thermal/core: Potential buffer overflow in thermal_build_list_of_policies()
      crypto: ccp - fix resource leaks in ccp_run_aes_gcm_cmd()

Dan Li (1):
      arm64: Mark __stack_chk_guard as __ro_after_init

Dongliang Mu (2):
      usb: hso: fix error handling code of hso_create_net_device
      usb: hso: remove the bailout parameter

Eric Dumazet (2):
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
      net: udp: annotate data race around udp_sk(sk)->corkflag

Evan Wang (1):
      PCI: aardvark: Fix checking for PIO status

F.A.Sulaiman (1):
      HID: betop: fix slab-out-of-bounds Write in betop_probe

Greg Kroah-Hartman (1):
      Linux 4.14.249

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

James Morse (1):
      cpufreq: schedutil: Destroy mutex before kobject_put() frees the memory

Jan Beulich (1):
      xen/x86: fix PV trap handling on secondary processors

Jesper Nilsson (1):
      net: stmmac: allow CSR clock of 300MHz

Johan Hovold (7):
      staging: greybus: uart: fix tty use after free
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

Juergen Gross (2):
      xen/balloon: use a kernel thread instead a workqueue
      xen/balloon: fix balloon kthread freezing

Julian Sikorski (1):
      Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Kaige Fu (1):
      irqchip/gic-v3-its: Fix potential VPE leak on error

Kevin Hao (1):
      cpufreq: schedutil: Use kobject release() method to free sugov_tunables

Krzysztof Kozlowski (2):
      USB: serial: mos7840: remove duplicated 0xac24 device ID
      USB: serial: option: remove duplicate USB device ID

Linus Torvalds (4):
      sparc: avoid stringop-overread errors
      qnx4: avoid stringop-overread errors
      spi: Fix tegra20 build with CONFIG_PM=n
      qnx4: work around gcc false positive warning bug

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Michael Chan (1):
      bnxt_en: Fix TX timeout when TX ring size is set to the smallest

NeilBrown (1):
      cred: allow get_cred() and put_cred() to be given NULL.

Oliver Neukum (1):
      hso: fix bailout in error case of probe

Ondrej Zary (1):
      usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Pali Rohár (3):
      serial: mvebu-uart: fix driver's tx_empty callback
      arm64: dts: marvell: armada-37xx: Extend PCIe MEM space
      PCI: aardvark: Fix checking for PIO Non-posted Request

Paul Fertser (1):
      hwmon: (tmp421) fix rounding for negative values

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

Sai Krishna Potthuri (1):
      EDAC/synopsys: Fix wrong value type assignment for edac_mode

Slark Xiao (1):
      USB: serial: option: add device id for Foxconn T99W265

Steve French (1):
      cifs: fix incorrect check for null pointer in header_assemble

Suzuki K Poulose (1):
      arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Tong Zhang (1):
      net: macb: fix use after free on rmmod

Uwe Brandt (1):
      USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Wengang Wang (1):
      ocfs2: drop acl cache for directories too

Xin Long (1):
      sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Zhihao Cheng (1):
      blktrace: Fix uaf in blk_trace access after removing by sysfs

yangerkun (1):
      ext4: fix potential infinite loop in ext4_dx_readdir()

