Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B814D792
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 09:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgA3IbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 03:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgA3IbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 03:31:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BA8206D5;
        Thu, 30 Jan 2020 08:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580373067;
        bh=RzhlbNNJ0HPNUn4mFfiL7nGUg+ZdztqsV5DgYeR1CJ8=;
        h=Date:From:To:Cc:Subject:From;
        b=ROY11bumu5R+IG1Lttex8HrPYF9Pxuub0ZGB7lTY3WmZYP+7ngG7JW5Y0Z+FuxeDb
         FBHNGp+zXbTZMaqITrm1U3msVNL8z6HnpeWUPWUiE8BDiyxi/N7xGiby0tthl5SNZP
         cl9XclPljGHhhSQ4gk36ZFjLBupq50bOGircSzAg=
Date:   Thu, 30 Jan 2020 09:31:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.100
Message-ID: <20200130083105.GA646231@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.100 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |    6=20
 Makefile                                        |    2=20
 arch/ia64/mm/init.c                             |   15=20
 arch/powerpc/mm/mem.c                           |   25 -
 arch/powerpc/platforms/powernv/memtrace.c       |    2=20
 arch/powerpc/platforms/pseries/hotplug-memory.c |    6=20
 arch/s390/mm/init.c                             |   16 -
 arch/sh/mm/init.c                               |   15=20
 arch/x86/mm/init_32.c                           |    9=20
 arch/x86/mm/init_64.c                           |   17 -
 drivers/acpi/acpi_memhotplug.c                  |    2=20
 drivers/atm/firestream.c                        |    3=20
 drivers/base/memory.c                           |  203 +++++++-----
 drivers/base/node.c                             |   52 +--
 drivers/crypto/geode-aes.c                      |   57 ++-
 drivers/crypto/geode-aes.h                      |    2=20
 drivers/hwmon/adt7475.c                         |    5=20
 drivers/hwmon/hwmon.c                           |   68 ++--
 drivers/hwmon/nct7802.c                         |    4=20
 drivers/hwtracing/coresight/coresight-etb10.c   |    4=20
 drivers/hwtracing/coresight/coresight-tmc-etf.c |    4=20
 drivers/infiniband/ulp/isert/ib_isert.c         |   12=20
 drivers/input/misc/keyspan_remote.c             |    9=20
 drivers/input/misc/pm8xxx-vibrator.c            |    2=20
 drivers/input/rmi4/rmi_smbus.c                  |    2=20
 drivers/input/tablet/aiptek.c                   |    6=20
 drivers/input/tablet/gtco.c                     |   10=20
 drivers/input/tablet/pegasus_notetaker.c        |    2=20
 drivers/input/touchscreen/sun4i-ts.c            |    6=20
 drivers/input/touchscreen/sur40.c               |    2=20
 drivers/media/v4l2-core/v4l2-ioctl.c            |   24 -
 drivers/mmc/host/sdhci-tegra.c                  |    2=20
 drivers/mmc/host/sdhci.c                        |   10=20
 drivers/net/can/slcan.c                         |   12=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |    4=20
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |    2=20
 drivers/net/ethernet/natsemi/sonic.c            |  380 ++++++++++++++-----=
-----
 drivers/net/ethernet/natsemi/sonic.h            |   44 ++
 drivers/net/gtp.c                               |   10=20
 drivers/net/slip/slip.c                         |   12=20
 drivers/net/tun.c                               |    4=20
 drivers/net/usb/lan78xx.c                       |   15=20
 drivers/net/wireless/marvell/libertas/cfg.c     |   16 -
 drivers/pci/quirks.c                            |   19 -
 drivers/scsi/scsi_transport_iscsi.c             |    7=20
 drivers/scsi/sd.c                               |    8=20
 drivers/target/iscsi/iscsi_target.c             |    6=20
 fs/afs/cell.c                                   |   11=20
 fs/namei.c                                      |   17 -
 include/linux/memory.h                          |    8=20
 include/linux/memory_hotplug.h                  |   22 -
 include/linux/mmzone.h                          |    3=20
 include/linux/netdevice.h                       |    2=20
 include/linux/netfilter/ipset/ip_set.h          |    7=20
 include/linux/node.h                            |    7=20
 include/trace/events/xen.h                      |    6=20
 kernel/memremap.c                               |   12=20
 kernel/trace/trace_events_hist.c                |  177 +++++++++--
 kernel/trace/trace_events_trigger.c             |   20 -
 mm/hmm.c                                        |    8=20
 mm/memory_hotplug.c                             |  166 +++++-----
 mm/sparse.c                                     |   27 -
 net/core/dev.c                                  |   33 +-
 net/core/net-sysfs.c                            |   39 +-
 net/core/rtnetlink.c                            |   13=20
 net/ipv4/ip_tunnel.c                            |    4=20
 net/ipv4/tcp.c                                  |    1=20
 net/ipv4/tcp_bbr.c                              |    3=20
 net/ipv4/tcp_input.c                            |    1=20
 net/ipv4/tcp_output.c                           |    1=20
 net/ipv4/udp.c                                  |    3=20
 net/ipv6/ip6_gre.c                              |    3=20
 net/ipv6/ip6_tunnel.c                           |    4=20
 net/ipv6/seg6_local.c                           |    4=20
 net/netfilter/ipset/ip_set_bitmap_gen.h         |    2=20
 net/netfilter/ipset/ip_set_bitmap_ip.c          |    6=20
 net/netfilter/ipset/ip_set_bitmap_ipmac.c       |    6=20
 net/netfilter/ipset/ip_set_bitmap_port.c        |    6=20
 net/netfilter/nf_tables_api.c                   |   29 +
 net/netfilter/nft_osf.c                         |    3=20
 net/sched/ematch.c                              |    2=20
 net/x25/af_x25.c                                |    6=20
 scripts/recordmcount.c                          |   17 +
 83 files changed, 1101 insertions(+), 721 deletions(-)

Al Viro (1):
      do_last(): fetch directory ->i_mode and ->i_uid before it's too late

Alex Deucher (1):
      PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken

Alex Sverdlin (1):
      ARM: 8950/1: ftrace/recordmcount: filter relocation types

Aneesh Kumar K.V (2):
      powerpc/mm: Fix section mismatch warning
      mm/memunmap: don't access uninitialized memmap in memunmap_pages()

Ard Biesheuvel (1):
      crypto: geode-aes - switch to skcipher for cbc(aes) fallback

Baoquan He (1):
      drivers/base/memory.c: clean up relics in function parameters

Bart Van Assche (1):
      scsi: RDMA/isert: Fix a recently introduced regression related to log=
out

Bo Wu (1):
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Changbin Du (1):
      tracing: xen: Ordered comparison of function pointers

Chuhong Yuan (1):
      Input: sun4i-ts - add a check for devm_thermal_zone_of_sensor_register

Cong Wang (1):
      net_sched: fix datalen for ematch

Dan Carpenter (1):
      mm, memory_hotplug: update a comment in unregister_memory()

Dan Williams (1):
      mm/hotplug: kill is_dev_zone() usage in __remove_pages()

David Hildenbrand (15):
      mm/memory_hotplug: make remove_memory() take the device_hotplug_lock
      mm/memory_hotplug: release memory resource after arch_remove_memory()
      mm/memory_hotplug: make unregister_memory_section() never fail
      mm/memory_hotplug: make __remove_section() never fail
      mm/memory_hotplug: make __remove_pages() and arch_remove_memory() nev=
er fail
      s390x/mm: implement arch_remove_memory()
      mm/memory_hotplug: allow arch_remove_memory() without CONFIG_MEMORY_H=
OTREMOVE
      drivers/base/memory: pass a block_id to init_memory_block()
      mm/memory_hotplug: create memory block devices after arch_add_memory()
      mm/memory_hotplug: remove memory block devices before arch_remove_mem=
ory()
      mm/memory_hotplug: make unregister_memory_block_under_nodes() never f=
ail
      mm/memory_hotplug: remove "zone" parameter from sparse_remove_one_sec=
tion
      drivers/base/node.c: simplify unregister_memory_block_under_nodes()
      mm/memory_hotplug: fix try_offline_node()
      mm/memory_hotplug: shrink zones when offlining memory

David Howells (1):
      afs: Fix characters allowed into cell names

Eric Dumazet (5):
      gtp: make sure only SOCK_DGRAM UDP sockets are accepted
      net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()
      net-sysfs: fix netdev_queue_add_kobject() breakage
      tcp: do not leave dangling pointers in tp->highest_sack
      tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()

Finn Thain (12):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Clear interrupt flags immediately
      net/sonic: Use MMIO accessors
      net/sonic: Fix interface error stats collection
      net/sonic: Fix receive buffer handling
      net/sonic: Avoid needless receive descriptor EOL flag updates
      net/sonic: Improve receive descriptor status flag check
      net/sonic: Fix receive buffer replenishment
      net/sonic: Quiesce SONIC before re-initializing descriptor memory
      net/sonic: Fix command register usage
      net/sonic: Fix CAM initialization
      net/sonic: Prevent tx watchdog timeout

Florian Fainelli (1):
      net: bcmgenet: Use netif_tx_napi_add() for TX NAPI

Florian Westphal (1):
      netfilter: nft_osf: add missing check for DREG attribute

Gilles Buloz (1):
      hwmon: (nct7802) Fix voltage limits to wrong registers

Greg Kroah-Hartman (1):
      Linux 4.19.100

Guenter Roeck (1):
      hwmon: (core) Do not use device managed functions for memory allocati=
ons

Hans Verkuil (2):
      Revert "Input: synaptics-rmi4 - don't increment rmiaddr for SMBus tra=
nsfers"
      media: v4l2-ioctl.c: zero reserved fields for S/TRY_FMT

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jeremy Linton (1):
      Documentation: Document arm64 kpti control

Johan Hovold (5):
      Input: keyspan-remote - fix control-message timeouts
      Input: sur40 - fix interface sanity checks
      Input: gtco - fix endpoint sanity check
      Input: aiptek - fix endpoint sanity check
      Input: pegasus_notetaker - fix endpoint sanity check

Jouni Hogander (4):
      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in netdev_queue_add_kobject
      net-sysfs: Call dev_hold always in rx_queue_add_kobject
      net-sysfs: Fix reference count leak

Kadlecsik J=C3=B3zsef (1):
      netfilter: ipset: use bitmap infrastructure completely

Luuk Paulussen (1):
      hwmon: (adt7475) Make volt2reg return same reg as reg2volt input

Martin Schiller (1):
      net/x25: fix nonblocking connect

Masami Hiramatsu (1):
      tracing: trigger: Replace unneeded RCU-list traversals

Masato Suzuki (1):
      sd: Fix REQ_OP_ZONE_REPORT completion handling

Michael Ellerman (1):
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Micha=C5=82 Miros=C5=82aw (2):
      mmc: tegra: fix SDR50 tuning override
      mmc: sdhci: fix minimum clock rate for v3 controller

Niko Kortstrom (1):
      net: ip6_gre: fix moving ip6gre between namespaces

Oscar Salvador (1):
      mm, memory_hotplug: add nid parameter to arch_remove_memory

Pablo Neira Ayuso (1):
      netfilter: nf_tables: add __nft_chain_type_get()

Paolo Abeni (1):
      Revert "udp: do rmem bulk free even if the rx sk queue is empty"

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Stephan Gerhold (1):
      Input: pm8xxx-vib - fix handling of separate enable register

Steven Rostedt (VMware) (1):
      tracing: Fix histogram code when expression has same var as value

Suzuki K Poulose (2):
      coresight: etb10: Do not call smp_processor_id from preemptible
      coresight: tmc-etf: Do not call smp_processor_id from preemptible

Tom Zanussi (2):
      tracing: Use hist trigger's var_ref array to destroy var_refs
      tracing: Remove open-coding of hist trigger var_ref management

Wei Yang (3):
      mm, sparse: drop pgdat_resize_lock in sparse_add/remove_one_section()
      mm, sparse: pass nid instead of pgdat to sparse_add_one_section()
      drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      tcp_bbr: improve arithmetic division in bbr_update_bw()

Wenwen Wang (1):
      firestream: fix memory leaks

William Dauchy (2):
      net, ip6_tunnel: fix namespaces move
      net, ip_tunnel: fix namespaces move

Yuki Taguchi (1):
      ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4ylEgACgkQONu9yGCS
aT5fFw/9HU5LSoRN3IaycZVf7bMk/U68ilibOcP7k0xesBQuz+Vup1A9k4T51Oo5
RdJhPy9+zGyBLIbzFGjcWKG0iJgXMRtrT44d5jFFoIfijg9hP9R5l/dj7JENj0BX
3tPhlyoAghhs2a4RBdoR7N1MZ1CNIAby7HU/DXANXNHhi4wo7eh0YQW2JLrkISdT
+IHz4IGdam0YXITsoki/ndIfIgmpeNr0kjb5b+1RNpC4DkezG+HtgQLUodt/DcsG
0jziYGhbHGCVFqELpPv+u86IOoWoqwMU4dVqRZZ2bEOInmqA17V3+4h/ByuaC4Jm
T3jFaI7XpPXl+AOl+KARkZiOeTnRosWy20aUheKXwI5e7dpSsjM7yjsrdtJAz7fm
gPjFHlPO9dkIhF4fCry1EgszJGIqmrzfVEUsE+rAnU/1n7iET+p5XL6V7+pAlaBf
bmyA0d9m11anNLH+LjyUAzkKwIbnaimz5YwOa9Lx48fiFe9q4gU659HWUnWD9wpm
qQUu++fVi0KhFO9XzTYZlFCR+hSU6FA3e1oUgNYzHrzOY2IB8esamAlOfgNV7WQb
ce0WD2VdjBRUZHuaNy5QCqI+xd+So5w+5m+SHEukNbw8Hhv8u53rSdO3mEvIQhSu
o2sC8tIXrhUTYqvYIOWGMKFUtGbQVorWJZEmxzX3qxIb1ZNdpoA=
=NuFg
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
