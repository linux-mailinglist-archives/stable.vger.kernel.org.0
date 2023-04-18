Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99836E661B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjDRNjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 09:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDRNi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 09:38:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A68210B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681825138; x=1713361138;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pJJC11WAuc+OANctsWFTJZU6Xb9byC95sJdE8ckS274=;
  b=jWwjXwOUIqxLNqgW0nzNZU5LtKz7NlCqQsenN19yQmFi7E7RH9h1cPVo
   XmE+En5NOfBWHoOfSlRW3cdpOtDzRLgDMDCjzfpfHgD1o4z5WhvXpF1gF
   PevBUmDXt/290Xg5DOc/GnEoUeuAe5Y2HW3EDSx89rjCLmwTbNTH6IIbT
   hl/IwZHTltD3Q10PDz4VtV2cWuFV15kfFeTdNeDQRTsgC8drD3ForuWqr
   vrEe7yQc6n6wMPNK9ZzDwLiJO2wFshAjAEE9Hde8gRM0sCjI29/qDujqF
   nFsh8XlsiEj9Dd5eHnM1IZaOSMw2UxHCl9uVwXQhL9JksR1HQCA5NMUqE
   w==;
X-IronPort-AV: E=Sophos;i="5.99,207,1677567600"; 
   d="asc'?scan'208";a="210081986"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 06:38:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 06:38:56 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 18 Apr 2023 06:38:54 -0700
Date:   Tue, 18 Apr 2023 14:38:38 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        Alyssa Ross <hi@alyssa.is>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 127/134] purgatory: fix disabling debug info
Message-ID: <20230418-wrist-glory-14a2aa00b2cb@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.600787422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WwxYlZ02mBcemm70"
Content-Disposition: inline
In-Reply-To: <20230418120317.600787422@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--WwxYlZ02mBcemm70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey folks,

On Tue, Apr 18, 2023 at 02:23:03PM +0200, Greg Kroah-Hartman wrote:
> From: Alyssa Ross <hi@alyssa.is>
>=20
> [ Upstream commit d83806c4c0cccc0d6d3c3581a11983a9c186a138 ]
>=20
> Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> -Wa versions of both of those if building with Clang and GNU as.  As a
> result, debug info was being generated for the purgatory objects, even
> though the intention was that it not be.
>=20
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> Cc: stable@vger.kernel.org
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/purgatory/Makefile | 7 +------
>  arch/x86/purgatory/Makefile   | 3 +--
>  2 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
> index d16bf715a586b..5730797a6b402 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,7 @@ CFLAGS_string.o			+=3D $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_ctype.o		+=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_ctype.o			+=3D $(PURGATORY_CFLAGS)
> =20
> -AFLAGS_REMOVE_entry.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memcpy.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memset.o		+=3D -Wa,-gdwarf-2

> -AFLAGS_REMOVE_strcmp.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strlen.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strncmp.o		+=3D -Wa,-gdwarf-2

How about just deleting these 3 lines, rather than pulling back commit
56e0790c7f9e ("RISC-V: add infrastructure to allow different str*
implementations") <20230418120317.572094889@linuxfoundation.org>
as that is just going to be a bunch of dead code?

Cheers,
Conor.

> +asflags-remove-y		+=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x=
))
> =20
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc263811..82fec66d46d29 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,7 @@ CFLAGS_sha256.o			+=3D $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_string.o		+=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o			+=3D $(PURGATORY_CFLAGS)
> =20
> -AFLAGS_REMOVE_setup-x86_$(BITS).o	+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o			+=3D -Wa,-gdwarf-2
> +asflags-remove-y		+=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x=
))
> =20
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> --=20
> 2.39.2
>=20
>=20
>=20

--WwxYlZ02mBcemm70
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD6dXgAKCRB4tDGHoIJi
0hqrAQCEeNdb+KYWF2N4id5tKtG5ZoL2bpCKDr/uNXuuzx5IFgEAg9rSS/khH/RN
0uGQiWVMchGz1z1Ve/NpYM2P/qjSswY=
=VJFp
-----END PGP SIGNATURE-----

--WwxYlZ02mBcemm70--
