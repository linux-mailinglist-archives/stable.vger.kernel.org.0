Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD7D6A7FE4
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 11:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCBKWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 05:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCBKWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 05:22:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD533CE3C;
        Thu,  2 Mar 2023 02:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677752528; x=1709288528;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9/FsjJQsJLPYNbPa7bC4QZ1Zjup5oogUxQ2o1INWtWs=;
  b=b1xWVCrW6WZKHYLc9YqXemQGi92Bzq7mnfDTz2guMZR/duVYXG/9gmra
   wOTPDDaoT8ZVeeapXPGHu4QE9wmrMZb0kjYP37KDHAfdsnpYbMgWiCqfd
   pxUOJPRm4fwsBB1Tj0kMetYbOd7Hby3x4zE7l8Ek2yvHZjUicBtu+SrVm
   IXsRqQeecY4yqjJ/5yHMBnBAjO88gXKsMGTvR2i1UEOa0hPMOsofu/Dcl
   jMTjlsOxTuoz2hZWJO20+TDzdmmdG6QszE3D54sp/Ay2HKUyTIfp++EDS
   955d4iC1WFilwHKtq3eDM4COkK+zTLUfvqQhbf0+E0DRAUt2iXIIUZp0E
   w==;
X-IronPort-AV: E=Sophos;i="5.98,227,1673938800"; 
   d="asc'?scan'208";a="199558519"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Mar 2023 03:22:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Mar 2023 03:22:05 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 2 Mar 2023 03:22:02 -0700
Date:   Thu, 2 Mar 2023 10:21:35 +0000
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
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <ZAB4r35HC1AB8QIV@wendy>
References: <20230301180653.263532453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Eu/98hARTQftF9Hy"
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Eu/98hARTQftF9Hy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.2.y
> and the diffstat can be found below.

My CI had an aneurysm while testing this rc, but I tested it locally and
looks good. Hardware or bootloader issue perhaps!
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--Eu/98hARTQftF9Hy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAB4rgAKCRB4tDGHoIJi
0hhUAQDf+1s/nY4eFWwJn6Hu/Ry88zPYxbvIxEAVZhuUuM758QEA8ui+xAHdjtwt
Cm2l6aHuvtYvgIS57oGqYItqWRR6fAI=
=ijQq
-----END PGP SIGNATURE-----

--Eu/98hARTQftF9Hy--
