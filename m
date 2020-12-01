Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F262CA676
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389683AbgLAPBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389514AbgLAPBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 10:01:45 -0500
Received: from localhost (cpc102334-sgyl38-2-0-cust884.18-2.cable.virginm.net [92.233.91.117])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A7952076C;
        Tue,  1 Dec 2020 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606834865;
        bh=tdQZ8jjvG7J/xpHtajPQDufefYQVstBWL2sN2icfXrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O7qEBHqFQMeuZY3W5sm8BFgn6tbZbZi+ISHgPGeYyyorUHINEItzSjng4EPROcO+X
         tYAhqHwnpybwSs3KtBPVXer9NCQqt3HD0LVIIHrLR7gmFTm7aqX0ou7lKcVjTlTBSp
         qqfxZLsL+7Ho72pDOR/6mMydz0uNR4+vexrzik6I=
Date:   Tue, 1 Dec 2020 15:00:36 +0000
From:   Mark Brown <broonie@kernel.org>
To:     dinghua ma <dinghua.ma.sz@gmail.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for
 AXP22x
Message-ID: <20201201150036.GH5239@sirena.org.uk>
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Content-Disposition: inline
In-Reply-To: <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 01, 2020 at 08:04:51AM +0800, dinghua ma wrote:

> I feel very sorry, I found the subject of the email was wrong at the
> moment I sent the email, which wasted everyone=E2=80=99s reading time. I =
have
> already sent the third email and I am sorry again

I don't appear to have any other mail from you recently and can't look
it up with lore either so I think perhaps it got stopped by some filter
somewhere in your mail system and you've not actually been disrupting
anything, at least for me - can you resend please?

--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/GWpMACgkQJNaLcl1U
h9CFMAf/W1lhCenUB8rEjQ/pjj4ikfn1PtGIq87fBx9jEXAbKNEGpgEbpZP7fisV
RyJCvLwe8OKOcUl2pHnPMolqpgYUoR4zv+BGs2SqASCYPI7PtV4ND1Lzpc0H0TpR
N+e3CzRMtGT9BLEdKZ/NTO7r7NlT5iYtcNEYFNCyRimjIr0SfCgEAeGqDMRs+pon
wBw1BgbXSemUiz75enEAlNYdN5woF7BO64/9q+ktaHXrYfJVd3LgjNBxEtZgAUc8
6c9JvabnnNMk80Z0903WvhC6znvofiAS8lt7OwahUSjeg8fMBkpsgJHpJ0yCZb02
urZbOglmNkvA5J8cYSPzFnbBRNmwOg==
=gEwI
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
