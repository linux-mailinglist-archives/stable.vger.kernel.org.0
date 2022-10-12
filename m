Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C585FC2A4
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 11:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJLJFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 05:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJLJFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 05:05:06 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B31827CFB;
        Wed, 12 Oct 2022 02:04:56 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0A9001C002B; Wed, 12 Oct 2022 11:04:55 +0200 (CEST)
Date:   Wed, 12 Oct 2022 11:04:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Luna Jernberg <droidbittin@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <20221012090454.GC14506@amd>
References: <20221010070330.159911806@linuxfoundation.org>
 <CADo9pHgdB7Czsuw=gxv9jAyrUJLjFNCVLW0CGXfszKrj1EfK1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <CADo9pHgdB7Czsuw=gxv9jAyrUJLjFNCVLW0CGXfszKrj1EfK1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Works on Arch Linux
>=20
> Tested-by: Luna Jernberg <droidbittin@gmail.com>

Can we get more details, like list of architectures you build it on
and list of machines or at least architectures you test it on?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmNGgzYACgkQMOfwapXb+vIfbwCgmoHgIfKGnSicQexnvc/0zhnH
cQMAoK2F0SSBG9m0kSWCY5a++8TwhWAZ
=3hAr
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
