Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78B2A86FB
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 20:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbgKETXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 14:23:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54700 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 14:23:07 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A40621C0B82; Thu,  5 Nov 2020 20:23:05 +0100 (CET)
Date:   Thu, 5 Nov 2020 20:23:05 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 156/191] powerpc: Warn about use of smt_snooze_delay
Message-ID: <20201105192305.GA18462@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203247.174991659@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20201103203247.174991659@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Joel Stanley <joel@jms.id.au>
>=20
> commit a02f6d42357acf6e5de6ffc728e6e77faf3ad217 upstream.
>=20
> It's not done anything for a long time. Save the percpu variable, and
> emit a warning to remind users to not expect it to do anything.
>=20
> This uses pr_warn_once instead of pr_warn_ratelimit as testing
> 'ppc64_cpu --smt=3Doff' on a 24 core / 4 SMT system showed the warning
> to be noisy, as the online/offline loop is slow.

I don't believe this is good idea for stable. It is in 5.9-rc2, and
likely mainline users will get userspace fixed, but that warning is
less useful for -stable users.

(And besides, it does not fix any serious bug).

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6RRGQAKCRAw5/Bqldv6
8i8IAJ9X4P9kUwPdNTkLcqTSARNwc347YgCgjGuqB788e0g81yR0yuOPeeK4dnI=
=sFTr
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
