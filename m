Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDC46BB456
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCONSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCONSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:18:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7D4769D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 06:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DB3B81E0B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 13:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD856C433EF;
        Wed, 15 Mar 2023 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678886301;
        bh=aqZVmk7t5WxMGPlPcRU9bGxPIcdBIhLbUYmgb//gCgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgfZWzCNqmUglOtvCMi0CeNNSq6mv7sWE4PjaocvodL7EhkLLIl4bafKxtzi+BWMQ
         X3jZRaEhH4Aaw170LlS4tI2CsUESkVXsL5YmrowLwbFuCqHt44Xz1h3+pmApeJLCTC
         YdPChklKBgTPzSMuivwwZrCX4v/eQS0tVf5QTffdiaZtlU8q4+hdmB13R0KzdyZ8bN
         +GkNqw9r3PFtAsEZkx5gPHrK3xnwNOfIXoi4i+Ym7SGcsf8Tky5/bDn+pFkTSisOq0
         h/KDskny5wG6C7Rb7ZVtqTMpXBZbcl9WWzIxJ56oo7uvPDN1FM3Oz6tosC+neH3mxq
         sCmruBz4gpdDQ==
Date:   Wed, 15 Mar 2023 13:18:17 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 112/141] RISC-V: clarify ISA string ordering rules in
 cpu.c
Message-ID: <4576eb25-2c86-49d3-a290-398d583f479a@spud>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.408666245@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tXGpNp6fssXWhX88"
Content-Disposition: inline
In-Reply-To: <20230315115743.408666245@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tXGpNp6fssXWhX88
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Wed, Mar 15, 2023 at 01:13:35PM +0100, Greg Kroah-Hartman wrote:
> From: Conor Dooley <conor.dooley@microchip.com>
>=20
> [ Upstream commit 99e2266f2460e5778560f81982b6301dd2a16502 ]
>=20
> While the current list of rules may have been accurate when created
> it now lacks some clarity in the face of isa-manual updates. Instead of
> trying to continuously align this rule-set with the one in the
> specifications, change the role of this comment.
>=20
> This particular comment is important, as the array it "decorates"
> defines the order in which the ISA string appears to userspace in
> /proc/cpuinfo.
>=20
> Re-jig and strengthen the wording to provide contributors with a set
> order in which to add entries & note why this particular struct needs
> more attention than others.
>=20
> While in the area, add some whitespace and tweak some wording for
> readability's sake.
>=20
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://lore.kernel.org/r/20221205144525.2148448-2-conor.dooley@mic=
rochip.com
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Stable-dep-of: 1eac28201ac0 ("RISC-V: fix ordering of Zbb extension")

I've been sick for the last week, and am not 100% sure what I did and
did not reply to stable selection emails for, but I'm pretty sure that I
did say that the ZBB stuff was a 6.3 feature and the order fix should
not be backported.

I'm not sure that I understand how this comment rework is a stable
dependency of that backport either, but this should be dropped.
Apologies if I missed a selection email for this one while I've been
sick, but I was sick after all...

Cheers,
Conor.

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/kernel/cpu.c | 49 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> index 1b9a5a66e55ab..db8b16ad9342b 100644
> --- a/arch/riscv/kernel/cpu.c
> +++ b/arch/riscv/kernel/cpu.c
> @@ -144,22 +144,45 @@ arch_initcall(riscv_cpuinfo_init);
>  		.uprop =3D #UPROP,				\
>  		.isa_ext_id =3D EXTID,				\
>  	}
> +
>  /*
> - * Here are the ordering rules of extension naming defined by RISC-V
> - * specification :
> - * 1. All extensions should be separated from other multi-letter extensi=
ons
> - *    by an underscore.
> - * 2. The first letter following the 'Z' conventionally indicates the mo=
st
> + * The canonical order of ISA extension names in the ISA string is defin=
ed in
> + * chapter 27 of the unprivileged specification.
> + *
> + * Ordinarily, for in-kernel data structures, this order is unimportant =
but
> + * isa_ext_arr defines the order of the ISA string in /proc/cpuinfo.
> + *
> + * The specification uses vague wording, such as should, when it comes to
> + * ordering, so for our purposes the following rules apply:
> + *
> + * 1. All multi-letter extensions must be separated from other extension=
s by an
> + *    underscore.
> + *
> + * 2. Additional standard extensions (starting with 'Z') must be sorted =
after
> + *    single-letter extensions and before any higher-privileged extensio=
ns.
> +
> + * 3. The first letter following the 'Z' conventionally indicates the mo=
st
>   *    closely related alphabetical extension category, IMAFDQLCBKJTPVH.
> - *    If multiple 'Z' extensions are named, they should be ordered first
> - *    by category, then alphabetically within a category.
> - * 3. Standard supervisor-level extensions (starts with 'S') should be
> - *    listed after standard unprivileged extensions.  If multiple
> - *    supervisor-level extensions are listed, they should be ordered
> + *    If multiple 'Z' extensions are named, they must be ordered first by
> + *    category, then alphabetically within a category.
> + *
> + * 3. Standard supervisor-level extensions (starting with 'S') must be l=
isted
> + *    after standard unprivileged extensions.  If multiple supervisor-le=
vel
> + *    extensions are listed, they must be ordered alphabetically.
> + *
> + * 4. Standard machine-level extensions (starting with 'Zxm') must be li=
sted
> + *    after any lower-privileged, standard extensions.  If multiple
> + *    machine-level extensions are listed, they must be ordered
>   *    alphabetically.
> - * 4. Non-standard extensions (starts with 'X') must be listed after all
> - *    standard extensions. They must be separated from other multi-letter
> - *    extensions by an underscore.
> + *
> + * 5. Non-standard extensions (starting with 'X') must be listed after a=
ll
> + *    standard extensions. If multiple non-standard extensions are liste=
d, they
> + *    must be ordered alphabetically.
> + *
> + * An example string following the order is:
> + *    rv64imadc_zifoo_zigoo_zafoo_sbar_scar_zxmbaz_xqux_xrux
> + *
> + * New entries to this struct should follow the ordering rules described=
 above.
>   */
>  static struct riscv_isa_ext_data isa_ext_arr[] =3D {
>  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> --=20
> 2.39.2
>=20
>=20
>=20

--tXGpNp6fssXWhX88
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBHFmQAKCRB4tDGHoIJi
0qpAAP4wgXwfuXGPQCEq+2geQM8YeG5ocMVON/7/uc77bvJ2IgD+IJ2qE6tGAlFa
s/x8y7G/ijaoCPaluu+TIOH3qtauhw8=
=0U1H
-----END PGP SIGNATURE-----

--tXGpNp6fssXWhX88--
