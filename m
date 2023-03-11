Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7DB6B5B4A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCKLpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 06:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCKLpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 06:45:23 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E84742D;
        Sat, 11 Mar 2023 03:45:21 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8187B1C0ABB; Sat, 11 Mar 2023 12:45:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1678535120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T21Tf5s3TefGU/imr7W0DKQiW+BHdYXty45JQdphxQU=;
        b=mHtERPERD4J3YI8mz4Zd0l74D0JcRlNe8hMd7YsxA4fXy/iPMjvR54PlKaZHt4QaCv6oo/
        BQGV1kwcfEAvAXIhozjNS8exy5m02wkSUy+DefdUxZkhWfparmGju4SWCYku116CCU9d3i
        AcagpsdrkgzY/UurEA2vJ8IEDBlLzT4=
Date:   Sat, 11 Mar 2023 12:45:20 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAxp0KaKq7x7ZKlz@duo.ucw.cz>
References: <Y/rbGxq8oAEsW28j@sol.localdomain>
 <Y/rufenGRpoJVXZr@sol.localdomain>
 <Y/ux9JLHQKDOzWHJ@sol.localdomain>
 <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAw3tt9xISOdb5sS@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zIdUC5pNgYdqHN+N"
Content-Disposition: inline
In-Reply-To: <ZAw3tt9xISOdb5sS@1wt.eu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zIdUC5pNgYdqHN+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I believe that -stable would be more useful without AUTOSEL process.
> > >=20
> > > There has to be a way to ensure that security fixes that weren't prop=
erly tagged
> > > make it to stable anyway.  So, AUTOSEL is necessary, at least in some=
 form.  I
> > > think that debating *whether it should exist* is a distraction from w=
hat's
> > > actually important, which is that the current AUTOSEL process has som=
e specific
> > > problems, and these specific problems need to be fixed...
> >=20
> > I agree with you, that we need autosel and we also need autosel to
> > be better.  I actually see Pavel's mail as a datapoint (or "anecdote",
> > if you will) in support of that; the autosel process currently works
> > so badly that a long-time contributor thinks it's worse than nothing.
> >=20
> > Sasha, what do you need to help you make this better?
>=20
> One would probably need to define "better" and "so badly". As a user
> of -stable kernels, I consider that they've got much better over the

Well, we have Documentation/process/stable-kernel-rules.rst . If we
wanted to define "better", we should start documenting what the real
rules are for the patches in the stable tree.

I agree that -stable works quite well, but the real rules are far away
=66rom what is documented.

I don't think AUTOSEL works well. I believe we should require positive
reply from patch author on relevant maintainer before merging such
patch to -stable.

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--zIdUC5pNgYdqHN+N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZAxp0AAKCRAw5/Bqldv6
8l1QAKChnPdXEsPLgcXM0pNrVUxb+tPR+wCcDXpmvYwVxER+sUkuwVLWCDePW7A=
=NAws
-----END PGP SIGNATURE-----

--zIdUC5pNgYdqHN+N--
