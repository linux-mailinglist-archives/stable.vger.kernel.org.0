Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22E140ABFE
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhINKuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 06:50:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60767 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhINKuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 06:50:50 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 79C745C0212;
        Tue, 14 Sep 2021 06:49:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 14 Sep 2021 06:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tHeJnF
        1k6ZyHrxR5t5ZIhno68yHo7xZ7224tLpR6g/I=; b=APRgfJAdR+9vVcfDaslR2x
        5+B8MflgQL6X4jjhWtV4ne9qsJmsiuX4sZmXojOFaqfhbI7CVfqShb8eN+U5V9Ta
        EZOEMFo0kLQwaqaOAWlaAJqcYZi0uL8t8QQZfTd++gkAyTKQI2H34KlCHnJys1mv
        0L0l2l+p9qxg3ofLU2J6fV42fGlB1RB/kJl2qKJulO2baFkDiCTYxqcmu/PLIc5N
        xtuz61NqBziez18OaJJH6/YFBZGJzEuLTFrxzSuJNLdLg14DyugG7KUd8+RQznkX
        kbhU4v4ejXiozBECA+6tZfw7tJJaDj9blxxblKMjeBkiF+SL4D/KuOlvtmHqc+Fw
        ==
X-ME-Sender: <xms:O35AYb8RvWQBkRZ6Mh-KmCgSn2H2pHuiAjuLxhLmIMoMisgOADNnpg>
    <xme:O35AYXtEfAhPQG0YW5bj7pZFisfR80uL8T3miWOJGApUeR6t7vRknII2ns4PA55Jl
    hH9pOFNOnJ3pQ>
X-ME-Received: <xmr:O35AYZACNAUmJma3BROdGO2R1Ps9ipSreOOHL2-HkksunEHuu1ldTYlqM-XJdcmfPG9YkELajcbs9GoxIO8UvXN8kNRD2fV7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeetveff
    iefghfekhffggeeffffhgeevieektedthfehveeiheeiiedtudegfeetffenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:O35AYXfjFXMBjdJLsWzx6d4CBg0OZNW6A6nwNoRqa9ZwG4d1woANTg>
    <xmx:O35AYQOIpsrWxQHr1MDWDrrFdH1PoUWbaA1cIHp0kwIodM5EPgyIwQ>
    <xmx:O35AYZk3xWTDMCBrzCaUvM__NwPg3lchBp5Qy1i3WfOxpJdM5DDogw>
    <xmx:PH5AYcBkHmQFWFAwvg_Nmjyzc2-ciSOPgMcdlsJyEz9kSJmYZhGvjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 06:49:30 -0400 (EDT)
Date:   Tue, 14 Sep 2021 12:49:27 +0200
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/setup: call early_reserve_memory() earlier
Message-ID: <YUB+N+bVrd4TCt9X@mail-itl>
References: <20210914094108.22482-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ng3gYZ7HeyL14wKB"
Content-Disposition: inline
In-Reply-To: <20210914094108.22482-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ng3gYZ7HeyL14wKB
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Sep 2021 12:49:27 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/setup: call early_reserve_memory() earlier

On Tue, Sep 14, 2021 at 11:41:08AM +0200, Juergen Gross wrote:
> Commit a799c2bd29d19c565 ("x86/setup: Consolidate early memory
> reservations") introduced early_reserve_memory() to do all needed
> initial memblock_reserve() calls in one function. Unfortunately the
> call of early_reserve_memory() is done too late for Xen dom0, as in
> some cases a Xen hook called by e820__memory_setup() will need those
> memory reservations to have happened already.
>=20
> Move the call of early_reserve_memory() to the beginning of
> setup_arch() in order to avoid such problems.
>=20
> Cc: stable@vger.kernel.org
> Fixes: a799c2bd29d19c565 ("x86/setup: Consolidate early memory reservatio=
ns")
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Thanks, it works!

Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>

> ---
>  arch/x86/kernel/setup.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 79f164141116..f369c51ec580 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -757,6 +757,18 @@ dump_kernel_offset(struct notifier_block *self, unsi=
gned long v, void *p)
> =20
>  void __init setup_arch(char **cmdline_p)
>  {
> +	/*
> +	 * Do some memory reservations *before* memory is added to
> +	 * memblock, so memblock allocations won't overwrite it.
> +	 * Do it after early param, so we could get (unlikely) panic from
> +	 * serial.
> +	 *
> +	 * After this point everything still needed from the boot loader or
> +	 * firmware or kernel text should be early reserved or marked not
> +	 * RAM in e820. All other memory is free game.
> +	 */
> +	early_reserve_memory();
> +
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
> =20
> @@ -876,18 +888,6 @@ void __init setup_arch(char **cmdline_p)
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

--Ng3gYZ7HeyL14wKB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmFAfjcACgkQ24/THMrX
1yyiDAf/cbECScwjsEcDuWCxieb4bXydSDNTKkPbdFll3q6+HMw1aHcvhY/WBej7
xt4vOb/dbqLjRBSPH3w3vCVw8r2zGk8QjhojMNN/8uRqkDpax/KsutFiEs8XsfTC
3NME49YGNCXocNGHIVF79/PNZpKpPIHN40CA/B8r5/OqM6DEBKt9KNWDX7Z9fb/o
s/NdqU/1hFWswunAL87hJ3e/XU8pu1mxP794sAq8XRCwBQjlKoBrdHDBF6QlLau8
Q2qx8U9y7sWNsf4hsGXkgcjLvy7R+zOCvzzXtF4m0SkueVPOm4ilUG4/65X+kcy5
3i+rBfYZ41Qb8csPFnFJOPud0tuTdQ==
=mhfL
-----END PGP SIGNATURE-----

--Ng3gYZ7HeyL14wKB--
