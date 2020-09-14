Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8358D26866C
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 09:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgINHrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 03:47:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgINHrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 03:47:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 97F7C1C0B76; Mon, 14 Sep 2020 09:47:32 +0200 (CEST)
Date:   Mon, 14 Sep 2020 09:47:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 1/8] ALSA; firewire-tascam: exclude Tascam FE-8 from
 detection
Message-ID: <20200914074731.GA11659@amd>
References: <20200911125421.695645838@linuxfoundation.org>
 <20200911125421.771196664@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20200911125421.771196664@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
>=20
> Tascam FE-8 is known to support communication by asynchronous transaction
> only. The support can be implemented in userspace application and
> snd-firewire-ctl-services project has the support. However, ALSA
> firewire-tascam driver is bound to the model.

This one is in upstream, but is not marked as such. AFAICT it is
0bd8bce897b6697bbc286b8ba473aa0705fe394b.

Unfortunately it is too late to fix that now.

This one was scheduled to be released at "Responses should be made by
Sun, 13 Sep 2020 12:54:13 +0000.". But it was released day earlier:
"Date: Sat, 12 Sep 2020 14:42:49 +0200".

Could you actually follow published schedule? Could the schedule be
made a bit less agressive over the weekends?

Could you cc me release announcements on pavel@denx.de email?

Thanks and best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9fIBMACgkQMOfwapXb+vJTigCeKFaps7ePED8HaUvjFtxeGIGc
BbcAnRQTedv3xiKcipgx98qEEe6NUF5j
=xAIU
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
