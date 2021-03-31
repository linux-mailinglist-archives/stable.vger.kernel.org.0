Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A70934F9A7
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 09:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhCaHSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 03:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231523AbhCaHSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Mar 2021 03:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B08619AB;
        Wed, 31 Mar 2021 07:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617175118;
        bh=8beEdFjtCAW+MZgiUCa4tYu3TEKJK3jHtRssNTqgmzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXCYOT31EaTt/xV9uUEkFHglHFUrw+VWuEQuvaHKqZLdUmbw7D7kdlu9IROqbck16
         iA7R7qVtoxa28s/80+yANQSBa4vLQfdPkD/iWkjPPG+1kYascbEQfdg9Rto3bx2m+I
         CDAF7HKX1FPEdK1soNI08hOeMLDQaRaPoRgkDH17T6TStzwfw8Jr8T4c0v1NGSZ0am
         Kr3WqslciQUHKP9sTrjz/swTsIs0CvKu5KTNwxyboH3lRA7n1BmCdwQHICgF8q36bU
         pnISfbtIxzIkgkpIhsOp9Wv3pdwjLMehEFIIzokDUIKi04qe4d4MHSA/8eubIzNCXC
         YHx/BtlWydN7g==
Date:   Wed, 31 Mar 2021 09:18:35 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc:     paul@crapouillou.net, stable@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, sernia.zhou@foxmail.com
Subject: Re: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
Message-ID: <20210331071835.GB1025@ninjato>
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
 <20210318170623.GA1961@ninjato>
 <644d19d8-9444-4dde-a891-c9dfd523389e@wanyeetech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <644d19d8-9444-4dde-a891-c9dfd523389e@wanyeetech.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,=20

> > Any write operation? I wonder then why nobody noticed before?
>=20
>=20
> The standard I2C communication should look like this:
>=20
> Read:
>=20
> device_addr + w, reg_addr, device_addr + r, data;
>=20
> Write:
>=20
> device_addr + w, reg_addr, data;
>=20
>=20
> But without this patch, it looks like this:
>=20
> Read:
>=20
> device_addr + w, reg_addr, device_addr + r, data;
>=20
> Write:
>=20
> device_addr + w, reg_addr, device_addr + w, data;
>=20
> This is clearly not correct.

Thanks for the additional information! I understand now. I added a bit
of this to the commit message of v2 to explain the situation.


--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmBkIksACgkQFA3kzBSg
KbZykQ//eDkcN/ZQvGDP0emgsNO6lU3HtajHI/lRiW/APQ3o+w69CqfEgOtbnJ00
5Kf0rOkFKeeuMNlv7xZNLOxJoq+V52e1g0S5m5DsVkFFL5rxmfYfBdOAChGoCzHp
6AfwU+QJjG0ETWgEq/4Wh8wqPbIYeYtATkJA8FcFQEu1bAA5JyGr/xuNNToTd/ln
PDpoJ0laVjU5ADjQJUBZSctEW07TfdOPumwVYmmpoAtmbc/O26aGp9R/ptZGMxVV
vTSVI2ghYL70Maoom42YfBQHUNVgqyU14jBw24Jkhu3+lB/B2IHszjG/qyRlEjTM
gHcu1wSPrXtKGjcicqFU/DVcJviOOZqni2la1ExLkuXE3xVOERAfcMZWZ05C410P
kB+YWBa5qE3iZllEgDN7f55SXZNX4kT7QpV6o/KGtJ6kPmQtPAb5X/9yTe69ogSe
PSaNpicjhmiUmgKh+Zu3ttxDREZNmhIbX6h1YMkYN1Ocz8PG9l42zRuFRLnqqRND
zcSIlK2PfO2XWYXaSNqo3weN66/oLX6kRjJSsTLpsfkuMU0SqE3LFjjqeCJRIEtP
v2okUgzFcqL9YuyQrwklbUxZ9fe4/cXpsHqwzpFPqlbgyqa16oxzIuNOQ/AG0M3S
m7s+bQ566uplLlH/VWW+Kg5Ak70k4tuAZCNB5Z2TaTRmpVO/02Y=
=cthv
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
