Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD525841E9
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 03:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfHGBu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 21:50:27 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:34376 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfHGBu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 21:50:27 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2019 21:50:27 EDT
Received: from chianamo (unknown [114.111.153.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 96BCB18039D;
        Tue,  6 Aug 2019 21:42:04 -0400 (EDT)
Message-ID: <c835c71b722c3df3d11e7b7f8fd65bbd7da0d482.camel@bonedaddy.net>
Subject: Re: [PATCH AUTOSEL 5.2 57/59] coredump: split pipe command
 whitespace before expanding template
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jakub Wilk <jwilk@jwilk.net>, Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20190806213319.19203-57-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
         <20190806213319.19203-57-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-9vrijft1q6Ih/4+n8s2l"
Date:   Wed, 07 Aug 2019 09:41:46 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-9vrijft1q6Ih/4+n8s2l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-06 at 17:33 -0400, Sasha Levin wrote:

> From: Paul Wise <pabs3@bonedaddy.net>
>=20
> [ Upstream commit 315c69261dd3fa12dbc830d4fa00d1fad98d3b03 ]

The patch changes the behaviour of the interface between the Linux
kernel and userspace core dump handlers. The previous behaviour was
unlikely to be depended on by any core dump handler but it is still a
behaviour change, so I think it would be best to keep it out of the
stable branches and would prefer to have folks encounter the change as
Linux distros etc roll out 5.3 and later into their dev releases.

We discussed this on #kernelnewbies a while ago and gregkh agreed that
it should stew a while longer before reaching any stable releases.

In addition if it gets backported to stable releases, my patch for
core(5) from man-pages will have to get more complicated :)

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-9vrijft1q6Ih/4+n8s2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAl1KLFcACgkQMRa6Xp/6
aaO9fRAAnNsoW6kI3MEIte62tmhVEx7PC/f2E1CHkOPaUJwlJFEIXkvQ9G35EXkT
5+hb++RC2BuhgHomoKL7OS8aD6nOHh5lehUlk7zqGbZ4U9krgH7zRve5IBF7TIxT
JFvwfwFggjsUm5QkvLBxTia4CP7ejbrku0KM5eqWcngFsx+gnzaJugC3pw+6Ilgz
Od7MuelAOzpOP9wIJenfmLBmrChHE3udG7gt8adtnIcCZ9t0/smEW2BZQCoA6lnq
Dnh+gzdPLFv07HJ0Y2awK9n6B3ccuxhUDzVPQpa29w/RfWyD9jOlDWr7qsYJcrAs
/XqiklHiDSuSrsOmpvUPTUyrKGh+pNCuhwmh2HU9mVK0dbRB/VtGdK0hpUFS3w61
MHvyvFBTHdwBw5LhrOh6Gk+nZgFxBuXJDLlafoAz5Q9o+AASgqc08uEWILVjOh6n
B9faOn06bTHLEvnuDxbk3e/fwh6GlnaR3SdqLP7nGv4GIGIsaNtjNR1JrU7hSlsQ
9QJwC0hDrBG66SKbjGkEnJYxTApppc+/WyhXz/gXw+BGemJR/XVsitEOJsW1CkDn
nhGoz65cun8dCXVxz5LU99z0wsoQfQReyApWxle4vwOuKJF7bb3VHBxX8iR0KZmk
NIgbiMHAPvfenSvoblgmFeIGf7kCmF+iwyV+/gLkshjM7v2rxjs=
=qv//
-----END PGP SIGNATURE-----

--=-9vrijft1q6Ih/4+n8s2l--

