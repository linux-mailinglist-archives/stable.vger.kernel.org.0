Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D066261019B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiJ0T1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiJ0T1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:27:49 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836BA78239;
        Thu, 27 Oct 2022 12:27:47 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AFC081C09E0; Thu, 27 Oct 2022 21:27:44 +0200 (CEST)
Date:   Thu, 27 Oct 2022 21:27:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Message-ID: <20221027192744.GC11819@duo.ucw.cz>
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <Y1rbQqkdeliRrQPF@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2022-10-27 21:25:54, Greg Kroah-Hartman wrote:
> On Thu, Oct 27, 2022 at 11:10:18AM -0700, Guenter Roeck wrote:
> > On 10/27/22 09:55, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.151 release.
> > > There are 79 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> > > Anything received after that time might be too late.
> > >=20
> >=20
> > Building arm64:allmodconfig ... failed
> > --------------
> > Error log:
> > /bin/sh: scripts/pahole-flags.sh: Permission denied
> >=20
> > Indeed:
> >=20
> > $ ls -l scripts/pahole-flags.sh
> > -rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh
> >=20
> > Compared to upstream:
> >=20
> > -rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh
>=20
> Yeah, this is going to be an odd one.  I have to do this by hand as
> quilt and git quilt-import doesn't like setting the mode bit.
>=20
> I wonder if I should just make a single-commit release with this file in
> it, set to the proper permission, to get past this hurdle.  I'll think
> about it in the morning...

Alternatively you can modify the caller to do /bin/sh /scripts/... so
it does not need a +x bit...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1rbsAAKCRAw5/Bqldv6
8j+YAJ9a4BEX10NyqTP/T8FIS9rRBaq2egCdEJkKzVlbQ4jVzPaa5B/kcn8n3Ps=
=br6g
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
