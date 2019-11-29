Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3710310DB75
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 23:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfK2WYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 17:24:04 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33876 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfK2WYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 17:24:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 583241C24D4; Fri, 29 Nov 2019 23:24:02 +0100 (CET)
Date:   Fri, 29 Nov 2019 23:24:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 185/306] net: hns3: bugfix for buffer not free
 problem during resetting
Message-ID: <20191129222401.GA29788@amd>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203128.798931840@linuxfoundation.org>
 <20191129110010.GA4313@amd>
 <20191129143108.GA3708972@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20191129143108.GA3708972@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Huazhong Tan <tanhuazhong@huawei.com>
> > >=20
> > > [ Upstream commit 73b907a083b8a8c1c62cb494bc9fbe6ae086c460 ]
> > >=20
> > > When hns3_get_ring_config()/hns3_queue_to_ring()/
> > > hns3_get_vector_ring_chain() failed during resetting, the allocated
> > > memory has not been freed before these three functions return. So
> > > this patch adds error handler in these functions to fix it.
> >=20
> > Correct me if I'm wrong, but... this introduces use-after-free:
> > Should it do devm_kfree(&pdev->dev, cur_chain); ?
>=20
> I think Sasha tried to backport a fix for this patch, but that fix broke
> the build :(
>=20
> If you want to provide a working backport, I'll be glad to take it.

Actually it looks like problem originated in mainline, and there was
more than one problem with this patch.

cda69d244585bc4497d3bb878c22fe2b6ad647c1 should fix it; it needs to be
back-ported, too.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3hmoEACgkQMOfwapXb+vJv5gCfd6CimahNgIuEDhSzw0ZWZyCO
crkAnRl/MyQICWG8uNdj5c/qXiS6pV+m
=SJcZ
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
