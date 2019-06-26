Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB89566E1
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZKhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:37:48 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45324 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZKhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fthX7q1PA205K3HyB/4xm7JyslheucTEViGnfJAdcoY=; b=ZC2i2BZM3tKs7idYei4YmLsXS
        Dx9A8UDaUtEtNZpcW0ZGWeRJCrFpM19Fj+OuYf79BftKYuKrfqYb6lpfy3B8gssrurlrG4B9KedQh
        /5OuZOzWhDbTfhGowJ6LzasT1WOASxd0Lzuy+ayOUbRlvIY6B9XBoe52yShdZHcWR6xvU=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hg5J8-0007l6-BK; Wed, 26 Jun 2019 10:37:42 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id D62F7440046; Wed, 26 Jun 2019 11:37:41 +0100 (BST)
Date:   Wed, 26 Jun 2019 11:37:41 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgii Staroselskii <georgii.staroselskii@emlid.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH AUTOSEL 5.1 11/51] ASoC: sun4i-codec: fix first delay on
 Speaker
Message-ID: <20190626103741.GU5316@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BirP4A6vdUSxtOfB"
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-11-sashal@kernel.org>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BirP4A6vdUSxtOfB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 11:40:27PM -0400, Sasha Levin wrote:
> From: Georgii Staroselskii <georgii.staroselskii@emlid.com>
>=20
> [ Upstream commit 1f2675f6655838aaf910f911fd0abc821e3ff3df ]
>=20
> Allwinner DAC seems to have a delay in the Speaker audio routing. When
> playing a sound for the first time, the sound gets chopped. On a second
> play the sound is played correctly. After some time (~5s) the issue gets
> back.

This is inserting a big delay in the startup and might disrupt some
production system.

--BirP4A6vdUSxtOfB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0TSvUACgkQJNaLcl1U
h9As/wf/daVSAseLfvbJ6I8HSQgy9IaX84GusocgcS+2jwWorbnZB5njXn1o/A/r
c8Q9mDHj2+CqPBk6hhZu3I2mg29/C5ig/7X6zlR//OwJFlubUNHi9lJfO1QI0oSn
pIQ8APUtmvSTzpRrOw3JidtLLx+y/8Y5UCMZ79vvnAsE/GFFd6DdPE1y2bIhqkaf
WZV6aHSEA7mzRe68UQzOUYl98n8LyKAR3WoH8Nt80WvLIMshj2L0TCrKPxapi/Fx
+xKNBsYTNCopA+jlM8URwElhPviK2IfZu4PbdW5jDZOhW7TZ0jL6s1btXFR/x7bZ
i1OBbDBb6iOVPF4Z89rFA/C4DF3gdg==
=OGBu
-----END PGP SIGNATURE-----

--BirP4A6vdUSxtOfB--
