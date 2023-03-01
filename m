Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413176A7562
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 21:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCAUd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 15:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjCAUd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 15:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980161E9C7;
        Wed,  1 Mar 2023 12:33:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2700261460;
        Wed,  1 Mar 2023 20:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706CAC433D2;
        Wed,  1 Mar 2023 20:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677702830;
        bh=TBRMkM4l+qa5Px7UuMkJ1H7i28QVep/005Rg1cpUJfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNtIRpnPHks+/WRLfhU5kfmVHuD+u7IxFv+5tQ9nHpZT1oT4kfKfheesIkn2Tfcr1
         7s+YrP7AOI2aB2mZGzSNMNGQeXAfkNZ1+MJNhkhWW3R3FI9jK2MPqnUdjOt56WV+7C
         encQgDds9vB0tngHrV9EfGedkhY1b6ovb8iDaeZ7AKqL3OaOGOQFf+2LNR+K1OPzrv
         Npnet2LOffGghXuqJ189dd5Ayh+UoFRPvFO/beahNAN4vtlaJgbYSELehwV/aA2+S1
         QOL59s7mnRghyjkj118Q8SpUgr1n2MBI3rxJfIUSx50Bazp09rPK7TYmxTWOjQDBwj
         xC4FNDzilb+bQ==
Date:   Wed, 1 Mar 2023 20:33:44 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <484d2a35-d1ec-4118-b93c-5b015a347a82@spud>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dDX7hddAPppdhD1y"
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dDX7hddAPppdhD1y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

On our RISC-V stuff, LGTM:
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--dDX7hddAPppdhD1y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/+2qAAKCRB4tDGHoIJi
0sdPAQDjTvHU5IhheRmD6xdsMkiKr5Bs/KmezzIblLj0Ffc3MgEA2p6Cf3QoDget
l7YxxopxHJm/mX+AXSygxIgw5qjc4A8=
=Sw4u
-----END PGP SIGNATURE-----

--dDX7hddAPppdhD1y--
