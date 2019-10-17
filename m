Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05D6DA7E6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 10:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408397AbfJQI7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 04:59:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39075 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404051AbfJQI7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 04:59:14 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id F3C74801AB; Thu, 17 Oct 2019 10:58:56 +0200 (CEST)
Date:   Thu, 17 Oct 2019 10:59:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Erik Schmauss <erik.schmauss@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Garry <john.garry@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 68/81] ACPICA: ACPI 6.3: PPTT add additional fields
 in Processor Structure Flags
Message-ID: <20191017085912.GA8594@amd>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214846.058277835@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20191016214846.058277835@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Erik Schmauss <erik.schmauss@intel.com>
>=20
> Commit b5eab512e7cffb2bb37c4b342b5594e9e75fd486 upstream.

So this introduces another format of "upstream" information. So far I
had this:

		ma =3D re.match(".*Upstream commit ([0-9a-f]*) .*", l)
		...
                ma =3D re.match("commit ([0-9a-f]*) upstream[.]*", l)

I believe this information belongs to the signoff area; it is
important to know who pushed patch to the upstream and who is pusing
it to the stable.

Could we just introduce "Upstream: <sha1>" tag and use it? It would
improve consistency...

Thanks,
								Pavel

> ACPICA commit c736ea34add19a3a07e0e398711847cd6b95affd
>=20
> Link: https://github.com/acpica/acpica/commit/c736ea34
> Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXagtYAAKCRAw5/Bqldv6
8iapAJ9+si17KDqJWrhQuFxEQ3CZZwcKGACgtPXzOyI93EkwZTPM2IPYFHLu8uQ=
=+NSr
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
