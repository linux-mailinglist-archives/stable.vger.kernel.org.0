Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F83563953
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 20:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiGASqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 14:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGASp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 14:45:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A439B33885;
        Fri,  1 Jul 2022 11:45:56 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 106431C0D81; Fri,  1 Jul 2022 20:45:54 +0200 (CEST)
Date:   Fri, 1 Jul 2022 20:45:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/29] 4.9.321-rc1 review
Message-ID: <20220701184553.GA12257@duo.ucw.cz>
References: <20220630133231.200642128@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.321 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
                                                =20
                                                                           =
                                                =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.9.y                                           =20
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

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYr9A4QAKCRAw5/Bqldv6
8meCAKCbEYQ0ZgxQNQC8FE0kZMZh6YRaTgCgmd5BqNDt3o3fpSfY0ubyoVa60ZU=
=ax6Z
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
