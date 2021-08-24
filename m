Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5763F6941
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 20:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhHXSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 14:55:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhHXSzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 14:55:39 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 30D6D1C0B7A; Tue, 24 Aug 2021 20:54:53 +0200 (CEST)
Date:   Tue, 24 Aug 2021 20:54:52 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH 5.10 10/98] vdpa: Define vdpa mgmt device, ops and a
 netlink interface
Message-ID: <20210824185452.GA15995@duo.ucw.cz>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210824165908.709932-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20210824165908.709932-11-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Parav Pandit <parav@nvidia.com>
>=20
> [ Upstream commit 33b347503f014ebf76257327cbc7001c6b721956 ]
>=20
> To add one or more VDPA devices, define a management device which
> allows adding or removing vdpa device. A management device defines
> set of callbacks to manage vdpa devices.
>=20
> To begin with, it defines add and remove callbacks through which a user
> defined vdpa device can be added or removed.

This looks quite intrusive; is it meant to be in -stable, or is it
some kind of mistake?

Best regards,
									Pavel
								=09

> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Eli Cohen <elic@nvidia.com>
> Reviewed-by: Jason Wang <jasowang@redhat.com>
> Link: https://lore.kernel.org/r/20210105103203.82508-4-parav@nvidia.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>=20
> Including a bugfix:
>=20
> vpda: correctly size vdpa_nl_policy
>=20
> We need to ensure last entry of vdpa_nl_policy[]
> is zero, otherwise out-of-bounds access is hurting us.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Parav Pandit <parav@nvidia.com>
> Cc: Eli Cohen <elic@nvidia.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Link: https://lore.kernel.org/r/20210210134911.4119555-1-eric.dumazet@gma=
il.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/vdpa/Kconfig      |   1 +
>  drivers/vdpa/vdpa.c       | 213 +++++++++++++++++++++++++++++++++++++-
>  include/linux/vdpa.h      |  31 ++++++
>  include/uapi/linux/vdpa.h |  31 ++++++
>  4 files changed, 275 insertions(+), 1 deletion(-)
>  create mode 100644 include/uapi/linux/vdpa.h

--=20
http://www.livejournal.com/~pavelmachek

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSVAfAAKCRAw5/Bqldv6
8qy0AJ9Tg8+8GX4JgBwFkgsCWSgTB4SNVACffFIqORPcMOWxfLIoNZ4x6OOipXY=
=RNQq
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
