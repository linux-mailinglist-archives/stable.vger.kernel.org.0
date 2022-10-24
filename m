Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA460BA5D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiJXUge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiJXUgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:36:08 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3965315A33C;
        Mon, 24 Oct 2022 11:47:42 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 28B2F1C0023; Mon, 24 Oct 2022 20:41:04 +0200 (CEST)
Date:   Mon, 24 Oct 2022 20:41:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 301/390] ARM: decompressor: Include
 .data.rel.ro.local
Message-ID: <20221024184103.GA26813@duo.ucw.cz>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113035.833900007@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20221024113035.833900007@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kees Cook <keescook@chromium.org>
>=20
> [ Upstream commit 1b64daf413acd86c2c13f5443f6b4ef3690c8061 ]
>=20
> The .data.rel.ro.local section has the same semantics as .data.rel.ro
> here, so include it in the .rodata section of the decompressor.
> Additionally since the .printk_index section isn't usable outside of
> the core kernel, discard it in the decompressor. Avoids these warnings:
>=20
> arm-linux-gnueabi-ld: warning: orphan section `.data.rel.ro.local' from `=
arch/arm/boot/compressed/fdt_rw.o' being placed in section `.data.rel.ro.lo=
cal'
> arm-linux-gnueabi-ld: warning: orphan section `.printk_index' from
> `arch/arm/boot/compressed/fdt_rw.o' being placed in section
> `.printk_index'

There's no printk_index in 5.10., so I'm not sure we should be
applying it here.

Best regards,
								Pavel
							=09
> +++ b/arch/arm/boot/compressed/vmlinux.lds.S
> @@ -23,6 +23,7 @@ SECTIONS
>      *(.ARM.extab*)
>      *(.note.*)
>      *(.rel.*)
> +    *(.printk_index)
>      /*
>       * Discard any r/w data - this produces a link error if we have any,
>       * which is required for PIC decompression.  Local data generates


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1bcPwAKCRAw5/Bqldv6
8jQFAJ9rKIiXdGHUrLDI9KrXMiHOJz4esACgvy21T3jpAoDY8vD9XTf+F9EZzaU=
=Rk7J
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
