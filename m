Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5779911F0FE
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 09:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfLNImd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 03:42:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfLNImd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 03:42:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE9751C25E0; Sat, 14 Dec 2019 09:42:31 +0100 (CET)
Date:   Sat, 14 Dec 2019 09:42:31 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>,
        Dan Murphy <dmurphy@ti.com>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 032/134] leds: lm3692x: Handle failure to
 probe the regulator
Message-ID: <20191214084231.GB16834@duo.ucw.cz>
References: <20191211151150.19073-1-sashal@kernel.org>
 <20191211151150.19073-32-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20191211151150.19073-32-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-12-11 10:10:08, Sasha Levin wrote:
> From: Guido G=FCnther <agx@sigxcpu.org>
>=20
> [ Upstream commit 396128d2ffcba6e1954cfdc9a89293ff79cbfd7c ]
>=20
> Instead use devm_regulator_get_optional since the regulator
> is optional and check for errors.

Support for new hardware, more than serious bug.

Please drop. Also please drop leds from your monitoring scripts, it
just adds unneccessary workload for everyone. If we see something
_really_ critical, we'll cc: stable.

Actually, I believe your monitoring scripts are doing more harm than
good, and it would be better to get positive confirmation from
contributors before pushing random changes into stable.

Thanks,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfSgdwAKCRAw5/Bqldv6
8uDFAJ43gejqrzrV5T59rKpKY1/Xqq7BlACcCQE23IP7BVW2RU7jQASKzaD1YRc=
=ezrN
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
