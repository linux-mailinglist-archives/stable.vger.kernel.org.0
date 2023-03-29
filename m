Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1786CD7CF
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjC2KlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 06:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjC2KlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 06:41:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4193C21;
        Wed, 29 Mar 2023 03:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680086463; x=1711622463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VdBcrgySIdL/WPuWoMsxsQA2x/dh18nj8WQEpF5gTGI=;
  b=a0uJ16ebyQ1ZJIxTWv3xl2pplSXsBP7wax0oCRMWzHB5Oaeu9OLAOLYN
   RDHFsyilkjZJVM97i6JtRgpRN+SDqPBAOptHSoheqU+xjtC03fEPmrqUh
   KRmnpDCyRreI8X3TqFsPBRLp1aSCk/m56YFkFqlP3T0ydn6e1lznYG+Od
   c+2eMKriIHH+EHs2InLmETxrrkvWyoBXBlhn4qEk+RTzZB23Oc9mTyWVT
   x+YyyFIeibnEfQjNjf5s2kJO5t/tR6HPqUDbKYzzYacFwAlROrDEVkAfa
   xPLONHH+PXiv1beZW1uYZynEaKejU74iPEGgLtTzCC/Jlr8LinCHA+6y5
   w==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="asc'?scan'208";a="203988039"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 03:41:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 03:40:59 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 29 Mar 2023 03:40:56 -0700
Date:   Wed, 29 Mar 2023 11:40:43 +0100
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
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <fc8625b8-ce07-4089-8d03-512914aa1bad@spud>
References: <20230328142617.205414124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gry5cg9km3M0xT/2"
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--gry5cg9km3M0xT/2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks grand on our RISC-V stuff, thanks.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

--gry5cg9km3M0xT/2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCQVqwAKCRB4tDGHoIJi
0iOxAQCab9SurRZBZIuLt6aBKrvXH3xW0zTSp3rRTtrvjc3PFwEApJuDc7pVVvFH
6FOEiPQkOGlYDkMcO0r+ra5XMIIPIQQ=
=PXbV
-----END PGP SIGNATURE-----

--gry5cg9km3M0xT/2--
