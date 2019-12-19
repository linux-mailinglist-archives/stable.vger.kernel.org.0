Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C895C126E37
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfLSTvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:51:19 -0500
Received: from foss.arm.com ([217.140.110.172]:43628 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfLSTvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 14:51:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF12B1FB;
        Thu, 19 Dec 2019 11:51:18 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C61C3F67D;
        Thu, 19 Dec 2019 11:51:18 -0800 (PST)
Date:   Thu, 19 Dec 2019 19:51:16 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.4 177/350] regulator: fixed: add off-on-delay
Message-ID: <20191219195116.GI5047@sirena.org.uk>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-138-sashal@kernel.org>
 <20191211105934.GB3870@sirena.org.uk>
 <20191219194012.GP17708@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4BlIp4fARb6QCoOq"
Content-Disposition: inline
In-Reply-To: <20191219194012.GP17708@sasha-vm>
X-Cookie: I smell a RANCID CORN DOG!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4BlIp4fARb6QCoOq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2019 at 02:40:12PM -0500, Sasha Levin wrote:
> On Wed, Dec 11, 2019 at 10:59:34AM +0000, Mark Brown wrote:
> > On Tue, Dec 10, 2019 at 04:04:42PM -0500, Sasha Levin wrote:

> > > Depends on board design, the gpio controlling regulator may
> > > connects with a big capacitance. When need off, it takes some time
> > > to let the regulator to be truly off. If not add enough delay, the
> > > regulator might have always been on, so introduce off-on-delay to
> > > handle such case.

> > This is clearly adding a new feature and doesn't include the matching DT
> > binding addition for that new feature.

> This new "feature" fixes a bug, no? Should we take the DT bindings as
> well?

This new feature enables support for new hardware which would not
otherwise be supported if someone also updates the DT for the system.
Most features are on some level a bugfix for the lack of whatever the
feature is, this is on a similar level to adding a new device driver
(some device drivers are about as complex!).  It's a good change but it
doesn't seem to fit into what stable is supposed to be doing.

If you are backporting features that need new DT bindings then yes, you
should be backporting the bindings as well but that's a pretty good
indication that it's adding a feature.

--4BlIp4fARb6QCoOq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl371LQACgkQJNaLcl1U
h9AEUQf/Vb0ua5Fshs7qlXdH3zFMjMfcDEAUQm7UkfQk3AOKUbm//XKgVbpKeGGq
jtXGr++AJOzIpioXiiqQvOW5nhfCuvM4t1YWWUCrVb5qR/Z63siauE3AZMtpXfxZ
P9LcoGG2OIaP+HEmOXYfkqEvd46Ou6za5aI3lSKJd1qOBFIDoWyIxwriIxeuyGLA
vmpzTUJNS6Z3YamfS/FonHuSYN79wlEbdOI7MRhoYEQIEsdmrRiFqppdFxhFSlCB
zmUy8PjNJZCHaa6+J8jWnVYVe35JDUxkjRWmhsi42IIoO8uQVdC577ia0rN7mJ5G
tuwpFhs+zt9d1ExXF4VNQUaA5LMcqg==
=+GqG
-----END PGP SIGNATURE-----

--4BlIp4fARb6QCoOq--
