Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA1066850E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240911AbjALVHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbjALVGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:06:54 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B5B5B161;
        Thu, 12 Jan 2023 12:51:51 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B8F521C0AB3; Thu, 12 Jan 2023 21:51:48 +0100 (CET)
Date:   Thu, 12 Jan 2023 21:51:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Message-ID: <Y8By5OZP8XGBolXB@duo.ucw.cz>
References: <20230112135524.143670746@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XG7gSYJU8siWq5o/"
Content-Disposition: inline
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XG7gSYJU8siWq5o/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XG7gSYJU8siWq5o/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8By5AAKCRAw5/Bqldv6
8qt6AKCiRmHpI7CIQDd2dfkjtQR7CdISAQCfQ3KW7IVjo3bUATFdXkvWMIpiVI8=
=t5RQ
-----END PGP SIGNATURE-----

--XG7gSYJU8siWq5o/--
