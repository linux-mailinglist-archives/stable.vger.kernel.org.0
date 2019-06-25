Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B252555
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfFYHw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfFYHw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 03:52:26 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CCE20863;
        Tue, 25 Jun 2019 07:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561449145;
        bh=P/ocJrXSJAaOJc1XBFTiIKSwrBYVDU55lTVp5CGtUfQ=;
        h=Date:From:To:Cc:Subject:From;
        b=jb3Z7knfH7pqkKrAFaaW769x49QvjQ+1Pn23JzmdcFYu4egJQ87DRULRAtPcm545M
         anV2d4ff81Rts4T0OcSWvUgpXk77nWtwXCEX0qX7RzqVZYbQ+72LXM8OQlVNxTOXX+
         R4zVg+lat/ztND6I/cXyEM/CTFslbsmXF+R3112g=
Date:   Tue, 25 Jun 2019 15:51:14 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.130
Message-ID: <20190625075114.GA22192@kroah.com>
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

I'm announcing the release of the 4.14.130 kernel.

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

 Makefile                                         |    4 +-
 arch/arc/boot/dts/hsdk.dts                       |    4 ++
 arch/arc/include/asm/cmpxchg.h                   |   14 ++++++--
 arch/arc/mm/tlb.c                                |   13 ++++---
 arch/arm/boot/dts/am57xx-idk-common.dtsi         |    1=20
 arch/arm/mach-imx/cpuidle-imx6sx.c               |    3 +
 arch/mips/kernel/uprobes.c                       |    3 -
 arch/parisc/math-emu/cnv_float.h                 |    8 ++--
 arch/powerpc/include/asm/ppc-opcode.h            |    1=20
 arch/powerpc/net/bpf_jit.h                       |    2 -
 arch/powerpc/net/bpf_jit_comp64.c                |    8 ++--
 arch/sparc/kernel/mdesc.c                        |    2 +
 arch/sparc/kernel/perf_event.c                   |    4 ++
 arch/xtensa/kernel/setup.c                       |    3 +
 drivers/gpu/drm/arm/hdlcd_crtc.c                 |   14 ++++----
 drivers/hwmon/hwmon.c                            |    2 -
 drivers/hwmon/pmbus/pmbus_core.c                 |   34 ++++++++++++++++++=
--
 drivers/infiniband/hw/hfi1/chip.c                |    1=20
 drivers/infiniband/hw/hfi1/user_exp_rcv.c        |    3 +
 drivers/infiniband/hw/hfi1/verbs.c               |    2 -
 drivers/infiniband/hw/hfi1/verbs_txreq.c         |    2 -
 drivers/infiniband/hw/hfi1/verbs_txreq.h         |    3 +
 drivers/infiniband/hw/qib/qib_verbs.c            |    2 -
 drivers/infiniband/sw/rdmavt/mr.c                |    2 +
 drivers/infiniband/sw/rdmavt/qp.c                |    3 +
 drivers/input/misc/uinput.c                      |   22 ++++++++++++-
 drivers/input/mouse/synaptics.c                  |    2 +
 drivers/mmc/core/sdio.c                          |   13 +++++++
 drivers/mmc/core/sdio_irq.c                      |    4 ++
 drivers/net/can/flexcan.c                        |    2 -
 drivers/net/dsa/mv88e6xxx/chip.c                 |    2 -
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |    4 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c      |   15 ++++-----
 drivers/net/ipvlan/ipvlan_main.c                 |    2 -
 drivers/net/phy/bcm-phy-lib.c                    |    4 +-
 drivers/nvme/host/core.c                         |    3 +
 drivers/parport/share.c                          |    2 +
 drivers/s390/net/qeth_l2_main.c                  |    2 -
 drivers/scsi/smartpqi/smartpqi_init.c            |    6 ++-
 drivers/scsi/ufs/ufshcd-pltfrm.c                 |   11 ++----
 drivers/scsi/ufs/ufshcd.c                        |    3 +
 drivers/usb/chipidea/udc.c                       |   20 ++++++++++++
 fs/btrfs/reada.c                                 |    5 +++
 fs/cifs/smb2maperror.c                           |    2 -
 include/net/bluetooth/hci_core.h                 |    3 +
 kernel/trace/trace.c                             |    6 ---
 kernel/trace/trace.h                             |   18 ++++++++++
 kernel/trace/trace_kdb.c                         |    6 ---
 net/bluetooth/hci_conn.c                         |   10 +++++-
 net/bluetooth/l2cap_core.c                       |   33 ++++++++++++++++---
 net/can/af_can.c                                 |    1=20
 net/mac80211/ieee80211_i.h                       |    3 +
 net/mac80211/mlme.c                              |   12 ++++++-
 net/mac80211/rx.c                                |    2 +
 net/mac80211/tdls.c                              |   23 +++++++++++++
 net/mac80211/wpa.c                               |    7 +++-
 net/wireless/core.c                              |    2 -
 scripts/checkstack.pl                            |    2 -
 security/apparmor/policy_unpack.c                |    2 -
 tools/objtool/check.c                            |   38 ++++++++++++++++++=
+----
 tools/objtool/check.h                            |    4 +-
 tools/objtool/elf.c                              |    1=20
 tools/objtool/elf.h                              |    3 +
 63 files changed, 336 insertions(+), 102 deletions(-)

Alexander Mikhaylenko (1):
      Input: synaptics - enable SMBus on ThinkPad E480 and E580

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Allan Xavier (1):
      objtool: Support per-function rodata sections

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Avri Altman (1):
      scsi: ufs: Check that space was properly alloced in copy_query_respon=
se

Dan Carpenter (1):
      scsi: smartpqi: unlock on error in pqi_submit_raid_request_synchronou=
s()

Eduardo Valentin (1):
      hwmon: (core) add thermal sensors only if dev->of_node is present

Eric Biggers (1):
      cfg80211: fix memory leak of wiphy device name

Fabio Estevam (1):
      ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Faiz Abbas (1):
      ARM: dts: am57xx-idk: Remove support for voltage switching for SD card

Florian Fainelli (1):
      net: phy: broadcom: Use strlcpy() for ethtool::get_strings

Gen Zhang (1):
      mdesc: fix a missing-check bug in get_vdev_port_node_info()

George G. Davis (1):
      scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Greg Kroah-Hartman (1):
      Linux 4.14.130

Guenter Roeck (1):
      xtensa: Fix section mismatch between memblock_reserve and mem_reserve

Helge Deller (1):
      parisc: Fix compiler warnings in float emulation code

Jaesoo Lee (1):
      nvme: Fix u32 overflow in the number of namespace list calculation

Jann Horn (1):
      apparmor: enforce nullbyte at end of tag string

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA

Jose Abreu (2):
      ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC no=
de
      ARC: [plat-hsdk]: Add missing FIFO size entry in GMAC node

Jouni Malinen (1):
      mac80211: Do not use stack memory with scatterlist for GMAC

Kamenee Arumugam (1):
      IB/hfi1: Validate page aligned for a given virtual address

Linus Torvalds (1):
      gcc-9: silence 'address-of-packed-member' warning

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions
      Bluetooth: Fix regression with minimum encryption key size alignment

Miaohe Lin (1):
      net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is =
set

Miguel Ojeda (1):
      tracing: Silence GCC 9 array bounds warning

Mike Marciniszyn (4):
      IB/hfi1: Silence txreq allocation warnings
      IB/rdmavt: Fix alloc_qpn() WARN_ON()
      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
      IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

Naveen N. Rao (1):
      powerpc/bpf: use unsigned division instruction for 64-bit operations

Nikita Yushchenko (1):
      net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

Peter Chen (1):
      usb: chipidea: udc: workaround for endpoint conflict issue

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Robin Murphy (2):
      drm/arm/hdlcd: Actually validate CRTC modes
      drm/arm/hdlcd: Allow a bit of clock tolerance

Sean Wang (2):
      net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported
      net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFF=
SET is enabled

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever

Steve French (1):
      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

Ulf Hansson (1):
      mmc: core: Prevent processing SDIO IRQs when the card is suspended

Vineet Gupta (1):
      ARC: fix build warnings

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

Yonglong Liu (1):
      net: hns: Fix loopback test failed at copper ports

Young Xiao (1):
      sparc: perf: fix updated event period in response to PERF_EVENT_IOC_P=
ERIOD

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

YueHaibing (2):
      parport: Fix mem leak in parport_register_dev_model
      MIPS: uprobes: remove set but not used variable 'epc'


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0R0nIACgkQONu9yGCS
aT6mxA//VaWyL4gjK2+FupcVG6dWGgHPcKTD/Ka274Eo2AEvJJromIREWClgBi6+
EZqoqb0eR37e3hGOvqgzJpXkLYxvqmuTVmvpO0MZjk1pJFFGihEaFhQOx5zZ2nmt
NVaEYey98GD34FT3MpnQsyeOGdWSzCmUjPRnUpTwlb/diKp9vZpK4ScnFRAK2Mc4
jN4W+cKrL46EwdsIe+JsgmSdDYiSuFVjiGXQv8LQ725dGIhkyib6BNdyyFsYqI1b
y+jCDZQ/rlMofehIkytCi+Zt13qZz9MzsFwU+V0XkypBL4YO/kdd8SYDZPpz5vsK
V/ER2Gwf5vcftCAJCWGW3Cg+98sqI2RA5CVP5lsu9/xtvFXae1jl2v2JQZfOFl7S
zZNEA1ii9tOBywSvKz2ZakVwPkWXR156UdviN165DLpw7MT2SSFQXgQ3tQq1lODp
FrBotFIibPyyM/innO/IzuqIaE2PLs0ofnYG6DoZD5T4t75VfeLCHmnMfVF91euq
I7JNtpng0mJUMF09UCtTyR3A+ouiNIp/0jak7RhjzU85nMDi118F2GO9IxefrP91
h5my7hcOkYcu11yH3AfxnvUyXWrJYyhUKF7WnzD0GHeLGAWZ6ZkY+ThXf4Cn6/Wx
94+ps+AWJC7LghaMJ1+KxMBIrA94wiMq/IRG5Hnkur84pPa/b1s=
=lgon
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
