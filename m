Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D273D8B78
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhG1KMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:12:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54638 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhG1KMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 06:12:46 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 91E7F1C0B7C; Wed, 28 Jul 2021 12:12:44 +0200 (CEST)
Date:   Wed, 28 Jul 2021 12:12:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 099/167] tcp: disable TFO blackhole logic by default
Message-ID: <20210728101244.GB30574@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153842.719316961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20210726153842.719316961@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 213ad73d06073b197a02476db3a4998e219ddb06 ]
>=20
> Multiple complaints have been raised from the TFO users on the internet
> stating that the TFO blackhole logic is too aggressive and gets falsely
> triggered too often.
> (e.g. https://blog.apnic.net/2021/07/05/tcp-fast-open-not-so-fast/)
> Considering that most middleboxes no longer drop TFO packets, we decide
> to disable the blackhole logic by setting
> /proc/sys/net/ipv4/tcp_fastopen_blackhole_timeout_set to 0 by
> default.

I understand this makes sense for mainline, but should we have this in
stable? Somebody may still be using broken middlebox with their
"stable" server.

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

iEYEARECAAYFAmEBLZsACgkQMOfwapXb+vIwUQCgg6oiio4fPI8TXau28bne2vI4
7m8AoITvFuvycFVOeeJptxNdTRQVsXhn
=0QgD
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
