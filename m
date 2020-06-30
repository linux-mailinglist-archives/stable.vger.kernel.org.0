Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB0820FF6A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 23:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgF3Vqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 17:46:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53674 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgF3Vqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 17:46:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1E3111C0C22; Tue, 30 Jun 2020 23:46:35 +0200 (CEST)
Date:   Tue, 30 Jun 2020 23:46:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/59] 4.9.226-rc2 review
Message-ID: <20200630214634.GC7113@duo.ucw.cz>
References: <20200602101841.662517961@linuxfoundation.org>
 <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
 <20200602163346.GQ1407771@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <20200602163346.GQ1407771@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >FWIW, if we need/want to use unified assembler in v4.9.y, shouldn't all =
unified
> >assembler patches be applied ?
>=20
> We don't - I took 71f8af111010 as a dependency rather than on its own
> merit.

Would it be possible to somehow mark patches that are "dependency"
rather than "on their own"? It would make review easier...

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvuyugAKCRAw5/Bqldv6
8iO5AJ9XuAJo4ZWaeXYBiOAnD+HhWlXGjgCgty3sJ8+qdw0rtpH4fB7+DHjUNgk=
=rFA0
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
