Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714854B4EF9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352959AbiBNLma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352936AbiBNLmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:42:24 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D146C1E8;
        Mon, 14 Feb 2022 03:34:44 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7F9D61C0B79; Mon, 14 Feb 2022 12:34:41 +0100 (CET)
Date:   Mon, 14 Feb 2022 12:34:41 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
Message-ID: <20220214113441.GA7989@duo.ucw.cz>
References: <20220214092458.668376521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any new kernel problems here (but we still        =
                                   =20
hit the gmp.h compilation issue):                                          =
                                   =20
                                                                           =
                                   =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y                             =20
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

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgo+UQAKCRAw5/Bqldv6
8lQgAKCskI4xApRKkVuZ/LUqQ/AkaZDGZACcD0HohcrGr/MhXfCgbOoc8OuMOds=
=qAJf
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
