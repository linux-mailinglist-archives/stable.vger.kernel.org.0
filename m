Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBB573BCB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235940AbiGMRLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 13:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGMRLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 13:11:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D572CE02;
        Wed, 13 Jul 2022 10:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01364B820F7;
        Wed, 13 Jul 2022 17:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8369C34114;
        Wed, 13 Jul 2022 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657732308;
        bh=y8ODDuKNhGgHWOzXAk4ajFSxwpWuHdTusjd19LkvJsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=il4NSRcGKIr8gkzLbgqbKFeutsfvnCGVtcVj3mqUSbB1OMbPyZ3PT0tTIHQBUSqHd
         HWatCEXmPzxUZmN0IOoMnxzzloHE6SGwpwXrDjKzs0GDYVIPXE988R3Dt6RxYjZNhq
         Bf2LF00Hu5ci6YFYMfiWsRblQcr/PU5d3dlZUpbwMK5+e4pbj4N8gqHBrToQ5+j0ff
         mdj2aNWmhHDfHWxsHB1e03WuiLtCl+AmALm5yw2KSHn6pWJvmncBA2CdFVuxtfQhfL
         arhjXtdIFc9DNkK8tfvdpSsKQ4zZK0UaBMgv2UQFMxfV2fsBV3tPXnQZCdDlrRYEDX
         yb8LstMzCPLfA==
Date:   Wed, 13 Jul 2022 18:11:43 +0100
From:   Mark Brown <broonie@kernel.org>
To:     kernelci-results@groups.io, bot@kernelci.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org, gtucker@collabora.com,
        linux-kernel@vger.kernel.org
Subject: Re: stable-rc/queue/5.15 bisection: baseline.login on
 qemu_x86_64-uefi-mixed
Message-ID: <Ys78z1V+sR5y78i6@sirena.org.uk>
References: <62cef702.1c69fb81.eda99.2196@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kFicTrH3TyE7iDol"
Content-Disposition: inline
In-Reply-To: <62cef702.1c69fb81.eda99.2196@mx.google.com>
X-Cookie: Positively no smoking.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kFicTrH3TyE7iDol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2022 at 09:46:58AM -0700, KernelCI bot wrote:

The KernelCI bisection bot found a boot failure on x86-64 on at least a
qemu system with 32 bit EDK2 firmware triggered by a backport of upstream
commit aa3d480315ba6c30 ("x86: Use return-thunk in asm code").  The boot
fails with:

<6>[    0.324425] Calibrating delay loop (skipped), value calculated using =
timer frequency.. 3592.02 BogoMIPS (lpj=3D1796010)
<6>[    0.325417] pid_max: default: 32768 minimum: 301
<2>[    0.326744] kernel tried to execute NX-protected page - exploit attem=
pt? (uid: 0)
<1>[    0.327415] BUG: unable to handle page fault for address: 000000000e6=
038c0
<1>[    0.327415] #PF: supervisor instruction fetch in kernel mode
<1>[    0.327415] #PF: error_code(0x0011) - permissions violation

=2E..

<4>[    0.327415] Call Trace:
<4>[    0.327415]  <TASK>
<4>[    0.327415]  ? efi_set_virtual_address_map+0x65/0x103
<4>[    0.327415]  ? efi_enter_virtual_mode+0x39e/0x3f9
<4>[    0.327415]  ? start_kernel+0x5be/0x65a
<4>[    0.327415]  ? secondary_startup_64_no_verify+0xc2/0xcb
<4>[    0.327415]  </TASK>

The full boot log from a failed boot can be seen at:

	https://storage.kernelci.org/stable-rc/queue-5.15/v5.15.54-78-ga5f899726e5=
9/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mix=
ed.txt

I've left the full report below with more details (including a log of
the bisection) and a tag from the bot below.  The 32 bit EFI on x86-64
combination is unfortunately a thing some physical systems do.

> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>=20
> stable-rc/queue/5.15 bisection: baseline.login on qemu_x86_64-uefi-mixed
>=20
> Summary:
>   Start:      a5f899726e592 x86/static_call: Serialize __static_call_fixu=
p() properly
>   Plain log:  https://storage.kernelci.org/stable-rc/queue/5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
>   HTML log:   https://storage.kernelci.org/stable-rc/queue/5.15/v5.15.54-=
78-ga5f899726e59/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
>   Result:     a02ac6ab73cc3 x86: Use return-thunk in asm code
>=20
> Checks:
>   revert:     PASS
>   verify:     PASS
>=20
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
>   Branch:     queue/5.15
>   Target:     qemu_x86_64-uefi-mixed
>   CPU arch:   x86_64
>   Lab:        lab-baylibre
>   Compiler:   gcc-10
>   Config:     x86_64_defconfig
>   Test case:  baseline.login
>=20
> Breaking commit found:
>=20
> -------------------------------------------------------------------------=
------
> commit a02ac6ab73cc327552cb12e13b740e3c8a118bf6
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Tue Jun 14 23:15:45 2022 +0200
>=20
>     x86: Use return-thunk in asm code
>    =20
>     commit aa3d480315ba6c3025a60958e1981072ea37c3df upstream.
>    =20
>     Use the return thunk in asm code. If the thunk isn't needed, it will
>     get patched into a RET instruction during boot by apply_returns().
>    =20
>     Since alternatives can't handle relocations outside of the first
>     instruction, putting a 'jmp __x86_return_thunk' in one is not valid,
>     therefore carve out the memmove ERMS path into a separate label and j=
ump
>     to it.
>    =20
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Signed-off-by: Borislav Petkov <bp@suse.de>
>     Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
>     Signed-off-by: Borislav Petkov <bp@suse.de>
>     [cascardo: no RANDSTRUCT_CFLAGS]
>     Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index a2dddcc189f69..c8891d3b38d30 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -92,6 +92,7 @@ endif
>  endif
> =20
>  $(vobjs): KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_LTO) $(GCC_PLUGINS_=
CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
> +$(vobjs): KBUILD_AFLAGS +=3D -DBUILD_VDSO
> =20
>  #
>  # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
> diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkag=
e.h
> index 030907922bd07..d04e61c2f863c 100644
> --- a/arch/x86/include/asm/linkage.h
> +++ b/arch/x86/include/asm/linkage.h
> @@ -18,19 +18,27 @@
>  #define __ALIGN_STR	__stringify(__ALIGN)
>  #endif
> =20
> +#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined=
(BUILD_VDSO)
> +#define RET	jmp __x86_return_thunk
> +#else /* CONFIG_RETPOLINE */
>  #ifdef CONFIG_SLS
>  #define RET	ret; int3
>  #else
>  #define RET	ret
>  #endif
> +#endif /* CONFIG_RETPOLINE */
> =20
>  #else /* __ASSEMBLY__ */
> =20
> +#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined=
(BUILD_VDSO)
> +#define ASM_RET	"jmp __x86_return_thunk\n\t"
> +#else /* CONFIG_RETPOLINE */
>  #ifdef CONFIG_SLS
>  #define ASM_RET	"ret; int3\n\t"
>  #else
>  #define ASM_RET	"ret\n\t"
>  #endif
> +#endif /* CONFIG_RETPOLINE */
> =20
>  #endif /* __ASSEMBLY__ */
> =20
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 50ea390df7128..4b8ee3a2fcc37 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -40,7 +40,7 @@ SYM_FUNC_START(__memmove)
>  	/* FSRM implies ERMS =3D> no length checks, do the copy directly */
>  .Lmemmove_begin_forward:
>  	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
> -	ALTERNATIVE "", __stringify(movq %rdx, %rcx; rep movsb; RET), X86_FEATU=
RE_ERMS
> +	ALTERNATIVE "", "jmp .Lmemmove_erms", X86_FEATURE_ERMS
> =20
>  	/*
>  	 * movsq instruction have many startup latency
> @@ -206,6 +206,11 @@ SYM_FUNC_START(__memmove)
>  	movb %r11b, (%rdi)
>  13:
>  	RET
> +
> +.Lmemmove_erms:
> +	movq %rdx, %rcx
> +	rep movsb
> +	RET
>  SYM_FUNC_END(__memmove)
>  SYM_FUNC_END_ALIAS(memmove)
>  EXPORT_SYMBOL(__memmove)
> -------------------------------------------------------------------------=
------
>=20
>=20
> Git bisection log:
>=20
> -------------------------------------------------------------------------=
------
> git bisect start
> # good: [8bb7eca972ad531c9b149c0a51ab43a417385813] Linux 5.15
> git bisect good 8bb7eca972ad531c9b149c0a51ab43a417385813
> # bad: [a5f899726e5928dd5640ec76f6d35bbefc7d19b4] x86/static_call: Serial=
ize __static_call_fixup() properly
> git bisect bad a5f899726e5928dd5640ec76f6d35bbefc7d19b4
> # good: [39738a2346b270e8f72f88d8856de2c167bd2899] ibmvnic: free reset-wo=
rk-item when flushing
> git bisect good 39738a2346b270e8f72f88d8856de2c167bd2899
> # good: [11f5f236dbd6e685356e10f158e306e592cb70ff] kvm: x86/cpuid: Only p=
rovide CPUID leaf 0xA if host has architectural PMU
> git bisect good 11f5f236dbd6e685356e10f158e306e592cb70ff
> # good: [0b011b408f349e76f7903a477870051f94c7e119] tty: goldfish: Introdu=
ce gf_ioread32()/gf_iowrite32()
> git bisect good 0b011b408f349e76f7903a477870051f94c7e119
> # good: [f7fa3263079c55e2bbdcd5ff763c19b665e329ed] drm/msm: Fix double pm=
_runtime_disable() call
> git bisect good f7fa3263079c55e2bbdcd5ff763c19b665e329ed
> # good: [16b7cb2803bf088ed08e026f70fa9ac04f3c9800] memory: renesas-rpc-if=
: Avoid unaligned bus access for HyperFlash
> git bisect good 16b7cb2803bf088ed08e026f70fa9ac04f3c9800
> # good: [3b9f491386698a7e39680cb3c375e62d0cae457d] btrfs: fix use of unin=
itialized variable at rm device ioctl
> git bisect good 3b9f491386698a7e39680cb3c375e62d0cae457d
> # good: [445d1c4b5642518587808c59f0faec9b7b4d3fe2] x86/asm: Fix register =
order
> git bisect good 445d1c4b5642518587808c59f0faec9b7b4d3fe2
> # bad: [e9acb6c4a96ae59548659eca7d1c95e2ff892658] x86/bugs: Enable STIBP =
for JMP2RET
> git bisect bad e9acb6c4a96ae59548659eca7d1c95e2ff892658
> # good: [3319d4d152b047d01ddea3094f72d26e601a817b] x86/retpoline: Swizzle=
 retpoline thunk
> git bisect good 3319d4d152b047d01ddea3094f72d26e601a817b
> # good: [ae13a2bad9d648d4ebf05511a9f606ca2fd27de3] x86/kvm: Fix SETcc emu=
lation for return thunks
> git bisect good ae13a2bad9d648d4ebf05511a9f606ca2fd27de3
> # bad: [18de59c1eee14fcb121422919f51a47a449c812e] x86/entry: Avoid very e=
arly RET
> git bisect bad 18de59c1eee14fcb121422919f51a47a449c812e
> # good: [2c90fcb95d0ad54074480cf6b9c601348180da59] x86/sev: Avoid using _=
_x86_return_thunk
> git bisect good 2c90fcb95d0ad54074480cf6b9c601348180da59
> # bad: [a02ac6ab73cc327552cb12e13b740e3c8a118bf6] x86: Use return-thunk i=
n asm code
> git bisect bad a02ac6ab73cc327552cb12e13b740e3c8a118bf6
> # first bad commit: [a02ac6ab73cc327552cb12e13b740e3c8a118bf6] x86: Use r=
eturn-thunk in asm code
> -------------------------------------------------------------------------=
------
>=20
>=20
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Groups.io Links: You receive all messages sent to this group.
> View/Reply Online (#29281): https://groups.io/g/kernelci-results/message/=
29281
> Mute This Topic: https://groups.io/mt/92361801/1131744
> Group Owner: kernelci-results+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci-results/unsub [broonie@kernel.o=
rg]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>=20
>=20

--kFicTrH3TyE7iDol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLO/M4ACgkQJNaLcl1U
h9CGHgf/ZtbepJXBaCMkCFYwVaM6pFC/kOo43UhshRbr+3icxinrdSvsGXpnM4WZ
wdMpEjU2Bgj9j6kfRWYRh3TaohrA1Huo6mMCPuhdiFZXLGVVARqfAUiGyThoVxY5
w6XZs9UYqSSEQhPuPjE0L1Wrnhd3LDU3C1Yonj2N+jAT6NBh0JbkhTPyU35YpUD3
TkoXYzcnpjyLTCFRVM5UpexjypOyIAnlNiCYRWUD9Ak3SKz44O4t+KlKPyEnSQur
LcKwdGQUwy7MfQ6EvPxhvkOupX01kgMWPjMlpzNKD0s/K69irl9u0eUKnM/BkZ+K
xnSD9QUDV1j2iUfoH+nUIO9ATZNQhg==
=LPxx
-----END PGP SIGNATURE-----

--kFicTrH3TyE7iDol--
