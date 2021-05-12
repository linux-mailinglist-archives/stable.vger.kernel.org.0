Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03F037EEB1
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348207AbhELWFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:05:05 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391745AbhELVbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:31:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 466111C0B80; Wed, 12 May 2021 23:30:14 +0200 (CEST)
Date:   Wed, 12 May 2021 23:30:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
Message-ID: <20210512213013.GB30312@duo.ucw.cz>
References: <20210512144819.664462530@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
                                                                           =
                    =20
CIP testing did not find any problems here:                                =
                    =20
                                                                           =
                    =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y               =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y              =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y              =20
                                                                           =
                    =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
                    =20
                                                                           =
                    =20
Best regards,                                                              =
                    =20
                                                                Pavel      =
                    =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJxI5QAKCRAw5/Bqldv6
8plKAKC0qKvkGUqvrGfcKg1FIqe7dcLergCeKlYNmX16uhWgwldCgpMpwhiT1Bw=
=i/v7
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
