Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646D2566FE
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfFZKjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:39:16 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47802 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFZKjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xJ4m0by2++9HOQy1nxvjvxKgg1O9KxqocX77DoVxh9I=; b=Y8LuQXVEzUZY/Zor1Ea5GGrtS
        kXI7pGcfwdr8xmD7cLNeiWBxnXgw94aoRWF8JDNguW/KnwzfyjWLSL8+ESI59cdzjQfEQFtHDer3v
        htt03AewcJ6jcp1gQogjGzo98K74PbUdeGkE2GWAELCISrralIiZNIHIeI5nzIv2IHnzI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hg5Ka-0007lL-MF; Wed, 26 Jun 2019 10:39:12 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 33AE5440046; Wed, 26 Jun 2019 11:39:12 +0100 (BST)
Date:   Wed, 26 Jun 2019 11:39:12 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "kernelci . org bot" <bot@kernelci.org>
Subject: Re: [PATCH AUTOSEL 5.1 38/51] ASoC: core: Fix deadlock in
 snd_soc_instantiate_card()
Message-ID: <20190626103912.GW5316@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-38-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nyUxq7w40972sSTq"
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-38-sashal@kernel.org>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nyUxq7w40972sSTq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 11:40:54PM -0400, Sasha Levin wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>=20
> [ Upstream commit 495f926c68ddb905a7a0192963096138c6a934e1 ]
>=20
> Move the client_mutex lock to snd_soc_unbind_card() before
> removing link components. This prevents the deadlock
> in the error path in snd_soc_instantiate_card().

Again, are you sure there's no dependencies?

--nyUxq7w40972sSTq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0TS08ACgkQJNaLcl1U
h9Bp8wf/b10PvV5+hosEt5JhEak/U1IB1FmeyKx3FAZVgheXBMUX/ENgHuHVx59c
RA6HdxulvuxEo3PeOZxgJxBwKmfV7SiZZTrV/dAcEhRVXT1Zw24Ci2Fmez4cqocJ
XMEYKOLKQ8X/bP58YttRJbtlzcHlH/e+lsLUSHr7Hn3QzyjKuJ6dsfJ6nID2oB8o
Qj48a5Z6/6SqokSSVS2DfSBRmkU65xLYFGnrGzbgPKjhXxUdxz1/tBvugBHjIHxf
dd/nBLTTx5wCy5xWEf09BcIq2rG1Goz+uCwpkRkT5GGlfuxqjKdWTrkfyKiMtF56
NYpGA6UM2gqlDEfWVc3EnqmoEQ+uIw==
=RJf/
-----END PGP SIGNATURE-----

--nyUxq7w40972sSTq--
