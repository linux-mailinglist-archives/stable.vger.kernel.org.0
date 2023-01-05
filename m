Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D9F65E7E1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 10:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjAEJcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 04:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjAEJca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 04:32:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA24551D2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 01:32:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pDMbr-0000OK-CO; Thu, 05 Jan 2023 10:32:27 +0100
Received: from pengutronix.de (hardanger-2.fritz.box [IPv6:2a03:f580:87bc:d400:f8ae:feaa:aa7a:50b8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8D05F14ED02;
        Thu,  5 Jan 2023 09:32:26 +0000 (UTC)
Date:   Thu, 5 Jan 2023 10:32:26 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] can: isotp: handle wait_event_interruptible() return
 values
Message-ID: <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
References: <20230104164605.39666-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ruasmcjo5skxk6ew"
Content-Disposition: inline
In-Reply-To: <20230104164605.39666-1-socketcan@hartkopp.net>
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


--ruasmcjo5skxk6ew
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.01.2023 17:46:05, Oliver Hartkopp wrote:
> When wait_event_interruptible() has been interrupted by a signal the
> tx.state value might not be ISOTP_IDLE. Force the state machines
> into idle state to inhibit the timer handlers to continue working.
>=20
> Cc: stable@vger.kernel.org # >=3D v5.15
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Can you add a Fixes: tag?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ruasmcjo5skxk6ew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmO2mScACgkQrX5LkNig
013W+wf+PTYpoxIbAkat1orcNosmmcQPR9zPrOV2Ym1cvvcx/8NLwNfUllT0J7LI
iCS8G6VbX3IoKF7dzGXSrKILEAcl7vsb3885dZqyFHMzRiZPbA46MjTkzcDd79Bq
3BAfssLPxvZsQdSzMK0E6SfXBZ+45ZJYs/HRgnAscHVUxZaOFePsKMekuiPhko+h
1VcPAlLnRzwxT7mSdmaJg1mpaaamRJEmi+jkFVi8uyuMe88Euk1xLS61tHkYoB22
M2tleKiw/V0IF/DT1UonVdaa8CIAecV5qAVlUTA6CbXJuoeCI6GUtCyQDa5LNVVa
cxUpB6Qy4ubRmmJT+il8YsU3L4Bunw==
=QOCQ
-----END PGP SIGNATURE-----

--ruasmcjo5skxk6ew--
