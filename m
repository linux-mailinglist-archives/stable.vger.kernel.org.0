Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BB141A0E9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 22:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhI0VBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:01:04 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34748 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbhI0VBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:01:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DA8261C0B7F; Mon, 27 Sep 2021 22:59:24 +0200 (CEST)
Date:   Mon, 27 Sep 2021 22:59:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.70-rc1 review
Message-ID: <20210927205924.GA19700@duo.ucw.cz>
References: <20210927170225.702078779@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hu!

> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
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

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYVIwrAAKCRAw5/Bqldv6
8tAtAKCztxnKLqCQ2TaEk+CeA9lSvdveAQCgq6XDgeSAv5ZnT41JL5gO1NbhiVY=
=aQ5G
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
