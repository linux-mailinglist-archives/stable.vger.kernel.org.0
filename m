Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B976D5E17
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbjDDKwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjDDKwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:52:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B3A35A6;
        Tue,  4 Apr 2023 03:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680605535; x=1712141535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pX0g5xweg8C2mVbKyqhWztK1Mf/XSGZ0k+3Bgdaq5Ts=;
  b=Qv1RpdnhH0UWQggtpsglirpk/O7LJTt9xxuoJ58UJ3AhPEzFi1rE/qRp
   N1aiF0EJ4MIAVwkymY3TImRswzcVTxA3sNtshMpdSvUxpwCXse/IpzDGD
   3aL3dmI0LUiI/LJEoRCUHhqwvjZx1l0+T4dUzL851drtNdFwEQyypD8gH
   gYvY+/14OZe6zI9oRzQ0xvzWomgElzVPkLFrBBtqUOcG1VpErFoeafCSI
   pm1OxWaOpS1IFd9GVAD++SGezTqXbFGxG9wQhVUCkEuPeUKnrBiud+nbq
   kR62i/no5fOdlvr9h338d7TWEFEaUE94WIO+n4qCSbSvFfC3g0OE3Q1tG
   g==;
X-IronPort-AV: E=Sophos;i="5.98,317,1673938800"; 
   d="asc'?scan'208";a="208763109"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 03:52:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:52:08 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 4 Apr 2023 03:52:05 -0700
Date:   Tue, 4 Apr 2023 11:51:51 +0100
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
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <20230404-4e22a0dc0fff4925c669a4c3@wendy>
References: <20230403140415.090615502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tvZ8Eb5ln00blsXj"
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--tvZ8Eb5ln00blsXj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

On our RISC-V stuff, looks as per usual.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--tvZ8Eb5ln00blsXj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCwBRwAKCRB4tDGHoIJi
0oQFAPkB1KDMJ5h0lxly4c/fc2xc7JxEZT2e3CYFPrdjpjtpqQD/XtMHEoGPmx3a
yuU53n5EoHejeQrIVmPdXckUsDnD9wM=
=bPih
-----END PGP SIGNATURE-----

--tvZ8Eb5ln00blsXj--
