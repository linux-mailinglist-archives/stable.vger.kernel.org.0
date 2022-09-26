Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98805EA64E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiIZMix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiIZMiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:38:22 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8576BC7;
        Mon, 26 Sep 2022 04:15:29 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D6111C09D6; Mon, 26 Sep 2022 13:14:07 +0200 (CEST)
Date:   Mon, 26 Sep 2022 13:14:08 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 05/40] efi/libstub: Disable Shadow Call Stack
Message-ID: <20220926111408.GF8978@amd>
References: <20220926100738.148626940@linuxfoundation.org>
 <20220926100738.422260948@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <20220926100738.422260948@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sami Tolvanen <samitolvanen@google.com>
>=20
> [ Upstream commit cc49c71d2abe99c1c2c9bedf0693ad2d3ee4a067 ]
>=20
> Shadow stacks are not available in the EFI stub, filter out SCS
> flags.

AFAICT, SCS is not available in 4.19, CC_FLAGS_SCS is not defined
there, and we should apply this patch.

Best regards,
								Pavel

> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -23,6 +23,9 @@ KBUILD_CFLAGS			:=3D $(cflags-y) -DDISABLE_BRANCH_PROFI=
LING \
>  				   $(call cc-option,-ffreestanding) \
>  				   $(call cc-option,-fno-stack-protector)
> =20
> +# remove SCS flags from all objects in this directory
> +KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> +
>  GCOV_PROFILE			:=3D n
>  KASAN_SANITIZE			:=3D n
>  UBSAN_SANITIZE			:=3D n

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxiYAACgkQMOfwapXb+vJO8wCfRJcnTdlYvAAYKyxzfCJlZPhG
pcUAnRKoLshX7g8z+DpqBFIm3v5a3Bdp
=Um+2
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
