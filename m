Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60F6C2CCD
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCUIo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 04:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjCUIoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:44:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B31347413;
        Tue, 21 Mar 2023 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679388204; x=1710924204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=btMS0huDMUYhEmGuZe82nAyhxOj5XzUpq5NA/2S108g=;
  b=S3A4PWZyCEnf03oEsWjmJjWeYV++mV/b0Im/oYpx7YyujKfVUgRcLmq4
   s+u/bB5/C0/ohoTu2sqmQc1uyxYvVzpLg2773eXF5TjkAoeaDMTEsLl+1
   GJ3ekWHI9CP6YtOwWpKGnSOLRlQm2NF5nI5zJ+7h5IPwZiQQBwm4U6OXo
   +ZXMRZK9FhJhlXiEiYuvGSw7YRD8LSrIc9XxiCrnV1Pm3oQOyORYn3Q/b
   t3xgCgtuUvz6vHCup4OSFL/lpz2swnfwgX97yIVrnOeB3D7+QVqatGlI6
   UX+Tc1d7MOvS/5P31HPRZUjV+pCdrdwuYX+8XNALYkg23Vt7/3YMaMH/L
   w==;
X-IronPort-AV: E=Sophos;i="5.98,278,1673938800"; 
   d="asc'?scan'208";a="143082697"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2023 01:43:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:43:11 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 21 Mar 2023 01:43:09 -0700
Date:   Tue, 21 Mar 2023 08:42:39 +0000
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
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <174b5c37-b4cc-4ec4-89f1-8eca4ccd3043@spud>
References: <20230320145507.420176832@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3ranM69fegQ07Uvr"
Content-Disposition: inline
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--3ranM69fegQ07Uvr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 20, 2023 at 03:52:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--3ranM69fegQ07Uvr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBlt8AAKCRB4tDGHoIJi
0osqAQCXp7XGbmO3waPebaOqtK+o/IFEysCgiDT7zf72nI9BGwEA0mQccjPondSp
o1T13gT3EdwtFKCNYQ0yXOVc4mTLTQA=
=g0Vt
-----END PGP SIGNATURE-----

--3ranM69fegQ07Uvr--
