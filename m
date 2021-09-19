Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923C3410CFC
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 21:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhISTGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 15:06:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34314 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhISTGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 15:06:08 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8D4BA1C0B79; Sun, 19 Sep 2021 21:04:41 +0200 (CEST)
Date:   Sun, 19 Sep 2021 21:04:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5.10 002/306] io_uring: limit fixed table size by
 RLIMIT_NOFILE
Message-ID: <20210919190441.GA12576@amd>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155753.989906303@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20210916155753.989906303@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Pavel Begunkov <asml.silence@gmail.com>
>=20
> Limit the number of files in io_uring fixed tables by RLIMIT_NOFILE,
> that's the first and the simpliest restriction that we should impose.
>=20
> Cc: stable@vger.kernel.org

5.13 and 5.14 backports do have "upstream" marking, but this one does
not. It is commit 3a1b8a4e843f96b636431450d8d79061605cf74b
upstream. But I guess it is too late to fix that.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director:    Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194    Groebenzell, Germany

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFHickACgkQMOfwapXb+vKlgACeI9upzf1xSpWam8eTAcHXOhh4
bCEAnAtv64rQuDix/srh55KehVOk87fw
=QNDh
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
