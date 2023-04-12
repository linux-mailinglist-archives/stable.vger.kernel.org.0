Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA02A6DF633
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDLMxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjDLMxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:53:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE7B901F;
        Wed, 12 Apr 2023 05:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681303991; x=1712839991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mgle8TOZj+RHhJAekpvZ/BT/yYwE38lNotj9mGkRDC0=;
  b=wpDPOCIDVKabz4kgrXxVEUIMpwDseXoucth7r2G5YVbxf9P2Ad+Bwob9
   wxXaWFQ7QouV4FYuUBZwvjLKtRVDTVdP5ZW41yeItx9Mgn4DSiSfVxFWm
   T9Y8xN1wEpsolwCG4nGDoFN1R3TlvXDUCkAk46+DTBrNDeqtjwXIYcnll
   CNFU1TUKMcxWl6yIfU2rYmbg1bdvR6spEEsZhgsDtJqlfzrbkfCPSEk8l
   E+8Hn80gI8tvMBuYsQXT+Ztp5ufdNBgmXeNllNGtiHK/RtY/V488O5Lfy
   4nSRi0Xn7IAHZy43lB4AUxWcxuM9/A6XFBO/e+XXaHSKNKlgA/DqT2BPa
   w==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="asc'?scan'208";a="206146473"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 05:51:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 05:51:44 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 05:51:41 -0700
Date:   Wed, 12 Apr 2023 13:51:26 +0100
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
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <20230412-hardly-sepia-9a074ac2deda@wendy>
References: <20230412082838.125271466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1pecpxDfWI/k9n2D"
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--1pecpxDfWI/k9n2D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--1pecpxDfWI/k9n2D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDapTQAKCRB4tDGHoIJi
0iZWAP9cGGwlvWkvJYWD46+GSWO8soa105r4HnWbWogov2vYNwD/Qs41xKhukdMj
7PtpYj8DjE63q66o06Zj85kHGv8SXA0=
=FAXU
-----END PGP SIGNATURE-----

--1pecpxDfWI/k9n2D--
