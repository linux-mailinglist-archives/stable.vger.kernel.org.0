Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202932D71E4
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 09:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391987AbgLKIhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 03:37:17 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45484 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391984AbgLKIhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 03:37:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C48D31C0B8B; Fri, 11 Dec 2020 09:36:21 +0100 (CET)
Date:   Fri, 11 Dec 2020 09:36:21 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 15/39] ALSA: hda/generic: Add option to enforce
 preferred_dacs pairs
Message-ID: <20201211083621.GA9395@duo.ucw.cz>
References: <20201210142602.272595094@linuxfoundation.org>
 <20201210142603.037114540@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20201210142603.037114540@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Takashi Iwai <tiwai@suse.de>
>=20
> commit 242d990c158d5b1dabd166516e21992baef5f26a upstream.
>=20
> The generic parser accepts the preferred_dacs[] pairs as a hint for
> assigning a DAC to each pin, but this hint doesn't work always
> effectively.  Currently it's merely a secondary choice after the trial
> with the path index failed.  This made sometimes it difficult to
> assign DACs without mimicking the connection list and/or the badness
> table.
>=20
> This patch adds a new flag, obey_preferred_dacs, that changes the
> behavior of the parser.  As its name stands, the parser obeys the

Option added is never used as variable is never set. We don't need
this in 4.19.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX9MvhQAKCRAw5/Bqldv6
8uJOAJwMOJXGmIR1oqWNQAu4KDxKi4mViACghYPweN/Sh3j7Qk3UnX39EMDfBPc=
=nWwb
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
