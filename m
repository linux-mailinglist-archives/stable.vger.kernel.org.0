Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEA2261D1A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbgIHTcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:32:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44768 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731012AbgIHTcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:32:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 00C0F1C0B7F; Tue,  8 Sep 2020 21:32:14 +0200 (CEST)
Date:   Tue, 8 Sep 2020 21:32:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Grant <al.grant@arm.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 40/88] perf tools: Correct SNOOPX field offset
Message-ID: <20200908193214.GA6758@duo.ucw.cz>
References: <20200908152221.082184905@linuxfoundation.org>
 <20200908152223.128046647@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20200908152223.128046647@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Al Grant <al.grant@foss.arm.com>
>=20
> [ Upstream commit 39c0a53b114d0317e5c4e76b631f41d133af5cb0 ]
>=20
> perf_event.h has macros that define the field offsets in the data_src
> bitmask in perf records. The SNOOPX and REMOTE offsets were both 37.
>=20
> These are distinct fields, and the bitfield layout in perf_mem_data_src
> confirms that SNOOPX should be at offset 38.
>=20
> Committer notes:
>=20
> This was extracted from a larger patch that also contained kernel
> changes.
>=20
> Fixes: 52839e653b5629bd ("perf tools: Add support for printing new
> mem_info encodings")

> +++ b/tools/include/uapi/linux/perf_event.h
> @@ -1079,7 +1079,7 @@ union perf_mem_data_src {
> =20
>  #define PERF_MEM_SNOOPX_FWD	0x01 /* forward */
>  /* 1 free */
> -#define PERF_MEM_SNOOPX_SHIFT	37
> +#define PERF_MEM_SNOOPX_SHIFT	38
> =20

We still have:

=2E/include/uapi/linux/perf_event.h:#define PERF_MEM_SNOOPX_SHIFT	37

(note tools/include vs. include).

Should those be in sync before merging this to stable?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1fcPgAKCRAw5/Bqldv6
8janAJ0SZLRix7HkKpoh8hwE2zOl5qd5qwCffo1hrLj9rLNHSbavYFi1ysLKXOk=
=wnJl
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
