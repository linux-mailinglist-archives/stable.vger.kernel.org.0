Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248BB6EDC0A
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 09:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbjDYHCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 03:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjDYHCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 03:02:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237F54ED5;
        Tue, 25 Apr 2023 00:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682406158; x=1713942158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0uYU44IZRgxrVlK5Tyn1icFuk/3TdFAeptiXaTucBfM=;
  b=gAKDZnirer/Dnb2G14HhuWZsFOfooAQUasnVKzGRpwu+gvxLa6TR7Q6l
   3kDK+oBfngkbsPPlzwUm/wje5pTPhY580MCeRA4BB3FyDC+XqeVbl90tc
   vsYMT1n74k0YoSghR5yNF/v/iMSNEKKoHGDfp3AMlf0cE6n6cYW2wu920
   txYAD0v27Gsca9FiHDgzwzRR1qP1/N6TGzIOEOAkQELmxqdHikgLV88wh
   1KBtxN4QgdsmBL26X6172x7mx30kYy1R8R0LjZb1x3i+MQtaTgiUu5e20
   x9TOVEu21JAVpZLwDces47znyXlji1eqaCiqhIBE4xEKMllwPVnR8XFk0
   A==;
X-IronPort-AV: E=Sophos;i="5.99,224,1677567600"; 
   d="asc'?scan'208";a="211041873"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2023 00:02:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 25 Apr 2023 00:02:35 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 25 Apr 2023 00:02:32 -0700
Date:   Tue, 25 Apr 2023 08:02:15 +0100
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
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <20230425-blog-ninetieth-ab5861b38d16@wendy>
References: <20230424131133.829259077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e9X7m7ankMwLleXD"
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--e9X7m7ankMwLleXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2023 at 03:16:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No "drama" this time around :)
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--e9X7m7ankMwLleXD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEd69wAKCRB4tDGHoIJi
0hAkAP0Wz37/WAYlXp4x7m8T7fkSt8qV5Vx3H2xVBFRo6w2SigD7Bvi8ZQTVeuc0
bB1s7mgT45soL/ZiS1i4KuToE2rz2wU=
=VC0T
-----END PGP SIGNATURE-----

--e9X7m7ankMwLleXD--
