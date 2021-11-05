Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2A44642E
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhKENfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:35:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47694 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhKENfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 09:35:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4B0841C0BAC; Fri,  5 Nov 2021 14:32:44 +0100 (CET)
Date:   Fri, 5 Nov 2021 14:32:43 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 5.10 13/16] ARM: 9120/1: Revert "amba: make use of -1
 IRQs warn"
Message-ID: <20211105133243.GA9809@amd>
References: <20211104141159.561284732@linuxfoundation.org>
 <20211104141200.023521604@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20211104141200.023521604@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Wang Kefeng <wangkefeng.wang@huawei.com>
>=20
> commit eb4f756915875b0ea0757751cd29841f0504d547 upstream.
>=20
> After commit 77a7300abad7 ("of/irq: Get rid of NO_IRQ usage"),
> no irq case has been removed, irq_of_parse_and_map() will return
> 0 in all cases when get error from parse and map an interrupt into
> linux virq space.
>=20
> amba_device_register() is only used on no-DT initialization, see
>   s3c64xx_pl080_init()		arch/arm/mach-s3c/pl080.c
>   ep93xx_init_devices()		arch/arm/mach-ep93xx/core.c
>=20
> They won't set -1 to irq[0], so no need the warn.

AFAICT this does not fix any bug. It is simply a WARN that can not
trigger.

Best regards,
							Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGFMnoACgkQMOfwapXb+vIuqgCcCYEXcUd8W6Y+3oJW/E0tzcxB
uA0AoKM3aNRsq8rkuuVovD9Q0k8O36mJ
=csIP
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
