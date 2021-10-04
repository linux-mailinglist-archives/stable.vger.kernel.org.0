Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C9142160C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 20:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhJDSIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 14:08:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45340 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbhJDSIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 14:08:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C16131C0B76; Mon,  4 Oct 2021 20:06:33 +0200 (CEST)
Date:   Mon, 4 Oct 2021 20:06:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.286-rc1 review
Message-ID: <20211004180633.GB14089@duo.ucw.cz>
References: <20211004125026.597501645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.286 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

(Note that our testing on 4.4 is single target where 4.19 has wider
set, so it is impossible to tell if it 4.4 has same problem as 4.19
based on our testing).

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYVtCqQAKCRAw5/Bqldv6
8qswAJ9WAYqMgzhxt8VJg+P7tZ7a1hrALgCZAUtFYuwUyTdtu+xYmDyUAT3iK2Y=
=HOwQ
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
