Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C19B3A42D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 09:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfFIHkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 03:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbfFIHkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 03:40:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4429F2070B;
        Sun,  9 Jun 2019 07:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560066002;
        bh=JSAMkNTZxZGQB0Jgs3a80F3gkvo01GLQ5d57uHmK9bY=;
        h=Date:From:To:Cc:Subject:From;
        b=qFVp8h4kvo4jV3EqJpgtQLswD3hT5dh45YE+LjXrIjFXogZftf7pjDxkJJ6t8tIVz
         zXg7h4jPiR6Oqqzd/i1t/ObT/pJbX0dihCtC9Fy8mELG/dqBN4jYWXBuDdit4wnP8A
         wtuJl6+ef26jH81IckuARwXaHffoTT66oW5xZy8U=
Date:   Sun, 9 Jun 2019 09:40:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.124
Message-ID: <20190609074000.GA10361@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.124 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/conf.py                                              |    2=
=20
 Documentation/sphinx/kerneldoc.py                                  |   44 =
+-
 Documentation/sphinx/kernellog.py                                  |   28 +
 Documentation/sphinx/kfigure.py                                    |   40 +
 Makefile                                                           |    2=
=20
 arch/mips/kvm/mips.c                                               |    3=
=20
 arch/powerpc/kvm/book3s_xive.c                                     |    4=
=20
 arch/powerpc/kvm/powerpc.c                                         |    3=
=20
 arch/powerpc/perf/core-book3s.c                                    |    6=
=20
 arch/powerpc/perf/power8-pmu.c                                     |    3=
=20
 arch/powerpc/perf/power9-pmu.c                                     |    3=
=20
 arch/s390/kvm/kvm-s390.c                                           |    1=
=20
 arch/sparc/mm/ultra.S                                              |    4=
=20
 arch/x86/kernel/vmlinux.lds.S                                      |    6=
=20
 arch/x86/kvm/x86.c                                                 |    3=
=20
 drivers/crypto/vmx/ghash.c                                         |  213 =
++++------
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h                  |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c                      |   26 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h                      |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c                     |   15=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c                      |   21=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h                      |    1=
=20
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c                        |    9=
=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                |    8=
=20
 drivers/media/usb/siano/smsusb.c                                   |   33 -
 drivers/media/usb/uvc/uvc_driver.c                                 |    2=
=20
 drivers/net/dsa/mv88e6xxx/chip.c                                   |    2=
=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |    2=
=20
 drivers/net/ethernet/freescale/fec_main.c                          |    2=
=20
 drivers/net/ethernet/marvell/mvneta.c                              |    4=
=20
 drivers/net/ethernet/marvell/mvpp2.c                               |   10=
=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c                  |    2=
=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                  |    3=
=20
 drivers/net/phy/marvell10g.c                                       |   14=
=20
 drivers/net/usb/usbnet.c                                           |    6=
=20
 drivers/s390/scsi/zfcp_ext.h                                       |    1=
=20
 drivers/s390/scsi/zfcp_scsi.c                                      |    9=
=20
 drivers/s390/scsi/zfcp_sysfs.c                                     |   55 =
++
 drivers/s390/scsi/zfcp_unit.c                                      |    8=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9=
=20
 drivers/staging/wlan-ng/hfa384x_usb.c                              |    3=
=20
 drivers/tty/serial/max310x.c                                       |    2=
=20
 drivers/tty/serial/msm_serial.c                                    |    5=
=20
 drivers/tty/serial/sh-sci.c                                        |    7=
=20
 drivers/usb/core/config.c                                          |    4=
=20
 drivers/usb/core/quirks.c                                          |    3=
=20
 drivers/usb/host/xhci-ring.c                                       |   17=
=20
 drivers/usb/host/xhci.c                                            |   24 -
 drivers/usb/misc/rio500.c                                          |   41 +
 drivers/usb/misc/sisusbvga/sisusb.c                                |   15=
=20
 drivers/usb/usbip/stub_dev.c                                       |   75 =
++-
 drivers/xen/xen-pciback/pciback_ops.c                              |    2=
=20
 fs/btrfs/inode.c                                                   |   14=
=20
 fs/btrfs/send.c                                                    |    6=
=20
 fs/btrfs/tree-log.c                                                |   20=
=20
 fs/cifs/file.c                                                     |    4=
=20
 fs/lockd/xdr.c                                                     |    4=
=20
 fs/lockd/xdr4.c                                                    |    4=
=20
 include/linux/bitops.h                                             |   16=
=20
 include/linux/compiler-gcc.h                                       |    4=
=20
 include/linux/compiler_types.h                                     |    4=
=20
 include/linux/list_lru.h                                           |    1=
=20
 include/linux/module.h                                             |    4=
=20
 include/linux/siphash.h                                            |    5=
=20
 include/net/netns/ipv4.h                                           |    2=
=20
 include/uapi/linux/tipc_config.h                                   |   10=
=20
 kernel/signal.c                                                    |    2=
=20
 mm/list_lru.c                                                      |    8=
=20
 net/core/dev.c                                                     |    2=
=20
 net/ipv4/igmp.c                                                    |   47 =
+-
 net/ipv4/route.c                                                   |   12=
=20
 net/ipv6/output_core.c                                             |   30 -
 net/ipv6/raw.c                                                     |    2=
=20
 net/llc/llc_output.c                                               |    2=
=20
 net/tipc/core.c                                                    |   32 -
 net/tipc/subscr.c                                                  |   14=
=20
 net/tipc/subscr.h                                                  |    5=
=20
 scripts/gcc-plugins/gcc-common.h                                   |    4=
=20
 security/integrity/ima/ima_policy.c                                |   21=
=20
 sound/pci/hda/patch_realtek.c                                      |    2=
=20
 virt/kvm/arm/arm.c                                                 |    3=
=20
 virt/kvm/kvm_main.c                                                |    2=
=20
 82 files changed, 727 insertions(+), 368 deletions(-)

Alan Stern (3):
      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
      media: usb: siano: Fix general protection fault in smsusb
      media: usb: siano: Fix false-positive "uninitialized variable" warning

Andrey Smirnov (1):
      xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Andy Duan (1):
      net: fec: fix the clk mismatch in failed_reset path

Antoine Tenart (1):
      net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Benjamin Coddington (1):
      Revert "lockd: Show pid of lockd for remote locks"

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL

Chris Packham (1):
      tipc: Avoid copying bytes beyond the supplied data

C=E9dric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough inter=
rupts

Dan Carpenter (1):
      staging: vc04_services: prevent integer overflow in create_pagelist()

Daniel Axtens (1):
      crypto: vmx - ghash: do nosimd fallback manually

David S. Miller (1):
      Revert "tipc: fix modprobe tipc failed after switch order of device r=
egistration"

Eric Dumazet (5):
      inet: switch IP ID generator to siphash
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST

Fabio Estevam (1):
      xhci: Use %zu for printing size_t type

Filipe Manana (4):
      Btrfs: fix wrong ctime and mtime of a directory after log replay
      Btrfs: fix race updating log root item during fsync
      Btrfs: fix fsync not persisting changed attributes of a directory
      Btrfs: incremental send, fix file corruption when no-holes feature is=
 enabled

George G. Davis (1):
      serial: sh-sci: disable DMA for uart_console

Greg Kroah-Hartman (2):
      Revert "x86/build: Move _etext to actual end of .text"
      Linux 4.14.124

Henry Lin (1):
      xhci: update bounce buffer with correct sg num

James Clarke (1):
      sparc64: Fix regression in non-hypervisor TLB flush xcall

Jiri Slaby (1):
      memcg: make it work on sparse non-0-node systems

Jisheng Zhang (2):
      net: stmmac: fix reset gpio free missing
      net: mvneta: Fix err code path of probe

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup

Jonathan Corbet (3):
      docs: Fix conf.py for Sphinx 2.0
      doc: Cope with the deprecation of AutoReporter
      doc: Cope with Sphinx logging deprecations

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: Fix XON/XOFF

Junwei Hu (1):
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Kailang Yang (1):
      ALSA: hda/realtek - Set default power save node to 0

Kees Cook (1):
      gcc-plugins: Fix build failures under Darwin host

Kloetzke Jan (1):
      usbnet: fix kernel crash after disconnect

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Lyude Paul (1):
      drm/nouveau/i2c: Disable i2c bus access after ->fini()

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter

Michael Chan (1):
      bnxt_en: Fix aggregation buffer leak under OOM condition.

Miguel Ojeda (2):
      Compiler Attributes: add support for __copy (gcc >=3D 9)
      include/linux/module.h: copy __init/__exit attrs to init/cleanup_modu=
le

Mike Manning (1):
      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Nadav Amit (1):
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Oliver Neukum (3):
      USB: sisusbvga: fix oops in error path of sisusb_probe
      USB: rio500: refuse more than one device at a time
      USB: rio500: fix memory leak in close after disconnect

Parav Pandit (1):
      net/mlx5: Allocate root ns memory using kzalloc to match kfree

Rasmus Villemoes (2):
      net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT
      include/linux/bitops.h: sanitize rotate primitives

Ravi Bangoria (1):
      powerpc/perf: Fix MMCRA corruption by bhrb_filter

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page arra=
y on ENOMEM

Roberto Sassu (1):
      ima: show rules with IMA_INMASK correctly

Russell King (1):
      net: phy: marvell10g: report if the PHY fails to boot firmware

Shuah Khan (2):
      usbip: usbip_host: fix BUG: sleeping function called from invalid con=
text
      usbip: usbip_host: fix stub_dev lock context imbalance regression

Steffen Maier (2):
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_r=
emove
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only=
 sdevs)

Thomas Hellstrom (1):
      drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Thomas Huth (1):
      KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID

Tim Collier (1):
      staging: wlan-ng: fix adapter initialization failure

Todd Kjos (2):
      Revert "binder: fix handling of misaligned binder object"
      binder: fix race between munmap() and direct reclaim

Vicente Bergas (1):
      drm/rockchip: shutdown drm subsystem on shutdown

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz8t9AACgkQONu9yGCS
aT6qsw/8CFlZ8JOMbuYpFXWfNTPAEFzackHwlcbHccB2JWp0Z5+BHWUWCB2QGXqg
I3QlnUOD98tk8xvQM9Ts2UbaRKGLfKTKnKgn2FIM3jFmnKXqvcP8kZuqXtuEeXF8
mOkaE8Qp9bOwO1Xk1ryHKu33hX+vHGkDfkWrbgoC0kt3wt1Ok+mSHWetWg3fLv3Y
R+wJDy8JeVRBcxpjPcVpizgcglbpSQK1eJL+cpCkoOWgHE6DT4d/5zxAT+vEvVLj
3AQwRjs3m8VD6KG302qSg7gRp7LjC57tjUKzHS6y+/ibcYPjJ2lYIQGChT10aUqI
Z/4OuITSzlcnufptIQl1KLy6XOCaYgbY8+TeyWeRY384/lwuoovJuLJiFJis+CMd
gsCX2gYuIuizeHqrhJ+tUsJhkjZnqVp46Bet+GVXtbH/hb99+vAuWj2s/9ddHxqI
rcgcMqNXh/c9kPJR+kG4h03Qas7VLfFHGrVbx5YmGAQToUUmNMqTGu9qjs3G21Ud
Ivd+LhVs5AZufrzl6W8t59DE4XvCD+KQ2qLwLRr6X8LdI5nOH3SQrNrQm3Zb05kR
MQmyjGTjScRsWDn0uRl3uwRsp/A34pRc9rbAfIAdvWxzGeCU1Uvd+nJfyyaQlSNF
VPTTEvzwnT7SUQvxjA2xIKfpdsQx4jnPbEjJ9oCMmxrJWZyEAL0=
=9ApC
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
