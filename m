Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF309E641
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfH0LAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 07:00:18 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47686 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0LAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 07:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mABMcH5HUXQ/Q6YWOuJJcz06DxftCmdBtzVd6s8/bVM=; b=Jyx10YUPIHl82g2sCLZ/LBjuK
        /bSPXp6iUhxDqwZxRw3AmFM7lCYg9rZCjWZ6JqbQmyjUo9VqXfg3sLC5nZakJVHypmPVbiEEuKsbM
        h8QWektPPpSPoXOCEWtY9NJc58XYSIWEuZBDiRAg7qB/nyrsU1ysipqPuy+/4t5kK1O5g=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i2ZCw-0007wq-RE; Tue, 27 Aug 2019 11:00:14 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 71A09D02CE6; Tue, 27 Aug 2019 12:00:14 +0100 (BST)
Date:   Tue, 27 Aug 2019 12:00:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Ricard Wanderlof <ricardw@axis.com>
Subject: Re: [PATCH AUTOSEL 5.2 040/123] ASoC: Fail card instantiation if DAI
 format setup fails
Message-ID: <20190827110014.GD23391@sirena.co.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
 <20190814092213.GC4640@sirena.co.uk>
 <20190826013515.GG5281@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ofQ+NWZjH2FySEVi"
Content-Disposition: inline
In-Reply-To: <20190826013515.GG5281@sasha-vm>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ofQ+NWZjH2FySEVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 25, 2019 at 09:35:15PM -0400, Sasha Levin wrote:
> On Wed, Aug 14, 2019 at 10:22:13AM +0100, Mark Brown wrote:

> > > If the DAI format setup fails, there is no valid communication format
> > > between CPU and CODEC, so fail card instantiation, rather than continue
> > > with a card that will most likely not function properly.

> > This is another one where if nobody noticed a problem already and things
> > just happened to be working this might break things, it's vanishingly
> > unlikely to fix anything that was broken.

> Same as the other patch: this patch suggests it fixes a real bug, and if
> this patch is broken let's fix it.

If anyone ran into this on the older kernel and fixed or worked
around it locally there's a reasonable chance this will then
break what they're doing.  The patch itself is perfectly fine but
that doesn't mean the rest of the changes it's being backported
into are also fine.

--ofQ+NWZjH2FySEVi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1lDT0ACgkQJNaLcl1U
h9BjVAf/boHZSbqg/5cIB1wL6zlEEE8r9u8Iz9v1u3dB2EpNj81ARXzDX1EjPwU3
TE930t5hNdqrttap4ejbM7ndJFps7UxtNjQ/cjwAGgSndl04wdrAePhmGp4m+ZBj
0nABy4K9WXedeEl5LrpafxYHymGZBceNPg8ZyJNrFcuC7US6zgPvbdgt3Medp98X
yp0mprlLwb/0rrdWB/8ZO9XRagC2AOkpqWHKJ9tDl09Bab1AlSipdX6E/vA7fuEG
YYbsPoGx4uKkuhxxZ+bvylbB5PqwQndoy3OTFHmGrJZjmSoJaz8Qs57pRrh+EE30
D+6QDIkvBcg0YjTvppWXYDwqkcLrrw==
=wi+f
-----END PGP SIGNATURE-----

--ofQ+NWZjH2FySEVi--
