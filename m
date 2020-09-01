Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDA259EFD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 21:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgIATMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 15:12:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48246 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbgIATMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 15:12:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 23D1F1C0B7F; Tue,  1 Sep 2020 21:12:11 +0200 (CEST)
Date:   Tue, 1 Sep 2020 21:12:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+34ee1b45d88571c2fa8b@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 124/125] HID: hiddev: Fix slab-out-of-bounds write
 in hiddev_ioctl_usage()
Message-ID: <20200901191209.GB5295@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150940.687698839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <20200901150940.687698839@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 25a097f5204675550afb879ee18238ca917cba7a upstream.
>=20
> `uref->usage_index` is not always being properly checked, causing
> hiddev_ioctl_usage() to go out of bounds under some cases. Fix it.

Well, the code is quite confusig, but:

a) does HIDIOCGCOLLECTIONINDEX need same checking?

b) should we check this using some kind of _nospec() variant to
prevent speculation attacks?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX06dCQAKCRAw5/Bqldv6
8vuOAJ9twBP5YeB7z+SZcVfL21PpnbcJ+wCgg40ZpMaVUuOl6f1ZGFM26VrJb7s=
=Mpeu
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
