Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B6666632B
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 19:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbjAKSz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 13:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbjAKSza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 13:55:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7727B36302;
        Wed, 11 Jan 2023 10:55:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2196EB81BB2;
        Wed, 11 Jan 2023 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB788C433D2;
        Wed, 11 Jan 2023 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463326;
        bh=1mtyVJ+eDRZasVR09aEPxUk1jiKct8AhwB7gd7YYPws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ew17GEygfBoFYf5RPBhZxgNbVtjvjXa0L4p8Cd1bpzbnfJRVXTDWc1wxSC1uiDy48
         y/tCYcM8uj2tjx6sq38q4slatXPBCz7AAzT/ZfOj2yz5asxuB+LKSkQH8idv4PQpZA
         yyuPoXsqdWOYm2XHIxFawliI6H4Lq/IL43lwE8YJ+fJdEKfuLiJ8Zs5tYr2TdlhVFe
         4WC1B1RRSgoM/7t6XeI4Pkomgiyon1cMBVEJYi6J7fCdQ/uVN2qd8pJksGB7qi2Kvc
         Q1l5R/M0Kuuw6T8Ny5qBG7w3nEemB+VN8vVU0ULK1Kpb4Qv/Oq2kWj0uVKlhdBMd67
         M/T3SEOa8xKwA==
Date:   Wed, 11 Jan 2023 18:55:21 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y78GGa5rNou1BWzL@spud>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3prk4W3F/n3buwe"
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3prk4W3F/n3buwe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--u3prk4W3F/n3buwe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY78GGQAKCRB4tDGHoIJi
0pmqAQCBSfGbB1tQfyciGu5GaWr7H7kYXGQwb3apMGAGzYgINAEAi37rovfiqPxS
KKinZ8dsHd4p05sCzi9OdfxL9TwxfQY=
=Itc6
-----END PGP SIGNATURE-----

--u3prk4W3F/n3buwe--
