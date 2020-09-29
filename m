Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47D927CB3C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbgI2MZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:25:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55648 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732676AbgI2MZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 08:25:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 17F551C0B78; Tue, 29 Sep 2020 14:25:07 +0200 (CEST)
Date:   Tue, 29 Sep 2020 14:25:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/85] 4.4.238-rc1 review
Message-ID: <20200929122506.GA29097@duo.ucw.cz>
References: <20200929105928.198942536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.238 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.238=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.4.y
> and the diffstat can be found below.

No problems detected in CIP testing.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
95833030

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3MnogAKCRAw5/Bqldv6
8qtuAKCHMTdQ3KV14KoECE+xoK6A67/BKgCeNLQOew5PtEefDgrRQSK63sq1Avw=
=gLwe
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
