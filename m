Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866762F4AAE
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbhAMLuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 06:50:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51736 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbhAMLuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 06:50:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2AC0F1C0B8F; Wed, 13 Jan 2021 12:49:41 +0100 (CET)
Date:   Wed, 13 Jan 2021 12:49:34 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian Labisch <clnetbox@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 67/77] ALSA: hda/via: Fix runtime PM for Clevo W35xSS
Message-ID: <20210113114934.GB2843@duo.ucw.cz>
References: <20210111130036.414620026@linuxfoundation.org>
 <20210111130039.628452970@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20210111130039.628452970@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Takashi Iwai <tiwai@suse.de>
>=20
> commit 4bfd6247fa9164c8e193a55ef9c0ea3ee22f82d8 upstream.
>=20
> Clevo W35xSS_370SS with VIA codec has had the runtime PM problem that
> looses the power state of some nodes after the runtime resume.  This
> was worked around by disabling the default runtime PM via a denylist
> entry.  Since 5.10.x made the runtime PM applied (casually) even
> though it's disabled in the denylist, this problem was revisited.  The
> result was that disabling power_save_node feature suffices for the
> runtime PM problem.

=46rom changelog it looks like we do not need this for 4.19.

Best regards,
								Pavel
								=20

--=20
http://www.livejournal.com/~pavelmachek

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/7eTgAKCRAw5/Bqldv6
8pXmAJ4phO14s2bVgfq1KWY/uM4jKzhXOQCfdKKU+EvVdK9o0pXWg8i01Uxk8LQ=
=QL4Y
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
