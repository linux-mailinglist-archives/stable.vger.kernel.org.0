Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A883FB66A
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbhH3MuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:50:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47308 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236743AbhH3MuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:50:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE6181C0B76; Mon, 30 Aug 2021 14:49:27 +0200 (CEST)
Date:   Mon, 30 Aug 2021 14:49:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.13 02/12] ASoC: component: Remove misplaced
 prefix handling in pin control functions
Message-ID: <20210830124924.GA22096@duo.ucw.cz>
References: <20210817003536.83063-1-sashal@kernel.org>
 <20210817003536.83063-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20210817003536.83063-2-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> When the component level pin control functions were added they for some
> no longer obvious reason handled adding prefixing of widget names. This
> meant that when the lack of prefix handling in the DAPM level pin
> operations was fixed by ae4fc532244b3bb4d (ASoC: dapm: use component
> prefix when checking widget names) the one device using the component
> level API ended up with the prefix being applied twice, causing all
> lookups to fail.

AFAICT ae4fc532244b3bb4d (ASoC: dapm: use component...) is not in
5.10-stable, so this one should not go into 5.10-stable, either?

(Or alternatively, both can go in).

I hope I understand it right.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSzT1wAKCRAw5/Bqldv6
8tYvAJ9Mqv1udqvt/eQ59aUzDFbILly8+ACgqgjWJPcLX9pQWvIxE2q6Eo9VWX8=
=xi1K
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
