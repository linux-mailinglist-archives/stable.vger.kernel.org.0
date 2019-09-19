Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19CCB758E
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbfISI6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388321AbfISI6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 04:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785FF21907;
        Thu, 19 Sep 2019 08:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568883520;
        bh=lAi4bPEos7d0npdc46Ye3XjpCmO8sBcFtjL5Rwu92To=;
        h=Date:From:To:Cc:Subject:From;
        b=pDUQFAOpOHfJdNQNILzPqk8uXlo4KF2Ph5DhfuEv7IVqhITCSVbW/uSzzn+wqFxkB
         qNuoA/69a8BLNp7BwPLho6Qkt5UbKVXxzudB2Mu+QRMrloalzKfP0zlVfJG2y6Moc3
         Gp1RdTmRCLwXfYVIWDNijNxK0FvQwVBqjJPKu+2U=
Date:   Thu, 19 Sep 2019 10:58:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.74
Message-ID: <20190919085837.GA2612830@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.74 kernel.

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

 Makefile                                       |    2=20
 arch/powerpc/include/asm/uaccess.h             |    1=20
 arch/s390/kvm/interrupt.c                      |   10 +++
 arch/s390/kvm/kvm-s390.c                       |    4 +
 arch/x86/Makefile                              |    1=20
 arch/x86/kvm/vmx.c                             |    7 +-
 arch/x86/kvm/x86.c                             |    7 ++
 arch/x86/purgatory/Makefile                    |   35 +++++++------
 drivers/base/core.c                            |   53 +++++++++++++++++++
 drivers/bluetooth/btusb.c                      |    5 -
 drivers/clk/rockchip/clk-mmc-phase.c           |    4 -
 drivers/crypto/talitos.c                       |   67 ++++++++++++++++++--=
-----
 drivers/firmware/ti_sci.c                      |    8 +-
 drivers/gpio/gpiolib-acpi.c                    |   42 ++++++++++++++-
 drivers/gpio/gpiolib.c                         |   16 ++++-
 drivers/gpu/drm/drm_panel_orientation_quirks.c |   12 ++++
 drivers/gpu/drm/mediatek/mtk_drm_drv.c         |    5 +
 drivers/gpu/drm/meson/meson_plane.c            |   16 +++++
 drivers/iio/adc/stm32-dfsdm-adc.c              |    4 -
 drivers/isdn/capi/capi.c                       |   10 +++
 drivers/mtd/nand/raw/mtk_nand.c                |   21 +++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |    8 ++
 drivers/net/phy/phylink.c                      |    6 +-
 drivers/net/tun.c                              |   16 ++++-
 drivers/net/usb/cdc_ether.c                    |   13 +++-
 drivers/net/wireless/rsi/rsi_91x_usb.c         |    1=20
 drivers/nvmem/core.c                           |   15 ++++-
 drivers/pci/pci-driver.c                       |    3 -
 drivers/platform/x86/pmc_atom.c                |    8 ++
 fs/btrfs/tree-log.c                            |    8 +-
 fs/ubifs/tnc.c                                 |   16 ++++-
 include/uapi/linux/isdn/capicmd.h              |    1=20
 kernel/irq/resend.c                            |    2=20
 kernel/module.c                                |   24 ++++++--
 net/bridge/br_mdb.c                            |    2=20
 net/core/dev.c                                 |    2=20
 net/core/skbuff.c                              |   19 +++++++
 net/ipv4/tcp_input.c                           |    2=20
 net/ipv6/ping.c                                |    2=20
 net/sched/sch_generic.c                        |    9 ++-
 net/sched/sch_hhf.c                            |    2=20
 net/sctp/protocol.c                            |    2=20
 net/sctp/sm_sideeffect.c                       |    2=20
 net/tipc/name_distr.c                          |    3 -
 44 files changed, 378 insertions(+), 118 deletions(-)

Alex Williamson (1):
      PCI: Always allow probing with driver_override

Alexander Duyck (1):
      ixgbe: Prevent u8 wrapping of ITR value to something less than 10us

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

Douglas Anderson (1):
      clk: rockchip: Don't yell about bad mmc phases when getting

Eric Biggers (1):
      isdn/capi: check message length in capi_write()

Eric Dumazet (1):
      net: sched: fix reordering issues

Filipe Manana (1):
      Btrfs: fix assertion failure during fsync and use of stale transaction

Fuqian Huang (1):
      KVM: x86: work around leak of uninitialized stack contents

Greg Kroah-Hartman (1):
      Linux 4.19.74

Hans de Goede (2):
      gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and bl=
acklist
      drm: panel-orientation-quirks: Add extra quirk table entry for GPD Mi=
croPC

Hui Peng (1):
      rsi: fix a double free bug in rsi_91x_deinit()

Igor Mammedov (1):
      KVM: s390: kvm_s390_vm_start_migration: check dirty_bitmap before usi=
ng it as target for memset()

Jean Delvare (1):
      nvmem: Use the same permissions for eeprom as for nvmem

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

Olivier Moysan (1):
      iio: adc: stm32-dfsdm: fix data type

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread

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

Steffen Klassert (1):
      ixgbe: Fix secpath usage for IPsec TX offload.

Steve Wahl (1):
      x86/purgatory: Change compiler flags from -mcmodel=3Dkernel to -mcmod=
el=3Dlarge to fix kexec relocation errors

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

Yang Yingliang (3):
      tun: fix use-after-free when register netdev failed
      modules: fix BUG when load module with rodata=3Dn
      modules: fix compile error if don't have strict module rwx

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2DQz0ACgkQONu9yGCS
aT57Bg/9GeRpWusFBCcP+vBDbBHjkoPJOkAaS8Hi65Oqs3niv04Fe3CgB5g6k+pH
RW36u7/WuH0FgQqAKb6Pj7hSi7uyNyKpLiKg3DtBsl7qdbTXH9Zqqnyxb3lvDOt+
1rIJZ+K1S/WdpSoWnmb7bzLZwQh8E1mp2sUmmgWzKMO5Eb8eBDaGMxmegftPYIgr
gglsH1opaT0kfqG/3MjUXwDpE0e1oLyhzodFEtJBJ25j/MDs3GFq/mj1UzhlXxFo
CpQ20ZPRKlEzfaz1O8bcar+eTPY4ZmUHv5Vs+QRQ9h2lC774yJxy+S+cJh6T0Ow5
IBLyswrEXw8/0I7PNDWeOvIAUlufZm29tYaIJNNcWhvbiNG0c1f7p34p0FkXsjL3
mKiCCS0zxSBoqcyJqfS9yDyRB5w1xs7aaIB6WdupwtVLspCYdyyouxp4iVlcwf0l
4tB3citVnKP859Wa1hntfDu9gQVPMS3nadsMqpxaiAFGiUXNsphNXUWIivomUQRY
o6h7LeTXh9AFla5/cuayL5mRwGd5orqITrCzmAuxVWkd/4x40BDQ1GiESEvf1YE7
7qDO9roBbuTWHPULvz0o2J76sEE8pSAvBSgUAM8YAtExU6C3SXno0vSxzrG5iefy
GWUGg4maRzFfdQElZGVpbrpymbpF0VeVs8ITQEEv6uQxsZJGUKc=
=3gNZ
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
