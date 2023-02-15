Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FA769816A
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 17:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBOQ4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 11:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBOQ4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 11:56:43 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC2223C71;
        Wed, 15 Feb 2023 08:56:41 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EF7151C0AAC; Wed, 15 Feb 2023 17:56:38 +0100 (CET)
Date:   Wed, 15 Feb 2023 17:56:38 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <Y+0Oxi3j+ix0QSMC@duo.ucw.cz>
References: <20230214172549.450713187@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TgFN2bL5klN5LmOv"
Content-Disposition: inline
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TgFN2bL5klN5LmOv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Revision tested was f90240a238a9. I can't find 5.10.168-rc2 anywhere
to verify it matches. Please mention sha hash in the release
announcement.

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TgFN2bL5klN5LmOv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY+0OxgAKCRAw5/Bqldv6
8oXzAKC7urD1JIJhDYbpwEKEuovcDc+1zACfXFSbtK4Cd3SpJLVZBEWlPWeQSkU=
=cVzQ
-----END PGP SIGNATURE-----

--TgFN2bL5klN5LmOv--
