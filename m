Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04C7318F0B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhBKPol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhBKPmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:42:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DAD64E95;
        Thu, 11 Feb 2021 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613058074;
        bh=4buKxeO2cWeF9EKIk1Oq6mWcOvZWGPa916QlK1XW5Os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yj1wRxUC2ZpHUKleyA6dab5ziYZM3LG0ZTKiVwyyVSwamqDavEbrWoBrxH9/o9Hsr
         4pAZL7/c/TyM5wOAPATbO9Jh/XIKFSu0RBKOjolyK3NtTtpm+S8sm0IJtPhTcy3ebF
         R2tVdQv3GKZej0ubsZsDOYiJ1eDWn0NYwZQggPfBy0OSE04kyKi3c56GI8/SMFNtLE
         OyB8xQzcLvdGtw0RdhkwFUnNT22Zve9OTLmZ2E1BJjYhT7D6p1HEmf10NC0ZrkZwNU
         okFIwjPMlnaCS3EX+SQDmCC3gYm2wxLHpaNUBpGZOJiVU5kLzjd5xk/XNg0n3x8Sb4
         gOEHIqwY7uxiA==
Date:   Thu, 11 Feb 2021 15:40:21 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 07/24] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210211154021.GE5217@sirena.org.uk>
References: <20210211150147.743660073@linuxfoundation.org>
 <20210211150148.069380965@linuxfoundation.org>
 <20210211152656.GD5217@sirena.org.uk>
 <YCVPYEgCIbqDRYLa@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <YCVPYEgCIbqDRYLa@kroah.com>
X-Cookie: Do not pick the flowers.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 11, 2021 at 04:38:08PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 11, 2021 at 03:26:56PM +0000, Mark Brown wrote:

> > > The final step in regulator_register() is to call
> > > regulator_resolve_supply() for each registered regulator

> > This is buggy without a followup which doesn't seem to have been
> > backported here.

> Would that be 14a71d509ac8 ("regulator: Fix lockdep warning resolving
> supplies")?  Looks like it made it into the 5.4.y and 5.10.y queues, but
> not 4.19.y.

Yes, that's the one.

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAlT+QACgkQJNaLcl1U
h9CwOAf/by0ynXegA8iZtKpqli6cMZKDZpzq2NyEeDRfqDzIq5iG1Cceu0o+Y1ky
mYppnS95bpPbNdo9Bwq2/Nrg+sVgLjw3XYXl63k+8kdPuQJLxwHZQY18n+/xSPQZ
JpvKbMF48EHHCvgtM7mIJHiKPQa32SNIH9nsuuvPS3qpG14s7ZKc/uqe3jRURjz6
yRewW8YEi1CJ01oaX29GiCM3PO0R8I4Y/8OABsW7iwsCpe8HVGYusHm/0tzDJJzj
4aRJzBDZG3SgtxpYK+4PJpq8gHJ1mmCsbhP1gIXj2kdxWZxYIbMD8NMWmz/hK8FA
drPHZqBthxf/LccbI5q78VJXhOpWmQ==
=wI+O
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
