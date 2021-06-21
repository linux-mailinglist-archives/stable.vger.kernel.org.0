Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D563AE82F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 13:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhFULal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 07:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhFULak (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 07:30:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03399C061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 04:28:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lvI6I-0007g1-4Y; Mon, 21 Jun 2021 13:28:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3569:1fb5:40be:61fc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BA172640529;
        Mon, 21 Jun 2021 11:28:20 +0000 (UTC)
Date:   Mon, 21 Jun 2021 13:28:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     kernel@pengutronix.de,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-stable <stable@vger.kernel.org>,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
Message-ID: <20210621112820.5gemmaw56bipx45j@pengutronix.de>
References: <1624271916195215@kroah.com>
 <20210621112451.2882032-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yhmgce7jhv4ifrup"
Content-Disposition: inline
In-Reply-To: <20210621112451.2882032-1-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yhmgce7jhv4ifrup
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.06.2021 13:24:51, Marc Kleine-Budde wrote:
> From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>=20
> commit 8d0caedb759683041d9db82069937525999ada53 upstream
>=20
> syzbot is reporting hung task at register_netdevice_notifier() [1] and
> unregister_netdevice_notifier() [2], for cleanup_net() might perform
> time consuming operations while CAN driver's raw/bcm/isotp modules are
> calling {register,unregister}_netdevice_notifier() on each socket.
>=20
> Change raw/bcm/isotp modules to call register_netdevice_notifier() from
> module's __init function and call unregister_netdevice_notifier() from
> module's __exit function, as with gw/j1939 modules are doing.
>=20
> Link: https://syzkaller.appspot.com/bug?id=3D391b9498827788b3cc6830226d4f=
f5be87107c30 [1]
> Link: https://syzkaller.appspot.com/bug?id=3D1724d278c83ca6e6df100a2e320c=
10d991cf2bce [2]
> Link: https://lore.kernel.org/r/54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-lo=
ve.sakura.ne.jp
> Cc: linux-stable <stable@vger.kernel.org>
> Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.co=
m>
> Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.co=
m>
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> [mkl: ported to v4.19.195]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hello Greg,
>=20
> this is a backport of
>=20
> | 8d0caedb7596 can: bcm/raw/isotp: use per module netdevice notifier
>=20
> to v4.19.195. Please apply.

This also applies to v4.14.237.

I'm working on a v4.9 version.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yhmgce7jhv4ifrup
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDQd9EACgkQqclaivrt
76kseQf+NvUFgZeGvQ+pY7pn/gR2djJfzNTIyLJcYEuOnZMkJ7AI4sdt3ixui7l0
KzdbyK7Brb85poOUvTq4+tK+f2j8UQ0EbNZLfcPzujHqSj+Ezw6gkmw5VXybn9O4
1so6rRjxm9U8Y5Ve81JdVVJ/rekHgSGTuhe6UcgyNt+3/SLJQPVX3GpCSfa/dh5G
/61MEr73YCKMg1FQqWiNqyqyHrQkj/x3iCINemmRxO/LwLgv3JRlugYWOJguNJZl
AGjc359azH4+AUaM6Qt/4M4cI6CLe2vKCFEcBtEQ85uey9wSqEVoIE/6ydh0Phwc
7KPW8Anu/igjA1KxB5/Ii4bMd3qiVQ==
=4jOM
-----END PGP SIGNATURE-----

--yhmgce7jhv4ifrup--
