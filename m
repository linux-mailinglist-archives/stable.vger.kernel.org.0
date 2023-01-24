Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1AA6798EB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjAXNIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjAXNIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:08:16 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91CEC164;
        Tue, 24 Jan 2023 05:08:10 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8CA1C1C0AAC; Tue, 24 Jan 2023 14:08:09 +0100 (CET)
Date:   Tue, 24 Jan 2023 14:08:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <Y8/YOf8ewgbqOd4o@duo.ucw.cz>
References: <20230122150219.557984692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="36o4gY8SYoSNX2mv"
Content-Disposition: inline
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--36o4gY8SYoSNX2mv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This one makes sense for 5.10, but we don't have followup patches in
4.19, so we don't need this:

> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Add a flag to disable USB3 lpm on a xhci root port level.

Plus, we have patch in 5.10 which we probably need in 4.19/4.14:

|0c7428f0d 8ccc99 o: 5.10| net/ulp: use consistent error code when  blockin=
g ULP

Best regards,
									Pavel
								=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--36o4gY8SYoSNX2mv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8/YOQAKCRAw5/Bqldv6
8ttZAJ4iiyfP3Sq/w+AKxfnch2tR+/E9aQCdFoML11XHb4NVryXCAO/yec4w6Qk=
=vo2U
-----END PGP SIGNATURE-----

--36o4gY8SYoSNX2mv--
