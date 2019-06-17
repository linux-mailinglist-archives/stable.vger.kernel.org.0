Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE2490A6
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 21:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfFQT4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 15:56:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfFQT4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 15:56:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E39EA30872F3;
        Mon, 17 Jun 2019 19:56:38 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAF7180939;
        Mon, 17 Jun 2019 19:56:36 +0000 (UTC)
Message-ID: <92ef28dedfbe5adf7928caceeaa79b452492f44d.camel@redhat.com>
Subject: Re: [PATCH] RDMA/odp: Fix missed unlock in non-blocking
 invalidate_start
From:   Doug Ledford <dledford@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>, stable@vger.kernel.org
Date:   Mon, 17 Jun 2019 15:56:34 -0400
In-Reply-To: <20190612161536.GS6369@mtr-leonro.mtl.com>
References: <20190611160951.23135-1-jgg@ziepe.ca>
         <20190612161536.GS6369@mtr-leonro.mtl.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZWPd+e+sfldX6aOXW9Rd"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 17 Jun 2019 19:56:39 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ZWPd+e+sfldX6aOXW9Rd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-06-12 at 19:15 +0300, Leon Romanovsky wrote:
> On Tue, Jun 11, 2019 at 01:09:51PM -0300, Jason Gunthorpe wrote:
> > From: Jason Gunthorpe <jgg@mellanox.com>
> >=20
> > If invalidate_start returns with EAGAIN then the umem_rwsem needs
> > to be
> > unlocked as no invalidate_end will be called.
> >=20
> > Cc: <stable@vger.kernel.org>
> > Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm-
> > >notifier_count")
> > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > ---
> >  drivers/infiniband/core/umem_odp.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-ZWPd+e+sfldX6aOXW9Rd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0H8HIACgkQuCajMw5X
L91AnxAAgivoNirOgguwm5USGyeORAmKQo2bF3OadlT7XFwv1DEj8Vp0Cx27u0Hb
oxzMn0V0HJ4CH142yS2bX8N7dhbzXmWqUs7/9n/yTufXHQOy3FB8l3Iu6MirmvCL
iromXBKfVaFltxCXgpfHugk+76RRQgZevbjg3+NUfYqGVBp/98WKMdzJVo9oMmzO
p+MrWpYR5/1xnm1XFdfmpGxrubZzhX/jNcgmlESD5BWEcqAIP+WFk11x4JthuH7J
9uzgSbToQpiCd+qqoVael3yMbZBI5/zM0D5AdIfW6N8HWEpjH4y9HyN9r4xEj1ga
cOAHYUfUCulzGkWrwq3Z+LvDzCirshsAmC+Zltmk3chSg//cyoHvj09XJvIVgK3P
MMIJweBePpyrQ3uWW2o6SE5/uD3L/uHflyw5iHhFjXSrETNJzowJccE+zA6mEP0M
k5k7TpZx/lnW2gvhLDyADydDhbbXORNTt738oK1G4pujKt3+M9kYLALhbgfqjlXC
vSiBBDwZm0lJAxp+nCXtUBS3ZgsVmIrS1wyj59z24Txaqj8NGyJ3bIuAAOuiZ650
Pn+8uZzKjU/TQ/1iGtt0hKIOPSPZOQBJZPN634F6tBntrsgvpQfGhuuGfJiUe8L9
FiF1818NEdXftBDQBj7u+CmESbI2dWVHJNynO87TwY68sgNvl0I=
=AFTM
-----END PGP SIGNATURE-----

--=-ZWPd+e+sfldX6aOXW9Rd--

