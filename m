Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CAD2905B4
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395509AbgJPNGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:06:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41602 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394512AbgJPNG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:06:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C38781C0B7D; Fri, 16 Oct 2020 15:06:27 +0200 (CEST)
Date:   Fri, 16 Oct 2020 15:06:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: Re: [PATCH 4.19 14/21] staging: comedi: check validity of
 wMaxPacketSize of usb endpoints found
Message-ID: <20201016130626.GA4335@amd>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016090437.987989197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20201016090437.987989197@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>=20
> commit e1f13c879a7c21bd207dc6242455e8e3a1e88b40 upstream.
>=20
> While finding usb endpoints in vmk80xx_find_usb_endpoints(), check if
> wMaxPacketSize =3D 0 for the endpoints found.
>=20
> Some devices have isochronous endpoints that have wMaxPacketSize =3D 0
> (as required by the USB-2 spec).
> However, since this doesn't apply here, wMaxPacketSize =3D 0 can be
> considered to be invalid.
>=20
> Reported-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
> Tested-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20201010082933.5417-1-anant.thazhemadam@g=
mail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Why duplicate Sign-off?

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+JmtIACgkQMOfwapXb+vLYuACglJXlWCS7ODg7GkEHkt1S3fbn
bTwAoKeycDZdTyfsy7RYZtgy4rcWYvyR
=s3Ty
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
