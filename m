Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B086EDC0C
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 09:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjDYHDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 03:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjDYHDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 03:03:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B366465B8;
        Tue, 25 Apr 2023 00:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682406219; x=1713942219;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LNM/P5bjteU89CNsy/1BnEsQcAv8z/6w82DBFllYF9A=;
  b=J7o5ruaQ1xNQ9vcsRsPj/b+EadwhJwu9AZS/0DnXp9zSFdYQh5J2MVKw
   PAvO/YqNiHCEBvlzCswWN9UQ3MCqGBKVmLDs5JxrPf3DHLFCy9DsQD2v/
   r6e1b5wwCJ/QztSIu0X2PHvIsuUa8vUAq8/YvrTCoCGP+Vtk7H8gs38F4
   rHkbEqD9cgcGLUMKc1MXNB/y3BG5qdYZdq4HDLxO+wTW1KLJwb6vCrVYY
   S9hVGr6IjYwY9r1SVF+t4mK+MpaghTQ1JkVSBI0tBd+zzK1ZlMvXuclBo
   KVx4vMa/PK+sXiq1W6db2Y4fP8PZ8akSJC7oHqjEYkmLLHaEmD8+J8TTj
   g==;
X-IronPort-AV: E=Sophos;i="5.99,224,1677567600"; 
   d="asc'?scan'208";a="210552771"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2023 00:03:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 25 Apr 2023 00:03:38 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 25 Apr 2023 00:03:36 -0700
Date:   Tue, 25 Apr 2023 08:03:18 +0100
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
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <20230425-kilometer-poach-6027ead556f1@wendy>
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9vQlMmaF15WcW9/H"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--9vQlMmaF15WcW9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--9vQlMmaF15WcW9/H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEd7NgAKCRB4tDGHoIJi
0sruAQDWoD0FXPXbOxk3XXGRP/0XN9HsDmIyzX1mYK+vEuGFEwD/d/E5LS2lIVzz
IS/2VZsVMSEnBe6AL6XduSbE6VGT6w4=
=BEiT
-----END PGP SIGNATURE-----

--9vQlMmaF15WcW9/H--
