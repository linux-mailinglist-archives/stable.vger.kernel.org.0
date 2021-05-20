Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5632338AF8A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 15:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242996AbhETNEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 09:04:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45876 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243312AbhETNEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 09:04:30 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6E9E41C0B7F; Thu, 20 May 2021 15:03:07 +0200 (CEST)
Date:   Thu, 20 May 2021 15:03:07 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/190] 4.4.269-rc1 review
Message-ID: <20210520130307.GA24123@duo.ucw.cz>
References: <20210520092102.149300807@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.269 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:=20

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYKZeCwAKCRAw5/Bqldv6
8m3mAJ0eL14aqwo+MXT2zFUyr1r7hK4DSwCeP4QHaygg5uVeb6aRv/g0anSVgtM=
=2QpU
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
