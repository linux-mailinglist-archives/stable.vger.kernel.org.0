Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386A5458532
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 17:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhKURC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 12:02:57 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:41570 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbhKURC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 12:02:56 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6A62E1C0B76; Sun, 21 Nov 2021 17:59:50 +0100 (CET)
Date:   Sun, 21 Nov 2021 17:59:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10 03/21] loop: Use blk_validate_block_size() to
 validate block size
Message-ID: <20211121165949.GA19702@duo.ucw.cz>
References: <20211119171443.892729043@linuxfoundation.org>
 <20211119171444.002617211@linuxfoundation.org>
 <20211119214522.GA23353@amd>
 <YZimRBMpcbcLMCJN@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <YZimRBMpcbcLMCJN@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2021-11-20 08:39:48, Greg Kroah-Hartman wrote:
> On Fri, Nov 19, 2021 at 10:45:22PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > commit af3c570fb0df422b4906ebd11c1bf363d89961d5 upstream.
> > >=20
> > > Remove loop_validate_block_size() and use the block layer helper
> > > to validate block size.
> >=20
> > This is just a cleanup, and it needs previous cleanup to be
> > applied. I would not mind if both were dropped from stable series.
>=20
> No, it is not a cleanup, it fixes a real bug as reported on the stable
> mailing list.

Aha:
https://lore.kernel.org/all/7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org/

Thanks for explanation.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYZp7BQAKCRAw5/Bqldv6
8nxrAJ9U9uSCJ5hTE89nwDSK2xkBAHHvNwCeNzttJnvtfoc2JZ/0KpDz9BcyXZk=
=0UcK
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
