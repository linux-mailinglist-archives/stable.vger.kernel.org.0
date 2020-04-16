Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6591ABCE7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 11:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503814AbgDPJfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 05:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503615AbgDPJfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 05:35:20 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E1A21BE5;
        Thu, 16 Apr 2020 09:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587029720;
        bh=NQ5/lPTdX2gpOrtrULduRpmOlE6dr1GpQbMmIFdGoY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILbirrdeWJRkENmXJlgUtCIGhDOx/tLRCAQS86e89/CbxW6+Uhk+1omlRhq33cnEz
         bRjv1QNF/byBELs7/6Z7THTtvta+hRLXaX76sGNDxgV6SBOZGezUHd0b5Oaeil1yTL
         NvKm/nCw5Yu2bQtAc1zEE50hdBajZLrpBbe+DnJo=
Date:   Thu, 16 Apr 2020 10:35:17 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        szabolcs.nagy@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Always force a branch protection
 mode when the" failed to apply to 5.6-stable tree
Message-ID: <20200416093517.GA5354@sirena.org.uk>
References: <158694980415630@kroah.com>
 <20200416015121.GV1068@sasha-vm>
 <20200416083204.GA19241@gaia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20200416083204.GA19241@gaia>
X-Cookie: Tempt me with a spoon!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 16, 2020 at 09:32:05AM +0100, Catalin Marinas wrote:
> On Wed, Apr 15, 2020 at 09:51:21PM -0400, Sasha Levin wrote:

> > I don't think that this is needed anywhere without 74afda4016a7 ("arm64:
> > compile the kernel with ptrauth return address signing")?

> Good point. Mark, is the Fixes line above correct or it should have been
> the one Sasha mentions?

Yes, Sasha's is right.

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6YJtEACgkQJNaLcl1U
h9BZowf8C5PWRq8sYgUKKvOseG3c7FbEZU+CtrrKcoiwjsaLzWUb/iMH4bI6Vh09
C4PhKjtx0tq5dMlHX7QqJonPiBv4XDV1MGL2+OshmU0MPvoOQ6KVlspO3lHTLNoG
x3oUq6ggHxnU+U0FpmCqx5pSp61cNQSLxpswnSteFUAPvw4SCbIXy+lc6r4aI4VW
fCP+UWjtxQLN6/0o/I20u87Ufqz9qcIDqtmBbxzu9mUmEsCSajvi1U3GCXgYYISH
xf5BzEJzArgQ5MUvC+uZ3LF/ShKwcEQXyvCA1LoWsZ9qjQ0XPlp9zrM/b7clLsdg
KqtWXwV8U0rTOzjow6iTFT9D8DblwA==
=nyv2
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
