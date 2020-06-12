Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2968F1F7647
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 11:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgFLJ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 05:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgFLJ4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 05:56:07 -0400
Received: from localhost (p54b33104.dip0.t-ipconnect.de [84.179.49.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9FB2081A;
        Fri, 12 Jun 2020 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591955767;
        bh=vpHTuwUDM9a5LcIHJu50XcaJieuFQe7fiS+Dk2mMIpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2UEHK2tVpciOsv09SaQXib8V2ByKV+2ALo5gw8FS5anC2j7Tgy3jxXHPBhEomd90v
         YYxI1o+AFsEg9pGS4MB1Yq+QFS0Lc6M1xgapxTGgqjSEmPY8z/xi7//huR020ol5Li
         +7ubHZAWSfrptdS+gfVO3wyHzmZMeKaB+cWeBQvc=
Date:   Fri, 12 Jun 2020 11:56:04 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Gao Pan <b54642@freescale.com>,
        Fugang Duan <B38611@freescale.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612095604.GA17763@ninjato>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20200612092941.GA25990@pi3>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2020 at 11:29:41AM +0200, Krzysztof Kozlowski wrote:
> On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> >=20
> > That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> > SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
> > without fake injection, I assume?
>=20
> No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
> some debugging options already).

Interesting. Maybe probe was deferred and you got the extra irq when
deregistering?


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7jUTAACgkQFA3kzBSg
KbbntA//dAQo2Vc4X+lVKV4pApi36lY7bZa0XTJB1+2aZfBti0Twy0cQrN3vvaaQ
rc4sYXRkK/d1N5z95dj3eWcnmsUtel2Ac5neRuCCFY62y27uI24JJT7HKKXwXPkT
oFAxksVZ4cDnjrrtpeFSq5vWtqilA8s7m1bapaNS2B5kv7AtRD733NDXHNwec0Io
nCgN4hKMEY+JZFBhnQG3VfR+i/kuvg4zPd47bb+gc3eGHuXs4jGMb06EXuKmBbK/
VdjUuwqiO/gGhcFAqdsA1JA9eSbvFfEJndS9uAz9WfXQBtIO//is6jFp5e9kU8Gx
pmKCiiVUnO5BTLPreLSEqNDJeLAj17ksGj7nSAdxujjXeXLM68j6FZJRytOZLFdG
o6KSO2QSbPEBGJiArJQj6s7i7GOP5pjPaEb+6x8ldV9hBkeAmsscFD92OiWHSgM6
rs1NX9s3/64cN0yWl2R0UActscJTQWMntBLiwBXoOU+Pjjh2dZU0ju0+diUjfgA4
/i714f+DaPkgC+HcTpzpmV9xmDCEGhLV6DJyJkbUHKknDLQ5e5rXxkGAeRWn1cCV
1UcrBB8YZR/YSJj5FO7T340Fg5kXAAtzZF5qIOSSjmD0cdadtHZNezhbL6jJfiJ2
seyWQ80gCrbSGVW3DH4sgm+CUDnVvCN33gMa50NmsZ0gPC2F3HA=
=r8jc
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
