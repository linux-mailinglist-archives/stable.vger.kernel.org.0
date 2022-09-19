Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251415BC9BE
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 12:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiISKrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 06:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiISKqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 06:46:48 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8FF28E01;
        Mon, 19 Sep 2022 03:33:28 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 68CC81C0005; Mon, 19 Sep 2022 12:33:26 +0200 (CEST)
Date:   Mon, 19 Sep 2022 12:33:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: 5.10.144 got more patches? was Re: [PATCH 5.10 00/24] 5.10.144-rc1
 review
Message-ID: <20220919103325.GA10942@duo.ucw.cz>
References: <20220916100445.354452396@linuxfoundation.org>
 <20220916135942.GA29693@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20220916135942.GA29693@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 5.10.144 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> CIP testing did not find any problems here:
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linu=
x-5.10.y
>=20
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

And now I'm confused.

5.10.144-rc1 was announced / tested, but now there's buch more patches
in the queue, starting with

 |9843b839a 174974 .: 5.10| drm/msm/rd: Fix FIFO-full deadlock
 |518b67da4 174974 .: 4.19| drm/msm/rd: Fix FIFO-full deadlock
 |88eba3686 174974 .: 4.9| drm/msm/rd: Fix FIFO-full deadlock

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYyhFdQAKCRAw5/Bqldv6
8nPzAKCdsq6LX2UySzT7yM/BuekqwsER8gCgmiIVz/2jCT+0H1wTcxL5zvHQQ3A=
=chmi
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
