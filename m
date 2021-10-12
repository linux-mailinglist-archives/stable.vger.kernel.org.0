Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE5A42A686
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhJLN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 09:58:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56644 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbhJLN6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 09:58:11 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7C3FF1C0B9D; Tue, 12 Oct 2021 15:56:08 +0200 (CEST)
Date:   Tue, 12 Oct 2021 15:56:08 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/81] 5.10.73-rc3 review
Message-ID: <20211012135608.GA23821@duo.ucw.cz>
References: <20211012093348.134236881@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20211012093348.134236881@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.73 release.
> There are 81 patches in this series, all will be posted as a response
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

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYWWT+AAKCRAw5/Bqldv6
8lhWAKCzsEpW8m2BpUtt/n8wxJTcc8WdcgCgpIjiq6xZNcd0KUbJO5C//ub+7q4=
=mBP7
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
