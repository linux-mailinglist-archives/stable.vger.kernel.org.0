Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB8A46A5C9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 20:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346847AbhLFTlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 14:41:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42714 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242432AbhLFTlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 14:41:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0870E1C0B9C; Mon,  6 Dec 2021 20:38:14 +0100 (CET)
Date:   Mon, 6 Dec 2021 20:38:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
Message-ID: <20211206193811.GB11359@duo.ucw.cz>
References: <20211206145548.859182340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.220 release.
> There are 48 patches in this series, all will be posted as a response
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

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYa5mowAKCRAw5/Bqldv6
8pixAJ9ah2lsqMbfkkslaRREXEtZmPivmQCeIEupVMxSR5dCQK5FIjGDQlfpq1g=
=KGPT
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
