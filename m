Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7993A85B9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhFOP6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhFOP47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41EEA608FE;
        Tue, 15 Jun 2021 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772494;
        bh=L8bTOqo7KA+9IcGkt64VA1pcvn0+H8VF6Rsg+u5M0Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VOhcYfeMd9kMPw0gbr7RcZ0GCNof3c6mQDq527AAfbhgPWgXgZIVCUg8LPEgTRU+c
         tJYOwMOQy3XRenRJ4+CzDGrE152NOxatKBQ293Beve8gsoggiT3PUa4Yzw7nyrPY8W
         yRjAeMFU4NBGwZcDgCCffv1uHfW2iLnb+qIMxOTzdpyyEhX7E9pY7skm4TO/9v8f7O
         wRFBnBvm2QdFJC/4ZiOfrFNBfC/mfxCh8QPLpp4hwltsUOG793Q4ms4Flldp4Pom2Z
         tBWKNUuixjgAqGhpT6AD26CxBc+5zW+D4u2cpUuP7WvwaYy4RvepPisgZkIExMKmUm
         nVzgYq/dcG2Uw==
Date:   Tue, 15 Jun 2021 16:54:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 02/33] regulator: max77620: Silence deferred
 probe error
Message-ID: <20210615155436.GM5149@sirena.org.uk>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qgof7w7UksPF5inF"
Content-Disposition: inline
In-Reply-To: <20210615154824.62044-2-sashal@kernel.org>
X-Cookie: See store for details.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Qgof7w7UksPF5inF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 15, 2021 at 11:47:53AM -0400, Sasha Levin wrote:
> From: Dmitry Osipenko <digetx@gmail.com>
>=20
> [ Upstream commit 62499a94ce5b9a41047dbadaad885347b1176079 ]
>=20
> One of previous changes to regulator core causes PMIC regulators to
> re-probe until supply regulator is registered. Silence noisy error
> message about the deferred probe.

This really doesn't look like stable material...

--Qgof7w7UksPF5inF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDIzTsACgkQJNaLcl1U
h9AeAAf/X7cX3Hnuq4+91l5S2PBDfenr48Qqp+59oDHaw/Rf+W+zhf0fGiIUsUIB
851urvhCDyyL4pL8aRLrGhrX9jtaK4pG2QLoya9yDX+OkaIfMzSUQsgm8b3KpZx9
u8sd23hOfZbON7Nq5stOz81lScDzed9RreL/S8OFG9dFlZGsf65tDTUBK33C/MCI
qYaO0O/7inAKCQKYzECAZuTgIVh6KR3vavxk7TF6Wdch1GeARRcGGYNy1V0yiZDF
PFuhsPhkUjF/SO6omXrA+VsbXOjZ6JDXfJM1u574iyLZbvrK/nwcp0HFFCW2NuvI
qRraFwroG2VS/cWIe3LHCpkWpoJiIA==
=44Yz
-----END PGP SIGNATURE-----

--Qgof7w7UksPF5inF--
