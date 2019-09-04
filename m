Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78865A922A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbfIDTFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 15:05:39 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42238 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbfIDTFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 15:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QDYuHGg6Ej+bMPCc78560zCDL+cJryZFlneTfbKuV8E=; b=t//yuqn0TBhqB478H/xqd/KLw
        z6KC2jF/8BdPGsyrZgKWGCpc4WrXHpjiZG1eCJogeCX+npl7FK4V24snG9+kqaVEuenDYafx0qHm2
        6z04dyUudYMofcdWKu2504YWQzTJ+wTDrfD4pGArEaC1mP4Qx1yDME0xxSK7c8nkbMrlY=;
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i5ab1-0000ES-Sx; Wed, 04 Sep 2019 19:05:35 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 66D492742B45; Wed,  4 Sep 2019 20:05:35 +0100 (BST)
Date:   Wed, 4 Sep 2019 20:05:35 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/83] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190904190535.GH4348@sirena.co.uk>
References: <20190904175303.488266791@linuxfoundation.org>
 <20190904175304.389271806@linuxfoundation.org>
 <20190904181027.GG4348@sirena.co.uk>
 <20190904183527.GA364@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
Content-Disposition: inline
In-Reply-To: <20190904183527.GA364@kroah.com>
X-Cookie: Help fight continental drift.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2019 at 08:35:27PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 04, 2019 at 07:10:27PM +0100, Mark Brown wrote:

> > I nacked this patch when Sasha posted it - it only improves diagnostics
> > and might make systems that worked by accident break since it turns=20
> > things into a hard failure, it won't make anything that didn't work
> > previously work.

> This is already in the 4.14.141, 4.19.69, and 5.2.11 releases, have you
> heard any problems there?

Ugh, how did that happen?  I've not heard any reports but I'd be a lot
more comfortable if this was reverted, these releases haven't been out
that long and the users who'd be affected are mostly doing embedded
stuff.

> I'll be glad to drop this from the 4.9.y and 4.4.y queues, now if you
> wish, but just want you to know it's already out there in some releases.

Yes, please.

--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1wCv4ACgkQJNaLcl1U
h9AeJQf9H0MpKQMHhK+ySibRaENR2Jv5I7yx0Z9djCM/5UgYOqeHHDCNkfauD6+v
7ANLz0fTolkI2ebyBHD+bWodk/j3PnPerIP+mec1o7bMm6VvcDhpVrCs5QPtB5Rn
EP8I6dqRbVBMxy/fKSnzzMgpNFIl06KMfxrkC944NY47Nsr6fKWoz1EVDEYdvzKY
nemiAfElastgsAqw7pxfhyfYIJICpSuvS7P6jCsIIdD9xGk2QT8W6mfxy9uJH8E9
Slv5Yd0vrFbM62KmJjzQOSworPQoT25X3tgxUJEc3r52GG35muYEaZAUqH6lntsm
o/CzxqMt/5IiFxlOF8ULYia6EE8QKQ==
=QLKC
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--
