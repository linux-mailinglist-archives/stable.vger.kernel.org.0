Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65089591ABF
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbiHMNoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbiHMNod (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:44:33 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF9FDF46;
        Sat, 13 Aug 2022 06:44:26 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C695A1C0012; Sat, 13 Aug 2022 15:44:24 +0200 (CEST)
Date:   Sat, 13 Aug 2022 15:44:22 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        kernel test robot <lkp@intel.com>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH AUTOSEL 4.19 04/16] genirq: GENERIC_IRQ_IPI depends on SMP
Message-ID: <20220813130448.GA23630@duo.ucw.cz>
References: <20220808013914.316709-1-sashal@kernel.org>
 <20220808013914.316709-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <20220808013914.316709-4-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Samuel Holland <samuel@sholland.org>
>=20
> [ Upstream commit 0f5209fee90b4544c58b4278d944425292789967 ]
>=20
> The generic IPI code depends on the IRQ affinity mask being allocated
> and initialized. This will not be the case if SMP is disabled. Fix up
> the remaining driver that selected GENERIC_IRQ_IPI in a non-SMP config.

Are you sure this is right thing to do on 4.19 kernel?

In particular, should we have "Only register IPI domain when SMP is
enabled" in the tree before this can be applied?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYveqtgAKCRAw5/Bqldv6
8oPlAKCRrGBePOK2mk45HDbd4yXoRm7f1QCgjKof9WKJKHAMqxfP4CC42glSUSk=
=vhVH
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
