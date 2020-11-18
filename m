Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C202B7B8C
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 11:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgKRKnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 05:43:20 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35430 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRKnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 05:43:19 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 241641C0B78; Wed, 18 Nov 2020 11:43:17 +0100 (CET)
Date:   Wed, 18 Nov 2020 11:43:16 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 031/101] ALSA: hda: Reinstate runtime_allow() for
 all hda controllers
Message-ID: <20201118104316.GA8364@duo.ucw.cz>
References: <20201117122113.128215851@linuxfoundation.org>
 <20201117122114.605040102@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20201117122114.605040102@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>=20
> [ Upstream commit 9fc149c3bce7bdbb94948a8e6bd025e3b3538603 ]
>=20
> The broken jack detection should be fixed by commit a6e7d0a4bdb0 ("ALSA:
> hda: fix jack detection with Realtek codecs when in D3"), let's try
> enabling runtime PM by default again.

I believe experiments should be done in mainline, not in stable.

Worse problem is that a6e7d0a4bdb0 is not in 4.19-stable, so this will
likely break jack detection.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX7T6xAAKCRAw5/Bqldv6
8qNvAJ0erFrRa/rwZNBgtghWbPFsW/lv3QCgmShM9pXWR35stOVOhIafBJzOqZ0=
=HvEy
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
