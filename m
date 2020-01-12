Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F2A1387CF
	for <lists+stable@lfdr.de>; Sun, 12 Jan 2020 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733201AbgALTDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jan 2020 14:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgALTDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jan 2020 14:03:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08228214D8;
        Sun, 12 Jan 2020 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578855800;
        bh=TDbN9zmPH5sY8Mkn8C/T1F389vR5JxfM9maSqxTJ4kk=;
        h=Date:From:To:Cc:Subject:From;
        b=RkMJKhA2G4aN87bpOQmWvAfCQbF7IHVcq24W9O3V8Ge5uNIRndFhBSmwxNPVFJGwd
         lk06FSei5CnhDeVK8rlgTvaxo/IOPwLd8hRTuJ1brdmJdHqjpDCebKL3akqjf3eNWE
         kBVZ6k1Bwjym3F7pA4UiR9bTmMCVKfhxAGezKvR0=
Date:   Sun, 12 Jan 2020 20:03:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.209
Message-ID: <20200112190318.GA1364332@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.209 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/am437x-gp-evm.dts               |    2=20
 arch/arm/boot/dts/am43x-epos-evm.dts              |    2=20
 arch/arm/mach-vexpress/spc.c                      |   12 ++
 arch/arm64/include/asm/pgtable-prot.h             |    5=20
 arch/arm64/include/asm/pgtable.h                  |   10 -
 arch/arm64/mm/fault.c                             |    2=20
 arch/mips/include/asm/thread_info.h               |   20 +++
 arch/parisc/include/asm/cmpxchg.h                 |   10 +
 arch/powerpc/mm/mem.c                             |    8 +
 arch/powerpc/platforms/pseries/hvconsole.c        |    2=20
 arch/s390/kernel/perf_cpum_sf.c                   |   22 +++-
 arch/s390/kernel/smp.c                            |   80 ++++++++++-----
 arch/tile/lib/atomic_asm_32.S                     |    3=20
 arch/x86/events/core.c                            |    9 +
 arch/x86/include/asm/atomic.h                     |   13 --
 block/blk-map.c                                   |    2=20
 block/compat_ioctl.c                              |    9 +
 drivers/ata/ahci_brcm.c                           |  112 ++++++++++++++++-=
-----
 drivers/ata/libahci_platform.c                    |    6 -
 drivers/block/xen-blkback/blkback.c               |    2=20
 drivers/block/xen-blkback/xenbus.c                |   10 +
 drivers/bluetooth/btusb.c                         |    3=20
 drivers/devfreq/devfreq.c                         |    8 -
 drivers/firewire/net.c                            |    6 -
 drivers/firmware/efi/libstub/gop.c                |   80 +++------------
 drivers/gpio/gpiolib.c                            |    8 +
 drivers/gpu/drm/drm_dp_mst_topology.c             |    6 -
 drivers/gpu/drm/drm_property.c                    |    2=20
 drivers/infiniband/core/cma.c                     |    1=20
 drivers/infiniband/hw/mlx4/main.c                 |    9 -
 drivers/md/raid1.c                                |    2=20
 drivers/media/usb/b2c2/flexcop-usb.c              |    2=20
 drivers/media/usb/dvb-usb/af9005.c                |    5=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |   12 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2=20
 drivers/net/macvlan.c                             |    2=20
 drivers/net/usb/lan78xx.c                         |   11 --
 drivers/net/vxlan.c                               |    4=20
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c     |   23 +++-
 drivers/regulator/ab8500.c                        |   17 ---
 drivers/regulator/rn5t618-regulator.c             |    1=20
 drivers/scsi/libsas/sas_discover.c                |   11 +-
 drivers/scsi/lpfc/lpfc_bsg.c                      |   15 +-
 drivers/scsi/qla2xxx/qla_isr.c                    |    4=20
 drivers/scsi/qla4xxx/ql4_os.c                     |    1=20
 drivers/spi/spi-cavium-thunderx.c                 |    2=20
 drivers/tty/hvc/hvc_vio.c                         |   16 ++-
 drivers/tty/serial/msm_serial.c                   |   13 ++
 drivers/usb/core/config.c                         |   70 +++++++++++--
 drivers/usb/gadget/function/f_ecm.c               |    6 -
 drivers/usb/gadget/function/f_rndis.c             |    1=20
 drivers/usb/serial/option.c                       |    2=20
 drivers/xen/balloon.c                             |    3=20
 fs/compat_ioctl.c                                 |    3=20
 fs/locks.c                                        |    2=20
 fs/nfsd/nfs4state.c                               |   15 +-
 fs/pstore/ram.c                                   |   11 ++
 fs/xfs/libxfs/xfs_bmap.c                          |    2=20
 fs/xfs/xfs_log.c                                  |    2=20
 include/linux/ahci_platform.h                     |    2=20
 include/linux/dmaengine.h                         |    5=20
 include/linux/if_ether.h                          |    8 +
 include/linux/regulator/ab8500.h                  |    1=20
 include/net/neighbour.h                           |    2=20
 include/uapi/linux/netfilter/xt_sctp.h            |    6 -
 kernel/cred.c                                     |    6 -
 kernel/locking/spinlock_debug.c                   |   32 +++---
 kernel/power/snapshot.c                           |    9 +
 kernel/taskstats.c                                |   30 +++--
 kernel/trace/ftrace.c                             |    6 -
 kernel/trace/tracing_map.c                        |    4=20
 mm/mmap.c                                         |    6 -
 mm/zsmalloc.c                                     |    5=20
 net/8021q/vlan.h                                  |    1=20
 net/8021q/vlan_dev.c                              |    3=20
 net/8021q/vlan_netlink.c                          |   19 ++-
 net/bluetooth/hci_conn.c                          |    4=20
 net/bluetooth/l2cap_core.c                        |    4=20
 net/core/neighbour.c                              |    4=20
 net/ethernet/eth.c                                |    7 +
 net/ipv4/tcp_input.c                              |    5=20
 net/llc/llc_station.c                             |    4=20
 net/netfilter/nf_conntrack_netlink.c              |    3=20
 net/rfkill/core.c                                 |    7 -
 net/rxrpc/peer_event.c                            |    3=20
 net/sched/sch_fq.c                                |    2=20
 net/sched/sch_prio.c                              |   10 +
 net/sctp/sm_sideeffect.c                          |   28 +++--
 samples/bpf/trace_event_user.c                    |    4=20
 scripts/kconfig/expr.c                            |    7 +
 sound/isa/cs423x/cs4236.c                         |    3=20
 sound/pci/ice1712/ice1724.c                       |    9 +
 sound/soc/codecs/wm8962.c                         |    4=20
 tools/perf/builtin-report.c                       |    7 -
 99 files changed, 655 insertions(+), 348 deletions(-)

Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Al Viro (1):
      fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones

Alexander Shishkin (1):
      perf/x86/intel: Fix PT PMI handling

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks

Andreas Kemnade (1):
      regulator: rn5t618: fix module aliases

Andy Whitcroft (1):
      PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Arnd Bergmann (1):
      compat_ioctl: block: handle Persistent Reservations

Arvind Sankar (3):
      efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
      efi/gop: Return EFI_SUCCESS if a usable GOP was found
      efi/gop: Fix memory leak in __gop_query32/64()

Bo Wu (1):
      scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Brian Foster (1):
      xfs: fix mount failure crash on invalid iclog memory access

Catalin Marinas (1):
      arm64: Revert support for execute-only user mappings

Chan Shu Tak, Alex (1):
      llc2: Fix return statement of llc_stat_ev_rx_null_dsap_xid_c (and _te=
st_c)

Chanho Min (1):
      mm/zsmalloc.c: fix the migrated zspage statistics.

Chen-Yu Tsai (1):
      net: stmmac: dwmac-sunxi: Allow all RGMII modes

Christian Brauner (1):
      taskstats: fix data-race

Chuhong Yuan (2):
      RDMA/cma: add missed unregister_pernet_subsys in init failure
      spi: spi-cavium-thunderx: Add missing pci_release_regions()

Colin Ian King (2):
      ALSA: cs4236: fix error return comparison of an unsigned integer
      media: flexcop-usb: ensure -EIO is returned on error condition

Cristian Birsan (1):
      net: usb: lan78xx: Fix error message format specifier

Dan Carpenter (2):
      scsi: iscsi: qla4xxx: fix double free in probe
      Bluetooth: delete a stray unlock

Daniel Axtens (1):
      powerpc/pseries/hvconsole: Fix stack overread via udbg

Daniel T. Lee (1):
      samples: bpf: Replace symbol compare of trace_event

Daniel Vetter (1):
      drm: limit to INT_MAX in create_blob ioctl

Daniele Palmas (1):
      USB: serial: option: add Telit ME910G1 0x110a composition

David Howells (1):
      rxrpc: Fix possible NULL pointer access in ICMP handling

Dmitry Vyukov (1):
      locking/x86: Remove the unused atomic_inc_short() methd

EJ Hsu (1):
      usb: gadget: fix wrong endpoint desc

Eric Dumazet (6):
      net: add annotations on hh->hh_len lockless accesses
      macvlan: do not assume mac_header is set in macvlan_broadcast()
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      vlan: vlan_changelink() should propagate errors
      vlan: fix memory leak in vlan_dev_set_egress_priority

Florian Fainelli (3):
      ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
      ata: ahci_brcm: Allow optional reset controller to be used
      ata: ahci_brcm: Fix AHCI resources management

Florian Westphal (1):
      netfilter: ctnetlink: netns exit must wait for callbacks

Greg Kroah-Hartman (1):
      Linux 4.9.209

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

Jose Abreu (1):
      net: stmmac: RX buffer size must be 16 byte aligned

Juergen Gross (1):
      xen/balloon: fix ballooned page accounting without hotplug enabled

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Leonard Crestez (2):
      PM / devfreq: Don't fail devfreq_dev_release if not in list
      PM / devfreq: Check NULL governor in available_governors_show

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

Navid Emamdoost (2):
      Bluetooth: Fix memory leak in hci_connect_le_scan
      media: usb: fix memory leak in af9005_identify_state

Oliver Neukum (1):
      Bluetooth: btusb: fix PM leak in error case of setup

Omar Sandoval (1):
      xfs: don't check for AG deadlock for realtime files in bunmapi

Parav Pandit (1):
      IB/mlx4: Follow mirror sequence of device add during device removal

Paul Burton (1):
      MIPS: Avoid VDSO ABI breakage due to global register variable

Paul Durrant (1):
      xen-blkback: prevent premature module unload

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Petr Machata (1):
      net: sch_prio: When ungrafting, replace with FIFO

Phil Sutter (1):
      netfilter: uapi: Avoid undefined left-shift in xt_sctp.h

Roman Bolshakov (1):
      scsi: qla2xxx: Don't call qlt_async_event twice

Russell King (1):
      gpiolib: fix up emulated open drain outputs

Sasha Levin (1):
      Revert "perf report: Add warning when libunwind not compiled in"

Scott Mayhew (1):
      nfsd4: fix up replay_matches_cache()

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages

Shakeel Butt (1):
      memcg: account security cred as well to kmemcg

Shengjiu Wang (1):
      ASoC: wm8962: fix lambda value

Stephan Gerhold (1):
      regulator: ab8500: Remove AB8505 USB regulator

Steven Rostedt (VMware) (1):
      tracing: Have the histogram compare functions convert to u64 first

Sudeep Holla (1):
      ARM: vexpress: Set-up shared OPP table instead of individual for each=
 CPU

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

Yang Yingliang (1):
      block: fix memleak when __blk_rq_map_user_iov() is failed

Zhiqiang Liu (1):
      md: raid1: check rdev before reference in raid1_sync_request func


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4bbXMACgkQONu9yGCS
aT4u8g/+KYJ/GVqpVAbNY1DIMsZK12H5nfBWIBDddt9mLnqf8RQz7flRjBFW9D8U
3/1h2CDFGp+xgqn7yL2GOiP1FJnlJ46WLjDs+D5SzrKRlvuMeajNcm0zsmNDiWlh
rqgkgRbYste9XhKUA0nPq7gYAchVdBM1GV7AH1k84mc/n1EjgNpgjlx/P17K2Ep0
o0bJjYJgFxlNSrIGYg2pTS1+cPF5xyrvzVzzeZlRrHPjyruMrFtvZv73+Ks6tHki
Fc9RGQp0sEh/ls3sFP9OFDoDNLFSM9TgGxQf3EC6MyJVDEu5yd5PSXnEosMIBrhG
g/uMud8miiR7+mEoBmF8DbMx6nQG6J35LoYJE2TUIuEDupa6quCArm9YwVERItLJ
obuHvgHFA5GRarojCU5WZe8u/5o2gZk9ctXWs5wREzEqtt7XpH5IaKoc4tYGNcrz
sEH91YiBngZaqQe1u+w08G8vY60HC5eSI79+U8//M0RqVXXHpi6C8AE6BUPYJXXo
oBtZAe+Uy9J87SK5WXADNl+EMUaq9RLheelAVnYGOiEeMhQDv2szy2HTFbwGjnuz
jMfeJaeG3Dk1JCPIOwfwjReoIeafAcwGfJjWAsb6f962ruKsvnDrclHycv1Ad31F
/lnVhgVTpA4rwUgebcpzryv2n6x3P3fZ6HpZM6wSNKG2EYaM3p8=
=Imv4
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
