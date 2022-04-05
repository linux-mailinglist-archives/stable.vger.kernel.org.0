Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A814F5439
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347464AbiDFEpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454586AbiDEWjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 18:39:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69EE7284;
        Tue,  5 Apr 2022 14:29:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 375C41C0B7F; Tue,  5 Apr 2022 23:28:53 +0200 (CEST)
Date:   Tue, 5 Apr 2022 23:28:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Michael Walle <michael@walle.cc>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.16 0018/1017] Revert "gpio: Revert regression in
 sysfs-gpio (gpiolib.c)"
Message-ID: <20220405212852.GA5493@amd>
References: <20220405070354.155796697@linuxfoundation.org>
 <20220405070354.714970989@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20220405070354.714970989@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 56e337f2cf1326323844927a04e9dbce9a244835 ]
>=20
> This reverts commit fc328a7d1fcce263db0b046917a66f3aa6e68719.
>=20
> This commit - while attempting to fix a regression - has caused a number
> of other problems. As the fallout from it is more significant than the
> initial problem itself, revert it for now before we find a correct
> solution.

The patch this reverts is queued as 15/ in the series. Rather than
applying broken patch and then reverting, it would be better to drop
both, right?

(I found during 5.10 review, but I can't find 5.10 mail to reply to).

Best regards,
									Pavel
--
 'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194    Groebenzell, Germany'

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJMtJQACgkQMOfwapXb+vIn/QCdF/xJKh1/1IlXB8xV91+/KO6m
ZX4AoJsYvaBdW+KAqF7tCNoP3SC+gISG
=toLM
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
