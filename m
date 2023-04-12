Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB1E6DF08F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 11:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjDLJhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbjDLJhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 05:37:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2484C24
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 02:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681292223; x=1712828223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iW014jw93jNltxJmodVKxtkwW3MpOg3Vy7vWHpczrgk=;
  b=aYTAkcpDr5Pvj1cztEb2wwDgt6uMrZ6XN6HFN2oAK5pfPmWzYj5tPx5+
   5HQKafmaYok50en+sX16lCJmRFQUmtm6UOYw8hTIJrAcBQjI/gbVxTOKA
   pT6E/MXuDvmaovQeICbO3wMmzhe8TyJcMqpuRrHdeF75RUm+yy93UbJaN
   7yXmUP/IxECDId3pTWSsRqCN7caZQ5beBhZ7tyWe2VCZf6MDaso5xiuF5
   IrnaD30O8n6CTV1m8TeReZw5fG+ZoUxyaXOKzWDWyKjORJ31M+D+SaBQs
   qicat6sCrA2aVG5oshGCPpIsIO6+bx+IWwAeqBFHloNTVtprUOJoPSVVJ
   w==;
X-IronPort-AV: E=Sophos;i="5.98,338,1673938800"; 
   d="asc'?scan'208";a="210027622"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 02:37:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 02:37:02 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 02:37:01 -0700
Date:   Wed, 12 Apr 2023 10:36:45 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 01/93] soc: sifive: ccache: Rename SiFive L2 cache
 to Composable cache.
Message-ID: <20230412-mustang-machine-e9fccdb6b81c@wendy>
References: <20230412082823.045155996@linuxfoundation.org>
 <20230412082823.103777810@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Li8sIjHv3RuwQst"
Content-Disposition: inline
In-Reply-To: <20230412082823.103777810@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--9Li8sIjHv3RuwQst
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:33:02AM +0200, Greg Kroah-Hartman wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> [ Upstream commit ca120a79cf5a3323172c82e77efd70ae10d120ef ]
>=20
> Since composable cache may be L3 cache if there is a L2 cache, we should
> use its original name composable cache to prevent confusion.
>=20
> There are some new lines were generated due to adding the compatible
> "sifive,ccache0" into ID table and indent requirement.
>=20
> The sifive L2 has been renamed to sifive CCACHE, EDAC driver needs to
> apply the change as well.
>=20
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Zong Li <zong.li@sifive.com>
> Co-developed-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20220913061817.22564-3-zong.li@sifive.com
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() =
in error path in sifive_ccache_init()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Did I just miss AUTOSEL emails for this stuff?

NAK. This seems waay too invasive to me, and changing the Kconfig symbol
for the driver in stable kernels sounds like a bit of a nasty surprise?

The two actual fixes that this is a dep of should be backported
individually, please drop patches 1-7 (inclusive) & I'll give you less
invasive backports for 6 & 7.

Cheers,
Conor.


--9Li8sIjHv3RuwQst
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDZ7rQAKCRB4tDGHoIJi
0n0yAQDJWAJh1t0v3srK/Av27ty95824Xdc+7Q1a509lswdQsgEAu+8YoG573yI2
wE02xMBWjLrAsYCZh7kDrk63xubycAU=
=cQwy
-----END PGP SIGNATURE-----

--9Li8sIjHv3RuwQst--
