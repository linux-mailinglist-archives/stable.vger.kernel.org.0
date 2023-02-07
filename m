Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6597968DC48
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 15:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBGO5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 09:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjBGO5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 09:57:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BC213502;
        Tue,  7 Feb 2023 06:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675781855; x=1707317855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ozUXLjZYqwMgT4/0CspipDk+aY2Gjk0FFWRE1tkPH2k=;
  b=gtKdkK79bv9JVZzBGCDMP7JpVBjpGpF97SiWe/lA2sNgoGOJijQtPRPi
   eaElLAyjV78++FYtFgllaJtkjse3urkZ9aaTYPyov057CYHM/i9gXt8qq
   jZZw/MDr0aDDEv/GUGYAQCptkfNnk9Hjsij5UftD92xe7GWvyuXlS3CY5
   TvESoja93YHk/ANtWZ4m0CbL72beQ+EEj89eRWILm+0yY2q+DSGdUiiJG
   EtoFU/PKsbgPbh3j0DUc+EQjyCoGUY1JSTDp/LnzA3JDRRD+56xhIE/4r
   7NjIGE5YensTamtJ1WxnBpyc/pGhg1NzyYsdifCFoYGZQkap35Zk/QXGF
   g==;
X-IronPort-AV: E=Sophos;i="5.97,278,1669100400"; 
   d="asc'?scan'208";a="135967029"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2023 07:57:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 07:57:27 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 7 Feb 2023 07:57:25 -0700
Date:   Tue, 7 Feb 2023 14:57:00 +0000
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
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+JmvESkNepHM2lQ@wendy>
References: <20230207125634.292109991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/E7IExwYR4bKPk8j"
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--/E7IExwYR4bKPk8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.
>=20

On our RISC-V hardware this looks good, no issues noticed.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--/E7IExwYR4bKPk8j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+JmrQAKCRB4tDGHoIJi
0ld7AP966Tb14hlWBuZ1TvOT1d5i3LHimCNrM8eUxiCs80c23wEAvmjo49oz5KbR
6dhs6qDXCawHWWFmIFG90JRYqxk7YQA=
=m32o
-----END PGP SIGNATURE-----

--/E7IExwYR4bKPk8j--
