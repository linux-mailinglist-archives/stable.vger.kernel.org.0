Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BCA274583
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIVPkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 11:40:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47062 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVPkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 11:40:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B78861C0B76; Tue, 22 Sep 2020 17:39:57 +0200 (CEST)
Date:   Tue, 22 Sep 2020 17:39:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4.19 43/49] Input: trackpoint - add new trackpoint
 variant IDs
Message-ID: <20200922153957.GB18907@duo.ucw.cz>
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162036.567357303@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20200921162036.567357303@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vincent Huang <vincent.huang@tw.synaptics.com>
>=20
> commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.
>=20
> Add trackpoint variant IDs to allow supported control on Synaptics
> trackpoints.

This just adds unused definitions. I don't think it is needed in
stable.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2oazQAKCRAw5/Bqldv6
8t5UAJ9i/9UakFJLc278tt771ExFDDR8vwCgpxQ/Cu7Thi3AlH2z4JPDUG7ktFc=
=HFp8
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
