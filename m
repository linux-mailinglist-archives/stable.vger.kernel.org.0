Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE874D5111
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 19:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiCJSBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245267AbiCJSBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:01:07 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124D1965F6;
        Thu, 10 Mar 2022 10:00:06 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 600551C0B7F; Thu, 10 Mar 2022 19:00:05 +0100 (CET)
Date:   Thu, 10 Mar 2022 19:00:04 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/33] 4.19.234-rc2 review
Message-ID: <20220310180004.GB15877@duo.ucw.cz>
References: <20220310140807.749164737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.234 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

                                                                           =
             =20
CIP testing did not find any problems here:                                =
             =20
                                                                           =
             =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y       =20
                                                                           =
             =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
             =20

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYio8pAAKCRAw5/Bqldv6
8gB/AJsH5ZkFQlHLC+wS6P5fWhFg7Eg6UACfVT1edukdkKi8S+aGy2sn9TRJNy8=
=zlqB
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
