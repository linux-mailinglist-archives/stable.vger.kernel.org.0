Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A271677A2D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjAWLbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjAWLbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:31:36 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8611117B;
        Mon, 23 Jan 2023 03:31:34 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E40F01C09F4; Mon, 23 Jan 2023 12:31:31 +0100 (CET)
Date:   Mon, 23 Jan 2023 12:31:31 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85wE2OBrVvwUlLp@duo.ucw.cz>
References: <20230122150229.351631432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EO3ICQiYStspkriT"
Content-Disposition: inline
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EO3ICQiYStspkriT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hmm. Interesting.

We tested

commit 9096aabfe9e099a5af5d13bb0fb36e98bb623398
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon Jan 23 10:49:12 2023 +0100

    Linux 5.10.165-rc2

and found no problems there, but that is -rc2 and you announced -rc1.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EO3ICQiYStspkriT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY85wEwAKCRAw5/Bqldv6
8mELAKC6XYVXnYoGaUEg3jUIDWP0zLMmfQCgnddfsEF0EEw3PXbjyldM7S6vsb0=
=WREq
-----END PGP SIGNATURE-----

--EO3ICQiYStspkriT--
