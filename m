Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6943D2A7D69
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 12:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgKELoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 06:44:15 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59150 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgKELoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 06:44:13 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B120A1C0B82; Thu,  5 Nov 2020 12:44:08 +0100 (CET)
Date:   Thu, 5 Nov 2020 12:44:08 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 057/191] sparc64: remove mm_cpumask clearing to fix
 kthread_use_mm race
Message-ID: <20201105114408.GA9009@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203240.110227839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20201103203240.110227839@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Nicholas Piggin <npiggin@gmail.com>
>=20
> [ Upstream commit bafb056ce27940c9994ea905336aa8f27b4f7275 ]
=2E..
> io_uring 2b188cc1bb857 ("Add io_uring IO interface") added code which
> does a kthread_use_mm() from a mmget_not_zero() refcount.
=2E..
> The basic fix for sparc64 is to remove its mm_cpumask clearing code. The
> optimisation could be effectively restored by sending IPIs to mm_cpumask
> members and having them remove themselves from mm_cpumask. This is more
> tricky so I leave it as an exercise for someone with a sparc64 SMP.
> powerpc has a (currently similarly broken) example.

So this removes optimalization from Sparc, because it clashes with
2b188cc1bb857 ("Add io_uring IO interface"). But that commit is not
present in 4.19... so this probably is not good idea.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6PliAAKCRAw5/Bqldv6
8n98AJ9Uc+NmgNmzCQI3QdHmr+ziaK4ztwCfUlXuJoy1lBQzAM9E15amAF34hYU=
=m0CZ
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
