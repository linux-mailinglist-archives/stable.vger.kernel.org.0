Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478CFB7588
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfISI6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfISI6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 04:58:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD5721907;
        Thu, 19 Sep 2019 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568883496;
        bh=iVEj9EnXaU+WqmlUoLEpRYE1JvDrZGXFiflC2Of+4E4=;
        h=Date:From:To:Cc:Subject:From;
        b=VEWCLX/f6ArHjquyp4WehSNjqxuo9dhYbxG8DjZt/8eu7nezXY1YPu6ZMDXJj9gKN
         uFeVPZ9WcO5MQE8fdPxbRSml19wrNM0He1XBTohE/cf8xWHmrZNtB3beoexFAkBHQr
         TYrDZQDnLnRKI+a75e2WyUPLkHqdzMmuLd3+yLt4=
Date:   Thu, 19 Sep 2019 10:58:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.145
Message-ID: <20190919085813.GA2612736@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.145 kernel.

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

 Makefile                               |    2=20
 arch/mips/Kconfig                      |    3 -
 arch/mips/include/asm/smp.h            |   12 +++++
 arch/mips/sibyte/common/Makefile       |    1=20
 arch/mips/sibyte/common/dma.c          |   14 ------
 arch/mips/vdso/Makefile                |    4 +
 arch/powerpc/include/asm/uaccess.h     |    1=20
 arch/s390/kvm/interrupt.c              |   10 ++++
 arch/s390/kvm/kvm-s390.c               |    2=20
 arch/x86/Makefile                      |    1=20
 arch/x86/kvm/vmx.c                     |    7 ++-
 arch/x86/kvm/x86.c                     |    7 +++
 drivers/base/core.c                    |   53 +++++++++++++++++++++++++-
 drivers/bluetooth/btusb.c              |    5 --
 drivers/clk/rockchip/clk-mmc-phase.c   |    4 -
 drivers/crypto/talitos.c               |   67 ++++++++++++++++++++++++----=
-----
 drivers/firmware/ti_sci.c              |    8 +--
 drivers/gpio/gpiolib-acpi.c            |   42 ++++++++++++++++++--
 drivers/gpio/gpiolib.c                 |   20 ++++++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    5 +-
 drivers/gpu/drm/meson/meson_plane.c    |   16 +++++++
 drivers/isdn/capi/capi.c               |   10 ++++
 drivers/mtd/nand/mtk_nand.c            |   21 ++++------
 drivers/net/phy/phylink.c              |    6 +-
 drivers/net/tun.c                      |   16 +++++--
 drivers/net/usb/cdc_ether.c            |   13 ++++--
 drivers/nvmem/core.c                   |   15 +++++--
 drivers/pci/pci-driver.c               |    3 -
 drivers/platform/x86/pmc_atom.c        |    8 +++
 fs/btrfs/compression.c                 |   31 +++++++++++++++
 fs/btrfs/compression.h                 |    3 +
 fs/btrfs/props.c                       |    6 --
 fs/btrfs/tree-log.c                    |    8 +--
 fs/ubifs/tnc.c                         |   16 +++++--
 include/uapi/linux/isdn/capicmd.h      |    1=20
 kernel/irq/resend.c                    |    2=20
 net/bridge/br_mdb.c                    |    2=20
 net/core/dev.c                         |    2=20
 net/core/skbuff.c                      |   19 +++++++++
 net/ipv4/tcp_input.c                   |    2=20
 net/ipv6/ping.c                        |    2=20
 net/sched/sch_hhf.c                    |    2=20
 net/sctp/protocol.c                    |    2=20
 net/sctp/sm_sideeffect.c               |    2=20
 net/tipc/name_distr.c                  |    3 -
 45 files changed, 365 insertions(+), 114 deletions(-)

Alex Williamson (1):
      PCI: Always allow probing with driver_override

Andrew F. Davis (1):
      firmware: ti_sci: Always request response from firmware

Bj=F8rn Mork (1):
      cdc_ether: fix rndis support for Mediatek based smartphones

Christophe JAILLET (2):
      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'

Christophe Leroy (6):
      crypto: talitos - check AES key size
      crypto: talitos - fix CTR alg blocksize
      crypto: talitos - check data blocksize in ablkcipher.
      crypto: talitos - fix ECB algs ivsize
      crypto: talitos - Do not modify req->cryptlen on decryption.
      crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.

Cong Wang (1):
      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero

David Sterba (1):
      btrfs: compression: add helper for type to string conversion

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
      Linux 4.14.145

Hans de Goede (1):
      gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and bl=
acklist

Jean Delvare (1):
      nvmem: Use the same permissions for eeprom as for nvmem

Johannes Thumshirn (1):
      btrfs: correctly validate compression type

Kent Gibson (2):
      gpio: fix line flag validation in linehandle_create
      gpio: fix line flag validation in lineevent_create

Linus Torvalds (1):
      x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to si=
lence GCC9 build warning

Mario Limonciello (1):
      Revert "Bluetooth: btusb: driver to enable the usb-wakeup feature"

Muchun Song (1):
      driver core: Fix use-after-free and double free on glue directory

Neal Cardwell (1):
      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Neil Armstrong (1):
      drm/meson: Add support for XBGR8888 & ABGR8888 formats

Nicolas Dichtel (1):
      bridge/mdb: remove wrong use of NLM_F_MULTI

Nishka Dasgupta (1):
      drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread

Paul Burton (2):
      MIPS: VDSO: Prevent use of smp_processor_id()
      MIPS: VDSO: Use same -m%-float cflag as the kernel proper

Richard Weinberger (1):
      ubifs: Correctly use tnc_next() in search_dh_cookie()

Shmulik Ladkani (1):
      net: gso: Fix skb_segment splat when splitting gso_size mangled skb h=
aving linear-headed frag_list

Stefan Chulski (1):
      net: phylink: Fix flow control resolution

Steffen Dirkwinkel (1):
      platform/x86: pmc_atom: Add CB4063 Beckhoff Automation board to critc=
lk_systems DMI table

Subash Abhinov Kasiviswanathan (1):
      net: Fix null de-reference of device refcount

Suraj Jitindar Singh (1):
      powerpc: Add barrier_nospec to raw_copy_in_user()

Thomas Huth (1):
      KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT io=
ctl

Xiaolei Li (1):
      mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue

Xin Long (2):
      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
      tipc: add NULL pointer check before calling kfree_rcu

Yang Yingliang (1):
      tun: fix use-after-free when register netdev failed

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2DQyIACgkQONu9yGCS
aT6EwBAAv6vOevDDyaPTv1wXrNciB791Al6O6QjwfMCk0HcZs9cTrBc7DEkCfGjH
7E4TxCbUezeRDSbvNRiraNDa207j+iVDhxchv5ik+85rXO+bjPCT+BTiEaPQY60R
3+SyDJA+6N+gKul+AOS/WN5jLEKosO+EHYm+pV6nycWNcV4C0Fs8NITyUrEAdaA6
SsYA+keGB1T+eHEPhquQOjR0nGXGW+i8eWw2ZLVXHHitfeNHLZB/QS+LVeqq9JXT
RI7JxilziZvA/6U6xpTBZqZReXZjB4c9qMR8K5yEiR8qp20TjnS0MD0GT7R/uhgz
ZEjYAheJDEvDAx7RUdC8wnPVf4ZzCJ0mkBf/+9ANW8S9rCkwVlAwmGOClbONUEwN
kh+BNfWYcPXBF81r5zBPCZx+tA8Y52L6f1DEhWSVCfOFv8ZRzNFeczVd48NwNpYD
Itxf1EeU1e2C71F7HkNiSD0yqYT8SkNuSM7wphSSoh2bemSpCekb0A+i8M8FsjNJ
tN1ZgwUaDvJE6Xj3/fU8DSXeyZFmgx7UHdyuB2dk836dwRWY7yzzqYiL/E6yWC6T
uBu/acLKVx4Gh3RN9M1xiBvOwge5Epn5vYcyLAENxm8gVY4SE37r1Wo0hdRrvsoH
VaiLycxQWq17mzjB6L4eIGiblaaBZ1xJIo5yOnKQG6sFHiLVYpc=
=gcG+
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
