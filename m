Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B9F5470EA
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 03:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiFKBZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 21:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiFKBZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 21:25:27 -0400
Received: from bluehome.net (bluehome.net [96.66.250.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA4F38C75A
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:25:25 -0700 (PDT)
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id 00DD74B40507
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:25:24 -0700 (PDT)
Date:   Fri, 10 Jun 2022 18:25:23 -0700
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <20220610182523.2f5620a2@valencia>
In-Reply-To: <YqLTecx7MGFPOvhw@kroah.com>
References: <20220609162943.6e3bba4f@valencia>
        <YqLTecx7MGFPOvhw@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aXYr8CB8lHsAuG61eCWfU5c";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/aXYr8CB8lHsAuG61eCWfU5c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jun 2022 07:15:37 +0200
Greg KH <greg@kroah.com> wrote:

> On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote:
> > In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=3Dm I get
> > the following. My workaround is to leave it as
> > CRYPTO_LIB_CURVE25519=3Dn for now.
> >=20
> > CONFIG_OR1K_1200=3Dy
> > CONFIG_OPENRISC_BUILTIN_DTB=3D"or1ksim"
> >=20
> >   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
> >   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
> >   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined!
> > make[1]: *** [scripts/Makefile.modpost:134: modules-only.symvers]
> > Error 1 make[1]: *** Deleting file 'modules-only.symvers' make:
> > *** [Makefile:1783: modules] Error 2 =20
>=20
>=20
> Is this a new problem, or has it always been there for these kernel
> trees?

It's new; it began in 5.15.45 & 5.10.120, which is when make
oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519.

--Sig_/aXYr8CB8lHsAuG61eCWfU5c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmKj7wMACgkQnQ2zG1Ra
MZi7Ww/+K5dtxgnuTiPvr5SXSfo2OOGAnR+zdwffGjaP34Uut0zGRndcFaS5YcMo
U+km9iAKcVUYHpN6aqWdGFYND4vDBt29xcmu8mB1oOf04KeHJSXQWFCCLe3PfAN/
XIG+r8DHBLLHAf0AyrgR/2AHFStS231EBUhdcwsHxP4NXl+vOT1YO2df8CBkW+Zn
5oI4OvR8MV8F2b5O71ClmzKqqwDll/Wr1aDwREdCuYtJtM2riZF8vvHfkxzHe2T2
37vpT+L/A/ym4Nc9Qs5YjnZyMOQ8lfKqV7jdKCbl6XAZfVrO+/RJYvnaovL8ka0r
frfahe7q++MiDwgJ471M/xuJvXUfyxmINRn2i8N3K3ZNHSZHujZdnqC4hB5o2QM0
+lPoPquXqD0lDmWtfogd0RoGAD3ooT37eXP135NL4Cci3XWQngFZ1PkoiFytN5dQ
fmUspyTjpkf0brhVUx7OvO6yamDBX13gxG34CPQypq0d9sWbXKpMynC5r++jP+GK
K2wkAacnZmayHtkCUTChv+danIpHKkl19I1upPW4jdakKg0r19atT2y6FfrG/4BG
G2d82uKRjaeSlmktnZrpmxT7VCshucV7NzwPHuWaI/3Iaf3Wr9WouyKW4/jYYyEd
Sh6SeakOVSIpJaUSrvB3OxAY6vzeUexUuu3zjVy4XZjjFs2yCnE=
=8Hlx
-----END PGP SIGNATURE-----

--Sig_/aXYr8CB8lHsAuG61eCWfU5c--
