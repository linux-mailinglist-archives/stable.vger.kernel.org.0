Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056561737DA
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgB1NFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:05:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgB1NFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 08:05:36 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1B58B1C0314; Fri, 28 Feb 2020 14:05:34 +0100 (CET)
Date:   Fri, 28 Feb 2020 14:05:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miles Chen <miles.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 60/97] lib/stackdepot: Fix outdated comments
Message-ID: <20200228130532.GA2979@duo.ucw.cz>
References: <20200227132214.553656188@linuxfoundation.org>
 <20200227132224.337663006@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20200227132224.337663006@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit ee050dc83bc326ad5ef8ee93bca344819371e7a5 ]
>=20
> Replace "depot_save_stack" with "stack_depot_save" in code comments becau=
se
> depot_save_stack() was replaced in commit c0cfc337264c ("lib/stackdepot:
> Provide functions which operate on plain storage arrays") and removed in
> commit 56d8f079c51a ("lib/stackdepot: Remove obsolete functions")

This is wrong.

> +++ b/lib/stackdepot.c
> @@ -96,7 +96,7 @@ static bool init_stack_slab(void **prealloc)
>  		stack_slabs[depot_index + 1] =3D *prealloc;
>  		/*
>  		 * This smp_store_release pairs with smp_load_acquire() from
> -		 * |next_slab_inited| above and in depot_save_stack().
> +		 * |next_slab_inited| above and in stack_depot_save().
>  		 */
>  		smp_store_release(&next_slab_inited, 1);
>  	}

May have been outdated for mainline, but they are actually okay for
4.19.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXlkQHAAKCRAw5/Bqldv6
8tAzAJ95qqYvuO9RBFo7nXmPUkGUMFI7JwCfSMtXBblNLSW62kuhjkvzKX/LWJ0=
=p+Oh
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
