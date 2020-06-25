Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CDE20A565
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 21:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgFYTC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 15:02:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55310 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403781AbgFYTC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 15:02:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8AFC51C0BD2; Thu, 25 Jun 2020 21:02:55 +0200 (CEST)
Date:   Thu, 25 Jun 2020 21:02:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/206] ALSA: hda/realtek - Introduce polarity for
 micmute LED GPIO
Message-ID: <20200625190255.GB5531@duo.ucw.cz>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195317.567695457@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20200623195317.567695457@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Currently mute LED and micmute LED share the same GPIO polarity.
>=20
> So split the polarity for mute and micmute, in case they have different
> polarities.

> +++ b/sound/pci/hda/patch_realtek.c
> @@ -94,6 +94,7 @@ struct alc_spec {
> =20
>  	/* mute LED for HP laptops, see alc269_fixup_mic_mute_hook() */
>  	int mute_led_polarity;
> +	int micmute_led_polarity;
>  	hda_nid_t mute_led_nid;
>  	hda_nid_t cap_mute_led_nid;
>

This variable will be always zero in 4.19.130... so the patch does not
really do anything.

In mainline, commit 3e0650ab26e20 makes use of this variable.

Best regards,
										Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvT03wAKCRAw5/Bqldv6
8oN3AKCJ59Eqf9yMVzKyjC0MOyX5f2akRgCgt7yS+zqHipO0FdnOTgiw27iz+qY=
=euAr
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
