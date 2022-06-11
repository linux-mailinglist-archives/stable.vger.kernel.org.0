Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3F5476F0
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 19:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFKRjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 13:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiFKRjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 13:39:24 -0400
Received: from bluehome.net (bluehome.net [96.66.250.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD5449274
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 10:39:23 -0700 (PDT)
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id 566E84B40507
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 10:39:22 -0700 (PDT)
Date:   Sat, 11 Jun 2022 10:39:21 -0700
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <20220611103921.7b56a960@valencia>
In-Reply-To: <819bb33c-bb9a-1da8-395a-67c9f4da798e@gmail.com>
References: <20220609162943.6e3bba4f@valencia>
        <YqLTecx7MGFPOvhw@kroah.com>
        <20220610182523.2f5620a2@valencia>
        <819bb33c-bb9a-1da8-395a-67c9f4da798e@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kuu04gsrvhLm36sS_/Xj307";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/Kuu04gsrvhLm36sS_/Xj307
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Jun 2022 14:29:53 +0700
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> > It's new; it began in 5.15.45 & 5.10.120, which is when make
> > oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519. =20
>=20
> What did you answer for that new config?

Initially "m" but "y" also seems to not matter. With "y":

or1k-linux-ld: lib/crypto/curve25519-selftest.o: in function
`curve25519_selftest': curve25519-selftest.c:(.init.text+0x7c):
undefined reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x7c): relocation truncated to fit:
R_OR1K_INSN_REL_26 against undefined symbol `__crypto_memneq'
or1k-linux-ld: curve25519-selftest.c:(.init.text+0x110): undefined
reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x110): relocation truncated to
fit: R_OR1K_INSN_REL_26 against undefined symbol `__crypto_memneq'
or1k-linux-ld: curve25519-selftest.c:(.init.text+0x140): undefined
reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x140): relocation truncated to
fit: R_OR1K_INSN_REL_26 against undefined symbol `__crypto_memneq'
or1k-linux-ld: curve25519-selftest.c:(.init.text+0x188): undefined
reference to `__crypto_memneq'
curve25519-selftest.c:(.init.text+0x188): relocation truncated to
fit: R_OR1K_INSN_REL_26 against undefined symbol `__crypto_memneq'
make: *** [Makefile:1183: vmlinux] Error 1

--Sig_/Kuu04gsrvhLm36sS_/Xj307
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmKk00kACgkQnQ2zG1Ra
MZgalQ/7BV7ufVPcJD0M88UzBsHI/CC59HV5sCLmhx6mXyArJlrPGt3qT8tCsrkS
W8iW08C5GJeirZODAtxMfjnXiU/rxjD/RN9tW3RsLNiXzkAmRBf+FHWSg84bh/8Y
Gd2s+fxomXn28+yscisgd11YsIc61QPHR1WZdOMF4Wz05z8MlrGALEi7F6ECQL+q
vwiXl1ENHFvTAfMIigQC6QU7uJ9LfmyQ/oQH5kZFdp42yUSeySX+0ntg47N6otvY
kfHH/CxHyzwjLhMdp14yfgDxrLbuOLXfJ8CmHkOUH9QXUsAYLbvuQRo46MVkW9Tn
iTdZGm/H3BXhDLbT7433UrKDZ+8Fu2/RGveW0VUwQHPPVqULp97sT6pg56QlLLt3
NQVEOSIu5TxxHeamk0tkbt6a7zNNrSCG2QHV45LlFSqxxyLj/HaY0sIwrbUazCJW
C8ZJPS322M3wnf7ueGLNFHBI3Knk1QUJ6BnoCWN3WjBa19f+Ed/irq1wYRtRMUz0
m3LXU1hYnSL/GuoPVmEh1BgRSLxM+x6oFBSZYJDSdp1e8opd+AANkLtdCquVYjt0
ZYIHrVse8qDjbEP/oUnJ5kCovXAnbx0+xAb7dwTsfiUjU7sR7hFs1WXq+MRhCkjn
vce6ZCziIQ34y0gfgoUt/dDmgaRfPfJ+l/ywNK9GCuBO+kl6SZI=
=h/T+
-----END PGP SIGNATURE-----

--Sig_/Kuu04gsrvhLm36sS_/Xj307--
