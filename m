Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50316C321B
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 13:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCUM6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 08:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCUM6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 08:58:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D3A16339
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 05:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED500B81668
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B5DC433EF;
        Tue, 21 Mar 2023 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679403507;
        bh=fUrFfBTem00Au6MAb6n8c6Qe40M3ghfl65QUUzCSqa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZuT9FKJwjKS2yKMRBWP67LIJ9nQxSE7TvmnusywsL4e/7rbaldUPjQr86Ak52G4x
         u8EhTgBEcmy5+apxWOgwefox5aTOyH7m5mvZ1784g7jwz9OtYgd29F5zJffBmgpFI+
         oHYo/G3AVh5YSy2dCS/OFSHq6KHewSH8WBEb7yYMismSkh7adRWw74YXa9fz4pOR7T
         CDgBKrXJgTHcy3OuEBszAz+5nj/EFFGQUbYeipuRLdnFqLKxjDXIh73ZAc8KPKeYEK
         XDD7zxeInfgPYRR0s/qKL4Ofm3hYPORhDcMma75bLYSZKPUUIF2CTenefRmuSmNdiQ
         4j65V4gt1GRkA==
Date:   Tue, 21 Mar 2023 12:58:22 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Harrison <John.C.Harrison@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Cc:     kernelci-results@groups.io, bot@kernelci.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: stable-rc/linux-5.10.y bisection: baseline.login on
 hp-x360-14-G1-sona
Message-ID: <7f0ccd45-ab53-4155-b647-d082221d65b3@sirena.org.uk>
References: <6419a07b.630a0220.8bbc0.07b1@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YkFerU4B7/lHCmk/"
Content-Disposition: inline
In-Reply-To: <6419a07b.630a0220.8bbc0.07b1@mx.google.com>
X-Cookie: Will it improve my CASH FLOW?
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YkFerU4B7/lHCmk/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 05:18:03AM -0700, KernelCI bot wrote:

The KernelCI bisection bot found a boot bisection on one of the HP
ChromeBooks in v5.10.175 triggered by b5005605013d ("drm/i915: Don't use
BAR mappings for ring buffers with LLC").  The system appears to die
very early in boot with no output.

I've left the full report from the bot below, including links to full
boot logs such as they are and a tag for the bot, and the full web
dashboard for the test case fail is at:

    https://linux.kernelci.org/test/plan/id/64147346939869e04b8c8694/

including details of the successful test on v5.10.174.

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
> stable-rc/linux-5.10.y bisection: baseline.login on hp-x360-14-G1-sona
>=20
> Summary:
>   Start:      de26e1b2103b Linux 5.10.175
>   Plain log:  https://storage.kernelci.org/stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.txt
>   HTML log:   https://storage.kernelci.org/stable-rc/linux-5.10.y/v5.10.1=
75/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.html
>   Result:     b5005605013d drm/i915: Don't use BAR mappings for ring buff=
ers with LLC
>=20
> Checks:
>   revert:     PASS
>   verify:     PASS
>=20
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
>   Branch:     linux-5.10.y
>   Target:     hp-x360-14-G1-sona
>   CPU arch:   x86_64
>   Lab:        lab-collabora
>   Compiler:   gcc-10
>   Config:     x86_64_defconfig+x86-chromebook
>   Test case:  baseline.login
>=20
> Breaking commit found:
>=20
> -------------------------------------------------------------------------=
------
> commit b5005605013d30ab27c303cbaeff60b7872234a3
> Author: John Harrison <John.C.Harrison@Intel.com>
> Date:   Wed Feb 15 17:11:01 2023 -0800
>=20
>     drm/i915: Don't use BAR mappings for ring buffers with LLC
>    =20
>     commit 85636167e3206c3fbd52254fc432991cc4e90194 upstream.
>    =20
>     Direction from hardware is that ring buffers should never be mapped
>     via the BAR on systems with LLC. There are too many caching pitfalls
>     due to the way BAR accesses are routed. So it is safest to just not
>     use it.
>    =20
>     Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>     Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywher=
e")
>     Cc: Chris Wilson <chris@chris-wilson.co.uk>
>     Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>     Cc: Jani Nikula <jani.nikula@linux.intel.com>
>     Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>     Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>     Cc: intel-gfx@lists.freedesktop.org
>     Cc: <stable@vger.kernel.org> # v4.9+
>     Tested-by: Jouni H=F6gander <jouni.hogander@intel.com>
>     Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>     Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.19=
09009-3-John.C.Harrison@Intel.com
>     (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
>     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>     Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/=
gt/intel_ring.c
> index 4034a4bac7f0..69b2e5509d67 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ring.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ring.c
> @@ -49,7 +49,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915=
_gem_ww_ctx *ww)
>  	if (unlikely(ret))
>  		goto err_unpin;
> =20
> -	if (i915_vma_is_map_and_fenceable(vma))
> +	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
>  		addr =3D (void __force *)i915_vma_pin_iomap(vma);
>  	else
>  		addr =3D i915_gem_object_pin_map(vma->obj,
> @@ -91,7 +91,7 @@ void intel_ring_unpin(struct intel_ring *ring)
>  		return;
> =20
>  	i915_vma_unset_ggtt_write(vma);
> -	if (i915_vma_is_map_and_fenceable(vma))
> +	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
>  		i915_vma_unpin_iomap(vma);
>  	else
>  		i915_gem_object_unpin_map(vma->obj);
> -------------------------------------------------------------------------=
------
>=20
>=20
> Git bisection log:
>=20
> -------------------------------------------------------------------------=
------
> git bisect start
> # good: [955623617f2f505ac08d0efda2bb50c1a52e2c96] Linux 5.10.174
> git bisect good 955623617f2f505ac08d0efda2bb50c1a52e2c96
> # bad: [de26e1b2103b1f56451f6ad77f0190c9066c87dc] Linux 5.10.175
> git bisect bad de26e1b2103b1f56451f6ad77f0190c9066c87dc
> # good: [d16701a385b54f44bf41ff1d7485e7a11080deb3] bnxt_en: Avoid order-5=
 memory allocation for TPA data
> git bisect good d16701a385b54f44bf41ff1d7485e7a11080deb3
> # good: [d47d364f6671d8794a89e4972b1fd3284d213c96] macintosh: windfarm: U=
se unsigned type for 1-bit bitfields
> git bisect good d47d364f6671d8794a89e4972b1fd3284d213c96
> # bad: [c3fd717b58f0a3e2461c16e2360ee6a949b47940] ext4: add strict range =
checks while freeing blocks
> git bisect bad c3fd717b58f0a3e2461c16e2360ee6a949b47940
> # good: [7aa5a495cbf8a33cd9fec892c180dedf14292b76] ipmi/watchdog: replace=
 atomic_add() and atomic_sub()
> git bisect good 7aa5a495cbf8a33cd9fec892c180dedf14292b76
> # bad: [b5005605013d30ab27c303cbaeff60b7872234a3] drm/i915: Don't use BAR=
 mappings for ring buffers with LLC
> git bisect bad b5005605013d30ab27c303cbaeff60b7872234a3
> # good: [c53d50d8081a49ba21f866a51277a012b9efad8e] skbuff: Fix nfct leak =
on napi stolen
> git bisect good c53d50d8081a49ba21f866a51277a012b9efad8e
> # first bad commit: [b5005605013d30ab27c303cbaeff60b7872234a3] drm/i915: =
Don't use BAR mappings for ring buffers with LLC
> -------------------------------------------------------------------------=
------
>=20
>=20
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Groups.io Links: You receive all messages sent to this group.
> View/Reply Online (#39748): https://groups.io/g/kernelci-results/message/=
39748
> Mute This Topic: https://groups.io/mt/97753328/1131744
> Group Owner: kernelci-results+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci-results/unsub [broonie@kernel.o=
rg]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>=20
>=20

--YkFerU4B7/lHCmk/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQZqe0ACgkQJNaLcl1U
h9Ae8Af/e4zhZHNncnmKMZFZ42oC4hpGhUabhsZVYx4602o8aBP3K/2PRCZdQLYP
g/m8HS8809F0Eoch9Vw/iBr/RBZdAJNq7Woxv1h+78CjJPLfl00K0O4Gik9N+rDd
5hVnFXYm2oF3lEfsZJQQJCSMPuSXfa0NFAC9LiG+NYzVsq73upbNtgrzHQGmTgDE
lB9+I5HvxMjMwNZPi+gUQ0xYXIEKf+UPoNI4G/XFCB4TpV0u0nWbiZ+63Tw55UQR
FFQTXHNst3viopXYgFP5ZyWA932dNqPVXb1Kuu88La+e2hj8LPCIvO5vs5QxGWhE
EyBvWDQwdkIaeK1Yh/trKtgKA43NUQ==
=M1Ea
-----END PGP SIGNATURE-----

--YkFerU4B7/lHCmk/--
