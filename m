Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5EE4EE8A4
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiDAGzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245758AbiDAGzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:55:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF1C329B1
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 23:53:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1naB9k-00025p-1L; Fri, 01 Apr 2022 08:53:12 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-a2e4-7752-b370-a958.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:a2e4:7752:b370:a958])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1B3C458411;
        Fri,  1 Apr 2022 06:53:10 +0000 (UTC)
Date:   Fri, 1 Apr 2022 08:53:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        ukl@pengutronix.de,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
Message-ID: <20220401065309.dizbkleyw44auhbo@pengutronix.de>
References: <20220126171442.1338740-1-aurelien@aurel32.net>
 <20220331103247.y33wvkxk5vfbqohf@pengutronix.de>
 <20220331103913.2vlneq6clnheuty6@pengutronix.de>
 <20220331105112.7t3qgtilhortkiq4@pengutronix.de>
 <CAHk-=wjnuMD091mNbY=fRm-qFyhMjbtfiwkAFKyFehyR8bPB5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5jl2rqq57omr4yri"
Content-Disposition: inline
In-Reply-To: <CAHk-=wjnuMD091mNbY=fRm-qFyhMjbtfiwkAFKyFehyR8bPB5A@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5jl2rqq57omr4yri
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.03.2022 11:16:53, Linus Torvalds wrote:
> On Thu, Mar 31, 2022 at 3:51 AM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> >
> > Cc +=3D linux-sparse, Uwe, Luc Van Oostenryck
> >
> > tl;dr:
> >
> > A recent change in the kernel regarding the riscv -march handling breaks
> > current sparse.
>=20
> Gaah. Normally sparse doesn't even look at the -march flag, but for
> riscv it does, because it's meaningful for the predefined macros.
>=20
> Maybe that 'die()' shouldn't be so fatal. And maybe add a few more
> extensions (but ignore them) to the parsing.
>=20
> Something ENTIRELY UNTESTED like the attached.

Works-for-me:

|   CHECK   /srv/work/frogger/socketcan/linux/drivers/net/can/usb/etas_es58=
x/es58x_core.c
| WARNING: invalid argument to '-march': 'zicsr_zifencei'

Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>

Regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5jl2rqq57omr4yri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJGoVIACgkQrX5LkNig
0131+gf+OoP5mBIuthsyF3cauP7RO1sSa7VFXUnlth9PI5r6HwTL7dHAjry4lXfJ
x4Dl/7p024mbaQcCTKyUVStHaSIVd6aze/8pCsjmBTARtMe86P9rOyWGaLcES5P7
tp/DjsYxQrYrOt+5Fs7+UrqZP5vnXuPYrKfYz0/VP3fLoA6gFGYTvlTXgiYFj7vL
2xdpRvS1pbZhExvNlkKnJSzKZwE6L841k292RtWWOCzogsPt5YwUlkn/Zb4FbHwR
y8BbMJhcGHG6T+DkgQA6amREXr6Y0Z5z4vzPDZMRpTFdVVmAUaYgqO7sncdEoyDL
qv7LdfZg11z7bYVLbk/Z7Y5oXcsG8A==
=1XuF
-----END PGP SIGNATURE-----

--5jl2rqq57omr4yri--
