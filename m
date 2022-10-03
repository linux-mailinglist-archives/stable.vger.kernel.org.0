Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1545F31E1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 16:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJCOV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 10:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJCOV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 10:21:28 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404792F3AB;
        Mon,  3 Oct 2022 07:21:27 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DCFFC1C0024; Mon,  3 Oct 2022 16:21:25 +0200 (CEST)
Date:   Mon, 3 Oct 2022 16:21:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
Message-ID: <20221003142125.GC28203@duo.ucw.cz>
References: <20221003070715.406550966@linuxfoundation.org>
 <20221003134906.GA28203@duo.ucw.cz>
 <Yzrq4FkX+ulsn3se@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <Yzrq4FkX+ulsn3se@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.19.261 release.
> > > There are 25 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Will there be matching 4.9.331?
>=20
> Someday, yes, I did not push out a 4.9.y-rc or 4.14.y-rc today, sorry.

No problem, I seen this and I noted 4.9 and 4.19 go together. I'll try
to remember it is not always the case.

Best regards,
								Pavel

commit fdefb462455685d63acda7bca5fd486d86490132 (origin/linux-4.9.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon Oct 3 09:07:13 2022 +0200

    Linux 4.9.331-rc1



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYzrv5QAKCRAw5/Bqldv6
8n5yAJ9bupSiJcwWfTT8A4tMl2IB4Ca+RQCfQXz6mtYdIR0UnvlJii4zcUL946I=
=ATl6
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
