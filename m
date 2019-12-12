Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF21E11CCC3
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLLMG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:06:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39370 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfLLMG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 07:06:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C77F31C2461; Thu, 12 Dec 2019 13:06:24 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:06:24 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 134/243] bpf: btf: check name validity for various
 types
Message-ID: <20191212120624.GA15567@duo.ucw.cz>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150348.188128369@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20191211150348.188128369@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-12-11 16:04:56, Greg Kroah-Hartman wrote:
> From: Yonghong Song <yhs@fb.com>
>=20
> [ Upstream commit eb04bbb608e683f8fd3ef7f716e2fa32dd90861f ]
>=20
> This patch added name checking for the following types:
>  . BTF_KIND_PTR, BTF_KIND_ARRAY, BTF_KIND_VOLATILE,
>    BTF_KIND_CONST, BTF_KIND_RESTRICT:
>      the name must be null
>  . BTF_KIND_STRUCT, BTF_KIND_UNION: the struct/member name
>      is either null or a valid identifier
>  . BTF_KIND_ENUM: the enum type name is either null or a valid
>      identifier; the enumerator name must be a valid identifier.
>  . BTF_KIND_FWD: the name must be a valid identifier
>  . BTF_KIND_TYPEDEF: the name must be a valid identifier
>=20
> For those places a valid name is required, the name must be
> a valid C identifier. This can be relaxed later if we found
> use cases for a different (non-C) frontend.

Does this fix any serious bug? I don't think this is suitable for
stable.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfItQAAKCRAw5/Bqldv6
8sZNAKCpPlKj4aNOz24kULtOT5OPHge6zgCdFh7w/ah2JlnWD5WRRljYPZLpo48=
=1DLt
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
