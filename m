Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A364248EA84
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 14:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiANNWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 08:22:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34764 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiANNWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 08:22:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CE4141C0B76; Fri, 14 Jan 2022 14:22:19 +0100 (CET)
Date:   Fri, 14 Jan 2022 14:22:19 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/25] 5.10.92-rc1 review
Message-ID: <20220114132219.GA26600@duo.ucw.cz>
References: <20220114081542.698002137@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.92 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.

CIP testing did not find any new kernel problems here (gcc 8 gmp.h
problem remains):

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYeF5CwAKCRAw5/Bqldv6
8kFqAJ9nwgTJkxTfs5Huz8EVtn7NFMdY6wCff+GpKsNaNIEi3J3Tlb/vKB8czxU=
=IiSg
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
