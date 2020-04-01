Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FFC19B517
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbgDASHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 14:07:24 -0400
Received: from foss.arm.com ([217.140.110.172]:58332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732121AbgDASHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 14:07:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1EC41FB;
        Wed,  1 Apr 2020 11:07:23 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 759483F52E;
        Wed,  1 Apr 2020 11:07:23 -0700 (PDT)
Date:   Wed, 1 Apr 2020 19:07:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Amit Kachhap <Amit.Kachhap@arm.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: Always force a branch protection mode when the
 compiler has one
Message-ID: <20200401180721.GG4943@sirena.org.uk>
References: <20200331194459.54740-1-broonie@kernel.org>
 <20200401175444.GF9434@mbp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20200401175444.GF9434@mbp>
X-Cookie: The Ranger isn't gonna like it, Yogi.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 01, 2020 at 06:54:44PM +0100, Catalin Marinas wrote:
> On Tue, Mar 31, 2020 at 08:44:59PM +0100, Mark Brown wrote:
> > Compilers with branch protection support can be configured to enable it by
> > default, it is likely that distributions will do this as part of deploying
> > branch protection system wide. As well as the slight overhead from having
> > some extra NOPs for unused branch protection features this can cause more
> > serious problems when the kernel is providing pointer authentication to
> > userspace but not built for pointer authentication itself.

> With 5.7 you won't be able to configure user and kernel PAC support
> independently. So, I guess that's something only for prior kernel
> versions.

Yes, it's really for the benefit of stable at this point - hence the Cc.
Going forward it's hopefully more for defensiveness than anything else,
it's possible something similar might come up with some future stuff but
ideally not.

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6E2FkACgkQJNaLcl1U
h9AvZAf4kcawmHf3KjTLz/Ml0UjkQlK6IiE5hl/jqyojdkmbqJ6vdmNYVpxdGRZv
jXhRkAf8jc6tuNYEJESXynxGqqygMkn46iMlBKpNRjNcs9niJoI5Xsc8cxczlyMD
RyPLCVtV0rGCXUbCqprcZc+0OvIXavtvAGPiOW+A1uoqKmBjY8EzJOheTJPCmGxj
3RgoWrHUHfDs9UnAlSleC9HdpI1o2x+H8T6pW8lw1jKwgx7O1kGSbv/EFXWcFfqT
wOGT+/QHawC2xC1GHO4hzOvq7Ao9pF4jBEAmZAxQVUgknxumFQJlSviubg8lGKxe
4jkQAXQgBy3YGWhzdW37lSBfpHaH
=5eIU
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
