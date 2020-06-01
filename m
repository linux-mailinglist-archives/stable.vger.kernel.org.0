Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11401EB08A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFAU6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 16:58:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57294 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgFAU6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 16:58:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 929E81C0BD2; Mon,  1 Jun 2020 22:58:49 +0200 (CEST)
Date:   Mon, 1 Jun 2020 22:58:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 28/95] gfs2: dont call quota_unhold if quotas are
 not locked
Message-ID: <20200601205814.GA17898@amd>
References: <20200601174020.759151073@linuxfoundation.org>
 <20200601174025.297113760@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20200601174025.297113760@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bob Peterson <rpeterso@redhat.com>
>=20
> [ Upstream commit c9cb9e381985bbbe8acd2695bbe6bd24bf06b81c ]
>=20
> Before this patch, function gfs2_quota_unlock checked if quotas are
> turned off, and if so, it branched to label out, which called
> gfs2_quota_unhold. With the new system of gfs2_qa_get and put, we
> no longer want to call gfs2_quota_unhold or we won't balance our
> gets and puts.
>=20
> Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

4.19 does not yet contain gfw2_qa_get; according to the changelog that
means that this patch is not suitable for 4.19 kernel.

Best regards,
                                                                Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7Va+UACgkQMOfwapXb+vI1EQCgtD7V3nevWA+1nvVi53q31te+
pg8An2LddBjhbY6uwo3gNn92Gp16thkY
=LZ7Y
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
