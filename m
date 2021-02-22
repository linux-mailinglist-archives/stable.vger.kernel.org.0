Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B91321F39
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhBVSiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:38:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:41628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhBVSiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:38:12 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B67531C0B7F; Mon, 22 Feb 2021 19:37:11 +0100 (CET)
Date:   Mon, 22 Feb 2021 19:37:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/35] 4.4.258-rc1 review
Message-ID: <20210222183711.GA29892@duo.ucw.cz>
References: <20210222121013.581198717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.258 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDP51wAKCRAw5/Bqldv6
8rxpAJ9BlH81J4hdE7Y0tF1gMXGP5xsReACfX8evjL+aq2r3gcnhXPEmFLELdEg=
=vTpq
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
