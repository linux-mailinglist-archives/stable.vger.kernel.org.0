Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A9CB9CB6
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405410AbfIUGhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405234AbfIUGhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:37:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77CF12080F;
        Sat, 21 Sep 2019 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047831;
        bh=F8GQMPQc1plnAROHxazH+4cAJ3N8VK8k8v0SxjdDkMU=;
        h=Date:From:To:Cc:Subject:From;
        b=mCWWN1UmLtaMgsO8PSyVsqsuAzkIjnPFH2r60a1/tzX7PWmVFmrwb9uO4vDXJizpP
         i06Yct8xSO9sli7P4PJ5Itr+CfbM0dHE7zn6lJvsCIOldb2t/0ApGvh55pl/Y52RVw
         peD8UkobCw1z3OCw1blCkb44Rit8tHWx+0VcL7cA=
Date:   Sat, 21 Sep 2019 08:37:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.1
Message-ID: <20190921063708.GA1083465@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.1 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/filesystems/overlayfs.txt           |    2=20
 Documentation/sphinx/automarkup.py                |    2=20
 Makefile                                          |    2=20
 arch/arm64/include/asm/pgtable.h                  |   12 ++-
 drivers/block/floppy.c                            |    4 -
 drivers/firmware/google/vpd.c                     |    4 -
 drivers/firmware/google/vpd_decode.c              |   55 +++++++++-------
 drivers/firmware/google/vpd_decode.h              |    6 -
 drivers/media/usb/dvb-usb/technisat-usb2.c        |   22 +++---
 drivers/media/usb/tm6000/tm6000-dvb.c             |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   12 ++-
 drivers/net/xen-netfront.c                        |    2=20
 drivers/phy/qualcomm/phy-qcom-qmp.c               |   33 ++++-----
 drivers/phy/renesas/phy-rcar-gen3-usb2.c          |    2=20
 drivers/tty/serial/atmel_serial.c                 |    1=20
 drivers/tty/serial/sprd_serial.c                  |    2=20
 drivers/usb/core/config.c                         |   12 ++-
 fs/overlayfs/ovl_entry.h                          |    1=20
 fs/overlayfs/super.c                              |   73 ++++++++++++++---=
-----
 include/net/pkt_sched.h                           |    7 +-
 include/net/sock_reuseport.h                      |   20 +++++-
 net/core/dev.c                                    |   16 +++-
 net/core/sock_reuseport.c                         |   15 +++-
 net/dsa/dsa2.c                                    |    2=20
 net/ipv4/datagram.c                               |    2=20
 net/ipv4/udp.c                                    |    5 -
 net/ipv6/datagram.c                               |    2=20
 net/ipv6/ip6_gre.c                                |    2=20
 net/ipv6/udp.c                                    |    5 -
 net/sched/sch_generic.c                           |    3=20
 net/wireless/nl80211.c                            |    4 -
 virt/kvm/coalesced_mmio.c                         |   19 +++--
 32 files changed, 226 insertions(+), 126 deletions(-)

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Amir Goldstein (1):
      ovl: fix regression caused by overlapping layers detection

Andrew Lunn (1):
      net: dsa: Fix load order between DSA drivers and taggers

Bjorn Andersson (1):
      phy: qcom-qmp: Correct ready status, again

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Cong Wang (1):
      net_sched: let qdisc_put() accept NULL pointer

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handl=
ing

Greg Kroah-Hartman (1):
      Linux 5.3.1

Hung-Te Lin (1):
      firmware: google: check if size is valid when decoding VPD data

Jann Horn (1):
      floppy: fix usercopy direction

Jonathan Neusch=E4fer (1):
      Documentation: sphinx: Add missing comma to list of strings

Jose Abreu (1):
      net: stmmac: Hold rtnl lock in suspend/resume callbacks

Masashi Honma (1):
      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Paolo Abeni (1):
      net/sched: fix race between deactivation and dequeue for NOLOCK qdisc

Razvan Stefanescu (1):
      tty/serial: atmel: reschedule TX after RX was started

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Will Deacon (1):
      Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"

Willem de Bruijn (1):
      udp: correct reuseport selection with connected sockets

Xin Long (1):
      ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2FxRQACgkQONu9yGCS
aT4Vdg//fkETFmQ3jz4BXfhraBd6JxJSkmoB2ONVlRJ/f/qgl3Iq8nZWF7Zjg40c
0V079yVMJZEtM8Oq+PPXYas2F6MA4d8O/1enc43neQPgXBmIXxTt56383ADH5Ww8
mptWi2QvLb5eGbmx4CdJ5d7gpsYHMkNoYgAlY8MDsFqUaBqdyGE50xhsYd28+LNK
Rg6kDRdehho48x/ZTKNdVSW/+7GlAiL+D7+wsqdGn093ku6mzo+J9vuj0Te52FtM
jC1WIUdHfgEvGBLIBdlvR9FIGdEAnueQt4l2fllCFAyzKe3i6Xtt+mQXJt4oA7BF
CRNtxZXE7jRpwA3GvRdnX8ik3a6lZ/7qg8QbgWjLNpW6X9C7Wje9oWnFNkN/TxPc
t3g22hBBV/kDKMmXwR5oNyS+oKBPOI5QgD/gJv5qoe81AzmIM/w9jSzSsgYbDiqE
Lk0gAVRhU50iger4yvmtDivTWMpd9zyK+jXztJWcZzp/9/amMQ1uhe0JY851ZtOq
ktMm1I3+6lvZ7Jxp0w+eQ21hY3r3rHNvQ8Nl3g3Ze6Zk3+WiXQPc2yT9yYBLr+YP
k/X0U47HR/26R9wZdMX48fU1SrgnIewlGr7n/rLADuUSaPx7QkEVSfhssPIY3etx
RJFeOZWRfeAFI4l6xnj0hy3WNPnzkHv8J03MHdTsM/kux5V1mO8=
=U2Cn
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
