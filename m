Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0360D6AE66C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCGQ1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjCGQ0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5588272B9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109C7B8191F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688EEC433D2;
        Tue,  7 Mar 2023 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678206358;
        bh=q1yUnLP7XmPMe1cSmObrn/l8wGmfWdxlJoXfl8rYJSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXeuJD+DV1bMU+TJr7ih/Hlp2RyvTRtLYposIpBW+zaSgU5vhX6/uLKi8EgGChbBT
         jalvxBhFSYqXCbE6Uac4LTucDosRYyvF+ehKsuQj+zMoZ4Ydgg1fVSloEkk9THHja/
         MMcUG0zxL3vUqdEOEbp85W30ZP5zG4X5AB3hPrxT5Zfkzv3M1YoEaY/vIXF57j63HN
         aljHXKX4QYW0zmFFULUdrb53WJjIPEY+lQ2ITq/bf24xmqZ7V3hbDmCGefUFC9E2jj
         J4OGwB8NvYeVXY88BqT1pol+R0F+vvOSXjQmBOw5+2W1dRSan/GYoySPBYQ//6NGPw
         mJpIXsJUUBO1Q==
Date:   Tue, 7 Mar 2023 16:25:54 +0000
From:   Conor Dooley <conor@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     conor.dooley@microchip.com, linux@roeck-us.net,
        palmer@rivosinc.com, samuel@sholland.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] RISC-V: take text_mutex during
 alternative patching" failed to apply to 6.1-stable tree
Message-ID: <a2a21e9c-41ec-46dd-b792-6314c5fa4241@spud>
References: <1678204838254140@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+uYOTNFG828YyHkZ"
Content-Disposition: inline
In-Reply-To: <1678204838254140@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+uYOTNFG828YyHkZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:00:38PM +0100, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 6.1-stable tree.

This patch has a bug and shouldn't be backported as-is anyway, as it
breaks boot on some platforms.
I'll do something about this patch once the fix lands too.

Same applies to whatever other trees it's been attempted to be
backported too.

Cheers,
Conor.

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> To reproduce the conflict and resubmit, you may use the following command=
s:
>=20
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.gi=
t/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782048382=
54140@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..
>=20
> Possible dependencies:
>=20
> 9493e6f3ce02 ("RISC-V: take text_mutex during alternative patching")
> bfd6fc5d8014 ("riscv: Fix early alternative patching")
> 8d23e94a4433 ("riscv: switch to relative alternative entries")
> 4bf8860760d9 ("riscv: cpufeature: extend riscv_cpufeature_patch_func to a=
ll ISA extensions")
> abcc445acdbe ("riscv: move riscv_noncoherent_supported() out of ZICBOM pr=
obe")
> 61a9b7129070 ("Merge patch series "Putting some basic order on isa extens=
ion lists"")
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> >From 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 Mon Sep 17 00:00:00 2001
> From: Conor Dooley <conor.dooley@microchip.com>
> Date: Sun, 12 Feb 2023 19:47:36 +0000
> Subject: [PATCH] RISC-V: take text_mutex during alternative patching
>=20
> Guenter reported a splat during boot, that Samuel pointed out was the
> lockdep assertion failing in patch_insn_write():
>=20
> WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 patch_insn_write+0=
x222/0x2f6
> epc : patch_insn_write+0x222/0x2f6
>  ra : patch_insn_write+0x21e/0x2f6
> epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffffff81803df0
>  gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffffffffffe000
>  t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81803e40
>  s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffffffffffffff
>  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000001
>  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
>  s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffffff80b48828
>  s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 0000000000000fff
>  s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 0000000000000018
>  s11: 000000000000000b t3 : 0000000000000001 t4 : 000000000000000d
>  t5 : ffffffffd8180000 t6 : ffffffff81803bc8
> status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
> [<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
> [<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
> [<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x98
> [<ffffffff80003348>] _apply_alternatives+0x46/0x86
> [<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
> [<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
> [<ffffffff80c0075a>] start_kernel+0xa2/0x8f8
>=20
> This issue was exposed by 702e64550b12 ("riscv: fpu: switch has_fpu() to
> riscv_has_extension_likely()"), as it is the patching in has_fpu() that
> triggers the splats in Guenter's report.
>=20
> Take the text_mutex before doing any code patching to satisfy lockdep.
>=20
> Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
> Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
> Fixes: 1a0e5dbd3723 ("riscv: sifive: Add SiFive alternative ports")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/all/20230212154333.GA3760469@roeck-us.net/
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Samuel Holland <samuel@sholland.org>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20230212194735.491785-1-conor@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>=20
> diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive=
/errata.c
> index ef9a4eec0dba..da55cb247e89 100644
> --- a/arch/riscv/errata/sifive/errata.c
> +++ b/arch/riscv/errata/sifive/errata.c
> @@ -4,6 +4,7 @@
>   */
> =20
>  #include <linux/kernel.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/bug.h>
> @@ -107,8 +108,10 @@ void __init_or_module sifive_errata_patch_func(struc=
t alt_entry *begin,
> =20
>  		tmp =3D (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
> +			mutex_lock(&text_mutex);
>  			patch_text_nosync(ALT_OLD_PTR(alt), ALT_ALT_PTR(alt),
>  					  alt->alt_len);
> +			mutex_lock(&text_mutex);
>  			cpu_apply_errata |=3D tmp;
>  		}
>  	}
> diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/e=
rrata.c
> index 1dd90a5f86f0..3b96a06d3c54 100644
> --- a/arch/riscv/errata/thead/errata.c
> +++ b/arch/riscv/errata/thead/errata.c
> @@ -5,6 +5,7 @@
> =20
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
> @@ -101,10 +102,13 @@ void __init_or_module thead_errata_patch_func(struc=
t alt_entry *begin, struct al
>  			altptr =3D ALT_ALT_PTR(alt);
> =20
>  			/* On vm-alternatives, the mmu isn't running yet */
> -			if (stage =3D=3D RISCV_ALTERNATIVES_EARLY_BOOT)
> +			if (stage =3D=3D RISCV_ALTERNATIVES_EARLY_BOOT) {
>  				memcpy(oldptr, altptr, alt->alt_len);
> -			else
> +			} else {
> +				mutex_lock(&text_mutex);
>  				patch_text_nosync(oldptr, altptr, alt->alt_len);
> +				mutex_unlock(&text_mutex);
> +			}
>  		}
>  	}
> =20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 21fb567e1b22..59d58ee0f68d 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -10,6 +10,7 @@
>  #include <linux/ctype.h>
>  #include <linux/libfdt.h>
>  #include <linux/log2.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <asm/alternative.h>
> @@ -292,8 +293,11 @@ void __init_or_module riscv_cpufeature_patch_func(st=
ruct alt_entry *begin,
> =20
>  		oldptr =3D ALT_OLD_PTR(alt);
>  		altptr =3D ALT_ALT_PTR(alt);
> +
> +		mutex_lock(&text_mutex);
>  		patch_text_nosync(oldptr, altptr, alt->alt_len);
>  		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
> +		mutex_unlock(&text_mutex);
>  	}
>  }
>  #endif
>=20

--+uYOTNFG828YyHkZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAdljwAKCRB4tDGHoIJi
0tALAQCDAP/w1ebsv0pH/jf9ciAuEaK4eJftBc2iRNlMIYM2rwD/WeTmf0kOolH3
4S6YNjAETJE1jJNpw4E/7bbonjEqLQk=
=MC8k
-----END PGP SIGNATURE-----

--+uYOTNFG828YyHkZ--
