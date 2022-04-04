Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A301F4F1AFA
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379331AbiDDVTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380281AbiDDT2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:28:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B44026AD7
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:26:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nbSLT-0004Yo-Fg; Mon, 04 Apr 2022 21:26:35 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-3524-91ca-8473-ba45.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:3524:91ca:8473:ba45])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 027345A44E;
        Mon,  4 Apr 2022 19:26:34 +0000 (UTC)
Date:   Mon, 4 Apr 2022 21:26:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     hbh25y@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: usb_8dev: usb_8dev_start_xmit(): fix
 double" failed to apply to 5.10-stable tree
Message-ID: <20220404192634.wgqggbo5dbbq4ri2@pengutronix.de>
References: <1648815684224177@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tswiwplkvf3oh4w7"
Content-Disposition: inline
In-Reply-To: <1648815684224177@kroah.com>
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


--tswiwplkvf3oh4w7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.04.2022 14:21:24, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Done - should be available at:

| https://lore.kernel.org/all/20220404192536.1243729-1-mkl@pengutronix.de/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tswiwplkvf3oh4w7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJLRmgACgkQrX5LkNig
013A+gf/dFk6J35C9uv5QC2h35RH4j8ERGJDRdtwer/Fi3ni/qEg5IFszoqNtjKA
GgbkrwyqcYEgGlFraqwkmF6hbwWYPsSFKT+1FlEu2XJ9BCSVu3unETOW6lB6OtEE
gwfn95mWnVDZHkQHJMbshDpUJh08MIAtHmWFDVJfmWAcNDUOf950eIHhDkFll6Fp
rfNLSl+7jvJeQfoIdDo3HKXWNOMRbkvR7RkVHdADX7txdM0FbX8awKpF2Gq0r9YN
p0xJAASfUeO0WxS26VvQPwWecGDjltt4ObWFzRGax9O+BMjDafXiG4QtqkUfqCqL
w2qzqpFkXN3dUPw9YNVpHCq/K1c1/w==
=Nk4e
-----END PGP SIGNATURE-----

--tswiwplkvf3oh4w7--
