Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608A7B8EC3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 13:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438136AbfITLCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 07:02:15 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:59282 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438135AbfITLCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 07:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TvSJPXCNUj0sKtwLV+ZZRK3DKaY/Th/BDTAKK7SPRmI=; b=tFnaNCfFVD5quhenDzNWlPLBG
        H1xR7Ud+5LuOoeOUM1tufkeG1zX+z7B13lZOVDrq0n/h50BtlvgUZbCNfLo71wEfUnHvJylKDJnKH
        JVPaH2d6OIxUuxi3/Y8tZob3xE5cXJnuxTmfZ2uYN9+5Thph8DtRipWc/HVyLQ27OCZPc=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iBGfv-0001bE-Nx; Fri, 20 Sep 2019 11:02:07 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id D53BD274293C; Fri, 20 Sep 2019 12:02:06 +0100 (BST)
Date:   Fri, 20 Sep 2019 12:02:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mason Yang <masonccyang@mxic.com.tw>,
        Julien Su <juliensu@mxic.com.tw>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] spi: mxic: Fix transmit path
Message-ID: <20190920110206.GC3822@sirena.co.uk>
References: <20190919202504.9619-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <20190919202504.9619-1-miquel.raynal@bootlin.com>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2019 at 10:25:01PM +0200, Miquel Raynal wrote:
> In certain circumstances, it is needed to check INT_TX_EMPTY and
> INT_RX_NOT_EMPTY in the transmit path, not only in the receive
> path. In both cases, the delay penalty is negligible.

In which circumstances and why is this required?

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2Esa0ACgkQJNaLcl1U
h9AgbAf/WGzhQIKCPqtpT234KXwcBHp9ZJZEvag3OQYnGwCZ2HTkbFi2GxY82UT4
FnSIj9o6IaTk1y4lFcXSoVfYJFm6ik+CksaPPCOKp/yX6Wdh+zcszod8nYGb9MDH
8JodKY8SteqX+PB9bxuZzip9vNkX6VaS+4ZA7Z/y+645Jmjo8FS1Yk83J/H87FJg
FroH17yf9TsGUgggStqTfz10e7sT17uPFpF6e3s/rGU3GVYqaYgtQS65vM2ARXbR
1OLvYa+4ogLGFE/JfxVFbyHDUQa7dQKZ/3fxlEXN4huhVJ9vRR0kPztathlfdX46
3TqFUQ7tJLD/tzeEt7hfU6OMdItB0A==
=717f
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
