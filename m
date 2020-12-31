Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4F02E8191
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgLaSQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 13:16:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42734 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbgLaSQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 13:16:25 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0603B1C0B79; Thu, 31 Dec 2020 19:15:43 +0100 (CET)
Date:   Thu, 31 Dec 2020 19:15:42 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 267/346] ALSA: hda/ca0132 - Change Input Source enum
 strings.
Message-ID: <20201231181542.GA28026@amd>
References: <20201228124919.745526410@linuxfoundation.org>
 <20201228124932.680293903@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20201228124932.680293903@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Connor McAdams <conmanx360@gmail.com>
>=20
> commit 7079f785b50055a32b72eddcb7d9ba5688db24d0 upstream.
>=20
> Change the Input Source enumerated control's strings to make it play
> nice with pulseaudio.

> +++ b/sound/pci/hda/patch_ca0132.c
> @@ -106,7 +106,7 @@ enum {
>  };
> =20
>  /* Strings for Input Source Enum Control */
> -static const char *const in_src_str[3] =3D {"Rear Mic", "Line", "Front M=
ic" };
> +static const char *const in_src_str[3] =3D { "Microphone", "Line In", "F=
ront Microphone" };
>  #define IN_SRC_NUM_OF_INPUTS 3

If pulseaudio expects the strings to be from small set, should we have
defines for them?

If pulseaudio can't understand short versions, do these need fixing,
too?

hda_auto_parser.c:		"Internal Mic", "Dock Mic", "Mic", "Rear Mic", "Front M=
ic"
hda_auto_parser.c:			return "Headset Mic";
hda_auto_parser.c:			return "Headphone Mic";
hda_auto_parser.c:			return "Mic";
hda_auto_parser.c:		return "Headphone Mic";
hda_jack.c:						    cfg, "Headphone Mic");
hda_jack.c:						    cfg, "Headphone Mic");
hda_proc.c:		"Line In", "Aux", "Mic", "Telephony",

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/uFU4ACgkQMOfwapXb+vIc4wCgho+qPygudvptuabw+9ZymCzy
qNkAnAw88I21GQc44txhYx0yy8PT0wAF
=xyUr
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
