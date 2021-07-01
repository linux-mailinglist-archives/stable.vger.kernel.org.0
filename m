Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24923B9181
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 14:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhGAMOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 08:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236192AbhGAMOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 08:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3BA561403;
        Thu,  1 Jul 2021 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625141522;
        bh=TT5ATJx6/SGmcZ2onpZJhXly2bwzw4Mlao44OlsAkcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6ITX7x1DYq7u9skUcCsAXk3eYjBdE/n3aYvabBb9yGroo1OOK3laVLG6iEkcQOEZ
         1gX9jQqStMnE0JdKtFWtTjvYsDGPvpf6y3BhxX+f1j5qlcWWO+6r05StyYejnLbxoM
         opX/2D54G7wzk1Htc+PDmkkFZuBRsaL6qC9xI6984+rZzShRwVYhCBSbSTU4sVMJ7R
         kWF2JMPzomyvyLkCTrc8JOf3beh5LCdRO0T3+vEZfR3Mp0i9v+iagq5N+qCTx7Ma2N
         3B+UHeaduFzw4a2xaBONWMSZV2uD5+/BxPJ0OLEy315cIu4IaDcTxOStA3r5DOF9ep
         AOxRVONgQmdcQ==
Date:   Thu, 1 Jul 2021 13:11:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Richard Purdie <richard.purdie@linuxfoundation.org>
Cc:     Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Message-ID: <20210701121133.GA4641@sirena.org.uk>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
 <YMoXdljfOFjoVO93@slm.duckdns.org>
 <20210630161036.GA43693@sirena.org.uk>
 <696dc58209707ce364616430673998d0124a9a31.camel@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <696dc58209707ce364616430673998d0124a9a31.camel@linuxfoundation.org>
X-Cookie: Turn off engine while fueling.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 30, 2021 at 11:31:06PM +0100, Richard Purdie wrote:

> Out of interest are you also seeing the proc01 test hang on a non-blocking
> read of /proc/kmsg periodically?

> https://bugzilla.yoctoproject.org/show_bug.cgi?id=14460

> I've not figured out a way to reproduce it at will yet and it seems strace

I've been talking to Ross, he mentioned it but no, rings no bells.

> was enough to unblock it. It seems arm specific.

If it's 32 bit I'm not really doing anything that looks at it.

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDdsPQACgkQJNaLcl1U
h9CWJwf/YF+XAA1qBYxWYCc8ZI/W6jctkkgrPHFx22WMAE341gHUGHvmC7twHrgI
DcCGdXI1CL2IQ0YJos9z2ydV66ZTtH2qP1K2Ugt2GzZyL0zL+P5hgndYquVXNOFQ
p736kNqsvsB3tOrsIDzLeVheqJmQwH4E60rBgU40C5oRkNYmO1aA9KLDhOxa5NAX
KfZ3to8t+mR1KCh/LipJaBgmmLli9c0s+reuz9bfnJnAqW7VHSQvGopo5afkmWYO
RO32LIAwI81JTGOyG+gWjSExxS8sMWYEuSMkCWiXwtrKKjm5XD91W4465CmfOtgb
UeHMvCVvCwaU5A+cq9VTN6vsMx7Qhg==
=UGEt
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
