Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E8229767
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 13:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgGVL2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 07:28:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47138 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730405AbgGVL2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 07:28:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7A46E1C0BD8; Wed, 22 Jul 2020 13:28:35 +0200 (CEST)
Date:   Wed, 22 Jul 2020 13:28:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 4.19 034/133] iio:humidity:hts221 Fix alignment and data
 leak issues
Message-ID: <20200722112835.GB22052@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.365344523@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20200720152805.365344523@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>=20
> commit 5c49056ad9f3c786f7716da2dd47e4488fc6bd25 upstream.
>=20
> One of a class of bugs pointed out by Lars in a recent review.
> iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
> to the size of the timestamp (8 bytes).  This is not guaranteed in
> this driver which uses an array of smaller elements on the stack.

I don't see documentation explaining alignment issues with
iio_push_to_buffers_with_timestamp(). Perhaps comment near that
function should explain that?

And as it seems to be common problem, perhaps
iio_push_to_buffers_with_timestamp should check alignment of its
arguments?

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxgi4wAKCRAw5/Bqldv6
8p7LAJ4pnvnOAWe6DEydoxNqzkUemwCCMwCfewBOfeS3g7+syjtJ5uGuOOn2pXE=
=PesH
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
