Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E65600C6
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiF2M7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 08:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiF2M7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 08:59:34 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1904E3819D;
        Wed, 29 Jun 2022 05:59:32 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6FCEF1C0B8F; Wed, 29 Jun 2022 14:59:29 +0200 (CEST)
Date:   Wed, 29 Jun 2022 14:59:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, matthias.bgg@gmail.com, beanhuo@micron.com,
        avri.altman@wdc.com, daejun7.park@samsung.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 10/34] scsi: ufs: Support clearing multiple
 commands at once
Message-ID: <20220629125929.GA13395@duo.ucw.cz>
References: <20220628022241.595835-1-sashal@kernel.org>
 <20220628022241.595835-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20220628022241.595835-10-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit d1a7644648b7cdacaf8d1013a4285001911e9bc8 ]
>=20
> Modify ufshcd_clear_cmd() such that it supports clearing multiple commands
> at once instead of one command at a time. This change will be used in a
> later patch to reduce the time spent in the reset handler.

This and "scsi: ufs: Simplify ufshcd_clear_cmd()" are not really
bugfixes. Patch they are preparing for is not queued for 5.10-stable.

Please drop.

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrxMsQAKCRAw5/Bqldv6
8spgAKCrEm3g+0xxO7RBnswwHkbwojFTAQCggJYrnNnnP5agGkiGWSzYQDwjG5M=
=jUUt
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
