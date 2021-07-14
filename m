Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DD13C8E99
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhGNTsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45118 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbhGNTrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 15:47:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 36D6C1C0B82; Wed, 14 Jul 2021 21:44:38 +0200 (CEST)
Date:   Wed, 14 Jul 2021 21:44:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 131/593] sched/fair: Fix ascii art by relpacing tabs
Message-ID: <20210714194437.GB15200@amd>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060857.536900755@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20210712060857.536900755@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> When using something other than 8 spaces per tab, this ascii art
> makes not sense, and the reader might end up wondering what this
> advanced equation "is".

I believe this should not be in stable. Our stable-rules documentation
is quite clear there.

> +++ b/kernel/sched/fair.c
> @@ -3141,7 +3141,7 @@ void reweight_task(struct task_struct *p, int prio)
>   *
>   *                     tg->weight * grq->load.weight
>   *   ge->load.weight =3D -----------------------------               (1)
> - *			  \Sum grq->load.weight
> + *                       \Sum grq->load.weight
>   *
>   * Now, because computing that sum is prohibitively expensive to compute=
 (been
>   * there, done that) we approximate it with this average stuff. The aver=
age

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDvPqUACgkQMOfwapXb+vJuEACePvX0TPI5DgGo6VlE+RWKjm9e
/7wAn0YoNQlFUq/pFqXxLy38FAYw8JrZ
=FGCH
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
