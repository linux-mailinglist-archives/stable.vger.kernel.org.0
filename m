Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA10566DF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfFZKhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:37:06 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:44112 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZKhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fv78PdY7ISyJvRIZkYjhKT6541Tfj6GZo68h8e0qdwU=; b=QT/4DyeoR37Ut3uZQIvJRpiBV
        vDycd5XVOoHRHCHKygD23NzaBcdORxGAcwrbmgu9lDKSDtBdbj2+jsdFC8awg3X43GXXPw6Emvwhw
        ry7aFB95KYChtTn1BpUdDziDqY4LJ8ZIVu8yBj2GZpjHT0zJkK7+wEZXbUke6z8p64DFQ=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hg5IU-0007kw-1M; Wed, 26 Jun 2019 10:37:02 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 785F4440046; Wed, 26 Jun 2019 11:37:01 +0100 (BST)
Date:   Wed, 26 Jun 2019 11:37:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 5.1 08/51] ASoC: core: lock client_mutex while
 removing link components
Message-ID: <20190626103701.GT5316@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GqkYCIxWRddlF0H7"
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-8-sashal@kernel.org>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GqkYCIxWRddlF0H7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 11:40:24PM -0400, Sasha Levin wrote:
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>=20
> [ Upstream commit 34ac3c3eb8f0c07252ceddf0a22dd240e5c91ccb ]
>=20
> Removing link components results in topology unloading. So,
> acquire the client_mutex before removing components in
> soc_remove_link_components. This will prevent the lockdep warning
> seen when dai links are removed during topology removal.

There's additional fixes for this IIRC.

--GqkYCIxWRddlF0H7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0TSswACgkQJNaLcl1U
h9AsLgf8D+/v0nq2yD+Y60a1KDcgtaDiv+d79o/qTa89Ar7Inuu4hoWyWQjT1j7D
6g2cEUat0w+aHPVYWVi5FfnVMFwncJU687szqy3JO2fFVRK3Md7keFdrg/z89Tri
/00P/XZdgBBx3P3SySa1YCFaH/g8iKqk60anmfxBhzrkIrrpkrhAoxzYRAtjkU8O
zpi21KZFycdBKxh0wcvG9snEUPsgn0gnkgQF3EV+NigFoFxC/pA9m4UZDs/MzZFh
HEsTvRsEWSpWAmVc4QW41JsLcSfTSnfXCyUr3dWhSp+CgoaEZcwCG97HfCT3K3Ai
U42ZovNFkAjdC7w2pildmIenUvrCcQ==
=2YJo
-----END PGP SIGNATURE-----

--GqkYCIxWRddlF0H7--
