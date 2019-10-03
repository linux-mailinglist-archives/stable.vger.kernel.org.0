Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A515CAE3F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbfJCSeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:34:13 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42758 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729993AbfJCSeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 14:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l7lg82rRQaQDVfeOcm7Rfr/SwqkkoNP3HHRQDP2RzwA=; b=rdHcT+kn7cFovw6rm0OfSTKCS
        KDwDt+68dvvvK0nEwAp1CE5O0vibScB+1y5mauwSu7U9vyyN0snsFE6rnXamMw81w5ovB2KRSgE1F
        Ms9pOKjNeCi75rnVVNfYuXCApsQcZ0F4DkAxfVK3RuJSKOwVLgQTEFG+c1Uk7zZpCSy8A=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iG5vQ-0006CL-C9; Thu, 03 Oct 2019 18:34:04 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 837CD2740210; Thu,  3 Oct 2019 19:34:03 +0100 (BST)
Date:   Thu, 3 Oct 2019 19:34:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Libin Yang <libin.yang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.3 039/344] ASoC: SOF: Intel: hda: Make hdac_device
 device-managed
Message-ID: <20191003183403.GD6090@sirena.co.uk>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191003154543.920067214@linuxfoundation.org>
 <20191003172617.GA6090@sirena.co.uk>
 <20191003181937.GC3457141@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Content-Disposition: inline
In-Reply-To: <20191003181937.GC3457141@kroah.com>
X-Cookie: Reactor error - core dumped!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2019 at 08:19:37PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 03, 2019 at 06:26:17PM +0100, Mark Brown wrote:
> > On Thu, Oct 03, 2019 at 05:50:04PM +0200, Greg Kroah-Hartman wrote:

> > > Signed-off-by: Libin Yang <libin.yang@intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Reviewed-by: Takashi Iwai <tiwai@suse.de>
> > > Link: https://lore.kernel.org/r/20190626070450.7229-1-ranjani.sridharan@linux.intel.com
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---

> > Looks like you're missing your own signoff on this (and quite a few of
> > the others)?

> Sasha signs off on these, I didn't, as he is the one that queues them
> up.

It seems off when they go out as e-mail with you as the sender - it'll
be OK in git if he's the committer of course but it's weird here.

--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2WPxoACgkQJNaLcl1U
h9AxNwf+I1RACj7QAv9TLm9jlzO6uYlsr+zdnMrG+0ZOunWrliY1KLheoRB6M0xi
mDqEJNimfEyhB4TddvIehWrbEA64IBq78XefzDknQnbyI/m/v6Lsd8F9ZWf9tbSQ
sxwN4eh66bPap7YmACtltDh7TV0QVdo8u+y1zzVczQ/UBYUFDN+sfCfxBDL1GtAo
w+AG6SBVAwl4pYBLwzB5DMpnk6s2MJOi1x9icmoBf/6jv4uGlUjDJN0DxGI8WMcE
5K97j3661Y1IPLp9sBnXr4dJxd0u88b2qYTyoIuohv6ZCAjCh5ZXLh6mF0zOztW6
PociXsKyM44Ze2Bp3P1docJMulodZA==
=k2RV
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
