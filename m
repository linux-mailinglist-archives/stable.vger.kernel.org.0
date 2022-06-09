Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197D65458AB
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 01:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbiFIXgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 19:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiFIXgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 19:36:31 -0400
X-Greylist: delayed 404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 16:36:30 PDT
Received: from bluehome.net (bluehome.net [96.66.250.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A5765C
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 16:36:29 -0700 (PDT)
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id 9C9C24B4001B
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 16:29:44 -0700 (PDT)
Date:   Thu, 9 Jun 2022 16:29:43 -0700
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <20220609162943.6e3bba4f@valencia>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nAr7_4mQ7iSMd5JbuYMF9MF";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/nAr7_4mQ7iSMd5JbuYMF9MF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=3Dm I get the
following. My workaround is to leave it as CRYPTO_LIB_CURVE25519=3Dn
for now.

CONFIG_OR1K_1200=3Dy
CONFIG_OPENRISC_BUILTIN_DTB=3D"or1ksim"

  sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
  modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
  "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined! make[1]:
  *** [scripts/Makefile.modpost:134: modules-only.symvers] Error 1
  make[1]: *** Deleting file 'modules-only.symvers' make: ***
  [Makefile:1783: modules] Error 2

--Sig_/nAr7_4mQ7iSMd5JbuYMF9MF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmKigmcACgkQnQ2zG1Ra
MZhcJQ//bMxmHX6id782VcBhm79wuDlIVXtCavh5Lkrk7guvcu4q5iRHFqOrG4zv
5kyO1Z3+LdLWmnQlalUWHP2PQgrlz7nPF5WCbZP9f2KEsX3NnPA/RF28w2fkqT80
xlPKyLePH+uArrFrQVWAIc/GvLzqg8c7dkd/vdfCOre49JHX4HttlQ3gtqKYAe3c
TCt2y/RBiWvg4kAdMNrq+yFYfSxWy5Tv/dqT01l9zwkPjBBQZkSn5LdMd2zuMiKx
Deg+gwfsp7ACYa+VA1rIzv4UR92s9c2TUYaZK84HbglPXTOCpxdqUkKJwCBc3+RV
SXgFu9l2OFx3fr0f+uu9M2WStaI6+GV0veceVUt7k+n5ejMWAKh2MVevGr77b2EN
DqzhxguA62nQQULakMLO785xrOV4c/nCPx/zaQZDvGG4KqoTc/eGE5w0KXOEMD7I
L0xWzw5ue+GKJ3y1ctewdT9AZVdLa9vOrA5/xiyAsFyUnxpkOwhUVDg0YK9nvPBI
7UMAdjwz3h1YkP5/VkJvUwSMYorNubRHi6wWf0UJnRSU1Hqa1rz6WbMZN1nCIPWw
/QGRnUI/SpWjg1sYnY2NForW0YiCH8MWs8631gad7R3kM7BleSM1FNTIrMuPxcu5
drgmCTlygcMFaogbwLvLTM+DdL/+z6vzQ5Xbq9CMj8c5BMvqbak=
=JBHo
-----END PGP SIGNATURE-----

--Sig_/nAr7_4mQ7iSMd5JbuYMF9MF--
