Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AEB6C21CE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 20:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCTTon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCTToO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 15:44:14 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004F34EC2;
        Mon, 20 Mar 2023 12:41:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B40FA1C0DC0; Mon, 20 Mar 2023 20:40:59 +0100 (CET)
Date:   Mon, 20 Mar 2023 20:40:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        davidgow@google.com
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Message-ID: <ZBi2y4cQRKnTAAFS@duo.ucw.cz>
References: <20230320145443.333824603@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iaVLeYsRAx45gDPJ"
Content-Disposition: inline
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iaVLeYsRAx45gDPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

> David Gow <davidgow@google.com>
>     rust: arch/um: Disable FP/SIMD instruction to match x86

Why is this patch here? It does not make sense for stable, it was only
in AUTOSEL for less than a week, and I already explained why it is
bad.

"git grep KBUILD_RUSTFLAGS" if in doubt.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--iaVLeYsRAx45gDPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBi2ywAKCRAw5/Bqldv6
8us9AKCl6DQOOqkO66UXPEgQYG7PFx+esgCeLEFphO1uqB1D4D351QwjaTT0hl4=
=LG53
-----END PGP SIGNATURE-----

--iaVLeYsRAx45gDPJ--
