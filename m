Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3304BE9F1
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiBURpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 12:45:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiBURol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 12:44:41 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA69C113D;
        Mon, 21 Feb 2022 09:44:16 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CE0741C0B78; Mon, 21 Feb 2022 18:44:14 +0100 (CET)
Date:   Mon, 21 Feb 2022 18:44:14 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
Message-ID: <20220221174414.GA23447@duo.ucw.cz>
References: <20220221084911.895146879@linuxfoundation.org>
 <20220221122340.GA15152@duo.ucw.cz>
 <YhOeqJ0XLjYVuBCe@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <YhOeqJ0XLjYVuBCe@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.19.231 release.
> > > There are 58 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
=2Egit linux-4.19.y
> > > and the diffstat can be found below.
> >=20
> > Do you think you could quote git hash of the respective commit here?
>=20
> No, as that tree is a "throw away" one which I delete instantly on my
> side once I create it and push it out.  I am only creating it so that
> people who use git for their CI can have an easy way to test it.

You deleting the tree should not be a problem, no?

> Once I do a -rc announcement, the branch here should always work, if
> not, please report it.

So I want to make sure we are testing the right kernel. It would be
good to mention the hash of the release, so that I can double-check
against our CI system that we are testing right commit.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYhPPbgAKCRAw5/Bqldv6
8rVhAJ9JBg5LIjwDRHA8bCspjb6ui/kf4ACgkbECSSF0YaOt8I+Tpm3PeZkUAPg=
=yaQe
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
