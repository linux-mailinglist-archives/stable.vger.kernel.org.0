Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DE5418495
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhIYVSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:18:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35064 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhIYVSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:18:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7BF3C1C0BFC; Sat, 25 Sep 2021 23:16:56 +0200 (CEST)
Date:   Sat, 25 Sep 2021 23:16:56 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/64] 5.10.69-rc2 review
Message-ID: <20210925211656.GA19572@duo.ucw.cz>
References: <20210925120750.056868347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20210925120750.056868347@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.69 release.
> There are 64 patches in this series, all will be posted as a response
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

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYU+RyAAKCRAw5/Bqldv6
8tdaAKCLN8Rgx45QMGmsBHh3fHjB8Tn0qQCghIhn2yo94vHFrNfRHRdaUVBvOSk=
=cMc8
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
