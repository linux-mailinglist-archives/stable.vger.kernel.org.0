Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62166A768F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCAWDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCAWDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:03:52 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816AC1F93B;
        Wed,  1 Mar 2023 14:03:50 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D5F9A1C0AB3; Wed,  1 Mar 2023 23:03:47 +0100 (CET)
Date:   Wed, 1 Mar 2023 23:03:47 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kuniyu@amazon.com
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <Y//Lw/zL168J3spQ@duo.ucw.cz>
References: <20230301180652.316428563@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SfylrsavIRoFCp2I"
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SfylrsavIRoFCp2I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

AFAICT we should not need this patch -- we don't have b5fc29233d28 in
5.10, so the assertion seems to be at the correct place here.

> Kuniyuki Iwashima <kuniyu@amazon.com>
>     net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
>     sk_stream_kill_queues().

CIP testing did not find any problems here:                                =
                            =20
                                                                           =
                            =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y                      =20
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

--SfylrsavIRoFCp2I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY//LwwAKCRAw5/Bqldv6
8izUAKCmo3ncVN67b/E4QaSFAkxgocnrxACeIInLTZTnIlvCkx6jzMhB742Rp8w=
=wHWb
-----END PGP SIGNATURE-----

--SfylrsavIRoFCp2I--
