Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477AD417D3B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 23:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhIXVvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 17:51:16 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53270 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbhIXVvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 17:51:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D03711C0BB8; Fri, 24 Sep 2021 23:49:41 +0200 (CEST)
Date:   Fri, 24 Sep 2021 23:49:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
Message-ID: <20210924214941.GA10819@duo.ucw.cz>
References: <20210924124334.228235870@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.69 release.
> There are 63 patches in this series, all will be posted as a response
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

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYU5H9QAKCRAw5/Bqldv6
8j8DAKCD7DjJ/SskkTeDlsxoqspAcVFmZACgjrxSZTkqoqxqaoOE2MOGhc1oJ70=
=QG8o
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
