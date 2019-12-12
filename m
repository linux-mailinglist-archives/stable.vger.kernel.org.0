Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE30211CCE5
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfLLMRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:17:50 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40678 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfLLMRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 07:17:50 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 136581C246E; Thu, 12 Dec 2019 13:17:48 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:17:47 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 130/350] power: supply: cpcap-battery: Check
 voltage before orderly_poweroff
Message-ID: <20191212121747.GA17876@duo.ucw.cz>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-91-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-91-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-10 16:03:55, Sasha Levin wrote:
> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit 639c1524da3b273d20c42ff2387d08eb4b12e903 ]
>=20
> We can get the low voltage interrupt trigger sometimes way too early,
> maybe because of CPU load spikes. This causes orderly_poweroff() be
> called too easily.
>=20
> Let's check the voltage before orderly_poweroff in case it was not
> yet a permanent condition. We will be getting more interrupts anyways
> if the condition persists.
>=20
> Let's also show the measured voltages for low battery and battery
> empty warnings since we have them.

This is a tweak of power management parameters, not a fix for serious
bug.

Plus, it needs a lot of testing it did not get, yet.

Please drop from stable.
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfIv6wAKCRAw5/Bqldv6
8neQAKCuma2iqj3Mcwse+dL2ttWbLhR9vACglinMiBDLg/OwKBaFGXYSaNEjmiI=
=7UBu
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
