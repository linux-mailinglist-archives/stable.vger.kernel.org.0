Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A08213CD13
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbfFKNfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbfFKNfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:35:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DCB2063F;
        Tue, 11 Jun 2019 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560260133;
        bh=bQEuoD4VQU6z0kxefWDSYSxo/2Mz4kEEL8mu9ApamBM=;
        h=Date:From:To:Cc:Subject:From;
        b=JGIwP2JzO7vMo0l2g/qNTX0DzdrZCMwvXORQXcZMqwKeAcUXcvF1Syg2NAmSZ5Qjo
         0ccwpOSHog31zu9CI9imHC1jYAEWbZNsXhX1+a3KfUEHMgliYc5lj496vT0tw9zIYt
         NZBR8gZxt7dZIke2AbJzp3e9wV9M14yimwqdxG6k=
Date:   Tue, 11 Jun 2019 15:35:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.181
Message-ID: <20190611133529.GA2537@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.181 kernel.

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

 Documentation/conf.py                                              |    2=
=20
 Makefile                                                           |    2=
=20
 arch/mips/ath79/setup.c                                            |    6=
=20
 arch/mips/pistachio/Platform                                       |    1=
=20
 arch/powerpc/perf/core-book3s.c                                    |    6=
=20
 arch/powerpc/perf/power8-pmu.c                                     |    3=
=20
 arch/powerpc/perf/power9-pmu.c                                     |    3=
=20
 arch/sparc/mm/ultra.S                                              |    4=
=20
 arch/x86/kernel/vmlinux.lds.S                                      |    6=
=20
 arch/x86/power/cpu.c                                               |   10=
=20
 arch/x86/power/hibernate_64.c                                      |   33=
=20
 drivers/android/binder.c                                           |   36=
=20
 drivers/crypto/vmx/ghash.c                                         |  213 =
++---
 drivers/firmware/efi/libstub/arm-stub.c                            |   23=
=20
 drivers/firmware/efi/libstub/arm64-stub.c                          |    4=
=20
 drivers/firmware/efi/libstub/efi-stub-helper.c                     |   19=
=20
 drivers/firmware/efi/libstub/efistub.h                             |    2=
=20
 drivers/gpu/drm/gma500/cdv_intel_lvds.c                            |    3=
=20
 drivers/gpu/drm/gma500/intel_bios.c                                |    3=
=20
 drivers/gpu/drm/gma500/psb_drv.h                                   |    1=
=20
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h                  |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c                      |   26=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h                      |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c                     |   15=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c                      |   21=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h                      |    1=
=20
 drivers/gpu/drm/radeon/radeon_display.c                            |    4=
=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                |    8=
=20
 drivers/irqchip/irq-ath79-misc.c                                   |   11=
=20
 drivers/media/usb/siano/smsusb.c                                   |   33=
=20
 drivers/media/usb/uvc/uvc_driver.c                                 |    2=
=20
 drivers/misc/genwqe/card_dev.c                                     |    2=
=20
 drivers/misc/genwqe/card_utils.c                                   |    4=
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
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                    |    4=
=20
 drivers/net/ethernet/mellanox/mlx4/port.c                          |    5=
=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                  |    3=
=20
 drivers/net/usb/usbnet.c                                           |    6=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c        |   16=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |    5=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h            |   16=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c          |    2=
=20
 drivers/parisc/ccio-dma.c                                          |    4=
=20
 drivers/parisc/sba_iommu.c                                         |    3=
=20
 drivers/s390/scsi/zfcp_ext.h                                       |    1=
=20
 drivers/s390/scsi/zfcp_scsi.c                                      |    9=
=20
 drivers/s390/scsi/zfcp_sysfs.c                                     |   55 +
 drivers/s390/scsi/zfcp_unit.c                                      |    8=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9=
=20
 drivers/tty/serial/max310x.c                                       |    2=
=20
 drivers/tty/serial/msm_serial.c                                    |    5=
=20
 drivers/tty/serial/serial_core.c                                   |   24=
=20
 drivers/usb/core/config.c                                          |    4=
=20
 drivers/usb/core/quirks.c                                          |    3=
=20
 drivers/usb/host/xhci-ring.c                                       |   17=
=20
 drivers/usb/host/xhci.c                                            |   24=
=20
 drivers/usb/misc/rio500.c                                          |   41 -
 drivers/usb/misc/sisusbvga/sisusb.c                                |   15=
=20
 drivers/usb/usbip/stub_dev.c                                       |   75 =
+-
 drivers/xen/xen-pciback/pciback_ops.c                              |    2=
=20
 drivers/xen/xenbus/xenbus_dev_frontend.c                           |    2=
=20
 fs/btrfs/tree-log.c                                                |    8=
=20
 fs/cifs/file.c                                                     |    4=
=20
 fs/fuse/dev.c                                                      |   12=
=20
 fs/fuse/file.c                                                     |    6=
=20
 fs/open.c                                                          |   18=
=20
 fs/pipe.c                                                          |    4=
=20
 fs/read_write.c                                                    |    5=
=20
 fs/splice.c                                                        |   12=
=20
 include/linux/bitops.h                                             |   16=
=20
 include/linux/cpu.h                                                |    4=
=20
 include/linux/efi.h                                                |    2=
=20
 include/linux/fs.h                                                 |    4=
=20
 include/linux/list_lru.h                                           |    1=
=20
 include/linux/mm.h                                                 |    6=
=20
 include/linux/pipe_fs_i.h                                          |   10=
=20
 include/linux/rcupdate.h                                           |    6=
=20
 include/net/arp.h                                                  |    8=
=20
 include/uapi/drm/i915_drm.h                                        |    2=
=20
 include/uapi/linux/fuse.h                                          |    2=
=20
 include/uapi/linux/tipc_config.h                                   |   10=
=20
 kernel/cpu.c                                                       |    4=
=20
 kernel/power/hibernate.c                                           |    9=
=20
 kernel/signal.c                                                    |    2=
=20
 kernel/trace/trace.c                                               |    6=
=20
 mm/gup.c                                                           |   54 +
 mm/hugetlb.c                                                       |   16=
=20
 mm/list_lru.c                                                      |    8=
=20
 net/core/dev.c                                                     |    2=
=20
 net/core/ethtool.c                                                 |   17=
=20
 net/core/fib_rules.c                                               |    7=
=20
 net/core/neighbour.c                                               |    9=
=20
 net/core/pktgen.c                                                  |   11=
=20
 net/ipv4/igmp.c                                                    |   47 -
 net/ipv6/raw.c                                                     |   27=
=20
 net/llc/llc_output.c                                               |    2=
=20
 net/rds/ib_rdma.c                                                  |   10=
=20
 net/tipc/core.c                                                    |   32=
=20
 net/tipc/subscr.c                                                  |   14=
=20
 net/tipc/subscr.h                                                  |    5=
=20
 scripts/coccinelle/api/stream_open.cocci                           |  363 =
++++++++++
 scripts/gcc-plugins/gcc-common.h                                   |    4=
=20
 sound/pci/hda/patch_realtek.c                                      |    2=
=20
 107 files changed, 1240 insertions(+), 442 deletions(-)

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

Ard Biesheuvel (1):
      efi/libstub: Unify command line param parsing

Arend Van Spriel (1):
      brcmfmac: add length checks in scheduled scan result handler

Arend van Spriel (2):
      brcmfmac: assure SSID length from firmware is limited
      brcmfmac: add subtype check for event handling in data path

Ben Hutchings (1):
      binder: Replace "%p" with "%pK" for stable

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL

Chris Packham (1):
      tipc: Avoid copying bytes beyond the supplied data

Chris Wilson (1):
      drm/i915: Fix I915_EXEC_RING_MASK

Christian K=F6nig (1):
      drm/radeon: prefer lower reference dividers

Dan Carpenter (2):
      staging: vc04_services: prevent integer overflow in create_pagelist()
      genwqe: Prevent an integer overflow in the ioctl

Daniel Axtens (1):
      crypto: vmx - ghash: do nosimd fallback manually

David Ahern (2):
      neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
      ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled

David S. Miller (1):
      Revert "tipc: fix modprobe tipc failed after switch order of device r=
egistration"

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Eric Dumazet (4):
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST

Fabio Estevam (1):
      xhci: Use %zu for printing size_t type

Filipe Manana (1):
      Btrfs: fix race updating log root item during fsync

Greg Kroah-Hartman (4):
      Revert "x86/build: Move _etext to actual end of .text"
      Revert "fib_rules: fix error in backport of e9919a24d302 ("fib_rules:=
 return 0...")"
      Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"
      Linux 4.9.181

Hangbin Liu (1):
      Revert "fib_rules: return 0 directly if an exactly same rule exists w=
hen NLM_F_EXCL not supplied"

Henry Lin (1):
      xhci: update bounce buffer with correct sg num

James Clarke (1):
      sparc64: Fix regression in non-hypervisor TLB flush xcall

Jiri Kosina (1):
      x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Jiri Slaby (2):
      memcg: make it work on sparse non-0-node systems
      TTY: serial_core, add ->install

Jisheng Zhang (2):
      net: stmmac: fix reset gpio free missing
      net: mvneta: Fix err code path of probe

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coheren=
ce index of I/O pdirs

Jonathan Corbet (1):
      docs: Fix conf.py for Sphinx 2.0

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: Fix XON/XOFF

Junwei Hu (1):
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Kailang Yang (1):
      ALSA: hda/realtek - Set default power save node to 0

Kees Cook (1):
      gcc-plugins: Fix build failures under Darwin host

Kirill Smelkov (2):
      fs: stream_open - opener for stream-like files so that read and write=
 can run simultaneously without deadlock
      fuse: Add FOPEN_STREAM to use stream_open()

Kloetzke Jan (1):
      usbnet: fix kernel crash after disconnect

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Linus Torvalds (3):
      mm: prevent get_user_pages() from overflowing page refcount
      mm: make page ref count overflow check tighter and more explicit
      rcu: locking and unlocking need to always be at least barriers

Lyude Paul (1):
      drm/nouveau/i2c: Disable i2c bus access after ->fini()

Matthew Wilcox (1):
      fs: prevent page refcount overflow in pipe_buf_get

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter

Michael Chan (1):
      bnxt_en: Fix aggregation buffer leak under OOM condition.

Mike Manning (1):
      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Miklos Szeredi (1):
      fuse: fallocate: fix return with locked inode

Nadav Amit (1):
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Oliver Neukum (3):
      USB: sisusbvga: fix oops in error path of sisusb_probe
      USB: rio500: refuse more than one device at a time
      USB: rio500: fix memory leak in close after disconnect

Olivier Matz (2):
      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Paul Burton (1):
      MIPS: pistachio: Build uImage.gz by default

Punit Agrawal (1):
      mm, gup: ensure real head page is ref-counted when using hugepages

Rasmus Villemoes (2):
      net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT
      include/linux/bitops.h: sanitize rotate primitives

Ravi Bangoria (1):
      powerpc/perf: Fix MMCRA corruption by bhrb_filter

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page arra=
y on ENOMEM

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

Todd Kjos (1):
      binder: replace "%p" with "%pK"

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Will Deacon (1):
      mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

Yunsheng Lin (1):
      ethtool: check the return value of get_regs_len

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz/riEACgkQONu9yGCS
aT4s+RAAn5zcQAVr6Eu9X1GPCB0qEsW8u+dtckeei8wFezWmWGhNzcXxj/65r+rj
wwR1U+yuVqjafBTce26xmGSul5xpi49ToKkcS3RvsyXJkU/16D+RAek6w1wR3s3u
+Tb6n5mrzRcGsJm/kvmwLv9DAwG1wfCewz9JZUkNe8tZR5B08S2A/RAbNLVrM5AP
Uhzj68ljCmL3bOj/or3dCcNPEqYjyue4ZftvHePzOgq+ADSCAlPlKJNg8h0rD6Bq
T8rzwNPIU+ILnBpr3/a6gx4JKhLb0I4jXrg924TYuUO9MB3mmGo21pnl6y4ruAOn
5j9VlUDv0Z8JsUtPYH1yO4+mC8qi9+KYWaTQ+yiETIuIJxVKoAqdToaMuflTMN4E
KtP/+FpMT/0VNOMGLu4yIrTh8bDCTzmK+wlBYIm/QwSsaPturLPTph5BdPZ6NeF6
yfRECdCDEXkH/HPkf7EF5QeOuDclt0Wy66FV5VBxatOmBnb1O7zWKdbnlaZCMAse
TT54Q7hZoIFWYhDA/utqYG/mLUfRwh2LHAC3/PSLq86UD0GA3AljIJpoMb6fq5T+
ZnEoN9waDcDOwAKekR1VxinLpWmUEwHvy9MeYvpK2HYbI7CFfEAzHhsRJN/Q/exx
evLmvri1Daqe7nphw3gOGDNrU26i3qLTv4DfbI92TuyR2xkKass=
=M5Fe
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
