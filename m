Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9309599A5A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348491AbiHSLC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiHSLCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:02:43 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ACFF61A8;
        Fri, 19 Aug 2022 04:02:42 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oOzlk-0002zN-5f; Fri, 19 Aug 2022 13:02:28 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oOzli-000aat-1m;
        Fri, 19 Aug 2022 13:02:26 +0200
Message-ID: <2d899b4a9a08f79396a071eb8c06d524ae6033b0.camel@decadent.org.uk>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        1017425@bugs.debian.org,
        =?ISO-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date:   Fri, 19 Aug 2022 13:02:17 +0200
In-Reply-To: <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
         <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-YjhQggnj2zhMxQngHr7f"
User-Agent: Evolution 3.44.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-YjhQggnj2zhMxQngHr7f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-08-19 at 10:47 +0200, Peter Zijlstra wrote:
> On Fri, Aug 19, 2022 at 02:33:08AM +0200, Ben Hutchings wrote:
> > From: Ben Hutchings <benh@debian.org>
> >=20
> > The mitigation for PBRSB includes adding LFENCE instructions to the
> > RSB filling sequence.  However, RSB filling is done on some older CPUs
> > that don't support the LFENCE instruction.
> >=20
>=20
> Wait; what? There are chips that enable the RSB mitigations and DONT
> have LFENCE ?!?

Yes, X86_FEATURE_RSB_CTXSW is enabled if any other Spectre v2
mitigation is enabled.  And all Intel family 6 (except some early
Atoms) and AMD family 5+ get Spectre v2 mitigation by default.

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-YjhQggnj2zhMxQngHr7f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmL/bbkACgkQ57/I7JWG
EQmxQg//ZS3fq6QOEM160thdxrPitpXbg0ygRoO4bBjmDY8G/+2sne8MEPRq2r2U
gKHbq5O6TTLbGDQjZBwGwMEg1omi8dLHt9m9I8YKBxBwqOHdqO4UrZa9cuvVQnF4
TDTGeBO7sGMRPcuaff7HPKMgjQL2E6+Db2DbZhxvtPkKyRRuoCRONajy7z/W+K0F
9nHY/offfF5EXLySFwqSE1ypm/MTBVro4EGPFKMe/znSx5y4jFh6Dci39BAVb+rf
YyzI1y5bmbBnRhy/GGbb/zVhPiQxnwjKCq4o9SUGCh+cWDLfrU8nmkttzxwb2J29
KEK488/fxi7sI4WB7IxPMTI8REqyrxBq8ybWW0i1HBWt+VieHYroqMrsi9kjrgOU
6ae6V5PPi773/WzLK/sYnKlKB74V7svRRsFXgk5p5GKVoIGngaWhNQNAknDpdhPK
Sl8sQTsgS8mUnPIKitwtEgNX+XzvKUuSz8ep0tO/a96ZMahoBSbKO2dt2n+jv7e5
FU17Q8IKFnqpb9SybcUhD/BGiTLJ7sWcb+sR20Nlxk2ji0j67gzkKcmtVU+qsgLB
3IzG38XZsd5X+RwTUyO+ZRvTdjKTcj7phIywd+PgYBaWbck1y2OGygJt4U2FDe7a
MPMJwbDp3jIE3lt/k+XDWY9x2HvXF5C1ZuOdhSapp+eRW4yVkzs=
=QDsX
-----END PGP SIGNATURE-----

--=-YjhQggnj2zhMxQngHr7f--
