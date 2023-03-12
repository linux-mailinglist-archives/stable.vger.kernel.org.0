Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB3B6B66BD
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 14:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCLNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCLNeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 09:34:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086DB39CF2;
        Sun, 12 Mar 2023 06:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C82C2B80B18;
        Sun, 12 Mar 2023 13:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B733AC433AC;
        Sun, 12 Mar 2023 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678628047;
        bh=lLvXX1RY/TsF8vol5nsiuBWxIpMDLvN0QDYIXXQeoWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOQf+FW3/2d+IEmAsy7eNQW3JNm0eAJefKGE73FaHUHHDq0ElsfNYtCQcvAPboeYt
         9MT0+G7PZ7DycgLy7r5w5Ki/Mxen3fjLb7vzpOHpnDhBTAGKp6ne84OJBGRPmGJhCH
         bhbHwfHiBhZfERo/BePa2A1/zNKr6LXQe5co5MvatEmccC6RSFWwVTxZvp8u/5/sWC
         x3JnwSQVyvw9K036uUlwi5aHa9dA3yRAqHbqry1iNwXTixgCTlO4wpnXXADqN+CQGq
         C1Km24e9n+Xe8TZgYSlFt1YiBEbH25GET36pVBZ4FWX5MynV672PZgyGe+ol2e/oqc
         tyPhXjsWMki3Q==
Date:   Sun, 12 Mar 2023 13:34:03 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: AUTOSEL process
Message-ID: <ZA3Uy4HuBPLvKWsJ@sirena.org.uk>
References: <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzJltJaydwjCN6E@1wt.eu>
 <ZAzVbzthi8IfptFZ@sol.localdomain>
 <ZAzghyeiac3Zh8Hh@1wt.eu>
 <ZAzqSeus4iqCOf1O@sol.localdomain>
 <ZA1V4MbG6U3wP6q6@1wt.eu>
 <ZA1hdkrOKLG697RG@sol.localdomain>
 <CAOQ4uxiJPvKh5VzoP=9xamFfU78r3J25pwW6GQyAUN7YPJk=dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g2af+PWy0yQWzBAQ"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiJPvKh5VzoP=9xamFfU78r3J25pwW6GQyAUN7YPJk=dQ@mail.gmail.com>
X-Cookie: Many a family tree needs trimming.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--g2af+PWy0yQWzBAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 12, 2023 at 09:42:59AM +0200, Amir Goldstein wrote:

> Alas, despite sending a pull request via github and advertising my work
> and its benefits on several occasions, I got no feedback from Konstantin
> nor from any other developers, so I did not pursue upstreaming.

> If you find any part of this work relevant, I can try to rebase and
> post my b4 patches.

...

> [1] https://github.com/mricon/b4/pull/1

b4 development is mainly done via email on the tools@linux.kernel.org
list, and https://git.kernel.org/pub/scm/utils/b4/b4.git rather than that
github repository (note that yours is the first and only pull
request there) is the main repo.  I suspect that github repo is
just an automatically maintained mirror and nobody's seen your
pull request, you'd be much more likely to get a response sending
your patches to the list CC Konstantin.

--g2af+PWy0yQWzBAQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQN1McACgkQJNaLcl1U
h9AcIQgAg8ofOrCx+tGCy6/btvuphxg1CWaxqhEa/n3LX9DaWK5Edr2ukKshhkoh
VdvMuf1chP6TjW0wQBEdwh8IRB7ZMx2uSp/dYdI968ohf5MoZur9FuYWJaPbxAnC
Q8/Q2La9oZ5EAgrD2yJWoABLy+/r53Q8XOab30K02PLiDD9L4ZUPAUpDdj1898r0
igsHe1wxtgkO68kw2hjx8We2hu/p44RvAEqIexOUXlt8ZBKaLptFq1WfDK+7Dse5
QPkJN8T5YublavSzESExkQAo7hClVKU+DbJ1cZIwygsa2TsgWeGuzuALqXwjX8uI
sEN77L4ymPK/C5+lyWv73xb5VReREQ==
=VSTB
-----END PGP SIGNATURE-----

--g2af+PWy0yQWzBAQ--
