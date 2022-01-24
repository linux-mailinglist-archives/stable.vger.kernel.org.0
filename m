Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB57499266
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354741AbiAXUT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:19:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52438 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380874AbiAXURC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:17:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 05F1A1C0B76; Mon, 24 Jan 2022 21:17:00 +0100 (CET)
Date:   Mon, 24 Jan 2022 21:16:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
Message-ID: <20220124201659.GA16782@duo.ucw.cz>
References: <20220124183927.095545464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
               =20
                                                                           =
               =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y          =20
                                                                           =
               =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
               =20
                                                                           =
               =20
Best regards,                                                              =
               =20
                                                                Pavel      =
               =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYe8JOwAKCRAw5/Bqldv6
8tTFAJ0RB9+gLMlo8UssKOnqvKVvdmiD4QCcDgLqxv/m/i0VdmP9Fu59A9zHUuA=
=0NoZ
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
