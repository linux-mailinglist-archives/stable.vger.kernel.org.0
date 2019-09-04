Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1304FA907C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390025AbfIDSJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:59 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48994 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390015AbfIDSJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 14:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qG8opaR13yirPBMA3yYye/hgLEgoC/bD1fPgs2vYlls=; b=tcKTv9BbRVRH/iPzWeSkE/GON
        prBQwlWTEHaZnK6c6TzJcXVBYBE+6Tg3Y4wy59b0dAIbjfTVetoMDzoJAY4V59PDop8Ll3eoMuKDy
        /w6UA939DApE/CTdpnonch76YIrsopcnSWPtID7bX6b/cW7BzlFlVDhDWQSQKuHu9PdyI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i5Zj7-0006o3-Fd; Wed, 04 Sep 2019 18:09:53 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id A864D2742B45; Wed,  4 Sep 2019 19:09:52 +0100 (BST)
Date:   Wed, 4 Sep 2019 19:09:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 06/77] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190904180952.GF4348@sirena.co.uk>
References: <20190904175303.317468926@linuxfoundation.org>
 <20190904175304.060004729@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
Content-Disposition: inline
In-Reply-To: <20190904175304.060004729@linuxfoundation.org>
X-Cookie: Help fight continental drift.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2019 at 07:52:53PM +0200, Greg Kroah-Hartman wrote:
> [ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]
>=20
> If the DAI format setup fails, there is no valid communication format
> between CPU and CODEC, so fail card instantiation, rather than continue
> with a card that will most likely not function properly.

I nacked this patch when Sasha posted it - it only improves diagnostics
and might make systems that worked by accident break since it turns
things into a hard failure, it won't make anything that didn't work
previously work.

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1v/e8ACgkQJNaLcl1U
h9Ca6gf9FecwK4D+h++8/eLeOkmItr1GGI6gIc+y8U68YlvJwqCZoirmrs2AO7b0
CxHsQGBQadSEGVYWZ0WLm6uLxJZhseakmz4pOTYPuIT8zyy2LtITnhW7dEb6FGRS
PrFB+VYWZEt5kydi7/5aHtiLxqflrRNO/i8HbN5dzOr55Kht+3MKt/FE+VTx1O8X
fRSXXTCJNx6tujSlaGg35QDKl3GgSl0SNdNM1vP87csdZjUGRUSTQpU4vuAnsjV8
eo43B83hgbF3hyQ444/MQ48QduTacy8wAdKv7s5YxTJKn2T6ePpRUOBv9Tca8BqJ
kcC+YJ1RYt4kk3jWKPSWCN7fvST0hQ==
=3qkM
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
