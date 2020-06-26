Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B12620B2C7
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFZNpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:45:11 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38994 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZNpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 09:45:11 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AC7A91C0BD2; Fri, 26 Jun 2020 15:45:09 +0200 (CEST)
Date:   Fri, 26 Jun 2020 15:45:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jayshri Pawar <jpawar@cadence.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.7 264/477] usb: gadget: Fix issue with
 config_ep_by_speed function
Message-ID: <20200626134509.GB29985@duo.ucw.cz>
References: <20200623195407.572062007@linuxfoundation.org>
 <20200623195420.044538801@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20200623195420.044538801@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 5d363120aa548ba52d58907a295eee25f8207ed2 ]
>=20
> This patch adds new config_ep_by_speed_and_alt function which
> extends the config_ep_by_speed about alt parameter.
> This additional parameter allows to find proper
> usb_ss_ep_comp_descriptor.

>  drivers/usb/gadget/composite.c | 78 ++++++++++++++++++++++++++--------
>  include/linux/usb/composite.h  |  3 ++

It seems that (at least for 4.19) we applied rather big patch to
merge unused function.

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvX75QAKCRAw5/Bqldv6
8l4tAJ90ZvmlqbKOPmyWc0P8KUx2TrY6BgCgrI7VEggekYipeiTim9DYbpxDx24=
=dcLE
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
