Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292442161B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 20:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhJDSKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 14:10:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45550 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhJDSKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 14:10:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A9BB61C0B76; Mon,  4 Oct 2021 20:08:45 +0200 (CEST)
Date:   Mon, 4 Oct 2021 20:08:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc1 review
Message-ID: <20211004180845.GE14089@duo.ucw.cz>
References: <20211004125044.945314266@linuxfoundation.org>
 <20211004180651.GC14089@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <20211004180651.GC14089@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-10-04 20:06:51, Pavel Machek wrote:
> Hi!
>=20
> > This is the start of the stable review cycle for the 5.14.10 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> CIP testing did not find any problems here:
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linu=
x-5.10.y

Sorry, I replied to wrong email. We are not actually testing 5.14.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYVtDLQAKCRAw5/Bqldv6
8qchAKCfwnXBCNUEfjsNH0aK2z1PsL9bCACfR9c2dNYNJ/LkgccM6A2O5U7CAQc=
=Ao+Z
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
