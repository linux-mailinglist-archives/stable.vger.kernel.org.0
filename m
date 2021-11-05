Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153A54463EE
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhKENSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:18:17 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45968 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhKENSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 09:18:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2DEC21C0BAC; Fri,  5 Nov 2021 14:15:35 +0100 (CET)
Date:   Fri, 5 Nov 2021 14:15:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
Message-ID: <20211105131533.GA31100@duo.ucw.cz>
References: <20211104170112.899181800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYYUudQAKCRAw5/Bqldv6
8vgWAJ4yI993CdSobakymkqDIpj6Nu3ovQCbBZWIEP/Cficxqs2wVXXp9n+nGHo=
=GtyV
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
