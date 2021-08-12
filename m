Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854B93EAAD3
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 21:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHLTUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 15:20:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33664 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhHLTUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 15:20:53 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DF1A11C0B76; Thu, 12 Aug 2021 21:20:26 +0200 (CEST)
Date:   Thu, 12 Aug 2021 21:20:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/54] 4.19.203-rc1 review
Message-ID: <20210812192026.GA20325@duo.ucw.cz>
References: <20210810172944.179901509@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.203 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (but we have some
problems with testing infrastructure).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

I noticed that 4.4.281-rc1 was tagged, and our bots are working on it,
too, but I don't see corresponding announcement.
                                                                           =
                  =20
Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRV0egAKCRAw5/Bqldv6
8iq9AJ4og67f+NYXJup/qtkMNLrNevb74ACfWGnsjS+NoPNEBbT4g8PRS94VMoI=
=x+M7
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
