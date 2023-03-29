Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929CD6CD980
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 14:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjC2Mpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 08:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC2Mpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 08:45:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875FFF4;
        Wed, 29 Mar 2023 05:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680093929; x=1711629929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cukQmgxAG+VTZdX0jlNhMge1f4ECwtBcvqgzQqaFGj0=;
  b=P7F42d1mNxXiK328ZRVRai7dXkd4hw2iUBiUwC5ZXIPStFh3QQ30hEJp
   ezrqKXRRSyOc0mRGwOgOC1FY+FLOUbueC0XIpxkmOJPL9oARtBKwzuDIN
   +JII1qIMfucKdWrLdWm3QkwsN0Tzt9DgOLSLrEmOBtiPvAWnVf5LE6/YP
   wG/0nvzzLueVik8OhdNCBXLB2eX4ICjkQ11tQLE1VxJ9u/dBiUxpgs/bp
   Nmmx72d87wV47Nc6okzrooJ1PlYqlT5ttaoGTgsNE3+H+iSq92M0yqZoW
   w5S0MA7jskbHm2oKsaat74dz3oGfVSZ0IiwSzJcAUez1XTLFDcME54gqn
   A==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="asc'?scan'208";a="144483518"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 05:45:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 05:45:28 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 29 Mar 2023 05:45:25 -0700
Date:   Wed, 29 Mar 2023 13:45:12 +0100
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
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <3d21953f-7b60-4650-b9e9-438f45cde8d0@spud>
References: <20230328142619.643313678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FAzB7HwGpvW87Uc5"
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--FAzB7HwGpvW87Uc5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Nothing unexpected testing wise on our RISC-V stuff..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--FAzB7HwGpvW87Uc5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCQy2AAKCRB4tDGHoIJi
0vY1AP9wJpeSfm3cEuOrHzfqbzErLpYa9f9/3zAy1MlW3k+gFQEAiFOwWKhMsVfi
trse0uh+JRoFe8yoiv4MHLWjRjhNmQA=
=OLmW
-----END PGP SIGNATURE-----

--FAzB7HwGpvW87Uc5--
