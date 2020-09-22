Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF5274A17
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIVUYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:24:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56764 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVUYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:24:08 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F26961C0B8B; Tue, 22 Sep 2020 22:24:03 +0200 (CEST)
Date:   Tue, 22 Sep 2020 22:24:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4.19 43/49] Input: trackpoint - add new trackpoint
 variant IDs
Message-ID: <20200922202403.GA10773@duo.ucw.cz>
References: <20200921162034.660953761@linuxfoundation.org>
 <20200921162036.567357303@linuxfoundation.org>
 <20200922153957.GB18907@duo.ucw.cz>
 <20200922161642.GA2283857@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20200922161642.GA2283857@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-09-22 18:16:42, Greg Kroah-Hartman wrote:
> On Tue, Sep 22, 2020 at 05:39:57PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Vincent Huang <vincent.huang@tw.synaptics.com>
> > >=20
> > > commit 6c77545af100a72bf5e28142b510ba042a17648d upstream.
> > >=20
> > > Add trackpoint variant IDs to allow supported control on Synaptics
> > > trackpoints.
> >=20
> > This just adds unused definitions. I don't think it is needed in
> > stable.
>=20
> It add support for a new device.

No, it does not. Maybe in mainline there's followup patch that adds
such support, but that's not in 4.19.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2pdYwAKCRAw5/Bqldv6
8hVeAJwJhd7vEVASA7niH1ypU+Uclj+bJQCgtAAkDQEUALYZzQ39laMlnDBIe+c=
=RidB
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
