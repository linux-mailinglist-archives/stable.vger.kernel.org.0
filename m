Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99A5639827
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 20:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiKZT1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 14:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiKZT1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 14:27:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D97140A3
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 11:27:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oz0pG-000232-Kd; Sat, 26 Nov 2022 20:26:58 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5b51:dd55:b9e8:eb6e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5C1EC12A557;
        Sat, 26 Nov 2022 19:26:57 +0000 (UTC)
Date:   Sat, 26 Nov 2022 20:26:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-can@vger.kernel.org, Peter Fink <pfink@christ-es.de>,
        stable@vger.kernel.org, Ryan Edwards <ryan.edwards@gmail.com>
Subject: Re: [PATCH] can: gs_usb: fix size parameter to usb_free_coherent()
 calls
Message-ID: <20221126192656.yb2v2sw6af57sa4f@pengutronix.de>
References: <20221125201727.1558965-1-mkl@pengutronix.de>
 <20221125203217.cuv63t4ijxwmqun7@pengutronix.de>
 <Y4G6a4hlJFgH+iAy@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hat6s6lltkfdnn75"
Content-Disposition: inline
In-Reply-To: <Y4G6a4hlJFgH+iAy@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hat6s6lltkfdnn75
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.11.2022 08:04:11, Greg Kroah-Hartman wrote:
> On Fri, Nov 25, 2022 at 09:32:17PM +0100, Marc Kleine-Budde wrote:
> > Hello Greg,
> >=20
> > with v5.18-rc1 in commit
> >=20
> > | c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in stru=
ct gs_host_frame")
> >=20
> > a bug in the gs_usb driver in the usage of usb_free_coherent() was
> > introduced. With v6.1-rc1
> >=20
> > | 62f102c0d156 ("can: gs_usb: remove dma allocations")
> >=20
> > the DMA allocation was removed altogether from the driver, fixing the
> > bug unintentionally.
> >=20
> > We can either cherry-pick 62f102c0d156 ("can: gs_usb: remove dma
> > allocations") on v6.0, v5.19, and v5.18 or apply this patch, which fixes
> > the usage of usb_free_coherent() only.
>=20
> We should always take what is in Linus's tree, that's the best
> solution.

Ok.

> Does the change backport cleanly?

ACK.

> And 5.19 and 5.18 are long end-of-life, no need to worry about them.
> Only 6.0 matters right now.

Please queue 62f102c0d156 ("can: gs_usb: remove dma allocations") for
v6.0.x and add the fixes tag:

Fixes: c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in str=
uct gs_host_frame")

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hat6s6lltkfdnn75
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOCaHwACgkQrX5LkNig
012lxAf/do5yctOLIE5HyY35427dytnMxSHjX0UsXi8xKRTs6S1kD1jc4zPNQY8m
xPA9Op5uSD6xuUxS2DwRE5nFYwb5lIKrguwstTdtAaqojUIEXIi8Nmxxsv1OQBGI
Zey7c+u6LPnoCTiVfaAd0WyGt9rTLMV9CUCnSPcIS3pRLy3IE3RVZnwJIcc2nREn
AKeR/hhr6orAVCLWmDu/LrMW43G+4aIrcwAurZ4pULuyJmiBkvOcP8gUJFJmUf5h
eGDohaVrmdbeM8ySsWOEDSyfRgbD/+nUh/gXvuCY0UQoM7VC66lbYiQ5NVgXXbZM
v301V9qna/OH1gI/hkoqjATNBxTX0A==
=nJFD
-----END PGP SIGNATURE-----

--hat6s6lltkfdnn75--
