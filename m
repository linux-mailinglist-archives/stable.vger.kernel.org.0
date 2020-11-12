Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A982B0EB2
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 21:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKLUBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 15:01:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60822 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKLUBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 15:01:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 87B071C0B88; Thu, 12 Nov 2020 21:01:41 +0100 (CET)
Date:   Thu, 12 Nov 2020 21:01:41 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 105/191] memory: emif: Remove bogus debugfs error
 handling
Message-ID: <20201112200140.GA11931@amd>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.447026264@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20201103203243.447026264@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> [ Upstream commit fd22781648080cc400772b3c68aa6b059d2d5420 ]
>=20
> Callers are generally not supposed to check the return values from
> debugfs functions.  Debugfs functions never return NULL so this error
> handling will never trigger.  (Historically debugfs functions used to
> return a mix of NULL and error pointers but it was eventually deemed too
> complicated for something which wasn't intended to be used in normal
> situations).
>=20
> Delete all the error handling.

This is wrong for 4.19.

Memory functions still return NULL here.

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+tlKQACgkQMOfwapXb+vIpDACfYo1UXXvIT9J3cjFrdudnJvGR
ZsQAn0eVMVM7ji2qEwfcLfw8nm2R+dnY
=QpKI
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
