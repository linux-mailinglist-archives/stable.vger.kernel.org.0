Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D93A635C13
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 12:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiKWLrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 06:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKWLrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 06:47:23 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D8511091F;
        Wed, 23 Nov 2022 03:47:22 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4F5401C09DB; Wed, 23 Nov 2022 12:47:21 +0100 (CET)
Date:   Wed, 23 Nov 2022 12:47:20 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/76] 4.9.334-rc1 review
Message-ID: <Y34ISJA4/YGREd/4@duo.ucw.cz>
References: <20221123084546.742331901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BtFXNc2ONGWFLTj3"
Content-Disposition: inline
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BtFXNc2ONGWFLTj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.334 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Nathan Huckleberry <nhuck@google.com>
>     drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

This is just a kCFI annotation, we don't really need them in stable.

> Alexandre Belloni <alexandre.belloni@bootlin.com>
>     rtc: cmos: fix build on non-ACPI platforms

I believe maintainersaid we don't need this in stable. Should I google
for exact mail?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--BtFXNc2ONGWFLTj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY34ISAAKCRAw5/Bqldv6
8qLSAKCjwrr9fgSafQdFixlYfNeVyxeKkgCfUFkFsreiSW/nkw+OeOnX0IpD7j8=
=hiAh
-----END PGP SIGNATURE-----

--BtFXNc2ONGWFLTj3--
