Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50361AB98D
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390992AbfIFNp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390492AbfIFNp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:45:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A91120650;
        Fri,  6 Sep 2019 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777525;
        bh=lYDcDFiihX1r5EPwWeYbJ159pW6cZTZ8U/uz4Y8UaHE=;
        h=Date:From:To:Cc:Subject:From;
        b=IYR6Xn0pEstsd7EkUxpYnVkCTXScRRJnDTWgFgnDimPut+n/u8V+RBM5jCs8qgTsQ
         SvIVTyUIgj4V9PcO66XJV+HsUXdFq7uFIzDVItsyZqF7+EY38WgA4JfTMfDhEIf5yz
         bXK7MuBsvW+YMzz/TIsqqsy/Kf7ugv8yCyeNVmtc=
Date:   Fri, 6 Sep 2019 15:45:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.191
Message-ID: <20190906134523.GA6704@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.191 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                |    7 
 Documentation/siphash.txt                          |  175 ++++++
 MAINTAINERS                                        |    7 
 Makefile                                           |    2 
 arch/mips/kernel/i8253.c                           |    3 
 arch/x86/include/asm/bootparam_utils.h             |   60 +-
 arch/x86/include/asm/msr-index.h                   |    1 
 arch/x86/include/asm/msr.h                         |   10 
 arch/x86/include/asm/nospec-branch.h               |    2 
 arch/x86/include/asm/ptrace.h                      |    6 
 arch/x86/include/asm/suspend_32.h                  |    1 
 arch/x86/include/asm/suspend_64.h                  |    1 
 arch/x86/kernel/apic/apic.c                        |   72 ++
 arch/x86/kernel/apic/bigsmp_32.c                   |   24 
 arch/x86/kernel/cpu/amd.c                          |   66 ++
 arch/x86/kernel/ptrace.c                           |    3 
 arch/x86/kernel/uprobes.c                          |   17 
 arch/x86/kvm/x86.c                                 |    9 
 arch/x86/power/cpu.c                               |  152 +++++
 drivers/ata/libata-sff.c                           |    6 
 drivers/dma/ste_dma40.c                            |    4 
 drivers/hid/hid-tmff.c                             |   12 
 drivers/hid/wacom_wac.c                            |    2 
 drivers/hwtracing/stm/core.c                       |    1 
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   13 
 drivers/md/dm-bufio.c                              |    4 
 drivers/md/dm-table.c                              |    5 
 drivers/md/persistent-data/dm-btree.c              |   31 -
 drivers/md/persistent-data/dm-space-map-metadata.c |    2 
 drivers/misc/vmw_vmci/vmci_doorbell.c              |    6 
 drivers/mmc/core/sd.c                              |    6 
 drivers/mmc/host/sdhci-of-at91.c                   |    3 
 drivers/net/bonding/bond_main.c                    |    9 
 drivers/net/can/dev.c                              |    2 
 drivers/net/can/sja1000/peak_pcmcia.c              |    2 
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    2 
 drivers/net/ethernet/arc/emac_main.c               |    9 
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    5 
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   28 -
 drivers/net/usb/qmi_wwan.c                         |    1 
 drivers/nfc/st-nci/se.c                            |    2 
 drivers/nfc/st21nfca/se.c                          |    2 
 drivers/scsi/ufs/ufshcd.c                          |    3 
 drivers/usb/class/cdc-wdm.c                        |   16 
 drivers/usb/gadget/composite.c                     |    1 
 drivers/usb/host/fotg210-hcd.c                     |    4 
 drivers/usb/host/ohci-hcd.c                        |   15 
 drivers/usb/storage/realtek_cr.c                   |   15 
 drivers/usb/storage/unusual_devs.h                 |    2 
 drivers/vhost/net.c                                |   31 -
 drivers/vhost/scsi.c                               |   15 
 drivers/vhost/vhost.c                              |   20 
 drivers/vhost/vhost.h                              |    6 
 drivers/watchdog/bcm2835_wdt.c                     |    1 
 fs/gfs2/rgrp.c                                     |   13 
 fs/nfs/nfs4_fs.h                                   |    3 
 fs/nfs/nfs4client.c                                |    5 
 fs/nfs/nfs4state.c                                 |   27 -
 fs/userfaultfd.c                                   |   25 
 include/linux/siphash.h                            |  145 +++++
 include/net/netfilter/nf_conntrack.h               |    2 
 include/net/netns/ipv4.h                           |    2 
 include/net/tcp.h                                  |    4 
 kernel/cgroup.c                                    |  122 ++--
 lib/Kconfig.debug                                  |   10 
 lib/Makefile                                       |    3 
 lib/siphash.c                                      |  551 +++++++++++++++++++++
 lib/test_siphash.c                                 |  223 ++++++++
 net/bridge/netfilter/ebtables.c                    |    4 
 net/core/stream.c                                  |   16 
 net/ipv4/route.c                                   |   12 
 net/ipv6/output_core.c                             |   30 -
 net/mac80211/cfg.c                                 |    9 
 net/netfilter/nf_conntrack_core.c                  |   35 +
 net/netfilter/nf_conntrack_netlink.c               |   34 +
 net/wireless/reg.c                                 |    2 
 sound/core/seq/seq_clientmgr.c                     |    3 
 sound/core/seq/seq_fifo.c                          |   17 
 sound/core/seq/seq_fifo.h                          |    2 
 sound/soc/davinci/davinci-mcasp.c                  |   43 +
 sound/usb/mixer.c                                  |   30 -
 tools/hv/hv_kvp_daemon.c                           |    2 
 tools/hv/hv_vss_daemon.c                           |    2 
 tools/perf/bench/numa.c                            |    6 
 tools/perf/tests/parse-events.c                    |   27 -
 tools/testing/selftests/kvm/config                 |    3 
 86 files changed, 2009 insertions(+), 307 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: correct misreported EKR ring values

Adrian Hunter (1):
      scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()

Adrian Vladu (1):
      tools: hv: fix KVP and VSS daemons exit code

Alexander Kochetkov (1):
      net: arc_emac: fix koops caused by sk_buff free

Arnd Bergmann (1):
      dmaengine: ste_dma40: fix unneeded variable warning

Bandan Das (2):
      x86/apic: Do not initialize LDR and DFR for bigsmp
      x86/apic: Include the LDR when clearing out APIC registers

Benjamin Herrenschmidt (1):
      usb: gadget: composite: Clear "suspended" on reset/disconnect

Bob Ham (1):
      net: usb: qmi_wwan: Add the BroadMobi BM818 card

Bob Peterson (1):
      GFS2: don't set rgrp gl_object until it's inserted into rgrp tree

Chen Yu (1):
      x86/pm: Introduce quirk framework to save/restore extra MSR registers around suspend/resume

Christophe JAILLET (1):
      net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'

Daniel Bristot de Oliveira (1):
      cgroup: Disable IRQs while holding css_set_lock

Ding Xiang (1):
      stm class: Fix a double free of stm_source_device

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Eric Dumazet (2):
      inet: switch IP ID generator to siphash
      tcp: make sure EPOLLOUT wont be missed

Eugen Hristev (1):
      mmc: sdhci-of-at91: add quirk for broken HS200

Florian Westphal (1):
      netfilter: ctnetlink: don't use conntrack/expect object addresses as id

Greg Kroah-Hartman (2):
      x86/ptrace: fix up botched merge of spectrev1 fix
      Linux 4.4.191

Hans Ulli Kroll (1):
      usb: host: fotg2: restart hcd after port reset

Henk van der Laan (1):
      usb-storage: Add new JMS567 revision to unusual_devs

Hodaszi, Robert (1):
      Revert "cfg80211: fix processing world regdomain when non modular"

Hui Peng (2):
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Ilya Trukhanov (1):
      HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT

Jason A. Donenfeld (2):
      siphash: add cryptographically secure PRF
      siphash: implement HalfSipHash1-3 for hash tables

Jason Wang (4):
      vhost_net: introduce vhost_exceeds_weight()
      vhost: introduce vhost_exceeds_weight()
      vhost_net: fix possible infinite loop
      vhost: scsi: add weight support

Jens Axboe (1):
      libata: add SG safety checks in SFF pio transfers

Jia-Ju Bai (1):
      isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()

Jiangfeng Xiao (3):
      net: hisilicon: make hip04_tx_reclaim non-reentrant
      net: hisilicon: fix hip04-xmit never return TX_BUSY
      net: hisilicon: Fix dma_map_single failed on arm64

Jiri Olsa (1):
      perf bench numa: Fix cpu0 binding

Johannes Berg (1):
      mac80211: fix possible sta leak

John Hubbard (2):
      x86/boot: Save fields explicitly, zero out everything else
      x86/boot: Fix boot regression caused by bootparam sanitizing

Juliana Rodrigueiro (1):
      isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack

Kai-Heng Feng (2):
      USB: storage: ums-realtek: Update module parameter description for auto_delink_en
      USB: storage: ums-realtek: Whitelist auto-delink support

Mikulas Patocka (2):
      Revert "dm bufio: fix deadlock with loop device"
      dm table: fix invalid memory accesses with too high sector number

Nadav Amit (1):
      VMCI: Release resource if the work is already queued

Naresh Kamboju (1):
      selftests: kvm: Adding config fragments

Navid Emamdoost (2):
      st21nfca_connectivity_event_received: null check the allocation
      st_nci_hci_connectivity_event_received: null check the allocation

Oleg Nesterov (1):
      userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx

Oliver Neukum (1):
      USB: cdc-wdm: fix race between write and disconnect due to flag abuse

Paolo Abeni (1):
      vhost_net: use packet weight for rx handler, too

Peter Ujfalusi (1):
      ASoC: ti: davinci-mcasp: Correct slot_width posed constraint

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Ricardo Neri (1):
      ptrace,x86: Make user_64bit_mode() available to 32-bit builds

Sasha Levin (1):
      Revert "perf test 6: Fix missing kvm module load for s390"

Sean Christopherson (2):
      x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386
      KVM: x86: Don't update RIP or do single-step on faulting emulation

Sebastian Mayr (1):
      uprobes/x86: Fix detection of 32-bit user mode

Stefan Wahren (1):
      watchdog: bcm2835_wdt: Fix module autoload

Takashi Iwai (1):
      ALSA: seq: Fix potential concurrent access to the deleted pool

Thomas Bogendoerfer (1):
      MIPS: kernel: only use i8253 clocksource with periodic clockevent

Thomas Falcon (1):
      bonding: Force slave speed check after link state recovery for 802.3ad

Thomas Gleixner (1):
      x86/apic: Handle missing global clockevent gracefully

Tim Froidcoeur (1):
      tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue

Tom Lendacky (1):
      x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

Trond Myklebust (1):
      NFSv4: Fix a potential sleep while atomic in nfs4_do_reclaim()

Ulf Hansson (1):
      mmc: core: Fix init of SD cards reporting an invalid VDD range

Wang Xiayang (2):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated

Wenwen Wang (1):
      netfilter: ebtables: fix a memory leak bug in compat

Yoshihiro Shimoda (1):
      usb: host: ohci: fix a race condition between shutdown and irq

ZhangXiaoxu (2):
      dm btree: fix order of block initialization in btree_split_beneath
      dm space map metadata: fix missing store of apply_bops() return value

haibinzhang(张海斌) (1):
      vhost-net: set packet weight of tx polling to 2 * vq size

