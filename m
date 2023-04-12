Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19AF6DF636
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDLMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDLMxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:53:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EFD8A45;
        Wed, 12 Apr 2023 05:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681304009; x=1712840009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zg7kFd/BtrVDt7skRSXJbiaHpkZzFwiw8o8iPI1pEJg=;
  b=SmZZXL6vaaq4G3r9sSgWlYSvg0BOuAeQKhdl6R6XrY43D7JPgYt0tOcR
   ZQUM8PQ3l6qXPpqr13TQx1fMf/F3MRP3KJiFYdGG0jqg8C14xLAZiN1H6
   /QkpTxL0tkyGbIEhyL7BjdcIP6/K2ocPNE9onxYqsws6bPx7JMWf0Z8bi
   EHk2dWqO+FLzAtH+1YsV2gAso8L3KqiWhEG63eQ8E+5fp3G2xJd+5jnG9
   7DfViH7j6o3B0TXOdOqoeaVz36mKROG0olGPUXkb/k+yTFDNvQ9vzpplJ
   Abp5Cmx2TzSqekQNd9eCgl2x+RzE8CExQwME3HEaGrq4sGwYsWse3Gtw5
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="asc'?scan'208";a="220547407"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 05:52:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 05:52:28 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 05:52:25 -0700
Date:   Wed, 12 Apr 2023 13:52:10 +0100
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
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <20230412-headfirst-bottle-e66e4335bc5c@wendy>
References: <20230412082836.695875037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ImYlABTTs//xW8Fa"
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--ImYlABTTs//xW8Fa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--ImYlABTTs//xW8Fa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDapegAKCRB4tDGHoIJi
0g/XAP4gUitKVG36n7dttIwHmgERpTwDZ1TJdta2EQlhhwuNHQEAix/Ubi9A6D1U
TL4iIYOkbY67EwX4KL7+0KnKJWr9fAw=
=U6/L
-----END PGP SIGNATURE-----

--ImYlABTTs//xW8Fa--
