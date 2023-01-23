Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05655677607
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 09:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjAWIEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 03:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjAWIEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 03:04:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA489125A1;
        Mon, 23 Jan 2023 00:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674461050; x=1705997050;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CXt4xHUGCEc11v2dBCdYnBfm6ITSIKvpYk+Zn/u7vWM=;
  b=Py5XZCNflwzMWTTC64gQvXFdjKZn7AooDEo60MoRFS4KWwL9bZ1DNyzZ
   dombmisJKygLjZxiBhGs9mvrMgbZyo2AJKSck3a/3ashjhZEgfz7dXjVh
   FdTrwBv1eFoWOs/ucgreTOjrcCyWtwsbyMZldOpMMd+Wca5Kx/TRvqbGY
   3gWOByOFf4wEs7T/FH97ancd3aExxqdXWQ2xqJMJVL4Cu3Sj7Naq4mqVI
   f/RPOhonBWhL0/9HRTCo5lNO60yg+3qnJFsMe9F4MS1kQEqJl+LvDPcmY
   jeoX8ToTcjE6Wp+f8JxQtQdaPf+BCg0oqf7mDACIH4AxuTeyTGYq/F4OT
   A==;
X-IronPort-AV: E=Sophos;i="5.97,239,1669100400"; 
   d="asc'?scan'208";a="193408657"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2023 01:04:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 01:04:04 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 23 Jan 2023 01:04:02 -0700
Date:   Mon, 23 Jan 2023 08:03:38 +0000
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
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y84/WnTNfDibXSy7@wendy>
References: <20230122150246.321043584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+15ijdafIi6o+7kF"
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--+15ijdafIi6o+7kF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

For our RISC-V stuff, LGTM.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--+15ijdafIi6o+7kF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY84/SQAKCRB4tDGHoIJi
0sKnAQD5dGnbA0TVPGkUxviLq0FRQFKxiLgUSO5FogKv3mmv6gD+Jo3zYWpLTKPZ
8ZUcTtmNWVh2/Fe2kDVBdmeGDqYA8Ag=
=ryn4
-----END PGP SIGNATURE-----

--+15ijdafIi6o+7kF--
