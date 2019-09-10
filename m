Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2770AE7CA
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 12:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405859AbfIJKSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 06:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388426AbfIJKSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 06:18:01 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AAF12081B;
        Tue, 10 Sep 2019 10:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568110678;
        bh=J1eqSSSzE+jWYKQ1i9iiJcV5V6TxLNo/c827cEgKsnk=;
        h=Date:From:To:Cc:Subject:From;
        b=r3vz8XKi1bAPAcwzVx2ZCpHCR38r15AzjgnZE5N00jJOjxeoK+AY7xGmJM/3pNDiZ
         X+8qbMKjSANaBfqezuDDOVgrbMlufWHWLb8UgX3oJLc61cdOkoM17Koj/meFivfj1h
         5IeuteksT6mU9tWyyA0DY/DDF2+D5v289SK6pRuw=
Date:   Tue, 10 Sep 2019 11:17:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.143
Message-ID: <20190910101755.GA7330@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.143 kernel.

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

 Makefile                                               |    2=20
 arch/x86/include/asm/bootparam_utils.h                 |    1=20
 arch/x86/kernel/apic/apic.c                            |    4 -
 drivers/bluetooth/btqca.c                              |    3=20
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                 |   49 ++++++++++++-
 drivers/gpu/drm/mediatek/mtk_drm_drv.h                 |    2=20
 drivers/hid/hid-cp2112.c                               |    8 +-
 drivers/infiniband/hw/mlx4/mad.c                       |    4 -
 drivers/input/serio/hyperv-keyboard.c                  |   35 +--------
 drivers/net/ethernet/cavium/liquidio/request_manager.c |    4 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c     |    4 -
 drivers/net/ethernet/ibm/ibmveth.c                     |    9 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c       |    2=20
 drivers/net/ethernet/renesas/ravb_main.c               |    8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c         |    6 -
 drivers/net/ethernet/toshiba/tc35815.c                 |    2=20
 drivers/net/ethernet/tundra/tsi108_eth.c               |    5 -
 drivers/net/hyperv/netvsc_drv.c                        |    9 +-
 drivers/net/usb/cx82310_eth.c                          |    3=20
 drivers/net/usb/kalmia.c                               |    6 -
 drivers/net/usb/lan78xx.c                              |    8 +-
 drivers/net/wimax/i2400m/fw.c                          |    4 -
 drivers/spi/spi-bcm2835aux.c                           |   62 +++++-------=
-----
 fs/ceph/caps.c                                         |    5 +
 fs/ceph/inode.c                                        |    7 +
 fs/ceph/snap.c                                         |    4 -
 fs/ceph/super.h                                        |    2=20
 fs/ceph/xattr.c                                        |   19 +++--
 fs/read_write.c                                        |   49 +++++++++++--
 include/linux/ceph/buffer.h                            |    3=20
 include/linux/gpio.h                                   |   24 ------
 include/net/act_api.h                                  |    4 -
 include/net/psample.h                                  |    1=20
 kernel/kprobes.c                                       |    8 +-
 net/core/netpoll.c                                     |    6 -
 net/ipv4/tcp.c                                         |   29 +++++--
 net/ipv4/tcp_output.c                                  |    3=20
 net/ipv6/mcast.c                                       |    5 -
 net/psample/psample.c                                  |    2=20
 net/sched/act_bpf.c                                    |    2=20
 net/sched/act_connmark.c                               |    2=20
 net/sched/act_csum.c                                   |    2=20
 net/sched/act_gact.c                                   |    2=20
 net/sched/act_ife.c                                    |    2=20
 net/sched/act_ipt.c                                    |   11 +--
 net/sched/act_mirred.c                                 |    2=20
 net/sched/act_nat.c                                    |    2=20
 net/sched/act_pedit.c                                  |    2=20
 net/sched/act_police.c                                 |    2=20
 net/sched/act_sample.c                                 |    7 +
 net/sched/act_simple.c                                 |    2=20
 net/sched/act_skbedit.c                                |    2=20
 net/sched/act_skbmod.c                                 |    2=20
 net/sched/act_tunnel_key.c                             |    2=20
 net/sched/act_vlan.c                                   |    2=20
 tools/hv/hv_kvp_daemon.c                               |    2=20
 virt/kvm/arm/mmio.c                                    |    7 +
 57 files changed, 270 insertions(+), 196 deletions(-)

Alexandre Courbot (2):
      drm/mediatek: use correct device to import PRIME buffers
      drm/mediatek: set DMA max segment size

Andrea Righi (1):
      kprobes: Fix potential deadlock in kprobe_optimizer()

Andrew Jones (1):
      KVM: arm/arm64: Only skip MMIO insn once

Benjamin Tissoires (1):
      HID: cp2112: prevent sleeping function called from invalid context

Chen-Yu Tsai (1):
      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Cong Wang (1):
      net_sched: fix a NULL pointer deref in ipt action

Darrick J. Wong (1):
      vfs: fix page locking deadlocks when deduping files

Dexuan Cui (2):
      hv_netvsc: Fix a warning of suspicious RCU usage
      Input: hyperv-keyboard: Use in-place iterator API in the channel call=
back

Eric Dumazet (2):
      tcp: remove empty skb from write queue in error cases
      mld: fix memory leak in mld_del_delrec()

Feng Sun (1):
      net: fix skb use after free in netpoll

Fuqian Huang (1):
      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq i=
n IRQ context

Greg Kroah-Hartman (1):
      Linux 4.14.143

John S. Gruber (1):
      x86/boot: Preserve boot_params.secure_boot from sanitizing

Linus Torvalds (1):
      Revert "x86/apic: Include the LDR when clearing out APIC registers"

Luis Henriques (4):
      ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
      ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xattr=
s_blob()
      ceph: fix buffer free while holding i_ceph_lock in fill_inode()
      libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Martin Sperl (3):
      spi: bcm2835aux: unifying code between polling and interrupt driven c=
ode
      spi: bcm2835aux: remove dangerous uncontrolled read of fifo
      spi: bcm2835aux: fix corruptions for longer spi transfers

Matthias Kaehlcke (1):
      Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Tho Vu (1):
      ravb: Fix use-after-free ravb_tstamp_skb

Thomas Falcon (1):
      ibmveth: Convert multicast list size for little-endian system

Vitaly Kuznetsov (1):
      Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Vlad Buslov (1):
      net: sched: act_sample: fix psample group handling on overwrite

Wenwen Wang (8):
      cxgb4: fix a memory leak bug
      liquidio: add cleanup in octeon_setup_iq()
      net: myri10ge: fix memory leaks
      lan78xx: Fix memory leaks
      cx82310_eth: fix a memory leak bug
      net: kalmia: fix memory leaks
      wimax/i2400m: fix a memory leak bug
      IB/mlx4: Fix memory leaks

Willem de Bruijn (1):
      tcp: inherit timestamp on mtu probe

YueHaibing (1):
      gpio: Fix build error of function redefinition


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl13eFMACgkQONu9yGCS
aT4eChAAlHl3Pw+qiJ+pB24HqpDL+mpTxaw8CbsIv12bCjUvRm1mrBII8vq136P+
aihfxrzYOv91RNEnKLV2SqKjVMUXMinqLgmyYTTaffk9Bebv9S5CBmjO8GQuPDq/
1NcpAATQ6JwQXz0xcTGwz38EHBoEN8giXtG7a8ntnp7TNhNhqtADsrVAjKXyZcvr
DocSjHRiwXF4F6TH5CDbfOvhKh6suWPSKhCNh/qOQGXs8fSabzvZ8X92MQf2Civ4
lt0LeFFy46mWTahS6dinJfz6jTTM3PbXi340qQML+hIsPb+zk8nbQsA/yg15UNk8
nQ7DHlffECYdtwZVypCQQfwDIB8szij9wOi9dhTaoNq+/X90rgodMj46w71Ekh8C
IEUqPcDgzrEKqb/cos5af7Na85Pi2UMM5WJj91RYPnaheEXwdVu5WDBn0WbaDrxV
jrR8l3ZLjyCrZypC2aFu3hXwZZIOG2eHkQvaXgt7NZ3eIsRd4svOPJbhRVqKM1rT
HveqKBpU68wTD9cJYf2CnhJXWwaiEgMaXdFdmF6yptZ3z2GD0a026kO6OIBfULNd
i8fx/++1yy1INix6k8ejX8QamWBgdCAE8VNPbZjNQis1rnoVxx4DfkUt5uOl2bXK
NkV/DMWwQPOl+8FD3Bve3vv10qcyAxe/krfseDnMSjahxvt74uA=
=12ln
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
