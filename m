Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1452D823E
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404745AbgLKWjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:39:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45164 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406972AbgLKWjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:39:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 297DB1C0BC5; Fri, 11 Dec 2020 23:38:23 +0100 (CET)
Date:   Fri, 11 Dec 2020 23:38:22 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 15/39] ALSA: hda/generic: Add option to enforce
 preferred_dacs pairs
Message-ID: <20201211223822.GB18452@amd>
References: <20201210142602.272595094@linuxfoundation.org>
 <20201210142603.037114540@linuxfoundation.org>
 <20201211083621.GA9395@duo.ucw.cz>
 <s5hy2i4pwdk.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <s5hy2i4pwdk.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Takashi Iwai <tiwai@suse.de>
> > >=20
> > > commit 242d990c158d5b1dabd166516e21992baef5f26a upstream.
> > >=20
> > > The generic parser accepts the preferred_dacs[] pairs as a hint for
> > > assigning a DAC to each pin, but this hint doesn't work always
> > > effectively.  Currently it's merely a secondary choice after the trial
> > > with the path index failed.  This made sometimes it difficult to
> > > assign DACs without mimicking the connection list and/or the badness
> > > table.
> > >=20
> > > This patch adds a new flag, obey_preferred_dacs, that changes the
> > > behavior of the parser.  As its name stands, the parser obeys the
> >=20
> > Option added is never used as variable is never set. We don't need
> > this in 4.19.
>=20
> Right, it seems that the succeeding fix is queued only for 5.4 and
> 5.9.
>=20
> OTOH, this change will help if another quirk is added in near future,
> and it's pretty safe to apply, so I think it's worth to keep it.

I agree that this is safe to apply and makes sense if we get another
quirk soon. OTOH it is trivial to backport if it is needed.

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/T9N4ACgkQMOfwapXb+vJLbACfY1I3Vuk/n8LIY5QyIKk9yTcm
l/8AnRj5OmlyXp9G3TdWxaCeFwMKlkcQ
=GLKi
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
