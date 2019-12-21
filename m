Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEDA1288A7
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfLUKls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfLUKls (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:41:48 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A90521655;
        Sat, 21 Dec 2019 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576924906;
        bh=3tuwli954OrAvToudSjyb2y3+lhv7NouCqWVfIM7BQU=;
        h=Date:From:To:Cc:Subject:From;
        b=noZPkNWd+lA6Foqx9vPYmLT4tcKl6wZC07GJh0QEUnCjzw26AF4hRoEeXCBfolx6M
         qfbyZi399xbP0tTiv5/JImje4Ol7t5Dl6m2HSEcUIpRWgdu9DoTu6XInVuJ2Rw85+S
         aXp2xio3/s3vYpjUKiokUdo+aLSah2DskIkyQBYM=
Date:   Sat, 21 Dec 2019 11:41:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.91
Message-ID: <20191221104126.GA61826@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.91 kernel.

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

 Makefile                                                 |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts                   |    4=20
 arch/arm/boot/dts/s3c6410-smdk6410.dts                   |    4=20
 arch/arm/mach-tegra/reset-handler.S                      |    6=20
 arch/arm64/include/asm/assembler.h                       |    8=20
 arch/arm64/kernel/entry.S                                |    6=20
 arch/xtensa/mm/tlb.c                                     |    4=20
 drivers/dma-buf/sync_file.c                              |    2=20
 drivers/gpu/drm/meson/meson_venc_cvbs.c                  |   48 ++--
 drivers/gpu/drm/radeon/r100.c                            |    4=20
 drivers/gpu/drm/radeon/r200.c                            |    4=20
 drivers/md/dm-mpath.c                                    |   37 ---
 drivers/md/persistent-data/dm-btree-remove.c             |    8=20
 drivers/mmc/core/block.c                                 |  151 +++++-----=
-----
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |   27 ++
 drivers/net/ethernet/ti/cpsw.c                           |    2=20
 drivers/pci/hotplug/pciehp.h                             |    2=20
 drivers/pci/hotplug/pciehp_ctrl.c                        |    6=20
 drivers/pci/hotplug/pciehp_hpc.c                         |    2=20
 drivers/pci/msi.c                                        |    2=20
 drivers/pci/pci-driver.c                                 |   17 +
 drivers/pci/quirks.c                                     |   22 +-
 drivers/rpmsg/qcom_glink_native.c                        |   53 ++++-
 drivers/rpmsg/qcom_glink_smem.c                          |    2=20
 drivers/scsi/libiscsi.c                                  |    4=20
 drivers/scsi/qla2xxx/qla_init.c                          |    1=20
 drivers/usb/host/xhci-hub.c                              |    8=20
 drivers/usb/host/xhci-ring.c                             |    3=20
 drivers/vfio/pci/vfio_pci_intrs.c                        |    2=20
 fs/cifs/cifs_debug.c                                     |    5=20
 fs/cifs/file.c                                           |    7=20
 fs/cifs/smb2misc.c                                       |   59 ++++-
 fs/cifs/smb2pdu.c                                        |   16 +
 fs/cifs/smb2proto.h                                      |    3=20
 fs/cifs/smbdirect.c                                      |    8=20
 fs/cifs/transport.c                                      |    7=20
 include/linux/netdevice.h                                |    5=20
 include/linux/time.h                                     |   13 +
 include/net/ip.h                                         |    5=20
 include/net/tcp.h                                        |   27 +-
 net/bridge/br_device.c                                   |    6=20
 net/core/dev.c                                           |    3=20
 net/core/flow_dissector.c                                |    5=20
 net/ipv4/devinet.c                                       |    5=20
 net/ipv4/ip_output.c                                     |   13 -
 net/ipv4/tcp_output.c                                    |    5=20
 net/openvswitch/conntrack.c                              |   11 +
 net/sched/sch_mq.c                                       |    1=20
 net/sched/sch_mqprio.c                                   |    3=20
 net/tipc/core.c                                          |   29 +-
 51 files changed, 415 insertions(+), 264 deletions(-)

Aaron Conole (1):
      openvswitch: support asymmetric conntrack

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures

Alexander Lobakin (1):
      net: dsa: fix flow dissection on Tx path

Arun Kumar Neelakantam (2):
      rpmsg: glink: Fix reuse intents memory leak issue
      rpmsg: glink: Fix use after free in open_ack TIMEOUT case

Bart Van Assche (1):
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Bjorn Andersson (2):
      rpmsg: glink: Don't send pending rx_done during remove
      rpmsg: glink: Free pending deferred work on remove

Chaotian Jing (2):
      mmc: block: Make card_busy_detect() a bit more generic
      mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response

Chris Lew (3):
      rpmsg: glink: Set tail pointer to 0 at end of FIFO
      rpmsg: glink: Put an extra reference during cleanup
      rpmsg: glink: Fix rpmsg_register_device err handling

Dexuan Cui (1):
      PCI/PM: Always return devices to D0 when thawing

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Dust Li (1):
      net: sched: fix dump qlen for sch_mq/sch_mqprio with NOLOCK subqueues

Eric Dumazet (2):
      inet: protect against too small mtu values.
      tcp: md5: fix potential overestimation of TCP option space

George Cherian (1):
      PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3

Greg Kroah-Hartman (2):
      Revert "arm64: preempt: Fix big-endian when checking preempt count in=
 assembly"
      Linux 4.19.91

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

Huy Nguyen (1):
      net/mlx5e: Query global pause state before setting prio2buffer

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume

Jiang Yi (1):
      vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers

Long Li (4):
      cifs: smbd: Return -EAGAIN when transport is reconnecting
      cifs: smbd: Add messages on RDMA session destroy and reconnection
      cifs: smbd: Return -EINVAL when the number of iovs exceeds SMBDIRECT_=
MAX_SGE
      cifs: Don't display RDMA transport on reconnect

Lukas Wunner (1):
      PCI: pciehp: Avoid returning prematurely from sysfs requests

Martin Blumenstingl (1):
      drm: meson: venc: cvbs: fix CVBS mode matching

Mathias Nyman (1):
      xhci: fix USB3 device initiated resume race with roothub autosuspend

Max Filippov (1):
      xtensa: fix TLB sanity checker

Mian Yousaf Kaukab (1):
      net: thunderx: start phy before starting autonegotiation

Mike Snitzer (1):
      dm mpath: remove harmful bio-based optimization

Navid Emamdoost (1):
      dma-buf: Fix memory leak in sync_file_merge()

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Pavel Shilovsky (2):
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
      CIFS: Close open handle after interrupted close

Roman Bolshakov (1):
      scsi: qla2xxx: Change discovery state before PLOGI

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Taehee Yoo (1):
      tipc: fix ordering of tipc module init and exit routine

Vladyslav Tarasiuk (1):
      mqprio: Fix out-of-bounds access in mqprio_dump


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl399tYACgkQONu9yGCS
aT4Vww/9H0+MWaGR5q+EQXU0AO8EYZnM4nWvOxumzJPiaw1BexXr0yFnAOYt4lT/
IyaPkm6LkXqUHQZqqJWONUQg5906JgqRqRoq5T/4CKKC6dZTme8AowTUfwoa1yKE
CnRm1Se7QDA0cyMvT0aywTPKmNU+zxhLWXlPWyoYPSTvL+TDOZ4mLNAg9WDhYASS
0qoTi8Mqn27jOOYcQiJUUR0oJx5zfz3tCcDrqE/KcaIzQj3MmF949r4XLfj/1acB
/lHfTmJGgJFV1g+oGFsy7IJfm41nZgSMeDpWH4uTpgfGXNLxbAINxtXLnxZ7JOvh
xvpq46ltHh79pxGUQfce4yLv16ZYfWjVOmV8HrnFuR4v/oz7zSiKkak535W+JhL1
ULvZpaN5aLDwDeNjECtBVYwx2+93LrmzUKgx6+rJV4Xul/xENxr21Yqpj1u/NQng
3n39gDsrg+/oK5W+VOmbDbC7jOLc2Cv33/Tq294re0TRb3kvQ0yU2hauoJELGuqy
XjNhQzyXq4ig94Y154WMp3lAYH3ffDXwbtibvbJudLXCr/ulS+w4IKuLM7W5Nphh
lFB+Yc0in2qFfi9vYx3fbetIhw5jDB8X6gxb+pG6JYZ45KgVhz3jXEso43eUgWoU
L8OfcMekcC5otZ77h21sibzi3mwY7QH5qkcTuwJJeEFe9NWxuC4=
=N71S
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
