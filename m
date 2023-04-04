Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23ED56D5E21
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbjDDKxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjDDKxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:53:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DE7E7C;
        Tue,  4 Apr 2023 03:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680605579; x=1712141579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/GV8vUoU4LJcg6rrWHdwWvNvtOX+KcMhQSPqgf7Im2Y=;
  b=hLxvSDy9IM4+5PrLFqo/j5GCUtiBGPVk9GUhtR5JN7AmtZZQI1v2H1fk
   qV2JZ3c/kbC5DYlxs8M2JYK5spW662ZiwzElhzliZmNROgVCE36Gmv8Fb
   hYQyG/J7MyDH5vcSqeY/MIv1w2PXFFJAoyUsGtRc481v+8AiV/ufEURT6
   17yL/+Cwz32YaJr9pTjH2u3P+KobrgZVaTexHB0vRcQQiiOiqQviDzAle
   ziaqGpDrxKM3kEoUOh9Cg3BOQ2nZqSn2SRuEhvVMkLQG6MvR8io1i08Ia
   H05dEASzt8R+VOGwLFS57zSF/pNIGPgcOvUeDPaSoK0m9DQJvuKYzd8sC
   g==;
X-IronPort-AV: E=Sophos;i="5.98,317,1673938800"; 
   d="asc'?scan'208";a="208056652"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 03:52:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:52:57 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 4 Apr 2023 03:52:54 -0700
Date:   Tue, 4 Apr 2023 11:52:40 +0100
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
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <20230404-579526715e555bf737a26902@wendy>
References: <20230403140416.015323160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Mvqp1wEA/dAWbANB"
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Mvqp1wEA/dAWbANB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Again, looks grand on our RISC-V stuff...
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--Mvqp1wEA/dAWbANB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCwBeAAKCRB4tDGHoIJi
0grRAQCOmt10BZsuvOs+c8mzCkVA0eGjRnYoUa4bNW0lDQLQtQD/ZXx2ufy6sB3D
akGTACBPxUX/Fo1nMKVNIX88w4l9Mwc=
=EJBA
-----END PGP SIGNATURE-----

--Mvqp1wEA/dAWbANB--
