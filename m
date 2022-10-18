Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEAA602875
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiJRJfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJRJfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:35:25 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEEB6D862;
        Tue, 18 Oct 2022 02:35:11 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8F19B1C09D8; Tue, 18 Oct 2022 11:35:10 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:35:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ian Rogers <irogers@google.com>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.10 04/16] powerpc/hw_breakpoint: Avoid relying
 on caller synchronization
Message-ID: <20221018093509.GB1264@duo.ucw.cz>
References: <20221018001029.2731620-1-sashal@kernel.org>
 <20221018001029.2731620-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <20221018001029.2731620-4-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Marco Elver <elver@google.com>
>=20
> [ Upstream commit f95e5a3d59011eec1257d0e76de1e1f8969d426f ]
>=20
> Internal data structures (cpu_bps, task_bps) of powerpc's hw_breakpoint
> implementation have relied on nr_bp_mutex serializing access to them.
>=20
> Before overhauling synchronization of kernel/events/hw_breakpoint.c,
> introduce 2 spinlocks to synchronize cpu_bps and task_bps respectively,
> thus avoiding reliance on callers synchronizing powerpc's
> hw_breakpoint.

This is preparation, not a bugfix, not sure why it was picked for
5.10.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY05zTQAKCRAw5/Bqldv6
8hDCAJ93uULfn3AoJWhDD3Cg+mHOSVqtLwCeL4eiZsmL+Ra5uL3L03wLx5hvocg=
=NwNt
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
