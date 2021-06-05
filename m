Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6139C8E8
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFENoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 09:44:12 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35682 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFENoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 09:44:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 555151C0B76; Sat,  5 Jun 2021 15:42:23 +0200 (CEST)
Date:   Sat, 5 Jun 2021 15:42:22 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 235/252] ALSA: usb-audio: scarlett2:
 snd_scarlett_gen2_controls_create() can be static
Message-ID: <20210605134222.GA28479@amd>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130705.983881838@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20210531130705.983881838@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: kernel test robot <lkp@intel.com>
>=20
> [ Upstream commit 2b899f31f1a6db2db4608bac2ac04fe2c4ad89eb ]
>=20
> sound/usb/mixer_scarlett_gen2.c:2000:5: warning: symbol 'snd_scarlett_gen=
2_controls_create' was not declared. Should it be static?
>=20
> Fixes: 265d1a90e4fb ("ALSA: usb-audio: scarlett2: Improve driver startup =
messages")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/r/20210522180900.GA83915@f59a3af2f1d9
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

We normally require real, legal names for commit authors and
signoffs. I guess it is a bit late now, but... we don't take
pseudonyms so we should not take robots.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC7fz0ACgkQMOfwapXb+vK5WwCeN1V8IcodHCJc1fv/6cUAec+9
AVwAn31eohvJOOPPdFrayKktglOb327m
=sJs1
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
