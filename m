Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103A343A53F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhJYU7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:59:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47994 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhJYU7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 16:59:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9F21F1C0B7F; Mon, 25 Oct 2021 22:56:52 +0200 (CEST)
Date:   Mon, 25 Oct 2021 22:56:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 70/95] gcc-plugins/structleak: add makefile var for
 disabling structleak
Message-ID: <20211025205652.GA2807@duo.ucw.cz>
References: <20211025190956.374447057@linuxfoundation.org>
 <20211025191007.069144838@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20211025191007.069144838@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 554afc3b9797511e3245864e32aebeb6abbab1e3 ]
>=20
> KUnit and structleak don't play nice, so add a makefile variable for
> enabling structleak when it complains.

AFAICT, this patch does nothing useful in 5.10. Unlike mainline,
DISABLE_STRUCTLEAK_PLUGIN is not used elsewhere in the tree.

Best regards,
							Pavel
						=09
> +++ b/scripts/Makefile.gcc-plugins
> @@ -19,6 +19,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF=
)		\
>  		+=3D -fplugin-arg-structleak_plugin-byref
>  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	\
>  		+=3D -fplugin-arg-structleak_plugin-byref-all
> +ifdef CONFIG_GCC_PLUGIN_STRUCTLEAK
> +    DISABLE_STRUCTLEAK_PLUGIN +=3D -fplugin-arg-structleak_plugin-disable
> +endif
> +export DISABLE_STRUCTLEAK_PLUGIN
>  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)		\
>  		+=3D -DSTRUCTLEAK_PLUGIN
> =20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYXcaFAAKCRAw5/Bqldv6
8o/OAKCiM8x6f9KGiz6S/S9gWP0zGgzGAgCfRdEvHcLYqaiNbgM+h/ZvlVnoOAE=
=hBS9
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
