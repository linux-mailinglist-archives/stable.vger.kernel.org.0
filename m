Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD73D2CF33E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 18:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgLDRlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 12:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgLDRlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 12:41:04 -0500
Date:   Fri, 4 Dec 2020 17:40:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607103624;
        bh=cKXZXdbUC28emu96zhdomNFGFPRK9ainoY7T9RHi9vs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=uapmoEQj7UDRIF4DPvwBujT6h1ntqg5+8MmJEBbom2cjOCNO3oQqNpdfuzgfGqxPk
         m2YiS3w08YxuNdbkx7qY2K881kZR/8utYBE7qOSx/1O6XbfuKOZwLYUoE87iv53QSH
         Xh6jTYCuYNSczNxtkUsxZqPfbIWi8egmI7Zobjw7rGbv7T5UZTnHaAW7DhMNcxlvaV
         4AocWDvw/LBOgtdnnbXFNB6GoiRGB1le9PfLyxZxdWZOF5TJARrBN9TsgoyaJ3GWLw
         tmaGPCqjR9W380yKeQ4+oGuqSuBuaOxbDWIbYQdP0h3Vp548Aq6MnZwZJYle1gb1U/
         KgPXtOWvdicuw==
From:   Mark Brown <broonie@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     dinghua ma <dinghua.ma.sz@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for
 AXP22x
Message-ID: <20201204174020.GB4558@sirena.org.uk>
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
 <20201201150036.GH5239@sirena.org.uk>
 <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
 <20201202161042.GI5560@sirena.org.uk>
 <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
X-Cookie: Not a flying toy.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 04, 2020 at 10:34:21AM +0800, Chen-Yu Tsai wrote:
> On Thu, Dec 3, 2020 at 12:11 AM Mark Brown <broonie@kernel.org> wrote:

> > No, no sign.  You can check if things are at least hitting the list at:

> >     https://lore.kernel.org/lkml/

> I did receive it though. Would it help if I tried to bounce it to you
> and the lists?

Possibly?  It depends on what the issue is.

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/KdIMACgkQJNaLcl1U
h9A+oQf9HYPSpAokcjeYwc9F5BH7m1QJqLI0UfvyBf8S05ngFXN2V1JYh3CJZUKC
2ofvat2JA9lK1vGwjRrnzEb8WspBmqTGbUPhIH/SPso5FdKBxwLeUjRdpwloZ+HK
flUCRBrlD8/UokCZdsVyY4HngVLgOgreoJc1npg9ooG7XAncTdiZHuaVsFBVKdOX
2kVBizK8i1ESNLEGXzmELnocD0aJZaKlvlTBQWDSBqf4A+juudsrwpKG2yrPF+P8
SL27yHXwv6WPgUmk45o1namA6BCCqSQTPp/cnqjikl/ZK8DHZWdKx1WYjN/eQlIT
5dlpve3k23ZVpJJ2IIyAXg5/lmBGFg==
=P1Jy
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
