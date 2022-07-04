Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA080565690
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiGDNH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiGDNHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:07:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B09DEC1
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:07:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8Lnj-0004Fg-6J; Mon, 04 Jul 2022 15:07:43 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-9ec8-2378-47c2-fbd7.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:9ec8:2378:47c2:fbd7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 964AAA7C3C;
        Mon,  4 Jul 2022 13:07:42 +0000 (UTC)
Date:   Mon, 4 Jul 2022 15:07:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jimmy Assarsson <extja@kvaser.com>
Cc:     linux-can@vger.kernel.org,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 0/3] can: kvaser_usb: CAN clock frequency regression
Message-ID: <20220704130742.aeczqfbfnwemb7ax@pengutronix.de>
References: <20220603083820.800246-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jk3ggiaspqsqf5g4"
Content-Disposition: inline
In-Reply-To: <20220603083820.800246-1-extja@kvaser.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jk3ggiaspqsqf5g4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2022 10:38:17, Jimmy Assarsson wrote:
> When fixing the CAN clock frequency,
> fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device"),
> I introduced a regression.
>=20
> For Leaf devices based on M32C, the firmware expects bittiming parameters
> calculated for 16MHz clock. Regardless of the actual clock frequency.
>=20
> This regression affects M32C based Leaf devices with non-16MHz clock.
>=20
> Also correct the bittiming constants in kvaser_usb_leaf.c, where the limi=
ts
> are different depending on which firmware/device being used.
>=20
> Once merged to mainline, I'll backport these fixes for the stable kernels.

Added to linux-can/testing. I had to move the kvaser_usb_driver_info
into kvaser_usb_core.c and the keep struct can_bittiming_const
kvaser_usb_flexc_bittiming_const in kvaser_usb_hydra.c as structs in
header files cause defined but not used warnings on some platforms.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jk3ggiaspqsqf5g4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLC5hsACgkQrX5LkNig
013Obwf9GKOY0FnDPwrS73id/0FrnFW6T/5aXnTotaMVmFvgxxf91WbRCOhkFYfs
6XKeqmiOTaU8Hjs0fn9ABLIDK/FNq81878oQrGKVm9DyGndwTjPBaBs9D2VrRnb5
w0O8Fb9eiF7+BoZCh6b1F8C4dB4PMF5TajnwCYYzQWaghRt/LJC9Y8PqDVFlfYdk
8uIkV7RNxBu1Vt/xM18JO92A51M8Iuk5dqn9Lcfz5wtaJeI0MkP4z4GZIwMGstui
DcR11YDvZ3ny1DXHluM5F+zovNLb7LWW2q110UiV9hdxn60WYkPmhTNB53zYSWYO
PYqVIeg1Ea+jaRthysiBUFP83tDt1A==
=l367
-----END PGP SIGNATURE-----

--jk3ggiaspqsqf5g4--
