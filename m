Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C353C3B21
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 10:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhGKIDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 04:03:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59308 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhGKIDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 04:03:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C1E231C0B77; Sun, 11 Jul 2021 10:00:13 +0200 (CEST)
Date:   Sun, 11 Jul 2021 10:00:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/6] 5.10.49-rc1 review
Message-ID: <20210711080013.GB14434@duo.ucw.cz>
References: <20210709131537.035851348@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
             =20
                                                                           =
             =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y       =20
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

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYOqlDQAKCRAw5/Bqldv6
8tkDAJ9GxrFLhQoG732lY0sYxo1S/8wOSgCfdwipjDgAGbxgmXXxV56tqbnoikw=
=h3sF
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
