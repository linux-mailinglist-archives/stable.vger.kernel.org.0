Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741F2902DA
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 12:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395349AbgJPKfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 06:35:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50058 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395348AbgJPKfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 06:35:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0252B1C0B7D; Fri, 16 Oct 2020 12:34:56 +0200 (CEST)
Date:   Fri, 16 Oct 2020 12:34:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/16] 4.4.240-rc1 review
Message-ID: <20201016103455.GB11338@amd>
References: <20201016090435.423923738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.240 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems revealed by CIP testing.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+Jd08ACgkQMOfwapXb+vKXmgCgwt1ufLCrNGM0kw93/7EIlFMF
B4EAoJLnnuLwuZG4Nceu2fA70F2rj1pN
=Juwu
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
