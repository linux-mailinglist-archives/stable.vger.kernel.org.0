Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B3E6ECBD5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjDXMLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 08:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXMLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 08:11:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D64AE7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682338261; x=1713874261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oxBJC66V2sIRHtIbWaa+ZrDgEGvsYKDbNxizfVikAYQ=;
  b=MvceiMjtM4Oh2j3IuIB1WhJRjWDsNgTedWkH1soaRh5WmIk0k2+Uobsv
   sXuf39CNTFm90+3ybFdfn7QW2he7+DKGCSpz4WfyR3fHAoxiQKhJhwKMD
   h85bdxQhGhn00jLQpbgdAwpmNy17dG7br0qBnnRWBzsCcMhSt8eLKLRx0
   oa8rUm2FG4nIFZNXVUX3xLWxWBzECEN5AcYTT0+nJiMsCwslQKGJD/OXD
   Bnw6iEn8U0XYzn3P0zEaXRESHucdn1cBXUV1rJiy0AXGmnT6iOSuoOd2y
   aKDacI9/qKkoMDNZ3XV2YegmK+DzBwSoDRmsK0hp5QbfeqeQlM6jfMcC4
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677567600"; 
   d="asc'?scan'208";a="207969390"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2023 05:11:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 24 Apr 2023 05:10:58 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 24 Apr 2023 05:10:58 -0700
Date:   Mon, 24 Apr 2023 13:10:41 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Alexandre Ghiti <alexghiti@rivosinc.com>
CC:     <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15.108 0/3] Fixes for dtb mapping
Message-ID: <20230424-unquote-underpass-26ca33151b86@wendy>
References: <20230424115618.185321-1-alexghiti@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DSoWsxxUmAcaaITy"
Content-Disposition: inline
In-Reply-To: <20230424115618.185321-1-alexghiti@rivosinc.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--DSoWsxxUmAcaaITy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Alex,

On Mon, Apr 24, 2023 at 01:56:15PM +0200, Alexandre Ghiti wrote:
> We used to map the dtb differently between early_pg_dir and
> swapper_pg_dir which caused issues when we referenced addresses from
> the early mapping with swapper_pg_dir (reserved_mem): move the dtb mapping
> to the fixmap region in patch 1, which allows to simplify dtb handling in
> patch 2.
>=20
> base-commit-tag: v5.15.108
>=20
> Alexandre Ghiti (3):
>   [ Upstream commit ef69d2559fe9 ]
>   [ Upstream commit f1581626071c ]
>   [ Upstream commit 1b50f956c8fe ]

I only got 1/3 in my inbox, but I think you've got the structure
slightly incorrect here Alex. The $subject should be preserved, and the
"upstream commit" stuff should be the first line of the body.

I think that `commit <sha1> upstream.` is the preferred format, although
I did see some other format being documented recently enough, but not
going to actually speak for the stable folk!

Cheers,
Conor.

>=20
>  Documentation/riscv/vm-layout.rst |  2 +-
>  arch/riscv/include/asm/fixmap.h   |  8 ++++
>  arch/riscv/include/asm/pgtable.h  |  8 +++-
>  arch/riscv/kernel/setup.c         |  6 +--
>  arch/riscv/mm/init.c              | 68 ++++++++++++++++---------------
>  5 files changed, 52 insertions(+), 40 deletions(-)
>=20
> --=20
> 2.37.2
>=20

--DSoWsxxUmAcaaITy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEZxsgAKCRB4tDGHoIJi
0o25AQD1Atf460VvmkoiCjfMT2yAicWs55MSzi0Wr80NzbRpXgD/ftuR8i+r+Qpj
nKg95J91rW7fm4mySiRhHNohseH4XAA=
=DTDk
-----END PGP SIGNATURE-----

--DSoWsxxUmAcaaITy--
