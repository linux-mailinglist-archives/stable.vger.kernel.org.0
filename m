Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A876F4F4E5
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFVJqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfFVJqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA8A208C3;
        Sat, 22 Jun 2019 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196794;
        bh=q5OAdo6a142/tNkWxxE5/fN6VANdjoHj/FwhU9BJFuc=;
        h=Date:From:To:Cc:Subject:From;
        b=xuy8DmKk3wr3RJ5VF+ZhPx5+Tfrtayk25lgM29oL/HrFss3wTI0isAHDER8Ka8lnf
         FkAcTtwbpFhQXHHCLbfy8uzqDv6xw2IPEH8ID9/xZXpldkgEsgzSqVpECvjsYjHUWC
         SmSYVHuA0qd27yb6Qt91drexkXnMs8k4vdYkYXpo=
Date:   Sat, 22 Jun 2019 11:46:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.54
Message-ID: <20190622094631.GA12389@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.54 kernel.

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

 Makefile                                                  |    2=20
 arch/arm64/include/asm/syscall.h                          |    2=20
 arch/arm64/include/asm/syscall_wrapper.h                  |   18 ++--
 arch/arm64/kernel/sys.c                                   |   14 ++-
 arch/arm64/kernel/sys32.c                                 |    7 -
 arch/ia64/mm/numa.c                                       |    1=20
 arch/powerpc/include/asm/kvm_host.h                       |    1=20
 arch/powerpc/kvm/book3s.c                                 |    1=20
 arch/powerpc/kvm/book3s_hv.c                              |    9 --
 arch/powerpc/kvm/book3s_rtas.c                            |   14 +--
 arch/powerpc/platforms/powernv/opal-imc.c                 |    4=20
 arch/x86/events/intel/ds.c                                |   28 +++---
 arch/x86/kernel/cpu/amd.c                                 |    7 +
 drivers/acpi/device_pm.c                                  |    4=20
 drivers/clk/ti/clkctrl.c                                  |    8 -
 drivers/gpio/Kconfig                                      |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_dump.c                    |    5 +
 drivers/i2c/i2c-dev.c                                     |    1=20
 drivers/isdn/mISDN/socket.c                               |    5 -
 drivers/net/dsa/rtl8366.c                                 |    7 -
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          |    7 -
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |   61 +++++++--=
-----
 drivers/net/ethernet/dec/tulip/de4x5.c                    |    1=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c            |    2=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c            |   23 ++---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c             |   25 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            |    4=20
 drivers/net/ethernet/renesas/sh_eth.c                     |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |    1=20
 drivers/net/hyperv/netvsc_drv.c                           |    2=20
 drivers/net/phy/dp83867.c                                 |    4=20
 drivers/net/phy/phylink.c                                 |   10 +-
 drivers/pci/pci-acpi.c                                    |    3=20
 drivers/scsi/cxgbi/libcxgbi.c                             |    4=20
 drivers/scsi/device_handler/scsi_dh_alua.c                |    6 -
 drivers/scsi/libsas/sas_expander.c                        |    2=20
 drivers/scsi/smartpqi/smartpqi_init.c                     |    2=20
 drivers/staging/vc04_services/bcm2835-camera/controls.c   |    4=20
 drivers/tty/serial/sunhv.c                                |    2=20
 drivers/usb/host/xhci-debugfs.c                           |    3=20
 drivers/xen/pvcalls-front.c                               |    4=20
 drivers/xen/xenbus/xenbus.h                               |    3=20
 drivers/xen/xenbus/xenbus_dev_frontend.c                  |   18 ++++
 drivers/xen/xenbus/xenbus_xs.c                            |    7 +
 fs/configfs/dir.c                                         |   14 +--
 fs/inode.c                                                |    9 +-
 fs/ocfs2/filecheck.c                                      |    1=20
 include/linux/sched/mm.h                                  |    4=20
 kernel/events/ring_buffer.c                               |   39 +++++++-
 mm/khugepaged.c                                           |    3=20
 net/ax25/ax25_route.c                                     |    2=20
 net/core/neighbour.c                                      |    7 +
 net/ipv6/ip6_flowlabel.c                                  |    7 -
 net/lapb/lapb_iface.c                                     |    1=20
 net/netfilter/ipvs/ip_vs_core.c                           |    2=20
 net/netfilter/nf_queue.c                                  |    1=20
 net/nfc/netlink.c                                         |    3=20
 net/openvswitch/vport-internal_dev.c                      |   18 ++--
 net/sctp/sm_make_chunk.c                                  |    8 +
 net/tipc/group.c                                          |    1=20
 net/vmw_vsock/virtio_transport_common.c                   |    4=20
 sound/pci/hda/hda_intel.c                                 |    5 -
 tools/perf/arch/s390/util/machine.c                       |    9 +-
 tools/perf/util/data-convert-bt.c                         |    2=20
 tools/perf/util/thread.c                                  |   15 ++-
 tools/testing/selftests/netfilter/nft_nat.sh              |    6 +
 66 files changed, 331 insertions(+), 171 deletions(-)

Alaa Hleihel (1):
      net/mlx5: Avoid reloading already removed devices

Alexander Lochmann (1):
      Abort file_remove_privs() for non-reg. files

Amit Cohen (1):
      mlxsw: spectrum: Prevent force of 56G

Andrea Arcangeli (1):
      coredump: fix race condition between collapse_huge_page() and core du=
mping

Anju T Sudhakar (1):
      powerpc/powernv: Return for invalid IMC domain

Bard Liao (1):
      ALSA: hda - Force polling mode on CNL for fixing codec communication

Biao Huang (1):
      net: stmmac: update rx tail pointer register to fix rx dma hang issue.

Dan Carpenter (2):
      Staging: vc04_services: Fix a couple error codes
      mISDN: make sure device name is NUL terminated

Dmitry Bogdanov (1):
      net: aquantia: fix LRO with FCS error

Eric Dumazet (3):
      ax25: fix inconsistent lock state in ax25_destroy_timer
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Frank van der Linden (1):
      x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Greg Kroah-Hartman (1):
      Linux 4.19.54

Haiyang Zhang (1):
      hv_netvsc: Set probe mode to sync

Igor Russkikh (1):
      net: aquantia: tx clean budget logic error

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

Jia-Ju Bai (1):
      usb: xhci: Fix a potential null pointer dereference in xhci_debugfs_c=
reate_endpoint()

John Paul Adrian Glaubitz (1):
      sunhv: Fix device naming inconsistency between sunhv_console and sunh=
v_reg

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Lianbo Jiang (1):
      scsi: smartpqi: properly set both the DMA mask and the coherent DMA m=
ask

Linus Walleij (1):
      net: dsa: rtl8366: Fix up VLAN filtering

Lucas Stach (1):
      drm/etnaviv: lock MMU while dumping core

Max Uvarov (1):
      net: phy: dp83867: Set up RGMII TX delay

Maxime Chevallier (2):
      net: mvpp2: prs: Fix parser range for VID filtering
      net: mvpp2: prs: Use the correct helpers when removing all VID filters

Namhyung Kim (1):
      perf namespace: Protect reading thread's namespace

Neil Horman (1):
      sctp: Free cookie before we memdup a new one

Paul Mackerras (2):
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token l=
ist
      KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Peter Zijlstra (2):
      perf/ring_buffer: Add ordering to rb->nest increment
      perf/ring-buffer: Always use {READ,WRITE}_ONCE() for rb->user_page da=
ta

Rafael J. Wysocki (1):
      ACPI/PCI: PM: Add missing wakeup.flags.valid checks

Randy Dunlap (2):
      gpio: fix gpio-adp5588 build errors
      ia64: fix build errors by exporting paddr_to_nid()

Ross Lagerwall (1):
      xenbus: Avoid deadlock during suspend due to open transactions

Russell King (1):
      net: phylink: ensure consistent phy interface mode

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Sami Tolvanen (3):
      arm64: fix syscall_fn_t type
      arm64: use the correct function type in SYSCALL_DEFINE0
      arm64: use the correct function type for __arm64_sys_ni_syscall

Shawn Landden (1):
      perf data: Fix 'strncat may truncate' build failure with recent gcc

Stephane Eranian (1):
      perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Stephen Barber (1):
      vsock/virtio: set SOCK_DONE on peer shutdown

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

Xin Long (1):
      tipc: purge deferredq list for each grp member in tipc_group_delete

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

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


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+PcACgkQONu9yGCS
aT4GkxAAnMXo7BxQaUGhiP+7Nbj0mI6cpWwfzUL5g14K6dNWlW7US2f83P2WuKHM
+5Wrm3r/x3oLQxy20jKCOLjIeAGU42p2hMexo5RQQcFmChLmhRfcNyqxwYVXImRm
vH8NTo1tZP1iAsfGCZGcjBbPahOK92qN+R/zjy+4zHLOa1mJQdWbjdoMoX8xzkCy
h1IlUgA5q3nfoSaKgEgeTsXkblCu80xh8b2ZniOXaCB5bci3bDiJl1OXy4at9I5M
zaB44ICLj6uBULxWl8gOBUH6aQnCUkiUXBYbK0c4xqSrCnM/U93+FUE4D+I7Un2S
VAvJjqtx9Z59m5D49YzA31ZKTJZ02Wavyu59kHc8824g0pJ1Kz1k+q7HRlQl9AfM
DtW6KyKeC0DNsa2NvkyCdu7+lEGn6AdkuShg59o7giRwwnyxMRb0RHBjAkx+7dD7
5ncZKggGs8HYD11p2o9LFwA3CAxaM3dBM7ZH37olqPs7cuF61OD+p1JJS9dFMhL3
b1lChGiY+32JkoiB4pFNnWxP6oWAmAPviwlP+GASLQdQ6Kb5tVAizCjdMJ8BOVLy
F9ZzXwdFcwRfyeDtKx1lhqtRvvHVPC3LcELZcu3UajbmZH8KtIyDdIjFkY5gtnEs
GManv3psIHhkfb3oanGh9cu4wNypi6r68Be0TeYsXL0QtSL8jaI=
=1GH2
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
