Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD81278FC4
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 19:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIYRju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 13:39:50 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44308 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbgIYRjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 13:39:49 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 07BB91C0B77; Fri, 25 Sep 2020 19:39:47 +0200 (CEST)
Date:   Fri, 25 Sep 2020 19:39:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
Message-ID: <20200925173946.GB7253@duo.ucw.cz>
References: <20200925124720.972208530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.148 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not detect any problems.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

I see significant part of this is LLVM support... I'm quite surprised
to see it in -stable. Few words if LLVM is now officially supported in
4.19 or what is going on here would be welcome.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX24rYgAKCRAw5/Bqldv6
8vMBAJ9lsJYIH/SEjNar/W2gRKSnWe5V9wCdGsOaIpK3JX0C+jnwNLDOqRsidxA=
=c88Z
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
