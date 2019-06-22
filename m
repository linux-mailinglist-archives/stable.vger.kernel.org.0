Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400E34F4ED
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfFVJr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfFVJr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:47:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0A62063F;
        Sat, 22 Jun 2019 09:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196846;
        bh=WfoAhO2RsRPHLw+kkxWXNqyN68fntFIwFiyMLiScUXk=;
        h=Date:From:To:Cc:Subject:From;
        b=AKB9kimFhE2A4oluah5Ols35jh0glwL23DkCP9xJMzptQstCtqMrWOgQb9y242tK/
         LLFWExT0uyZIgQ3+iQxwgffd0uEbfi3GJJO/GVhInEXhpdWzGrdVemhZrGhSGSGX6C
         yAzPtNKqoFncIKyjICyy9EYiPQgJcoOYwgtpTfBc=
Date:   Sat, 22 Jun 2019 11:47:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.13
Message-ID: <20190622094724.GA12529@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.13 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/arm64/include/asm/syscall.h                          |    2=20
 arch/arm64/include/asm/syscall_wrapper.h                  |   18 +--
 arch/arm64/kernel/sys.c                                   |   14 +-
 arch/arm64/kernel/sys32.c                                 |    7 -
 arch/ia64/mm/numa.c                                       |    1=20
 arch/powerpc/include/asm/kvm_host.h                       |    2=20
 arch/powerpc/kvm/book3s.c                                 |    1=20
 arch/powerpc/kvm/book3s_64_mmu_hv.c                       |   36 +++---
 arch/powerpc/kvm/book3s_hv.c                              |   40 ++++---
 arch/powerpc/kvm/book3s_rtas.c                            |   14 +-
 arch/powerpc/platforms/powernv/opal-imc.c                 |    4=20
 arch/s390/include/asm/ap.h                                |    4=20
 arch/x86/events/intel/ds.c                                |   28 ++---
 arch/x86/kernel/cpu/amd.c                                 |    7 -
 block/blk-mq.c                                            |    5=20
 drivers/acpi/device_pm.c                                  |    4=20
 drivers/clk/ti/clkctrl.c                                  |    8 -
 drivers/gpio/Kconfig                                      |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                    |    5=20
 drivers/i2c/i2c-dev.c                                     |    1=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                |   46 ++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                 |   20 +++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c                |    3=20
 drivers/isdn/mISDN/socket.c                               |    5=20
 drivers/net/dsa/microchip/ksz_common.c                    |    3=20
 drivers/net/dsa/rtl8366.c                                 |    7 -
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          |    7 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   61 ++++++---=
--
 drivers/net/ethernet/dec/tulip/de4x5.c                    |    1=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c            |    2=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c            |    9 -
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c        |    4=20
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c          |    4=20
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c      |    3=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c            |   23 ++--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c             |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c             |   25 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h              |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c       |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c          |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           |    3=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c    |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c     |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c     |   73 +++++++++=
++++-
 drivers/net/ethernet/renesas/sh_eth.c                     |    4=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c      |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |    7 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c     |    5=20
 drivers/net/geneve.c                                      |    2=20
 drivers/net/hyperv/netvsc_drv.c                           |    2=20
 drivers/net/phy/dp83867.c                                 |   39 ++++++-
 drivers/net/phy/phylink.c                                 |   10 +
 drivers/net/vxlan.c                                       |    2=20
 drivers/nvme/host/tcp.c                                   |   70 +++++++++=
+---
 drivers/pci/pci-acpi.c                                    |    3=20
 drivers/pinctrl/intel/pinctrl-intel.c                     |   37 +------
 drivers/s390/crypto/ap_bus.c                              |   26 ++++
 drivers/s390/crypto/ap_bus.h                              |    3=20
 drivers/s390/crypto/zcrypt_api.c                          |   17 ++-
 drivers/scsi/cxgbi/libcxgbi.c                             |    4=20
 drivers/scsi/device_handler/scsi_dh_alua.c                |    6 -
 drivers/scsi/libsas/sas_expander.c                        |    2=20
 drivers/scsi/smartpqi/smartpqi_init.c                     |    2=20
 drivers/staging/erofs/super.c                             |    1=20
 drivers/staging/vc04_services/bcm2835-camera/controls.c   |    4=20
 drivers/staging/wilc1000/wilc_wlan.c                      |    8 +
 drivers/tty/serial/sunhv.c                                |    2=20
 drivers/usb/host/xhci-debugfs.c                           |    3=20
 drivers/xen/pvcalls-front.c                               |    4=20
 drivers/xen/xenbus/xenbus.h                               |    3=20
 drivers/xen/xenbus/xenbus_dev_frontend.c                  |   18 +++
 drivers/xen/xenbus/xenbus_xs.c                            |    7 -
 fs/cifs/dfs_cache.c                                       |    4=20
 fs/configfs/dir.c                                         |   14 +-
 fs/io_uring.c                                             |    2=20
 fs/ocfs2/filecheck.c                                      |    1=20
 include/linux/sched/mm.h                                  |    4=20
 include/net/flow_dissector.h                              |    1=20
 include/net/netfilter/nft_fib.h                           |    2=20
 kernel/events/ring_buffer.c                               |   39 ++++++-
 mm/khugepaged.c                                           |    3=20
 mm/mmu_gather.c                                           |   24 +++-
 net/ax25/ax25_route.c                                     |    2=20
 net/core/ethtool.c                                        |    5=20
 net/core/neighbour.c                                      |    7 +
 net/ipv4/ip_output.c                                      |    2=20
 net/ipv4/netfilter/nft_fib_ipv4.c                         |   23 ----
 net/ipv6/ip6_flowlabel.c                                  |    7 -
 net/ipv6/ip6_output.c                                     |    2=20
 net/ipv6/netfilter/nft_fib_ipv6.c                         |   16 ---
 net/lapb/lapb_iface.c                                     |    1=20
 net/netfilter/ipvs/ip_vs_core.c                           |    2=20
 net/netfilter/nf_nat_helper.c                             |    2=20
 net/netfilter/nf_queue.c                                  |    1=20
 net/netfilter/nf_tables_api.c                             |   20 ++-
 net/netfilter/nft_fib.c                                   |    6 -
 net/nfc/netlink.c                                         |    3=20
 net/openvswitch/vport-internal_dev.c                      |   18 ++-
 net/sctp/sm_make_chunk.c                                  |    8 +
 net/tipc/group.c                                          |    1=20
 net/tls/tls_sw.c                                          |    1=20
 net/vmw_vsock/virtio_transport_common.c                   |    4=20
 sound/firewire/fireface/ff-protocol-latter.c              |   10 -
 sound/pci/hda/hda_intel.c                                 |    5=20
 tools/perf/arch/s390/util/machine.c                       |    9 +
 tools/perf/util/data-convert-bt.c                         |    2=20
 tools/perf/util/thread.c                                  |   15 ++
 tools/testing/selftests/netfilter/nft_nat.sh              |    6 -
 111 files changed, 759 insertions(+), 359 deletions(-)

Alaa Hleihel (2):
      net/mlx5: Avoid reloading already removed devices
      net/mlx5e: Avoid detaching non-existing netdev under switchdev mode

Amit Cohen (1):
      mlxsw: spectrum: Prevent force of 56G

Andrea Arcangeli (1):
      coredump: fix race condition between collapse_huge_page() and core du=
mping

Anju T Sudhakar (1):
      powerpc/powernv: Return for invalid IMC domain

Bard Liao (1):
      ALSA: hda - Force polling mode on CNL for fixing codec communication

Biao Huang (3):
      net: stmmac: update rx tail pointer register to fix rx dma hang issue.
      net: stmmac: fix csr_clk can't be zero issue
      net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio read/wr=
ite fail

Chengguang Xu (1):
      staging: erofs: set sb->s_root to NULL when failing from __getname()

Chris Mi (1):
      net/mlx5e: Add ndo_set_feature for uplink representor

Dan Carpenter (3):
      Staging: vc04_services: Fix a couple error codes
      staging: wilc1000: Fix some double unlock bugs in wilc_wlan_cleanup()
      mISDN: make sure device name is NUL terminated

Dmitry Bogdanov (1):
      net: aquantia: fix LRO with FCS error

Edward Srouji (1):
      net/mlx5: Update pci error handler entries and command translation

Eli Britstein (1):
      net/mlx5e: Support tagged tunnel over bond

Eric Dumazet (3):
      ax25: fix inconsistent lock state in ax25_destroy_timer
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Florian Westphal (2):
      netfilter: nat: fix udp checksum corruption
      netfilter: nf_tables: fix oops during rule dump

Frank van der Linden (1):
      x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Geert Uytterhoeven (1):
      ALSA: fireface: Use ULL suffixes for 64-bit constants

Gen Zhang (1):
      dfs_cache: fix a wrong use of kfree in flush_cache_ent()

Greg Kroah-Hartman (1):
      Linux 5.1.13

Haiyang Zhang (1):
      hv_netvsc: Set probe mode to sync

Harald Freudenberger (1):
      s390/zcrypt: Fix wrong dispatching for control domain CPRBs

Ido Schimmel (1):
      mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Igor Russkikh (1):
      net: aquantia: tx clean budget logic error

Ioana Radulescu (2):
      dpaa2-eth: Fix potential spectre issue
      dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

Jagdish Motwani (1):
      netfilter: nf_queue: fix reinject verdict handling

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed

Jeffrin Jose T (1):
      selftests: netfilter: missing error check when setting up veth interf=
ace

Jeremy Sowden (1):
      lapb: fixed leak of control-blocks.

Jes Sorensen (1):
      blk-mq: Fix memory leak in error handling

Jia-Ju Bai (1):
      usb: xhci: Fix a potential null pointer dereference in xhci_debugfs_c=
reate_endpoint()

Jiri Pirko (1):
      mlxsw: spectrum_flower: Fix TOS matching

John Fastabend (1):
      net: tls, correctly account for copied bytes with multiple sk_msgs

John Paul Adrian Glaubitz (1):
      sunhv: Fix device naming inconsistency between sunhv_console and sunh=
v_reg

Kai-Heng Feng (1):
      pinctrl: intel: Clear interrupt status in mask/unmask callback

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Lianbo Jiang (1):
      scsi: smartpqi: properly set both the DMA mask and the coherent DMA m=
ask

Linus Walleij (1):
      net: dsa: rtl8366: Fix up VLAN filtering

Lucas Stach (1):
      drm/etnaviv: lock MMU while dumping core

Madalin Bucur (1):
      dpaa_eth: use only online CPU portals

Max Uvarov (3):
      net: phy: dp83867: fix speed 10 in sgmii mode
      net: phy: dp83867: increase SGMII autoneg timer duration
      net: phy: dp83867: Set up RGMII TX delay

Maxime Chevallier (3):
      net: mvpp2: prs: Fix parser range for VID filtering
      net: mvpp2: prs: Use the correct helpers when removing all VID filters
      net: ethtool: Allow matching on vlan DEI bit

Namhyung Kim (1):
      perf namespace: Protect reading thread's namespace

Neil Horman (1):
      sctp: Free cookie before we memdup a new one

Paul Mackerras (3):
      KVM: PPC: Book3S HV: Use new mutex to synchronize MMU setup
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token l=
ist
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Pavel Begunkov (1):
      io_uring: Fix __io_uring_register() false success

Peter Zijlstra (2):
      perf/ring_buffer: Add ordering to rb->nest increment
      perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page da=
ta

Petr Machata (1):
      mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2

Phil Sutter (1):
      netfilter: nft_fib: Fix existence check support

Raed Salem (1):
      net/mlx5e: Fix source port matching in fdb peer flow rule

Rafael J. Wysocki (1):
      ACPI/PCI: PM: Add missing wakeup.flags.valid checks

Randy Dunlap (2):
      gpio: fix gpio-adp5588 build errors
      ia64: fix build errors by exporting paddr_to_nid()

Robert Hancock (1):
      net: dsa: microchip: Don't try to read stats for unused ports

Ross Lagerwall (1):
      xenbus: Avoid deadlock during suspend due to open transactions

Russell King (1):
      net: phylink: ensure consistent phy interface mode

Sagi Grimberg (3):
      nvme-tcp: rename function to have nvme_tcp prefix
      nvme-tcp: fix possible null deref on a timed out io queue connect
      nvme-tcp: fix queue mapping when queue count is limited

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Sami Tolvanen (3):
      arm64: fix syscall_fn_t type
      arm64: use the correct function type in SYSCALL_DEFINE0
      arm64: use the correct function type for __arm64_sys_ni_syscall

Shawn Landden (1):
      perf data: Fix 'strncat may truncate' build failure with recent gcc

Stefano Brivio (2):
      vxlan: Don't assume linear buffers in error handler
      geneve: Don't assume linear buffers in error handler

Stephane Eranian (1):
      perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Stephen Barber (1):
      vsock/virtio: set SOCK_DONE on peer shutdown

Steve Moskovchenko (1):
      iio: imu: mpu6050: Fix FIFO layout for ICM20602

Taehee Yoo (1):
      net: openvswitch: do not free vport if register_netdevice() is failed.

Thomas Richter (1):
      perf record: Fix s390 missing module symbol and warning for non-root =
users

Tobin C. Harding (1):
      ocfs2: fix error path kobject memory leak

Tony Lindgren (1):
      clk: ti: clkctrl: Fix clkdm_clk handling

Varun Prakash (1):
      scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Willem de Bruijn (1):
      net: correct udp zerocopy refcnt also when zerocopy only on append

Xin Long (1):
      tipc: purge deferredq list for each grp member in tipc_group_delete

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

Yang Shi (1):
      mm: mmu_gather: remove __tlb_reset_range() for force flush

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Yoshihiro Shimoda (1):
      net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/=
A1 SoCs

Young Xiao (1):
      nfc: Ensure presence of required attributes in the deactivate_target =
handler

YueHaibing (3):
      ipvs: Fix use-after-free in ip_vs_in
      xen/pvcalls: Remove set but not used variable
      scsi: scsi_dh_alua: Fix possible null-ptr-deref


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+SwACgkQONu9yGCS
aT4FuhAA1lSp493kC4mq1vVjde3AKi+DitzFsPC68v/Cf0icnJNScMRo67NjJxgw
CRpnEAFMhEx3yTVTo3UNfj6Cs+urFA7iY1kQ9yG6nj3+EvmkLE+IBs3FB2u0EmV/
7tD7DDlZCjV78V7aPcMn7hsGijE+lk7XnfaFiNrEXgdlxjpkbyL0bB6fXM/29Gi+
jB8CWRX9T91JiVscqIVRfMNL1DjGe7m7KHBORqDxnyQJvfGFBd1vgoRjTjYFRPIP
H8wp2Q98uw4ZADK+BkrGZxLjRwGabkzSudVRDKDG5Ir+sZfrqEy1gmu1hjhqDX5Z
LLy2xPUYDty5PhpdlgZK6QEdwDyYkE4usvedsNDlyUikpJ/Xw75+G9xMTcTbWhqo
Y3asOtleo1F1z0z3+6qMp2Uz+xS4Pg9Jx3zGWejt1omYxpR+74dORYhwS5F91vPK
6C6ecPSRhPlR/QDgyKJc202ScHKaI+NooBxLIZdR+UJkfNBhE9XYapylBZYdv1P4
+yBSQ++QpxxTVnSOLj0ZJt9dXaO6Cfach0kXgwrp6lj0IF6CJB4jeY3fNGSerqBS
OBI7k389xnZynyPh12Gt/uX1pvaF9sIayQX4CgyvAjmnJUP6iLR0t9VuH1FPpqmi
W9NcJC7paedsWXgh2KxRPUmoHNiW0sP90n/xx94ulet5s56kcQA=
=LyD1
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
