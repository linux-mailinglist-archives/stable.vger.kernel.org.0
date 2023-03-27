Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD696CA1B4
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjC0Kvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 06:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjC0Kvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 06:51:52 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C5640C0;
        Mon, 27 Mar 2023 03:51:50 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 447721C0AC1; Mon, 27 Mar 2023 12:51:48 +0200 (CEST)
Date:   Mon, 27 Mar 2023 12:51:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Luna Jernberg <droidbittin@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <ZCF1Q9DYDfhE3yA0@duo.ucw.cz>
References: <20230307170022.094103862@linuxfoundation.org>
 <CADo9pHh614h0vBkb5cKJvD6wCOXSkKwoCpYeQN9be4LFcArJ3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7mABmfs2EqDcut8p"
Content-Disposition: inline
In-Reply-To: <CADo9pHh614h0vBkb5cKJvD6wCOXSkKwoCpYeQN9be4LFcArJ3w@mail.gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7mABmfs2EqDcut8p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Working on my Arch Linux Server with an i5-6400
>=20
> Tested-by: Luna Jernberg <droidbittin@gmail.com>
>=20
> On 3/7/23, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1001 patches in this series, all will be posted as a

Please

1) don't top-post

2) trim stuff you are not replying to.

Thanks for testing,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7mABmfs2EqDcut8p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCF1QwAKCRAw5/Bqldv6
8qHYAJ9x2LUDPsMnqJXz4wBjy4nEELA1YACghiCcdtX8BE8Z11wyfBkeAHgmCyU=
=MMRd
-----END PGP SIGNATURE-----

--7mABmfs2EqDcut8p--
