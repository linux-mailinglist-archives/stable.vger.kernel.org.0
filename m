Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58338DC65
	for <lists+stable@lfdr.de>; Sun, 23 May 2021 20:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhEWS0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 14:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhEWS0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 May 2021 14:26:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D389C061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 11:24:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lksmM-0005qv-JT; Sun, 23 May 2021 20:24:46 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:4062:af82:ca48:e761])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7B8CC629CEC;
        Sun, 23 May 2021 18:24:42 +0000 (UTC)
Date:   Sun, 23 May 2021 20:24:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Francois Gervais <fgervais@distech-controls.com>,
        linux-rtc@vger.kernel.org,
        Michael McCormick <michael.mccormick@enatel.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] rtc: pcf85063: fallback to parent of_node
Message-ID: <20210523182441.he5kqrlhargchaxw@pengutronix.de>
References: <20210310211026.27299-1-fgervais@distech-controls.com>
 <161861118020.865088.6364463756780633947.b4-ty@bootlin.com>
 <20210522153636.ymyyq4vtzz2dq5k2@pengutronix.de>
 <YKoQds5N0dP2Gjg5@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="55tqwaddqmsh55rc"
Content-Disposition: inline
In-Reply-To: <YKoQds5N0dP2Gjg5@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--55tqwaddqmsh55rc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.05.2021 10:21:10, Greg Kroah-Hartman wrote:
> On Sat, May 22, 2021 at 05:36:36PM +0200, Marc Kleine-Budde wrote:
> > > [1/1] rtc: pcf85063: fallback to parent of_node
> > >       commit: 03531606ef4cda25b629f500d1ffb6173b805c05
> > >=20
> > > I made the fallback unconditionnal because this should have been that=
 way from
> > > the beginning as you point out.
> >=20
> > can you queue this for stable, as it causes a NULL Pointer deref with
> > (at least) v5.12.
>=20
> After it hits Linus's tree, let stable@vger.kernel.org know the id and
> we will glad to add it to the stable trees.

It's in Linus's tree since v5.13-rc1~64^2~19 and the commit id is
03531606ef4c ("rtc: pcf85063: fallback to parent of_node").

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--55tqwaddqmsh55rc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCqnecACgkQqclaivrt
76kQKwf+MTBuPtLWQPRQawOmM1P/s4C8lSEdTEZVWhyCEBbDbhVoC19m7ORt/XT/
LUThURIUi1JZARW8H0Fohbr53iTRLpxlWSZrrfyA2ANz6DnoL0YyqmaCskuTTHSQ
zpxUweK7zYN0OhaOQXCNwRVREvFQX+QKyG7klhLoiMmY60R3N77Fyo5ahGl2eTa2
pb55anvkdLvwmp7g9oNgoW872MKNdG2b9lKcfXtFz0M8sFkXJKv2eVENlY6hWSMz
h2h/jiBEsi7LHhZ8/uBGpYo5mL/MqGZIYhO5Ci0z39xGB13XykWRzIT0yn9kbVcY
KqekXNnM5Fqy3ZYDsXtJq152CKefKA==
=0o5v
-----END PGP SIGNATURE-----

--55tqwaddqmsh55rc--
