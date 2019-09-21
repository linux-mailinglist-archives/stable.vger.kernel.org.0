Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE5CB9C9F
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731028AbfIUGes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfIUGes (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:34:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4E5A208C0;
        Sat, 21 Sep 2019 06:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047686;
        bh=GVqz0sPZlfjMmSQRw7qcptkVS72c5Ovs2yLm5B/q0Io=;
        h=Date:From:To:Cc:Subject:From;
        b=z+uc7d1q4l9978d3e4XeQrdXtB7qJ7JF/aZPyo/HowyX/MLBlS5ep2in357h6ZUZt
         rqWMqePA7GPu1aARmaO2HkBFoKq2gspCYEqfF2NDMCGh6BTmjVAB1XFtqLs5O9iQyl
         KhwtXkyhFbbOZhH9+8I9kBGezjiUznU9Jg8oUI2I=
Date:   Sat, 21 Sep 2019 08:34:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.194
Message-ID: <20190921063443.GA1071236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.194 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/arc/configs/axs101_defconfig          |    1 
 arch/arc/configs/axs103_defconfig          |    1 
 arch/arc/configs/axs103_smp_defconfig      |    1 
 arch/arc/configs/nsim_700_defconfig        |    1 
 arch/arc/configs/nsim_hs_defconfig         |    1 
 arch/arc/configs/nsim_hs_smp_defconfig     |    1 
 arch/arc/configs/nsimosci_defconfig        |    1 
 arch/arc/configs/nsimosci_hs_defconfig     |    1 
 arch/arc/configs/nsimosci_hs_smp_defconfig |    1 
 arch/arc/kernel/traps.c                    |    1 
 arch/arm/mach-omap2/omap4-common.c         |    3 +
 arch/arm/mm/init.c                         |    3 +
 arch/mips/Kconfig                          |    3 -
 arch/mips/include/asm/netlogic/xlr/fmn.h   |    2 -
 arch/mips/include/asm/smp.h                |   12 ++++++
 arch/mips/sibyte/common/Makefile           |    1 
 arch/mips/sibyte/common/dma.c              |   14 -------
 arch/mips/vdso/Makefile                    |    4 +-
 arch/s390/kvm/interrupt.c                  |   10 +++++
 arch/s390/kvm/kvm-s390.c                   |    2 -
 arch/s390/net/bpf_jit_comp.c               |   12 +++---
 arch/x86/Makefile                          |    1 
 arch/x86/include/asm/bootparam_utils.h     |    1 
 arch/x86/kernel/apic/io_apic.c             |    8 +++-
 arch/x86/kvm/vmx.c                         |    7 ++-
 arch/x86/kvm/x86.c                         |    7 +++
 drivers/atm/Kconfig                        |    2 -
 drivers/base/core.c                        |   53 ++++++++++++++++++++++++++++-
 drivers/block/floppy.c                     |    4 +-
 drivers/clk/rockchip/clk-mmc-phase.c       |    4 --
 drivers/crypto/talitos.c                   |   29 +++++++++++++++
 drivers/dma/omap-dma.c                     |    4 +-
 drivers/isdn/capi/capi.c                   |   10 ++++-
 drivers/media/usb/dvb-usb/technisat-usb2.c |   21 +++++------
 drivers/media/usb/tm6000/tm6000-dvb.c      |    3 +
 drivers/net/ethernet/marvell/sky2.c        |    7 +++
 drivers/net/ethernet/seeq/sgiseeq.c        |    7 ++-
 drivers/net/tun.c                          |   16 ++++++--
 drivers/net/usb/cdc_ether.c                |   13 +++++--
 drivers/net/usb/r8152.c                    |    5 ++
 drivers/net/wireless/mwifiex/ie.c          |    3 +
 drivers/net/wireless/mwifiex/uap_cmd.c     |    9 ++++
 drivers/net/xen-netfront.c                 |    2 -
 drivers/tty/serial/atmel_serial.c          |    1 
 drivers/tty/serial/sprd_serial.c           |    2 -
 drivers/usb/core/config.c                  |   12 ++++--
 fs/btrfs/tree-log.c                        |    6 +--
 fs/cifs/connect.c                          |   22 ++++++++++++
 fs/nfs/nfs4file.c                          |   12 +++---
 fs/nfs/pagelist.c                          |    2 -
 fs/nfs/proc.c                              |    7 ++-
 include/uapi/linux/isdn/capicmd.h          |    1 
 kernel/irq/resend.c                        |    2 +
 net/bridge/br_mdb.c                        |    2 -
 net/core/dev.c                             |    2 +
 net/ipv4/tcp_input.c                       |    2 -
 net/ipv6/ping.c                            |    2 -
 net/netfilter/nf_conntrack_ftp.c           |    2 -
 net/sched/sch_generic.c                    |    6 ++-
 net/sched/sch_hhf.c                        |    2 -
 net/sctp/protocol.c                        |    2 -
 net/sctp/sm_sideeffect.c                   |    2 -
 net/tipc/name_distr.c                      |    3 +
 security/keys/request_key_auth.c           |    6 +++
 tools/power/x86/turbostat/turbostat.c      |    2 -
 virt/kvm/coalesced_mmio.c                  |   17 +++++----
 67 files changed, 300 insertions(+), 111 deletions(-)

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Alexey Brodkin (1):
      ARC: configs: Remove CONFIG_INITRAMFS_SOURCE from defconfigs

Bjørn Mork (1):
      cdc_ether: fix rndis support for Mediatek based smartphones

Christophe JAILLET (4):
      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
      Kconfig: Fix the reference to the IDT77105 Phy driver in the description of ATM_NICSTAR_USE_IDT77105
      net: seeq: Fix the function used to release some memory in an error handling path

Christophe Leroy (2):
      crypto: talitos - check AES key size
      crypto: talitos - check data blocksize in ablkcipher.

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Cong Wang (2):
      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
      net_sched: let qdisc_put() accept NULL pointer

Corey Minyard (1):
      x86/boot: Add missing bootparam that breaks boot on some platforms

Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handling

Doug Berger (1):
      ARM: 8874/1: mm: only adjust sections of valid mm structures

Douglas Anderson (1):
      clk: rockchip: Don't yell about bad mmc phases when getting

Eric Biggers (1):
      isdn/capi: check message length in capi_write()

Filipe Manana (1):
      Btrfs: fix assertion failure during fsync and use of stale transaction

Fuqian Huang (1):
      KVM: x86: work around leak of uninitialized stack contents

Greg Kroah-Hartman (2):
      Revert "MIPS: SiByte: Enable swiotlb for SWARM, LittleSur and BigSur"
      Linux 4.4.194

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Ilya Leoshkevich (2):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls

Jann Horn (1):
      floppy: fix usercopy direction

Linus Torvalds (1):
      x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Muchun Song (1):
      driver core: Fix use-after-free and double free on glue directory

Naoya Horiguchi (1):
      tools/power turbostat: fix buffer overrun

Neal Cardwell (1):
      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Nicolas Dichtel (1):
      bridge/mdb: remove wrong use of NLM_F_MULTI

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread

Paul Burton (3):
      MIPS: VDSO: Prevent use of smp_processor_id()
      MIPS: VDSO: Use same -m%-float cflag as the kernel proper
      MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()

Prashant Malani (1):
      r8152: Set memory to all 0xFFs on failed reg reads

Razvan Stefanescu (1):
      tty/serial: atmel: reschedule TX after RX was started

Ronnie Sahlberg (1):
      cifs: set domainName when a domain-key is used in multiuser

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Subash Abhinov Kasiviswanathan (1):
      net: Fix null de-reference of device refcount

Takashi Iwai (1):
      sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Gleixner (1):
      x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Thomas Huth (1):
      KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Tony Lindgren (1):
      ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Trond Myklebust (4):
      NFSv4: Fix return values for nfs4_file_open()
      NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
      NFSv2: Fix eof handling
      NFSv2: Fix write regression

Vineet Gupta (1):
      ARC: export "abort" for modules

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_settings

Wenwen Wang (1):
      dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Xin Long (2):
      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
      tipc: add NULL pointer check before calling kfree_rcu

Yang Yingliang (1):
      tun: fix use-after-free when register netdev failed

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()

