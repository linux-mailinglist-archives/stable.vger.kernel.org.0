Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F92FBEFB
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 19:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbhASS3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 13:29:43 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45170 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729132AbhASS3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 13:29:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 893A01C0B85; Tue, 19 Jan 2021 19:28:37 +0100 (CET)
Date:   Tue, 19 Jan 2021 19:28:37 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 077/152] kconfig: remove kvmconfig and xenconfig
 shorthands
Message-ID: <20210119182837.GA18123@duo.ucw.cz>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210118113356.479183926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20210118113356.479183926@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Masahiro Yamada <masahiroy@kernel.org>
>=20
> [ Upstream commit 9bba03d4473df0b707224d4d2067b62d1e1e2a77 ]
>=20
> Linux 5.10 is out. Remove the 'kvmconfig' and 'xenconfig' shorthands
> as previously announced.

I don't believe this is suitable for stable.

Best regards,
								Pavel

> +++ b/scripts/kconfig/Makefile
> @@ -94,16 +94,6 @@ configfiles=3D$(wildcard $(srctree)/kernel/configs/$@ =
$(srctree)/arch/$(SRCARCH)/c
>  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m .conf=
ig $(configfiles)
>  	$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
> =20
> -PHONY +=3D kvmconfig
> -kvmconfig: kvm_guest.config
> -	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
> -	@echo >&2 "         Please use 'make $<' instead."
> -
> -PHONY +=3D xenconfig
> -xenconfig: xen.config
> -	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
> -	@echo >&2 "         Please use 'make $<' instead."
> -
>  PHONY +=3D tinyconfig
>  tinyconfig:
>  	$(Q)$(MAKE) -f $(srctree)/Makefile allnoconfig tiny.config

--=20
http://www.livejournal.com/~pavelmachek

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYAck1QAKCRAw5/Bqldv6
8kZZAJ9kd1RZN+oY4xSW4LAig9y6RHS7jQCfS+XrT3TGlbxzuenBUk3lEdJkGuI=
=yvyq
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
