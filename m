Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691D3A9093
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390109AbfIDSKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:32 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:49898 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390085AbfIDSKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 14:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qV05ywLNhkw5oOxBhEEGmA7EY58+l2bVgOq9K+RRCSE=; b=l8T7UEE/HS8sg7kowfz/+EUNp
        9rpWmbF/Qzo07zEp3UqHIucDuX4ZAeP2kp6diPbi8Wsk+DZ2cFY7Bk9J5b7sPmoyDdaSKpcRerpHp
        2lK0P5MhN3gg81oFYzzV1YTMhy3SXTtrU1vVM7x3wmqssW4GXWqH6XPwLuCx9sP0BMetA=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i5Zjf-0006oF-Ms; Wed, 04 Sep 2019 18:10:27 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 3D6B52742B45; Wed,  4 Sep 2019 19:10:27 +0100 (BST)
Date:   Wed, 4 Sep 2019 19:10:27 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/83] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190904181027.GG4348@sirena.co.uk>
References: <20190904175303.488266791@linuxfoundation.org>
 <20190904175304.389271806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <20190904175304.389271806@linuxfoundation.org>
X-Cookie: Help fight continental drift.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2019 at 07:52:59PM +0200, Greg Kroah-Hartman wrote:
> [ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]
>=20
> If the DAI format setup fails, there is no valid communication format
> between CPU and CODEC, so fail card instantiation, rather than continue
> with a card that will most likely not function properly.

I nacked this patch when Sasha posted it - it only improves diagnostics
and might make systems that worked by accident break since it turns=20
things into a hard failure, it won't make anything that didn't work
previously work.

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1v/hIACgkQJNaLcl1U
h9Dkowf+KbjSSQVbjapxEa9i0Tmjpe8K9MpYCABj4iB/aertfFsfF7lruARygQLs
JLqr5Rdf/lmK5Acn+3UKnkVvJOrFWnasjMZsgZW5oZ47CdjaWIuQ76BAclHtwUCr
7DoyuUnAHbZPXWw7BbKv6zt/wb++RdWuweuzUa2LE6YwVQCqixGpXmYz7RRhfcDm
SMPYuYMczBvj8iONtRILTZc40DtYsPkc7jXvk67bwjImQceyuq4uW4/jTerTgzfm
s0ZnoSOxopHUwoJ6V/Va+ae7DweWi/+bOqBbo69ff6lD6gZ2miKg3Wxb5tN5mAwh
UsPNYX9fBwy9tJvNRwq0aAvOf4fGEA==
=2RWa
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
