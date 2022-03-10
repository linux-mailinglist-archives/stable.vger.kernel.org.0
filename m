Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41CF4D45EE
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 12:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiCJLmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 06:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiCJLmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 06:42:19 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4531144F77;
        Thu, 10 Mar 2022 03:41:18 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 53B801C0B87; Thu, 10 Mar 2022 12:41:17 +0100 (CET)
Date:   Thu, 10 Mar 2022 12:41:16 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Message-ID: <20220310114116.GD20436@duo.ucw.cz>
References: <20220309155856.295480966@linuxfoundation.org>
 <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
 <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
In-Reply-To: <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This is not breaking the build, but...

> commit d0002ea56072220ddab72bb6e31a32350c01b44e
> Author: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Date:   Thu Feb 10 16:05:45 2022 +0000
>     ARM: Spectre-BHB workaround

>     comomit b9baf5c8c5c356757f4f9d8180b5e9d234065bc3 upstream.

=2E..the typo in word "commit" breaks our scripts, so we'd not mind if
it was fixed.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYinj3AAKCRAw5/Bqldv6
8ur9AKC3zFDgas8Exkm3RQJsuZX+3YpG/ACfaBKvriT6zOMlTMejLG9LHw+cpmE=
=8zSA
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
