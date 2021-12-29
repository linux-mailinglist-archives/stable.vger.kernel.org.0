Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64ECB4811E6
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhL2LMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:12:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39968 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbhL2LMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:12:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9C5C41C0B9D; Wed, 29 Dec 2021 12:12:12 +0100 (CET)
Date:   Wed, 29 Dec 2021 12:12:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 5.10 091/132] Documentation/locking/locktypes: Update
 migrate_disable() bits.
Message-ID: <20211229111211.GA25195@amd>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213092942.231632373@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20211213092942.231632373@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> commit 6a631c0432dcccbcf45839016a07c015e335e9ae upstream.
>=20
> The initial implementation of migrate_disable() for mainline was a
> wrapper around preempt_disable(). RT kernels substituted this with
> a real migrate disable implementation.
>=20
> Later on mainline gained true migrate disable support, but the
> documentation was not updated.
>=20
> Update the documentation, remove the claims about migrate_disable()
> mapping to preempt_disable() on non-PREEMPT_RT kernels.

> Fixes: 74d862b682f51 ("sched: Make migrate_disable/enable()
>  independent of RT")

AFAICT this commit is not present in 5.10... so this breaks
documentation, rather than improving it. (And should be reverted from
5.10).

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHMQosACgkQMOfwapXb+vLoZQCeM/ogN+kq/SnlxdVNheuHavoj
hkAAoKpVSWGQi6h5ChXL76N/tT2BFoOS
=yqnn
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
