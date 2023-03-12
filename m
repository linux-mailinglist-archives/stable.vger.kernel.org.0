Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC7E6B6AC4
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 20:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCLTp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 15:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCLTp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 15:45:27 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C2025949;
        Sun, 12 Mar 2023 12:45:25 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 82C0D1C0AAC; Sun, 12 Mar 2023 20:45:24 +0100 (CET)
Date:   Sun, 12 Mar 2023 20:45:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/528] 5.10.173-rc2 review
Message-ID: <ZA4r03fWsS3KOQ5O@duo.ucw.cz>
References: <20230311091908.975813595@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qe/Jjd6815Vh63SM"
Content-Disposition: inline
In-Reply-To: <20230311091908.975813595@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qe/Jjd6815Vh63SM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.173 release.
> There are 528 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

(We tested Linux 5.10.173 (e5f315b55f8e) and 6.1, 4.19 and 4.14 seem
ok, too).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qe/Jjd6815Vh63SM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZA4r0wAKCRAw5/Bqldv6
8iTNAKC7+b+W5w6QYC+TEzNeGZ1QJ0t0DACbB7Q3h2YJWvSVKeRTXupGsyjAl6A=
=5/u7
-----END PGP SIGNATURE-----

--qe/Jjd6815Vh63SM--
