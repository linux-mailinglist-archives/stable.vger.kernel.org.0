Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002DC3AE75D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFUKnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFUKnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 06:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F5A61153;
        Mon, 21 Jun 2021 10:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624272064;
        bh=UbCcZm9yRxkuaU4xQLxn8nCsaydZD6ZzKtQxMT/YMLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+U2tLKYUHdlHLeSjqpjrxf9kXOylOkCNYdCYAkIY4ljKQSACv7cVTNKIW0q5kLR+
         Hqf9iMMu/c+w8m1ur2Lznh3zuJZMzGLMTDV+SgYNhI3U4ODLCccbuuzFuzHcg9wBFY
         Z2MLwGijFyzv6NuaqHk9xi/h0didjoIO5avK0dtsoF3RpaIJaSRNjhVDza9u4YQOYI
         mbiqlPI1Ndga2zg7wSTZJrFlxD5RLUC/9+atcXfZSpsoto3uDUiCwQzn/QTN+bb0En
         NnPRnsW2raQmvQb5HZLiBmsYMqk0G+BPjpRj8by0uBu7YZNsur5m31IFeIENWtsjFH
         6hZFEFPzI8YBQ==
Date:   Mon, 21 Jun 2021 11:40:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.12 02/33] regulator: max77620: Silence deferred
 probe error
Message-ID: <20210621104042.GB4094@sirena.org.uk>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-2-sashal@kernel.org>
 <20210615155436.GM5149@sirena.org.uk>
 <YM8633R356GXEwoR@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <YM8633R356GXEwoR@sashalap>
X-Cookie: I hate dying.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 20, 2021 at 08:55:59AM -0400, Sasha Levin wrote:
> On Tue, Jun 15, 2021 at 04:54:36PM +0100, Mark Brown wrote:
> > On Tue, Jun 15, 2021 at 11:47:53AM -0400, Sasha Levin wrote:
> > > From: Dmitry Osipenko <digetx@gmail.com>

> > > One of previous changes to regulator core causes PMIC regulators to
> > > re-probe until supply regulator is registered. Silence noisy error
> > > message about the deferred probe.

> > This really doesn't look like stable material...

> Not strictly, but we usually take fixes to issues that can confuse users
> or spam logs.

I really don't think this is appropriate (and don't know that it's even
relevant without the core change mentioned in the commit log).

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDQbKkACgkQJNaLcl1U
h9BQTgf+KepvwkW0eqqj1vAPw0OMvyj5s0LXy/zfgoLXNI+n5VI3c+HTZpb/fxSj
muFuWhx6qTO0OmTCeEc0M+oiMgkB9Is5VFJsps9wxGXhIemMu/rXEXeJkDt2G6UA
3fJ6aXneDSfFJaPFcuYwBxHpyxgKn5NDFm8pbtXyXgFObatSwUhR3s5XQNAKTcCj
a1rjmElXPT/o0GaucBXbvfnFewGa6h9XDd9d7mmhiRKz7IkTnEu2I1bsc7cMQCGR
U5SO6tFE5nJJgg2yA4LAkVeWVYP0BvO6je8zeLouS6jAKLqiUotDdHrzRPt/dG7s
fVM3PcefuLlRmUTNwKZ5WJWVUwqYYg==
=yxVY
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
