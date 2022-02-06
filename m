Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212104AB29D
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 23:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbiBFWZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 17:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBFWZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 17:25:10 -0500
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 14:25:08 PST
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19DAC06173B;
        Sun,  6 Feb 2022 14:25:08 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7FCD31C0B81; Sun,  6 Feb 2022 23:19:08 +0100 (CET)
Date:   Sun, 6 Feb 2022 23:19:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        trond.myklebust@hammerspace.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 5/7] NFSv4 expose nfs_parse_server_name
 function
Message-ID: <20220206221907.GA26066@duo.ucw.cz>
References: <20220203203651.5158-1-sashal@kernel.org>
 <20220203203651.5158-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20220203203651.5158-5-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Olga Kornievskaia <kolga@netapp.com>
>=20
> [ Upstream commit f5b27cc6761e27ee6387a24df1a99ca77b360fea ]
>=20
> Make nfs_parse_server_name available outside of nfs4namespace.c.

I don't think this makes sense for 4.9-stable. Noone uses the new
export.

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgBJWwAKCRAw5/Bqldv6
8m30AKCed4lKEne8yPZCYU+6zrIl59WLcACaAn8YLbN/0Hyxo1U1PMY/m3IJMeg=
=UxGk
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
