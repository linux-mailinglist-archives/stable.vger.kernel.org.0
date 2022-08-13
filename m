Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1DA591AB2
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiHMNnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbiHMNnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:43:50 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C15DEA9;
        Sat, 13 Aug 2022 06:43:38 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 015591C0006; Sat, 13 Aug 2022 15:43:37 +0200 (CEST)
Date:   Sat, 13 Aug 2022 15:43:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg.Karfich@wago.com, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 14/14] fs/dcache: Disable preemption on
 i_dir_seq write side on PREEMPT_RT
Message-ID: <20220813134334.GA24517@duo.ucw.cz>
References: <20220811160948.1542842-1-sashal@kernel.org>
 <20220811160948.1542842-14-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20220811160948.1542842-14-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> [ Upstream commit cf634d540a29018e8d69ab1befb7e08182bc6594 ]
>=20
> i_dir_seq is a sequence counter with a lock which is represented by the
> lowest bit. The writer atomically updates the counter which ensures that =
it
> can be modified by only one writer at a time. This requires preemption to
> be disabled across the write side critical section.
>=20
> On !PREEMPT_RT kernels this is implicit by the caller acquiring
> dentry::lock. On PREEMPT_RT kernels spin_lock() does not disable preempti=
on

This should not be applied to 4.19 as CONFIG_PREEMPT_RT does not exist
there.

Best regards,
								Pavel
--=20
 'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany'


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYveqhgAKCRAw5/Bqldv6
8jB7AJ9kB9Ep7hzmzZvri5e6Cl+NElOtSACgtrJkx7JKO87b2TS/jWh66brZ6YI=
=LuVS
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
