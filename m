Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42E611F103
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 09:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfLNInd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 03:43:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37070 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfLNInd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Dec 2019 03:43:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7D1331C25FC; Sat, 14 Dec 2019 09:43:31 +0100 (CET)
Date:   Sat, 14 Dec 2019 09:43:31 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 034/134] leds: trigger: netdev: fix handling
 on interface rename
Message-ID: <20191214084331.GD16834@duo.ucw.cz>
References: <20191211151150.19073-1-sashal@kernel.org>
 <20191211151150.19073-34-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x4pBfXISqBoDm8sr"
Content-Disposition: inline
In-Reply-To: <20191211151150.19073-34-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x4pBfXISqBoDm8sr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-12-11 10:10:10, Sasha Levin wrote:
> From: Martin Schiller <ms@dev.tdt.de>
>=20
> [ Upstream commit 5f820ed52371b4f5d8c43c93f03408d0dbc01e5b ]
>=20
> The NETDEV_CHANGENAME code is not "unneeded" like it is stated in commit
> 4cb6560514fa ("leds: trigger: netdev: fix refcnt leak on interface
> rename").
>=20
> The event was accidentally misinterpreted equivalent to
> NETDEV_UNREGISTER, but should be equivalent to NETDEV_REGISTER.
>=20
> This was the case in the original code from the openwrt project.
>=20
> Otherwise, you are unable to set netdev led triggers for (non-existent)
> netdevices, which has to be renamed. This is the case, for example, for
> ppp interfaces in openwrt.

Please drop.
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--x4pBfXISqBoDm8sr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfSgswAKCRAw5/Bqldv6
8gduAJ9Lu1crg0JOc3VxbN0IycADWiBfQQCgpZAKA5szYroZKAauiMcPMTgIzzE=
=xFie
-----END PGP SIGNATURE-----

--x4pBfXISqBoDm8sr--
