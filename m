Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5840417931E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgCDPQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:16:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57678 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgCDPQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 10:16:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EFEB21C0321; Wed,  4 Mar 2020 16:15:59 +0100 (CET)
Date:   Wed, 4 Mar 2020 16:15:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Scott Wood <swood@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 05/87] sched/core: Dont skip remote tick for idle
 CPUs
Message-ID: <20200304151559.GB2367@duo.ucw.cz>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174349.478213998@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20200303174349.478213998@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 488603b815a7514c7009e6fc339d74ed4a30f343 ]
>=20
> This will be used in the next patch to get a loadavg update from
> nohz cpus.  The delta check is skipped because idle_sched_class
> doesn't update se.exec_start.

I don't see the next patch queued for 4.19-stable. AFAICT this does
not fix anything without the subsequent patch?

Best regards,
								Pavel
							=09
> Signed-off-by: Scott Wood <swood@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lkml.kernel.org/r/1578736419-14628-2-git-send-email-swood@r=
edhat.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXl/GLwAKCRAw5/Bqldv6
8g59AKCAkdRvWkI303NEB4XaL7ZHY5h8QgCgqIqZbp3BLrA4y5LiDCA5da1yh5Y=
=I9VM
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
