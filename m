Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809C63CEF9C
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349700AbhGSWS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:18:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50070 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387356AbhGSUGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 16:06:06 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 56ACD1C0B77; Mon, 19 Jul 2021 22:46:39 +0200 (CEST)
Date:   Mon, 19 Jul 2021 22:46:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
Message-ID: <20210719204638.GB23727@duo.ucw.cz>
References: <20210719184335.198051502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPXkrgAKCRAw5/Bqldv6
8vlaAJ0XScML3aQjtZ0F5a/pSY1O6rUvbACfayWf7t0g/D/vIidUXn9gFP0Am7E=
=Urqu
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
