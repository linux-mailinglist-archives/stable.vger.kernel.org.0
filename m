Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1286A891AA
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 14:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHKM2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 08:28:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60540 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfHKM2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 08:28:46 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwmxo-0007kS-KF; Sun, 11 Aug 2019 13:28:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwmxo-0001qp-F2; Sun, 11 Aug 2019 13:28:44 +0100
Message-ID: <490c54d7b488a0f0b5d55d60d46a7e2f627cef66.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 004/157] iio: Use kmalloc_array() in
 iio_scan_mask_set()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Jonathan Cameron <jic23@kernel.org>
Date:   Sun, 11 Aug 2019 13:28:39 +0100
In-Reply-To: <b8a167bfb3731a665ba54b4fa4ccf899a31d9644.camel@perches.com>
References: <lsq.1565469607.57202441@decadent.org.uk>
         <b8a167bfb3731a665ba54b4fa4ccf899a31d9644.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-DXQKGYxMyCrSBAhUUpBT"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-DXQKGYxMyCrSBAhUUpBT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-08-10 at 14:02 -0700, Joe Perches wrote:
> On Sat, 2019-08-10 at 21:40 +0100, Ben Hutchings wrote:
> > 3.16.72-rc1 review patch.  If anyone has any objections, please let
> > me know.
>=20
> Unless to enable applying further patches,
> I doubt there is ever a need to have any
> of Markus Elfring's patches applied to any
> -stable kernel.
[...]

I picked this in preparation for commit 20ea39ef9f2f "iio: Fix scan
mask selection".

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.


--=-DXQKGYxMyCrSBAhUUpBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1QCfcACgkQ57/I7JWG
EQl22Q//RzSjYv/Br1Vz0eQFEZxE4gqWvEBHkHbqMWmIgW+jN61yowgwng2pqv3F
vf7PAsT7jXPTpjyWWJyvEb9rRFsyCFll0dl4zUem6TmPBa+WlAFiBLvZeiILyuy6
L/rpENPohVkn93AIYfE79L/W1IuLbQ06/3O9eVo6wcu7dhOZPv6HV2vk//9AAAV5
nlUUhVdjGZrFYtCeJ2hIe6RkOiCEeTQ4c/39L5AV6D4nvB8XmCYjQ1YB5XbpejQp
z6TkKag57F5lh0aXIY08yK7qcbC2sqwzGSVqUIeDbjpM4RKvso3VG+726JX58Jjn
dSbK8ylHlswks+7XG2BLYzazV2ps8y+xjIu5FS0ROqKXAuIWk1XOGufJTwHmvXEp
yv52qvQILzGYloxUgnKTjnVSrboS240d9SnCySGAiaaySTlrXE/hvWCBCuWcyZYa
7qqIGntHGMHcfgLAnH2pqstYR0u5j924ukasTpFyzfW7S6L2EPlMUeoZazK0vgdX
sxsY+/4dlHzPMgWc6vgkgfTg+hW4mo/O5iUl5mtWtTZ15PC0LAGamxl/XvCRcz0z
maTyP2y2GRl3ulg5NW4MYkkadF8VnUpW4wT2I+/sJrfX2kJj2VNYyPAXekgvvxUE
L+JugcE1sm9TDCl8s6FX8iTV1o736SGcd2Bqht82Zpv2XW9Kal8=
=Mv8y
-----END PGP SIGNATURE-----

--=-DXQKGYxMyCrSBAhUUpBT--
