Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3979D4B4F0A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352847AbiBNLn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:43:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352874AbiBNLnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:43:15 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAF36C94D;
        Mon, 14 Feb 2022 03:35:02 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E9BC51C0B96; Mon, 14 Feb 2022 12:35:00 +0100 (CET)
Date:   Mon, 14 Feb 2022 12:35:00 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
Message-ID: <20220214113500.GB7989@duo.ucw.cz>
References: <20220214092448.285381753@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
                                   =20
                                                                           =
                                   =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y                             =20
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

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgo+ZAAKCRAw5/Bqldv6
8vEKAKCh+RhH4mqzHpY95271rD9janOSygCcDfRdFsvBcmJTK9eB9ww6Am/hgb4=
=lOYL
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
