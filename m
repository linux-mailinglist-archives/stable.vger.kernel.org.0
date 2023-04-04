Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010AA6D5F5A
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjDDLno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbjDDLnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:43:39 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7C73A9F
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:43:33 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id ABE0D1C0DFD; Tue,  4 Apr 2023 13:43:32 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:43:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
Message-ID: <ZCwNZEoySWUWoKpR@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org>
 <ZCwJhAfrTIPorVTw@duo.ucw.cz>
 <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="53sEu/xf4uFkW4y7"
Content-Disposition: inline
In-Reply-To: <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--53sEu/xf4uFkW4y7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
> > >=20
> > > Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_T=
RGMII
> > > case as it's only needed when trgmii is used.
> >=20
> > This one is very wrong for 5.10. ssc_delta is unconditionally used
> > below, and it will not use uninitialized variable.
> >=20
> > (In mainline, that code is protected by if (trgint), so it does not
> > have this problem).
>=20
> This patch is not stable material in the first place. As a newbie I
> incorrectly sent it to net tree instead of net-next. This patch can just =
be
> ignored for 5.10, if that takes the least amount of effort for you folks.
>=20
> Sorry about that and thanks for pointing this out Pavel.

I believe you did the right thing, but as it had Fixes header stable
people picked it up.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--53sEu/xf4uFkW4y7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwNYwAKCRAw5/Bqldv6
8hkbAJ92g96m/7Yi/jSmHm/3DtFR+zK40gCdH8EfP7KuoFlBBYdT3mpmWEqm8S8=
=Y7HH
-----END PGP SIGNATURE-----

--53sEu/xf4uFkW4y7--
