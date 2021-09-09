Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03840569D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352884AbhIINUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357723AbhIINPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C472F61051;
        Thu,  9 Sep 2021 13:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631192727;
        bh=nzbSQqsPS5FcwzRSALz3d74l1Nj0HIR4mATqTsW+N68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PFOpPWYY9dyEvy3fwZeTSNhsetGczhzX8WirNeICmuj3QyY0hQe3oq6njlMJr4sJv
         rngIuwSqLv5IisBtMjsbmdG9EYpptVO1y6g/r/Ql68xaZwIT3l8HrsaYpkWzp0p/Zq
         BQ3eYjfvmU7c2TEY142j1a09uAmBnj4EG0SfqWtlDkoDpvgd17d4Bb0kviH6N8Fsrv
         2WHQ09JixxBWO/YrwJGJtusBjXsp4rDPcKj/UGlXjLCe1G2tH6n4HWoRlTqRLTO3Yx
         oN+GuKnawQjYmhYtBGDjpZGA3VnXGdwGdUpC4u4ZlEctbfDHqZ828ZIF4q1o4zZdiM
         49X4cHTDUQQ9g==
Date:   Thu, 9 Sep 2021 14:04:50 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 133/252] spi: tegra20-slink: Improve runtime
 PM usage
Message-ID: <20210909130450.GB5176@sirena.org.uk>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-133-sashal@kernel.org>
 <20210909123751.GA5176@sirena.org.uk>
 <f75c5c9c-8430-f650-5d0a-3490ac6aa3de@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <f75c5c9c-8430-f650-5d0a-3490ac6aa3de@gmail.com>
X-Cookie: I have become me without my consent.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 09, 2021 at 03:45:45PM +0300, Dmitry Osipenko wrote:
> 09.09.2021 15:37, Mark Brown =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> > This feels new featureish to me - it'll give you runtime PM where
> > previously there was none.

> Apparently all patches which have a word 'fix' in commit message are
> auto-selected. I agree that it's better not to port this patch.

Yeah, it's a fairly common source of false positives :/

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE6BnEACgkQJNaLcl1U
h9Cdrgf9E78HM3YH3HOA9i4ZNOnPUQjItYOxxsBBBniZXXz5oIpT9MVSFkNL9mXD
4440XtsdeGNpdZyoiFPmkUQzUvpLymgvRbcEkh+aTODZvb6ZeLhU+GJBs2Ua0Q0w
yNfV29Kp7sfi9rKLE7s+8Xm1N3ODy11i4zn2LmmWFsH+ImB5+CWdw2wXqYJLo0c8
yhSqpszFYf/OhkUt16wR72lGVUPymHEGao8sd42X8tPf2dLH3rHZxdc1zSWhdcjT
W53YcSMcPIqanpGa23LKQS2Ut6TtCoUlfvsR3x6bTVCRSS1+a0xlc8xdD4GikFHp
w1JOxc50IcCGugd55WOrqdnsf9t6DA==
=6meK
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
