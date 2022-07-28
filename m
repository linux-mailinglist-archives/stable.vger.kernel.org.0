Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30D5584771
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 23:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiG1VAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 17:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiG1VAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 17:00:18 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAA3F5B3;
        Thu, 28 Jul 2022 14:00:13 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E0FC91C0003; Thu, 28 Jul 2022 23:00:11 +0200 (CEST)
Date:   Thu, 28 Jul 2022 23:00:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: [PATCH 5.10 010/105] net: make free_netdev() more lenient with
 unregistering devices
Message-ID: <20220728210011.GA4108@duo.ucw.cz>
References: <20220727161012.056867467@linuxfoundation.org>
 <20220727161012.480155559@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20220727161012.480155559@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Fedor Pchelkin <pchelkin@ispras.ru>
>=20
> From: Jakub Kicinski <kuba@kernel.org>
>=20
> commit c269a24ce057abfc31130960e96ab197ef6ab196 upstream.
=2E..
> Simplify the error paths which are currently doing gymnastics
> around free_netdev() handling.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Patches 10..15: there's something wrong with From: field here; it is
present twice and sign-off does not match from.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYuL42wAKCRAw5/Bqldv6
8qRrAKCfZhnZdZNQDsA1nl7EK3y4W/EcnQCfZjjgZ1E4fDe7wo9isOVuKUmVrcI=
=5GRE
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
