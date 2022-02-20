Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F034BCDD6
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 11:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiBTKBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 05:01:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiBTKBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 05:01:45 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F05354685;
        Sun, 20 Feb 2022 02:01:25 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4E9A41C0B77; Sun, 20 Feb 2022 11:01:24 +0100 (CET)
Date:   Sun, 20 Feb 2022 11:01:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brenda Streiff <brenda.streiff@ni.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 06/11] kconfig: let 'shell' return enough
 output for deep path names
Message-ID: <20220220100123.GB7321@amd>
References: <20220215153104.581786-1-sashal@kernel.org>
 <20220215153104.581786-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <20220215153104.581786-6-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8a4c5b2a6d8ea079fa36034e8167de87ab6f8880 ]
>=20
> The 'shell' built-in only returns the first 256 bytes of the command's
> output. In some cases, 'shell' is used to return a path; by bumping up
> the buffer size to 4096 this lets us capture up to PATH_MAX.

If the idea is to support up-to PATH_MAX, perhaps open-coded 4096
should be replaced by PATH_MAX in the code, too?

Best regards,
								Pavel

> +++ b/scripts/kconfig/preprocess.c
> @@ -138,7 +138,7 @@ static char *do_lineno(int argc, char *argv[])
>  static char *do_shell(int argc, char *argv[])
>  {
>  	FILE *p;
> -	char buf[256];
> +	char buf[4096];
>  	char *cmd;
>  	size_t nread;
>  	int i;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmISEXMACgkQMOfwapXb+vIWuACePVh9P6XNUf65gNso/je802o0
jfcAoIaceGroSVxiOUUwf6eqYaKJ01Xr
=H4bk
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
