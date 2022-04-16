Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEED50381D
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 22:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiDPUDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 16:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiDPUDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 16:03:46 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72A36333;
        Sat, 16 Apr 2022 13:01:13 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6DD421C0B8C; Sat, 16 Apr 2022 22:01:11 +0200 (CEST)
Date:   Sat, 16 Apr 2022 22:01:10 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 2/7] scsi: lpfc: Fix queue failures when
 recovering from PCI parity error
Message-ID: <20220416200110.GA28827@duo.ucw.cz>
References: <20220412005248.351701-1-sashal@kernel.org>
 <20220412005248.351701-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20220412005248.351701-2-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: James Smart <jsmart2021@gmail.com>
>=20
> [ Upstream commit df0101197c4d9596682901631f3ee193ed354873 ]

There's something strange going on with this commit. It is in autosel
for 4.9 and 5.10, but not 4.19. Mistake?

Best regards,

								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYlsghgAKCRAw5/Bqldv6
8hdUAKDAkGNAr1ZV9TpeilaOQDOjqIYXSwCgrzgwprwzs5vBrPVgEXaCK1DhutI=
=Guue
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
