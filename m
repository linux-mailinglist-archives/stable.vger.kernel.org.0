Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBA515B20
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 09:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiD3H7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 03:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiD3H7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 03:59:34 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8B38E1A1;
        Sat, 30 Apr 2022 00:56:12 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7056A1C0B82; Sat, 30 Apr 2022 09:56:09 +0200 (CEST)
Date:   Sat, 30 Apr 2022 09:56:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, iwamatsu@nigauri.org,
        dinguyen@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/53] 4.19.240-rc1 review [net: ethernet: stmmac:
 fix altr_tse_pcs function when using a]
Message-ID: <20220430075605.GA13110@amd>
References: <20220426081735.651926456@linuxfoundation.org>
 <20220426200000.GB9427@duo.ucw.cz>
 <YmkrZ5t2cb1JSHR8@kroah.com>
 <20220429074341.GB1423@amd>
 <YmuuTb7Cv/JExahQ@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <YmuuTb7Cv/JExahQ@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Can you run git bisect?
> >=20
> > Not a bisect, but we guessed e2423aa174e6 was responsible, and tested
> > it boots with that patch reverted.
> >=20
> > commit e2423aa174e6c3e9805e96db778245ba73cdd88c
> >=20
> >     net: ethernet: stmmac: fix altr_tse_pcs function when using a
> >     fixed-link
> >=20
> >     [ Upstream commit a6aaa00324240967272b451bfa772547bd576ee6 ]
> >    =20
>=20
> Thanks, now reverted from 4.19.y, 4.14.y, and 4.9.y

Thank you!

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJs65QACgkQMOfwapXb+vIZ7QCfRO2U4ed9cCrh6jzxugQeDPj3
WGcAoLG26DAESv7iYvtlszrb3VM+N1gc
=e0CJ
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
