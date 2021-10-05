Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61181422FD5
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhJESWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 14:22:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38040 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJESWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 14:22:45 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B92211C0B80; Tue,  5 Oct 2021 20:20:53 +0200 (CEST)
Date:   Tue, 5 Oct 2021 20:20:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc2 review
Message-ID: <20211005182053.GB21785@duo.ucw.cz>
References: <20211005083300.523409586@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <20211005083300.523409586@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYVyXhQAKCRAw5/Bqldv6
8nvNAJ9xGDCNrf6TX2cLC57BQy5mSlf/nwCdHA+OBmNUEduFyzZjWeqGqg27P+U=
=s3NU
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
