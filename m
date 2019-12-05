Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC6211428E
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfLEOYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbfLEOYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 09:24:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F207206DB;
        Thu,  5 Dec 2019 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575555885;
        bh=jN17Ga8kf5HoaOx3s+oL4/naaLNCleezKFlMKQT6iZs=;
        h=Date:From:To:Cc:Subject:From;
        b=xm3AuUvczXN0AA/RlOFU6XFj7Wp4JS5yDWkI48662/3Tji5h0qOfTnU343GObCB1h
         dqupHspdKG2602TdxJHOe89KPZZ2c9dyzZe7Bh2sOb/J2QPGQX9xFk4ptlxsn9kHVB
         l1dO4CFPDgtJsaukKH5JMN2qZXAS6GJm14SRmp+c=
Date:   Thu, 5 Dec 2019 15:24:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.2
Message-ID: <20191205142443.GA693797@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.2 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/x86/include/asm/fpu/internal.h          |    2=20
 drivers/base/platform.c                      |    7 -
 drivers/crypto/Kconfig                       |    1=20
 drivers/crypto/inside-secure/safexcel.c      |    4=20
 drivers/hid/hid-core.c                       |   51 ++++++-
 drivers/misc/mei/bus.c                       |    9 -
 drivers/misc/mei/hw-me-regs.h                |    1=20
 drivers/misc/mei/pci-me.c                    |    1=20
 drivers/net/dsa/sja1105/sja1105_main.c       |   10 -
 drivers/net/ethernet/cadence/macb_main.c     |    1=20
 drivers/net/ethernet/google/gve/gve_main.c   |    3=20
 drivers/net/ethernet/realtek/r8169_main.c    |    3=20
 drivers/net/macvlan.c                        |    3=20
 drivers/net/phy/mdio_bus.c                   |    6=20
 drivers/net/slip/slip.c                      |    1=20
 drivers/platform/x86/hp-wmi.c                |   10 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    5=20
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |    7 -
 drivers/staging/wilc1000/wilc_hif.c          |   25 ++-
 drivers/thunderbolt/switch.c                 |   54 ++++++-
 drivers/usb/dwc2/core.c                      |    2=20
 drivers/usb/serial/ftdi_sio.c                |    3=20
 drivers/usb/serial/ftdi_sio_ids.h            |    7 +
 fs/ext4/inode.c                              |   15 ++
 fs/ext4/super.c                              |   21 +--
 fs/io_uring.c                                |   23 +++
 fs/jffs2/nodelist.c                          |    2=20
 include/linux/skmsg.h                        |   26 +--
 include/net/sctp/structs.h                   |    3=20
 include/net/tls.h                            |    3=20
 net/core/filter.c                            |    8 -
 net/core/skmsg.c                             |    2=20
 net/ipv4/tcp_bpf.c                           |    2=20
 net/openvswitch/datapath.c                   |   17 ++
 net/psample/psample.c                        |    2=20
 net/sched/sch_mq.c                           |    3=20
 net/sched/sch_mqprio.c                       |    4=20
 net/sched/sch_multiq.c                       |    2=20
 net/sched/sch_prio.c                         |    2=20
 net/sctp/associola.c                         |    1=20
 net/sctp/endpointola.c                       |    1=20
 net/sctp/input.c                             |    4=20
 net/sctp/sm_statefuns.c                      |    4=20
 net/socket.c                                 |  184 +++++++++++++++++++---=
-----
 net/tipc/netlink_compat.c                    |    4=20
 net/tls/tls_main.c                           |   13 -
 net/tls/tls_sw.c                             |   32 ++--
 tools/testing/selftests/bpf/test_sockmap.c   |   47 ++++--
 tools/testing/selftests/bpf/xdping.c         |    2=20
 tools/testing/selftests/net/pmtu.sh          |    5=20
 tools/testing/selftests/net/tls.c            |   60 ++++++++
 52 files changed, 504 insertions(+), 206 deletions(-)

Ajay Singh (1):
      staging: wilc1000: fix illegal memory access in wilc_parse_join_bss_p=
aram()

Alexander Usyskin (2):
      mei: bus: prefix device names on bus with the bus name
      mei: me: add comet point V device id

Candle Sun (1):
      HID: core: check whether Usage Page item is after Usage ID items

Chuhong Yuan (1):
      net: macb: add missed tasklet_kill

David Bauer (1):
      mdio_bus: don't use managed reset-controller

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock sub=
queues

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Greg Kroah-Hartman (1):
      Linux 5.4.2

Hans de Goede (4):
      staging: rtl8723bs: Drop ACPI device ids
      staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input si=
ze

Heiner Kallweit (2):
      r8169: fix jumbo configuration for RTL8168evl
      r8169: fix resume on cable plug-in

Herbert Xu (1):
      crypto: talitos - Fix build error by selecting LIB_DES

Jakub Kicinski (8):
      net/tls: take into account that bpf_exec_tx_verdict() may free the re=
cord
      net/tls: free the record on encryption error
      net: skmsg: fix TLS 1.3 crash with full sk_msg
      selftests/tls: add a test for fragmented messages
      net/tls: remove the dead inplace_crypto code
      net/tls: use sg_next() to walk sg entries
      selftests: bpf: test_sockmap: handle file creation failures gracefully
      selftests: bpf: correct perror strings

Jens Axboe (3):
      io_uring: async workers should inherit the user creds
      net: separate out the msghdr copy from ___sys_{send,recv}msg()
      net: disallow ancillary data for __sys_{send,recv}msg_file()

Jeroen de Borst (1):
      gve: Fix the queue page list allocated pages count

Joel Stanley (1):
      Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_fr=
ag_to_fragtree()"

John Rutherford (1):
      tipc: fix link name length check

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Mathias Kresin (1):
      usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Mika Westerberg (1):
      thunderbolt: Power cycle the router if NVM authentication fails

Navid Emamdoost (1):
      sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

Nikolay Aleksandrov (1):
      net: psample: fix skb_over_panic

Oleksij Rempel (1):
      net: dsa: sja1105: fix sja1105_parse_rgmii_delays()

Pan Bian (1):
      staging: rtl8192e: fix potential use after free

Paolo Abeni (3):
      openvswitch: fix flow command message size
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Pascal van Leeuwen (1):
      crypto: inside-secure - Fix stability issue with Macchiatobin

Sami Tolvanen (1):
      driver core: platform: use the correct callback type for bus_find_dev=
ice

Sebastian Andrzej Siewior (1):
      x86/fpu: Don't cache access to fpu_fpregs_owner_ctx

Thadeu Lima de Souza Cascardo (1):
      selftests: pmtu: use -oneline for ip route list cache

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Xin Long (1):
      sctp: cache netns in sctp_ep_common


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3pEysACgkQONu9yGCS
aT5LlRAAi3zI2RTma6gBGAs7EZHDVqyJvWo4os49/Gv3uyMOTGOoWsyjjtqCDXfY
eVrILFdvwHBHLyy4dm1dSj6o3P1BUjUdmF5WPeB38TEBiszcon+dAOaz71HGHVWJ
Ek4trg/MWtlx+JFaR6Opo+ojyedU89KykWyI4/OQ/VmvEbQ+4vdnqQzaD6TUUyh5
iijxlwfeaL2sOouJW2nhqg65U78RCqEL6FxnDGAh2OtEmYyb9YM2fPjUZzuaS2Bb
m1XIHgFhUbBEthQHIvNm0KjTBlGyKlcYW5oHxQCQ3rjLswiyYvZFYg0XVJMxHeGL
NP3zJzAYn2PDn27HqoGsqDC7zPWZ79tZiCR+swP7YeJMDe6RhiaUUqTxmXHEBnMW
T9kDtrFJR+AqmvXtjQaGzP3iiqDbigfoCsRl++GM+vB1dXKi/aXQzkiQ8k4c1UTo
+yQoQn4ASliSbDzsR8HUjcopUrPkKE64n6sfzL5D797YYtWwVdWFwDiEncvSNm8B
Q1oKTAJTaowHEZnkQLqspE1pIkfsxBGCEb4D56qbJ2h8bDyNw3ZagXjgwaa1+w1r
EFMFiHewv649EQAOhBUnvlz2GkNrtWGosR7AZKQeZAPoZVDzn/hQJLKN096jd742
hrkeWUjM8C62RAAoOhhqjzFRdzoc5NAalUP1PKhP4pr+wsvEuEQ=
=yyqz
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
