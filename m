Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2532B2149B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfEQHhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbfEQHhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:37:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E14206A3;
        Fri, 17 May 2019 07:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078629;
        bh=Km+OeZmRxVBCLZpy7CX/JEHFrTdm4yRqrhyQgyrdlL4=;
        h=Date:From:To:Cc:Subject:From;
        b=xeBvnna7XdOBE8T/LBHWtm3/H0qs5fYEHbB1k5S+lEBUlpPFzwlL2dMlErh3Knc9+
         cODernjXIZYOzehhs5wsu64Pa0OZyGDK53Bey8bBS70iqubxPdK7LYcO7bV6AQaf/l
         y7qHBHKjLIh4XTxKyeoUSxiTyRWN74vdU4LRYbd0=
Date:   Fri, 17 May 2019 09:37:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.3
Message-ID: <20190517073706.GA11119@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.3 kernel.

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

 Makefile                                            |    2=20
 arch/powerpc/include/asm/book3s/64/pgalloc.h        |    3=20
 arch/powerpc/include/asm/reg_booke.h                |    2=20
 arch/powerpc/kernel/idle_book3s.S                   |   20 +++++
 drivers/hwmon/occ/sysfs.c                           |    8 +-
 drivers/hwmon/pwm-fan.c                             |    2=20
 drivers/i2c/i2c-core-base.c                         |    5 +
 drivers/isdn/gigaset/bas-gigaset.c                  |    9 +-
 drivers/md/raid5.c                                  |   19 +----
 drivers/net/bonding/bond_options.c                  |    7 -
 drivers/net/ethernet/cadence/macb_main.c            |    6 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c      |    2=20
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c   |    8 --
 drivers/net/ethernet/seeq/sgiseeq.c                 |    1=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c   |    2=20
 drivers/net/phy/phy_device.c                        |   11 +--
 drivers/net/tun.c                                   |   14 +++
 drivers/net/wireless/marvell/mwl8k.c                |   13 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c |    1=20
 drivers/pci/controller/pci-hyperv.c                 |   23 ++++++
 drivers/platform/x86/dell-laptop.c                  |    6 -
 drivers/platform/x86/sony-laptop.c                  |    8 +-
 drivers/platform/x86/thinkpad_acpi.c                |   72 +++++++++++++++=
++++-
 drivers/usb/serial/generic.c                        |   39 ++++++++--
 drivers/virt/fsl_hypervisor.c                       |   29 ++++----
 drivers/virt/vboxguest/vboxguest_core.c             |   31 ++++++++
 drivers/virtio/virtio_ring.c                        |    1=20
 fs/f2fs/data.c                                      |   17 +++-
 fs/f2fs/f2fs.h                                      |   13 +++
 fs/f2fs/file.c                                      |    2=20
 fs/f2fs/gc.c                                        |    2=20
 fs/f2fs/segment.c                                   |   13 +--
 fs/kernfs/dir.c                                     |    5 -
 include/linux/i2c.h                                 |    3=20
 net/8021q/vlan_dev.c                                |    4 -
 net/bridge/br_if.c                                  |   13 +--
 net/core/fib_rules.c                                |    6 -
 net/core/flow_dissector.c                           |    3=20
 net/dsa/dsa.c                                       |   11 ++-
 net/ipv4/raw.c                                      |    4 -
 net/ipv6/sit.c                                      |    2=20
 net/packet/af_packet.c                              |   25 +++++-
 net/tipc/socket.c                                   |    4 -
 security/selinux/hooks.c                            |    8 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c       |   43 ++++++-----
 45 files changed, 375 insertions(+), 147 deletions(-)

Andrea Parri (1):
      kernfs: fix barrier usage in __kernfs_new_node()

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Corentin Labbe (1):
      net: ethernet: stmmac: dwmac-sun8i: enable support of unicast filteri=
ng

Damien Le Moal (1):
      f2fs: Fix use of number of devices

Dan Carpenter (2):
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

Dexuan Cui (3):
      PCI: hv: Fix a memory leak in hv_eject_device_work()
      PCI: hv: Add hv_pci_remove_slots() when we unload the driver
      PCI: hv: Add pci_destroy_slot() in pci_devices_present_work(), if nec=
essary

Eric Dumazet (1):
      flow_dissector: disable preemption around BPF calls

Greg Kroah-Hartman (1):
      Linux 5.1.3

Gustavo A. R. Silva (2):
      platform/x86: sony-laptop: Fix unintentional fall-through
      rtlwifi: rtl8723ae: Fix missing break in switch statement

Hangbin Liu (2):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_=
F_EXCL not supplied
      vlan: disable SIOCSHWTSTAMP in container

Hans de Goede (1):
      virt: vbox: Sanity-check parameter types for hgcm-calls coming from u=
serspace

Harini Katakam (1):
      net: macb: Change interrupt and napi enable order in open

Heiner Kallweit (1):
      net: phy: fix phy_validate_pause

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Wang (2):
      tuntap: fix dividing by zero in ebpf queue selection
      tuntap: synchronize through tfiles array instead of tun->numqueues

Jiaxun Yang (1):
      platform/x86: thinkpad_acpi: Disable Bluetooth for some machines

Johan Hovold (1):
      USB: serial: fix unthrottle races

Kees Cook (1):
      selftests/seccomp: Handle namespace failures gracefully

Laurentiu Tudor (2):
      dpaa_eth: fix SG frame cleanup
      powerpc/booke64: set RI in default MSR

Lei YU (1):
      hwmon: (occ) Fix extended status bits

Mario Limonciello (1):
      platform/x86: dell-laptop: fix rfkill functionality

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Paolo Abeni (1):
      selinux: do not report error on connect(AF_UNSPEC)

Parthasarathy Bhuvaragan (1):
      tipc: fix hanging clients using poll with EPOLLOUT flag

Paul Bolle (1):
      isdn: bas_gigaset: use usb_fill_int_urb() properly

Petr =C5=A0tetiar (1):
      mwl8k: Fix rate_idx underflow

Rick Lindsley (1):
      powerpc/book3s/64: check for NULL pointer in pgd_alloc()

Russell Currey (1):
      powerpc/powernv/idle: Restore IAMR after idle

Stefan Wahren (1):
      hwmon: (pwm-fan) Disable PWM if fetching cooling data fails

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Thomas Bogendoerfer (1):
      net: seeq: fix crash caused by not set dev.parent

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Wolfram Sang (1):
      i2c: core: ratelimit 'transfer when suspended' errors

YueHaibing (3):
      net: dsa: Fix error cleanup path in dsa_init_module
      packet: Fix error path in packet_init
      virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzeZKIACgkQONu9yGCS
aT7e+BAA0t7GYlHXEaPM04PmyGE7kCo6nFqlUmkYpGVhPCP2nKb4XgxsPAO7XJn/
NX5WO7YSIM4yl0UQmicKAxwpg2nCEMsbg5RH05RSsftr/JGTsFv1pJHED9fTIKtr
/YLgOuwyB2r1FG6Zd8zimYOdqu+6mW9bgrdYwDW3f3TDnna0qM/JiPy7twJ9pRbi
Z++7kqsXfuIE511WJ5soKC4Al+UFszTONhXt8locnS2nmHFCvh/4BE7D61QcS34R
UDdOkJBSxgMUW1QpxEEGYZ9y4gTC9mgQjh9ealqV7P1djr0Tsp0OxTxNNgZJ2+Ly
v3RAL/pj9wstt9SNls+DE83SfsSdUStGbA8OXf/9k+K0fRAmS+dK+yfV0qYWHFW+
3tlmKVmWk4EIVH3c4JajFbefisfSMyvhWqESBjIPj90F/log3GThc0pWB6Xu0J0S
ZjmYUjx8e/C2m6rlDU7lWhmm3vpb1sEYHEPKwZqsHiQyoJectsFpcYWXXHzxzgKe
YxHd4yFnA0J73rzpP5xpikp9jdZRuzl0XMOxbrIkeRNLbrZRpVpa1xVdHEO9PDPY
9jditxmZrdGsXm3lQxEs/aTJqHrZV13UErJ75EYo95FOo7BMBX9O2VKuAo2Tomgo
73K6MrbXpdSECMZ8TdcTTD1huH++LXLc3nMN+WC8FK7Ot8oznHc=
=jxd3
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
