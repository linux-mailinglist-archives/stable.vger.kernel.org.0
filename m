Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE666632C8D
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 20:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiKUTCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 14:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiKUTCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 14:02:42 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F172AD7;
        Mon, 21 Nov 2022 11:02:39 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F3A4B1C09DB; Mon, 21 Nov 2022 20:02:36 +0100 (CET)
Date:   Mon, 21 Nov 2022 20:02:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
Message-ID: <Y3vLTFCZzsl5/bkr@duo.ucw.cz>
References: <20221121124150.886779344@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cmoRar13e3jH32gZ"
Content-Disposition: inline
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cmoRar13e3jH32gZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
                      =20
                                                                           =
                      =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y                =20
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

--cmoRar13e3jH32gZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3vLTAAKCRAw5/Bqldv6
8jEeAJ4yLekh7lTJW3IJZCSX00FIofF0RgCfVggNVsadTCCJQfGYMFNW/k3URr8=
=nvlH
-----END PGP SIGNATURE-----

--cmoRar13e3jH32gZ--
