Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5DC26BEEA
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgIPIQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:16:05 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38688 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPIQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:16:03 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 84A0D1C0B76; Wed, 16 Sep 2020 10:16:00 +0200 (CEST)
Date:   Wed, 16 Sep 2020 10:16:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 1/8] ALSA; firewire-tascam: exclude Tascam FE-8 from
 detection
Message-ID: <20200916081600.GD32537@duo.ucw.cz>
References: <20200911125421.695645838@linuxfoundation.org>
 <20200911125421.771196664@linuxfoundation.org>
 <20200914074731.GA11659@amd>
 <20200914075858.GA1035258@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <20200914075858.GA1035258@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Unfortunately it is too late to fix that now.
> >=20
> > This one was scheduled to be released at "Responses should be made by
> > Sun, 13 Sep 2020 12:54:13 +0000.". But it was released day earlier:
> > "Date: Sat, 12 Sep 2020 14:42:49 +0200".
> >=20
> > Could you actually follow published schedule?
>=20
> If all of the reported testing systems come back successful, there is no
> need to wait any longer.

Well, then perhaps you should not publish the schedule, as it is confusing?

> > Could you cc me release announcements on pavel@denx.de email?
>=20
> Will add you to the list, thanks.

Thank you,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2HJwAAKCRAw5/Bqldv6
8qpkAJoC1q0R+2oC4wD8SPkOeyfrID3JhQCdHKekskyYJ7d8JBVqVBzwI5kgY9Y=
=doZo
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
