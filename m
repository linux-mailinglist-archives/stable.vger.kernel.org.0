Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12047AE7CE
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 12:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388998AbfIJKSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 06:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbfIJKSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 06:18:24 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3BAB2081B;
        Tue, 10 Sep 2019 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568110702;
        bh=TyQSe5pbU0SrwnM/7kmvlw70voy8toNjzr/nb5tlfq0=;
        h=Date:From:To:Cc:Subject:From;
        b=rw5/3KmEC1IA932Pd1dfWRkmal0OoKN/pfV9VD7txPhTiZ3Ip6yPBB3Fz4PN3ia95
         afEdgmjRIXkOmMTpuAfEW1SmG1megPQAYmAr6mE9flGbt8a54u/TH5uH/mpD0A6vsT
         5b/UrDPIG8zWBUcDHs+QIiIaMb0kGG+PL79czwk0=
Date:   Tue, 10 Sep 2019 11:18:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.72
Message-ID: <20190910101819.GA7421@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.72 kernel.

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

 Makefile                                               |    2=20
 arch/x86/boot/compressed/pgtable_64.c                  |   13 ++-
 arch/x86/include/asm/bootparam_utils.h                 |    1=20
 arch/x86/kernel/apic/apic.c                            |    4 -
 drivers/bluetooth/btqca.c                              |    3=20
 drivers/gpu/drm/mediatek/mtk_drm_drv.c                 |   49 ++++++++++++-
 drivers/gpu/drm/mediatek/mtk_drm_drv.h                 |    2=20
 drivers/hid/hid-cp2112.c                               |    8 +-
 drivers/infiniband/hw/hfi1/fault.c                     |   12 ++-
 drivers/infiniband/hw/mlx4/mad.c                       |    4 -
 drivers/input/serio/hyperv-keyboard.c                  |   35 +--------
 drivers/net/ethernet/cavium/common/cavium_ptp.c        |    2=20
 drivers/net/ethernet/cavium/liquidio/request_manager.c |    4 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c     |    4 -
 drivers/net/ethernet/ibm/ibmveth.c                     |    9 +-
 drivers/net/ethernet/ibm/ibmvnic.c                     |   11 ---
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
 drivers/nvme/host/multipath.c                          |    1=20
 drivers/scsi/qla2xxx/qla_attr.c                        |    2=20
 drivers/scsi/qla2xxx/qla_os.c                          |   11 ++-
 drivers/spi/spi-bcm2835aux.c                           |   62 +++++-------=
-----
 drivers/target/target_core_user.c                      |    9 +-
 fs/afs/cell.c                                          |    4 +
 fs/ceph/caps.c                                         |    5 +
 fs/ceph/inode.c                                        |    7 +
 fs/ceph/snap.c                                         |    4 -
 fs/ceph/super.h                                        |    2=20
 fs/ceph/xattr.c                                        |   19 +++--
 fs/read_write.c                                        |   49 +++++++++++--
 include/linux/ceph/buffer.h                            |    3=20
 include/linux/gpio.h                                   |   24 ------
 include/net/act_api.h                                  |    4 -
 include/net/netfilter/nf_tables.h                      |    9 +-
 include/net/psample.h                                  |    1=20
 kernel/kprobes.c                                       |    8 +-
 net/core/netpoll.c                                     |    6 -
 net/ipv4/tcp.c                                         |   29 +++++--
 net/ipv4/tcp_output.c                                  |    3=20
 net/ipv6/mcast.c                                       |    5 -
 net/netfilter/nf_tables_api.c                          |   15 ++--
 net/netfilter/nft_flow_offload.c                       |    9 +-
 net/psample/psample.c                                  |    2=20
 net/rds/recv.c                                         |    5 +
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
 tools/bpf/bpftool/common.c                             |    2=20
 tools/hv/hv_kvp_daemon.c                               |    2=20
 tools/testing/selftests/kvm/lib/x86.c                  |   16 ++--
 tools/testing/selftests/kvm/platform_info_test.c       |    2=20
 virt/kvm/arm/mmio.c                                    |    7 +
 virt/kvm/arm/vgic/vgic-init.c                          |   30 +++++---
 74 files changed, 374 insertions(+), 245 deletions(-)

Alexandre Courbot (2):
      drm/mediatek: use correct device to import PRIME buffers
      drm/mediatek: set DMA max segment size

Andre Przywara (1):
      KVM: arm/arm64: VGIC: Properly initialise private IRQ affinity

Andrea Righi (1):
      kprobes: Fix potential deadlock in kprobe_optimizer()

Andrew Jones (1):
      KVM: arm/arm64: Only skip MMIO insn once

Anton Eidelman (1):
      nvme-multipath: fix possible I/O hang when paths are updated

Benjamin Tissoires (1):
      HID: cp2112: prevent sleeping function called from invalid context

Bill Kuzeja (1):
      scsi: qla2xxx: Fix gnl.l memory leak on adapter init failure

Chen-Yu Tsai (1):
      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Cong Wang (1):
      net_sched: fix a NULL pointer deref in ipt action

Darrick J. Wong (1):
      vfs: fix page locking deadlocks when deduping files

David Howells (1):
      afs: Fix leak in afs_lookup_cell_rcu()

Dexuan Cui (2):
      hv_netvsc: Fix a warning of suspicious RCU usage
      Input: hyperv-keyboard: Use in-place iterator API in the channel call=
back

Dmitry Fomichev (1):
      scsi: target: tcmu: avoid use-after-free after command timeout

Eric Dumazet (2):
      mld: fix memory leak in mld_del_delrec()
      tcp: remove empty skb from write queue in error cases

Feng Sun (1):
      net: fix skb use after free in netpoll

Fuqian Huang (1):
      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq i=
n IRQ context

Greg Kroah-Hartman (1):
      Linux 4.19.72

Jakub Kicinski (1):
      tools: bpftool: fix error message (prog -> object)

John S. Gruber (1):
      x86/boot: Preserve boot_params.secure_boot from sanitizing

Ka-Cheong Poon (1):
      net/rds: Fix info leak in rds6_inc_info_copy()

Kirill A. Shutemov (2):
      x86/boot/compressed/64: Fix boot on machines with broken E820 table
      x86/boot/compressed/64: Fix missing initialization in find_trampoline=
_placement()

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

Pablo Neira Ayuso (2):
      netfilter: nf_tables: use-after-free in failing rule with bound set
      netfilter: nft_flow_offload: skip tcp rst and fin packets

Paolo Bonzini (1):
      selftests: kvm: fix state save/load on processors without XSAVE

Stephen Hemminger (1):
      net: cavium: fix driver name

Tho Vu (1):
      ravb: Fix use-after-free ravb_tstamp_skb

Thomas Falcon (2):
      ibmveth: Convert multicast list size for little-endian system
      ibmvnic: Unmap DMA address of TX descriptor buffers after use

Vitaly Kuznetsov (2):
      Tools: hv: kvp: eliminate 'may be used uninitialized' warning
      selftests/kvm: make platform_info_test pass on AMD

Vlad Buslov (1):
      net: sched: act_sample: fix psample group handling on overwrite

Wenwen Wang (10):
      cxgb4: fix a memory leak bug
      liquidio: add cleanup in octeon_setup_iq()
      net: myri10ge: fix memory leaks
      lan78xx: Fix memory leaks
      cx82310_eth: fix a memory leak bug
      net: kalmia: fix memory leaks
      wimax/i2400m: fix a memory leak bug
      IB/mlx4: Fix memory leaks
      infiniband: hfi1: fix a memory leak bug
      infiniband: hfi1: fix memory leaks

Willem de Bruijn (1):
      tcp: inherit timestamp on mtu probe

YueHaibing (1):
      gpio: Fix build error of function redefinition


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl13eGsACgkQONu9yGCS
aT61Tw//Spm8pZCHOkvJw7P9ImjeapQUkC7WsWMAfxnKSc/LerQdltmUaUHq77L6
6sBQ1rh7O6uTE77r5BWGCzuv850+uZr7iAsyE0oOErC5QZOEvPSC6u5MJpQ6+Tt0
5UC/S3vYSEc+VE2LMpHMJ8YCq1ergL0+/hkH37UpbyYn642RAXNizOq9geK5Wd4v
dOK0+X0+nQcPXuwsrIr1RncJZVZ5ZRo+49YYRfy+MSqcUB/CLc5trkwuSRs6y3tZ
FvZNBVBy94MFIyu+uZl8Yvkk8u+Cv5hdMjacvVUOtV/5Uqvb72vGCxPvBByuOIJh
N0IfSL3FuDibdUpF1jhEONYZVCiraPt1qm7q9KaAG7SVF89o6rTfbOKZZdlmEMpB
mQbJAXHOG3AtiPlcDh2pfsZNeM98FKnpGFo1Mc+zO+CcGR9ln/ufQiovo0q1lKHg
jVxge6XR6x6RqVGxutTE54kBeH26Gt/e4wlo2NbIfKpVLpT+NpYjBghjmI5Z2GQt
x4SpcXwpFizDpMUtGNqN5ghEz7H15iUBy1HE+Jgj+p5Kf1PnYyLwpK/YBI0WzMl+
2be0l85q+j/vMcaDLJvIqWb9KaWTt65x+ayvkkd5VhZPrSLQcLu+FZ4WsLC8QB3R
iDSjMI1u2GqF/dXBV+D2qXKYrl1kDW3FN4BNQv9rfeKwEQpW34U=
=vU/C
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
