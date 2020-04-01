Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B042A19AD69
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgDAOH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 10:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732894AbgDAOH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 10:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5522206F6;
        Wed,  1 Apr 2020 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585750047;
        bh=pvsObeztfWxr/slMNd2FfI4kv332DjXD/AUbhUNq2Qo=;
        h=Date:From:To:Cc:Subject:From;
        b=MSV+krG+BWkqLgmIBokt+PzlH5MSfWkVr02FGp7w8yhYsUbpDQ30rIFu8ZUygAw1L
         0ZULyOBJpOH3w9oK7YbUw8VCRFIwXU++pKlJVMkTGOASSNWH1f0yyXV3VnIgCDOh6L
         pYydc7IEFuKyaBDJjRhlyX842VO4DqVLa9NuZkEw=
Date:   Wed, 1 Apr 2020 16:04:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.1
Message-ID: <20200401140451.GA2427801@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.1 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                                  =
         |    2=20
 drivers/ata/ahci.c                                                        =
         |    1=20
 drivers/media/usb/b2c2/flexcop-usb.c                                      =
         |    6 -
 drivers/media/usb/dvb-usb/dib0700_core.c                                  =
         |    4=20
 drivers/media/usb/gspca/ov519.c                                           =
         |   10 ++
 drivers/media/usb/gspca/stv06xx/stv06xx.c                                 =
         |   19 ++++
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c                          =
         |    4=20
 drivers/media/usb/gspca/xirlink_cit.c                                     =
         |   18 ++++
 drivers/media/usb/usbtv/usbtv-core.c                                      =
         |    2=20
 drivers/media/usb/usbtv/usbtv-video.c                                     =
         |    5 -
 drivers/media/v4l2-core/v4l2-device.c                                     =
         |    1=20
 drivers/staging/kpc2000/kpc2000/core.c                                    =
         |    4=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                               =
         |    1=20
 drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/siliabs=
,wfx.txt |    7 -
 drivers/staging/wfx/bus_sdio.c                                            =
         |   15 +--
 drivers/staging/wfx/bus_spi.c                                             =
         |   41 +++++-----
 drivers/staging/wfx/main.c                                                =
         |   21 +++--
 drivers/staging/wfx/main.h                                                =
         |    1=20
 drivers/staging/wfx/queue.c                                               =
         |   16 +--
 drivers/staging/wlan-ng/hfa384x_usb.c                                     =
         |    2=20
 drivers/staging/wlan-ng/prism2usb.c                                       =
         |    1=20
 drivers/usb/class/cdc-acm.c                                               =
         |   18 ++--
 drivers/usb/musb/musb_host.c                                              =
         |   17 +---
 drivers/usb/serial/io_edgeport.c                                          =
         |    2=20
 drivers/usb/serial/option.c                                               =
         |    6 +
 fs/libfs.c                                                                =
         |    8 +
 kernel/bpf/verifier.c                                                     =
         |   19 ----
 27 files changed, 148 insertions(+), 103 deletions(-)

Dafna Hirschfeld (1):
      media: v4l2-core: fix a use-after-free bug of sd->devnode

Dan Carpenter (1):
      staging: kpc2000: prevent underflow in cpld_reconfigure()

Daniel Borkmann (1):
      bpf: Undo incorrect __reg_bound_offset32 handling

Eric Biggers (1):
      libfs: fix infoleak in simple_attr_read()

Greg Kroah-Hartman (1):
      Linux 5.6.1

Johan Hovold (6):
      media: flexcop-usb: fix endpoint sanity check
      media: usbtv: fix control-message timeouts
      media: ov519: add missing endpoint sanity checks
      media: dib0700: fix rc endpoint lookup
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Kai-Heng Feng (1):
      ahci: Add Intel Comet Lake H RAID PCI ID

Larry Finger (1):
      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Mans Rullgard (1):
      usb: musb: fix crash with highmen PIO and usbmon

Matthias Reichl (1):
      USB: cdc-acm: restore capability check order

Micha=C5=82 Miros=C5=82aw (3):
      staging: wfx: add proper "compatible" string
      staging: wfx: fix init/remove vs IRQ race
      staging: wfx: annotate nested gc_list vs tx queue locking

Pawel Dembicki (3):
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Qiujun Huang (3):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interru=
pt_callback
      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6En4IACgkQONu9yGCS
aT7sGA/+P1W6ARrYuCgpCqjSt0b3DuUSLhKiFoqxtuePulusov4DL4yK7O0LI9Kc
b/OS9K6MeL/9o2ZX6GFkbAW26vEg2/2F/ldLuF8dInBcvSN/q7hYVmPXksdGypCB
Mh3/fsuex+KljR4BYlOJ01T3CX4xvRQfJu+xbNUq3bhX2vuVG/K76BU4r3tThHsg
v+8hSxxKukz/Gf9LNRNcf0JyWhazQlL5uGhNtYxH953LRi/XJLQC+Qs/9Etkm6gr
oXUsaRtycLyUnZkke6JaCPs0733MFRHipnaKwrMwoA9TzJeA6mCn0WaznFxPvUuC
VNBTVZbvkIDiCU7ra31TyLV91URfoU8Q07hDHc3c8b2PTPbmNa+TDv9N0BetrsTV
Fg1TtnXOPpxMPCPDpDAJGwc6B/yGvK2NDA5oFwf5DMiiWHI7E+vOA7kQFgZZg02E
/rK6k9v/O9tQD++zZPwJbNuYx9ahAsFFiEgrExD2zGkVlV9KSDf7OELP6thzQxtr
/gci3uGXj9v4sbc8wdiaxp3YyUO6gci750C5EMio/3JmfgO2rk3yoGsBHMMgMC0g
o18pvkedK7au21uQgWJN0/bam59AGgdXuuKMLd67bR8WBujl4qwJaampnapjX7Kl
s6dKjQSaWMbx4kQ/HwpjIeAxux6s0ldLnMfvgf8DeXrHVBQx2PQ=
=eB1v
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
