Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52C82CF5B2
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 21:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgLDUfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 15:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgLDUfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 15:35:42 -0500
Date:   Fri, 4 Dec 2020 20:34:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607114101;
        bh=Z/IXAQSuHsMdyUyeiOxn7qVElB9dwUCJ+fe8BiQfsDg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPa7oA5vvwTc4NFTLAMdCOjj1R4nb6XXrXVI/hxidcSO9J8I+HF8S0YJPciSQONbs
         DbNN5dvl84tPRQaURPP77lIoGlbguCH+eQtYFXFPnXcS21qdEPGa5qRtLJMvxaqTIC
         LMnt2q81EAAOx/kLX7Jd4ruC/LavW+L5/MgQ6cth7mZHh1xdp3biLwAJGtEJaygXGb
         anl5TaBYSx6HeKD7ZZfLblplmzHTOMatxD7CJCNZ7TeCTwLUIczPfjmrXi7uwadIyE
         CMhpezjqPoec2NCBFjz7nKv6Z8KeRnAobWEzlL9lF/LyBXYqU9OR13Z3dfNQjY4i3r
         Q8XjmAYPfqHPg==
From:   Mark Brown <broonie@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     dinghua ma <dinghua.ma.sz@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for
 AXP22x
Message-ID: <20201204203457.GG4558@sirena.org.uk>
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
 <20201201150036.GH5239@sirena.org.uk>
 <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
 <20201202161042.GI5560@sirena.org.uk>
 <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
 <20201204174020.GB4558@sirena.org.uk>
 <CAGb2v65mRo7sTZZ65P75vs9os198kUh-OyhewdDCkjyUhXuV6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Content-Disposition: inline
In-Reply-To: <CAGb2v65mRo7sTZZ65P75vs9os198kUh-OyhewdDCkjyUhXuV6Q@mail.gmail.com>
X-Cookie: Not a flying toy.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 05, 2020 at 01:56:38AM +0800, Chen-Yu Tsai wrote:
> On Sat, Dec 5, 2020 at 1:40 AM Mark Brown <broonie@kernel.org> wrote:

> > > I did receive it though. Would it help if I tried to bounce it to you
> > > and the lists?

> > Possibly?  It depends on what the issue is.

> Looks like v3 was already there the first time though:

> https://lore.kernel.org/lkml/20201201001000.22302-1-dinghua.ma.sz@gmail.com/

> Me bouncing it again had no real effect.

I've only got the bounced copy.  No sign as to why not...

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/KnXEACgkQJNaLcl1U
h9B9TAf9FQittmvUs03xlh4ecy2duZMIGjbiIOvaCOfVkGJUjKlsCrZCXfYEC/B5
m5MS248eiqZeP+pmTuq3+BswSNDCKQDwuw5q4B1gmcJAezvxqTqA3a6wREWNJkH9
jTOpKX3IHFMNv7H+rbvFPHZTgUwB8MwmqYvyjAmfzR/1vkkC2s//NuxeUgRZ51oL
8H2/BkYA7GDTb846Jqkmb8HG7etDhw3nCtKXyTCPmsSu9CAnB2vrmiTYNaxQQXt9
FxFHp90XOst5cHRsOZW4wVXBW5WMkro7sWTsM+5TbtK93MFMNkD3+d2LvcJX00yr
q8AHuUjYfGNW0rO91HNKOG4wB0i4SA==
=dUfO
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
