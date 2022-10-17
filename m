Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD5600F7A
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiJQMs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 08:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJQMs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 08:48:57 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF735C97E;
        Mon, 17 Oct 2022 05:48:49 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5E1EE1C0023; Mon, 17 Oct 2022 14:48:47 +0200 (CEST)
Date:   Mon, 17 Oct 2022 14:48:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Harry Stern <harry@harrystern.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 03/10] hid: topre: Add driver fixing report
 descriptor
Message-ID: <20221017124846.GB13227@duo.ucw.cz>
References: <20221013002802.1896096-1-sashal@kernel.org>
 <20221013002802.1896096-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <20221013002802.1896096-3-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Harry Stern <harry@harrystern.net>
>=20
> [ Upstream commit a109d5c45b3d6728b9430716b915afbe16eef27c ]
>=20
> The Topre REALFORCE R2 firmware incorrectly reports that interface
> descriptor number 1, input report descriptor 2's events are array events
> rather than variable events. That particular report descriptor is used
> to report keypresses when there are more than 6 keys held at a time.
> This bug prevents events from this interface from being registered
> properly, so only 6 keypresses (from a different interface) can be
> registered at once, rather than full n-key rollover.
>=20
> This commit fixes the bug by setting the correct value in a report_fixup
> function.
>=20
> The original bug report can be found here:
> Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/804
>=20
> Thanks to Benjamin Tissoires for diagnosing the issue with the report
> descriptor.

Come on, whole new driver to work around hw problem that is not really
serious. Plus this won't really do anything unless people enable it in
config.

This should not be in stable.

Best regards,
								Pavel

> Signed-off-by: Harry Stern <harry@harrystern.net>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Link: https://lore.kernel.org/r/20220911003614.297613-1-harry@harrystern.=
net
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hid/Kconfig     |  6 +++++
>  drivers/hid/Makefile    |  1 +
>  drivers/hid/hid-ids.h   |  3 +++
>  drivers/hid/hid-topre.c | 49 +++++++++++++++++++++++++++++++++++++++++

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY01PLgAKCRAw5/Bqldv6
8kdsAJ9lvQoxJ3ffIjkIWlnFNChhUI+/iQCfVZLCVxHpaAXYQsfAQV6JKd5A8yw=
=YMaE
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
