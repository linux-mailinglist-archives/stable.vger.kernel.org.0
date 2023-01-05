Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FCB65F49A
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbjAETgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbjAETgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:36:04 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA711AA2B;
        Thu,  5 Jan 2023 11:34:10 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id ECB241C09F4; Thu,  5 Jan 2023 20:34:08 +0100 (CET)
Date:   Thu, 5 Jan 2023 20:34:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7cmMKUr//oYKWXb@duo.ucw.cz>
References: <20230104160511.905925875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DAyEOyzRmfg8uvlt"
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DAyEOyzRmfg8uvlt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Thank you.

Is it known at this point if 6.1 will became next longterm release? It
is not listed as such on https://www.kernel.org/category/releases.html
=2E We might want to do some extra testing if it is.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DAyEOyzRmfg8uvlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY7cmMAAKCRAw5/Bqldv6
8pqJAJ4/YfINv5Euqccv0dO35v2LvEq/tQCdEWqYh718akCnEq2hGbjbdK9w/nU=
=Sj9A
-----END PGP SIGNATURE-----

--DAyEOyzRmfg8uvlt--
