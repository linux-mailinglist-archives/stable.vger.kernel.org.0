Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6228D1163F8
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 23:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfLHWUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 17:20:34 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:50198 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfLHWUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 17:20:34 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 17:20:33 EST
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id AB98672CCD5;
        Mon,  9 Dec 2019 01:13:58 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 9D5637CC7AF; Mon,  9 Dec 2019 01:13:58 +0300 (MSK)
Date:   Mon, 9 Dec 2019 01:13:58 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] tools lib: Disable redundant-delcs error for strlcpy
Message-ID: <20191208221358.GA30636@altlinux.org>
References: <20191208214607.20679-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20191208214607.20679-1-vt@altlinux.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2019 at 12:46:07AM +0300, Vitaly Chikunov wrote:
> Disable `redundant-decls' error for strlcpy declaration and solve build
> error allowing users to compile vanilla kernels.
>=20
> When glibc have strlcpy (such as in ALT linux since 2004) objtool and
> perf build fails with something like:
>=20
>   In file included from exec-cmd.c:3:
>   tools/include/linux/string.h:20:15: error: redundant redeclaration of =
=E2=80=98strlcpy=E2=80=99 [-Werror=3Dredundant-decls]
>      20 | extern size_t strlcpy(char *dest, const char *src, size_t size);
> 	|               ^~~~~~~
>=20
> It's very hard to produce a perfect fix for that since it is a header
> file indirectly pulled from many sources from different Makefile builds.
>=20
> Fixes: ce99091 ("perf tools: Move strlcpy() from perf to tools/lib/string=
=2Ec")
> Fixes: 0215d59 ("tools lib: Reinstate strlcpy() header guard with __UCLIB=
C__")
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: Dmitry V. Levin <ldv@altlinux.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Cc: stable@vger.kernel.org

Apparently, this patch also addresses
https://bugzilla.kernel.org/show_bug.cgi?id=3D118481


--=20
ldv

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJd7XWmAAoJEAVFT+BVnCUIerAQAIVZMVD3GuIlivJKBcsX1KiA
vXeumJEuTjqraAnWkzuCgxLQ7ktvRqgfZQMmmXHvHLPNNOg8+oSYtGZpRT+R07Ak
S0+NtjW2PANjJPtzKEZE7PbaZ069mqhI9OHMCscQmV5HzcxzcX4Am5kwpJMaiHj7
yoHdciwGPth3k9u1ZOWM1VdfvmhM/9alsncOk1VhaqtbXMdUhU8uauvWLCpb+sbR
krwNp6A3TcbeFyOWr1r9Z9Gu86Lo/+EuCW+sVX5YCkq4VselB2IxNbk2upiSBf5+
8Cc1sKdLg50kt2ouYo1G+HFNY0h0g9WJgtrYLypLtrUYxccwfHer8NVeuyZthVLV
/RmVi3q+V1TthJ5cNZi3T1WOEYdTGjAFhrMro7qxTjZZ8wbf4hqNNK5PvCEG/sC2
SPWzcJVYWOpB48DJnftvCLTLYygcUhKZnDodFs6fNCDSNQXmYWXavvRO5j3gNo5H
qoXfACj4qdxy8/JHxdSfnu8pVWQ+lrVHlu/hqEVK6Caa1AgYNoUeT4OZoyufkQla
NCmcX1x+iwAj53HNkScCb/Eep7iT+fHbDvUjSIIRbcjLTAYiJZl4et61fbW5Xm1F
VPM36vEJV6k0Ag1m80GroRu1Ib3wiyyFZbmmM877qAto+CSKUwuh4HeImw0qpeU2
BnEsv6OMa4YVr6D8r4G8
=+oYm
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
