Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0AA1387C9
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732957AbgALTC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 14:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgALTC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 14:02:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5875A214D8;
        Sun, 12 Jan 2020 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578855745;
        bh=UIRS0SEnchyp42iLA05TKe9m/L5UjGhkJdPBlBBFwXk=;
        h=Date:From:To:Cc:Subject:From;
        b=sJHaBKGQXg4dyPDJtcdCGl1KkNrCRVtFCSvjNYzGQ+MrllHYhwiWz5ar8Qhu/XkIg
         UA4F8aVoqMtGI+FSUS9mkQqkhPVpZ23Vy1xUCBN/PG1CqPI+ZSirQcfXKpbGa8rv15
         FYdJvlrOGKBnTXipO928twZ0RsWMbvTGAmkBhjWs=
Date:   Sun, 12 Jan 2020 20:02:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Linux 4.4.209
Message-ID: <20200112190223.GA1364011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.209 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/boot/dts/am437x-gp-evm.dts               |    2 
 arch/arm/boot/dts/am43x-epos-evm.dts              |    2 
 arch/arm/mach-vexpress/spc.c                      |   12 +++
 arch/mips/include/asm/thread_info.h               |   20 +++++
 arch/parisc/include/asm/cmpxchg.h                 |   10 ++
 arch/powerpc/mm/mem.c                             |    8 ++
 arch/powerpc/platforms/pseries/hvconsole.c        |    2 
 arch/s390/kernel/perf_cpum_sf.c                   |   22 ++++--
 arch/s390/kernel/smp.c                            |   80 ++++++++++++++--------
 arch/tile/lib/atomic_asm_32.S                     |    3 
 arch/x86/include/asm/atomic.h                     |   13 ---
 block/compat_ioctl.c                              |    9 ++
 drivers/bluetooth/btusb.c                         |    3 
 drivers/devfreq/devfreq.c                         |    6 -
 drivers/firewire/net.c                            |    6 +
 drivers/gpio/gpiolib.c                            |    8 ++
 drivers/gpu/drm/drm_dp_mst_topology.c             |    6 +
 drivers/infiniband/core/cma.c                     |    1 
 drivers/md/raid1.c                                |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   12 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |    1 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |   12 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2 
 drivers/net/macvlan.c                             |    2 
 drivers/net/usb/lan78xx.c                         |   11 +--
 drivers/net/vxlan.c                               |    2 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c     |   23 +++++-
 drivers/regulator/rn5t618-regulator.c             |    1 
 drivers/scsi/libsas/sas_discover.c                |   11 ++-
 drivers/scsi/lpfc/lpfc_bsg.c                      |   15 ++--
 drivers/scsi/qla2xxx/qla_isr.c                    |    4 -
 drivers/scsi/qla4xxx/ql4_os.c                     |    1 
 drivers/tty/hvc/hvc_vio.c                         |   16 ++++
 drivers/tty/serial/msm_serial.c                   |   13 +++
 drivers/usb/core/config.c                         |   70 +++++++++++++++----
 drivers/usb/gadget/function/f_ecm.c               |    6 +
 drivers/usb/gadget/function/f_rndis.c             |    1 
 drivers/usb/serial/option.c                       |    2 
 drivers/xen/balloon.c                             |    3 
 fs/locks.c                                        |    2 
 fs/pstore/ram.c                                   |   11 +++
 fs/xfs/xfs_log.c                                  |    2 
 include/linux/dmaengine.h                         |    5 +
 include/linux/if_ether.h                          |    8 ++
 include/net/neighbour.h                           |    2 
 include/uapi/linux/netfilter/xt_sctp.h            |    6 -
 kernel/locking/spinlock_debug.c                   |   32 ++++----
 kernel/taskstats.c                                |   30 +++++---
 kernel/trace/ftrace.c                             |    6 -
 net/8021q/vlan.h                                  |    1 
 net/8021q/vlan_dev.c                              |    3 
 net/8021q/vlan_netlink.c                          |   19 +++--
 net/bluetooth/l2cap_core.c                        |    4 -
 net/core/neighbour.c                              |    4 -
 net/ethernet/eth.c                                |    7 +
 net/ipv4/tcp_input.c                              |    5 +
 net/llc/llc_station.c                             |    4 -
 net/netfilter/nf_conntrack_netlink.c              |    3 
 net/rfkill/core.c                                 |    7 +
 net/sched/sch_fq.c                                |    2 
 net/sctp/sm_sideeffect.c                          |   28 ++++---
 scripts/kconfig/expr.c                            |    7 +
 sound/isa/cs423x/cs4236.c                         |    3 
 sound/pci/ice1712/ice1724.c                       |    9 +-
 sound/soc/codecs/wm8962.c                         |    4 -
 tools/perf/builtin-report.c                       |    7 -
 68 files changed, 459 insertions(+), 189 deletions(-)

Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks

Andreas Kemnade (1):
      regulator: rn5t618: fix module aliases

Arnd Bergmann (1):
      compat_ioctl: block: handle Persistent Reservations

Bo Wu (1):
      scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Brian Foster (1):
      xfs: fix mount failure crash on invalid iclog memory access

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _test_c)

Chen-Yu Tsai (1):
      net: stmmac: dwmac-sunxi: Allow all RGMII modes

Christian Brauner (1):
      taskstats: fix data-race

Chuhong Yuan (1):
      RDMA/cma: add missed unregister_pernet_subsys in init failure

Colin Ian King (1):
      ALSA: cs4236: fix error return comparison of an unsigned integer

Cristian Birsan (1):
      net: usb: lan78xx: Fix error message format specifier

Dan Carpenter (2):
      scsi: iscsi: qla4xxx: fix double free in probe
      Bluetooth: delete a stray unlock

Daniel Axtens (1):
      powerpc/pseries/hvconsole: Fix stack overread via udbg

Daniele Palmas (1):
      USB: serial: option: add Telit ME910G1 0x110a composition

Dmitry Vyukov (1):
      locking/x86: Remove the unused atomic_inc_short() methd

EJ Hsu (1):
      usb: gadget: fix wrong endpoint desc

Eric Dumazet (6):
      net: add annotations on hh->hh_len lockless accesses
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      vlan: vlan_changelink() should propagate errors
      vlan: fix memory leak in vlan_dev_set_egress_priority
      macvlan: do not assume mac_header is set in macvlan_broadcast()

Florian Westphal (1):
      netfilter: ctnetlink: netns exit must wait for callbacks

Greg Kroah-Hartman (1):
      Linux 4.4.209

Hangbin Liu (1):
      vxlan: fix tos value before xmit

Heiko Carstens (1):
      s390/smp: fix physical to logical CPU map for SMT

Helge Deller (1):
      parisc: Fix compiler warnings in debug_core.c

Imre Deak (1):
      drm/mst: Fix MST sideband up-reply failure handling

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Johan Hovold (1):
      USB: core: fix check for duplicate endpoints

Juergen Gross (1):
      xen/balloon: fix ballooned page accounting without hotplug enabled

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Leonard Crestez (1):
      PM / devfreq: Don't fail devfreq_dev_release if not in list

Lukas Wunner (1):
      dmaengine: Fix access to uninitialized dma_slave_caps

Manish Chopra (2):
      bnx2x: Do not handle requests from VFs after parity
      bnx2x: Fix logic to get total no. of PFs per engine

Marco Elver (1):
      locking/spinlock/debug: Fix various data races

Masashi Honma (2):
      ath9k_htc: Modify byte order for an error message
      ath9k_htc: Discard undersized packets

Mike Rapoport (1):
      powerpc: Ensure that swiotlb buffer is allocated from low memory

Oliver Neukum (1):
      Bluetooth: btusb: fix PM leak in error case of setup

Paul Burton (1):
      MIPS: Avoid VDSO ABI breakage due to global register variable

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Roman Bolshakov (1):
      scsi: qla2xxx: Don't call qlt_async_event twice

Russell King (1):
      gpiolib: fix up emulated open drain outputs

Sasha Levin (1):
      Revert "perf report: Add warning when libunwind not compiled in"

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Sudeep Holla (1):
      ARM: vexpress: Set-up shared OPP table instead of individual for each CPU

Takashi Iwai (1):
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code

Thomas Hebb (1):
      kconfig: don't crash on NULL expressions in expr_eq()

Thomas Richter (2):
      s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
      s390/cpum_sf: Avoid SBD overflow condition in irq handler

Tomi Valkeinen (1):
      ARM: dts: am437x-gp/epos-evm: fix panel compatible

Wen Yang (1):
      ftrace: Avoid potential division by zero in function profiler

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Zhiqiang Liu (1):
      md: raid1: check rdev before reference in raid1_sync_request func

