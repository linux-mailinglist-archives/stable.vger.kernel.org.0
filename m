Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F42C3176
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgKXTxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:53:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57452 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgKXTxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 14:53:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 568581C0B7D; Tue, 24 Nov 2020 20:53:48 +0100 (CET)
Date:   Tue, 24 Nov 2020 20:53:47 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.160-rc1 review
Message-ID: <20201124195347.GB6517@amd>
References: <20201123121809.285416732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.160 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+9ZMsACgkQMOfwapXb+vLV+ACfRhxwq5Zbz/ueuYKJUusRji/O
JmUAnAtkvNfOOixxGerIPndIoIy1lkex
=Z8p9
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
