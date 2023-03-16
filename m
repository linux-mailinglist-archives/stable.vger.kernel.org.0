Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C721A6BCA37
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 10:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCPJAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 05:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjCPJA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 05:00:29 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EB323DA0;
        Thu, 16 Mar 2023 02:00:28 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 673E21C0E47; Thu, 16 Mar 2023 10:00:27 +0100 (CET)
Date:   Thu, 16 Mar 2023 10:00:26 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        dmitry.baryshkov@linaro.org, paul.elder@ideasonboard.com
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <ZBLaqsSWyRD+N4M9@duo.ucw.cz>
References: <20230316083335.429724157@linuxfoundation.org>
 <ZBLaULVciUIN+b4P@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ad2fZTWVXQoaz3mZ"
Content-Disposition: inline
In-Reply-To: <ZBLaULVciUIN+b4P@duo.ucw.cz>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ad2fZTWVXQoaz3mZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(added patch authors to cc)

> > This is the start of the stable review cycle for the 4.14.310 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> > Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >     clk: qcom: mmcc-apq8084: remove spdm clocks
>=20
> This looks like a cleanup, we should not need it in stable.
>=20
> > Paul Elder <paul.elder@ideasonboard.com>
> >     media: ov5640: Fix analogue gain control
>=20
> This is an API tweak, not a bugfix. This will have negative impact on
> users upgrading from 4.14.309 and 4.14.310, because you can be pretty
> sure someone out there uses the "old" interface in their
> application. I'm probably responsible for that sin in millipixels
> fork.
>=20
> Best regards,
> 								Pavel
> 							=09



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Ad2fZTWVXQoaz3mZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBLaqgAKCRAw5/Bqldv6
8srnAKCF5pYgOY4bmm6Vn2/E5cWyHLWJkACgww5o9jwjCZGfNQ4sM5YOSzcdsSw=
=pfCg
-----END PGP SIGNATURE-----

--Ad2fZTWVXQoaz3mZ--
