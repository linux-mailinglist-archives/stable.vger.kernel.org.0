Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0216D5F6B
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbjDDLq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbjDDLqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:46:55 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45A6FF;
        Tue,  4 Apr 2023 04:46:54 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3F2781C0DFD; Tue,  4 Apr 2023 13:46:53 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:46:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
Message-ID: <ZCwOLBxxGIHEyMZ2@duo.ucw.cz>
References: <20230403140353.406927418@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4szT7eDI/gkXwgyZ"
Content-Disposition: inline
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4szT7eDI/gkXwgyZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Jesse Brandeburg <jesse.brandeburg@intel.com>
>     intel-ethernet: rename i40evf to iavf

I don't think this one is suitable for stable. It is huga and has huge
impact, in part it renames module...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4szT7eDI/gkXwgyZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwOLAAKCRAw5/Bqldv6
8i90AJkB10mxom0JKD9M5n7pFikLfii5dgCfR3+OYEH2+3McQzAL4/6+6MgOC84=
=Kea1
-----END PGP SIGNATURE-----

--4szT7eDI/gkXwgyZ--
