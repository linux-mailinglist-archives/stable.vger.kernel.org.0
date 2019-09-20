Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29AB9497
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 17:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404191AbfITPyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 11:54:07 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41898 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404671AbfITPyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 11:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zLDrH1bjiD0FaVml2s6dPvH5HKK+NUEXFEsWfY1kDG8=; b=wgkf1wLSxZsRbDLbrQvjuR0V1
        VqsQPFVu3UU+r6FlfgdK9st2Wglyrogw9fAxJhZXA5aC0+kvs81kFNrg/tTrdeM+fRgHq4sNGLVSf
        AMVw21lXO5cyePhrCH2h4+tEW8D6uSGyac+KlQZi0WU++YjX/TUFVtUwNmwIZ+3S0eGhQ=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iBLEQ-0002uH-1M; Fri, 20 Sep 2019 15:54:02 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 30BB8274293F; Fri, 20 Sep 2019 16:54:01 +0100 (BST)
Date:   Fri, 20 Sep 2019 16:54:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: atmel: Fix crash when using more than 4 gpio CS
Message-ID: <20190920155400.GH3822@sirena.co.uk>
References: <20190919153847.7179-1-gregory.clement@bootlin.com>
 <20190919160315.GQ3642@sirena.co.uk>
 <20190919172350.GZ21254@piout.net>
 <20190920105101.GA3822@sirena.co.uk>
 <87a7az7zt6.fsf@FE-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nFBW6CQlri5Qm8JQ"
Content-Disposition: inline
In-Reply-To: <87a7az7zt6.fsf@FE-laptop>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFBW6CQlri5Qm8JQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2019 at 05:27:49PM +0200, Gregory CLEMENT wrote:

> But after going further in the details of the driver, this patch could
> cause a regression for on the old controllers.

> I also found other issues in this driver in the chip select
> management. So I will send a new series fixing all of it.

OK, great - glad at least one of us spotted a real problem!

--nFBW6CQlri5Qm8JQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2E9hgACgkQJNaLcl1U
h9DuOQf/d1YSSM95RC3kUN0e8uki1dRX6P/DzkwsU8aq/UjqRJWFqJfINJoq/iX2
Bxv2so1RItyHhc7DeDbguqZd3q7ZoGEIdpydEs0YiCe0ZsIC2WO5oQYbzR+StoUP
Go9tnNJxG00tYTUoOLSkuFt0oF28j6+IiBOqU028GK0CcCpEY5gK6bdLrO3Yg/bp
x7dnew+UZGVIqBygo6Gf4o781L0aV9exnr8toNx2meSItYSd53qBOywiLt+olUPB
i1y7ZIBMFvM/CADLLfgT8u+3bu8q6tVFs7olDfPXfiSqWC9tOzur/x3aDfY4CdQz
8iOeWl80Sr4wXQgZWxBJGWp6Gz1JHA==
=vx4t
-----END PGP SIGNATURE-----

--nFBW6CQlri5Qm8JQ--
