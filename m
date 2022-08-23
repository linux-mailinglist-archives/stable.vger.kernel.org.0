Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8485C59E3DA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiHWMgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242250AbiHWMfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:35:14 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37265102F3B;
        Tue, 23 Aug 2022 02:47:02 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 802D21C0005; Tue, 23 Aug 2022 11:46:55 +0200 (CEST)
Date:   Tue, 23 Aug 2022 11:46:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris.Paterson2@renesas.com, alice.ferrazzi@miraclelinux.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/101] 4.9.326-rc1 review
Message-ID: <20220823094654.GA10005@duo.ucw.cz>
References: <20220823080034.579196046@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.9.326 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This fails all over on ARM, with messages such as:

/builds/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-11.1.0-nolibc/ar=
m-linux-gnueabi/bin/arm-linux-gnueabi-ld: error: source object drivers/net/=
ethernet/smsc/built-in.o has EABI version 5, but target drivers/net/etherne=
t/built-in.o has EABI version 0
2761/builds/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-11.1.0-nolib=
c/arm-linux-gnueabi/bin/arm-linux-gnueabi-ld: failed to merge target specif=
ic data of file drivers/net/ethernet/smsc/built-in.o
2762scripts/Makefile.build:460: recipe for target 'drivers/net/ethernet/bui=
lt-in.o' failed
2763make[3]: *** [drivers/net/ethernet/built-in.o] Error 1
2764

Which is quite an odd failure. (So I'm Ccing our testing people to ask
for help).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/292007=
3158

This looks vaguely related:

> Masahiro Yamada <yamada.masahiro@socionext.com>
>     kbuild: clear LDFLAGS in the top Makefile

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYwSiDgAKCRAw5/Bqldv6
8vzAAJ9cpTLvA5vgF8BkbokE5RMQ4TxX1gCeLVLHsDfd5A1Lnsq8F4W/OGwRxKE=
=+iU/
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
