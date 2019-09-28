Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44449C11BE
	for <lists+stable@lfdr.de>; Sat, 28 Sep 2019 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfI1SYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Sep 2019 14:24:33 -0400
Received: from sauhun.de ([88.99.104.3]:36584 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfI1SYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Sep 2019 14:24:33 -0400
Received: from localhost (unknown [46.183.103.17])
        by pokefinder.org (Postfix) with ESMTPSA id 4122B2C0489;
        Sat, 28 Sep 2019 20:24:30 +0200 (CEST)
Date:   Sat, 28 Sep 2019 20:24:29 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Chris Brandt <chris.brandt@renesas.com>
Cc:     linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org,
        Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Subject: Re: [PATCH v2] i2c: riic: Clear NACK in tend isr
Message-ID: <20190928182423.GC12219@kunai>
References: <20190926121909.1795-1-chris.brandt@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <20190926121909.1795-1-chris.brandt@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2019 at 07:19:09AM -0500, Chris Brandt wrote:
> The NACKF flag should be cleared in INTRIICNAKI interrupt processing as
> description in HW manual.
>=20
> This issue shows up quickly when PREEMPT_RT is applied and a device is
> probed that is not plugged in (like a touchscreen controller). The result
> is endless interrupts that halt system boot.
>=20
> Fixes: 310c18a41450 ("i2c: riic: add driver")
> Cc: stable@vger.kernel.org
> Reported-by: Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
> Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
>=20

Applied to for-current, thanks!


--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl2PpVcACgkQFA3kzBSg
KbZtXw/+LLgzjDx2AqGztOvytSm+LJzDaDWx5E1ZHDGJuAnuU167yv4u+4Uxcx9S
4u3zG7ZlniHvRNu1fKz8/0QcRtiJMnwqupjHFRzf6v3xFluRsNPykYL9YipNgUgZ
clNCGxJjhEeaqLxHCP9XR2LtZMbiukafQTp+bbaa1YJM4JwPIwGDc5QasdbdP4/0
C6+KRSRkBhgL+VFtZUL21UwXxUkAem2q/pQtA08/Vrk3Uvu5tcLTJytn+kqOBPvh
lcvRQ080lapDUVrLzsZqk7fHQvBpxwXAZliaGwmCGtqMDgeCHdyisblXqNFWO1bE
jTqnm27un/h7SZxVhc1mRUv0uWSHn1V3fGP1yXGWhk1LfSAgJFefck/eZZovXjsh
KUFR5lxn1y728z++2lI+djH419C0zpTkMWqgZO/0zT8H2Wc6zkC1BGGCxxSJe6Dc
V2ZHEeZPgaQAngDeAGTU0zIzVYzhHcUUfi6L8JvemkEtYF+7H36aJhgjNyEz4/KT
SvUOOfT9yg3havUBGkcFf/mFwb2vPe0+AdoNbvOhEN9zFO0GD3DQXPKwxZdHKNuJ
Ah376vQkTWehzK9XBJl3GlzQKam+6YS6YeZHuhKo2QNEhiZ0e7/We09x99vgkzsX
46OUdWg4dtMBCdJ4NYcfMdBYb9oeu7+LAB3qAomREPB9KrkCfd4=
=sGSV
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
