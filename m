Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEFF285C06
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgJGJrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:47:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49870 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgJGJrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 05:47:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 851081C0B7A; Wed,  7 Oct 2020 11:47:37 +0200 (CEST)
Date:   Wed, 7 Oct 2020 11:47:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yu Kuai <yukuai3@huawei.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 27/38] iommu/exynos: add missing put_device() call
 in exynos_iommu_of_xlate()
Message-ID: <20201007094737.GA12593@duo.ucw.cz>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.977461657@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20201005142109.977461657@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Yu Kuai <yukuai3@huawei.com>
>=20
> [ Upstream commit 1a26044954a6d1f4d375d5e62392446af663be7a ]
>=20
> if of_find_device_by_node() succeed, exynos_iommu_of_xlate() doesn't have
> a corresponding put_device(). Thus add put_device() to fix the exception
> handling for this function implementation.

Okay, this looks reasonable, but...

Do we miss put_device() in normal path, too? I'd expect another
put_device at end of exynos_iommu_of_xlate() or perhaps in release
path somewhere...

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX32OuQAKCRAw5/Bqldv6
8sU0AJ9rrfMHwe6nVHIddM9aZpeNhn33bwCfcs/uzk9WpIzSw2sPucOCtrOEaQc=
=udAK
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
