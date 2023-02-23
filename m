Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C2E6A0C06
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 15:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjBWOln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 09:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbjBWOlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 09:41:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E232D57093;
        Thu, 23 Feb 2023 06:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677163298; x=1708699298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EbDA6i5W8/Ks2Oq6NeDB98gZwwYHaiY1VdNVTzntjoU=;
  b=BI9R29VIYHUy7Gakm3dYdz/g+HjHKK87tIZbgOBV4PCsJsPyUm7XBQ0k
   WapD8dSXG9ezgk9DZNBz9hfGJ1JKTJImMVyZ97KAP58Flfg7z9pytRDVL
   YyXC8HpzwlmmF5/HVKw12K0mgCzPj2+qUMfS+wEXhcWwIcd8SWYzw+XvZ
   zY95l0D3oQxHKpX2UHF0SnSc6COIWLCIyGLE+xTzrl2kGrEXJR4lJKGgu
   XOzZjeGgK5JkaoqJUFbc2R5YkK5htiprOmifPu/WHhwazw9JdDG4LgvGi
   RGJpfmUagfTq5gC3Pn6ubme5kyNVdqISuuSLFfN7S+7Sm+97JKlfjC+Ir
   g==;
X-IronPort-AV: E=Sophos;i="5.97,320,1669100400"; 
   d="asc'?scan'208";a="138728596"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2023 07:41:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:41:37 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 23 Feb 2023 07:41:35 -0700
Date:   Thu, 23 Feb 2023 14:41:08 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 00/46] 6.1.14-rc1 review
Message-ID: <Y/d7BERK7on0BCdn@wendy>
References: <20230223130431.553657459@linuxfoundation.org>
 <Y/d5KdOfh5rXUeqk@wendy>
 <Y/d6QnQrVMK8DHUK@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1PtNLss35S7tRv2"
Content-Disposition: inline
In-Reply-To: <Y/d6QnQrVMK8DHUK@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--k1PtNLss35S7tRv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 03:37:54PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2023 at 02:33:13PM +0000, Conor Dooley wrote:
> > On Thu, Feb 23, 2023 at 02:06:07PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.14 release.
> > > There are 46 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> > > Anything received after that time might be too late.
> > >=20
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1=
=2E14-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
=2Egit linux-6.1.y
> > > and the diffstat can be found below.
> >=20
> > > Dave Hansen <dave.hansen@linux.intel.com>
> > >     uaccess: Add speculation barrier to copy_from_user()
> >=20
> > This breaks the build for me on RISC-V, you need to take f3dd0c53370e
> > ("bpf: add missing header file include") from Linus' tree.
> > It was broken in mainline too, so it is probably broken everywhere you
> > backported it :(
>=20
> Already fixed up and in -rc2.

Cool, I'll go restart my CI jobs then. Thanks.

--k1PtNLss35S7tRv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/d7BAAKCRB4tDGHoIJi
0gp4AQDiJObDn5QPwIS5KeggKGrf7gUi3W7G0JzsWLZu3/tCyAEA6mBgJqi0yVe6
Kcbi/A+QqyrOl7kXAmb1YgzsK547SAg=
=p7ri
-----END PGP SIGNATURE-----

--k1PtNLss35S7tRv2--
