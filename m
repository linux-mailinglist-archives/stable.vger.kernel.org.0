Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60A1ABD79
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 12:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504322AbgDPKDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 06:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504310AbgDPKC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 06:02:58 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4C82076A;
        Thu, 16 Apr 2020 10:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587031378;
        bh=0PYw1oIxICIVQhf6Df2ZyRpfOwqyaClwsDe/u+1KAtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJNoGqTlSjAJ8PnagsHa4yFy0YOfvnrc/0Q5XvB9gLPzAV0D0i/h+OUGwhXepeCb1
         ZYqJrwfEOEnyMmecP1V1mXuQ3+HxW/hYTX/T5e02ifHI9ZqbSRQ4Lchg5N+VLH3m/0
         DIrr8COjqU2q+IqLE9VmfTo4kqmQ0bk6CGych1R8=
Date:   Thu, 16 Apr 2020 11:02:55 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        szabolcs.nagy@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Always force a branch protection
 mode when the" failed to apply to 5.6-stable tree
Message-ID: <20200416100255.GC5354@sirena.org.uk>
References: <158694980415630@kroah.com>
 <20200416015121.GV1068@sasha-vm>
 <20200416083204.GA19241@gaia>
 <20200416093517.GA5354@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <20200416093517.GA5354@sirena.org.uk>
X-Cookie: Tempt me with a spoon!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 16, 2020 at 10:35:17AM +0100, Mark Brown wrote:
> On Thu, Apr 16, 2020 at 09:32:05AM +0100, Catalin Marinas wrote:
> > On Wed, Apr 15, 2020 at 09:51:21PM -0400, Sasha Levin wrote:

> > > I don't think that this is needed anywhere without 74afda4016a7 ("arm64:
> > > compile the kernel with ptrauth return address signing")?

> > Good point. Mark, is the Fixes line above correct or it should have been
> > the one Sasha mentions?

> Yes, Sasha's is right.

Actually, no - we do need a version of the fix for older versions prior
to the kernel having pointer auth support since the goal was to ensure
that the kernel doesn't actually get built with pointer auth when we are
doing it for userspace as that leaves us with half baked pointer auth in
the code.  The original fixes was right and we want a redone backport.

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6YLU4ACgkQJNaLcl1U
h9DjtAf/cmJpPsTWlvwKZIqw49Nz1LXaXEstMQEh8Bc6UQ1VJPwyMdKVK8IJXkS/
1a/wQxO7q0Rzk+sqzljdXYk0bCc4c5XaofGkSGvXw5It/yYqJRaT1wVbrOsu70cm
5c0oqFUCHM531DADtWe7KsqVg9Fpile7V32IetGUgsI3JNJ63myQaqLW+5KqbzWa
pcVHfzOsFwdmUN7k8iDGEYzQjZZieWi2jDEJHUUir2kOqdvppIHrugG68ETmnkFA
xDNmN1wFiwOGWvSEdQOi0pI42Vnhh5UelrB62mLtUlRPjMJoebz+X2kyIzEAT53i
YIiFc4+NZkVKKTD3Q0fpfRk2Eo9fLg==
=hOxk
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
