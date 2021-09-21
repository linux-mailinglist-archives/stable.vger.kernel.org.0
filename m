Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0EC4129C4
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 02:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhIUAFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 20:05:05 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37653 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239789AbhIUADF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 20:03:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B964E3200B5E;
        Mon, 20 Sep 2021 20:01:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 20 Sep 2021 20:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=elddKd
        D4BPQ0M+cJwTBaZFkbiRuFjkdQnumS8prRBsE=; b=v4Pz4Ctd6lSYg77kUzC3vv
        7tV7NeWPWhYBvJW48B09tcF4tugDz/Q+ZL+eUMY4wUKYpSahhf4SmJiONTv+ChOu
        +QhIvU3VLWYZgEExcs5GM2X1R9AN7gCk7WXert82s1zszvgsRPCutKL9jy1KBQvT
        OmbY1FSiaMiDqetNLHe2igFwMm4RXDkwPy9XaA8CWOHyorBi2bIf/MrmGb0gnkxo
        ZxDJHXCk2CS1JSUpHnTemx4vSwkxvUE+y6lVJMMrNwkhlxGsRfAqcrxDj/LPntJG
        yQEV2CWKxf7aNQIuoGIO05HQmhxlj42o6zLNCHnMDwfWB62nvMmK0E6TIjOzvFkA
        ==
X-ME-Sender: <xms:3iBJYRW3dCGreU2LQrLa5VmdUqU7kTqcSYXQYwzLXuXjj9zP9-eI0g>
    <xme:3iBJYRnugGD-Or2uZSV4eEK4BOyjnzLogB9Tw9SyhV9oOCG7BDtgzglvvErALpVdu
    QamPmf-TKgC0g>
X-ME-Received: <xmr:3iBJYdYuPBELwQxKMChTDVktKmW-1_8kx-eY_PtOHoZbw2GleuRGYi50MfNUA3X8KeoAjwKUZL449si9kiLLI12Y9VGgfFQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeifedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetveff
    iefghfekhffggeeffffhgeevieektedthfehveeiheeiiedtudegfeetffenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:3iBJYUWh324LKSPb-1Ky676Loi0y0Y5CsUnPzrWBIEWCYZxB8-wnoA>
    <xmx:3iBJYbls-90q_PdrkBsnPyZY49B9EBFxGBTjsyGX-0vkTE5V-hyavQ>
    <xmx:3iBJYRcdLpGjcqBgL7SpRsBAH3TyHVsHItquiG-w2GJ74itgw3w0tA>
    <xmx:3yBJYZUwVrj9amEgmY4hmE6piESnkSfYnnLxyRW8Xa0TeLBBXZSCGg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Sep 2021 20:01:32 -0400 (EDT)
Date:   Tue, 21 Sep 2021 02:01:28 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, efault@gmx.de,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/setup: call early_reserve_memory() earlier
Message-ID: <YUkg2NsVB1xwX3dI@mail-itl>
References: <20210920120421.29276-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aUPRBE57vyxN5AhB"
Content-Disposition: inline
In-Reply-To: <20210920120421.29276-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aUPRBE57vyxN5AhB
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Sep 2021 02:01:28 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, efault@gmx.de,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/setup: call early_reserve_memory() earlier

On Mon, Sep 20, 2021 at 02:04:21PM +0200, Juergen Gross wrote:
> Commit a799c2bd29d19c565 ("x86/setup: Consolidate early memory
> reservations") introduced early_reserve_memory() to do all needed
> initial memblock_reserve() calls in one function. Unfortunately the
> call of early_reserve_memory() is done too late for Xen dom0, as in
> some cases a Xen hook called by e820__memory_setup() will need those
> memory reservations to have happened already.
>=20
> Move the call of early_reserve_memory() before the call of
> e820__memory_setup() in order to avoid such problems.
>=20
> Cc: stable@vger.kernel.org
> Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservatio=
ns")
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Signed-off-by: Juergen Gross <jgross@suse.com>

I confirm this fixes my boot issue too.

Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>

> ---
> V2:
> - update comment (Jan Beulich, Boris Petkov)
> - move call down in setup_arch() (Mike Galbraith)
> ---
>  arch/x86/kernel/setup.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 79f164141116..40ed44ead063 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -830,6 +830,20 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	x86_init.oem.arch_setup();
> =20
> +	/*
> +	 * Do some memory reservations *before* memory is added to memblock, so
> +	 * memblock allocations won't overwrite it.
> +	 *
> +	 * After this point, everything still needed from the boot loader or
> +	 * firmware or kernel text should be early reserved or marked not RAM in
> +	 * e820. All other memory is free game.
> +	 *
> +	 * This call needs to happen before e820__memory_setup() which calls the
> +	 * xen_memory_setup() on Xen dom0 which relies on the fact that those
> +	 * early reservations have happened already.
> +	 */
> +	early_reserve_memory();
> +
>  	iomem_resource.end =3D (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>  	e820__memory_setup();
>  	parse_setup_data();
> @@ -876,18 +890,6 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	parse_early_param();
> =20
> -	/*
> -	 * Do some memory reservations *before* memory is added to
> -	 * memblock, so memblock allocations won't overwrite it.
> -	 * Do it after early param, so we could get (unlikely) panic from
> -	 * serial.
> -	 *
> -	 * After this point everything still needed from the boot loader or
> -	 * firmware or kernel text should be early reserved or marked not
> -	 * RAM in e820. All other memory is free game.
> -	 */
> -	early_reserve_memory();
> -
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  	/*
>  	 * Memory used by the kernel cannot be hot-removed because Linux
> --=20
> 2.26.2
>=20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--aUPRBE57vyxN5AhB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmFJINkACgkQ24/THMrX
1yxeEgf+OTiRexZli2dhF3IwJBnJzNUlMY1c9IGqgKF1TZ0LZafQLFWuvFG0sN8Q
U+Cla7L/0wYCu+M3TLT502GYcD2B1xbA2IdugAVXCgShZoRqHPE4tiF7+UuUb1jo
DvroNdgMPgPelkQvexh/OG2XMrSwEjalNV+WH9axOAOlUC0p8ji+7DRhZX9au6fV
qQrjeOfxipfe2XL8RC8ED8dXx7c+xYzpTyphfzhdAwGwMHWpAjzmuHqbGIN2V/IP
xLNETBqQfk+M2VjVPihda8RFue3V/nc4fVL+e5X/EkSW24WC0+5h/U2U1cy0HKqI
8nwCQvL/CmtUZPZbZJCrQ6mM+rob7w==
=Cn+N
-----END PGP SIGNATURE-----

--aUPRBE57vyxN5AhB--
