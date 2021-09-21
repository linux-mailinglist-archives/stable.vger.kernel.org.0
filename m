Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70C413CDA
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 23:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhIUVq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 17:46:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47744 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhIUVq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 17:46:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B61881C0B76; Tue, 21 Sep 2021 23:45:28 +0200 (CEST)
Date:   Tue, 21 Sep 2021 23:45:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <20210921214528.GA30221@duo.ucw.cz>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
 <20210921212837.GA29170@duo.ucw.cz>
 <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver=
 broke
> > > when moving the incorrect handling of mac link state out of mac_confi=
g().
> > > This reason this breaks is because the stmmac's WoL is handled by the=
 MAC
> > > rather than the PHY, and phylink doesn't cater for that scenario.
> > >=20
> > > This patch adds the necessary phylink code to handle suspend/resume e=
vents
> > > according to whether the MAC still needs a valid link or not. This is=
 the
> > > barest minimum for this support.
> >=20
> > This adds functions that end up being unused in 5.10. AFAICT we do not
> > need this in 5.10.
>=20
> It needs to be backported to any kernel that also has
> "net: stmmac: fix MAC not working when system resume back with WoL active"
> backported to. From what I can tell, the fixes line in that commit
> refers to a commit (46f69ded988d) in v5.7-rc1.
>=20
> If "net: stmmac: fix MAC not working when system resume back with WoL
> active" is not being backported to 5.10, then there is no need to
> backport this patch.

Agreed.

> As I'm not being copied on the stmmac commit, I've no idea which kernels
> this patch should be backported to.

AFAICT "net: stmmac: fix MAC not working when..." is not queued for
5.10.68-rc1 or 5.14.7-rc1.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUpSeAAKCRAw5/Bqldv6
8jTBAJ0TGvDkLjp0bJitWGss9PANDf6zTACffzoV1Z+/5OQQBKIXKsSiXBthCMg=
=YGOO
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
