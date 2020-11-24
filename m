Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7B42C3173
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgKXTxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:53:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57376 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbgKXTxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 14:53:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C66EE1C0B7D; Tue, 24 Nov 2020 20:53:01 +0100 (CET)
Date:   Tue, 24 Nov 2020 20:53:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/38] 4.4.246-rc1 review
Message-ID: <20201124195301.GA6517@amd>
References: <20201123121804.306030358@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-11-23 13:21:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.246 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.

And anything before may be too late, too. Why publish date when you
release day too early, anyway? It is misleading.

Fortunately CIP testing did not find any problems.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+9ZJ0ACgkQMOfwapXb+vJIrgCeKCZC1m9LF+iN633V2BHH1765
lFYAoKnc1TPhCV0XMudyl+TaZ9sw4CtD
=VNIZ
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
