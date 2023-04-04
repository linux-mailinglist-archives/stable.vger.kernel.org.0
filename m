Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D786D5EFC
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbjDDL3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbjDDL3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:29:20 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143F62711
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:29:11 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CDDFD1C0DFE; Tue,  4 Apr 2023 13:29:09 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:29:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Sanju Mehta <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Message-ID: <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.499791738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QPUMG3WcAYkC+ftV"
Content-Disposition: inline
In-Reply-To: <20230403140416.499791738@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QPUMG3WcAYkC+ftV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> commit 1716efdb07938bd6510e1127d02012799112c433 upstream.
>=20
> `ring_interrupt_index` doesn't change the data for `ring` so mark it as
> const. This is needed by the following patch that disables interrupt
> auto clear for rings.

Yeah, nice cleanup. But do we really need it in -stable?

Best regards,
								Pavel
							=09
> +++ b/drivers/thunderbolt/nhi.c
> @@ -36,7 +36,7 @@
> =20
>  #define NHI_MAILBOX_TIMEOUT	500 /* ms */
> =20
> -static int ring_interrupt_index(struct tb_ring *ring)
> +static int ring_interrupt_index(const struct tb_ring *ring)
>  {
>  	int bit =3D ring->hop;
>  	if (!ring->is_tx)
>=20
>=20

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QPUMG3WcAYkC+ftV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwKBQAKCRAw5/Bqldv6
8rRSAJsHwMppkZv7sHEdAc/+N07jcUO2JwCcDm/nIt/5Dcy/9KjT13HYCO5vcb4=
=JN/b
-----END PGP SIGNATURE-----

--QPUMG3WcAYkC+ftV--
