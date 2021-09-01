Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C943FE385
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhIAUH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:07:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45190 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbhIAUH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:07:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 02D3B1C0BA1; Wed,  1 Sep 2021 22:07:00 +0200 (CEST)
Date:   Wed, 1 Sep 2021 22:06:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/10] 4.4.283-rc1 review
Message-ID: <20210901200659.GB7067@duo.ucw.cz>
References: <20210901122248.051808371@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> This is the start of the stable review cycle for the 4.4.283 release.
> There are 10 patches in this series, all will be posted as a response
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

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYS/dYwAKCRAw5/Bqldv6
8q6BAJ9Y6FWeyFL7L5IvFsZemmcDxw3djwCfVCSHUTvhpjf4pJRvGvKCcL3CqTA=
=Nm9v
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
