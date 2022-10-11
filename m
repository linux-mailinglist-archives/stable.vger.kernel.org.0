Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DBF5FAD1E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 08:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJKG5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 02:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJKG5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 02:57:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33F3814F7
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 23:57:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oi9Cs-0001ZS-7h; Tue, 11 Oct 2022 08:57:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BA5E6F9C0B;
        Tue, 11 Oct 2022 06:57:36 +0000 (UTC)
Date:   Tue, 11 Oct 2022 08:57:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     linux-can@vger.kernel.org,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 0/4] can: kvaser_usb: Various fixes
Message-ID: <20221011065734.a3mjk7hnx4xtuvfk@pengutronix.de>
References: <20221010150829.199676-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zcbitiktxcidjbv2"
Content-Disposition: inline
In-Reply-To: <20221010150829.199676-1-extja@kvaser.com>
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


--zcbitiktxcidjbv2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.10.2022 17:08:25, Jimmy Assarsson wrote:
> Changes in v5:
>  - Split series [1], keept only critical bug fixes that should go into
>    stable, since v4 got rejected [2].
>    Non-critical fixes are posted in a separate series.

Looks much better now. Added to linux-can/main.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zcbitiktxcidjbv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNFE9sACgkQrX5LkNig
011M7Af+OR297o5tgXYrzju+6oGAPkfxisg0d7gDb3OqlHHaYUpHbwCtf/0xmnzr
dwJ2oXyMdn6UW8R142YXQSfZzlYbPWMyld/JS7VC80IzVyUqxMpjR1Bkn9L3EtCx
EbgpnzXF/SixttsfRp5Yw+zFUgB7fes3bZaqQUEWWiNWr4zabKagFG+b7VJIgaGb
l6pjNE514S+xPYuZYHlr3NNPiF6AWjURF98ZcCYBSCJRioZ0rMCOwBk3xWCdMyed
zGER/IG7rkyzVST8OsYiYeqBMuuS4k45wZC1TS+5lTLxHZIkD+SoIxGuqNZZpZ5C
0JofmRq/QYSnIvB6CiEBb+OQBtXqAg==
=L4z0
-----END PGP SIGNATURE-----

--zcbitiktxcidjbv2--
